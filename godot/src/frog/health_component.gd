extends Node
class_name HealthComponent

#signal max_changed(value)
signal energy_changed(value)
signal died
@export var max_energy:float = 100:
	set(v):
		max_energy=v
		energy = clamp(energy, 0, max_energy)
		energy_changed.emit(energy)
		#max_changed.emit(v)
		

@onready var energy:float = max_energy


func on_take_damage(value:float):
	energy = clamp(energy-value, 0, max_energy)
	energy_changed.emit(energy)
	if energy == 0:
		Events.energy_depleted.emit()
		died.emit()
		
func on_heal(value:float):
	energy = clamp(energy+value, 0, max_energy)
	energy_changed.emit(energy)
