@tool
@icon("res://addons/xsm/icons/state_animation.png")
extends StateAnimation

var old_direction: int

func _on_update(_delta) -> void:
	var bug:Bug = target
	
	var wp = bug.waypoints[bug.wp_idx]
	bug.direction = sign(wp.x-bug.global_position.x)
	
	var vertical_direction = sign(wp.y-bug.global_position.y)
	if vertical_direction != old_direction:
		if vertical_direction > 0:
			play("idle")
		else:
			play("move")
		old_direction = vertical_direction
	
	var speed = bug.speed
	if vertical_direction > 0:
		speed = speed * 5
	
	var target_pos = bug.global_position.move_toward(wp,speed*_delta)
	bug.global_position = target_pos
	if bug.global_position == bug.waypoints[bug.wp_idx]:		
		change_state("idle")
	
	bug.update_thread()
