extends Node2D

const WORLD_SIZE: int = 40 * Config.TILE_SIZE  # 1280px — 40 tiles
const BORDER_SIZE: int = Config.TILE_SIZE / 2  # 16px  — half tile
const TORCH_OFFSET: int = 3 * Config.TILE_SIZE # 96px  — 3 tiles * 1.5

@onready var canvas_modulate: CanvasModulate = $CanvasModulate

# CanvasModulate tint per phase
const PHASE_COLORS := {
	DayPhase.Phase.DAWN:  Color(1.0, 0.75, 0.5),
	DayPhase.Phase.DAY:   Color(1.0, 1.0,  1.0),
	DayPhase.Phase.DUSK:  Color(0.8, 0.5,  0.3),
	DayPhase.Phase.NIGHT: Color(0.1, 0.15, 0.3),
}

@onready var background: TextureRect = $Background
@onready var top_wall: StaticBody2D = $Walls/TopWall
@onready var bottom_wall: StaticBody2D = $Walls/BottomWall
@onready var left_wall: StaticBody2D = $Walls/LeftWall
@onready var right_wall: StaticBody2D = $Walls/RightWall
@onready var top_border: ColorRect = $Border/TopBorder
@onready var bottom_border: ColorRect = $Border/BottomBorder
@onready var left_border: ColorRect = $Border/LeftBorder
@onready var right_border: ColorRect = $Border/RightBorder
@onready var player: CharacterBody2D = $Player
@onready var camera: Camera2D = $Player/Camera2D


func _ready() -> void:
	var ws: int = WORLD_SIZE
	var bs: int = BORDER_SIZE
	var half: float = ws / 2.0

	# Background
	background.offset_right = ws
	background.offset_bottom = ws

	# Wall collision shapes
	var h_shape := RectangleShape2D.new()
	h_shape.size = Vector2(ws, bs)
	var v_shape := RectangleShape2D.new()
	v_shape.size = Vector2(bs, ws)

	top_wall.position = Vector2(half, -bs / 2.0)
	top_wall.get_node("CollisionShape2D").shape = h_shape

	bottom_wall.position = Vector2(half, ws + bs / 2.0)
	bottom_wall.get_node("CollisionShape2D").shape = h_shape

	left_wall.position = Vector2(-bs / 2.0, half)
	left_wall.get_node("CollisionShape2D").shape = v_shape

	right_wall.position = Vector2(ws + bs / 2.0, half)
	right_wall.get_node("CollisionShape2D").shape = v_shape

	# Border strips
	top_border.offset_left = -bs
	top_border.offset_top = -bs
	top_border.offset_right = ws + bs
	top_border.offset_bottom = 0

	bottom_border.offset_left = -bs
	bottom_border.offset_top = ws
	bottom_border.offset_right = ws + bs
	bottom_border.offset_bottom = ws + bs

	left_border.offset_left = -bs
	left_border.offset_top = 0
	left_border.offset_right = 0
	left_border.offset_bottom = ws

	right_border.offset_left = ws
	right_border.offset_top = 0
	right_border.offset_right = ws + bs
	right_border.offset_bottom = ws

	# Player spawn: return to entry point if set, otherwise center
	if TransitionData.has_return:
		player.position = TransitionData.consume()
	else:
		player.position = Vector2(half, half)

	# Camera limits include border
	camera.limit_left = -bs
	camera.limit_top = -bs
	camera.limit_right = ws + bs
	camera.limit_bottom = ws + bs

	DayNightCycle.time_changed.connect(_on_time_changed)
	# Apply initial phase immediately
	_on_time_changed(DayNightCycle.current_phase)
	_spawn_torches()


func _spawn_torches() -> void:
	var torch_scene := load("res://scenes/torch/torch.tscn") as PackedScene
	var spawn := Vector2(WORLD_SIZE / 2.0, WORLD_SIZE / 2.0)
	var offsets := [
		Vector2(-TORCH_OFFSET, -TORCH_OFFSET),
		Vector2(-TORCH_OFFSET,  TORCH_OFFSET),
		Vector2( TORCH_OFFSET, -TORCH_OFFSET),
		Vector2( TORCH_OFFSET,  TORCH_OFFSET),
	]
	for offset in offsets:
		var torch := torch_scene.instantiate()
		torch.position = spawn + offset
		add_child(torch)


func _on_time_changed(phase: DayPhase.Phase) -> void:
	canvas_modulate.color = PHASE_COLORS[phase]
