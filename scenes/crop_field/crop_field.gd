class_name CropField
extends Node2D

@export var crop_data: CropData
@export var crop_plot_scene: PackedScene

@onready var _fertile_ground: TileMapLayer = $FertileGround

var _cell_map: Dictionary = {}


func _ready() -> void:
	_fertile_ground.visible = false
	if crop_plot_scene == null:
		push_error("CropField: crop_plot_scene is not assigned on " + name)
		return
	if crop_data == null:
		push_error("CropField: crop_data is not assigned on " + name)
		return
	FieldRegistry.register_field(name, crop_data.days_to_mature)
	FieldRegistry.plots_advanced.connect(_on_plots_advanced)
	var saved: Dictionary = FieldRegistry.get_field(name)
	for cell: Vector2i in _fertile_ground.get_used_cells():
		var plot: CropPlot = crop_plot_scene.instantiate() as CropPlot
		plot.crop_data = crop_data
		add_child(plot)
		plot.global_position = _fertile_ground.to_global(_fertile_ground.map_to_local(cell))
		_cell_map[plot] = cell
		plot.state_changed.connect(_on_plot_state_changed.bind(cell))
		var cell_key: String = str(cell)
		if saved.has(cell_key):
			var entry: Dictionary = saved[cell_key]
			plot.restore_state(entry["state"], entry["days_grown"])


func _on_plot_state_changed(state: int, days_grown: int, cell: Vector2i) -> void:
	FieldRegistry.save_plot(name, cell, state, days_grown)


func _on_plots_advanced(field_name: String) -> void:
	if field_name != name:
		return
	var saved: Dictionary = FieldRegistry.get_field(name)
	for plot: CropPlot in _cell_map:
		var cell_key: String = str(_cell_map[plot])
		if saved.has(cell_key):
			var entry: Dictionary = saved[cell_key]
			plot.restore_state(entry["state"], entry["days_grown"])
