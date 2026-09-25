extends Node2D

@export_enum("level_1", "level_2", "level_3") var layout_id := "level_1"

const LAYOUTS := {
	"level_1": [
		Rect2(0, 620, 3600, 120), Rect2(380, 500, 280, 32), Rect2(820, 430, 260, 32),
		Rect2(1240, 540, 300, 32), Rect2(1680, 450, 260, 32), Rect2(2140, 360, 280, 32),
		Rect2(2600, 470, 300, 32), Rect2(3120, 390, 260, 32)
	],
	"level_2": [
		Rect2(0, 620, 3900, 120), Rect2(320, 500, 260, 32), Rect2(760, 400, 240, 32),
		Rect2(1180, 520, 260, 32), Rect2(1600, 350, 260, 32), Rect2(2040, 470, 300, 32),
		Rect2(2480, 320, 250, 32), Rect2(2920, 450, 300, 32), Rect2(3440, 360, 280, 32)
	],
	"level_3": [
		Rect2(0, 620, 4400, 120), Rect2(360, 500, 260, 32), Rect2(780, 380, 250, 32),
		Rect2(1180, 500, 240, 32), Rect2(1540, 320, 280, 32), Rect2(2040, 460, 280, 32),
		Rect2(2500, 350, 240, 32), Rect2(2920, 500, 300, 32), Rect2(3420, 390, 260, 32),
		Rect2(3860, 300, 300, 32)
	]
}

func _ready() -> void:
	for platform_rect in LAYOUTS.get(layout_id, LAYOUTS.level_1):
		_create_platform(platform_rect)

func _create_platform(platform_rect: Rect2) -> void:
	var body := StaticBody2D.new()
	body.position = platform_rect.position + platform_rect.size * 0.5
	add_child(body)

	var collision := CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = platform_rect.size
	collision.shape = shape
	body.add_child(collision)

	var platform := Polygon2D.new()
	platform.polygon = PackedVector2Array([
		Vector2(-platform_rect.size.x * 0.5, -platform_rect.size.y * 0.5),
		Vector2(platform_rect.size.x * 0.5, -platform_rect.size.y * 0.5),
		Vector2(platform_rect.size.x * 0.5, platform_rect.size.y * 0.5),
		Vector2(-platform_rect.size.x * 0.5, platform_rect.size.y * 0.5)
	])
	platform.color = Color(0.10, 0.17, 0.24, 1.0)
	body.add_child(platform)

	var edge := Polygon2D.new()
	edge.polygon = PackedVector2Array([
		Vector2(-platform_rect.size.x * 0.5, -platform_rect.size.y * 0.5),
		Vector2(platform_rect.size.x * 0.5, -platform_rect.size.y * 0.5),
		Vector2(platform_rect.size.x * 0.5, -platform_rect.size.y * 0.5 + 6),
		Vector2(-platform_rect.size.x * 0.5, -platform_rect.size.y * 0.5 + 6)
	])
	edge.color = Color(0.98, 0.77, 0.36, 1.0)
	body.add_child(edge)
