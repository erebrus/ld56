extends Node

enum FloorType{Grass, Rock}


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
	[Types.BugType.Beetle,Types.BugType.Beetle,Types.BugType.Beetle],
	[Types.BugType.Beetle,Types.BugType.Fly,Types.BugType.Snail],
	[Types.BugType.Fly,Types.BugType.Fly,Types.BugType.Moth],
	[Types.BugType.Snail,Types.BugType.Snail,Types.BugType.Moth],
	[Types.BugType.Beetle,Types.BugType.Snail,Types.BugType.Beetle]
]
const BUG_ALMANAC_TEXTURES = {
	Types.BugType.Slug: preload("res://assets/gfx/ui/ComboIcons/Slug_Almanac.png"),
	Types.BugType.Beetle: preload("res://assets/gfx/ui/ComboIcons/Beetle_Almanac.png"),
	Types.BugType.Fly: preload("res://assets/gfx/ui/ComboIcons/Fly_Almanac.png"),
	Types.BugType.Moth: preload("res://assets/gfx/ui/ComboIcons/Moth_Almanac.png"),
	Types.BugType.Snail: preload("res://assets/gfx/ui/ComboIcons/Snail_Almanac.png"),
	Types.BugType.Worm: preload("res://assets/gfx/ui/ComboIcons/Worm_Almanac.png"),
	Types.BugType.Cockroach: preload("res://assets/gfx/ui/ComboIcons/Roach_Almanac.png"),
}
