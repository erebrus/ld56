@tool
@icon("res://addons/xsm/icons/state_animation.png")
extends XSMFrog
class_name XSMFrogIdle


func _on_enter(_args) -> void:
	Logger.info("state:%s " % name)
	if get_ctl():
		#TODO check if there is a better location for this
		get_ctl().reset_jumps_left()
		get_ctl().acc.x=0
		#var input:float = sign(Input.get_axis(get_ctl().input_left, get_ctl().input_right))
		#get_body().velocity.x = input * get_ctl().x_speed
		get_ctl().set_x_acc()
		##if we're not jumping, check for hop, otherwise jump will be triggered by controller
		#if get_ctl().check_process_jump_input():	
			#return
		
		#TODO this is here for the jump buffer on hopping. double check.
		if get_ctl().is_jump_buffer_timer_running() and not get_ctl().can_hold_jump: 
			get_ctl().jump()	
			Logger.info("Buffer jump")
		elif (get_ctl().is_falling() or not get_body().is_on_floor()) :
			get_ctl().started_falling.emit()
			
func _after_enter(_args) -> void:
	pass
func _on_update(_delta) -> void:
	if not get_body().is_on_floor() or get_ctl().is_falling():
		get_ctl().started_falling.emit()
		return
		

	
	var input:float = sign(Input.get_axis(get_ctl().input_left, get_ctl().input_right))
	get_ctl().check_direction_change(input)
	#get_body().velocity.x = input * get_ctl().x_speed
	get_ctl().set_x_acc()
	#if we're not jumping, check for hop, otherwise jump will be triggered by controller
	if not get_ctl().check_process_jump_input() and not get_body().is_facing_wall():	
		if input != 0:
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
	get_ctl().check_jump_input()
		 
