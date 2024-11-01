extends MarginContainer
class_name HealthBar

@onready var progress: TextureProgressBar = $Progress
@onready var grey_progress: TextureProgressBar = $GreyProgress


func _ready():
	Events.block_max_hp.connect(set_block)
	grey_progress.value = 0

func _on_frog_energy_changed(value: float) -> void:
	if progress:
		progress.value = value

func set_max(value:float)->void:
	progress.max_value=value
	grey_progress.max_value=value
	
func set_block(value:float):
	grey_progress.value=value
