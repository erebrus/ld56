@tool
@icon("res://addons/xsm/icons/state_animation.png")
extends XSMCharacterState


func _on_enter(_args) -> void:
	super._on_enter(_args)
	get_ctl().get_parent().velocity=Vector2.ZERO
	get_ctl().acc=Vector2.ZERO


func _on_update(_delta) -> void:	
	
	#get_ctl().check_jump_input()
	get_ctl().do_climb_movement(_delta)
	
func _on_controller_dettached_to_wall() -> void:
	change_state("fall")
