extends Node2D


func _on_exit_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		var entrance: Vector2 = TransitionData.return_position
		TransitionData.set_return(entrance + Direction.to_vec(body.direction) * Config.TILE_SIZE)
		get_tree().change_scene_to_file("res://scenes/game/game.tscn")
