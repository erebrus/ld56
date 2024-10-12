@tool
@icon("res://addons/xsm/icons/state_animation.png")
extends StateAnimation

@export var charge_duration:float = 3

func _on_enter(_args) -> void:
	target.speed=target.charge_speed

func _on_update(_delta) -> void:
	var bug:Bug = target
	if target == null:		
		change_state("move")
	bug.direction = sign(target.global_position.x-bug.global_position.x)
	bug.velocity= bug.global_position.move_toward(target.global_position,bug.speed)
	bug.move_and_slide()
		
