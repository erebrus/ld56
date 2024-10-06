@tool
@icon("res://addons/xsm/icons/state_animation.png")
extends StateAnimation


func _on_update(_delta) -> void:
	var bug:Bug = target
	var wp = bug.waypoints[bug.wp_idx]
	bug.direction = sign(wp.x-bug.global_position.x)
	var target_pos = bug.global_position.move_toward(wp,bug.speed*_delta)
	bug.global_position = target_pos
	if bug.global_position == bug.waypoints[bug.wp_idx]:		
		change_state("idle")
	
