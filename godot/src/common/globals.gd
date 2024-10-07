extends Node

const GAME_SCENE_PATH = "res://src/main.tscn"
const WIN_SCENE_PATH = "res://src/end_screens/win_screen.tscn"
var master_volume:float = 100
var music_volume:float = 100
var sfx_volume:float = 100

const GameDataPath = "user://conf.cfg"
var config:ConfigFile

@export var levels:Array[PackedScene]
var current_level=0

var debug_build := true
var in_game:=false
var in_dialogue:=false
var rng = RandomNumberGenerator.new()
var music_on:=true:
	set(v):
		music_on=v
		Logger.info("music %s" % [music_on])
		var sfx_index= AudioServer.get_bus_index("Music")
		AudioServer.set_bus_volume_db(sfx_index, music_manager.music_bus_volume if music_on else -60.0)
	

var sound_on:=true:
	set(v):
		sound_on = v
		Logger.info("sound %s" % [sound_on])
		var sfx_index= AudioServer.get_bus_index("Sound")
		AudioServer.set_bus_volume_db(sfx_index, 0 if sound_on else -60)
	

@onready var music_manager: MusicManager = $MusicManager

var player: Frog


func _ready():
	rng.randomize()
	_init_logger()
	Logger.info("Starting menu music")
	music_manager.fade_in_menu_music()

	#start_game()
	
func start_game():
	in_game=true

	
	music_manager.fade_menu_music()
	await get_tree().create_timer(1).timeout
	#music_manager.reset_synchronized_stream()

	#get_tree().change_scene_to_file(GAME_SCENE_PATH)
	get_tree().change_scene_to_packed(levels[current_level])

	#music_manager.fade_in_game_music()
	
	
func next_level():
	current_level += 1
	if current_level >= levels.size():
		do_win()
	else:
		get_tree().change_scene_to_packed(levels[current_level])

	

	
func _init_logger():
	Logger.set_logger_level(Logger.LOG_LEVEL_INFO)
	Logger.set_logger_format(Logger.LOG_FORMAT_MORE)
	var console_appender:Appender = Logger.add_appender(ConsoleAppender.new())
	console_appender.logger_format=Logger.LOG_FORMAT_FULL
	console_appender.logger_level = Logger.LOG_LEVEL_INFO
	var file_appender:Appender = Logger.add_appender(FileAppender.new("res://debug.log"))
	file_appender.logger_format=Logger.LOG_FORMAT_FULL
	file_appender.logger_level = Logger.LOG_LEVEL_DEBUG
	Logger.info("Logger initialized.")

func fade_from_black(black_overlay, duration:float=1):
	black_overlay.modulate=Color("ffffffff")
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)	
	tween.tween_property(black_overlay, "modulate", Color("ffffff00"), duration)
	
func fade_to_black(black_overlay,duration:float=1):
	black_overlay.modulate=Color("ffffff00")
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)	
	tween.tween_property(black_overlay, "modulate", Color("ffffffff"), duration)
	
func do_lose():
	Events.game_lost.emit()

func do_win():
	get_tree().change_scene_to_file(WIN_SCENE_PATH)
