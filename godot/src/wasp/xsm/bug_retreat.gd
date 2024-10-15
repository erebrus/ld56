@tool
@icon("res://addons/xsm/icons/state_animation.png")
extends StateAnimation


@export var retreat_time:float = .5

func _on_enter(_args) -> void:
	Logger.info("wasp:%s " % name)

	#target.speed=target.patrol_speed
	#target.velocity= target.velocity.normalized()*-1*target.speed
	target.velocity = Vector2(-target.velocity.x, -abs(target.velocity.y))
	
	add_timer("retreat",retreat_time)

func _on_update(_delta) -> void:
	var bug:Bug = target
	if bug.target == null:		
		change_state("move")
		return
	bug.move_and_slide()
		
	
func _on_exit(_args):
	del_timer("retreat")
	
func _on_timeout(_name) -> void:
	if _name == "retreat":
		change_state("prepare")
