extends Node

enum FloorType{Grass, Rock}
enum LossType {BIRD, ENERGY}


enum BugType {
	Slug,
	Spider,
	Beetle,
	Fly,
	Moth,
	Snail,
	Worm,
	Cockroach,
}
enum HopDirection{LEFT=-1, RIGHT=1}


func key_of(value) -> String:
	if value is BugType:
		return BugType.keys()[value]
	
	return str(value)

@onready var DEBUF_MAP = {
	BugType.Slug:  preload("res://src/frog/debufs/double_jump_debuf.tscn"),
	BugType.Spider:preload("res://src/frog/debufs/ep_max_debuf.tscn"),
	BugType.Beetle:preload("res://src/frog/debufs/ep_debuf.tscn"),
	BugType.Fly:preload("res://src/frog/debufs/less_heal_debuf.tscn"),
	BugType.Moth:preload("res://src/frog/debufs/invisible_debuf.tscn"),
	BugType.Snail:preload("res://src/frog/debufs/slowdown_debuf.tscn"),
	BugType.Worm:preload("res://src/frog/debufs/tongue_debuf.tscn"),
	BugType.Cockroach:preload("res://src/frog/debufs/ep_max_debuf.tscn")
}
@onready var COMBO_BUFS=[
	preload("res://src/frog/debufs/triple_double_buff.tscn"),
	preload("res://src/frog/debufs/gourmet_kebub_buf.tscn"),
	preload("res://src/frog/debufs/flying_taste_debuf.tscn"),
	preload("res://src/frog/debufs/take_it_slow_buff.tscn"),
	preload("res://src/frog/debufs/crunchy_sandwish_buf.tscn")
]
const COMBOS=[
	[Types.BugType.Beetle,Types.BugType.Fly,Types.BugType.Beetle],
	[Types.BugType.Beetle,Types.BugType.Moth,Types.BugType.Snail],
	[Types.BugType.Fly,Types.BugType.Moth,Types.BugType.Cockroach],
	[Types.BugType.Snail,Types.BugType.Slug,Types.BugType.Worm],
	[Types.BugType.Worm,Types.BugType.Cockroach,Types.BugType.Slug]
]
const DEBUF_ICONS={
	#CrunchySandwishBuf:preload("res://src/frog/debufs/crunchy_sandwish_buf.tscn"),
	#GourmetKebubBuf:preload("res://src/frog/debufs/gourmet_kebub_buf.tscn"),
	#TakeItSlowBuff:preload("res://src/frog/debufs/take_it_slow_buff.tscn"),
	#TripleDoubleBuff:preload("res://src/frog/debufs/triple_double_buff.tscn"),
	#FlyingTasteDebuf:preload("res://src/frog/debufs/flying_taste_debuf.tscn"),	
	"DoubleJumpDebuf":preload("res://assets/gfx/ui/DebuffIcons/DecreaBigJump.png"),
	"TongueDebuf":preload("res://assets/gfx/ui/DebuffIcons/NoTongue.png"),
	"SlowdownDebuf":preload("res://assets/gfx/ui/DebuffIcons/Slowdown.png"),
	"LessHealDebuf":preload("res://assets/gfx/ui/DebuffIcons/BeetleEPDown.png"),
	"InvisibleDebuf":preload("res://assets/gfx/ui/DebuffIcons/Invis_Dbuff.png"),
	"EpMaxDebuf":preload("res://assets/gfx/ui/DebuffIcons/DecreMaxEP.png"),
	"EPDebuf":preload("res://assets/gfx/ui/DebuffIcons/IncreasEPspeed.png")
}
const GREY_DEBUF_ICONS={
	#CrunchySandwishBuf:preload("res://src/frog/debufs/crunchy_sandwish_buf.tscn"),
	#GourmetKebubBuf:preload("res://src/frog/debufs/gourmet_kebub_buf.tscn"),
	#TakeItSlowBuff:preload("res://src/frog/debufs/take_it_slow_buff.tscn"),
	#TripleDoubleBuff:preload("res://src/frog/debufs/triple_double_buff.tscn"),
	#FlyingTasteDebuf:preload("res://src/frog/debufs/flying_taste_debuf.tscn"),	
	"DoubleJumpDebuf":preload("res://assets/gfx/ui/DebuffIcons/DecreaBigJump2.png"),
	"TongueDebuf":preload("res://assets/gfx/ui/DebuffIcons/NoTongue2.png"),
	"SlowdownDebuf":preload("res://assets/gfx/ui/DebuffIcons/Slowdown2.png"),
	"LessHealDebuf":preload("res://assets/gfx/ui/DebuffIcons/BeetleEPDown2.png"),
	"InvisibleDebuf":preload("res://assets/gfx/ui/DebuffIcons/Invis_Dbuff2.png"),
	"EpMaxDebuf":preload("res://assets/gfx/ui/DebuffIcons/DecreMaxEP2.png"),
	"EPDebuf":preload("res://assets/gfx/ui/DebuffIcons/IncreasEPspeed2.png")
}
const BUG_ALMANAC_TEXTURES = {
	Types.BugType.Slug: preload("res://assets/gfx/ui/ComboIcons/Slug_Almanac.png"),
	Types.BugType.Beetle: preload("res://assets/gfx/ui/ComboIcons/Beetle_Almanac.png"),
	Types.BugType.Fly: preload("res://assets/gfx/ui/ComboIcons/Fly_Almanac.png"),
	Types.BugType.Moth: preload("res://assets/gfx/ui/ComboIcons/Moth_Almanac.png"),
	Types.BugType.Snail: preload("res://assets/gfx/ui/ComboIcons/Snail_Almanac.png"),
	Types.BugType.Worm: preload("res://assets/gfx/ui/ComboIcons/Worm_Almanac.png"),
	Types.BugType.Cockroach: preload("res://assets/gfx/ui/ComboIcons/Roach_Almanac.png"),
}
