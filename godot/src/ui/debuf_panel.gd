extends Panel

const ICON_SCENE:PackedScene = preload("res://src/ui/debuf_icon.tscn")
@onready var grid: GridContainer = $MarginContainer/GridContainer

var icon_map={}
func _ready():
	Events.debuf_applied.connect(_on_debuf_applied)
	Events.debuf_cancelled.connect(_on_debuf_cancelled)
	while grid.get_child_count()>0:
		var child = grid.get_child(0)
		grid.remove_child(child)
		child.queue_free()
	
	
func _on_debuf_applied(debuf:Debuf):
	if not debuf.show_in_ui:
		return 
	var icon = get_icon_for_debuf(debuf)
	if icon:
		grid.add_child(icon)
		icon_map[debuf.name]=icon		
	else:
		Logger.warn("Can't find icon for %s" % debuf.name)
	
func _on_debuf_cancelled(debuf:Debuf):
	if not debuf.show_in_ui:
		return 
	if debuf.name in icon_map:
		grid.remove_child(icon_map[debuf.name]) 
		icon_map.erase(debuf.name)
	else:
		Logger.warn("Tried to remove missing debuf %s" % debuf.name)
		
func get_icon_for_debuf(debuf:Debuf)->DebufIcon:
	if not debuf.name in Types.DEBUF_ICONS:
		return null
	var icon = ICON_SCENE.instantiate()	
	var texture = Types.DEBUF_ICONS[debuf.name]
	icon.debuf = debuf
	icon.texture = texture
	return icon
	
