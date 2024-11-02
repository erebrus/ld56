extends Control
class_name DebufIcon

@onready var bg: TextureRect = $BG
@onready var progress: TextureProgressBar = $Progress

var debuf:Debuf
var texture:Texture:
	set(t):
		$BG.texture=t
		$Progress.texture_progress=t
		
func _process(_delta: float) -> void:
	$Progress.value=debuf.get_percentage_done()
