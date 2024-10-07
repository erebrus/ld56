@tool
@icon("res://addons/xsm/icons/state.png")
extends State


func _on_enter(_args) -> void:
	target.hide()
	
	var time = randf_range(target.min_time_between_fly_bys, target.max_time_between_fly_bys)
	await get_tree().create_timer(time).timeout
	target.fly_by()
	

func _on_update(_delta) -> void:
	target.global_position = Globals.player.global_position
