extends TongeState

var direction: Vector2


func _on_enter(_direction: Vector2) -> void:
	direction = _direction
	target.show()
	

func _on_update(delta: float) -> void:
	var new_position = target.global_position + delta * target.extension_speed * direction
	if new_position.distance_squared_to(head.tongue_position) > target.squared_length:
		target.global_position = head.tongue_position + head.tongue_position.direction_to(new_position) * target.max_length
		change_state("retracting")
		target.missed.emit()
		return
	else:
		target.global_position = new_position
	
	target.update_rope()
	
	if Input.is_action_just_pressed("left_click"):
		change_state("retracting")
		return
	
