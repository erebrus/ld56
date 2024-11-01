class_name Bug extends CharacterBody2D

@export var type: Types.BugType = Types.BugType.Slug

@export var energy_value:float = 10
@export var dodge_chance:float = 0
@export var speed:float = 20
@export var can_be_caught:=true
@export var respawn_period:float = 10
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

@onready var xsm: State = $xsm
@onready var sfx_death: AudioStreamPlayer2D = $sfx_death


var direction = 1 if Globals.rng.randf()>.5 else -1:
	set(v):
		direction=v
		sprite.flip_h=direction==1
var wp_idx=0
var waypoints=[]

func _ready():
	set_path()
	Events.bug_freeze_toggle.connect(func(v): xsm.disabled=v)
	
func catch() -> bool:
	if can_be_caught:
		if not xsm.is_active("dodge"):
			Events.bug_caught.emit(self)
			do_death()
			return true
		else:
			return false
	return false
func do_death():
	visible=false
	collision_mask=0
	xsm.disabled= true
	if sfx_death.stream:
		sfx_death.play()
		await sfx_death.finished

func free_if_done():
	if sfx_death.playing:
		await sfx_death.finished
	if respawn_period<=0:
		queue_free()
	else:
		await get_tree().create_timer(respawn_period).timeout
		global_position=waypoints[0]
		wp_idx=0
		xsm.disabled= false
		xsm.change_state("idle")
		collision_mask=4 #TODO use plugin for layers
		visible = true
	
func do_dodge():
	xsm.change_state("dodge")


func set_path():
	var path:Path2D=null
	var offset:=Vector2.ZERO
	if get_parent() is Path2D:
		path=get_parent()
		offset = get_parent().position
	else:
		for idx in range(get_child_count()):
			var child = get_child(idx)
			if child is Path2D:
				path=child
				offset = position+path.position
				remove_child(path)
				break

			
	if not path:	
		Logger.warn("%s has no path." % get_path())
		return
		
	waypoints=[]
	for idx in range (path.curve.point_count):
		waypoints.append(path.curve.get_point_position(idx)+offset)
		Logger.trace("%s: wp %d offset %s - %s -> %s" % [get_path(), idx, offset,path.curve.get_point_position(idx), path.curve.get_point_position(idx)+offset ])
	Logger.info("%s has path:%s" % [get_path(), waypoints])
func next_wp():
	if waypoints.is_empty():
		return
	wp_idx += 1
	if wp_idx>=waypoints.size():
		wp_idx=0

func _on_generic_controller_forward(method_name: String, args = null):
	for  s in xsm.active_states:
		var state= xsm.get_state(s)
		if state.has_method(method_name):
			if args == null:
				state.call(method_name)
			else:
				state.call(method_name, args)

func _on_reaction_area_area_shape_entered(_area_rid: RID, _area: Area2D, _area_shape_index: int, _local_shape_index: int) -> void:
	if Globals.rng.randf() < dodge_chance:
		do_dodge()
		
func set_collision(v:bool):
	$CollisionShape2D.disabled=not v
