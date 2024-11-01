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
		if bug1_node:
			bug1_node.texture = Types.BUG_ALMANAC_TEXTURES[bug1]
		

@export var bug2: Types.BugType:
	set(value):
		bug2 = value
		if bug2_node:
			bug2_node.texture = Types.BUG_ALMANAC_TEXTURES[bug2]


@export var bug3: Types.BugType:
	set(value):
		bug3 = value
		if bug3_node:
			bug3_node.texture = Types.BUG_ALMANAC_TEXTURES[bug3]

@onready var bug1_node: TextureRect = %Bug1
@onready var bug2_node: TextureRect = %Bug2
@onready var bug3_node: TextureRect = %Bug3

func _ready() -> void:
	bug1_node.texture = Types.BUG_ALMANAC_TEXTURES[bug1]
	bug2_node.texture = Types.BUG_ALMANAC_TEXTURES[bug2]
	bug3_node.texture = Types.BUG_ALMANAC_TEXTURES[bug3]
