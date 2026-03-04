extends Node

var _fields: Dictionary = {}


func save_plot(field_name: String, cell: Vector2i, state: int, days_grown: int) -> void:
	if not _fields.has(field_name):
		_fields[field_name] = {}
	_fields[field_name][str(cell)] = {"state": state, "days_grown": days_grown}


func get_field(field_name: String) -> Dictionary:
	return _fields.get(field_name, {})


func has_field(field_name: String) -> bool:
	return _fields.has(field_name)
