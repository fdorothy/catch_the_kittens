extends CharacterBody2D

const MAX_SPEED = 200.0
const ACCEL = 350.0
const DEACCEL = 600.0
const MIDDLE = 0.0

@export var jump_height : float
@export var jump_time_to_peak : float
@export var jump_time_to_descent : float

@onready var jump_velocity : float = (-2.0 * jump_height) / jump_time_to_peak
@onready var jump_gravity : float = (2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)
@onready var fall_gravity : float = (2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)

var is_jumping : bool = false

func get_gravity_scalar() -> float:
	return jump_gravity if is_jumping else fall_gravity

func is_below() -> bool:
	return MIDDLE < position.y

func _physics_process(delta: float) -> void:
	
	var gravity = get_gravity_scalar()
	
	if is_jumping:
		if is_on_floor() or is_on_ceiling():
			is_jumping = false
		if is_below() and velocity.y < 0.0:
			is_jumping = false
		if not is_below() and velocity.y > 0.0:
			is_jumping = false
	
	if is_below():
		gravity = -gravity
	
		# Add the gravity.
		if not is_on_ceiling():
			velocity.y += gravity * delta

		# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_ceiling():
			jump(-1)
			
		$AnimatedSprite2D.flip_v = true
	else:
		if not is_on_floor():
			velocity.y += gravity * delta
			
		if Input.is_action_just_pressed("jump") and is_on_floor():
			jump()
		
		$AnimatedSprite2D.flip_v = false

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = move_toward(velocity.x, direction * MAX_SPEED, ACCEL * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, DEACCEL * delta)

	move_and_slide()

func jump(multiplier = 1):
	velocity.y = jump_velocity * multiplier
	is_jumping = true
