extends Node2D

@onready var version: Label = %Version

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	version.text=ProjectSettings.get_setting("application/config/version") # Replace with function body.
	version.visible=Globals.debug_build

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
