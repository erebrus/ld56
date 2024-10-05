@tool
@icon("res://addons/xsm/icons/state_animation.png")
extends XSMFrog
class_name XSMFrogFall

@export var no_stop_land_time:=.3
var soft_land:=true
func _on_enter(_args) -> void:
	Logger.debug("state:%s " % name)
	add_timer("land", no_stop_land_time)
	soft_land=true
func _after_enter(_args) -> void:
	pass
func _on_update(_delta) -> void:
	# Check if we just hit the ground this frame
	if not get_ctl()._was_on_ground and get_ctl().is_feet_on_ground():
		get_ctl().current_jump_type = get_ctl().JumpType.NONE	
		get_ctl().hit_ground.emit()
		return
	if Input.is_action_just_pressed(get_ctl().input_jump):
		if get_ctl().can_double_jump():
			get_ctl().jump()
			return
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
		Logger.info("fall hit ground")
		change_state("idle")
	else:
		change_state("land")
