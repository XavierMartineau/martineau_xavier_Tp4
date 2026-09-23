extends Node2D # Ou Node2D, selon le nœud racine de votre BarreDeViePerso
class_name BarreDeViePerso

# Référence au Label VieJoueur (Basé sur la structure : BarreDeViePerso -> ColorRect -> VieJoueur)
@onready var vie_label: Label = $ColorRect/VieJoueur


# Fonction appelée par le Joueur pour mettre à jour l'affichage
func set_health(current_health: int, max_health: int):
	if is_instance_valid(vie_label):
		# Affiche le nombre actuel de cœurs (Ex: 100)
		vie_label.text = str(current_health)
		
		# Si vous voulez une barre visuelle, la logique de redimensionnement irait ici sur le ColorRect.
	else:
		print("ERREUR: Le Label 'VieJoueur' est invalide dans la barre de vie.")
