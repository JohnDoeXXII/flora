extends CharacterBody2D

const SPEED: float = 6.25 * Config.TILE_SIZE  # 200px/s

var direction: Direction.Dir = Direction.Dir.DOWN


func _ready() -> void:
	var capsule := CapsuleShape2D.new()
	capsule.radius = Config.TILE_SIZE / 4.0
	capsule.height = float(Config.TILE_SIZE)
	$CollisionShape2D.shape = capsule


func _physics_process(delta: float) -> void:
	var input := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if input != Vector2.ZERO:
		direction = Direction.from_vec(input)
	velocity = input * SPEED
	move_and_slide()
