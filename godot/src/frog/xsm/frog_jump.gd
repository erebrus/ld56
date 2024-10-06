@tool
@icon("res://addons/xsm/icons/state_animation.png")
extends XSMFrog
class_name XSMFrogJump


var lifted:=false
func _on_enter(_args) -> void:
	Logger.info("state:%s " % name)
	if target:
		target.state_name=name
	lifted=false
func _after_enter(_args) -> void:
	pass
func _on_update(_delta) -> void:
	#if we just started falling, do return because we will be changing state
	if get_ctl().check_just_started_falling():
		return
	if lifted and get_ctl().is_feet_on_ground():
		change_state("idle")
		return
		
	get_ctl().gravity = get_ctl().default_gravity
	if Input.is_action_just_pressed(get_ctl().input_jump):
		if get_ctl().can_double_jump():
			get_ctl().jump()
			return
	elif not Input.is_action_pressed(get_ctl().input_jump): 
		get_ctl().gravity = get_ctl().apply_release_gravity(get_ctl().gravity)	
	
	get_ctl().set_x_acc()
	get_ctl().process_movement(_delta)
	lifted=true
	Logger.debug("new velocity %.2f  acc %s" % [get_body().velocity.x, get_ctl().acc])

func _after_update(_delta) -> void:
	pass
func _before_exit(_args) -> void:
	pass
func _on_exit(_args) -> void:
	pass
func _on_timeout(_name) -> void:
	pass
