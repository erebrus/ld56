extends Node

const SCENE:PackedScene = preload("res://src/frog/debufs/invisible_debuf.tscn")

enum BugType {
	Slug,
	Spider,
	Beetle,
	Fly,
	Moth,
}


func key_of(value) -> String:
	if value is BugType:
		return BugType.keys()[value]
	
	return str(value)

const DEBUF_MAP = {
	BugType.Slug:  SCENE,
	BugType.Spider:SCENE,
	BugType.Beetle:SCENE,
	BugType.Fly:SCENE,
	BugType.Moth:SCENE
}
