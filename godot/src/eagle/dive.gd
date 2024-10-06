extends State

func _on_enter(_args) -> void:
	var camera_position = Globals.player.global_position + Vector2(0, -200)
	var max_height = -100
	var screen_size = Vector2(1920, 1080)
	
	target.global_position = camera_position - screen_size
	target.show()
	

func _on_update(delta) -> void:
	var motion = target.dive_speed * delta
	target.global_position = target.global_position.move_toward(Globals.player.global_position, motion)
	
	if target.global_position.distance_squared_to(Globals.player.global_position) < 100:
		change_state("grab")
