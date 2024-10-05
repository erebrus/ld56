@tool
@icon("res://addons/xsm/icons/state_animation.png")
extends XSMCharacterState

#NOTE configured to jump to idle at the end of animation

func _on_enter(_args) -> void:
	#super._on_enter(_args)
	#get_ctl().get_parent().velocity=Vector2.ZERO
	#get_ctl().acc=Vector2.ZERO
	change_state("idle")


func _on_update(_delta) -> void:

	get_ctl().check_jump_input()
	get_ctl().do_movement(_delta)
