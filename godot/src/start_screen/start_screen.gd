extends TextureRect


func _ready() -> void:
	Globals.in_game=false
	

func _on_start_button_pressed() -> void:
	$sfx_button.play()
	Globals.start_game()
	

func _on_quit_button_pressed():
	get_tree().quit()
	
