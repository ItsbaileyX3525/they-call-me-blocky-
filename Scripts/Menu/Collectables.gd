extends Control

@onready var tape_label: Label = $Right/Control/MarginContainer/CenterContainer/Radio/Label
@onready var time: Label = $Right/Control/MarginContainer2/VBoxContainer/Time
@onready var circle_1: Sprite2D = $Right/Control/MarginContainer2/VBoxContainer/ColorRect/Circle1

var playing_tape: bool = false
var knob_start: float = 0.0
var knob_end: float = 400.0
var current_tape_recording: AudioStreamPlayer

@onready var tapes: Array[Array] = [
	[WorldManager.tape1_motion_lights, $"Left/Control/MarginContainer/SmoothScrollContainer/MarginContainer/VBoxContainer/VoiceLog#1", $"Recordings/Motion Detecors", "Voice log #1"],
	[WorldManager.tape2, $"Left/Control/MarginContainer/SmoothScrollContainer/MarginContainer/VBoxContainer/VoiceLog#2", $"Recordings/American Dates", "Voice log #2"],
	[WorldManager.tape3, $"Left/Control/MarginContainer/SmoothScrollContainer/MarginContainer/VBoxContainer/VoiceLog#3", $"Recordings/Motorbikes", "Voice log #3"]
]

func _process(delta: float) -> void:
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
			var total_minutes := int(total_length) / 60
			var total_seconds := int(total_length) % 60

			var current_str := "%d:%02d" % [current_minutes, current_seconds]
			var total_str := "%d:%02d" % [total_minutes, total_seconds]

			time.text = current_str + " / " + total_str

func recording_finished() -> void:
	current_tape_recording = null

func play_recording(play_button: Button, pause_button: Button, sound: AudioStreamPlayer) -> void:
	if sound.playing:
		sound.stop()
		current_tape_recording = null
		play_button.disabled = false
		pause_button.disabled = true
		play_button.visible = true
		pause_button.visible = false
	else:
		sound.play()
		print(typeof(current_tape_recording))
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
	print(WorldManager.tape1_motion_lights)
	for e in tapes:
		print(e)
		if e[0]:
			show_tape_player(e[1], e[2], e[3])
