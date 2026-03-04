extends Node

signal plots_advanced(field_name: String)

const STATE_SEEDED: int = 1
const STATE_GROWING: int = 2
const STATE_HARVESTABLE: int = 3

var _fields: Dictionary = {}
var _days_to_mature: Dictionary = {}


func _ready() -> void:
	DayNightCycle.time_changed.connect(_on_time_changed)


func register_field(field_name: String, days_to_mature: int) -> void:
	_days_to_mature[field_name] = days_to_mature


func save_plot(field_name: String, cell: Vector2i, state: int, days_grown: int) -> void:
	if not _fields.has(field_name):
		_fields[field_name] = {}
	_fields[field_name][str(cell)] = {"state": state, "days_grown": days_grown}


func get_field(field_name: String) -> Dictionary:
	return _fields.get(field_name, {})


func has_field(field_name: String) -> bool:
	return _fields.has(field_name)


func _on_time_changed(phase: DayPhase.Phase) -> void:
	if phase != DayPhase.Phase.DAWN:
		return
	for field_name: String in _fields:
		var mature: int = _days_to_mature.get(field_name, 0)
		for cell_key: String in _fields[field_name]:
			var entry: Dictionary = _fields[field_name][cell_key]
			var state: int = entry["state"]
			if state != STATE_SEEDED and state != STATE_GROWING:
				continue
			entry["days_grown"] += 1
			entry["state"] = STATE_HARVESTABLE if entry["days_grown"] >= mature else STATE_GROWING
		plots_advanced.emit(field_name)
