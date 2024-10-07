extends Debuf



@export var value:float=1.5


func apply_debuf(frog):
	super.apply_debuf(frog)
	frog.controller.max_acceleration*=value
	
func cancel_debuf(frog):
	super.cancel_debuf(frog)
	frog.controller.max_acceleration/=value
