extends Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var is_permenant: bool = false

var is_pressed: bool = false

signal pressed_down

signal released

func _on_area_2d_body_entered(body: Node2D) -> void:
	if is_pressed:
		return
	if body.name == "Player" or body.name.rstrip("1234567890") == "BallTrigger":
		animation_player.play("ButtonDown")
		pass

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player" or body.name.rstrip("1234567890") == "BallTrigger":
		if not is_permenant:
			animation_player.play("ButtonUp")
			is_pressed = false
			released.emit()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "ButtonDown":
		is_pressed = true
		pressed_down.emit()
