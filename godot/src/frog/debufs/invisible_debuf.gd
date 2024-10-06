extends Debuf
class_name InvisibleDebuf

func apply_debuf(frog:Frog):
	super.apply_debuf(frog)
	#frog.visible=false
	
func cancel_debuf(frog:Frog):
	super.cancel_debuf(frog)
	#frog.visible=true
