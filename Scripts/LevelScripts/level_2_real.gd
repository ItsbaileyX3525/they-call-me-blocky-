extends Node2D
@onready var plat_1_3: AnimationPlayer = $"Platform1/Plat1,3"
@onready var welcome: AudioStreamPlayer = $"../Voicelines/Welcome"
@onready var sidenote_1: AudioStreamPlayer = $"../Voicelines/Sidenote1"
@onready var appear_door: AnimationPlayer = $"../Walls/AppearDoor"
@onready var static_sfx: AudioStreamPlayer2D = $"../SFX/Static"
@onready var boom: AudioStreamPlayer2D = $"../SFX/Boom"
@onready var world_go_bye_bye: ColorRect = $"../WorldGoByeBye"
@onready var level_camera: Camera2D = $"../LevelCamera"
@onready var access_note: ColorRect = $"../LoreHint/AccessNote"
@onready var access_note_label: Label = $"../LoreHint/AccessNote/Label"
@onready var note1: ColorRect = $"../LoreHint/Note"
@onready var radio: Node2D = $"../Radio"
@onready var note1_text: Label = $"../LoreHint/Note/Label"
@onready var hole_in_the_wall: Node2D = $HoleInTheWall
@onready var crack_click: Button = $"../CrackClick"
@onready var tap: AudioStreamPlayer2D = $"../SFX/Tap"
@onready var rock: AudioStreamPlayer2D = $"../SFX/Rock"
@onready var pause_menu: CanvasLayer = $"../LevelCamera/CanvasLayer2"

var collected_radio: bool = false

var activated_lever_1: bool = false
var press_order: Array[int] = []
var secret_order: Array[int] = [1,3,5,4,2] #Trust this makes sense <--- I lied. Uhh characters bday ig
var radio_order: Array[int] = [1,5,4,3,2] #To spawn radio
# 13th of May 1942
var levers_activated: Array[int] = [] 
 
var pressed_lever1: bool = false 
var pressed_lever2: bool = false
var pressed_lever3: bool = false
var pressed_lever4: bool = false
var pressed_lever5: bool = false

var times_pressed_crack: int = 0

var sidenote1_played: bool = false
var sidenote2_played: bool = false

var can_interact_note1: bool = false

var blackhole_min: float = 0.001;
var blackhole_max: float = 0.1

func _physics_process(_delta: float) -> void:
	if world_go_bye_bye.visible:
		var current_amount: float = world_go_bye_bye.material.get_shader_parameter("strength")
		world_go_bye_bye.material.set_shader_parameter("strength",current_amount+0.0008)
		level_camera.zoom = level_camera.zoom + Vector2(.01,.01)
		#Despite this getting called 60 times a second, it all clears when switching to the hidden room
		await get_tree().create_timer(3).timeout
		get_tree().call_deferred("change_scene_to_file", "res://Scenes/Levels/Hidden_Level_2.tscn")

func _input(event: InputEvent) -> void:
	if event.is_action("ui_cancel"):
		get_tree().paused = true
		pause_menu.visible = true

	if event.is_action_pressed("ui_interact"):
		if can_interact_note1:
			note1.visible = true

func _ready() -> void:
	await get_tree().create_timer(.8).timeout
	welcome.play()
	#static_sfx.play()

func show_accessability_note(text: String) -> void:
	access_note.visible = true
	access_note_label.text = text

func hide_accessability_note() -> void:
	access_note.visible = false

func check_levered_powered() -> void:
	if len(levers_activated) != 5:
		return
	
	if levers_activated == secret_order:
		print("Secret founddd")
		static_sfx.play()
	elif levers_activated == radio_order:
		print("Radio secret found.")
		if not collected_radio:
			radio.visible = true
	else:
		#Normal ending
		WorldManager.completed_level_two = true
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
		get_tree().call_deferred("change_scene_to_file", "res://Scenes/Levels/Level_3.tscn")

func _on_static_finished() -> void:
	boom.play()
	await get_tree().create_timer(.3).timeout
	boom.play()
	await get_tree().create_timer(.2).timeout
	world_go_bye_bye.visible = true


func _on_button_pressed() -> void:
	if hole_in_the_wall.visible:
		return
	
	if times_pressed_crack >= 20:
		rock.play()
		crack_click.disabled = true
		crack_click.mouse_filter = Control.MOUSE_FILTER_STOP
		hole_in_the_wall.visible = true
		return
	
	times_pressed_crack += 1
	tap.play()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player" and hole_in_the_wall.visible:
		print("Entered")
		can_interact_note1 = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		can_interact_note1 = false
		note1.visible = false
		hide_accessability_note()

func _on_close_pressed() -> void:
	hide_accessability_note()

func _on_access_mode_pressed() -> void:
	show_accessability_note(note1_text.text)

func _on_area_2d_radio_body_entered(body: Node2D) -> void:
	if body.name != "Player":
		return
		
	if radio.visible:
		radio.visible = false
		collected_radio = true
		WorldManager.tape2 = true

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_exit_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menu/Main Menu.tscn")

func _on_unstuck_pressed() -> void:
	pass#player.position = unstuck_position.position

func _on_resume_pressed() -> void:
	get_tree().paused = false
	pause_menu.visible = false
