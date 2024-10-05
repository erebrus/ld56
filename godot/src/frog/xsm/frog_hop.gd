@tool
@icon("res://addons/xsm/icons/state_animation.png")
extends XSMFrog
class_name XSMFrogHop


func _on_enter(_args) -> void:
	Logger.info("state:%s " % name)

func _after_enter(_args) -> void:
	pass
func _on_update(_delta) -> void:
	#TODO move to contrller?
	if not get_ctl()._was_falling and get_ctl().is_falling():
		get_ctl().started_falling.emit()
		return
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
