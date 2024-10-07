extends Debuf

@export var value:float=30


func apply_debuf(frog):
	super.apply_debuf(frog)
	frog.health_component.max_energy-=value
	Events.block_max_hp.emit(value)

	
func cancel_debuf(frog):
	super.cancel_debuf(frog)
	frog.health_component.max_energy+=value
	Events.block_max_hp.emit(0)
