extends Panel

const textures={
	Types.BugType.Slug:  preload("res://assets/gfx/ui/bug_icons/slug_icon.png"),
	Types.BugType.Beetle:preload("res://assets/gfx/ui/bug_icons/beetle_icon.png"),
	Types.BugType.Fly:preload("res://assets/gfx/ui/bug_icons/fly_icon.png"),
	Types.BugType.Moth:preload("res://assets/gfx/ui/bug_icons/moth_icon.png"),
	Types.BugType.Snail:preload("res://assets/gfx/ui/bug_icons/snail_icon.png"),
	Types.BugType.Worm:preload("res://assets/gfx/ui/bug_icons/worm_icon.png"),
	Types.BugType.Cockroach:preload("res://assets/gfx/ui/bug_icons/cockroach_icon.png")

}

@export var reset_delay=1
@onready var icons:=[$HBoxContainer/Icons/Icon1, $HBoxContainer/Icons/Icon2, $HBoxContainer/Icons/Icon3]
var bugs=[null,null,null]

func _ready():
	_reset_combo()
	#for bug in [Types.BugType.Snail,Types.BugType.Worm,Types.BugType.Fly,Types.BugType.Fly,Types.BugType.Moth]:
		#await get_tree().create_timer(.5).timeout
		#_on_bug_caught(bug)

func _reset_combo():
	for i in range(bugs.size()):
		bugs[i]=null
	update_bar()

func update_bar():
	for i in range(bugs.size()):
		icons[i].texture=null if not bugs[i] else textures[bugs[i]]
	

func _on_bug_caught(type:Types.BugType):
	for i in range(bugs.size()):
		if bugs[i] == null:
			bugs[i]=type
			update_bar()
			return
	for i in range(bugs.size()-1):
		bugs[i]=bugs[i+1]
	bugs[bugs.size()-1]=type
	update_bar()
	check_combo()
	
func matches(combo:Array)->bool:
	for i in range(combo.size()):
			if combo[i]!=bugs[i]:
				return false
	return true
	_reset_combo()
	
func check_combo():
	for combo_idx in range(Types.COMBOS.size()):
		var combo = Types.COMBOS[combo_idx]
		if matches(combo):
			Events.combo_achieved.emit(combo_idx)
			await get_tree().create_timer(reset_delay).timeout
			_reset_combo()
			return
