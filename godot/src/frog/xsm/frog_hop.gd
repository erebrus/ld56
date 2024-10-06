@tool
@icon("res://addons/xsm/icons/state_animation.png")
extends XSMFrog
class_name XSMFrogHop


func _on_enter(_args) -> void:
	Logger.info("state:%s %d" % [name, Time.get_ticks_msec()])

func _after_enter(_args) -> void:
	pass
func _on_update(_delta) -> void:
	if get_ctl().check_just_hit_ground():
		return
	
	#if we just started falling, do return because we will be changing state
	if get_ctl().check_just_started_falling():
		return
	get_ctl().set_x_acc()
	get_ctl().gravity = get_ctl().default_gravity
	get_ctl().process_movement(_delta)
func _after_update(_delta) -> void:
	pass
func _before_exit(_args) -> void:
	pass
func _on_exit(_args) -> void:
	pass
func _on_timeout(_name) -> void:
	pass
