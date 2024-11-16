extends Debuf



func apply_debuf(frog: Frog):
	super.apply_debuf(frog)
	frog.controller.max_jump_amount-=1
	frog.dirt_particles.emitting = true
	
func cancel_debuf(frog: Frog):
	super.cancel_debuf(frog)
	frog.controller.max_jump_amount+=1
	frog.dirt_particles.emitting = false
