extends Node
class_name HealthComponent

#signal max_changed(value)
signal energy_changed(value)
signal died
@export var max_energy:float = 100:
	set(v):
		max_energy=v
		energy = energy
		Events.max_energy_changed.emit(max_energy)
		#max_changed.emit(v)
		

@onready var energy:float = max_energy:
	set(value):
		var clamped = clamp(value, 0, max_energy)
		if energy == clamped:
			return
		energy = clamped
		energy_changed.emit(energy)
		Events.energy_changed.emit(energy)

@onready var max_heal:float = 100


func on_take_damage(value:float):
	energy -= value
	if energy == 0:
		Events.energy_depleted.emit()
		died.emit()
		
func on_heal(value:float):
	var heal_value:float = min(max_heal,value)
	Logger.info("Healing for %.2f" % heal_value)
	energy += value
