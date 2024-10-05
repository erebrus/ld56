@tool
@icon("res://addons/xsm/icons/state_animation.png")
extends StateAnimation
class_name XSMFrog


func _on_enter(_args) -> void:
	Logger.debug("state:%s " % name)

func _after_enter(_args) -> void:
	pass
func _on_update(_delta) -> void:
	pass
func _after_update(_delta) -> void:
	pass
func _before_exit(_args) -> void:
	pass
func _on_exit(_args) -> void:
	pass
func _on_timeout(_name) -> void:
	pass

func get_ctl()->FrogController:
	return target.controller
	
func get_body()->Frog:
	return target
