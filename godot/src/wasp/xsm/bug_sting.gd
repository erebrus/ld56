@tool
@icon("res://addons/xsm/icons/state_animation.png")
extends StateAnimation


func _on_enter(_args) -> void:
	Logger.info("wasp:%s " % name)
	if target.target and target.target.has_method("on_hurt"):
		target.target.on_hurt(target.attack_damage)


func _on_anim_finished():
	change_state("retreat")
