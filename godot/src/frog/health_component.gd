extends Node
class_name HealthComponent

signal energy_changed(value)
signal died
@export var max_energy:float = 100
@onready var energy:float = max_energy


func _on_take_damage(value:float):
	energy = clamp(energy-value, 0, max_energy)
	energy_changed.emit(energy)
	if energy == 0:
		died.emit()
		
func _on_heal(value:float):
	energy = clamp(energy+value, 0, max_energy)
	energy_changed.emit(energy)
