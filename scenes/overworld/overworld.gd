extends Node2D

# Fallback used only when the TileMap has no painted tiles yet.
const DEFAULT_WORLD_SIZE: int = 40 * Config.TILE_SIZE  # 2560px — 40 tiles
const BORDER_SIZE: int = Config.TILE_SIZE / 2           # 32px  — half tile

@onready var canvas_modulate: CanvasModulate = $CanvasModulate
@onready var ground_layer: TileMapLayer = $Ground
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
@onready var torch_markers: Node2D = $TorchMarkers

const PHASE_COLORS: Dictionary = {
	DayPhase.Phase.DAWN:  Color(1.0, 0.75, 0.5),
	DayPhase.Phase.DAY:   Color(1.0, 1.0,  1.0),
	DayPhase.Phase.DUSK:  Color(0.8, 0.5,  0.3),
	DayPhase.Phase.NIGHT: Color(0.1, 0.15, 0.3),
}


func _ready() -> void:
	var world: Vector2i = _world_size_px()
	var bs: int = BORDER_SIZE

	# Wall collision shapes
	var h_shape := RectangleShape2D.new()
	h_shape.size = Vector2(world.x, bs)
	var v_shape := RectangleShape2D.new()
	v_shape.size = Vector2(bs, world.y)

	top_wall.position    = Vector2(world.x / 2.0, -bs / 2.0)
	top_wall.get_node("CollisionShape2D").shape = h_shape

	bottom_wall.position = Vector2(world.x / 2.0, world.y + bs / 2.0)
	bottom_wall.get_node("CollisionShape2D").shape = h_shape

	left_wall.position   = Vector2(-bs / 2.0, world.y / 2.0)
	left_wall.get_node("CollisionShape2D").shape = v_shape

	right_wall.position  = Vector2(world.x + bs / 2.0, world.y / 2.0)
	right_wall.get_node("CollisionShape2D").shape = v_shape

	# Border strips
	top_border.offset_left    = -bs
	top_border.offset_top     = -bs
	top_border.offset_right   = world.x + bs
	top_border.offset_bottom  = 0

	bottom_border.offset_left   = -bs
	bottom_border.offset_top    = world.y
	bottom_border.offset_right  = world.x + bs
	bottom_border.offset_bottom = world.y + bs

	left_border.offset_left   = -bs
	left_border.offset_top    = 0
	left_border.offset_right  = 0
	left_border.offset_bottom = world.y

	right_border.offset_left   = world.x
	right_border.offset_top    = 0
	right_border.offset_right  = world.x + bs
	right_border.offset_bottom = world.y

	# Player spawn: return to entry point if set, otherwise center
	if TransitionData.has_return:
		player.position = TransitionData.consume()
	else:
		player.position = Vector2(world.x / 2.0, world.y / 2.0)

	# Camera limits include border
	camera.limit_left   = -bs
	camera.limit_top    = -bs
	camera.limit_right  = world.x + bs
	camera.limit_bottom = world.y + bs

	DayNightCycle.time_changed.connect(_on_time_changed)
	_on_time_changed(DayNightCycle.current_phase)
	_spawn_torches()


func _world_size_px() -> Vector2i:
	var rect: Rect2i = ground_layer.get_used_rect()
	if rect.size == Vector2i.ZERO:
		push_warning("Overworld Ground layer has no tiles — using DEFAULT_WORLD_SIZE fallback")
		return Vector2i(DEFAULT_WORLD_SIZE, DEFAULT_WORLD_SIZE)
	return rect.size * Config.TILE_SIZE


func _spawn_torches() -> void:
	var torch_scene := load("res://scenes/torch/torch.tscn") as PackedScene
	for marker: Marker2D in torch_markers.get_children():
		var torch: Node2D = torch_scene.instantiate()
		torch.position = marker.position
		add_child(torch)


func _on_time_changed(phase: DayPhase.Phase) -> void:
	canvas_modulate.color = PHASE_COLORS[phase]
