extends CharacterBody2D

signal hit_obstacle

const GRAVITY: float = 1800.0
const FLAP_FORCE: float = -550.0

@onready var collision_shape: CollisionShape2D = $CollisionShape2D


func _physics_process(delta: float) -> void:
	velocity.y += GRAVITY * delta
	move_and_slide()

	if get_slide_collision_count() > 0:
		hit_obstacle.emit()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		velocity.y = FLAP_FORCE
