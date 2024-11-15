extends Node2D


signal retracted
signal missed

@export var max_length:= 500
@export var extension_speed:= 1000.0
@export var retraction_speed:= 2000.0

var player: FrogHead

var is_shooting: bool:
	get:
		return visible
	
var caught_bug:Bug
@onready var xsm: State = $xsm
@onready var squared_length = pow(max_length, 2)

@onready var rope: Line2D = $Rope
@onready var tip: Area2D = $Tip
@onready var attach_sfx: AudioStreamPlayer2D = $AttachSfx


func _ready() -> void:
	xsm.change_state("hidden")
	tip.area_entered.connect(_on_area_entered)
	tip.body_entered.connect(_on_body_entered)
	Events.energy_depleted.connect(_on_energy_depleted)

func shoot(target: Vector2, _player: FrogHead) -> void:
	caught_bug=null
	player = _player
	global_position = player.tongue_position
	
	xsm.change_state("extending", target)
	

func retract() -> void:
	xsm.change_state("retracting")
	

func catch_bug(bug: Bug) -> void:
	
	if bug.catch():
		caught_bug=bug
	retract()
	

func attach(anchor: Vector2) -> void:
	global_position = anchor
	attach_sfx.play()
	xsm.change_state("attached")
	

func update_rope() -> void:
	rope.remove_point(1)
	rope.add_point(player.tongue_position - global_position)
	tip.rotation = (global_position - player.tongue_position).angle()

func _call_state_method(method_name: String, args = null):
	for  s in xsm.active_states:
		var state= xsm.get_state(s)
		if state.has_method(method_name):
			if args == null:
				state.call(method_name)
			else:
				state.call(method_name, args)
	

func _on_area_entered(area) -> void:
	if !is_shooting:
		return
	
	if area is Bug:
		catch_bug(area)
	else:
		attach(area.global_position)

func _on_body_entered(body) -> void:
	if !is_shooting:
		return
	
	if body is Bug:
		catch_bug(body)
	else: 
		attach(body.global_position)

func _on_energy_depleted() -> void:
	_call_state_method("_on_energy_depleted")
	
