extends StaticBody2D
class_name Platform
@export var floor_type:Types.FloorType
@export var collapsible:bool = false
@export var support_time:float = .5
@export var recover_time:float= 2
@onready var timer: Timer = $Timer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var collapsing:=false
func _ready():
	timer.wait_time = support_time
	
func on_contact():
	if collapsible and not collapsing:
		collapsing=true
		timer.start()


func _on_timer_timeout() -> void:
	Logger.info("Collapsing platform")
	collapse()
	await get_tree().create_timer(recover_time).timeout
	reset()

func collapse():
	animation_player.play("collapse")

func reset():
	animation_player.play("reset")
	collapsing=false
