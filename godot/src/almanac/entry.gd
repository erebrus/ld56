@tool 
extends HBoxContainer

@export var texture: Texture2D:
	set(value):
		texture = value
		$TextureRect.texture = value
	

@export var text: String:
	set(value):
		text = value
		$Label.text = value
