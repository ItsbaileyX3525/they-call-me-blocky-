extends Node2D

@onready var appear_door: AnimationPlayer = $Walls/AppearDoor
@onready var animation_player: AnimationPlayer = $StaticBody2D/AnimationPlayer

var door_shown: bool = false
var trapped: bool = false

func _on_trap_thing_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		if not trapped:
			trapped = true
			animation_player.play("Move")

func _on_show_door_body_entered(body: Node2D) -> void:
	if body.name == "Player" and not door_shown:
		door_shown = true
		appear_door.play("DoorUp")

func _on_cheeky_disabler_body_entered(body: Node2D) -> void:
	if body.name != "Player":
		return
	
	if body.gravity_flipped:
		body.oppose_gravity()
		$"../Section4".is_opposed = false

func _on_door_middle_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		get_tree().call_deferred("change_scene_to_file", "res://Scenes/Levels/Level_7.tscn")
