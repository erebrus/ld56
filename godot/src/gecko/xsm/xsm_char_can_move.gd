@tool
@icon("res://addons/xsm/icons/state_animation.png")
extends XSMCharacterState

func _on_update(_delta) -> void:
	get_ctl().check_input()
	get_ctl().do_movement(_delta)

func _on_controller_attached_to_wall() -> void:
	change_state("climb")
