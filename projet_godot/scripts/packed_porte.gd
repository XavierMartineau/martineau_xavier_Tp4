# Dans le script porte.gd
extends Area2D

# 1. Déclaration de la scène de destination (PackedScene)
# Correction : Suppression de l'espace insécable après PackedScene
@export var nouvelle_scene: PackedScene 

# 2. Déclaration du statut de porte de boss (booléen)
# Correction : Suppression de l'espace insécable après false
@export var est_porte_boss: bool = false 

# ... (autres variables et fonctions)

# --- Fonction unique et complète ---
func _on_body_entered(body: Node2D) -> void:
	# S'assurer que seul le joueur (avec son class_name 'Joueur') entre
	if body is Joueur:
		
		# 1. Vérification de la scène liée
		# Ceci gère l'erreur 'Expected indented block' de l'ancien code incomplet
		if nouvelle_scene == null:
			push_error("Erreur: Aucune scène de destination n'est liée à cette porte dans l'Inspecteur du nœud de porte.")
			return
			
		# 2. Vérification pour la porte du boss
		if est_porte_boss:
			
			# Vérifier si la fonction du boss et les pièces existent
			if Main.has_method("a_assez_de_coins_pour_boss") and Main.a_assez_de_coins_pour_boss():
				# Le joueur a assez de pièces
				Main.changer_scene(nouvelle_scene)
			else:
				# Message d'erreur si pas assez de pièces
				# Note: Le Main.COINS_REQUIS_BOSS doit être défini dans Main.gd
				if Main.has_method("a_assez_de_coins_pour_boss"):
					print("Il vous faut ", Main.COINS_REQUIS_BOSS, " pièces pour ouvrir cette porte!")
				pass
		
		# 3. Porte normale (changement de scène immédiat)
		else:
			Main.changer_scene(nouvelle_scene)
