extends CanvasLayer

const GOLD_LABEL_POSITION: Vector2 = Vector2(16.0, 16.0)

var _gold_label: Label


func _ready() -> void:
	_gold_label = Label.new()
	_gold_label.position = GOLD_LABEL_POSITION
	add_child(_gold_label)

	Inventory.gold_changed.connect(_on_gold_changed)
	_on_gold_changed(Inventory.get_gold())


func _on_gold_changed(amount: int) -> void:
	_gold_label.text = "Gold: " + str(amount)
