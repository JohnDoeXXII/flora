class_name CropField
extends Node2D

@export var crop_data: CropData
@export var crop_plot_scene: PackedScene

@onready var _fertile_ground: TileMapLayer = $FertileGround


func _ready() -> void:
	_fertile_ground.visible = false
	if crop_plot_scene == null:
		push_error("CropField: crop_plot_scene is not assigned on " + name)
		return
	if crop_data == null:
		push_error("CropField: crop_data is not assigned on " + name)
		return
	for cell: Vector2i in _fertile_ground.get_used_cells():
		var plot: CropPlot = crop_plot_scene.instantiate() as CropPlot
		plot.crop_data = crop_data
		add_child(plot)
		plot.global_position = _fertile_ground.to_global(_fertile_ground.map_to_local(cell))
