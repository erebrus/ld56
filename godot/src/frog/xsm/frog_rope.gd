@tool
@icon("res://addons/xsm/icons/state_animation.png")
extends XSMFrog
class_name XSMFrogRope

var reel_speed: float

var anchor: Vector2
var max_length: float
var is_on_floor: bool

func _on_enter(args) -> void:
	anchor = args
	max_length = get_body().global_position.distance_to(anchor)
	
	reel_speed = get_body().reel_speed
	

func _update_rope_length(delta: float) -> void:
	if Input.is_action_pressed("move_down"):
		max_length += min(reel_speed * delta, get_body().head.tongue.max_length)
		
	if Input.is_action_pressed("move_up"):
		max_length -= reel_speed * delta
	

func _move(motion: Vector2) -> void:
	var desired_position = get_body().global_position + motion
	var new_position = anchor + anchor.direction_to(desired_position) * max_length
	get_body().move_and_collide(new_position - get_body().global_position)
	
	is_on_floor = get_body().is_near_floor()
	
		
	
