extends Control
class_name HealthBar

@onready var progress: TextureProgressBar = $Progress


func _on_frog_energy_changed(value: float) -> void:
	progress.value = value

func set_max(value:float)->void:
	progress.max_value=value
