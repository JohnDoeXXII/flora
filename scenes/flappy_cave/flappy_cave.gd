extends Node2D

const OBSTACLE_SCENE: PackedScene = preload("res://scenes/flappy_cave/obstacle_pair.tscn")

const SPAWN_INTERVAL: float = 2.2
const SPAWN_X_OFFSET: float = 100.0
const GAP_MARGIN_TOP: float = 150.0
const GAP_MARGIN_BOTTOM: float = 150.0

var _elapsed_time: float = 0.0
var _game_over: bool = false

@onready var bird: CharacterBody2D = $Bird
@onready var spawn_timer: Timer = $SpawnTimer
@onready var time_label: Label = $SceneHUD/TimeLabel
@onready var countdown_label: Label = $SceneHUD/CountdownLabel
@onready var top_boundary: StaticBody2D = $TopBoundary
@onready var bottom_boundary: StaticBody2D = $BottomBoundary
@onready var obstacle_container: Node2D = $ObstacleContainer


func _ready() -> void:
	var screen_size: Vector2 = get_viewport_rect().size
	bird.position = Vector2(screen_size.x * 0.25, screen_size.y * 0.5)
	top_boundary.position = Vector2(screen_size.x * 0.5, -20.0)
	bottom_boundary.position = Vector2(screen_size.x * 0.5, screen_size.y + 20.0)
	bird.hit_obstacle.connect(_on_game_over)
	_run_countdown()


func _run_countdown() -> void:
	set_process(false)
	bird.set_physics_process(false)
	bird.set_process_unhandled_input(false)
	countdown_label.visible = true

	const STEP: float = 0.5
	countdown_label.text = "2"
	await get_tree().create_timer(STEP).timeout
	countdown_label.text = "1"
	await get_tree().create_timer(STEP).timeout
	countdown_label.text = "Go!"
	await get_tree().create_timer(STEP).timeout

	countdown_label.visible = false
	bird.set_physics_process(true)
	bird.set_process_unhandled_input(true)
	set_process(true)
	spawn_timer.start()


func _process(delta: float) -> void:
	if _game_over:
		return
	_elapsed_time += delta
	time_label.text = "Time: " + str(snappedf(_elapsed_time, 0.1)) + "s"


func _on_spawn_timer_timeout() -> void:
	if _game_over:
		return
	var screen_size: Vector2 = get_viewport_rect().size
	var obstacle: Node2D = OBSTACLE_SCENE.instantiate()
	var rand_y: float = randf_range(GAP_MARGIN_TOP, screen_size.y - GAP_MARGIN_BOTTOM)
	obstacle.position = Vector2(screen_size.x + SPAWN_X_OFFSET, rand_y)
	obstacle_container.add_child(obstacle)


func _on_game_over() -> void:
	if _game_over:
		return
	_game_over = true
	var gold: int = int(_elapsed_time)
	Inventory.add_gold(gold)
	get_tree().change_scene_to_file("res://scenes/overworld/overworld.tscn")
