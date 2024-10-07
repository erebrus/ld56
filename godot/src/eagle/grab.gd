extends State

var grab_sound_played:= false

func _on_enter(_args) -> void:
	target.grab_sfx.play(0.3)
	Events.frog_grabbed.emit()
	

func _on_update(delta) -> void:
	target.follow_player()
	target.move(delta)
	
	if target.claw.progress_ratio >= target.grab_end:
		change_state("leave")
	

func _on_exit(_args) -> void:
	target.sprite.texture = target.closed_texture
	
