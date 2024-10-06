@tool
@icon("res://addons/xsm/icons/state_animation.png")
extends XSMFrog
class_name XSMFrogRope

var reel_speed: float

var anchor: Vector2
var max_length: float
var max_length_squared: float


func _on_enter(args) -> void:
	anchor = args
	max_length = get_body().global_position.distance_to(anchor)
	max_length_squared = pow(max_length + 1, 2)
	
	reel_speed = get_body().reel_speed
	

func _update_rope_length(delta: float) -> void:
	if Input.is_action_pressed("move_down"):
		max_length += min(reel_speed * delta, get_body().head.tongue.max_length)
		
	if Input.is_action_pressed("move_up"):
		max_length -= reel_speed * delta
		max_length_squared = pow(max_length + 1, 2)
	

func _ensure_rope_length() -> void:
	get_body().global_position = anchor + anchor.direction_to(get_body().global_position) * max_length
	
