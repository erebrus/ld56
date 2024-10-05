class_name Bug extends CharacterBody2D

@export var type: Types.BugType = Types.BugType.Slug

@export var energy_value:float = 10
@export var dodge_chance:float = 0
@export var speed:float = 20

@onready var path_follow: PathFollow2D = $PathFollow2D
@onready var xsm: State = $xsm
@onready var sfx_death: AudioStreamPlayer2D = $sfx_death

var direction = 1 if Globals.rng.randf()>.5 else -1


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
		
	
