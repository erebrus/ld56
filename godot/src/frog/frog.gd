extends CharacterBody2D
class_name Frog

signal energy_changed(value:float)

@export var swing_gravity:= 1000
@export var swing_speed:= 5
@export var reel_speed:= 20
@export var energy_drop_rate:float = 1


@onready var controller: FrogController = $Controller
@onready var xsm: State = $xsm
@onready var rc_front: RayCast2D = $rc_front

@onready var head: FrogHead = $Head
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var health_component: HealthComponent = $HealthComponent
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var debufs: Node = %Debufs

var state_name:String


func _ready():
	velocity.y=1
	Events.tongue_attached.connect(_on_tongue_attached)
	Events.tongue_detached.connect(_on_tongue_detached)
	Events.debug_toggled.connect(_on_debug_toggled)

func _on_debug_toggled(debug:bool):
		HyperLog.text("position", self)
		HyperLog.text("state_name", self)
		HyperLog.text("controller:acc", self)
		HyperLog.text("controller:debug_on_ground", self)
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
			
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("dead"):
		_on_health_component_died()
		
func _on_controller_jumped(_is_ground_jump: bool) -> void:
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
	xsm.change_state("death")
	await animation_player.animation_finished
	Globals.do_lose()

func _on_health_component_energy_changed(value: Variant) -> void:
	energy_changed.emit(value)


func _on_tongue_attached(to: Vector2) -> void:
	_on_generic_controller_forward("_on_tongue_attached", to - (head.tongue_position - global_position))
	

func _on_tongue_detached() -> void:
	_on_generic_controller_forward("_on_tongue_detached")


func _on_head_shot_finished() -> void:
	head.hide()
	sprite.show()
	if head.tongue.caught_bug:
		$sfx/sfx_eat.play()
		process_bug(head.tongue.caught_bug)
		
func process_bug(bug:Bug)->void:
	health_component.on_heal(bug.energy_value)
	var scene:PackedScene = Types.DEBUF_MAP[bug.type]
	var new_debuf = scene.instantiate()
	var existing_debuf = find_debuf(new_debuf)
	if existing_debuf:
		existing_debuf.extend()
	else:
		debufs.add_child(new_debuf)
		new_debuf.apply(self)
		new_debuf.expired.connect(func(debuf):debuf.cancel(self))
	bug.queue_free()

func find_debuf(debuf:Debuf):
	for child in debufs.get_children():
		if child.name == debuf.name:
			return child
	return null
func _on_head_shot_started() -> void:
	head.show()
	sprite.hide()
	$sfx/sfx_tongue_attack.play()


func _on_head_shot_missed() -> void:
	$sfx/sfx_tongue_miss.play()


func _on_energy_timer_timeout() -> void:
	health_component.on_take_damage(energy_drop_rate)
