@tool
@icon("res://addons/xsm/icons/state_animation.png")
extends StateAnimation

@export var prepare_time:float=1

func _on_enter(_args) -> void:
	Logger.info("wasp:%s " % name)
	add_timer("prepare",prepare_time)

func _on_exit(_args):
	del_timer("prepare")
	
func _on_timeout(_name) -> void:
	if _name == "prepare":
		target.next_wp()
		change_state("charge")
