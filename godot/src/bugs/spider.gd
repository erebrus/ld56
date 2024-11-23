extends Bug


@onready var thread: Line2D = $Thread

func _ready() -> void:
	super._ready()
	update_thread()
	

func update_thread() -> void:
	thread.clear_points()
	thread.add_point(waypoints.front() - global_position)
	thread.add_point(Vector2(0,0))
