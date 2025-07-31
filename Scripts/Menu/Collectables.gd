extends Control

@onready var tape_label: Label = $Right/Control/MarginContainer/CenterContainer/Radio/Label
@onready var time: Label = $Right/Control/MarginContainer2/VBoxContainer/Time
@onready var circle_1: Sprite2D = $Right/Control/MarginContainer2/VBoxContainer/ColorRect/Circle1
@onready var play: Button = $"Left/Control/MarginContainer/SmoothScrollContainer/MarginContainer/VBoxContainer/VoiceLog#1/MarginContainer/Play"
@onready var play2: Button = $"Left/Control/MarginContainer/SmoothScrollContainer/MarginContainer/VBoxContainer/VoiceLog#2/MarginContainer/Play"
@onready var play3: Button = $"Left/Control/MarginContainer/SmoothScrollContainer/MarginContainer/VBoxContainer/VoiceLog#3/MarginContainer/Play"
@onready var pause: Button = $"Left/Control/MarginContainer/SmoothScrollContainer/MarginContainer/VBoxContainer/VoiceLog#1/MarginContainer/Pause"
@onready var pause2: Button = $"Left/Control/MarginContainer/SmoothScrollContainer/MarginContainer/VBoxContainer/VoiceLog#2/MarginContainer/Pause"
@onready var pause3: Button = $"Left/Control/MarginContainer/SmoothScrollContainer/MarginContainer/VBoxContainer/VoiceLog#3/MarginContainer/Pause"

var playing_tape: bool = false
var knob_start: float = 0.0
var knob_end: float = 400.0
var current_tape_recording: AudioStreamPlayer

@onready var tapes: Array[Array] = [
	[WorldManager.tape1_motion_lights, $"Left/Control/MarginContainer/SmoothScrollContainer/MarginContainer/VBoxContainer/VoiceLog#1", $"Recordings/Motion Detecors", "Voice log #1"],
	[WorldManager.tape2, $"Left/Control/MarginContainer/SmoothScrollContainer/MarginContainer/VBoxContainer/VoiceLog#2", $"Recordings/American Dates", "Voice log #2"],
	[WorldManager.tape3, $"Left/Control/MarginContainer/SmoothScrollContainer/MarginContainer/VBoxContainer/VoiceLog#3", $"Recordings/Motorbikes", "Voice log #3"]
]

func _process(_delta: float) -> void:
	map_time_to_position()

func map_time_to_position() -> void:
	if typeof(current_tape_recording) == 24:
		var total_length := current_tape_recording.stream.get_length()
		if total_length > 0:
			var current_time := current_tape_recording.get_playback_position()
			var normalized = clamp(current_time / total_length, 0.0, 1.0)
			var knob_position = lerp(knob_start, knob_end, normalized)
			circle_1.position.x = knob_position

			var current_minutes := int(current_time) / 60
			var current_seconds := int(current_time) % 60
			var total_minutes := int(total_length) / 60 # I KNOW ITS AN INTERGER DIVISION PLS STOP WHINING GODOT!
			var total_seconds := int(total_length) % 60

			var current_str := "%d:%02d" % [current_minutes, current_seconds]
			var total_str := "%d:%02d" % [total_minutes, total_seconds]

			time.text = current_str + " / " + total_str

func recording_finished() -> void:
	current_tape_recording = null
	if WorldManager.tape1_motion_lights:
		pause.visible = false
		pause.disabled = true
		play.visible = true
		play.disabled = false
	if WorldManager.tape2:
		pause2.visible = false
		pause2.disabled = true
		play2.visible = true
		play2.disabled = false
	if WorldManager.tape3:
		pause3.visible = false
		pause3.disabled = true
		play3.visible = true
		play3.disabled = false

func play_recording(play_button: Button, pause_button: Button, sound: AudioStreamPlayer) -> void:
	if WorldManager.tape1_motion_lights:
		play.disabled = true
	if WorldManager.tape2:
		play2.disabled = true
	if WorldManager.tape3:
		play3.disabled = true
	if sound.playing:
		sound.stop()
		current_tape_recording = null
		play_button.disabled = false
		pause_button.disabled = true
		play_button.visible = true
		pause_button.visible = false
		if WorldManager.tape1_motion_lights:
			play.disabled = false
		if WorldManager.tape2:
			play2.disabled = false
		if WorldManager.tape3:
			play3.disabled = false
	else:
		sound.play()
		current_tape_recording = sound
		pause_button.disabled = false
		play_button.disabled = true
		play_button.visible = false
		pause_button.visible = true

func show_tape_player(tape_node: ColorRect, recording: AudioStreamPlayer, tape_label_text: String) -> void:
	var correct_parent = tape_node.get_child(1)
	var play_button = tape_node.get_child(0).get_child(0)
	var pause_button = tape_node.get_child(0).get_child(1)
	var voice_title = correct_parent.get_child(0)
	var voice_title_data = correct_parent.get_child(1)
	
	tape_label.text = tape_label_text
	voice_title.text = voice_title_data.text
	
	play_button.disabled = false
	play_button.connect("pressed", play_recording.bind(play_button, pause_button, recording))
	pause_button.connect("pressed", play_recording.bind(play_button, pause_button, recording))
	recording.connect("finished", recording_finished)
	
func _ready() -> void:
	for e in tapes:
		if e[0]:
			show_tape_player(e[1], e[2], e[3])


func _on_return_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menu/Main Menu.tscn")
