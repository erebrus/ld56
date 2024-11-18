extends Debuf



func apply_debuf(frog: Frog):
	super.apply_debuf(frog)
	frog.controller.max_jump_amount-=1
	frog.debuff_animation_player.play("debuff_animations/squish")
	
func cancel_debuf(frog: Frog):
	super.cancel_debuf(frog)
	frog.controller.max_jump_amount+=1
	frog.debuff_animation_player.play_backwards("debuff_animations/squish")
