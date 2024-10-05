@tool
@icon("res://addons/xsm/icons/state_animation.png")
extends XSMFrog

var anchor: Vector2

func _on_enter(args) -> void:
	anchor = args
	

# TODO: retract

func _on_tongue_detached() -> void:
	change_state("idle")
