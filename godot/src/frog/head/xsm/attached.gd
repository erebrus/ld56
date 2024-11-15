extends TongeState

func _ready():
	super()
	Events.frog_grabbed.connect(_on_frog_grabbed)
	

func _on_enter(_args) -> void:
	Events.tongue_attached.emit(target.global_position)
	

func _on_update(_delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		change_state("retracting")
	
	target.update_rope()
	hide_if_retracted()
	

func _on_exit(_args) -> void:
	Events.tongue_detached.emit()

func _on_energy_depleted() -> void:
	change_state("retracting")

func _on_frog_grabbed() -> void:
	change_state("retracting")
