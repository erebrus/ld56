extends Debuf


func apply_debuf(frog):
	super.apply_debuf(frog)
	Events.bug_freeze_toggle.emit(true)	
func cancel_debuf(frog):
	super.cancel_debuf(frog)
	Events.bug_freeze_toggle.emit(false)	
