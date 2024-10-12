@tool
@icon("res://addons/xsm/icons/state.png")
extends State


func _on_enter(_args) -> void:
	target.speed=target.patrol_speed
	if target.sfx_fly:
		target.sfx_fly.pitch_scale=1
