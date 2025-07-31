extends Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var press: AudioStreamPlayer2D = $Press

@export var is_permenant: bool = false

var is_pressed: bool = false
var entity_pressed: String

signal pressed_down()
signal area_pressed_down(body: String)
signal released

func _on_area_2d_body_entered(body: Node2D) -> void:
	if is_pressed:
		return
	var _name = body.name.rstrip("1234567890")
	entity_pressed = _name
	if _name == "Player" or _name == "BallTrigger" or _name == "SquareTrigger":
		animation_player.play("ButtonDown")
		press.play()
		pass

func _on_area_2d_body_exited(body: Node2D) -> void:
	var _name = body.name.rstrip("1234567890")
	if _name == "Player" or _name == "BallTrigger" or _name == "SquareTrigger":
		if not is_permenant:
			animation_player.play("ButtonUp")
			is_pressed = false
			entity_pressed = ""
			released.emit()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "ButtonDown":
		is_pressed = true
		pressed_down.emit()
		area_pressed_down.emit(entity_pressed)
