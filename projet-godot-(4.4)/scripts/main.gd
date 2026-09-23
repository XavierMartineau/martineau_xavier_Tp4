# Main.gd
extends Node

# Fonction appelée par la porte, recevant la PackedScene en paramètre.
func changer_scene(target_scene: PackedScene) -> void:
	# On vérifie si la PackedScene a bien été liée dans l'Inspecteur
	if target_scene == null:
		push_error("Erreur: La scène cible (PackedScene) de la porte est nulle.")
		return
		
	# --- CORRECTION DE L'ERREUR DE PHYSIQUE ---
	# Utiliser call_deferred() pour reporter le changement de scène
	# à la prochaine frame (quand le moteur physique est stable).
	get_tree().call_deferred("change_scene_to_packed", target_scene)
	# ------------------------------------------
