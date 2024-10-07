extends State

func _on_enter(_args) -> void:
	target.show()
	

func _on_update(delta) -> void:
	target.follow_player()
	target.move(delta)
	
	if target.claw.progress_ratio >= target.grab_start:
		change_state("grab")
