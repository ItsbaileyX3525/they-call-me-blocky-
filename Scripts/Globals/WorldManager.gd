extends Node

var data_loaded: bool = false

func save_data(content: Dictionary) -> void:
	var file = FileAccess.open("user://WorldManager.sav", FileAccess.WRITE)
	#### store_8 (8bit int aka bool)
	file.store_var(content["completed_levels"])
	file.store_var(content["collected_tapes"])
	file.store_var(content["completed_hidden_levels"])

func load_from_file():
	if FileAccess.file_exists("user://WorldManager.sav"):
		var file = FileAccess.open("user://WorldManager.sav", FileAccess.READ)
		var content = [
			file.get_var(),
			file.get_var(),
			file.get_var()
		]
		return content
	else:
		return false

func save_game() -> void:
	completed_levels.clear()
	completed_levels.append(completed_level_one)
	completed_levels.append(completed_level_two)
	
	completed_hidden_levels.clear()
	completed_hidden_levels.append(completed_hidden_level_one)
	completed_hidden_levels.append(completed_hidden_level_two)
	
	collected_tapes.clear()
	collected_tapes.append(tape1_motion_lights)
	collected_tapes.append(tape2)
	collected_tapes.append(tape3)
	
	var content = {
		"completed_levels": completed_levels,
		"collected_tapes": collected_tapes,
		"completed_hidden_levels": completed_hidden_levels,
	}

	save_data(content)

#Save stuff

var completed_levels: Array[bool] = [ #In level order
	false,
	false,
]

var completed_hidden_levels: Array[bool] = [
	false,
	false,
]

var collected_tapes: Array[bool] = [
	false,
	false,
	false
]

var tapes: Array[bool] = [
	false,
	false,
	false
]

func _ready() -> void:
	
	var content = load_from_file()
	
	if content:
		completed_levels.clear()
		collected_tapes.clear()
		completed_hidden_levels.clear()
		completed_levels = content[0].duplicate()
		collected_tapes = content[1].duplicate()
		completed_hidden_levels = content[2].duplicate()
	
	for e in range(len(collected_tapes)):
		var i = collected_tapes[e]
		tapes[e] = i
		
	tape1_motion_lights = tapes[0]
	tape2 = tapes[1]
	tape3 = tapes[2]
	
	data_loaded = true

func reset_vars() -> void:
	intro_on_voicelines = 1
	on_level = 0
	times_gone_back_to_intro = 0
	completed_level1_explain = false

#Intro/Level 1 stuff
var intro_on_voicelines: int = 1 #1 - first, #2 - second, #3 finished
var on_level: int = 0 #0 for intro and 1 for level 1 and so on...
var times_gone_back_to_intro: int = 0 #Tracks how many times you've gone back to the intro
var completed_level1_explain: bool = false

var level_3_pos: Vector2 = Vector2(0.0,0.0)

#Level 3 stuff
var has_entered_sub: bool = false

#setgets

#Collectables
var _tape1_motion_lights: bool = false
var _tape2: bool = false
var _tape3: bool = false

var tape1_motion_lights: bool = false:
	set(value):
		_tape1_motion_lights = value
		if data_loaded:
			save_game()
	get:
		return _tape1_motion_lights

var tape2: bool = false:
	set(value):
		_tape2 = value
		if data_loaded:
			save_game()
	get:
		return _tape2

var tape3: bool = false:
	set(value):
		_tape3 = value
		if data_loaded:
			save_game()
	get:
		return _tape3
# level1

var _completed_level_one: bool = false

var completed_level_one: bool = false :
	set (value):
		_completed_level_one = value
		if data_loaded:
			save_game()
	get:
		return _completed_level_one

var _completed_level_two: bool = false

var completed_level_two: bool = false :
	set (value):
		_completed_level_two = value
		save_game()
	get:
		return _completed_level_two

var _completed_hidden_level_one: bool = false

var completed_hidden_level_one: bool = false :
	set (value):
		_completed_hidden_level_one = value
		save_game()
	get:
		return _completed_hidden_level_one

var _completed_hidden_level_two: bool = false

var completed_hidden_level_two: bool = false :
	set (value):
		_completed_hidden_level_two = value
		save_game()
	get:
		return _completed_hidden_level_two
