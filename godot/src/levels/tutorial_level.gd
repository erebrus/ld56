extends "res://src/levels/base_level.gd"

@onready var eagle = $Eagle


func _on_trigger_eagle_body_entered(body):
	eagle.fly_by()
