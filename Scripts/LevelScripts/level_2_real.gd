extends Node2D
@onready var plat_1_3: AnimationPlayer = $"Platform1/Plat1,3"
@onready var welcome: AudioStreamPlayer = $"../Voicelines/Welcome"
@onready var sidenote_1: AudioStreamPlayer = $"../Voicelines/Sidenote1"
@onready var appear_door: AnimationPlayer = $"../Walls/AppearDoor"
@onready var static_sfx: AudioStreamPlayer2D = $"../SFX/Static"
@onready var boom: AudioStreamPlayer2D = $"../SFX/Boom"
@onready var world_go_bye_bye: ColorRect = $"../WorldGoByeBye"
@onready var level_camera: Camera2D = $"../LevelCamera"

var activated_lever_1: bool = false
var press_order: Array[int] = []
var secret_order: Array[int] = [1,3,5,4,2] #Trust this makes sense <--- I lied. Uhh characters bday ig
# 13th of May 1942
var levers_activated: Array[int] = []

var pressed_lever1: bool = false
var pressed_lever2: bool = false
var pressed_lever3: bool = false
var pressed_lever4: bool = false
var pressed_lever5: bool = false

var sidenote1_played: bool = false
var sidenote2_played: bool = false

var blackhole_min: float = 0.001;
var blackhole_max: float = 0.1

func _physics_process(delta: float) -> void:
	if world_go_bye_bye.visible:
		var current_amount: float = world_go_bye_bye.material.get_shader_parameter("strength")
		world_go_bye_bye.material.set_shader_parameter("strength",current_amount+0.0008)
		level_camera.zoom = level_camera.zoom + Vector2(.01,.01)
		#Despite this getting called 60 times a second, it all clears when switching to the hidden room
		await get_tree().create_timer(3).timeout
		get_tree().change_scene_to_file("res://Scenes/Levels/Hidden_Level_2.tscn")

func _ready() -> void:
	await get_tree().create_timer(.8).timeout
	welcome.play()
	#static_sfx.play()

func check_levered_powered() -> void:
	if len(levers_activated) != 5:
		return
	
	if levers_activated == secret_order:
		print("Secret founddd")
		static_sfx.play()
	else:
		#Normal ending
		appear_door.play("DoorUp")

func _on_lever_1_powered(_state: bool) -> void:
	if welcome.playing:
		welcome.stop()
		if welcome.get_playback_position() < 3.5:
			$"../Voicelines/WelcomeSkip".play()
		
	
	if not pressed_lever1:
		if not press_order.has(1):
			press_order.append(1)
		levers_activated.append(1)
		pressed_lever1 = true
		check_levered_powered()
	else:
		for i in range(levers_activated.size()):
			var e = levers_activated[i]
			if e == 1:
				levers_activated.remove_at(i)
				break
		pressed_lever1 = false

	if plat_1_3.is_playing():
		plat_1_3.speed_scale *= -1.0
		activated_lever_1 = !activated_lever_1
		return

	if not activated_lever_1:
		plat_1_3.speed_scale = 1.0
		plat_1_3.play("platform_in")
		plat_1_3.seek(0)
	else:
		plat_1_3.play("platform_in")
		plat_1_3.seek(.77)
		plat_1_3.speed_scale = -1.0
		
	activated_lever_1 = !activated_lever_1

func _on_lever_2_powered(_state: bool) -> void:
	if not pressed_lever2:
		if not press_order.has(2):
			press_order.append(2)
		levers_activated.append(2)
		pressed_lever2 = true
		check_levered_powered()
	else:
		for i in range(levers_activated.size()):
			var e = levers_activated[i]
			if e == 2:
				levers_activated.remove_at(i)
				break
		pressed_lever2 = false
		
func _on_lever_3_powered(_state: bool) -> void:
	if not pressed_lever3:
		if not press_order.has(3):
			press_order.append(3)
		levers_activated.append(3)
		pressed_lever3 = true
		check_levered_powered()
	else:
		for i in range(levers_activated.size()):
			var e = levers_activated[i]
			if e == 3:
				levers_activated.remove_at(i)
				break
		pressed_lever3 = false

func _on_lever_4_powered(_state: bool) -> void:
	if not pressed_lever4:
		if not press_order.has(4):
			press_order.append(4)
		levers_activated.append(4)
		pressed_lever4 = true
		check_levered_powered()
	else:
		for i in range(levers_activated.size()):
			var e = levers_activated[i]
			if e == 4:
				levers_activated.remove_at(i)
				break
		pressed_lever4 = false

func _on_lever_5_powered(_state: bool) -> void:
	if not pressed_lever5:
		if not press_order.has(5):
			press_order.append(5)
		levers_activated.append(5)
		pressed_lever5 = true
		check_levered_powered()
	else:
		for i in range(levers_activated.size()):
			var e = levers_activated[i]
			if e == 5:
				levers_activated.remove_at(i)
				break
		pressed_lever5 = false

func _on_welcome_finished() -> void:
	pass # Replace with function body.

func _on_side_note_1_body_entered(body: Node2D) -> void:
	if body.name == "Player" and not sidenote1_played:
		sidenote1_played = true
		sidenote_1.play()

func _on_side_note_2_body_entered(body: Node2D) -> void:
	if body.name == "Player" and not sidenote2_played:
		sidenote2_played = true
		if sidenote_1.playing: #Doubt this will happen.
			sidenote_1.stop()
		$"../Voicelines/Sidenote2".play()

func _on_door_middle_body_entered(body: Node2D) -> void:
	if $"../Walls/AppearDoor".is_playing():
		return
	if body.name == "Player":
		get_tree().change_scene_to_file("res://Scenes/Levels/Level_3.tscn")

func _on_static_finished() -> void:
	boom.play()
	await get_tree().create_timer(.3).timeout
	boom.play()
	await get_tree().create_timer(.2).timeout
	world_go_bye_bye.visible = true
