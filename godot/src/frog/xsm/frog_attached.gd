@tool
@icon("res://addons/xsm/icons/state_animation.png")
extends XSMFrogRope


func _on_update(delta: float) -> void:
	_update_rope_length(delta)
	_ensure_rope_length()
	
	get_body().move_and_slide()
	
	if not get_ctl().is_feet_on_ground():
		change_state("swing", anchor)
	

func _on_tongue_detached() -> void:
	change_state("idle")
