extends Node2D
@onready var no_skip: AudioStreamPlayer = $VoiceLines/NoSkip
@onready var partial_skip: AudioStreamPlayer = $VoiceLines/PartialSkip
@onready var full_skip: AudioStreamPlayer = $VoiceLines/FullSkip
@onready var level_1_elements: Node2D = $"../Level1Elements"
@onready var voice_lines: Node = $VoiceLines
@onready var player: CharacterBody2D = $"../Player"
@onready var level_camera: Camera2D = $"../LevelCamera"
@onready var teleport: Node2D = $"../Level1Elements/Teleport"
@onready var camera_position_initial: Node2D = $"../Level1Elements/CameraPositionInitial"
@onready var came_back_1: AudioStreamPlayer = $VoiceLines/CameBack1
@onready var came_back_2: AudioStreamPlayer = $VoiceLines/CameBack2
@onready var came_back_3: AudioStreamPlayer = $VoiceLines/CameBack3
@onready var came_back_4: AudioStreamPlayer = $VoiceLines/CameBack4
@onready var instructions_1: AudioStreamPlayer = $VoiceLines/Instructions1
@onready var praise: AudioStreamPlayer = $VoiceLines/Praise #Didnt skip intro dialouge, skipped intructions
@onready var disapline: AudioStreamPlayer = $VoiceLines/Disapline #Skipped intro dialouge, skipped instructions
@onready var button_press: AudioStreamPlayer = $VoiceLines/ButtonPress #Didnt or did skip dialouge, waited for instruction
@onready var move_flooring_down: AnimationPlayer = $Flooring1/MoveFlooringDown
@onready var invis_wall_collider: CollisionShape2D = $Inviswall/InvisWallCollider
@onready var appear_door: AnimationPlayer = $"../Walls/AppearDoor"
@onready var congrats_normal: AudioStreamPlayer = $VoiceLines/CongratsNormal
@onready var congrats_disapline: AudioStreamPlayer = $VoiceLines/CongratsDisapline
@onready var congrats_praise: AudioStreamPlayer = $VoiceLines/CongratsPraise
#Secret stuff shhhh
@onready var level_counter_label: Label = $LevelCounter/Control/Label
@onready var level_counter_secret: Label = $LevelCounter/Control/Secret


@onready var came_back_voicelines: Array = [
	came_back_1,
	came_back_2,
	came_back_3,
	came_back_4
]

var on_instructions: int = 1 #1 for first instruction, 2 for 2nd etc.
var pressed_button: bool = false
var times_pressed_button: int = 0
var ending: String

signal door_passage()

func _ready() -> void:
	level_1_elements.connect("door_passage", start_func)

func start_normal() -> void:
	if not WorldManager.completed_level1_explain:
		if WorldManager.intro_on_voicelines == 1:
			#Skipped over first dialouge
			full_skip.play()
			#full_skip.connect("finished", update_voiceline_state)
		elif WorldManager.intro_on_voicelines == 2:
			#Skipped second
			partial_skip.play()
			#partial_skip.connect("finished", update_voiceline_state)
		elif WorldManager.intro_on_voicelines == 3:
			#Skipped none - Gooood boooooy
			no_skip.play()

func update_voiceline_state() -> void:
	WorldManager.completed_level1_explain = true
	await get_tree().create_timer(.6).timeout
	instructions_1.play()
	move_flooring_down.play("playAnim")

func start_func() -> void:
	if WorldManager.times_gone_back_to_intro == 0: #First time entering from left.
		if WorldManager.intro_on_voicelines == 1:
			#Skipped over first dialouge
			full_skip.play()
			full_skip.connect("finished", update_voiceline_state)
		elif WorldManager.intro_on_voicelines == 2:
			#Skipped second
			partial_skip.play()
			partial_skip.connect("finished", update_voiceline_state)
		elif WorldManager.intro_on_voicelines == 3:
			#Skipped none - Gooood boooooy
			no_skip.play()
	else:
		if WorldManager.completed_level1_explain:
			print("Stopped, ", WorldManager.completed_level1_explain)
			return #No need to explain again.
		if WorldManager.times_gone_back_to_intro >= 1 and WorldManager.times_gone_back_to_intro <= 4:
			await get_tree().create_timer(.6).timeout
			came_back_voicelines[WorldManager.times_gone_back_to_intro-1].play()
			came_back_voicelines[WorldManager.times_gone_back_to_intro-1].connect("finished", start_normal)

func _on_door_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		door_passage.emit()
		player.position = teleport.position
		level_camera.position = camera_position_initial.position
		for e in voice_lines.get_children():
			if e.playing:
				e.stop()
		WorldManager.on_level = 0

func _on_no_skip_finished() -> void:
	WorldManager.completed_level1_explain = true
	await get_tree().create_timer(.6).timeout
	move_flooring_down.play("playAnim")
	instructions_1.play()

func _on_button_pressed_down() -> void:
	times_pressed_button += 1
	if times_pressed_button >= 12:
		level_counter_label.visible = false
		level_counter_secret.visible = true
	if not pressed_button:
		pressed_button = true
		if WorldManager.intro_on_voicelines == 1:
			if instructions_1.playing:
				instructions_1.stop()
				await get_tree().create_timer(.2).timeout
				disapline.play()
				ending = "bad"
			else:
				if WorldManager.intro_on_voicelines == 2:
					praise.play()
					ending = "praise"
				else:
					button_press.play()
					ending = "normal"
		else:
			if instructions_1.playing:
				instructions_1.stop()
				praise.play()
				ending = "praise"
			else:
				button_press.play()
				ending = "normal"
		appear_door.play("DoorUp")
		await get_tree().create_timer(1.5).timeout
		if ending == "normal":
			congrats_normal.play()
		elif ending == "bad":
			congrats_disapline.play()
		elif ending == "praise":
			congrats_praise.play()

func _on_move_flooring_down_animation_finished(_anim_name: StringName) -> void:
	invis_wall_collider.disabled = true

func _on_door_middle_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		get_tree().call_deferred("change_scene_to_file", "res://Scenes/Levels/Level_2.tscn")
