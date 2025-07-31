extends Node2D

@onready var level_camera: Camera2D = $"../LevelCamera"
@onready var floor_wall: ColorRect = $"../Floor/ColorRect"
@onready var player: CharacterBody2D = $"../Player"
@onready var painting_1: Node2D = $"../LevelCamera/Paintings/Painting1"
@onready var painting_2: Node2D = $"../LevelCamera/Paintings/Painting2"
@onready var painting_3: Node2D = $"../LevelCamera/Paintings/Painting3"
@onready var painting_4: Node2D = $"../LevelCamera/Paintings/Painting4"
@onready var painting_5: Node2D = $"../LevelCamera/Paintings/Painting5"
@onready var darkness_r: ColorRect = $DarknessR
@onready var darkness_l: ColorRect = $"../DarknessL"
@onready var door_closed: Node2D = $Door/Closed
@onready var door_open: Node2D = $Door/Open
@onready var door_collision: StaticBody2D = $Door/StaticBody2D
@onready var pause_menu: CanvasLayer = $"../LevelCamera/CanvasLayer2"
@onready var door_shut: AudioStreamPlayer2D = $"../sfx/DoorShut"
@onready var door_open_sfx: AudioStreamPlayer2D = $"../sfx/DoorOpen"
@onready var appear_door: AnimationPlayer = $"../Walls/AppearDoor"
@onready var red: ColorRect = $Door/Red
@onready var green: ColorRect = $Door/Green
@onready var forgot: AudioStreamPlayer2D = $"../Voicelines/Forgot"
@onready var hard: AudioStreamPlayer2D = $"../Voicelines/Hard"

var can_open_door1: bool = false
var opened_door: bool = false
var said_hard: bool = false

var lever1_pressed: bool = false
var lever2_pressed: bool = false
var lever3_pressed: bool = false
var lever4_pressed: bool = false
var lever5_pressed: bool = false

func _ready() -> void:
	
	darkness_l.visible = false
	darkness_r.visible = true

func check_state() -> void:
	print(lever1_pressed,lever2_pressed,lever3_pressed,lever4_pressed)
	if lever1_pressed and lever2_pressed and lever3_pressed and lever4_pressed:
		appear_door.play("DoorUp")

func _input(event: InputEvent) -> void:
	if event.is_action("ui_cancel"):
		get_tree().paused = true
		pause_menu.visible = true

func _physics_process(_delta):
	var global_pos = level_camera.global_position
	floor_wall.material.set_shader_parameter("world_offset",global_pos / 900.07)

func _process(_delta: float) -> void:
	level_camera.position.x = player.position.x

func _on_lever_powered(state: bool) -> void:
	can_open_door1 = state
	red.visible = false
	green.visible = true

func _on_door_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		if can_open_door1 and not opened_door:
			opened_door = true
			door_closed.visible = false
			door_open.visible = true
			darkness_r.visible = false
			door_collision.position.y -= 20
			door_open_sfx.play()
 
func _on_entered_room_body_entered(body: Node2D) -> void:
	if body.name == "Player" and door_open.visible:
		door_collision.position.y += 10
		darkness_l.visible = true
		door_closed.visible = true
		door_open.visible = false
		door_shut.play()
		if not lever2_pressed:
			forgot.play()

### Paintings

func _on_painting_1_area_body_entered(body: Node2D) -> void:
	if painting_1.visible:
		return
	if body.name == "Player":
		painting_1.visible = true

func _on_painting_1_area_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		painting_1.visible = false

func _on_painting_2_area_body_entered(body: Node2D) -> void:
	if painting_2.visible:
		return
	if body.name == "Player":
		painting_2.visible = true

func _on_painting_2_area_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		painting_2.visible = false
		
func _on_painting_3_area_body_entered(body: Node2D) -> void:
	if painting_3.visible:
		return
	if body.name == "Player":
		painting_3.visible = true

func _on_painting_3_area_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		painting_3.visible = false
		
func _on_painting_4_area_body_entered(body: Node2D) -> void:
	if painting_4.visible:
		return
	if body.name == "Player":
		painting_4.visible = true

func _on_painting_4_area_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		painting_4.visible = false
		
func _on_painting_5_area_body_entered(body: Node2D) -> void:
	if painting_5.visible:
		return
	if body.name == "Player":
		painting_5.visible = true

func _on_painting_5_area_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		painting_5.visible = false

### Lever puzzle

func _on_lever_puzzle_1_powered(state: bool) -> void:
	lever1_pressed = state
	check_state()

func _on_lever_puzzle_2_powered(state: bool) -> void:
	lever2_pressed = state
	check_state()

func _on_lever_puzzle_3_powered(state: bool) -> void:
	lever3_pressed = state
	check_state()
	
func _on_lever_puzzle_4_powered(state: bool) -> void:
	lever4_pressed = state
	check_state()
	if not said_hard:
		said_hard = true
		hard.play()

### Normal stuff again

func _on_resume_pressed() -> void:
	pause_menu.visible = false
	get_tree().paused = false

func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/Levels/Level_5.tscn")

func _on_exit_menu_pressed() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/Menu/Main Menu.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_door_middle_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		get_tree().call_deferred("change_scene_to_file", "res://Scenes/Levels/Level_6.tscn")
