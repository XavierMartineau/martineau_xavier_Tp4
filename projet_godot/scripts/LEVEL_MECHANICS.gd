extends Node2D

@export var lever_positions := PackedVector2Array()
@export var collectible_positions := PackedVector2Array()

const LEVER_SCENE = preload("res://scenes/LEVER.tscn")
const COLLECTIBLE_SCENE = preload("res://scenes/COLLECTIBLE.tscn")

func _ready() -> void:
	var hud = get_parent().get_node_or_null("HUD")
	if hud and hud.has_method("register_mechanics"):
		hud.register_mechanics(lever_positions.size(), collectible_positions.size())

	for position in lever_positions:
		var lever = LEVER_SCENE.instantiate()
		lever.position = position
		lever.activated.connect(_on_lever_activated)
		add_child(lever)

	for position in collectible_positions:
		var collectible = COLLECTIBLE_SCENE.instantiate()
		collectible.position = position
		add_child(collectible)

func _on_lever_activated() -> void:
	var hud = get_parent().get_node_or_null("HUD")
	if hud and hud.has_method("lever_activated"):
		hud.lever_activated()
