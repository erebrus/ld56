extends Node2D

@onready var version: Label = %Version
@onready var ambient: AudioStreamPlayer = $ambient

var debug:=false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	version.text=ProjectSettings.get_setting("application/config/version") # Replace with function body.
	version.visible=Globals.debug_build
	ambient.play()
func _input(event: InputEvent) -> void:
	if not debug and Input.is_action_just_pressed("debug"):
		debug = true
		Events.debug_toggled.emit(debug)
	
