@tool
@icon("res://addons/xsm/icons/state_animation.png")
extends StateAnimation

@export var charge_time:float = 4

func _on_enter(_args) -> void:
	target.speed=target.charge_speed
	add_timer("charge",charge_time)

func _on_update(_delta) -> void:
	var bug:Bug = target
	if bug.target == null:		
		change_state("move")
		return
	bug.direction = sign(bug.target.global_position.x-bug.global_position.x)
	var target_pos=bug.target.global_position-target.sting_offset+bug.target.sprite_offset
	bug.velocity= (target_pos - bug.global_position).normalized()*bug.speed
	bug.move_and_slide()
		

func on_attack():
	Logger.info("Attacked")
	change_state("sting")

func _on_timeout(_name) -> void:
	if _name == "charge":
		change_state("prepare")
