extends CharacterBody2D
class_name Frog

signal energy_changed(value:float)

@export var swing_gravity:= 1000
@export var swing_speed:= 5
@export var reel_speed:= 20
@export var energy_drop_rate:float = 2
@export var max_energy:=100:
	set(value):
		max_energy = value
		if health_component:
			health_component.max_energy = max_energy
			health_component.energy = max_energy


@onready var controller: FrogController = $Controller
@onready var xsm: State = $xsm
@onready var rc_front: RayCast2D = $rc_front
@onready var rc_down: RayCast2D = $rc_down
@onready var rc_up: RayCast2D = $rc_up

@onready var head: FrogHead = $FrogBody/Head
@onready var sprite: AnimatedSprite2D = $FrogBody/AnimatedSprite2D
@onready var health_component: HealthComponent = $HealthComponent
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var debufs: Node = %Debufs
@onready var auto_hop: XSMFrogAutoHop = %auto_hop
@onready var sfx_hard_rock_landing: AudioStreamPlayer2D = $sfx/sfx_hard_rock_landing
@onready var sfx_hard_landing: AudioStreamPlayer2D = $sfx/sfx_hard_landing
@onready var sfx_swing: AudioStreamPlayer2D = $sfx/sfx_tongue_rope
@onready var energy_timer: Timer = $EnergyTimer
@onready var sprite_offset=sprite.position
@onready var debuff_animation_player: AnimationPlayer = $Debuffs/AnimationPlayer


var state_name:String
var is_dead:=false
var immune:=false
var trampoline_strength:float=0

func _ready():
	Globals.player = self
	
	health_component.max_energy = max_energy
	health_component.energy = max_energy
	
	velocity.y=1
	Events.tongue_attached.connect(_on_tongue_attached)
	Events.tongue_detached.connect(_on_tongue_detached)
	Events.debug_toggled.connect(_on_debug_toggled)
	#Events.reached_level_end.connect(func():$sfx/sfx_win.play())
	Events.combo_achieved.connect(_on_combo_achieved)

func set_trampoline(v:float):
	trampoline_strength=v
	
func is_near_floor() -> bool:
	return rc_down.is_colliding()
	

func is_under_cover() -> bool:
	return rc_up.is_colliding()
	

func _on_debug_toggled(_debug:bool):
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
			


func do_auto_hop(direction:Types.HopDirection, acc):
	auto_hop.direction=direction
	auto_hop.acc=acc
	xsm.change_state("auto_hop")
	
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
	if is_dead:
		return
	is_dead = true
	xsm.change_state("death")
	await animation_player.animation_finished
	Events.game_lost.emit(Types.LossType.ENERGY)
	
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
		head.tongue.caught_bug.free_if_done()
		head.tongue.caught_bug=null
		
func _on_combo_achieved(combo_idx:int):
	var new_buf=Types.COMBO_BUFS[combo_idx].instantiate() as Debuf
	process_debuf(new_buf)

func process_debuf(new_debuf:Debuf):
	var existing_debuf = find_debuf(new_debuf)
	if existing_debuf:
		existing_debuf.extend()
	else:
		debufs.add_child(new_debuf)
		new_debuf.apply_debuf(self)
		if new_debuf.immediate:		
			new_debuf.cancel_debuf(self)
		else:
			new_debuf.expired.connect(func(debuf):debuf.cancel_debuf(self))
	spawn_debuf_label(new_debuf)

func spawn_debuf_label(debuf:Debuf):
	var label = Types.DEBUF_LABEL_SCENE.instantiate()
	label.text = debuf.text
	label.anchor = %DebufAnchor
	get_parent().add_child(label)
	label.global_position = label.anchor.global_position
	
func process_bug(bug:Bug)->void:
	health_component.on_heal(bug.energy_value)
	var scene:PackedScene = Types.DEBUF_MAP[bug.type]
	var new_debuf:Debuf = scene.instantiate() as Debuf
	process_debuf(new_debuf)

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
	if not immune:
		health_component.on_take_damage(energy_drop_rate)

func on_hurt(dmg:float)->void:
	health_component.on_take_damage(dmg)
