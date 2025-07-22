extends Node2D

@onready var note1: ColorRect = $Player/Camera2D/Note
@onready var access_note: ColorRect = $Player/Camera2D/AccessNote
@onready var access_note_label: Label = $Player/Camera2D/AccessNote/Label
@onready var note1_text: Label = $Player/Camera2D/Note/Label
@onready var player: CharacterBody2D = $Player
@onready var time_is_not_right: Node2D = $TimeIsNotRight
@onready var cool_stuff: Node2D = $Player/CoolStuff

var can_interact_note1 = false
var text_step: float = 1.0/3.0 #3 times a second
var text_timer: float = 0.0

func show_text() -> void:
	var distance_from_time = time_is_not_right.position - player.position
	if distance_from_time[0] <= 6000 and distance_from_time[0] > 4500:
		for e in cool_stuff.get_children():
			rand_from_seed(Time.get_unix_time_from_system())
			var rng = randi_range(1,15)
			if rng == 15 and not e.visible:
				e.visible = true
				e.position = Vector2(randf_range(-560.0, 380.0), randf_range(31.0, -560.0))
				await get_tree().create_timer(randf_range(.8,1.6)).timeout
				e.visible = false
	elif distance_from_time[0] <= 4500 and distance_from_time[0] > 2500:
		for e in cool_stuff.get_children():
			rand_from_seed(Time.get_unix_time_from_system())
			var rng = randi_range(1,9)
			if rng == 9 and not e.visible:
				e.visible = true
				e.position = Vector2(randf_range(-560.0, 380.0), randf_range(31.0, -560.0))
				await get_tree().create_timer(randf_range(.6,.9)).timeout
				e.visible = false 
	elif distance_from_time[0] <= 2500:
		for e in cool_stuff.get_children():
			rand_from_seed(Time.get_unix_time_from_system())
			var rng = randi_range(1,4)
			if rng == 4 and not e.visible:
				e.visible = true
				e.position = Vector2(randf_range(-560.0, 380.0), randf_range(31.0, -560.0))
				await get_tree().create_timer(randf_range(.5,.7)).timeout
				e.visible = false
	if distance_from_time[0] <= 300:
		WorldManager.completed_hidden_level_one = true
		get_tree().change_scene_to_file("res://Scenes/Levels/Level_1.tscn") #To level1_Custom <-- Nvm

func _physics_process(delta: float) -> void:
	text_timer += delta
	if text_timer > text_step:
		text_timer = 0
		show_text()

func show_accessability_note(text: String) -> void:
	access_note.visible = true
	access_note_label.text = text

func hide_accessability_note() -> void:
	access_note.visible = false
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_interact"):
		if can_interact_note1:
			note1.visible = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		can_interact_note1 = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		can_interact_note1 = false
		note1.visible = false
		hide_accessability_note()

func _on_button_pressed() -> void:
	show_accessability_note(note1_text.text)

func _on_close_pressed() -> void:
	hide_accessability_note()
