extends Control

@onready var intro: AnimationPlayer = $Intro
@onready var initial: Control = $Initial
@onready var menu: Control = $Menu
@onready var elements: Control = $Menu/Elements
@onready var title_element: MarginContainer = $Menu/MarginContainer
@onready var boom: AudioStreamPlayer = $Menu/Boom
@onready var bg: AudioStreamPlayer = $Bg
@onready var alt_bg: AudioStreamPlayer = $AltBG

func _ready() -> void:
	if get_tree().paused:
		get_tree().paused = false
	#Lets the game be in any state and still work on load
	if SettingsManager.first_load:
		intro.play("LoadGame")
		initial.visible = true
		menu.visible = false
		for e in elements.get_children():
			e.visible = false
		SettingsManager.first_load = false
	else:
		var rand_chance: int = randi_range(1,10)
		if rand_chance == 10:
			alt_bg.play()
		else:
			bg.play()
		initial.visible = false
		menu.visible = true
		for e in elements.get_children():
			e.visible = true
		

func _on_intro_animation_finished(anim_name: StringName) -> void:
	if anim_name == "LoadGame":
		SettingsManager.first_load = false
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
		var rand_chance: int = randi_range(1,10)
		if rand_chance == 10:
			alt_bg.play()
		else:
			bg.play()
		for e in elements.get_children():
			if e.name == "MarginContainer":
				pass
			e.visible = true
			
func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/Level_1.tscn")

func _on_collectables_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menu/Collectables.tscn")
	
func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menu/Settings.tscn")
