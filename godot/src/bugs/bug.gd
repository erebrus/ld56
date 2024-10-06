class_name Bug extends CharacterBody2D

@export var type: Types.BugType = Types.BugType.Slug

@export var energy_value:float = 10
@export var dodge_chance:float = 0
@export var speed:float = 20

@onready var path_follow: PathFollow2D = $PathFollow2D
@onready var xsm: State = $xsm
@onready var sfx_death: AudioStreamPlayer2D = $sfx_death

var direction = 1 if Globals.rng.randf()>.5 else -1:
	set(v):
		direction=v
		$Sprite2D.flip_h=direction==1
var wp_idx=0
var waypoints=[]

func _ready():
	set_path()
	
func catch() -> bool:
	if Globals.rng.randf() > dodge_chance:
		Events.bug_caught.emit(type)
		do_death()
		return true
	else:
		do_dodge()
		return false

func do_death():
	if sfx_death.stream:
		sfx_death.play()
		await sfx_death.finished
	call_deferred("queue_free")
	
func do_dodge():
	xsm.change_state("dodge")

func move(_delta):
	var path_follow = get_parent() as PathFollow2D
	if not path_follow:
		return
	path_follow.progress+=speed*_delta*direction
	
	if path_follow.progress_ratio==0 or path_follow.progress_ratio==1:
		xsm.change_state("idle")
		
func set_path():
	var path:Path2D=null
	if get_parent() is Path2D:
		path=get_parent()
	else:
		for idx in range(get_child_count()):
			var child = get_child(idx)
			if child is Path2D:
				path=child
				remove_child(path)
				break

			
	if not path:	
		Logger.warn("%s has no path." % get_path())
		return
		
	waypoints=[]
	for idx in range (path.curve.point_count):
		waypoints.append(path.curve.get_point_position(idx))
	Logger.info("%s has path:%s" % [get_path(), waypoints])
func next_wp():
	if waypoints.is_empty():
		return
	wp_idx += 1
	if wp_idx>=waypoints.size():
		wp_idx=0
