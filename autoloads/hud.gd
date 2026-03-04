extends CanvasLayer

const GOLD_LABEL_POSITION: Vector2 = Vector2(16.0, 16.0)

var _gold_label: Label
var _prompt_label: Label


func _ready() -> void:
	_gold_label = Label.new()
	_gold_label.position = GOLD_LABEL_POSITION
	add_child(_gold_label)

	_prompt_label = Label.new()
	_prompt_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_prompt_label.anchor_left = 0.5
	_prompt_label.anchor_right = 0.5
	_prompt_label.anchor_bottom = 1.0
	_prompt_label.anchor_top = 1.0
	_prompt_label.offset_top = -48.0
	_prompt_label.offset_bottom = -16.0
	_prompt_label.offset_left = -128.0
	_prompt_label.offset_right = 128.0
	_prompt_label.visible = false
	add_child(_prompt_label)

	Inventory.gold_changed.connect(_on_gold_changed)
	_on_gold_changed(Inventory.get_gold())


func _on_gold_changed(amount: int) -> void:
	_gold_label.text = "Gold: " + str(amount)


func show_prompt(text: String) -> void:
	_prompt_label.text = "E: " + text
	_prompt_label.visible = true


func hide_prompt() -> void:
	_prompt_label.visible = false
