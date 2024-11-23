extends TongeState

var direction: Vector2


func _on_enter(_direction: Vector2) -> void:
	direction = _direction
	target.show()
	

func _on_update(delta: float) -> void:
	var new_position = target.global_position + delta * target.extension_speed * direction
	var squared_distance = new_position.distance_squared_to(head.tongue_marker.global_position)
	var max_distance = _get_max_distance()
	if squared_distance > pow(max_distance, 2):
		target.global_position = head.tongue_marker.global_position + head.tongue_marker.global_position.direction_to(new_position) * max_distance
		change_state("retracting")
		target.missed.emit()
		return
	else:
		target.global_position = new_position
	
	target.update_rope()
	
	if Input.is_action_just_pressed("left_click"):
		change_state("retracting")
		return
	

func _get_max_distance() -> float:
	if target.player.can_shoot:
		return target.max_length
	else:
		return target.enable_length - 5
	
