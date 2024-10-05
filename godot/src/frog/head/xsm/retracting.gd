extends TongeState


func _on_update(delta: float) -> void:
	target.global_position = target.global_position.move_toward(head.tongue_position, delta * target.retraction_speed)
	target.update_rope()
	
	hide_if_retracted()
	
