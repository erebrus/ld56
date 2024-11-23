extends Debuf

func apply_debuf(frog: Frog):
	super.apply_debuf(frog)
	frog.controller.input_factor *= -1

func cancel_debuf(frog: Frog):
	super.cancel_debuf(frog)
	frog.controller.input_factor *= -1
