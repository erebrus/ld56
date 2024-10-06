extends Node2D

@onready var version: Label = %Version
@onready var ambient: AudioStreamPlayer = $ambient
@onready var frog: Frog = %Frog
@onready var health_bar: HealthBar = %HealthBar
@onready var music: AudioStreamPlayer = $music
@onready var camera: Camera2D = %Camera2D

var debug:=false
var camera_follow_player:= true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	version.text=ProjectSettings.get_setting("application/config/version") # Replace with function body.
	version.visible=Globals.debug_build
	ambient.play()
	frog.health_component.max_changed.connect(func (x):health_bar.set_max(frog.health_component.max_energy);Logger.info("Changing healthbar"))
	health_bar.set_max(frog.health_component.max_energy)
	Globals.music_manager.fade_in_stream(music)
	Events.frog_grabbed.connect(func(): camera_follow_player = false)
	

func _process(_delta):
	if camera_follow_player:
		camera.position = frog.position - Vector2(0, 200)
	

func _input(event: InputEvent) -> void:
	if not debug and Input.is_action_just_pressed("debug"):
		debug = true
		Events.debug_toggled.emit(debug)
	
