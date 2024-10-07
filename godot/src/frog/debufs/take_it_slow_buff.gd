extends Debuf

func apply_debuf(frog):
	super.apply_debuf(frog)
	frog.immune=true
	
func cancel_debuf(frog):
	super.cancel_debuf(frog)
	frog.immune=false
