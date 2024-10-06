extends Node
class_name Debuf

@export var duration:float = 5
@onready var timer: Timer = $Timer


func apply(frog:Frog):
	timer.start()
	
func cancel(frog:Frog):
	timer.stop()
