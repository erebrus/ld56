@tool
@icon("res://addons/xsm/icons/state_animation.png")
extends XSMFrog

var reel_speed: float

var anchor: Vector2
var max_length: float
var max_length_squared: float


func _on_enter(args) -> void:
	anchor = args
	max_length = get_body().global_position.distance_to(anchor)
	max_length_squared = pow(max_length + 1, 2)
	
	reel_speed = get_body().reel_speed
	


func _on_update(delta: float) -> void:
	if Input.is_action_pressed("left_click"):
		max_length -= reel_speed * delta
		max_length_squared = pow(max_length + 1, 2)
	
	if get_body().global_position.distance_squared_to(anchor) > max_length_squared:
		get_body().global_position = anchor + anchor.direction_to(get_body().global_position) * max_length
	
	get_body().move_and_slide()
	
	if not get_ctl().is_feet_on_ground():
		change_state("swing", anchor)
	
 

func _on_tongue_detached() -> void:
	change_state("idle")
