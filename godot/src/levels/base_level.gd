extends Node2D

@onready var version: Label = %Version
@onready var ambient: AudioStreamPlayer = $ambient
@onready var frog: Frog = %Frog
@onready var health_bar: HealthBar = %HealthBar
@onready var music: AudioStreamPlayer = $music
@onready var black_overlay: ColorRect = $HUD/BlackOverlay

var debug:=false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.fade_from_black(black_overlay)
	version.text=ProjectSettings.get_setting("application/config/version") # Replace with function body.
	version.visible=Globals.debug_build
	ambient.play()
	frog.health_component.max_changed.connect(func (x):health_bar.set_max(frog.health_component.max_energy);Logger.info("Changing healthbar"))
	health_bar.set_max(frog.health_component.max_energy)
	Globals.music_manager.fade_in_stream(music)
	Events.reached_level_end.connect(_on_reached_level_end)
	
func _input(event: InputEvent) -> void:
	if not debug and Input.is_action_just_pressed("debug"):
		debug = true
		Events.debug_toggled.emit(debug)
	if Input.is_action_just_pressed("dead"):
		frog._on_health_component_died()
	if Input.is_action_just_pressed("win"):
		Globals.do_win()


func _on_reached_level_end():
	frog.do_auto_hop(Types.HopDirection.RIGHT, 7500)
	await get_tree().create_timer(.5).timeout
	Globals.fade_to_black(black_overlay, 1.5)
	Globals.music_manager.fade_stream(music,1.3)
	await get_tree().create_timer(1.5).timeout
	Globals.next_level()
	
