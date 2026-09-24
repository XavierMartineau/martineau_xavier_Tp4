extends StaticBody2D

@onready var hud = get_tree().current_scene.get_node_or_null("HUD")

func _ready() -> void:
	if hud:
		print("Lock prêt, HUD trouvé :", hud.name)
	else:
		push_warning("HUD introuvable, le lock ne pourra pas surveiller les étoiles.")

func _process(_delta: float) -> void:
	if hud and hud.nb_stars >= 1:
		disparaitre()

func disparaitre() -> void:
	print("🔓 Lock débloqué !")
	# Tween pour disparition si tu veux
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ZERO, 0.5)
	tween.finished.connect(Callable(self, "queue_free"))  # supprime le lock après animation
