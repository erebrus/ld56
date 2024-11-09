extends Sprite2D

@export var rotation_speed:= 1.0


func _physics_process(delta: float) -> void:
	rotation += rotation_speed * delta
