extends CharacterBody2D

const SPEED: float = 6.25 * Config.TILE_SIZE

var direction: Direction.Dir = Direction.Dir.DOWN

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(_delta: float) -> void:
	var input := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if input != Vector2.ZERO:
		direction = Direction.from_vec(input)
		if input.x != 0.0:
			animated_sprite.flip_h = input.x < 0.0
		animated_sprite.play("run")
	else:
		animated_sprite.play("idle")
	velocity = input * SPEED
	move_and_slide()
