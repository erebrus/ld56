extends StaticBody2D
class_name Trampoline

@export var strength:float = 1000

func _on_capture_area_body_entered(body: Node2D) -> void:
	if body.has_method("set_trampoline"):
		body.set_trampoline(strength)


func _on_capture_area_body_exited(body: Node2D) -> void:
	if body.has_method("set_trampoline"):
		body.set_trampoline(0)
