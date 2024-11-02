extends StaticBody2D



func _on_area_2d_body_entered(_body: Node2D) -> void:
	Events.reached_level_end.emit()
