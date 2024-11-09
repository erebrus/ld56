extends Debuf
func apply_debuf(frog: Frog):
	super.apply_debuf(frog)
	frog.debuff_animation_player.play_backwards("debuff_animations/no_tongue")
	frog.head.can_shoot = false
	
func cancel_debuf(frog: Frog):
	super.cancel_debuf(frog)
	frog.debuff_animation_player.play("debuff_animations/no_tongue")
	frog.head.can_shoot = true
