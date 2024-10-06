extends Node


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
