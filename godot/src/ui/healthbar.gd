extends MarginContainer
class_name HealthBar

@onready var progress: TextureProgressBar = $Progress
@onready var grey_progress: TextureProgressBar = $GreyProgress


func _ready():
	Events.energy_changed.connect(_on_frog_energy_changed)
	Events.max_energy_changed.connect(set_max)
	Events.block_max_hp.connect(set_block)
	grey_progress.value = 0
	
	if Globals.player:
		set_max(Globals.player.health_component.max_energy)
		_on_frog_energy_changed(Globals.player.health_component.energy)

func _on_frog_energy_changed(value: float) -> void:
	if progress:
		progress.value = value

func set_max(value:float)->void:
	progress.max_value=value
	grey_progress.max_value=value
	
func set_block(value:float):
	grey_progress.value=value
