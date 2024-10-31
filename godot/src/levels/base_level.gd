class_name GameLevel extends Node2D

@onready var version: Label = %Version
@onready var ambient: AudioStreamPlayer = $ambient
@onready var frog: Frog = %Frog
@onready var health_bar: HealthBar = %HealthBar
@onready var music: AudioStreamPlayer = $music
@onready var black_overlay: ColorRect = $HUD/BlackOverlay
@onready var camera: Camera2D = %Camera2D
@onready var almanac: Control = %Almanac
@onready var lose_screen: Control = %LoseScreen
@onready var eagle = %Eagle
@export var tense_timeout =  5
var camera_follow_player:= true

var threats:=0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.level = self
	Globals.fade_from_black(black_overlay)
	version.text=ProjectSettings.get_setting("application/config/version") # Replace with function body.
	version.visible=Debug.debug_build
	ambient.play()
	#frog.health_component.max_changed.connect(func (x):health_bar.set_max(x);Logger.info("Changing healthbar"))
	health_bar.set_max(frog.health_component.max_energy)
	health_bar._on_frog_energy_changed(frog.health_component.max_energy)

	Globals.music_manager.fade_in_stream(music)
	Events.reached_level_end.connect(_on_reached_level_end)
	Events.frog_grabbed.connect(func(): camera_follow_player = false)
	Events.eagle_incoming.connect(_on_eagle_incoming)
	Events.eagle_left.connect(_on_eagle_left)
	Events.game_lost.connect(_on_game_lost)
	Events.threat_on.connect(func(): update_threats(1))
	Events.threat_off.connect(func(): update_threats(-1))
	
func _on_eagle_incoming():
	Logger.debug("level eagle in")
	update_threats(1)
	Globals.music_manager.crossfade_synchronized(music.stream,1)
	
func _on_eagle_left():
	Logger.debug("level eagle out")
	if camera_follow_player:
		await get_tree().create_timer(5).timeout
		update_threats(-1)
	else:
		Globals.fade_to_black(black_overlay)

func update_threats(delta:int):
	threats+=delta
	if threats == 1:
		Logger.info("tense music")
		Globals.music_manager.crossfade_synchronized(music.stream,1)
	elif threats==0:
		Logger.info("normal music")
		Globals.music_manager.crossfade_synchronized(music.stream,0)

func _on_game_lost(type:Types.LossType):
	lose_screen.show_overlay(type)
	#Globals.fade_to_black(black_overlay)
	#await get_tree().create_timer(2).timeout
	#get_tree().quit()


func _process(_delta):
	if camera_follow_player:
		camera.position = frog.position - Vector2(0, 200)
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("almanac"):
		almanac.visible = not almanac.visible
		frog.energy_timer.paused=almanac.visible
		
func _on_reached_level_end():
	frog.do_auto_hop(Types.HopDirection.RIGHT, 7500)
	await get_tree().create_timer(.5).timeout
	Globals.fade_to_black(black_overlay, 1.5)
	Globals.music_manager.fade_stream(music,1.3)
	await get_tree().create_timer(1.5).timeout
	Globals.next_level()
	
