extends Node2D

@onready var door_red: ColorRect = $"../Door2/Red"
@onready var door_green: ColorRect = $"../Door2/Green"
@onready var button: Node2D = $Button
@onready var lever: Node2D = $Lever
@onready var lever_2: Node2D = $Lever2
@onready var lever_3: Node2D = $Lever3
@onready var closed: Node2D = $"../Door2/Closed"
@onready var open: Node2D = $"../Door2/Open"
@onready var door_rattle: AudioStreamPlayer2D = $SFX/DoorRattle
@onready var static_body_2d: StaticBody2D = $"../Door2/StaticBody2D"
@onready var door_open: AudioStreamPlayer = $"../sfx/DoorOpen"

var has_opened_door: bool = false

func _on_lever_powered(state: bool) -> void:
	lever_2.can_interact = state

func _on_lever_2_powered(state: bool) -> void:
	lever_3.can_interact = state

func _on_lever_3_powered(_state: bool) -> void:
	button.visible = true

func _on_button_pressed_down() -> void:
	door_red.visible = false
	door_green.visible = true

func _on_door_2_body_entered(body: Node2D) -> void:
	if body.name == "Player" and not has_opened_door and door_red.visible:
		door_rattle.play()
		return
	if body.name == "Player" and door_green.visible and not has_opened_door:
		has_opened_door = true
		closed.visible = false
		open.visible = true
		static_body_2d.position.y -= 45
		$"../Darkness2".visible = false
		door_open.play()
