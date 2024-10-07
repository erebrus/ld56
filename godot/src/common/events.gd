extends Node

signal bug_caught(type: Types.BugType)
signal tongue_attached(to: Vector2)
signal tongue_detached

signal debug_toggled(value:bool)

signal debuf_applied(debuf:Debuf)
#signal debuf_tick(debuf:Debuf)
signal debuf_cancelled(debuf:Debuf)

signal eagle_incoming
signal eagle_left
signal frog_grabbed

signal energy_depleted
signal reached_level_end()
signal game_lost()

signal combo_achieved(idx:int)

signal bug_freeze_toggle(val:bool)


func _ready() -> void:
	bug_caught.connect(func(type): Logger.info("Caught bug of type: %s" % Types.key_of(type)))
	eagle_incoming.connect(func(): Logger.info("Eagle incoming!"))
	eagle_left.connect(func(): Logger.info("Eagle left"))
	
