extends Node2D

signal extended
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

@onready var rope = $Rope
@onready var tip = $Tip


func shoot(target: Vector2, _player: FrogHead) -> void:
	player = _player
	global_position = player.tongue_position
	direction = global_position.direction_to(target)
	
	state = State.Extending
	visible = true
	
	

func _physics_process(delta: float) -> void:
	match state:
		State.Idle:
			return
		State.Extending:
			var new_position = global_position + delta * extension_speed * direction
			if new_position.distance_squared_to(player.tongue_position) > squared_length:
				global_position = player.tongue_position + player.tongue_position.direction_to(new_position) * max_length
				extended.emit()
				state = State.Retracting
			else:
				global_position = new_position
		State.Retracting:
			global_position = global_position.move_toward(player.tongue_position, delta * retraction_speed)
			
			if global_position.distance_squared_to(player.tongue_position) < 10:
				global_position = player.tongue_position
				retracted.emit()
				state = State.Idle
				visible = false
			
	
	rope.remove_point(1)
	rope.add_point(player.tongue_position - global_position)
	
