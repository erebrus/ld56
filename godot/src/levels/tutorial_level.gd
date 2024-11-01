extends GameLevel


func _ready():
	super._ready()
	Events.game_lost.connect(func(_x):$Tutorial.visible=false)
	

func _on_trigger_eagle_body_entered(_body):
	eagle.trigger_now()
