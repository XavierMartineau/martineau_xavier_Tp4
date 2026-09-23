extends Area2D

class_name Bomb # Nom de la classe pour pouvoir instancier depuis l’éditeur ou d’autres scripts

# Constante ou variable pour la quantité de dégâts si nécessaire
const DEGATS = 1 

func _ready() -> void:
	# Connexion du signal 'body_entered' à la fonction _on_body_entered
	connect("body_entered", Callable(self, "_on_body_entered"))

# Fonction appelée lorsqu'un corps entre en collision avec la zone de la bombe
func _on_body_entered(body: Node) -> void:
	if body is Joueur: # Vérifie que c’est bien le joueur
		print("💥 Bombe touchée par le joueur :", body.name)
		
		# Lance l'effet de dégâts / destruction
	
		
		# --- Logique de suppression de la bombe après "explosion" ---
		# Désactive la collision immédiatement pour éviter les multiples déclenchements
		$CollisionShape2D.set_deferred("disabled", true) 
		# Cache visuellement la bombe (si vous n'avez pas d'animation d'explosion)
		hide() 
		# Supprime l'objet de la scène (après un court délai si besoin d'une animation)
		call_deferred("queue_free") 
		
# Fonction pour appliquer l'effet de la bombe au joueur

	
