@tool
extends CharacterBody2D
class_name PlatformerCharacter
@onready var controller: CustomPlatformerController2D = $Controller
@onready var xsm: State = $xsm


func _ready() -> void:
	pass


func _on_controller_hit_ground() -> void:
	
	_on_generic_controller_forward("_on_controller_hit_ground")

func _on_generic_controller_forward(method_name):
	for  s in xsm.active_states:
		var state= xsm.get_state(s)
		if state.has_method(method_name):
			state.call(method_name)
			
func _on_controller_jumped(is_ground_jump: bool) -> void:
	for s in xsm.active_states:
		var state= xsm.get_state(s)
		if state.has_method("_on_controller_jumped"):
			state._on_controller_jumped(is_ground_jump)

func _on_controller_started_falling() -> void:
	_on_generic_controller_forward("_on_controller_started_falling")


func _on_controller_started_moving() -> void:
	_on_generic_controller_forward("_on_controller_started_moving")


func _on_controller_stopped() -> void:
	_on_generic_controller_forward("_on_controller_stopped")
	


func _on_controller_dettached_to_wall() -> void:
	_on_generic_controller_forward("_on_controller_dettached_to_wall")


func _on_controller_attached_to_wall() -> void:
	_on_generic_controller_forward("_on_controller_attached_to_wall")
