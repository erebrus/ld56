@tool
@icon("res://addons/xsm/icons/state_animation.png")
extends XSMFrogRope

var gravity: Vector2
var speed: Vector2
var last_velocity:Vector2
var has_played_sfx: bool = false

@export var acc_x_factor:float = 2.0
@export var max_x_speeed:float = 750

func _on_enter(args) -> void:
	super._on_enter(args)
	get_ctl().jumps_left=get_ctl().max_jump_amount
	gravity = get_body().swing_gravity * Vector2.DOWN
	speed = get_body().swing_speed * Vector2.RIGHT
	last_velocity = get_body().velocity
	

func _on_update(delta: float) -> void:
	var input = Input.get_axis("move_left", "move_right") * get_ctl().input_factor
	
	var velocity = last_velocity + gravity * delta + input * speed
	var direction = get_body().global_position.direction_to(anchor)
	var tangent = direction.normalized().rotated(PI/2)
	var length = velocity.dot(tangent)
	var new_velocity = length * tangent
	var new_direction = length / abs(length) * tangent
	
	if (last_velocity == Vector2.ZERO and new_velocity != Vector2.ZERO) or last_velocity.dot(new_velocity) < 0:
		# changed directions
		has_played_sfx = false
	
	if not has_played_sfx and abs(new_direction.dot(Vector2.RIGHT)) > 0.9:
		has_played_sfx = true
		var rope_length = get_body().global_position.distance_to(anchor)
		var max_rope_length = get_body().head.tongue.max_length
		var volume_factor = rope_length / max_rope_length
	
		target.sfx_swing.volume_db = linear_to_db(db_to_linear(6) * volume_factor) 
		target.sfx_swing.play()
		
	var motion = new_velocity * delta
	last_velocity = new_velocity
	
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
