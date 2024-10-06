extends Debuf
class_name InvisibleDebuf

func apply(frog:Frog):
	super.apply(frog)
	frog.visible=false
	
func cancel(frog:Frog):
	super.cancel(frog)
	frog.visible=true
