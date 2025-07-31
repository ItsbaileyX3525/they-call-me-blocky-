extends Node2D

@onready var player: CharacterBody2D = $"../Player"
@onready var level_camera: Camera2D = $"../LevelCamera"
@onready var floor_wall: ColorRect = $"../Floor/ColorRect"
@onready var pause_menu: CanvasLayer = $"../LevelCamera/CanvasLayer2"

func _physics_process(_delta):
	var global_pos = level_camera.global_position
	floor_wall.material.set_shader_parameter("world_offset", global_pos / 900.07)

func _process(_delta: float) -> void:
	level_camera.position.x = player.position.x


func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_exit_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menu/Main Menu.tscn")

func _on_resume_pressed() -> void:
	get_tree().paused = false
	pause_menu.visible = false

func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/Levels/Level_6.tscn")
