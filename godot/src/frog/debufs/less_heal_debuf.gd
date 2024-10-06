extends Debuf

@export var value:float=2


func apply_debuf(frog):
	super.apply_debuf(frog)
	frog.max_heal=1
	
func cancel_debuf(frog):
	super.cancel_debuf(frog)
	frog.max_heal=frog.health_component.max_energy
