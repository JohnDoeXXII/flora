extends Node2D

const SCROLL_SPEED: float = 220.0
const DESPAWN_X: float = -200.0


func _process(delta: float) -> void:
	position.x -= SCROLL_SPEED * delta
	if position.x < DESPAWN_X:
		queue_free()
