extends Debuf



func apply_debuf(frog):
	super.apply_debuf(frog)
	frog.controller.max_jump_amount-=1
	
func cancel_debuf(frog):
	super.cancel_debuf(frog)
	frog.controller.max_jump_amount+=1
