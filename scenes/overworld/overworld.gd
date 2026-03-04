extends Node2D

@onready var canvas_modulate: CanvasModulate = $CanvasModulate
@onready var player: CharacterBody2D = $Player
@onready var torch_markers: Node2D = $TorchMarkers
@onready var ground: TileMapLayer = $Ground

const PHASE_COLORS: Dictionary = {
	DayPhase.Phase.DAWN:  Color(1.0, 0.75, 0.5),
	DayPhase.Phase.DAY:   Color(1.0, 1.0,  1.0),
	DayPhase.Phase.DUSK:  Color(0.8, 0.5,  0.3),
	DayPhase.Phase.NIGHT: Color(0.1, 0.15, 0.3),
}

const WALL_GAP_COL: int = 25
const WALL_GAP_ROWS: Array[int] = [11, 12, 13]
const WALL_GATE_RETURN_OFFSET: Vector2 = Vector2(-128.0, 0.0)
const FLAPPY_CAVE_SCENE: String = "res://scenes/flappy_cave/flappy_cave.tscn"


func _ready() -> void:
	_clear_wall_gap()

	if TransitionData.has_return:
		player.position = TransitionData.consume()

	DayNightCycle.time_changed.connect(_on_time_changed)
	_on_time_changed(DayNightCycle.current_phase)


func _on_time_changed(phase: DayPhase.Phase) -> void:
	canvas_modulate.color = PHASE_COLORS[phase]


func _on_wall_gate_entered(body: Node2D) -> void:
	if body is not CharacterBody2D:
		return
	TransitionData.set_return(body.global_position + WALL_GATE_RETURN_OFFSET)
	get_tree().change_scene_to_file(FLAPPY_CAVE_SCENE)


func _clear_wall_gap() -> void:
	for row: int in WALL_GAP_ROWS:
		ground.erase_cell(Vector2i(WALL_GAP_COL, row))
