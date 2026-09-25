extends Area2D

var collected := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if collected or not body is Joueur:
		return
	collected = true
	var hud = get_tree().current_scene.get_node_or_null("HUD")
	if hud and hud.has_method("collectible_collected"):
		hud.collectible_collected()
	queue_free()
