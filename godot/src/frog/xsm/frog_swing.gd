@tool
@icon("res://addons/xsm/icons/state_animation.png")
extends XSMFrog

var gravity: Vector2
var speed: Vector2
var reel_speed: float

var anchor: Vector2
var max_length: float
var max_length_squared: float


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
	
	if get_ctl().is_feet_on_ground():
		change_state("attached", anchor)
	
 
func _on_tongue_detached() -> void:
	get_ctl().set_x_acc()
	change_state("fall")
