extends Debuf
func apply_debuf(frog):
	super.apply_debuf(frog)
	frog.head.can_shoot = false
	
func cancel_debuf(frog):
	super.cancel_debuf(frog)
	frog.head.can_shoot = true
