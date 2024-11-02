extends StaticBody2D
class_name Platform
@export var floor_type:Types.FloorType
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func reset():
	animation_player.play("reset")
