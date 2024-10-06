extends Debuf
class_name EPDebuff

@export var value:float=2


func apply_debuf(frog):
	super.apply_debuf(frog)
	frog.energy_drop_rate+=value
	
func cancel_debuf(frog):
	super.cancel_debuf(frog)
	frog.energy_drop_rate-=value
