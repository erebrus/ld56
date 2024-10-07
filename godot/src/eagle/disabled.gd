extends State


func _on_enter(_args) -> void:
	target.hide()
	
	if target.enabled:
		var time = randf_range(target.min_time_between_fly_bys, target.max_time_between_fly_bys)
		get_tree().create_timer(time).timeout.connect(_on_random_timer_timeout)
	

func _on_update(_delta) -> void:
	target.follow_player()
	

func _on_random_timer_timeout() -> void:
	if is_active("disabled"):
		change_state("waiting")
