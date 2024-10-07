@tool
@icon("res://addons/xsm/icons/state_animation.png")
extends XSMFrog
class_name XSMFrogAutoHop

@export  var acc:float=15000
@export var direction:Types.HopDirection = 1
func _on_enter(_args) -> void:
	Logger.info("state:%s " % name)
	if target:
		target.state_name=name
	get_body().head.can_shoot=false
	get_body().velocity.y = -get_ctl().hop_velocity
	
func _after_enter(_args) -> void:
	pass
func _on_update(_delta) -> void:
	get_ctl().set_auto_acc(direction,acc)

	#if you hit the ground hop again
	if get_ctl().check_just_hit_ground(false):		
		get_body().velocity.y = -get_ctl().hop_velocity
		get_node(animation_player).play("hop")
	elif get_body().velocity.y<0:
		get_ctl().gravity = get_ctl().default_gravity
	else:
		get_ctl().gravity = get_ctl().apply_falling_gravity(get_ctl().default_gravity)

	get_ctl().process_movement(_delta)
func _after_update(_delta) -> void:
	pass
func _before_exit(_args) -> void:
	pass
func _on_exit(_args) -> void:
	get_body().head.can_shoot=true
func _on_timeout(_name) -> void:
	pass
