@tool
extends Area2D

@export var width:float=2000.0:
	set(v):
		width = v
		update_shape()
		
@export var detection_area_size:Vector2:
	set(_size):
		detection_area_size=_size
		#await get_tree().process_frame
		#update_shape()
		
@export var interval:=Vector2(.2,1)
@export var count_per_interval:=Vector2i(1,2)
@export var wait_between_drops:=true

@onready var timer: Timer = $Timer

var active := false

func _ready() -> void:
	
	if not Engine.is_editor_hint():
		$Line2D.queue_free()
		update_shape()
	await get_tree().process_frame
	active = not get_overlapping_bodies().is_empty()
		
func update_shape():
	$CollisionShape2D.shape = RectangleShape2D.new()
	$CollisionShape2D.shape.size=detection_area_size
	$CollisionShape2D.position=Vector2.ZERO+Vector2(0,detection_area_size.y/2)
	if $Line2D:
		$Line2D.clear_points()
		$Line2D.add_point(Vector2(-width/2.0,0))
		$Line2D.add_point(Vector2(width/2.0,0))

func _physics_process(_delta: float) -> void:
	pass
	
func generate_drop():
	var rd = Types.RAINDROP_SCENE.instantiate()	
	rd.visible=false	

	get_parent().get_parent().add_child(rd)	
	rd.global_position=Vector2(global_position.x+randf_range(-1,1)*width/2.0,global_position.y)
	rd.visible=true
	if not Engine.is_editor_hint():
		Logger.debug("drop at %s" % rd.global_position )

func schedule_drops():
	timer.wait_time = randf_range(interval.x, interval.y)
	timer.start()
	
func _on_timer_timeout() -> void:
	
	for i in randi_range(count_per_interval.x, count_per_interval.y):
		generate_drop()
		if wait_between_drops:
			await get_tree().process_frame
	if active:
		schedule_drops()


func _on_body_entered(body: Node2D) -> void:
	active=true
	schedule_drops()


func _on_body_exited(body: Node2D) -> void:
	active=false
