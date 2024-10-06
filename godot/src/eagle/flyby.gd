@tool
@icon("res://addons/xsm/icons/state.png")
extends State


func _on_enter(_args) -> void:
	var camera_position = Globals.player.global_position + Vector2(0, -200)
	var max_height = -100
	var screen_size = Vector2(1920, 1080)
	
	var start_position = camera_position - screen_size
	var dive1 = camera_position + Vector2(-screen_size.x / 3, max_height)
	var dive2 = camera_position + Vector2(screen_size.x / 3, max_height)
	var end_position = camera_position + Vector2(screen_size.x, -screen_size.y)
	
	target.global_position = start_position
	target.show()
	var tween = create_tween()
	tween.tween_property(target, "global_position", dive1, 0.4).set_ease(Tween.EASE_OUT)
	tween.tween_property(target, "global_position", dive2, 0.5)
	tween.tween_property(target, "global_position", end_position, 0.4).set_ease(Tween.EASE_IN)
	
	await tween.finished
	
	change_state("waiting")
