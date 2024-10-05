extends TongeState


func _on_update(delta: float) -> void:
	target.global_position = target.global_position.move_toward(head.tongue_position, delta * target.retraction_speed)
	
	if target.global_position.distance_squared_to(head.tongue_position) < 10:
		target.global_position = head.tongue_position
		change_state("hidden")
		return
	
	target.update_rope()
