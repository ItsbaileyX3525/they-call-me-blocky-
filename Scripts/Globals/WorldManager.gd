extends Node

func save_data(content: Dictionary) -> void:
	var file = FileAccess.open("user://WorldManager.sav", FileAccess.WRITE)
	#### store_8 (8bit int aka bool)
	file.store_var(content["completed_levels"])
	file.store_8(content[""])

func load_from_file():
	var file = FileAccess.open("user://WorldManager.sav", FileAccess.READ)
	var content = file.get_as_text()
	return content

#Save stuff

var completed_levels: Array[bool] = [ #In level order
	false,
	false,
]

var collected_tapes: Array[bool] = [
	
]

#Collectables
var tape1_motion_lights: bool = false

#Intro/Level 1 stuff
var intro_on_voicelines: int = 1 #1 - first, #2 - second, #3 finished
var on_level: int = 0 #0 for intro and 1 for level 1 and so on...
var times_gone_back_to_intro: int = 0 #Tracks how many times you've gone back to the intro
var completed_level1_explain: bool = false



#Hidden level stuff

# level1

var _completed_hidden_level_one: bool = false

var completed_hidden_level_one: bool = false :
	set (value):
		_completed_hidden_level_one = completed_hidden_level_one
	get:
		return _completed_hidden_level_one
