@tool
@icon("res://addons/xsm/icons/state_animation.png")
extends XSMFrogRope


func _on_update(delta: float) -> void:
	_update_rope_length(delta)
	_move(Vector2.ZERO)
	
	if not is_on_floor:
		change_state("swing", anchor)
	

func _on_tongue_detached() -> void:
	change_state("idle")
