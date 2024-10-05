extends Node

signal bug_caught(type: Types.BugType)


func _ready() -> void:
	bug_caught.connect(func(type): Logger.info("Caught bug of type: %s" % Types.key_of(type)))
	
