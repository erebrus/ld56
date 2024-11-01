@tool
extends State

var end_position: Vector2

func _on_enter(_args) -> void:
	var camera_position = Globals.player.global_position + Vector2(0, -200)
	var screen_size = Vector2(1920, 1080)
	
	end_position = camera_position + Vector2(screen_size.x, -screen_size.y)
	

func _on_update(delta) -> void:
	target.move(delta)
	Globals.player.global_position = target.claw.global_position
	
	if target.claw.progress_ratio >= 1:
		Events.game_lost.emit(Types.LossType.BIRD)
