extends CanvasLayer

const FADE_DURATION: float = 0.5

var _overlay: ColorRect


func _ready() -> void:
	layer = 100

	_overlay = ColorRect.new()
	_overlay.color = Color.BLACK
	_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_overlay.modulate.a = 0.0
	_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_overlay)


func fade_out(duration: float = FADE_DURATION) -> void:
	var tween: Tween = create_tween()
	tween.tween_property(_overlay, "modulate:a", 1.0, duration)
	await tween.finished


func fade_in(duration: float = FADE_DURATION) -> void:
	var tween: Tween = create_tween()
	tween.tween_property(_overlay, "modulate:a", 0.0, duration)
	await tween.finished
