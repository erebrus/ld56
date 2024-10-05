extends Node

class_name FrogController

signal jump_requested()
signal jumped(is_ground_jump: bool)
signal hopped()
signal hit_ground()
signal started_falling()
signal direction_changed()


# Set these to the name of your action (in the Input Map)
## Name of input action to move up.
#@export var input_up : String = "move_up"
### Name of input action to move down.
#@export var input_down : String = "move_down"
### Name of input action to move left.
@export var input_left : String = "move_left"
## Name of input action to move right.
@export var input_right : String = "move_right"
## Name of input action to jump.
@export var input_jump : String = "jump"


const DEFAULT_HOP_HEIGHT = 80
const DEFAULT_MAX_JUMP_HEIGHT = 150
const DEFAULT_MIN_JUMP_HEIGHT = 60
const DEFAULT_DOUBLE_JUMP_HEIGHT = 100
const DEFAULT_JUMP_DURATION = 0.3
const DEFAULT_HOP_DURATION = 0.15

var _max_jump_height: float = DEFAULT_MAX_JUMP_HEIGHT
## The max jump height in pixels (holding jump).
@export var max_jump_height: float = DEFAULT_MAX_JUMP_HEIGHT: 
	get:
		return _max_jump_height
	set(value):
		_max_jump_height = value
	
		default_gravity = calculate_gravity(_max_jump_height, jump_duration)
		jump_velocity = calculate_jump_velocity(_max_jump_height, jump_duration)
		double_jump_velocity = calculate_jump_velocity2(double_jump_height, default_gravity)
		release_gravity_multiplier = calculate_release_gravity_multiplier(
				jump_velocity, min_jump_height, default_gravity)
			


var _hop_height: float = DEFAULT_HOP_HEIGHT
## The hop height (moving).
@export var hop_height: float = DEFAULT_HOP_HEIGHT: 
	get:
		return _hop_height
	set(value):
		_hop_height = value
		hop_velocity = calculate_jump_velocity(_hop_height, default_gravity)

		#release_gravity_multiplier = calculate_release_gravity_multiplier(
				#jump_velocity, min_jump_height, default_gravity)
				
var _min_jump_height: float = DEFAULT_MIN_JUMP_HEIGHT
## The minimum jump height (tapping jump).
@export var min_jump_height: float = DEFAULT_MIN_JUMP_HEIGHT: 
	get:
		return _min_jump_height
	set(value):
		_min_jump_height = value
		release_gravity_multiplier = calculate_release_gravity_multiplier(
				jump_velocity, min_jump_height, default_gravity)



var _double_jump_height: float = DEFAULT_DOUBLE_JUMP_HEIGHT
## The height of your jump in the air.
@export var double_jump_height: float = DEFAULT_DOUBLE_JUMP_HEIGHT:
	get:
		return _double_jump_height
	set(value):
		_double_jump_height = value
		double_jump_velocity = calculate_jump_velocity2(double_jump_height, default_gravity)
		
var _hop_duration: float = DEFAULT_HOP_DURATION
## How long it takes to get to the peak of the jump in seconds.
@export var hop_duration: float = DEFAULT_JUMP_DURATION:
	get:
		return _hop_duration
	set(value):
		_hop_duration = value
		hop_velocity = calculate_jump_velocity(hop_height, hop_duration)
				
var _jump_duration: float = DEFAULT_JUMP_DURATION
## How long it takes to get to the peak of the jump in seconds.
@export var jump_duration: float = DEFAULT_JUMP_DURATION:
	get:
		return _jump_duration
	set(value):
		_jump_duration = value
	
		default_gravity = calculate_gravity(max_jump_height, jump_duration)
		jump_velocity = calculate_jump_velocity(max_jump_height, jump_duration)
		double_jump_velocity = calculate_jump_velocity2(double_jump_height, default_gravity)
		release_gravity_multiplier = calculate_release_gravity_multiplier(
				jump_velocity, min_jump_height, default_gravity)
		
## Multiplies the gravity by this while falling.
@export var falling_gravity_multiplier = 1.5
## Amount of jumps allowed before needing to touch the ground again. Set to 2 for double jump.
@export var max_jump_amount = 1
@export var max_acceleration = 10000
@export var friction = 20
@export var can_hold_jump : bool = false
## You can still jump this many seconds after falling off a ledge.
@export var coyote_time : float = 0.1
## Pressing jump this many seconds before hitting the ground will still make you jump.
## Only neccessary when can_hold_jump is unchecked.
@export var jump_buffer : float = 0.1
@export var x_speed :float = 100

# These will be calcualted automatically
# Gravity will be positive if it's going down, and negative if it's going up
var default_gravity : float
var jump_velocity : float
var double_jump_velocity : float
var hop_velocity : float
# Multiplies the gravity by this when we release jump
var release_gravity_multiplier : float


var jumps_left : int
var holding_jump := false

enum JumpType {NONE, GROUND, AIR}
## The type of jump the player is performing. Is JumpType.NONE if they player is on the ground.
var current_jump_type: JumpType = JumpType.NONE

# Used to detect if player just hit the ground
var _was_on_ground: bool
var _was_falling: bool
var _was_moving: bool
var gravity:float

var acc = Vector2()
var last_direction:=Vector2.RIGHT
# coyote_time and jump_buffer must be above zero to work. Otherwise, godot will throw an error.
@onready var is_coyote_time_enabled = coyote_time > 0
@onready var is_jump_buffer_enabled = jump_buffer > 0
@onready var coyote_timer = Timer.new()
@onready var jump_buffer_timer = Timer.new()


func _init():
	default_gravity = calculate_gravity(max_jump_height, jump_duration)
	hop_velocity = calculate_jump_velocity(hop_height, hop_duration)
	jump_velocity = calculate_jump_velocity(max_jump_height, jump_duration)
	double_jump_velocity = calculate_jump_velocity2(double_jump_height, default_gravity)
	release_gravity_multiplier = calculate_release_gravity_multiplier(
			jump_velocity, min_jump_height, default_gravity)


func _ready():
	#if is_coyote_time_enabled:
		#add_child(coyote_timer)
		#coyote_timer.wait_time = coyote_time
		#coyote_timer.one_shot = true
	
	if is_jump_buffer_enabled:
		add_child(jump_buffer_timer)
		jump_buffer_timer.wait_time = jump_buffer
		jump_buffer_timer.one_shot = true
		jump_buffer_timer.timeout.connect(func(): Logger.info("buffer timeout at %d" % Time.get_ticks_msec()))
		Logger.info("jump buffer timeout set to %.2f" % jump_buffer)



func _input(e):
	if Input.is_action_just_pressed(input_jump):
		holding_jump=true
		start_jump_buffer_timer()
		Logger.info("Started jump buffer at %d" % Time.get_ticks_msec())
		jump_requested.emit()		

	elif Input.is_action_pressed(input_jump):
		holding_jump=true
	if Input.is_action_just_released(input_jump):
		holding_jump = false
		
func check_jump_input()->bool:
	if Input.is_action_just_pressed(input_jump):
		holding_jump = true
		start_jump_buffer_timer()
		if (not can_hold_jump and can_ground_jump()) or can_double_jump():
			jump()
			return true
		
	
	return false

func get_body()->CharacterBody2D:
	return get_parent() as CharacterBody2D

func set_x_acc():
	acc.x = 0
	var input = Input.get_axis(input_left, input_right)
	acc.x = sign(input)*max_acceleration
		
		
	check_direction_change(input)

func check_direction_change(input:float):
	if input!=0:
		last_direction=Vector2(sign(input),0)
		direction_changed.emit()

func reset_jumps_left():
	if current_jump_type == JumpType.NONE:
			jumps_left = max_jump_amount
#func pre_jump_process(delta):
	#if current_jump_type == JumpType.NONE:
		#jumps_left = max_jump_amount
	#
	## Check if we just hit the ground this frame
	#if not _was_on_ground and is_feet_on_ground():
		#current_jump_type = JumpType.NONE
		#if is_jump_buffer_timer_running() and not can_hold_jump: 
			#jump()		
		#hit_ground.emit()
	#else:
		#if not _was_falling and is_falling():
			#started_falling.emit()


			
	#print("speed:%.2f %s %s" % [get_body().velocity.x, _was_moving, is_moving()])
	#print("speed:%.2f %s %s [floor: %s %s]" % [get_body().velocity.y, _was_falling, is_falling(), _was_on_ground, is_feet_on_ground()])

func check_process_jump_input():
	# Cannot do this in _input because it needs to be checked every frame
	if Input.is_action_pressed(input_jump):
		if can_ground_jump() and can_hold_jump:
			jump()
			return true
	return false

func process_movement(delta):	
	_was_falling = is_falling()
	_was_moving = is_moving()
	
	acc.y = gravity
	
	# Apply friction
	get_body().velocity.x *= 1 / (1 + (delta * friction))
	get_body().velocity += acc * delta
	
	_was_on_ground = is_feet_on_ground()
	
	#var v = get_body().velocity

	get_body().move_and_slide()
	

func is_moving()->bool:
	return abs(get_body().velocity.x) > 100.0
func is_falling()->bool:
	return 	get_body().velocity.y>0 and not is_feet_on_ground()

## Use this instead of coyote_timer.start() to check if the coyote_timer is enabled first
func start_coyote_timer():
	if is_coyote_time_enabled:
		coyote_timer.start()

## Use this instead of jump_buffer_timer.start() to check if the jump_buffer is enabled first
func start_jump_buffer_timer():
	if is_jump_buffer_enabled:
		jump_buffer_timer.start()

## Use this instead of `not coyote_timer.is_stopped()`. This will always return false if 
## the coyote_timer is disabled
func is_coyote_timer_running():
	if (is_coyote_time_enabled and not coyote_timer.is_stopped()):
		return true
	
	return false

## Use this instead of `not jump_buffer_timer.is_stopped()`. This will always return false if 
## the jump_buffer_timer is disabled
func is_jump_buffer_timer_running():
	if is_jump_buffer_enabled and not jump_buffer_timer.is_stopped():
		return true
	
	return false


func can_ground_jump() -> bool:
	if jumps_left > 0 and current_jump_type == JumpType.NONE:
		return true
	elif is_coyote_timer_running():
		return true
	
	return false


func can_double_jump():
	if jumps_left <= 1 and jumps_left == max_jump_amount:
		# Special case where you've fallen off a cliff and only have 1 jump. You cannot use your
		# first jump in the air
		return false
	
	if jumps_left > 0 and not is_feet_on_ground() and coyote_timer.is_stopped():
		return true
	
	return false


## Same as is_on_floor(), but also returns true if gravity is reversed and you are on the ceiling
func is_feet_on_ground():
	if get_body().is_on_floor() and default_gravity >= 0:
		return true
	if get_body().is_on_ceiling() and default_gravity <= 0:
		return true
	
	return false


## Perform a ground jump, or a double jump if the character is in the air.
func jump():
	if can_double_jump():
		double_jump()
	else:
		ground_jump()


## Perform a double jump without checking if the player is able to.
func double_jump():
	if jumps_left == max_jump_amount:
		# Your first jump must be used when on the ground.
		# If your first jump is used in the air, an additional jump will be taken away.
		jumps_left -= 1
	
	get_body().velocity.y = -double_jump_velocity
	current_jump_type = JumpType.AIR
	jumps_left -= 1
	jumped.emit(false)


## Perform a ground jump without checking if the player is able to.
func ground_jump():
	get_body().velocity.y = -jump_velocity
	current_jump_type = JumpType.GROUND
	jumps_left -= 1
	#coyote_timer.stop()
	jumped.emit(true)


func hop():
	get_body().velocity.y = -hop_velocity
	hopped.emit()
	
func apply_falling_gravity(_gravity):
	_gravity *= falling_gravity_multiplier
	return _gravity
func apply_release_gravity(_gravity):
	_gravity *= release_gravity_multiplier # multiply the gravity so we have a lower jump
	return _gravity

#func apply_gravity_multipliers_to(gravity) -> float:
	#if get_body().velocity.y * sign(default_gravity) > 0: # If we are falling
		#gravity *= falling_gravity_multiplier
	#
	## if we released jump and are still rising
	#elif get_body().velocity.y * sign(default_gravity) < 0:
		#if not holding_jump: 
			#if not current_jump_type == JumpType.AIR: # Always jump to max height when we are using a double jump
				#gravity *= release_gravity_multiplier # multiply the gravity so we have a lower jump
	#
	#
	#return gravity


## Calculates the desired gravity from jump height and jump duration.  [br]
## Formula is from [url=https://www.youtube.com/watch?v=hG9SzQxaCm8]this video[/url] 
func calculate_gravity(p_max_jump_height, p_jump_duration):
	return (2 * p_max_jump_height) / pow(p_jump_duration, 2)


## Calculates the desired jump velocity from jump height and jump duration.
func calculate_jump_velocity(p_max_jump_height, p_jump_duration):
	return (2 * p_max_jump_height) / (p_jump_duration)


## Calculates jump velocity from jump height and gravity.  [br]
## Formula from 
## [url]https://sciencing.com/acceleration-velocity-distance-7779124.html#:~:text=in%20every%20step.-,Starting%20from%3A,-v%5E2%3Du[/url]
func calculate_jump_velocity2(p_max_jump_height, p_gravity):
	return sqrt(abs(2 * p_gravity * p_max_jump_height)) * sign(p_max_jump_height)


## Calculates the gravity when the key is released based off the minimum jump height and jump velocity.  [br]
## Formula is from [url]https://sciencing.com/acceleration-velocity-distance-7779124.html[/url]
func calculate_release_gravity_multiplier(p_jump_velocity, p_min_jump_height, p_gravity):
	var release_gravity = pow(p_jump_velocity, 2) / (2 * p_min_jump_height)
	return release_gravity / p_gravity


## Returns a value for friction that will hit the max speed after 90% of time_to_max seconds.  [br]
## Formula from [url]https://www.reddit.com/r/gamedev/comments/bdbery/comment/ekxw9g4/?utm_source=share&utm_medium=web2x&context=3[/url]
func calculate_friction(time_to_max):
	return 1 - (2.30259 / time_to_max)


## Formula from [url]https://www.reddit.com/r/gamedev/comments/bdbery/comment/ekxw9g4/?utm_source=share&utm_medium=web2x&context=3[/url]
func calculate_speed(p_max_speed, p_friction):
	return (p_max_speed / p_friction) - p_max_speed
