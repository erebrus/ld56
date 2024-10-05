extends TongeState

func _on_enter(_args) -> void:
	target.show()
	

func _on_update(delta: float) -> void:
	var new_position = target.global_position + delta * target.extension_speed * target.direction
	if new_position.distance_squared_to(head.tongue_position) > target.squared_length:
		target.global_position = head.tongue_position + head.tongue_position.direction_to(new_position) * target.max_length
		change_state("retracting")
		return
	else:
		target.global_position = new_position
	
	target.update_rope()
	

func _on_exit(_args) -> void:
	target.retracted.emit()
