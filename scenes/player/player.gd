extends CharacterBody2D

signal interactable_focused(prompt: String)
signal interactable_cleared

const SPEED: float = 6.25 * Config.TILE_SIZE

@export var debug_show_range: bool = true

var direction: Direction.Dir = Direction.Dir.DOWN

var _interactable_target: Interactable = null
var _interactable_candidates: Array[Interactable] = []

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var interaction_zone: Area2D = $InteractionZone
@onready var _interaction_shape: CircleShape2D = $InteractionZone/InteractionShape.shape as CircleShape2D


func _ready() -> void:
	interaction_zone.area_entered.connect(_on_interaction_zone_area_entered)
	interaction_zone.area_exited.connect(_on_interaction_zone_area_exited)
	interactable_focused.connect(HUD.show_prompt)
	interactable_cleared.connect(HUD.hide_prompt)
	queue_redraw()


func _draw() -> void:
	if not debug_show_range:
		return
	draw_arc(Vector2.ZERO, _interaction_shape.radius, 0.0, TAU, 32, Color(1, 1, 0, 0.8), 1.5)


func _physics_process(_delta: float) -> void:
	var input := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if input != Vector2.ZERO:
		direction = Direction.from_vec(input)
		if input.x != 0.0:
			animated_sprite.flip_h = input.x < 0.0
		animated_sprite.play("run")
	else:
		animated_sprite.play("idle")
	velocity = input * SPEED
	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_echo() or not event.is_action_pressed("interact"):
		return
	if _interactable_target == null:
		return
	_interactable_target.interact(self)
	var prompt: String = _interactable_target.get_prompt()
	if prompt.is_empty():
		interactable_cleared.emit()
	else:
		interactable_focused.emit(prompt)


func _on_interaction_zone_area_entered(area: Area2D) -> void:
	if area is not Interactable:
		return
	_interactable_candidates.append(area as Interactable)
	_refresh_target()


func _on_interaction_zone_area_exited(area: Area2D) -> void:
	if area is not Interactable:
		return
	_interactable_candidates.erase(area)
	_refresh_target()


func _refresh_target() -> void:
	var best: Interactable = null
	var best_dist: float = INF
	for candidate: Interactable in _interactable_candidates:
		if candidate.get_prompt().is_empty():
			continue
		var dist: float = global_position.distance_to(candidate.global_position)
		if dist < best_dist:
			best_dist = dist
			best = candidate
	if best == _interactable_target:
		return
	_interactable_target = best
	if _interactable_target != null:
		interactable_focused.emit(_interactable_target.get_prompt())
	else:
		interactable_cleared.emit()
