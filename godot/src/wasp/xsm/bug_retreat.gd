@tool
@icon("res://addons/xsm/icons/state_animation.png")
extends StateAnimation


@export var retreat_time:float = .5

func _on_enter(_args) -> void:
	#target.speed=target.patrol_speed
	#target.velocity= target.velocity.normalized()*-1*target.speed
	target.velocity*=-1
	add_timer("retreat",retreat_time)

func _on_update(_delta) -> void:
	var bug:Bug = target
	if bug.target == null:		
		change_state("move")
		return
	bug.move_and_slide()
		
	

func _on_timeout(_name) -> void:
	if _name == "retreat":
		target.next_wp()
		change_state("prepare")
