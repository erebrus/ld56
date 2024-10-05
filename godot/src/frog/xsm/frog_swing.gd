@tool
@icon("res://addons/xsm/icons/state_animation.png")
extends XSMFrog

var gravity:= 1000 * Vector2.DOWN
var speed:= 5 * Vector2.RIGHT

var anchor: Vector2
var last_velocity:Vector2i

@export var acc_x_factor:float = 2.0
@export var max_x_speeed:float = 750

func _on_enter(args) -> void:
	anchor = args
	

func _on_update(delta: float) -> void:
	var input = Input.get_axis("move_left", "move_right")
	
	var velocity = get_body().velocity + gravity * delta + input * speed
	last_velocity = velocity
	var direction = get_body().global_position.direction_to(anchor)
	var tangent = direction.normalized().rotated(PI/2)
	var length = velocity.dot(tangent)
	get_body().velocity = length * tangent
	get_body().move_and_slide()
	
	get_ctl().check_direction_change(length)
	
	if get_ctl().is_feet_on_ground():
		change_state("attached", anchor)
	
 
func _on_tongue_detached() -> void:
	#Logger.info("Last v: %s" % last_velocity)
	get_ctl().set_x_acc()
	get_ctl().acc.x*=abs(last_velocity.x)/max_x_speeed *acc_x_factor
	#Logger.info("acc %s" % get_ctl().acc)
	change_state("fall")
