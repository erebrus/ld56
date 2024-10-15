extends Bug



@export var patrol_speed:float =100
@export var charge_speed:float =1500 
@export var attack_damage:float = 20

@export var patrol_detection_range:float = 1000
@export var attack_detection_range:float = 2000

@onready var sting_offset:Vector2=get_node("HurtArea").position
@onready var sting: Node = $xsm/has_target/sting
@onready var detection_area: Area2D = $DetectionArea
@onready var sfx_fly: AudioStreamPlayer2D = $sfx/sfx_fly


var target:CharacterBody2D

func _ready():
	super._ready()
	var collision_shape:CollisionShape2D = detection_area.get_child(0)
	collision_shape.shape = CircleShape2D.new()
	set_detection_radius(patrol_detection_range)
func set_detection_radius(range:float):
	var collision_shape:CollisionShape2D = detection_area.get_child(0)
	(collision_shape.shape as CircleShape2D).radius = range
	
func _physics_process(delta: float) -> void:
	pass

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	pass # Replace with function body.


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	pass # Replace with function body.


func _on_detection_area_body_entered(body: Node2D) -> void:
	target=body
	if xsm.is_active("no_target"):
		Logger.info("Changing to prepare")
		set_detection_radius(attack_detection_range)
		Events.threat_on.emit()
		xsm.change_state("prepare")
	


func _on_detection_area_body_exited(body: Node2D) -> void:
	if body==target:
		target=null
		set_detection_radius(patrol_detection_range)
		
		Events.threat_off.emit()

	if xsm.is_active("has_target"):
		xsm.change_state("move")
		Logger.info("target gone")


func _on_hurt_area_body_entered(body: Node2D) -> void:
	Logger.info("wasp hurtbox found player")
	_on_generic_controller_forward("on_attack")


func catch() -> bool:
	#xsm.change_state("prepare")
	#_on_generic_controller_forward("on_stun")
	return false
