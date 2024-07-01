extends CharacterBody2D

@export var movement_data : PlayerMovementData
@onready var sprite_2d = $Sprite2D
@onready var coyote_jump_timer = $CoyoteJumpTimer
@onready var starting_position = global_position

var air_jump = false
var double_jump_triggered = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Main Physics
func _physics_process(delta):
	var input_axis = Input.get_axis("left", "right")
	var was_on_floor = is_on_floor()
	
	# Handle Animations
	handle_running_flip_idle_anim(input_axis)	
	
	# Handle Movement and Gravity
	apply_gravity(delta)
	handle_jump()
	apply_acceleration(input_axis, delta)
	apply_air_resistance(input_axis, delta)
	apply_air_acceleration(input_axis, delta)
	apply_friction(input_axis, delta)
	
	move_and_slide()
	
	# Handle Coyote Jump
	var just_left_ledge = was_on_floor and not is_on_floor() and velocity.y >= 0
	if just_left_ledge:
		coyote_jump_timer.start()

	

# Movement and Gravity Functions
func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * movement_data.gravity_scale * delta
		if velocity.y < 0: # If character is moving upwards (jumping or double jumping)
			if double_jump_triggered:
				sprite_2d.animation = "Double Jump"
			else:
				sprite_2d.animation = "Jump"
		else: # If character is falling
			sprite_2d.animation = "Fall"
func handle_jump():
	if is_on_floor(): 	
		air_jump = true 
		double_jump_triggered = false
	
	if is_on_floor() or coyote_jump_timer.time_left > 0.0:
		if Input.is_action_pressed("up"):
			sprite_2d.animation = "Jump"
			velocity.y = movement_data.jump_velocity
			coyote_jump_timer.stop()
	elif not is_on_floor():
		if Input.is_action_just_released("up") and velocity.y < movement_data.jump_velocity / 2:
			velocity.y = movement_data.jump_velocity / 2 	
			
		if Input.is_action_just_pressed("up") and air_jump:
			double_jump_triggered = true
			velocity.y = movement_data.jump_velocity * 0.8
			air_jump = false
func apply_acceleration(input_axis, delta):
	if not is_on_floor(): return
	if input_axis != 0:
		velocity.x = move_toward(velocity.x, movement_data.speed * input_axis, movement_data.acceleration * delta)
func apply_air_acceleration(input_axis, delta):
	if is_on_floor(): return
	if input_axis != 0:
		velocity.x = move_toward(velocity.x, movement_data.speed * input_axis, movement_data.acceleration * delta)
func apply_friction(input_axis, delta):
	if input_axis == 0 and is_on_floor():
		velocity.x = move_toward(velocity.x, 0, movement_data.friction * delta)
func apply_air_resistance(input_axis, delta):
	if input_axis == 0 and not is_on_floor():
		velocity.x = move_toward(velocity.x, 0, movement_data.air_resistance * delta)


# Animation Functions
func handle_running_flip_idle_anim(input_axis):
	if input_axis !=0:
		sprite_2d.flip_h = (input_axis < 0)
		sprite_2d.animation = "Run"
	else:
		sprite_2d.animation = "Idle"

# Reset on contact with a hazard
func _on_hazard_detector_area_entered(_area):
	global_position = starting_position	
