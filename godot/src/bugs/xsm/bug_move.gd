@tool
@icon("res://addons/xsm/icons/state_animation.png")
extends StateAnimation


func _after_update(_delta) -> void:
	target.move(_delta)
