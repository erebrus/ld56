extends Control
class_name DebufIcon

@onready var bg: TextureRect = $BG
@onready var progress: TextureProgressBar = $Progress

var texture:Texture:
	set(t):
		$BG.texture=t
		$Progress.texture_progress=t
		
