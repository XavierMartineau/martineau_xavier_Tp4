extends StaticBody2D
class_name Lock66  # lock qui disparaît à 66 étoiles

@onready var hud = get_tree().current_scene.get_node_or_null("HUD")

func _ready() -> void:
	if hud:
		print("Lock66 prêt, HUD trouvé :", hud.name)
		# On se connecte au HUD en appelant la méthode ajouter_star
		# On suppose que HUD appelle signal ou méthode lorsqu'une étoile est ajoutée
		hud.connect("tree_entered", Callable(self, "_on_hud_ready")) # on attend que le HUD soit prêt
	else:
		push_warning("HUD introuvable, le Lock66 ne pourra pas surveiller les étoiles.")

func _on_hud_ready() -> void:
	if hud.nb_stars >= 6:
		disparaitre()
	else:
		# On pourrait se connecter à un signal si tu crées un signal dans HUD
		# Exemple: hud.connect("star_added", Callable(self, "_check_stars"))
		pass

func _check_stars() -> void:
	if hud.nb_stars >= 6:
		disparaitre()

func disparaitre() -> void:
	print("🔓 Lock66 débloqué !")
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ZERO, 0.5)
	tween.finished.connect(Callable(self, "queue_free"))
