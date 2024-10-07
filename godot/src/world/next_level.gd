extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	body.do_auto_hop(Types.HopDirection.RIGHT,7500)
	await get_tree().create_timer(1).timeout
	Globals.next_level()
