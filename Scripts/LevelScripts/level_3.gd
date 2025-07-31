extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var player: CharacterBody2D = $"../Player"
@onready var appear_door: AnimationPlayer = $"../Walls/AppearDoor"
@onready var pause_menu: CanvasLayer = $"../LevelCamera/CanvasLayer2"
@onready var intro: AudioStreamPlayer2D = $"../VoiceLines/Intro"
@onready var intro_skip: AudioStreamPlayer2D = $"../VoiceLines/Intro - skip"
@onready var instruction_1: AudioStreamPlayer2D = $"../VoiceLines/Instruction1"
@onready var instruction_1_skipfull: AudioStreamPlayer2D = $"../VoiceLines/Instruction1skipfull"
@onready var instruction_1_skippartial: AudioStreamPlayer2D = $"../VoiceLines/Instruction1skippartial"
@onready var instruction_1_pressed_button_already: AudioStreamPlayer2D = $"../VoiceLines/Instruction1PressedButtonAlready"
@onready var instruction_help: AudioStreamPlayer2D = $"../VoiceLines/InstructionHelp"
@onready var help_nevermind: AudioStreamPlayer2D = $"../VoiceLines/HelpNevermind"

var button_1_pressed: bool = false
var button_2_pressed: bool = false

var skipped_intro: bool = false
var pressed_white_button: bool = false
var can_increment_helper: bool = true
var failure_counter: int = 0
var has_helped: bool = false

func _ready() -> void:
	if WorldManager.level_3_pos != Vector2(0.0,0.0):
		player.position = WorldManager.level_3_pos
	if WorldManager.has_entered_sub:
		intro.stop()
	
func _input(event: InputEvent) -> void:
	if event.is_action("ui_cancel"):
		get_tree().paused = true
		pause_menu.visible = true
	
	if event.is_action_pressed("ui_jump"):
		if player.is_on_floor() or player.is_on_ceiling():
			player.oppose_gravity()
			if intro.playing:
				intro.stop()
				skipped_intro = true
				intro_skip.play()

func _on_pressure_plate_released() -> void:
	if button_1_pressed:
		return
	animation_player.play("Plat1_Hide")
	await get_tree().create_timer(.1).timeout
	can_increment_helper = false

func _on_pressure_plate_activated() -> void:
	if button_1_pressed:
		return
	animation_player.play("Plat1_Reveal")
	if instruction_1.playing:
		instruction_1.stop()
		if skipped_intro:
			instruction_1_skipfull.play()
		else:
			instruction_1_skippartial.play()
	pressed_white_button = true
	can_increment_helper = true
			
func _on_button_pressed_down() -> void:
	button_1_pressed = true
	if animation_player.is_playing():
		#animation_player.stop()
		animation_player.speed_scale = -1
		await get_tree().create_timer(1.5).timeout
		$MiddleNodeReveal/Show.play("MoveDown")
	if instruction_help.playing:
		instruction_help.stop()
		help_nevermind.play()

func _on_pressure_plate_2_activated() -> void:
	if button_2_pressed:
		return
	animation_player.speed_scale = 1
	animation_player.play("show_button")

func _on_pressure_plate_2_released() -> void:
	if button_2_pressed:
		return
	animation_player.play("hide_button")

func _on_button_2_pressed_down() -> void:
	button_2_pressed = true
	if animation_player.is_playing():
		#animation_player.stop()
		animation_player.speed_scale = -1
	appear_door.play("DoorUp")


func _on_hidden_level_body_entered(_body: Node2D) -> void:
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/Levels/Level_3_Sub.tscn")

func _on_door_middle_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		#get_tree().call_deferred("change_scene_to_file","res://Scenes/Levels/Demo_Complete.tscn")
		get_tree().call_deferred("change_scene_to_file","res://Scenes/Levels/Level_4.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_exit_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menu/Main Menu.tscn")

func _on_unstuck_pressed() -> void:
	pass#player.position = unstuck_position.position

func _on_resume_pressed() -> void:
	get_tree().paused = false
	pause_menu.visible = false

func _on_intro__skip_finished() -> void:
	if not pressed_white_button:
		instruction_1.play()
	else:
		instruction_1_pressed_button_already.play()

func _on_intro_finished() -> void:
	if not pressed_white_button:
		instruction_1.play()

func _on_helper_body_entered(body: Node2D) -> void:
	if body.name == "Player" and can_increment_helper:
		failure_counter += 1
	
	if failure_counter >= 3 and not has_helped:
		instruction_help.play()
		has_helped = true
