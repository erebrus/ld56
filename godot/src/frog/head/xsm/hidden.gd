@tool
extends TongeState


func _on_enter(_args) -> void:
	target.hide()
	target.retracted.emit()
	
