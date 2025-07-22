extends Node2D

@onready var lever_up: ColorRect = $Sprites/LeverUp
@onready var lever_down: ColorRect = $Sprites/LeverDown
@onready var switch: AudioStreamPlayer = $Switch

@export var default_state: bool = false
@export var can_interact: bool = true
var lever_state: bool = false
var _can_interact: bool = false

signal powered(state: bool)

var activated: bool = false #Exposed

func _ready() -> void:
	if default_state:
		lever_up.visible = true
		lever_down.visible = false
		lever_state = true
		activated = true

func _input(event: InputEvent) -> void:
	if can_interact:
		if event.is_action_pressed("ui_interact") and _can_interact:
			lever_state = not lever_state
			activated = not activated
			powered.emit(activated)
			lever_up.visible = lever_state
			lever_down.visible = not lever_state
			if not switch.playing:
				switch.play()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		_can_interact = true

func _on_area_2d_body_exited(_body: Node2D) -> void:
	_can_interact = false
