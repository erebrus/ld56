extends Node

signal bug_caught(type: Types.BugType)
signal tongue_attached(to: Vector2)
signal tongue_detached

signal debug_toggled(value:bool)

signal debuf_applied(debuf:Debuf)
#signal debuf_tick(debuf:Debuf)
signal debuf_cancelled(debuf:Debuf)

signal frog_grabbed


func _ready() -> void:
	bug_caught.connect(func(type): Logger.info("Caught bug of type: %s" % Types.key_of(type)))
	
