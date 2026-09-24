# Main.gd
extends Node

var language: String = "fr"
var game_configured := false
var is_mobile := false

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


func translate_text(text: String) -> String:
	if language == "en":
		match text:
			"Barre de vie : ": return "Health bar: "
			"Tu a desormais loption dataquer\n\nPour ataquer Appuyer sur la touche \"E\"\n\nBonne chanches ": return "You can now attack.\n\nPress the \"E\" key to attack.\n\nGood luck!"
			"Salut à toi ! J'ai grand besoin de tes services.\n\nUn preneur d'âmes détient un trésor d'une valeur inestimable.\n\nRécupère cet objet précieux, et une récompense t'attend.": return "Hello! I need your help.\n\nA soul taker holds a priceless treasure.\n\nRecover it and a reward will be waiting for you."
			"BRAVO ! Vous avez affronté le Boss et l'avez vaincu. Le trésor est votre !\n\nMais la menace n'est pas écartée. L'alarme retentit, ou les renforts arrivent.\n\nMaintenant, FUYEZ par le tunnel ! Ne restez pas là, \nl'endroit est instable !": return "WELL DONE! You defeated the Boss and claimed the treasure!\n\nBut the threat is not over. The alarm is ringing and reinforcements are coming.\n\nNow RUN through the tunnel! Do not stay here,\nthe place is unstable!"
			"Trouve 11 étoiles": return "Find 11 stars"
			"bravo! ta trouve letoile_!2 ": return "Well done! You found star 2!"
			"Pour aller au lvl 2 ouvre les 2 lock": return "Open both locks to reach level 2"
			_: return text
	match text:
		"Health bar: ": return "Barre de vie : "
		"Find 11 stars": return "Trouve 11 étoiles"
		"Open both locks to reach level 2": return "Pour aller au niveau 2, ouvre les 2 verrous"
		_: return text


func translate_tree(root: Node) -> void:
	for label in root.find_children("*", "Label", true, false):
		label.text = translate_text(label.text)
