extends Control

@onready var intro: AnimationPlayer = $Intro
@onready var initial: Control = $Initial
@onready var menu: Control = $Menu
@onready var elements: Control = $Menu/Elements
@onready var title_element: MarginContainer = $Menu/MarginContainer
@onready var boom: AudioStreamPlayer = $Menu/Boom
@onready var bg: AudioStreamPlayer = $Bg

func _ready() -> void:
	#Lets the game be in any state and still work on load
	initial.visible = true
	menu.visible = false
	for e in elements.get_children():
		e.visible = false

func _on_intro_animation_finished(anim_name: StringName) -> void:
	if anim_name == "LoadGame":
		await get_tree().create_timer(.8).timeout
		intro.play("LoadMenu")
	elif anim_name == "LoadMenu":
		initial.visible = false
		menu.visible = true
		await get_tree().create_timer(.2).timeout
		boom.play()
		await get_tree().create_timer(.4).timeout
		title_element.visible = true
		
		
		await get_tree().create_timer(2).timeout
		boom.stop()
		bg.play()
		for e in elements.get_children():
			if e.name == "MarginContainer":
				pass
			e.visible = true
			
func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/Level_1.tscn")

func _on_collectables_pressed() -> void:
	get_tree().change_scene_to_file("res://addons/godot_super-wakatime/api_key_prompt.tscn")
	
func _on_exit_pressed() -> void:
	get_tree().quit()
