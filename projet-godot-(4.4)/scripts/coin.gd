extends Area2D

class_name Coin  # Nouveau nom de classe pour la pièce

func _ready() -> void:
	# Connexion du signal de collision lors du chargement de la scène
	# Utilisation de la syntaxe Godot 4 recommandée
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body is Joueur:  # Vérifie que c’est bien le joueur
		print("💰 Pièce collectée par le joueur :", body.name)
		
		# Récupération et mise à jour du HUD
		var hud = get_tree().current_scene.get_node_or_null("HUD")
		if hud:
			# --- CORRIGÉ : Utilise la fonction ajouter_coin() du HUD ---
			if hud.has_method("ajouter_coin"):
				hud.ajouter_coin() # Appel de la fonction pour incrémenter le score
			else:
				push_warning("HUD trouvé, mais méthode 'ajouter_coin' est manquante.")
		else:
			push_warning("HUD introuvable dans la scène ! Assurez-vous qu'il soit nommé 'HUD' et soit un enfant de la scène principale.")

		# Supprime la pièce après collecte
		hide()
		# Désactive la collision immédiatement (important pour éviter les doubles collections)
		$CollisionShape2D.set_deferred("disabled", true)
		call_deferred("queue_free") # Suppression du nœud à la fin du frame
