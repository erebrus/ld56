extends Debuf

@export var acceleration_factor: float = 0.8

@export var shrink_factor: float = 0.6:
	set(v):
		shrink_factor = v
		scale = Vector2(shrink_factor, shrink_factor)


var scale: Vector2

func apply_debuf(frog: Frog):
	super.apply_debuf(frog)
	frog.scale *= scale
	frog.head.tongue.set_size(shrink_factor)
	frog.head.can_shoot = false
	frog.controller.max_acceleration*=acceleration_factor
	frog.controller.min_jump_height*=acceleration_factor
	frog.controller.max_jump_height*=acceleration_factor
	frog.controller.double_jump_height*=acceleration_factor

func cancel_debuf(frog: Frog):
	super.cancel_debuf(frog)
	frog.scale /= scale
	frog.head.tongue.set_size(1.0 / shrink_factor)
	frog.head.can_shoot = true
	frog.controller.max_acceleration/=acceleration_factor
	frog.controller.min_jump_height/=acceleration_factor
	frog.controller.max_jump_height/=acceleration_factor
	frog.controller.double_jump_height/=acceleration_factor
