extends Node

signal gold_changed(amount: int)

var _gold: int = 0


func add_gold(amount: int) -> void:
	_gold += amount
	gold_changed.emit(_gold)


func get_gold() -> int:
	return _gold
