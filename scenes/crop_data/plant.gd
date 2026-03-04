class_name Plant
extends RefCounted

# TODO: fertilized_by: CropData

var crop_data: CropData
var days_grown: int = 0


func _init(data: CropData, grown: int = 0) -> void:
	crop_data = data
	days_grown = grown
