@tool
extends Area2D

@export var width:float=2000.0:
	set(v):
		width = v
		update_shape()
		
@export var detection_area_size:Vector2:
	set(_size):
		detection_area_size=_size
		update_shape()
		
@export var interval:=Vector2(.2,1)
@export var count_per_interval:=Vector2i(1,2)
@export var wait_between_drops:=true

@onready var timer: Timer = $Timer

func _ready() -> void:
	schedule_drops()
	if not Engine.is_editor_hint():
		$Line2D.queue_free()
		
func update_shape():
	$CollisionShape2D.shape = RectangleShape2D.new()
	$CollisionShape2D.shape.size=detection_area_size
	$CollisionShape2D.position=Vector2.ZERO+Vector2(0,detection_area_size.y/2)
	if $Line2D:
		$Line2D.clear_points()
		$Line2D.add_point(Vector2(-width,0))
		$Line2D.add_point(Vector2(width,0))

func _physics_process(_delta: float) -> void:
	pass
	
func generate_drop():
	var rd = Types.RAINDROP_SCENE.instantiate()	
	rd.visible=false	

	get_parent().get_parent().add_child(rd)	
	rd.global_position=Vector2(global_position.x+randf_range(-1,1)*width,global_position.y)
	rd.visible=true
	if not Engine.is_editor_hint():
		Logger.info("drop at %s" % rd.global_position )

func schedule_drops():
	timer.wait_time = randf_range(interval.x, interval.y)
	timer.start()
	
func _on_timer_timeout() -> void:
	
	for i in randi_range(count_per_interval.x, count_per_interval.y):
		generate_drop()
		if wait_between_drops:
			await get_tree().process_frame
	schedule_drops()
