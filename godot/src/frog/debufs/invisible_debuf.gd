extends Debuf
class_name InvisibleDebuf

func apply_debuf(frog):
	super.apply_debuf(frog)
	frog.visible=false
	
func cancel_debuf(frog):
	super.cancel_debuf(frog)
	frog.visible=true
