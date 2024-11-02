extends Node2D

@export var start_y:=-1000
@export var width:=2000.0
@export var interval:=Vector2(.2,1)
@onready var timer: Timer = $Timer

func _ready() -> void:
	schedule_drop()


func _physics_process(_delta: float) -> void:
	pass
	
func generate_drop():
	var rd = Types.RAINDROP_SCENE.instantiate()	
	rd.visible=false	

	get_parent().get_parent().add_child(rd)	
	rd.global_position=Vector2(global_position.x+randf_range(-1,1)*width,start_y)
	rd.visible=true
	Logger.info("drop at %s" % rd.global_position )

func schedule_drop():
	timer.wait_time = randf_range(interval.x, interval.y)
	timer.start()
	
func _on_timer_timeout() -> void:
	
	generate_drop()
	schedule_drop()
