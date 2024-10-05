@tool
@icon("res://addons/xsm/icons/state_animation.png")
extends StateAnimation
class_name XSMCharacterState


func _on_enter(_args) -> void:
	Logger.debug("state:%s " % name)

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
	
func get_ctl():
	return (target as PlatformerCharacter).controller
func _on_controller_hit_ground() -> void:
	change_state("land")

func _on_controller_jumped(is_ground_jump: bool) -> void:
	change_state("jump")

func _on_controller_started_falling() -> void:
	change_state("fall")


		
