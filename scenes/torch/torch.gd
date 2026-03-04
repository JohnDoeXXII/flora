extends StaticBody2D

@onready var light: PointLight2D = $PointLight2D
@onready var sprite: Sprite2D = $Sprite2D

const TINT_LIT := Color(1.0, 0.85, 0.4)
const TINT_UNLIT := Color(0.45, 0.3, 0.2)


func _ready() -> void:
	DayNightCycle.time_changed.connect(_on_time_changed)
	_on_time_changed(DayNightCycle.current_phase)


func _on_time_changed(phase: DayPhase.Phase) -> void:
	var lit: bool = phase == DayPhase.Phase.DUSK or phase == DayPhase.Phase.NIGHT
	light.enabled = lit
	sprite.modulate = TINT_LIT if lit else TINT_UNLIT
