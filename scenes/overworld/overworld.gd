extends Node2D

@onready var canvas_modulate: CanvasModulate = $CanvasModulate
@onready var player: CharacterBody2D = $Player
@onready var torch_markers: Node2D = $TorchMarkers

const PHASE_COLORS: Dictionary = {
	DayPhase.Phase.DAWN:  Color(1.0, 0.75, 0.5),
	DayPhase.Phase.DAY:   Color(1.0, 1.0,  1.0),
	DayPhase.Phase.DUSK:  Color(0.8, 0.5,  0.3),
	DayPhase.Phase.NIGHT: Color(0.1, 0.15, 0.3),
}


func _ready() -> void:
	if TransitionData.has_return:
		player.position = TransitionData.consume()

	DayNightCycle.time_changed.connect(_on_time_changed)
	_on_time_changed(DayNightCycle.current_phase)


func _on_time_changed(phase: DayPhase.Phase) -> void:
	canvas_modulate.color = PHASE_COLORS[phase]
