extends Node


enum BugType {
	Slug,
	Spider,
}


func key_of(value) -> String:
	if value is BugType:
		return BugType.keys()[value]
	
	return str(value)
