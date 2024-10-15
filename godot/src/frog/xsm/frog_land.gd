@tool
@icon("res://addons/xsm/icons/state_animation.png")
extends XSMFrog
class_name XSMFrogLand

func _on_anim_finished():
	if get_body().trampoline_strength>0:
		get_ctl().reset_jumps_left()
		get_ctl().ground_jump()
	else:
		change_state("idle")
	

func _on_enter(_args) -> void:
	Logger.debug("state:%s " % name)
	if target:
		target.state_name=name
	if get_ctl().floor_type==Types.FloorType.Grass:
		get_body().sfx_hard_landing.play()
		Logger.debug("Landed on grass")
	else:
		get_body().sfx_hard_rock_landing.play()
		Logger.debug("Landed on rock")

		
	#get_ctl().acc.x=0
	#if get_ctl().is_jump_buffer_timer_running() and not get_ctl().can_hold_jump: 
		#get_ctl().jump()	
	
func _after_enter(_args) -> void:
	pass
func _on_update(_delta) -> void:
	pass
func _after_update(_delta) -> void:
	pass
func _before_exit(_args) -> void:
	pass
func _on_exit(_args) -> void:
	pass
func _on_timeout(_name) -> void:
	pass
