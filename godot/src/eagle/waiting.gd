@tool
extends State

func _on_enter(_args) -> void:
	Logger.info("Eagle about to attack!")
	target.follow_player()
	Events.eagle_incoming.emit()
	target.warning_sfx.play()
	
	get_tree().create_timer(target.warning_time).timeout.connect(_on_random_timer_timeout)
	

func _on_update(_delta) -> void:
	target.follow_player()
	

func _on_random_timer_timeout() -> void:
	if is_active("waiting"):
		target.fly_by()
	
