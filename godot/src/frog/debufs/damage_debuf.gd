extends Debuf

@export var value:float=30


func apply_debuf(frog):
	super.apply_debuf(frog)
	frog.health_component.on_take_damage(value)

	
func cancel_debuf(frog):
	super.cancel_debuf(frog)
