extends Node2D

@onready var head = $Head
@onready var sprite = $AnimatedSprite2D

func _ready() -> void:
	head.shot_started.connect(_on_head_shot_started)
	head.shot_missed.connect(_on_head_shot_missed)
	head.shot_finished.connect(_on_head_shot_finished)
	Events.bug_caught.connect(_on_bug_caught)
	

func _on_head_shot_started() -> void:
	head.show()
	sprite.hide()
	$sfx/sfx_tongue_attack.play()
	

func _on_head_shot_finished() -> void:
	head.hide()
	sprite.show()
	if head.tongue.caught_bug:
		$sfx/sfx_eat.play()
	

func _on_head_shot_missed() -> void:
	$sfx/sfx_tongue_miss.play()
	

func _on_bug_caught(bug: Bug) -> void:
	bug.free_if_done()
