extends Node2D

@onready var pause_menu: CanvasLayer = $"../LevelCamera/CanvasLayer2"
@onready var player: CharacterBody2D = $"../Player"
@onready var gravity_label: Label = $LevelCounter/Control/Label
@onready var painting_1: Node2D = $"../LevelCamera/Paintings/Painting1"
@onready var first_button_move: AnimationPlayer = $Button2/FirstButtonMove
@onready var first_pressure_move: AnimationPlayer = $PressurePlate/FirstPressureMove
@onready var door_red: ColorRect = $"../Door/Red"
@onready var door_green: ColorRect = $"../Door/Green"
@onready var painting_move: AnimationPlayer = $Painting2/PaintingMove
@onready var painting_2: Node2D = $"../LevelCamera/Paintings/Painting2"
@onready var closed: Node2D = $"../Door/Closed"
@onready var open: Node2D = $"../Door/Open"
@onready var static_body_2d: StaticBody2D = $"../Door/StaticBody2D"
@onready var door_rattle: AudioStreamPlayer2D = $SFX/DoorRattle
@onready var door_open: AudioStreamPlayer = $"../sfx/DoorOpen"

var can_oppose: bool = true
var is_opposed: bool = false
var has_opened_door: bool = false
var moved_button: bool = false

func _input(event: InputEvent) -> void:
	if event.is_action("ui_cancel"):
		get_tree().paused = true
		pause_menu.visible = true
	
	if event.is_action_pressed("ui_jump") and can_oppose:
		if player.is_on_floor() or player.is_on_ceiling():
			player.oppose_gravity()
			is_opposed = not is_opposed

func _on_gravity_toggle_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		can_oppose = true
		gravity_label.text = "GRAVITY: Flexible"

func _on_gravity_toggle_2_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		can_oppose = false
		gravity_label.text = "GRAVITY: Normal"
		if is_opposed:
			player.oppose_gravity()
			is_opposed = false

func _on_painting_1_area_body_entered(body: Node2D) -> void:
	if painting_1.visible:
		return
	if body.name == "Player":
		painting_1.visible = true

func _on_painting_1_area_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		painting_1.visible = false

func _on_button_pressed_down() -> void:
	if not moved_button: 
		moved_button = true
		first_button_move.play("Move")

func _on_pressure_plate_activated() -> void:
	painting_move.speed_scale = 1
	if not painting_move.is_playing():
		painting_move.play("Move")

func _on_pressure_plate_released() -> void:
	if not painting_move.is_playing():
		painting_move.play("Move")
		painting_move.seek(.74)
		painting_move.speed_scale = -1
	else:
		painting_move.speed_scale = -1

func _on_button_2_pressed_down() -> void:
	first_pressure_move.play("Move")

func _on_painting_2_area_body_entered(body: Node2D) -> void:
	if painting_2.visible:
		return
	if body.name == "Player":
		painting_2.visible = true

func _on_painting_2_area_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		painting_2.visible = false

func _on_lever_powered(_state: bool) -> void:
	door_green.visible = true
	door_red.visible = false

func _on_door_body_entered(body: Node2D) -> void:
	if body.name == "Player" and not has_opened_door and door_red.visible:
		door_rattle.play()
		return
	if body.name == "Player" and door_green.visible and not has_opened_door:
		has_opened_door = true
		closed.visible = false
		open.visible = true
		static_body_2d.position.y -= 45
		$"../Darkness".visible = false
		door_open.play()
