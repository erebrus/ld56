class_name CollapsiblePlatform extends Platform


@export var support_time:float = .5
@export var recover_time:float= 2
@onready var timer: Timer = $Timer

var collapsing:=false

func _ready():
	if timer:
		timer.wait_time = support_time
	

func on_contact():
	if not collapsing:
		collapsing=true
		timer.start()
	

func _on_timer_timeout() -> void:
	Logger.info("Collapsing platform")
	collapse()
	await get_tree().create_timer(recover_time).timeout
	reset()

func collapse():
	animation_player.play("collapse")

func reset():
	super.reset()
	collapsing=false
