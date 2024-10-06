@tool
@icon("res://addons/xsm/icons/state_animation.png")
extends XSMFrog

var gravity: Vector2
var speed: Vector2
var reel_speed: float

var anchor: Vector2
var max_length: float
var max_length_squared: float

var last_velocity:Vector2i

@export var acc_x_factor:float = 2.0
@export var max_x_speeed:float = 750

func _on_enter(args) -> void:
	anchor = args
	max_length = get_body().global_position.distance_to(anchor)
	max_length_squared = pow(max_length + 1, 2)
	
	gravity = get_body().swing_gravity * Vector2.DOWN
	speed = get_body().swing_speed * Vector2.RIGHT
	reel_speed = get_body().reel_speed
	

func _on_update(delta: float) -> void:
	var input = Input.get_axis("move_left", "move_right")
	
	var velocity = get_body().velocity + gravity * delta + input * speed
	last_velocity = velocity
	var direction = get_body().global_position.direction_to(anchor)
	var tangent = direction.normalized().rotated(PI/2)
	var length = velocity.dot(tangent)
	get_body().velocity = length * tangent
	get_body().move_and_slide()
	
	if Input.is_action_pressed("left_click"):
		max_length -= reel_speed * delta
		max_length_squared = pow(max_length + 1, 2)
		
	
	if get_body().global_position.distance_squared_to(anchor) > max_length_squared:
		get_body().global_position = anchor + anchor.direction_to(get_body().global_position) * max_length
		 
	get_ctl().check_direction_change(length)
	
	get_head().rotation = get_head().angle_to_point(anchor)
	
	if get_ctl().is_feet_on_ground():
		change_state("attached", anchor)
	
 
func _on_tongue_detached() -> void:
	get_head().rotation = 0
	#Logger.info("Last v: %s" % last_velocity)
	get_ctl().set_x_acc()
	get_ctl().acc.x*=abs(last_velocity.x)/max_x_speeed *acc_x_factor
	#Logger.info("acc %s" % get_ctl().acc)
	change_state("fall")
