extends Node2D

@onready var red: ColorRect = $"../Door4/Red"
@onready var closed: Node2D = $"../Door4/Closed"
@onready var open: Node2D = $"../Door4/Open"
@onready var player: CharacterBody2D = $"../Player"
@onready var static_body_2d: StaticBody2D = $"../Door4/StaticBody2D"
@onready var door_open: AudioStreamPlayer = $"../sfx/DoorOpen"
@onready var door_rattle: AudioStreamPlayer2D = $SFX/DoorRattle
@onready var green: ColorRect = $"../Door4/Green"
@onready var painting_3: Node2D = $"../LevelCamera/Paintings/Painting3"
@onready var container_1: StaticBody2D = $Container/StaticBody2D
@onready var container_2: StaticBody2D = $Container/StaticBody2D2
@onready var container_3: StaticBody2D = $Container/StaticBody2D3
@onready var square_trigger_1: RigidBody2D = $PhysicsObjects/SquareTrigger1
@onready var gravity_label: Label = $LevelCounter/Control/Label
@onready var move_button_2: AnimationPlayer = $Button3/MoveButton2
@onready var painting_4: Node2D = $"../LevelCamera/Paintings/Painting4"
@onready var painting_5: Node2D = $"../LevelCamera/Paintings/Painting5"
@onready var circle: Sprite2D = $Indicator/Circle
@onready var circle_2: Sprite2D = $Indicator/Circle2
@onready var circle_3: Sprite2D = $Indicator/Circle3
@onready var show_paintings: AnimationPlayer = $Painting3/ShowPaintings

var has_opened_door: bool = false
var can_oppose: bool = false
var is_opposed: bool = false
var button_three_pressed: bool = false
var removed_dark: bool = false
var trapped: bool = false
var button_is_shown: bool = false

var lever_one_powered: bool = false
var lever_two_powered: bool = false
var lever_three_powered: bool = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_jump") and can_oppose:
		if player.is_on_floor() or player.is_on_ceiling():
			player.oppose_gravity()
			is_opposed = not is_opposed

func check_power() -> void:
	if lever_one_powered and lever_two_powered and lever_three_powered:
		green.visible = true
		red.visible = false
	else:
		green.visible = false
		red.visible = true

func _on_door_4_body_entered(body: Node2D) -> void:
	if body.name == "Player" and not green.visible:
		door_rattle.play()
		return
	if body.name == "Player" and green.visible and not has_opened_door:
		has_opened_door = true
		open.visible = true
		closed.visible = false
		door_open.play()
		static_body_2d.position.y -= 45
		$"../Darkness4".visible = false

func _on_gravity_toggle_2_body_entered(body: Node2D) -> void: #Enable gravity flip
	if body.name == "Player":
		can_oppose = true
		gravity_label.text = "GRAVITY: Flexible"

func _on_gravity_toggle_body_entered(body: Node2D) -> void: #Disable gravity flip
	if body.name == "Player":
		can_oppose = false
		gravity_label.text = "GRAVITY: Normal"

func _on_painting_3_area_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		painting_3.visible = false

func _on_painting_3_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		painting_3.visible = true

func _on_lever_puzzle_1_powered(state: bool) -> void:
	lever_one_powered = state
	if not removed_dark:
		$Button/removeDark.play("Move")
		removed_dark = true
	if state:
		circle.self_modulate = Color("00ff00")
	else:
		circle.self_modulate = Color("ff0000")
	check_power()

func _on_button_2_area_pressed_down(body: String) -> void:
	if body == "SquareTrigger1" or body == "SquareTrigger":
		if not button_three_pressed:
			move_button_2.speed_scale = 1
			if not button_is_shown:
				button_is_shown = true
				move_button_2.play("Move")

func _on_button_pressed_down() -> void:
	container_1.position.y = -900
	container_2.position.y = -900
	container_3.position.y = -900
	square_trigger_1.sleeping = false

func _on_button_3_pressed_down() -> void:
	button_three_pressed = true
	show_paintings.play("Move")

func _on_painting_5_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		painting_5.visible = true

func _on_painting_5_area_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		painting_5.visible = false

func _on_painting_4_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		painting_4.visible = true 

func _on_painting_4_area_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		painting_4.visible = false

func _on_lever_puzzle_3_powered(state: bool) -> void:
	lever_three_powered = state
	if state:
		circle_3.self_modulate = Color("00ff00")
	else:
		circle_3.self_modulate = Color("ff0000")
	check_power()

func _on_lever_puzzle_2_powered(state: bool) -> void:
	lever_two_powered = state
	if state:
		circle_2.self_modulate = Color("00ff00")
	else:
		circle_2.self_modulate = Color("ff0000")
	check_power()

func _on_cheeky_disabler_body_entered(body: Node2D) -> void:
	if body.name != "Player":
		return
	if trapped:
		return
	if green.visible:
		if is_opposed:
			player.oppose_gravity()
			is_opposed = false
		can_oppose = false
		gravity_label.text = "GRAVITY: NORMAL"

func _on_trap_thing_body_entered(_body: Node2D) -> void:
	trapped = true
