@tool
@icon("res://addons/xsm/icons/state_animation.png")
extends XSMFrog
class_name XSMFrogIdle


func _on_enter(_args) -> void:
	Logger.info("state:%s " % name)
	if get_ctl():
		get_ctl().reset_jumps_left()
		get_ctl().acc.x=0
		#if we just started falling, do return because we will be changing state
		if get_ctl().check_just_started_falling():
			return
			
func _after_enter(_args) -> void:
	pass
func _on_update(_delta) -> void:
	#if we just started falling, do return because we will be changing state
	if get_ctl().check_just_started_falling():
		return
		

	
	var input:float = sign(Input.get_axis(get_ctl().input_left, get_ctl().input_right))
	get_ctl().check_direction_change(input)
	get_ctl().set_x_acc()
	
	if Input.is_action_pressed(get_ctl().input_jump):		
		Logger.info("jump is pressed %d" % Time.get_ticks_msec())
		if get_ctl().can_ground_jump():
			Logger.info("can jump")
			get_ctl().jump_requested.emit()
			return
		else:
			Logger.info("can't jump %d %d" % [get_ctl().jumps_left, get_ctl().current_jump_type])
				

	#if we're not jumping, check for hop, otherwise jump will be triggered by controller
	if not get_body().is_facing_wall() and input != 0:
		get_ctl().hop()
	get_ctl().process_movement(_delta)

func _after_update(_delta) -> void:
	pass
func _before_exit(_args) -> void:
	pass
func _on_exit(_args) -> void:
	pass
func _on_timeout(_name) -> void:
	pass
	
func _on_controller_jump_requested():
	Logger.info("Jump instance on idle")
	if get_ctl().can_ground_jump():
		get_ctl().jump()
		
