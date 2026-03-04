extends StaticBody2D

@onready var light: PointLight2D = $PointLight2D
@onready var sprite: Sprite2D = $Sprite2D

const TINT_LIT := Color(1.0, 0.85, 0.4)
const TINT_UNLIT := Color(0.45, 0.3, 0.2)


func _ready() -> void:
	_build_sprite()
	_setup_light_texture()
	_setup_hitbox()
	DayNightCycle.time_changed.connect(_on_time_changed)
	_on_time_changed(DayNightCycle.current_phase)


func _setup_hitbox() -> void:
	var circle := CircleShape2D.new()
	circle.radius = Config.TILE_SIZE / 4.0
	$CollisionShape2D.shape = circle


func _build_sprite() -> void:
	var w: int = Config.TILE_SIZE / 2
	var h: int = Config.TILE_SIZE
	var img := Image.create(w, h, false, Image.FORMAT_RGBA8)
	# Handle (brown)
	for x in range(6, 10):
		for y in range(14, 32):
			img.set_pixel(x, y, Color(0.42, 0.24, 0.11))
	# Head wrap (darker brown)
	for x in range(4, 12):
		for y in range(10, 16):
			img.set_pixel(x, y, Color(0.55, 0.37, 0.18))
	# Flame outer (orange)
	for x in range(4, 12):
		for y in range(4, 10):
			img.set_pixel(x, y, Color(1.0, 0.55, 0.0, 0.9))
	# Flame inner (yellow)
	for x in range(5, 11):
		for y in range(2, 8):
			img.set_pixel(x, y, Color(1.0, 0.9, 0.2))
	sprite.texture = ImageTexture.create_from_image(img)
	sprite.modulate = TINT_UNLIT


func _setup_light_texture() -> void:
	var grad := Gradient.new()
	grad.set_color(0, Color(1, 1, 1, 1))
	grad.set_color(1, Color(1, 1, 1, 0))
	var tex := GradientTexture2D.new()
	tex.gradient = grad
	tex.fill = GradientTexture2D.FILL_RADIAL
	tex.fill_from = Vector2(0.5, 0.5)
	tex.fill_to = Vector2(1.0, 0.5)
	tex.width = 128
	tex.height = 128
	light.texture = tex


func _on_time_changed(phase: DayPhase.Phase) -> void:
	var lit: bool = phase == DayPhase.Phase.DUSK or phase == DayPhase.Phase.NIGHT
	light.enabled = lit
	sprite.modulate = TINT_LIT if lit else TINT_UNLIT
