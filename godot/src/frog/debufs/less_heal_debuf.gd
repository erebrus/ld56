extends Debuf

@export var value:float=1


func apply_debuf(frog: Frog):
	super.apply_debuf(frog)
	frog.health_component.max_heal=value
	
func cancel_debuf(frog: Frog):
	super.cancel_debuf(frog)
	frog.health_component.max_heal=frog.health_component.max_energy
