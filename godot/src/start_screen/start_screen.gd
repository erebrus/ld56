extends TextureRect


func _ready() -> void:
	Globals.in_game=false


func _on_sound_button_toggled(toggled_on: bool) -> void:
	$sfx_button.play()
	Globals.sound_on=toggled_on
	

func _on_music_button_toggled(toggled_on: bool) -> void:
	$sfx_button.play()
	Globals.music_on=toggled_on
	

func _on_ambient_button_toggled(toggled_on):
	$sfx_button.play()
	Globals.ambient_on=toggled_on
	

func _on_start_button_pressed() -> void:
	$sfx_button.play()
	Globals.start_game()
	

func _on_quit_button_pressed():
	get_tree().quit()
	
