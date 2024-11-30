@tool
extends Node2D

@export var frame: int = 0:
	set(value):
		frame = value
		$Sprite.frame = value

@export var flip_h: bool = false:
	set(value):
		flip_h=value
		$Sprite.flip_h=value
