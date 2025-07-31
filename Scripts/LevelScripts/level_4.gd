extends Node2D

@onready var level_camera: Camera2D = $"../LevelCamera"
@onready var player: CharacterBody2D = $"../Player"
@onready var floor_wall: ColorRect = $"../Floor/ColorRect"
@onready var unstuck_position: Node2D = $"../UnstuckPosition"
@onready var pause_menu: CanvasLayer = $"../LevelCamera/CanvasLayer2"
@onready var secret_menu: CanvasLayer = $"../LevelCamera/CanvasLayer"
@onready var ballpipe_collision: CollisionShape2D = $BallPipe/StaticBody2D/CollisionShape2D
@onready var ball_trigger_2: RigidBody2D = $"../PhysicsObjects/BallTrigger2"
@onready var wall_anim: AnimationPlayer = $PlatformLift/AnimationPlayer
@onready var square_trigger_1: RigidBody2D = $"../PhysicsObjects/SquareTrigger1"
@onready var introskip: AudioStreamPlayer2D = $"../VoiceLines/Introskip"
@onready var intro: AudioStreamPlayer2D = $"../VoiceLines/Intro"
@onready var introball: AudioStreamPlayer2D = $"../VoiceLines/Introball"
@onready var ball_press: AudioStreamPlayer2D = $"../VoiceLines/BallPress"
@onready var ball_press_skip: AudioStreamPlayer2D = $"../VoiceLines/BallPressSkip"
@onready var lolz: AudioStreamPlayer2D = $"../VoiceLines/Lolz"
@onready var sassy: AudioStreamPlayer2D = $"../VoiceLines/Sassy"
@onready var no_ball: AudioStreamPlayer2D = $"../VoiceLines/NoBall"
@onready var no_ball_2: AudioStreamPlayer2D = $"../VoiceLines/NoBall2"
@onready var no_ball_3: AudioStreamPlayer2D = $"../VoiceLines/NoBall3"
@onready var big_bertha: AudioStreamPlayer2D = $"../VoiceLines/BigBertha"

var entered_secret_door: bool = false
var entered_secret_door_code: bool = false
var door_unlocked: bool = false
var pressed_once: bool = false

var skipped_intro: bool = false
var played_skip: bool = false
var did_ball_once: bool = false
var said_big: bool = false

func _physics_process(_delta):
	var global_pos = level_camera.global_position
	floor_wall.material.set_shader_parameter("world_offset",global_pos / 900.07)

func _process(_delta: float) -> void:
	level_camera.position.x = player.position.x

func _ready() -> void:
	square_trigger_1.can_sleep = false

func _input(event: InputEvent) -> void:
	if event.is_action("ui_cancel"):
		get_tree().paused = true
		pause_menu.visible = true
	
	if not event.is_action_pressed("ui_interact"):
		return
	
	if door_unlocked:
		return
	
	if entered_secret_door_code:
		get_tree().paused = true
		secret_menu.visible = true

func _on_secret_door_input_body_entered(_body: Node2D) -> void:
	entered_secret_door_code = true
	
func _on_secret_door_input_body_exited(_body: Node2D) -> void:
	entered_secret_door_code = false
	secret_menu.visible = false
	get_tree().paused = false

######### Code input stuff ########

@onready var line_edit: LineEdit = $"../LevelCamera/CanvasLayer/CodeInput/LineEdit"
@onready var question: ColorRect = $"../LevelCamera/CanvasLayer/CodeInput/Question"
@onready var question_text: Label = $"../LevelCamera/CanvasLayer/CodeInput/Question/QuestionText"
@onready var show_door: AnimationPlayer = $"../MegaSecret/ShowDoor"
@onready var beam: AudioStreamPlayer = $"../SFX/Beam"
@onready var enterence1: ColorRect = $"../MegaSecret/ColorRect"
@onready var enterence2: ColorRect = $"../MegaSecret/ColorRect2"

func validate_answer(answer: String) -> void:
	var question_retrieve = questions[on_question]
	var real_answer = qna[question_retrieve]
	if answer.to_lower().replace(" ", "") in real_answer:
		if on_question == 4:
			player.can_move = false
			secret_menu.visible = false
			get_tree().paused = false
			show_door.play("Reveal")
			await get_tree().create_timer(7.166).timeout
			beam.play()
			player.can_move = true
			enterence1.color = Color("ff12ff")
			enterence2.color = Color("ff12ff")
			return
		on_question += 1
		question_text.text = questions[on_question]
		line_edit.text = ""
		await get_tree().process_frame
		line_edit.grab_focus()
	else:
		line_edit.text = ""
		line_edit.editable = false
		question_text.text = "WRONG!"
		await get_tree().create_timer(1.2).timeout
		line_edit.editable = true
		await get_tree().process_frame
		line_edit.grab_focus()
		question_text.text = questions[on_question]

var user_input: String

var questions = ["What caused it?", "Did you listen?", "When were you born?", "Regrets?", "Are you alive?"]
var on_question: int = 0

var qna: Dictionary = {
	"What caused it?" : ["motorbike", "bike"],
	"Did you listen?" : ["no", "nope", "nah", "naur", "never"],
	"When were you born?" : ["13/5/42", "13/5/1942", "13/05/1942", "13/05/42","13th of may 1942", "may 13th 1942", "may the 13th 1942"],
	"Regrets?" : ["many"],
	"Are you alive?" : ["yes", "no"]
}

func _on_line_edit_text_changed(new_text: String) -> void:
	user_input = new_text

func _on_line_edit_text_submitted(new_text: String) -> void:
	user_input = new_text
	validate_answer(user_input) 

### Normal stuff again ###

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_exit_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menu/Main Menu.tscn")

func _on_unstuck_pressed() -> void:
	player.position = unstuck_position.position

func _on_resume_pressed() -> void:
	get_tree().paused = false
	pause_menu.visible = false

func _on_ball_holder_1_body_entered(body: Node2D) -> void:
	if body.name.rstrip("1234567890") == "BallTrigger":
		if not played_skip:
			if intro.playing:
				intro.stop()
				introskip.play()
				skipped_intro = true
			else:
				introball.play()
		played_skip = true
		ballpipe_collision.call_deferred("set_disabled", true)
		ball_trigger_2.sleeping = false

func _on_ball_holder_1_body_exited(_body: Node2D) -> void:
	print("Ball one removed")

func _on_code_return_pressed() -> void:
	get_tree().paused = false
	secret_menu.visible = false

func _on_yeeter_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player.add_force(Vector2(0.0,-2000.0))

func _on_button_pressed_down() -> void:
	if not pressed_once:
		pressed_once = true
		$Wall/MoveWall.play("MoveWalls")
		if not skipped_intro:
			introball.stop()
			ball_press.play()
		else:
			ball_press_skip.play()

func _on_lever_powered(state: bool) -> void:
	if state:
		wall_anim.speed_scale = 1
		wall_anim.play("MoveUp")
	else:
		if not wall_anim.is_playing():
			wall_anim.play("MoveUp")
			wall_anim.seek(.95)
			wall_anim.speed_scale = -1
		else:
			wall_anim.speed_scale = -1

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		get_tree().call_deferred("change_scene_to_file", "res://Scenes/Levels/The_End.tscn")

var fake_wall_moved: bool = false

func _on_button_2_area_pressed_down(body: String) -> void:
	if body == "Player" or body == "player":
		if not fake_wall_moved:
			sassy.play()
		return
		
	if fake_wall_moved:
		return
	
	lolz.play()
	sassy.stop()
	fake_wall_moved = true
	$Wall2/CollisionShape2D.disabled = true
	$Wall2/MoveFakeWall.play("WallMove")

func _on_ball_holder_3_body_entered(body: Node2D) -> void:
	if body.name == "BallTrigger1":
		if not said_big:
			big_bertha.play()
		$Crane/RemoveCage.play("LiftUp")


func _on_omegabutton_area_pressed_down(body: String) -> void:
	if body == "BallTrigger":
		$"../Walls/AppearDoor".play("DoorUp")

func _on_door_middle_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		get_tree().call_deferred("change_scene_to_file","res://Scenes/Levels/Level_5.tscn")

@onready var nopes: Array[AudioStreamPlayer2D] = [
	$"../VoiceLines/NoBall2",$"../VoiceLines/NoBall3"
]

func _on_disintergrate_body_entered(body: Node2D) -> void:
	if body.name == "BallTrigger2":
		$"../PhysicsObjects/BallTrigger2".apply_central_impulse(Vector2(-6000, -6000))
		if not did_ball_once:
			did_ball_once = true
			no_ball.play()
		else:
			var rand = randi_range(0,1)
			nopes[rand].play()
