extends Node2D

@onready var version: Label = %Version
@onready var ambient: AudioStreamPlayer = $ambient
@onready var frog: Frog = %Frog
@onready var health_bar: HealthBar = %HealthBar
@onready var music: AudioStreamPlayer = $music
@onready var black_overlay: ColorRect = $HUD/BlackOverlay
@onready var camera: Camera2D = %Camera2D

@export var tense_timeout =  5
var debug:=false
var camera_follow_player:= true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.fade_from_black(black_overlay)
	version.text=ProjectSettings.get_setting("application/config/version") # Replace with function body.
	version.visible=Globals.debug_build
	ambient.play()
	frog.health_component.max_changed.connect(func (x):health_bar.set_max(x);Logger.info("Changing healthbar"))
	health_bar.set_max(frog.health_component.max_energy)
	health_bar._on_frog_energy_changed(frog.health_component.max_energy)

	Globals.music_manager.fade_in_stream(music)
	Events.reached_level_end.connect(_on_reached_level_end)
	Events.frog_grabbed.connect(func(): camera_follow_player = false)
	Events.eagle_incoming.connect(_on_eagle_incoming)
	Events.eagle_left.connect(_on_eagle_left)
	Events.game_lost.connect(_on_game_lost)
	
	
	
func _on_eagle_incoming():
	Logger.debug("level eagle in")
	Logger.debug("normal db=%d tense db=%d before incoming" % [music.stream.get_sync_stream_volume(0),music.stream.get_sync_stream_volume(1)])
	Globals.music_manager.crossfade_synchronized(music.stream,1)
	
func _on_eagle_left():
	Logger.debug("level eagle out")
	Logger.debug("normal db=%d tense db=%d on left" % [music.stream.get_sync_stream_volume(0),music.stream.get_sync_stream_volume(1)])
	if camera_follow_player:
		await get_tree().create_timer(5).timeout
		Globals.music_manager.crossfade_synchronized(music.stream,0)
		Logger.debug("normal db=%d tense db=%d after timeout" % [music.stream.get_sync_stream_volume(0),music.stream.get_sync_stream_volume(1)])
	else:
		Globals.fade_to_black(black_overlay)

func _on_game_lost():
	Globals.fade_to_black(black_overlay)
	await get_tree().create_timer(2).timeout
	get_tree().quit()


func _process(_delta):
	if camera_follow_player:
		camera.position = frog.position - Vector2(0, 200)
	

func _input(event: InputEvent) -> void:
	if not debug and Input.is_action_just_pressed("debug"):
		debug = true
		Events.debug_toggled.emit(debug)
	if Input.is_action_just_pressed("dead"):
		Events.energy_depleted.emit()
		frog._on_health_component_died()
	if Input.is_action_just_pressed("win"):
		Globals.do_win()
	if Input.is_action_just_pressed("buf_1"):
		Events.combo_achieved.emit(0)
	if Input.is_action_just_pressed("buf_2"):
		Events.combo_achieved.emit(1)
	if Input.is_action_just_pressed("buf_3"):
		Events.combo_achieved.emit(2)
	if Input.is_action_just_pressed("buf_4"):
		Events.combo_achieved.emit(3)
	if Input.is_action_just_pressed("buf_5"):
		Events.combo_achieved.emit(4)
	if Input.is_action_just_pressed("next_level"):
		Events.reached_level_end.emit()
		
		
func _on_reached_level_end():
	frog.do_auto_hop(Types.HopDirection.RIGHT, 7500)
	await get_tree().create_timer(.5).timeout
	Globals.fade_to_black(black_overlay, 1.5)
	Globals.music_manager.fade_stream(music,1.3)
	await get_tree().create_timer(1.5).timeout
	Globals.next_level()
	
