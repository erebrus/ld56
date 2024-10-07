@tool
@icon("res://addons/xsm/icons/state_animation.png")
extends XSMFrog
class_name XSMDeath

func _on_update(_delta) -> void:

	get_ctl().gravity = get_ctl().apply_falling_gravity(get_ctl().default_gravity)
	get_ctl().process_movement(_delta)
func _on_enter(_args) -> void:
	Logger.debug("state:%s " % name)
	#await get_tree().create_timer(.1).timeout
	#get_body().xsm.disabled=true
	
