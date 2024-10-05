extends CharacterBody2D
class_name Frog

@onready var controller: FrogController = $Controller
@onready var xsm: State = $xsm
@onready var rc_front: RayCast2D = $rc_front

@onready var head: FrogHead = $Head
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var health_component: HealthComponent = $HealthComponent



func _ready():
	velocity.y=1
	Events.tongue_attached.connect(_on_tongue_attached)
	Events.tongue_detached.connect(_on_tongue_detached)
	

#
#func _process(delta: float) -> void:
	#sprite.offset.x = 0 if not sprite.flip_h else +400

func _on_controller_hit_ground() -> void:
	_on_generic_controller_forward("_on_controller_hit_ground")
	


func _on_generic_controller_forward(method_name: String, args = null):
	for  s in xsm.active_states:
		var state= xsm.get_state(s)
		if state.has_method(method_name):
			if args == null:
				state.call(method_name)
			else:
				state.call(method_name, args)
			
			
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
	


func _on_health_component_died() -> void:
	Globals.do_lose()

func _on_health_component_energy_changed(value: Variant) -> void:
	Logger.info("new health is: %d" % value)


func _on_head_shot_finished() -> void:
	$sfx/sfx_eat.play()

func _on_head_shot_fired() -> void:
	$sfx/sfx_tongue_attack.play()
	

func _on_tongue_attached(to: Vector2i) -> void:
	_on_generic_controller_forward("_on_tongue_attached", to)
	

func _on_tongue_detached() -> void:
	_on_generic_controller_forward("_on_tongue_detached")
