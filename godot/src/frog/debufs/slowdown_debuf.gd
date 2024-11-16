extends Debuf



@export var value:float=5


func apply_debuf(frog):
	super.apply_debuf(frog)
	frog.controller.max_acceleration/=value
	frog.dirt_particles.emitting = true
	
func cancel_debuf(frog):
	super.cancel_debuf(frog)
	frog.controller.max_acceleration*=value
	frog.dirt_particles.emitting = false
