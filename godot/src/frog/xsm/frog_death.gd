@tool
@icon("res://addons/xsm/icons/state_animation.png")
extends XSMFrog
class_name XSMDeath


func _on_enter(_args) -> void:
	Logger.debug("state:%s " % name)
	await get_tree().create_timer(.1).timeout
	get_body().xsm.disabled=true
	
