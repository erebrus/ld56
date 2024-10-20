@tool
@icon("res://addons/xsm/icons/state_animation.png")
extends StateAnimation

func _on_anim_finished():
	change_state("move")

func _on_enter(_args):
	target.set_collision(false)

func _on_exit(_args):
	target.set_collision(true)
