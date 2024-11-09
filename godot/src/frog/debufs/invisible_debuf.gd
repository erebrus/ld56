extends Debuf
class_name InvisibleDebuf

func apply_debuf(frog: Frog):
	super.apply_debuf(frog)
	frog.debuff_animation_player.play("debuff_animations/invisible")
	
func cancel_debuf(frog: Frog):
	super.cancel_debuf(frog)
	frog.debuff_animation_player.play_backwards("debuff_animations/invisible")
