extends State

var end_position: Vector2

func _on_enter(_args) -> void:
	var camera_position = Globals.player.global_position + Vector2(0, -200)
	var max_height = -100
	var screen_size = Vector2(1920, 1080)
	
	end_position = camera_position + Vector2(screen_size.x, -screen_size.y)
	target.grab_sfx.play(0.11)
	Events.frog_grabbed.emit()
	

func _on_update(delta) -> void:
	var motion = target.dive_speed * delta
	target.global_position = target.global_position.move_toward(end_position, motion)
	Globals.player.global_position = target.global_position
	if target.global_position.distance_squared_to(end_position) < 100:
		Globals.do_lose()
