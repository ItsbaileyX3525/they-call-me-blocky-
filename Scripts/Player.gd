extends CharacterBody2D

@export var space_mode: bool = false

@onready var idle: Node2D = $PlayerTextures/Idle
@onready var walk_l: Node2D = $PlayerTextures/WalkL
@onready var walk_r: Node2D = $PlayerTextures/WalkR
@onready var jump: Node2D = $PlayerTextures/Jump
@onready var jump_walk_l: Node2D = $PlayerTextures/JumpWalkL
@onready var jump_walk_r: Node2D = $PlayerTextures/JumpWalkR
@onready var fall: Node2D = $PlayerTextures/Fall
@onready var fall_walk_l: Node2D = $PlayerTextures/FallWalkL
@onready var fall_walk_r: Node2D = $PlayerTextures/FallWalkR
@onready var blink_anim: AnimationPlayer = $PlayerTextures/Idle/Eyes/AnimationPlayer
@onready var afk_timer: Timer = $AFKTimer
@onready var blink_timer: Timer = $BlinkTimer

# Platformer mode constants
const GRAVITY: float = 1200.0
const MAX_SPEED: float = 450.0
const GROUND_ACCELERATION: float = 2000.0
const AIR_ACCELERATION: float = 1500.0
const GROUND_FRICTION: float = 2500.0
const AIR_FRICTION: float = 300.0
const JUMP_FORCE: float = -450.0

const COYOTE_TIME: float = 0.1
const JUMP_BUFFER_TIME: float = 0.1

@export var space_acceleration: float = 400.0
@export var space_max_speed: float = 300.0
@export var space_friction: float = 200.0

var coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0
var last_on_ground: bool = false

var input_direction: float = 0.0
var jump_pressed: bool = false
var jump_just_pressed: bool = false

var can_blink: bool = false

func _physics_process(delta: float) -> void:
	handle_input()

	if space_mode:
		handle_space_movement(delta)
	else:
		apply_gravity(delta)
		handle_horizontal_movement(delta)
		handle_jumping()
		update_timers(delta)

	move_and_slide()

func handle_input() -> void:
	input_direction = Input.get_axis("ui_left", "ui_right")
	jump_just_pressed = Input.is_action_just_pressed("ui_jump")
	jump_pressed = Input.is_action_pressed("ui_jump")

	if jump_just_pressed:
		jump_buffer_timer = JUMP_BUFFER_TIME

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta
		velocity.y = min(velocity.y, 1000.0)
	else:
		if velocity.y > 0:
			velocity.y = 0

func handle_horizontal_movement(delta: float) -> void:
	var accel = GROUND_ACCELERATION if is_on_floor() else AIR_ACCELERATION
	var friction = GROUND_FRICTION if is_on_floor() else AIR_FRICTION

	if input_direction != 0:
		afk_timer.stop()
		blink_timer.stop()
		can_blink = false
		idle.visible = false

		velocity.x = move_toward(velocity.x, input_direction * MAX_SPEED, accel * delta)

		if Input.is_action_pressed("ui_left"):
			if is_falling():
				fall_walk_l.visible = true
			elif is_rising():
				jump_walk_l.visible = true
			else:
				jump_walk_l.visible = false
				fall_walk_l.visible = false
				walk_l.visible = true
		elif Input.is_action_pressed("ui_right"):
			if is_falling():
				fall_walk_r.visible = true
			elif is_rising():
				jump_walk_r.visible = true
			else:
				jump_walk_r.visible = false
				fall_walk_r.visible = false
				walk_r.visible = true
	else:
		if afk_timer.is_stopped() and not can_blink:
			afk_timer.start()

		idle.visible = true
		walk_l.visible = false
		walk_r.visible = false
		jump_walk_l.visible = false
		jump_walk_r.visible = false
		fall_walk_l.visible = false
		fall_walk_r.visible = false

		velocity.x = move_toward(velocity.x, 0, friction * delta)

func handle_jumping() -> void:
	var can_jump = is_on_floor() or coyote_timer > 0.0

	if jump_buffer_timer > 0.0 and can_jump:
		velocity.y = JUMP_FORCE
		jump_buffer_timer = 0.0
		coyote_timer = 0.0

	if not jump_pressed and velocity.y < 0:
		velocity.y *= 0.6

func update_timers(delta: float) -> void:
	if is_on_floor():
		coyote_timer = COYOTE_TIME
		last_on_ground = true
	else:
		if last_on_ground:
			coyote_timer = COYOTE_TIME
			last_on_ground = false
		else:
			coyote_timer -= delta

	if jump_buffer_timer > 0.0:
		jump_buffer_timer -= delta

func handle_space_movement(delta: float) -> void:
	var input_vector := Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
	)

	# Reset all animations
	idle.visible = false
	walk_l.visible = false
	walk_r.visible = false
	jump.visible = false
	fall.visible = false
	jump_walk_l.visible = false
	jump_walk_r.visible = false
	fall_walk_l.visible = false
	fall_walk_r.visible = false

	if input_vector != Vector2.ZERO:
		input_vector = input_vector.normalized()
		velocity += input_vector * space_acceleration * delta
		velocity = velocity.limit_length(space_max_speed)

		# Stop blink timers on any movement
		afk_timer.stop()
		blink_timer.stop()
		can_blink = false

		# Show correct animation based on direction
		if input_vector.y < 0:
			jump.visible = true
		elif input_vector.y > 0:
			fall.visible = true
		elif input_vector.x < 0:
			walk_l.visible = true
		elif input_vector.x > 0:
			walk_r.visible = true
	else:
		# Apply friction and idle animation
		velocity = velocity.move_toward(Vector2.ZERO, space_friction * delta)

		if afk_timer.is_stopped() and not can_blink:
			afk_timer.start()

		idle.visible = true


func add_force(force: Vector2) -> void:
	velocity += force

func set_velocity_x(new_velocity_x: float) -> void:
	velocity.x = new_velocity_x

func set_velocity_y(new_velocity_y: float) -> void:
	velocity.y = new_velocity_y

func get_speed() -> float:
	return velocity.length()

func get_horizontal_speed() -> float:
	return abs(velocity.x)

func is_moving() -> bool:
	return velocity.length() > 10.0

func is_falling() -> bool:
	return velocity.y > 0 and not is_on_floor()

func is_rising() -> bool:
	return velocity.y < 0

func _on_afk_timer_timeout() -> void:
	can_blink = true
	blink_timer.wait_time = 0.7
	blink_timer.start()

func _on_blink_timer_timeout() -> void:
	if can_blink:
		blink_anim.play("Blink")
		blink_timer.wait_time = randf_range(2.6, 5.4)
		blink_timer.start()
