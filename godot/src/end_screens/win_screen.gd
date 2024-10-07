extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.music_manager.fade_in_stream($music)
	Globals.music_manager.fade_in_stream($ambient)
	Globals.fade_from_black($BlackOverlay)

func _on_timer_timeout() -> void:
	#show start up screen
	pass # Replace with function body.
