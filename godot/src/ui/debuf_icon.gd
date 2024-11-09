extends TextureProgressBar
class_name DebufIcon

var debuf:Debuf
		
func _process(_delta: float) -> void:
	value=debuf.get_percentage_done()
