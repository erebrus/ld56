extends Bug



@export var patrol_speed:float =100
@export var charge_speed:float =500 
@export var attack_damage:float = 20



var target:CharacterBody2D


func _physics_process(delta: float) -> void:
	pass

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	pass # Replace with function body.


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	pass # Replace with function body.


func _on_detection_area_body_entered(body: Node2D) -> void:
	if xsm.is_active("no_target"):
		xsm.change_state("prepare")


func _on_detection_area_body_exited(body: Node2D) -> void:
	if xsm.is_active("has_target"):
		xsm.change_state("move")
