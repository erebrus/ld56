@tool
extends VBoxContainer

@export var title: String:
	set(value):
		title = value
		$Title.text = title
		

@export var description: String:
	set(value):
		description = value
		$Description.text = description

@export var bug1: Types.BugType:
	set(value):
		bug1 = value
		$Bugs/Bug1.texture = Types.BUG_ALMANAC_TEXTURES[value]
		

@export var bug2: Types.BugType:
	set(value):
		bug2 = value
		$Bugs/Bug2.texture = Types.BUG_ALMANAC_TEXTURES[value]


@export var bug3: Types.BugType:
	set(value):
		bug3 = value
		$Bugs/Bug3.texture = Types.BUG_ALMANAC_TEXTURES[value]
