extends Debuf


func apply_debuf(frog):
	super.apply_debuf(frog)
	frog.controller.max_jump_amount+=1
	frog.controller.jumps_left=frog.controller.max_jump_amount
	
func cancel_debuf(frog):
	super.cancel_debuf(frog)
	frog.controller.max_jump_amount-=1
	
