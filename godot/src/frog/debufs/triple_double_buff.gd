extends Debuf

@export var value:int=20

func apply_debuf(frog):
	super.apply_debuf(frog)
	frog.health_component.on_heal(value)
	
