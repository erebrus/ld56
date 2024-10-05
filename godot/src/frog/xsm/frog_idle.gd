@tool
@icon("res://addons/xsm/icons/state_animation.png")
extends XSMFrog
class_name XSMFrogIdle


func _on_enter(_args) -> void:
	Logger.info("state:%s " % name)
	if get_ctl():
		get_ctl().reset_jumps_left()
		get_ctl().acc.x=0
		if (get_ctl().is_falling() or not get_body().is_on_floor()) :
			get_ctl().started_falling.emit()
			
func _after_enter(_args) -> void:
	pass
func _on_update(_delta) -> void:
	if not get_body().is_on_floor() or get_ctl().is_falling():
		get_ctl().started_falling.emit()
		return
		

	
	var input:float = sign(Input.get_axis(get_ctl().input_left, get_ctl().input_right))
	get_ctl().check_direction_change(input)
	get_ctl().set_x_acc()
	
	if Input.is_action_pressed(get_ctl().input_jump):
		if get_ctl().can_ground_jump():
			get_ctl().jump_requested.emit()
			return
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
	if get_ctl().can_ground_jump() or get_ctl().can_double_jump():
		get_ctl().jump()
		