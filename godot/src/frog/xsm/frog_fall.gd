@tool
@icon("res://addons/xsm/icons/state_animation.png")
extends XSMFrog
class_name XSMFrogFall

@export var no_stop_land_time:=.3
var soft_land:=true
func _on_enter(_args) -> void:
	Logger.debug("state:%s %d " % [name, Time.get_ticks_msec()])
	if target:
		target.state_name=name
	add_timer("land", no_stop_land_time)
	soft_land=true
func _after_enter(_args) -> void:
	pass
func _on_update(_delta) -> void:
	# Check if we just hit the ground this frame
	if get_ctl().check_just_hit_ground():
		return
	if Input.is_action_just_pressed(get_ctl().input_jump):
		if get_ctl().current_jump_type!=get_ctl().JumpType.NONE and get_ctl().can_double_jump():
			get_ctl().jump()
			return
			
	get_ctl().set_x_acc()
	get_ctl().gravity = get_ctl().apply_falling_gravity(get_ctl().default_gravity)
	get_ctl().process_movement(_delta)
func _after_update(_delta) -> void:
	pass
func _before_exit(_args) -> void:
	pass
func _on_exit(_args) -> void:
	pass
func _on_timeout(_name) -> void:
	if _name == "land":
		soft_land=false

func _on_controller_hit_ground():
	if soft_land:
		Logger.trace("fall hit ground")
		change_state("idle")
	else:
		change_state("land")
