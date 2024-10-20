extends Node2D

@export var acc:float=5

var text:String:
	set(v):
		text=v
		$Label.text=text

var velocity:Vector2=Vector2.ZERO
var anchor:Node2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#await get_tree().create_timer(.5).timeout
	fade()

func fade():
	var tween=create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self,"modulate",Color("ffffff00"),2)	
	await tween.finished
	queue_free()
	
func _physics_process(delta: float) -> void:
	velocity.y+=acc*delta
	global_position-=velocity
	#global_position.x=anchor.global_position.x
