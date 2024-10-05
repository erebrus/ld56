class_name TongeState extends State


var rope: Line2D:
	get:
		return target.rope
	
var tip: Area2D:
	get:
		return target.tip

var head: FrogHead:
	get:
		return target.player


func hide_if_retracted() -> void:
	if target.global_position.distance_squared_to(head.tongue_position) < 10:
		target.global_position = head.tongue_position
		change_state("hidden")
		return
	
