extends Node2D

@onready var cable1_color: ColorRect = $"../Section2/Cable/ColorRect"
@onready var cable1_color2: ColorRect = $"../Section2/Cable/ColorRect2"
@onready var cable1_color3: ColorRect = $"../Section2/Cable/ColorRect3"
@onready var cable2_color: ColorRect = $Cable/ColorRect
@onready var cable2_color2: ColorRect = $Cable/ColorRect2
@onready var cable2_color3: ColorRect = $Cable/ColorRect3
@onready var cable3_color: ColorRect = $Cable2/ColorRect
@onready var cable3_color2: ColorRect = $Cable2/ColorRect2
@onready var cable3_color3: ColorRect = $Cable2/ColorRect3
@onready var power_station_circle: Sprite2D = $Indicator/Circle
@onready var power_station_circle2: Sprite2D = $Indicator/Circle2
@onready var power_station_circle3: Sprite2D = $Indicator/Circle3
@onready var power_station_label: Label = $Indicator/Label
@onready var player: CharacterBody2D = $"../Player"
@onready var cage_move: AnimationPlayer = $Cage/CageMove
@onready var red: ColorRect = $"../Door3/Red"
@onready var green: ColorRect = $"../Door3/Green"
@onready var closed: Node2D = $"../Door3/Closed"
@onready var open: Node2D = $"../Door3/Open"
@onready var door_open: AudioStreamPlayer = $"../sfx/DoorOpen"
@onready var door_rattle: AudioStreamPlayer2D = $SFX/DoorRattle
@onready var static_body_2d: StaticBody2D = $"../Door3/StaticBody2D"

var power_one: bool = true
var power_two: bool = false
var power_three: bool = false
var inversed_gravity: bool = false
var is_door_open: bool = false
var has_opened_door: bool = false

func check_power() -> void:
	if power_one and power_two and power_three:
		power_station_label.text = "POWER: ONLINE"
		cage_move.play("Move")
	else:
		power_station_label.text = "POWER: OFFLINE"

func _on_lever_powered(state: bool) -> void:
	if state: #Power off
		power_one = false
		power_station_circle.self_modulate = Color("ff0000")
		cable1_color.color = Color("ff0000")
		cable1_color2.color = Color("ff0000")
		cable1_color3.color = Color("ff0000")
	else: #Power on
		power_one = true
		power_station_circle.self_modulate = Color("00db00")
		cable1_color.color = Color("00db00")
		cable1_color2.color = Color("00db00")
		cable1_color3.color = Color("00db00")
		check_power()

func _on_lever_2_powered(state: bool) -> void:
	if state: #Power on
		power_two = true
		power_station_circle2.self_modulate = Color("00db00")
		cable2_color.color = Color("00db00")
		cable2_color2.color = Color("00db00")
		cable2_color3.color = Color("00db00")
		if not inversed_gravity:
			inversed_gravity = true
			player.oppose_gravity()
	else: #Power off
		power_two = false
		power_station_circle2.self_modulate = Color("ff0000")
		cable2_color.color = Color("ff0000")
		cable2_color2.color = Color("ff0000")
		cable2_color3.color = Color("ff0000")
		check_power()

func _on_lever_3_powered(state: bool) -> void:
	if state: #Power on
		power_three = true
		player.oppose_gravity()
		inversed_gravity = false
		power_station_circle3.self_modulate = Color("00db00")
		cable3_color.color = Color("00db00")
		cable3_color2.color = Color("00db00")
		cable3_color3.color = Color("00db00")
		check_power()

	else: #Power off
		power_three = false
		power_station_circle3.self_modulate = Color("ff0000")
		cable3_color.color = Color("ff0000")
		cable3_color2.color = Color("ff0000")
		cable3_color3.color = Color("ff0000")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player.add_force(Vector2(0.0,-6000.0))

func _on_pressure_plate_activated() -> void:
	red.visible = false
	green.visible = true

func _on_pressure_plate_released() -> void:
	if not is_door_open:
		red.visible = true
		green.visible = false

func _on_door_3_body_entered(body: Node2D) -> void:
	if body.name == "Player" and not green.visible:
		door_rattle.play()
		return
	if body.name == "Player" and green.visible and not has_opened_door:
		has_opened_door = true
		is_door_open = true
		open.visible = true
		closed.visible = false
		door_open.play()
		static_body_2d.position.y -= 45
		$"../Darkness3".visible = false
