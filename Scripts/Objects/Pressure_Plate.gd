extends Node2D

signal released
signal activated

@onready var timeout: Timer = $Timeout
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var duration: float = 1.0
@export var allow_charge: bool = false
@export var max_charge: float = 1.0

var extended_time: float = 0.0
var timer: float = 0.0
var pressed: bool = false
var start_counting: bool = false

func _physics_process(delta: float) -> void:
	if not start_counting:
		return
	if pressed:
		if allow_charge and extended_time <= max_charge:
			extended_time += delta / 2 #Should do .5s every second
	else:
		if timeout.is_stopped():
			timeout.wait_time = duration + extended_time
			timeout.start()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "ButtonDown":
		activated.emit()
		start_counting = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		if start_counting:
			return
		animation_player.play("ButtonDown")
		pressed = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		pressed = false
		if not start_counting:
			animation_player.play("ButtonUp")

func _on_timeout_timeout() -> void:
	released.emit()
	start_counting = false
	extended_time = 0
	animation_player.play("ButtonUp")
