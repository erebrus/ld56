@tool
@icon("res://addons/xsm/icons/state.png")
extends State


func _on_enter(_args) -> void:
	target.show()
	target.follow_player(Vector2(0, -200))
	

func _on_update(delta: float) -> void:
	target.move(delta)
	
	if target.claw.progress_ratio >= 1:
		change_state("disabled")
		

func _on_exit(_args) -> void:
	Events.eagle_left.emit()
	target.claw.progress_ratio = 0
	
