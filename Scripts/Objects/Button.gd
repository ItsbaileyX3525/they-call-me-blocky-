extends Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var is_permenant: bool = false

signal pressed_down

signal released

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		animation_player.play("ButtonDown")
		pass

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		if not is_permenant:
			animation_player.play("ButtonUp")
			released.emit()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "ButtonDown":
		pressed_down.emit()
