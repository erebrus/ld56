extends CharacterBody2D


const SPEED = 1500.0
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _physics_process(delta: float) -> void:

	velocity = Vector2(0,SPEED)
	var collision = move_and_collide(velocity*delta)
	if collision:
		animation_player.play("splash")
		await animation_player.animation_finished
		queue_free()
		
