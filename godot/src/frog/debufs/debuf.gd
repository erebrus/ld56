extends Node
class_name Debuf

signal expired(debuf:Debuf)

@export var duration:float = 5
@onready var timer: Timer = $Timer
@onready var sfx_on: AudioStreamPlayer = $sfx_on
@onready var sfx_off: AudioStreamPlayer = $sfx_off

func apply_debuf(frog):
	timer.wait_time = duration
	timer.start()
	if sfx_on.stream:
		sfx_on.play()
	Logger.info("applying %s" % name)
	Events.debuf_applied.emit(self)
	
func cancel_debuf(frog):
	timer.stop()
	Logger.info("canceling %s" % name)
	if sfx_off.stream:
		sfx_off.play()
		await sfx_off.finished
	call_deferred("queue_free")


func _on_timer_timeout() -> void:
	expired.emit(self)
	Events.debuf_cancelled.emit(self)

func extend() ->void:
	Logger.info("Extending %s " % name)
	timer.wait_time = timer.time_left+duration
