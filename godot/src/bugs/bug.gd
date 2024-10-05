class_name Bug extends CharacterBody2D

@export var type: Types.BugType = Types.BugType.Slug

@export var energy_value:float = 10
@export var dodge_chance:float = 0

func catch() -> bool:
	if Globals.rng.randf() > dodge_chance:
		Events.bug_caught.emit(type)
		do_death()
		return true
	else:
		do_dodge()
		return false

func do_death():
	call_deferred("queue_free")
	
func do_dodge():
	Logger.debug("%s dodged." % name)
	pass
	
