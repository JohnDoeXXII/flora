extends StaticBody2D

@onready var door_area: Area2D = $DoorArea


func _ready() -> void:
	# Disable monitoring for one physics frame so a player returning to this
	# position from the interior doesn't immediately re-trigger the door.
	door_area.monitoring = false
	await get_tree().physics_frame
	door_area.monitoring = true


func _on_door_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		TransitionData.set_return(global_position)
		get_tree().change_scene_to_file("res://scenes/hut_interior/hut_interior.tscn")
