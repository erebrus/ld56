@tool
@icon("res://addons/xsm/icons/state_animation.png")
extends StateAnimation

@export var lookout_time:float=3

func _on_enter(_args) -> void:
	add_timer("lookout",lookout_time)

func _on_exit(_args):
	del_timer("lookout")
	
func _on_timeout(_name) -> void:
	if _name == "lookout":
		target.next_wp()
		change_state("move")
