extends CharacterBody2D
class_name Frog

@onready var controller: FrogController = $Controller
@onready var xsm: State = $xsm
@onready var rc_front: RayCast2D = $rc_front

@onready var head: FrogHead = $Head
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D


func _ready():
	velocity.y=1
#
#func _process(delta: float) -> void:
	#sprite.offset.x = 0 if not sprite.flip_h else +400

func _on_controller_hit_ground() -> void:
	
	_on_generic_controller_forward("_on_controller_hit_ground")

func _on_generic_controller_forward(method_name):
	for  s in xsm.active_states:
		var state= xsm.get_state(s)
		if state.has_method(method_name):
			state.call(method_name)
			
func _on_controller_jumped(is_ground_jump: bool) -> void:
	xsm.change_state("jump")

func _on_controller_started_falling() -> void:
	xsm.change_state("fall")


func _on_controller_hopped() -> void:
	xsm.change_state("hop")


func _on_controller_jump_requested() -> void:
	_on_generic_controller_forward("_on_controller_jump_requested")

func is_facing_wall()->bool:
	return rc_front.is_colliding()


func _on_controller_direction_changed() -> void:
	rc_front.target_position.x=abs(rc_front.target_position.x)*controller.last_direction.x
	rc_front.force_raycast_update()
	sprite.flip_h= controller.last_direction.x < 0
	 
	#legs.flip_h = controller.last_direction.x < 0
	head.flip_h = controller.last_direction.x < 0
	
