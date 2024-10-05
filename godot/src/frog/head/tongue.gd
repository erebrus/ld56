extends Node2D

signal retracted

@export var max_length:= 500
@export var extension_speed:= 1000.0
@export var retraction_speed:= 2000.0

enum State {
	Idle,
	Extending,
	Retracting
}

var state:= State.Idle
var direction: Vector2
var player: FrogHead # TODO: change for player class

var is_shooting: bool:
	get:
		return state != State.Idle
	

@onready var squared_length = pow(max_length, 2)

@onready var rope: Line2D = $Rope
@onready var tip: Area2D = $Tip

func _ready() -> void:
	tip.area_entered.connect(_on_area_entered)
	

func shoot(target: Vector2, _player: FrogHead) -> void:
	player = _player
	global_position = player.tongue_position
	direction = global_position.direction_to(target)
	
	state = State.Extending
	visible = true
	

func retract() -> void:
	state = State.Retracting
	

func idle() -> void:
	state = State.Idle
	hide()
	retracted.emit()
	

func _physics_process(delta: float) -> void:
	match state:
		State.Idle:
			return
		State.Extending:
			var new_position = global_position + delta * extension_speed * direction
			if new_position.distance_squared_to(player.tongue_position) > squared_length:
				global_position = player.tongue_position + player.tongue_position.direction_to(new_position) * max_length
				retract()
			else:
				global_position = new_position
		State.Retracting:
			global_position = global_position.move_toward(player.tongue_position, delta * retraction_speed)
			
			if global_position.distance_squared_to(player.tongue_position) < 10:
				global_position = player.tongue_position
				idle()
				
			
	
	rope.remove_point(1)
	rope.add_point(player.tongue_position - global_position)
	

func _on_area_entered(area: Area2D) -> void:
	var bug = area as Bug
	if bug == null:
		return
	
	if bug.catch():
		retract()
	
