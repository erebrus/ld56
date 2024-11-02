extends Area2D


func _on_body_entered(_body: Node2D) -> void:
	Events.reached_level_end.emit()
