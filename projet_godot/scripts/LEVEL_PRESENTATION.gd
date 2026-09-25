extends Node

@export_enum("level_1", "level_2", "level_3", "boss") var level_id := "level_1"

const BACKGROUNDS := {
	"level_1": preload("res://assets/spritesheets/backround/puhzil.png"),
	"level_2": preload("res://assets/spritesheets/backround/cave (1).png"),
	"level_3": preload("res://assets/spritesheets/tile_map/PNG/Background/Pale/Background.png"),
	"boss": preload("res://assets/spritesheets/backround/bulkhead-walls-files/bulkhead-walls-files/layers/bulkhead-walls-back.png")
}

const TITLES := {
	"level_1": "SECTEUR 01  /  INITIATION",
	"level_2": "SECTEUR 02  /  LES ETOILES",
	"level_3": "SECTEUR 03  /  L'ASCENSION",
	"boss": "SECTEUR 04  /  LE GARDIEN"
}

const OBJECTIVES := {
	"level_1": "Avance, recupere les bonus et atteins la porte.",
	"level_2": "Explore la zone et rassemble les etoiles pour ouvrir la voie.",
	"level_3": "Maitrise l'attaque et prepare-toi pour l'arene finale.",
	"boss": "Vaincs le gardien, puis echappe-toi avant l'effondrement."
}

func _ready() -> void:
	_build_backdrop()
	_build_status_panel()

func _build_backdrop() -> void:
	var canvas := CanvasLayer.new()
	canvas.layer = -10
	canvas.name = "Atmosphere"
	add_child(canvas)

	var background := TextureRect.new()
	background.texture = BACKGROUNDS.get(level_id, BACKGROUNDS.level_1)
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	background.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	background.modulate = Color(0.48, 0.52, 0.62, 1.0)
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	canvas.add_child(background)

	var shade := ColorRect.new()
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	shade.color = Color(0.025, 0.04, 0.08, 0.45)
	shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	canvas.add_child(shade)

func _build_status_panel() -> void:
	var canvas := CanvasLayer.new()
	canvas.layer = 4
	canvas.name = "LevelStatus"
	add_child(canvas)

	var panel := PanelContainer.new()
	panel.position = Vector2(28, 24)
	panel.custom_minimum_size = Vector2(390, 92)
	panel.modulate = Color(1, 1, 1, 0.94)
	canvas.add_child(panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 18)
	margin.add_theme_constant_override("margin_top", 12)
	margin.add_theme_constant_override("margin_right", 18)
	margin.add_theme_constant_override("margin_bottom", 12)
	panel.add_child(margin)

	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 4)
	margin.add_child(content)

	var title := Label.new()
	title.text = TITLES.get(level_id, TITLES.level_1)
	title.add_theme_font_size_override("font_size", 18)
	title.add_theme_color_override("font_color", Color(0.98, 0.77, 0.36))
	content.add_child(title)

	var objective := Label.new()
	objective.text = OBJECTIVES.get(level_id, OBJECTIVES.level_1)
	objective.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	objective.add_theme_font_size_override("font_size", 14)
	objective.add_theme_color_override("font_color", Color(0.92, 0.95, 0.95))
	content.add_child(objective)
	var hud = get_parent().get_node_or_null("HUD")
	if hud and hud.has_method("set_objective"):
		hud.set_objective(objective.text)

	var controls := Label.new()
	controls.text = "MOBILE: gauche/droite  |  JUMP: sauter  |  ATTACK: attaquer" if Main.is_mobile else "PC: A/D ou fleches  |  ESPACE: sauter  |  E: attaquer / levier"
	controls.add_theme_font_size_override("font_size", 12)
	controls.add_theme_color_override("font_color", Color(0.72, 0.82, 0.86))
	content.add_child(controls)
