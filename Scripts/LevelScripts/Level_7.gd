extends Node2D

@onready var label: Label = $Label

func _ready() -> void:
	label.text = "So many regrets."
	
	await get_tree().create_timer(6).timeout
	
	label.text = "Why did it have to end up like this."
	
	await get_tree().create_timer(10).timeout
	
	label.text = "The suffering, the pain."
	
	await get_tree().create_timer(8).timeout
	
	label.text = "All avoidable if I had listened."
	
	await get_tree().create_timer(10).timeout
	
	label.text = "Why."

func _on_audio_stream_player_2d_finished() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menu/Main Menu.tscn")
