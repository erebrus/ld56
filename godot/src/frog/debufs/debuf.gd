extends Node
class_name Debuf

signal expired(debuf:Debuf)

@export var duration:float = 5
@onready var timer: Timer = $Timer

func apply_debuf(frog:Frog):
	timer.wait_time = duration
	timer.start()
	Logger.info("applying %s" % name)
	Events.debuf_applied.emit(self)
	
func cancel_debuf(frog:Frog):
	timer.stop()
	Logger.info("canceling %s" % name)


func _on_timer_timeout() -> void:
	expired.emit(self)
	Events.debuf_cancelled.emit(self)

func extend() ->void:
	Logger.info("Extending %s " % name)
	timer.wait_time = timer.time_left+duration
