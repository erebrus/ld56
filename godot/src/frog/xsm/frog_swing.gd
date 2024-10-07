@tool
@icon("res://addons/xsm/icons/state_animation.png")
extends XSMFrogRope

var gravity: Vector2
var speed: Vector2
var last_velocity:Vector2

@export var acc_x_factor:float = 2.0
@export var max_x_speeed:float = 750

func _on_enter(args) -> void:
	super._on_enter(args)
	get_ctl().jumps_left=get_ctl().max_jump_amount
	gravity = get_body().swing_gravity * Vector2.DOWN
	speed = get_body().swing_speed * Vector2.RIGHT
	last_velocity = get_body().velocity
	

func _on_update(delta: float) -> void:
	var input = Input.get_axis("move_left", "move_right")
	
	var velocity = last_velocity + gravity * delta + input * speed
	var direction = get_body().global_position.direction_to(anchor)
	var tangent = direction.normalized().rotated(PI/2)
	var length = velocity.dot(tangent)
	last_velocity = length * tangent
	var motion = last_velocity * delta
	
	_update_rope_length(delta)
	_move(motion)
	get_ctl().check_direction_change(length)
	
	if is_on_floor:
		change_state("attached", anchor)
	
 
func _on_tongue_detached() -> void:
	#Logger.info("Last v: %s" % last_velocity)
	get_ctl().set_x_acc()
	get_ctl().acc.x*=abs(last_velocity.x)/max_x_speeed *acc_x_factor
	#Logger.info("acc %s" % get_ctl().acc)
	# because we are on air, this jump would be considered a double jump otherwise
	get_ctl().ground_jump()
