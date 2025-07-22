extends Node2D

@onready var access_note: ColorRect = $Player/Camera2D/AccessNote
@onready var access_note_label: Label = $Player/Camera2D/AccessNote/Label
@onready var note1_text: Label = $Player/Camera2D/Note/Label
@onready var note1: ColorRect = $Player/Camera2D/Note
@onready var levelcounter_label: Label = $Player/Camera2D/LevelCounter/Control/Label
@onready var timer: Timer = $Timer

var can_interact_note1: bool = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_interact"):
		if can_interact_note1:
			note1.visible = true

func _physics_process(_delta: float) -> void:
	levelcounter_label.text = str(int(round(timer.time_left)))

func show_accessability_note(text: String) -> void:
	access_note.visible = true
	access_note_label.text = text

func hide_accessability_note() -> void:
	access_note.visible = false

func _on_close_pressed() -> void:
	hide_accessability_note()

func _on_button_pressed() -> void:
	show_accessability_note(note1_text.text)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print("Entered")
		can_interact_note1 = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		can_interact_note1 = false
		note1.visible = false
		hide_accessability_note()

func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/Level_1.tscn")
