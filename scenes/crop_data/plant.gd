class_name Plant
extends RefCounted

# TODO: fertilized_by: CropData

var type: CropData
var days_grown: int = 0


func _init(data: CropData, grown: int = 0) -> void:
	type = data
	days_grown = grown
