extends Node

var return_position: Vector2 = Vector2.ZERO
var has_return: bool = false


func set_return(pos: Vector2) -> void:
	return_position = pos
	has_return = true


func consume() -> Vector2:
	has_return = false
	return return_position
