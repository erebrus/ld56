extends "res://src/levels/base_level.gd"

@onready var eagle = $Eagle

func _ready():
	super._ready()
	Events.game_lost.connect(func(x):$Tutorial.visible=false)
	
func _on_trigger_eagle_body_entered(body):
	eagle.trigger_now()
