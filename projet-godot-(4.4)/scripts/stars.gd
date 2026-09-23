extends Area2D

class_name Star # nom de la classe pour pouvoir instancier depuis l’éditeur ou d’autres scripts

# Nœud AudioStreamPlayer pour le son de collecte (doit être un enfant du nœud Star)
@onready var audio_bonus = $bonus # Assurez-vous que le chemin est correct

func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node) -> void:
	# L'indentation ici a été corrigée
	if body is Joueur: # Vérifie que c’est bien le joueur
		print("⭐ Star touchée par le joueur :", body.name)
		
		# 1. Jouer le son de bonus
		if audio_bonus:
			audio_bonus.play()
		else:
			push_warning("Nœud audio 'bonus' introuvable.")
			
		# 2. Mettre à jour le HUD
		var hud = get_tree().current_scene.get_node_or_null("HUD")
		if hud:
			# L'indentation ici a été corrigée
			hud.ajouter_star() # Assure-toi que HUD.gd a la méthode ajouter_star()
		else:
			push_warning("HUD introuvable dans la scène !")

		# 3. Supprime ou cache l'étoile après collecte
		# Désactiver la collision pour éviter les multiples déclenchements
		$CollisionShape2D.set_deferred("disabled", true)
		# Cacher l'étoile
		hide()
		
		# 4. Suppression de l'objet : on attend que le son soit joué (méthode robuste)
		
		# Si le son n'existe pas ou n'est pas prêt, on supprime immédiatement
		if audio_bonus and audio_bonus.stream_paused == false: 
			# Connecte la suppression de l'objet à la fin de la lecture du son
			audio_bonus.finished.connect(Callable(self, "queue_free"))
		else:
			# Si pas de son, on supprime immédiatement
			call_deferred("queue_free")
