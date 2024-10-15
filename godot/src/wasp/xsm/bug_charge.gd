@tool
@icon("res://addons/xsm/icons/state_animation.png")
extends StateAnimation

@export var charge_time:float = 1
@export var rotation_speed:float = 2
var stunned:bool = false

func _on_enter(_args) -> void:
	Logger.info("wasp:%s " % name)
	var bug:Bug = target
	if bug.target == null:		
		change_state("move")
		return
	bug.speed=bug.charge_speed
	bug.sfx_fly.pitch_scale=1.1
	bug.velocity=	_get_direction_to_target()*bug.speed
	#Logger.info("charge start vector: %s" % bug.velocity)
	add_timer("charge",charge_time)

func _get_direction_to_target()->Vector2:
	var bug:Bug = target
	
	return ((bug.target.global_position+bug.target.sprite_offset)
					- (bug.global_position+bug.sting_offset)).normalized()
func _on_update(_delta) -> void:
	if stunned:
		return
	var bug:Bug = target
	if bug.target == null:		
		change_state("move")
		return
	bug.direction = sign(bug.target.global_position.x-bug.global_position.x)
	
	var desired_angle=_get_direction_to_target().angle()
	var current_angle= bug.velocity.angle()
	var new_angle = rotate_toward(current_angle, desired_angle, rotation_speed*_delta)
	bug.velocity = Vector2.RIGHT.rotated(new_angle)*bug.speed
	bug.move_and_slide()
		

func on_attack():
	Logger.info("Attacked")
	change_state("sting")

func _on_exit(_args):
	del_timer("charge")
	del_timer("stunned")
	
func on_stun():
	stunned=true
	add_timer("stunned",.1)
	
func _on_timeout(_name) -> void:
	Logger.info("timer:%s" % _name)
	if _name == "charge":
		Logger.info("Failed charge")
		change_state("prepare")
	if _name == "stunned":
		stunned=false
