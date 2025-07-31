extends Node2D

@onready var label: Label = $Label
@onready var l: Label = $Label2
@onready var lmat: ShaderMaterial = $Label2.material

func _ready() -> void:
	label.visible = true
	l.visible = false
	await get_tree().create_timer(1).timeout
	label.visible = false
	l.visible = true
	l.text = "I just wanted to live life to it's fullest, I wanted to be safe, I wanted to fufil my life."
	
	await get_tree().create_timer(10).timeout

	l.text = "I bought myself a motorbike, a thrilling journey like no other, zooming through the streets and meeting loads of other people."
	await get_tree().create_timer(10).timeout
	
	l.text = "One of the people I met told me about an amazing motorbike event that was coming up soon. It sounded really fun so I told him I would attend!"
	await get_tree().create_timer(14).timeout
	
	l.text = "My mother made sure I was ready for the event, ensuring I was fully suited up and ready for the occasion. I told her I didn't need it but she insisted anyways."
	await get_tree().create_timer(16).timeout
	
	lmat.set_shader_parameter("separate_xy", true)
	l.text = "The time came for the event, I rolled up with my motorbike and showed it off to everybody. And thank god I did because everybody loved it! They said it was the best."
	
	await get_tree().create_timer(16).timeout
	
	lmat.set_shader_parameter("jitter_strength", 7.8)
	l.text = "After the showcase we had to do some tricks with our bikes, you know, flips, 360s, all the fun and exciting stuff."
	
	await get_tree().create_timer(11).timeout
	
	lmat.set_shader_parameter("jitter_speed", 9.6)
	lmat.set_shader_parameter("jitter_strength", 20)
	l.text = "There was one final big loop that came up, the most exciting looking loop of the event, we had one shot to complete it!"
	
	await get_tree().create_timer(12).timeout

	lmat.set_shader_parameter("enable_scaling", true)
	lmat.set_shader_parameter("scale_strength", 0.024)
	l.text = "And just like that."
	
	await get_tree().create_timer(5).timeout
	
	lmat.set_shader_parameter("jitter_speed", 17)
	lmat.set_shader_parameter("jitter_strength", 17)
	lmat.set_shader_parameter("scale_strength", 0.284)
	l.text = "Lol you shouldnt be able to read this, and if you can congrats you have ruinined the experience for yourself due to the forth wall break."

	await get_tree().create_timer(8).timeout
	
	lmat.set_shader_parameter("jitter_speed", 0)
	lmat.set_shader_parameter("jitter_strength", 0.1)
	lmat.set_shader_parameter("scale_strength", 0.1)
	lmat.set_shader_parameter("enable_scaling", false)
	lmat.set_shader_parameter("separate_xy", false)
	lmat.set_shader_parameter("enable_rotation", false)
	l.text = "And now, I'm in a coma, I am aware that I am... For now but each day or test I feel like I'm fading away like the candle is about to go out."
	await get_tree().create_timer(16).timeout

	l.text = "Why."
	
	await get_tree().create_timer(8).timeout
	
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/Menu/Main Menu.tscn")
