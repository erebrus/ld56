extends Node


enum BugType {
	Slug,
	Spider,
	Beetle,
	Fly
}


func key_of(value) -> String:
	if value is BugType:
		return BugType.keys()[value]
	
	return str(value)
