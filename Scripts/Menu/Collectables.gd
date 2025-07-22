extends Control

@onready var tape_label: Label = $Right/Control/MarginContainer/CenterContainer/Radio/Label

@onready var tapes: Array[Array] = [
	[WorldManager.tape1_motion_lights, $"Left/Control/MarginContainer/SmoothScrollContainer/MarginContainer/VBoxContainer/VoiceLog#1", $"Recordings/Motion Detecors", "Voice log #1"]
]

func play_recording(play_button: Button, pause_button: Button, sound: AudioStreamPlayer) -> void:
	if sound.playing:
		sound.stop()
		play_button.disabled = false
		pause_button.disabled = true
		play_button.visible = true
		pause_button.visible = false
	else:
		sound.play()
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
	
func _ready() -> void:
	print(WorldManager.tape1_motion_lights)
	for e in tapes:
		print(e)
		if e[0]:
			show_tape_player(e[1], e[2], e[3])
