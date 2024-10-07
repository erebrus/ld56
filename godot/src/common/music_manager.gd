class_name MusicManager extends Node

@export var music_bus_volume:=-10.0
@export var ambient_volume:=0
@onready var menu_music: AudioStreamPlayer = $menu_music
@onready var game_music: AudioStreamPlayer = $game_music


@onready var game_music_stream:AudioStreamSynchronized = game_music.stream


func fade_in_menu_music(time:float=1.0):
	fade_in_stream(menu_music,time)

func fade_menu_music(time:float=1.0):
	fade_stream(menu_music, time)
	
func fade_in_game_music(time:float=1.0):
	fade_in_stream(game_music, time)

func fade_game_music(time:float=1.0):
	fade_stream(game_music, time)

func play_music(node:AudioStreamPlayer):
	if not node.playing:
		node.play()
	
#func reset_synchronized_stream():
	#for i in range(game_music_stream.stream_count):
		#if i == current_game_music_id:
			#game_music_stream.set_sync_stream_volume(i,0)
		#else:
			#game_music_stream.set_sync_stream_volume(i,-60)

func fade_in_stream(node:AudioStreamPlayer, duration := 1.0, volume_db:=0.0):
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	node.volume_db=-20
	node.play()
	tween.tween_property(node,"volume_db",volume_db , duration)
	

func fade_stream(node:AudioStreamPlayer, duration := 1.0):
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(node,"volume_db",-20 , duration)
	await tween.finished
	node.stop()

func _helper_set_volume(volume_db:float, stream:AudioStreamSynchronized, id:int):
	stream.set_sync_stream_volume(id, volume_db)
	
func crossfade_synchronized(stream:AudioStreamSynchronized, new_idx:int, time:=1.0):	
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.tween_method(_helper_set_volume.bind(stream,new_idx),-60,0, time).set_ease(Tween.EASE_OUT)
	for i in range(stream.stream_count):
		if i != new_idx:
			tween.parallel().tween_method(_helper_set_volume.bind(stream, i),0,-60, time)
	await tween.finished
