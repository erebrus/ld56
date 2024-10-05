class_name Bug extends Area2D

@export var type: Types.BugType = Types.BugType.Slug


func catch() -> void:
	Events.bug_caught.emit(type)
	queue_free()
