extends TongeState


func _on_enter(_args) -> void:
	Events.tongue_attached.emit(target.global_position)
	

func _on_update(_delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		change_state("retracting")
	
	target.update_rope()
	hide_if_retracted()
	

func _on_exit(_args) -> void:
	Events.tongue_detached.emit()
