@tool
@icon("res://addons/xsm/icons/state_animation.png")
extends XSMFrog
class_name XSMFrogJump



func _on_enter(_args) -> void:
	Logger.debug("state:%s " % name)

func _after_enter(_args) -> void:
	pass
func _on_update(_delta) -> void:
	#TODO move to contrller?
	if not get_ctl()._was_falling and get_ctl().is_falling():
		get_ctl().started_falling.emit()
		return
	get_ctl().gravity = get_ctl().default_gravity
	if not Input.is_action_pressed(get_ctl().input_jump): 
		get_ctl().gravity = get_ctl().apply_release_gravity(get_ctl().gravity)	
	get_ctl().set_x_acc()
	get_ctl().process_movement(_delta)
	Logger.debug("new velocity %.2f  acc %s" % [get_body().velocity.x, get_ctl().acc])

func _after_update(_delta) -> void:
	pass
func _before_exit(_args) -> void:
	pass
func _on_exit(_args) -> void:
	pass
func _on_timeout(_name) -> void:
	pass
