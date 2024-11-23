extends TongeState


func _on_update(delta: float) -> void:
	if not is_instance_valid(target) or not is_instance_valid(head):
		return
	
	target.global_position = target.global_position.move_toward(head.tongue_marker.global_position, delta * target.retraction_speed)
	target.update_rope()
	
	hide_if_retracted()
	
