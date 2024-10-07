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
		if $Bugs/Bug1:
			$Bugs/Bug1.texture = Types.BUG_ALMANAC_TEXTURES[bug1]
		

@export var bug2: Types.BugType:
	set(value):
		bug2 = value
		if $Bugs/Bug2:
			$Bugs/Bug2.texture = Types.BUG_ALMANAC_TEXTURES[bug2]


@export var bug3: Types.BugType:
	set(value):
		bug3 = value
		if $Bugs/Bug3:
			$Bugs/Bug3.texture = Types.BUG_ALMANAC_TEXTURES[bug3]

func _ready() -> void:
	$Bugs/Bug1.texture = Types.BUG_ALMANAC_TEXTURES[bug1]
	$Bugs/Bug2.texture = Types.BUG_ALMANAC_TEXTURES[bug2]
	$Bugs/Bug3.texture = Types.BUG_ALMANAC_TEXTURES[bug3]
