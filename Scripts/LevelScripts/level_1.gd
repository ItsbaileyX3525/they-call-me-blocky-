extends Node2D

@onready var teleport: Node2D = $"../Level2Elements/Teleport"
@onready var level_camera: Camera2D = $"../LevelCamera"
@onready var camera_position: Node2D = $"../Level2Elements/CameraPosition"
@onready var voice_lines: Node = $VoiceLines
@onready var intro_2: AudioStreamPlayer = $VoiceLines/Intro2
@onready var wentback_1: AudioStreamPlayer = $VoiceLines/Wentback1
@onready var wentback_2: AudioStreamPlayer = $VoiceLines/Wentback2
@onready var wentback_3: AudioStreamPlayer = $VoiceLines/Wentback3
@onready var wentback_4: AudioStreamPlayer = $VoiceLines/Wentback4
@onready var wentback_8: AudioStreamPlayer = $VoiceLines/Wentback8
@onready var hurry_1: AudioStreamPlayer = $VoiceLines/Hurry1
@onready var hurry_2: AudioStreamPlayer = $VoiceLines/Hurry2
@onready var hurry_3: AudioStreamPlayer = $VoiceLines/Hurry3
@onready var hurry_4: AudioStreamPlayer = $VoiceLines/Hurry4
@onready var hurry_5: AudioStreamPlayer = $VoiceLines/Hurry5
@onready var level_2_elements: Node2D = $"../Level2Elements"
@onready var point_light_2d: PointLight2D = $PointLight2D
@onready var light_turn_off: AudioStreamPlayer2D = $SFX/LightTurnOff
@onready var light_buzz: AudioStreamPlayer2D = $"../Ambience/LightBuzz"
@onready var door_rattle: AudioStreamPlayer2D = $SFX/DoorRattle
@onready var hole_in_the_wall: Node2D = $HoleInTheWall
@onready var radio: Node2D = $Radio
@onready var pause_menu: CanvasLayer = $"../LevelCamera/CanvasLayer2"

signal door_passage()

var finished_level: bool = false

@onready var went_back_voicelines: Array = [
	wentback_1,
	wentback_2,
	wentback_3,
	wentback_4
]

var smacked_into_door: int = 0

func _input(event: InputEvent) -> void:
	if event.is_action("ui_cancel"):
		get_tree().paused = true
		pause_menu.visible = true

func update_times_gone_back() -> void:
	if not WorldManager.tape1_motion_lights:
		radio.visible = true
	
	WorldManager.times_gone_back_to_intro += 1
	if WorldManager.times_gone_back_to_intro >= 0 and WorldManager.times_gone_back_to_intro <= 4:
		#Create a realistic reation feel
		await get_tree().create_timer(.85).timeout
		if WorldManager.on_level != 0:
			return
		went_back_voicelines[WorldManager.times_gone_back_to_intro-1].play()
	
	if WorldManager.times_gone_back_to_intro == 8:
		wentback_8.play()

func panel_fallout() -> void:
	hole_in_the_wall.visible = true
	for e in hole_in_the_wall.get_children():
		if e.name == "Lever":
			e.can_interact = true

func _ready() -> void:
	level_2_elements.connect("door_passage", update_times_gone_back)
	WorldManager.on_level = 0
	
	#Start timer for the voice lines about being stupid
	await get_tree().create_timer(28).timeout
	if WorldManager.on_level != 0:
		return
	hurry_1.play()
	await get_tree().create_timer(16).timeout
	if WorldManager.on_level != 0:
		return
	hurry_2.play()
	await get_tree().create_timer(18).timeout
	if WorldManager.on_level != 0:
		return
	hurry_3.play()
	await get_tree().create_timer(19).timeout
	if WorldManager.on_level != 0:
		return
	hurry_4.play()
	await get_tree().create_timer(25).timeout
	if WorldManager.on_level != 0:
		return
	hurry_5.play()
	await get_tree().create_timer(30).timeout
	if WorldManager.on_level != 0:
		return
	point_light_2d.enabled = false
	light_turn_off.play()
	light_buzz.stop()

func _on_intro_1_finished() -> void:
	await get_tree().create_timer(.6).timeout
	print(WorldManager.on_level)
	if WorldManager.on_level == 0:
		WorldManager.intro_on_voicelines = 2
		intro_2.play()
	
func _on_door_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		if point_light_2d.enabled:
			body.position = teleport.position
			level_camera.position = camera_position.position
			for e in voice_lines.get_children():
				if e.playing:
					e.stop()
			door_passage.emit()
			WorldManager.on_level = 1
		else:
			if not door_rattle.playing:
				door_rattle.play()
				smacked_into_door += 1
				if smacked_into_door == 8:
					panel_fallout()

func _on_intro_2_finished() -> void:
	WorldManager.intro_on_voicelines = 3

func _on_lever_powered(_state: bool) -> void:
	$WallL/MoveWall.play("MoveWallUp")

func _on_hidden_level_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		get_tree().call_deferred("change_scene_to_file", "res://Scenes/Levels/Hidden_Level_1.tscn")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name != "Player":
		return

	if radio.visible:
		WorldManager.tape1_motion_lights = true
		$SFX/RadioPickup.play()
		radio.visible = false

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_exit_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menu/Main Menu.tscn")

func _on_unstuck_pressed() -> void:
	pass#player.position = unstuck_position.position

func _on_resume_pressed() -> void:
	get_tree().paused = false
	pause_menu.visible = false
