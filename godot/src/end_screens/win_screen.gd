extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.music_manager.fade_in_menu_music()
	Globals.music_manager.fade_in_stream(Globals.music_manager.get_node("ambient"))
	Globals.fade_from_black($BlackOverlay)

func _on_timer_timeout() -> void:
	back_to_start_screen()
	
func back_to_start_screen():
	Globals.fade_to_black($BlackOverlay)
	await get_tree().create_timer(.8)
	Globals.show_start_screen()
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_cancel"):
		back_to_start_screen()
