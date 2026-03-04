class_name CropPlot
extends Interactable

enum State { FERTILE, SEEDED, GROWING, HARVESTABLE }

signal state_changed(state: int, days_grown: int)

@export var crop_data: CropData

var _state: State = State.FERTILE
var _plant: Plant = null

@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
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
			_plant = Plant.new(crop_data)
			_state = State.SEEDED
		State.HARVESTABLE:
			Inventory.add_gold(_plant.type.harvest_gold)
			_plant = null
			_state = State.FERTILE
	_update_visuals()
	state_changed.emit(_state, _plant.days_grown if _plant else 0)


func restore_state(state: int, days_grown: int) -> void:
	_state = state as State
	if _state != State.FERTILE:
		_plant = Plant.new(crop_data, days_grown)
	_update_visuals()


func _update_visuals() -> void:
	if crop_data == null:
		push_error("CropPlot: crop_data is not assigned on " + name)
		return
	match _state:
		State.FERTILE:
			sprite.texture = crop_data.sprite_fertile
		State.SEEDED:
			sprite.texture = _plant.type.sprite_seeded
		State.GROWING:
			sprite.texture = _plant.type.sprite_growing
		State.HARVESTABLE:
			sprite.texture = _plant.type.sprite_harvestable
