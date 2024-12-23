extends Panel

const textures={
	Types.BugType.Slug:  preload("res://assets/gfx/ui/ComboIcons/Slug_HUD.png"),
	Types.BugType.Beetle:preload("res://assets/gfx/ui/ComboIcons/Beetle_HUD.png"),
	Types.BugType.Fly:preload("res://assets/gfx/ui/ComboIcons/Fly_HUD.png"),
	Types.BugType.Moth:preload("res://assets/gfx/ui/ComboIcons/Moth_HUD.png"),
	Types.BugType.Snail:preload("res://assets/gfx/ui/ComboIcons/Snail_HUD.png"),
	Types.BugType.Worm:preload("res://assets/gfx/ui/ComboIcons/Worm_HUD.png"),
	Types.BugType.Cockroach:preload("res://assets/gfx/ui/ComboIcons/Roach_HUD.png"),
	Types.BugType.Spider:preload("res://assets/gfx/ui/ComboIcons/Spider_HUD.png"),

}

@export var reset_delay=1
@export var combo_timeout=3

@onready var icons:=[$HBoxContainer/Icons/Icon1, $HBoxContainer/Icons/Icon2, $HBoxContainer/Icons/Icon3]
var bugs=[null,null,null]
@onready var timer: Timer = $Timer

func _ready():
	_reset_combo()
	Events.bug_caught.connect(_on_bug_caught)
	timer.wait_time=combo_timeout

	#for bug in [Types.BugType.Snail,Types.BugType.Slug,Types.BugType.Fly,Types.BugType.Fly,Types.BugType.Moth]:
		#await get_tree().create_timer(.5).timeout
		#_on_bug_caught(bug)

func _reset_combo():
	for i in range(bugs.size()):
		bugs[i]=null
	update_bar()
	timer.stop()

func update_bar():
	for i in range(bugs.size()):
		icons[i].texture=null if bugs[i]==null else textures[bugs[i]]
	

func _on_bug_caught(bug: Bug):
	var type = bug.type
	for i in range(bugs.size()):
		if bugs[i] == null:
			bugs[i]=type
			process_check()
			return
			
	for i in range(bugs.size()-1):
		bugs[i]=bugs[i+1]
	bugs[bugs.size()-1]=type
	process_check()
func process_check():
	update_bar()
	if not check_combo():
		timer.start()
		$combo_add.play()				
	else:
		$combo_success.play()
		timer.stop()
		await get_tree().create_timer(reset_delay).timeout
		_reset_combo()
		
	
func matches(combo:Array)->bool:
	for i in range(combo.size()):
			if combo[i]!=bugs[i]:
				return false
	return true
	
func check_combo()->bool:
	for i in range(bugs.size()):
		if bugs[i]==null:
			return false
	for combo_key in Types.Combos.keys():
		var key = Types.Combos[combo_key]
		var combo = Types.COMBO_BUGS[key]
		if matches(combo):
			Events.combo_achieved.emit(combo_key)
			$combo_success.play()
			Logger.info("combo success")
			return true

	$combo_add.play()
	return false

func _on_timer_timeout() -> void:
	_reset_combo()
	$combo_drop.play()
	Logger.info("Combo dropped.")
