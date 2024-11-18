extends CharacterBody2D


const SPEED = 1500.0
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var collided:=false

func _physics_process(delta: float) -> void:
	if collided:
		return 
	velocity = Vector2(0,SPEED)
	var collision = move_and_collide(velocity*delta)
	if collision:
		collided = true
		animation_player.play("splash")
		if collision.get_collider() is Frog:
			collision.get_collider().on_hurt(Types.RAIN_DAMAGE)
			Logger.info("rain damage")
		await animation_player.animation_finished		
		queue_free()
		
