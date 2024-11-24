@tool
extends StaticBody2D
class_name Platform
@export var floor_type:Types.FloorType
@export var flipped:bool:
	set(_v):
		if _v != flipped:
			$Sprite2D.flip_h=!$Sprite2D.flip_h
			$CollisionPolygon2D.apply_scale(Vector2(-1,1))
			
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func reset():
	animation_player.play("reset")
