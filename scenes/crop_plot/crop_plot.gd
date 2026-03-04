class_name CropPlot
extends Interactable

enum State { FERTILE, SEEDED, GROWING, HARVESTABLE }

@export var crop_data: CropData

var _state: State = State.FERTILE
var _days_grown: int = 0

@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	DayNightCycle.time_changed.connect(_on_time_changed)
	_update_visuals()


func get_prompt() -> String:
	match _state:
		State.FERTILE:
			return "Till & Plant"
		State.HARVESTABLE:
			return "Harvest"
		_:
			return ""


func interact(initiator: Node2D) -> void:
	match _state:
		State.FERTILE:
			_state = State.SEEDED
			_days_grown = 0
		State.HARVESTABLE:
			Inventory.add_gold(crop_data.harvest_gold)
			_state = State.FERTILE
			_days_grown = 0
	_update_visuals()


func _on_time_changed(phase: DayPhase.Phase) -> void:
	if phase != DayPhase.Phase.DAWN:
		return
	if _state != State.SEEDED and _state != State.GROWING:
		return
	_days_grown += 1
	_state = State.HARVESTABLE if _days_grown >= crop_data.days_to_mature else State.GROWING
	_update_visuals()


func _update_visuals() -> void:
	if crop_data == null:
		push_error("CropPlot: crop_data is not assigned on " + name)
		return
	match _state:
		State.FERTILE:
			sprite.texture = crop_data.sprite_fertile
		State.SEEDED:
			sprite.texture = crop_data.sprite_seeded
		State.GROWING:
			sprite.texture = crop_data.sprite_growing
		State.HARVESTABLE:
			sprite.texture = crop_data.sprite_harvestable
