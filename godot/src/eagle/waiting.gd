@tool
@icon("res://addons/xsm/icons/state.png")
extends State

func _on_enter(_args) -> void:
	target.hide()
	
	var time = randf_range(target.min_time_between_fly_bys, target.max_time_between_fly_bys)
	get_tree().create_timer(time).timeout.connect(_on_random_timer_timeout)
	
	

func _on_update(_delta) -> void:
	target.global_position = Globals.player.global_position
	

func _on_random_timer_timeout() -> void:
	if is_active("waiting"):
		target.fly_by()
	
