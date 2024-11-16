extends MarginContainer
class_name HealthBar

@export var health_loss_to_show_delay = 2
@export var delay: float = 0.3
@export var dealy_animation_duration: float = 0.8

@onready var progress: TextureProgressBar = $Progress
@onready var delayed_progress: TextureProgressBar = $DelayedProgress
@onready var grey_progress: TextureProgressBar = $GreyProgress

var tween: Tween
var queue: Array[float]

func _ready():
	Events.energy_changed.connect(_on_frog_energy_changed)
	Events.max_energy_changed.connect(set_max)
	Events.block_max_hp.connect(set_block)
	grey_progress.value = 0
	
	if Globals.player:
		set_max(Globals.player.health_component.max_energy)
		_on_frog_energy_changed(Globals.player.health_component.energy)

func _tween_damage(value: int) -> void:
	if delayed_progress.value - value > health_loss_to_show_delay:
		tween = create_tween()
		tween.tween_interval(delay)
		tween.tween_property(delayed_progress, "value", value, dealy_animation_duration).set_trans(Tween.TRANS_QUINT)
		tween.finished.connect(_on_tween_finished)
	else:
		delayed_progress.value = value
		_on_tween_finished()
		

func _on_tween_finished() -> void:
	if queue.is_empty():
		delayed_progress.value = progress.value
		return
	var value = queue.pop_front()
	tween.kill()
	_tween_damage(value)
	

func _should_queue_damage() -> bool:
	if not queue.is_empty():
		return true
	
	return tween != null and tween.is_valid()
	

func _on_frog_energy_changed(value: float) -> void:
	if progress:
		progress.value = value
		
		if _should_queue_damage():
			queue.append(value)
		else:
			_tween_damage(value)
		
	

func set_max(value:float)->void:
	progress.max_value=value
	delayed_progress.max_value=value
	grey_progress.max_value=value
	
func set_block(value:float):
	grey_progress.value=value
