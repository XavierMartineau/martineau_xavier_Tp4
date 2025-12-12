extends Area2D

# Propriété exportée pour définir la scène cible dans l'éditeur
@export var chemin_scene: String = "res://scenes/niveau_2.tscn"

# Nœud AudioStreamPlayer2D (doit exister comme enfant du nœud actuel)
@onready var audio_level_up: AudioStreamPlayer2D = $Level_up 
# Si le nœud est un simple AudioStreamPlayer, utilisez: $AudioStreamPlayer à la place.

func _ready() -> void:
	# Connexion standard
	connect("body_entered", Callable(self, "_on_body_entered"))
	
	# Optionnel : S'assurer que le son est prêt et connecté pour le changement de scène
	# On connecte le signal 'finished' du son à la fonction de changement de scène
	audio_level_up.finished.connect(_changer_de_scene)

func _on_body_entered(body: Node) -> void:
	if body is Joueur:
		print("🚪 Joueur détecté.")
		
		# 1. Empêche le joueur de toucher plusieurs fois la zone
		$CollisionShape2D.set_deferred("disabled", true)
		
		# 2. Jouer le son
		audio_level_up.play()
		
		# Le changement de scène est maintenant géré par le signal 'finished' du son
		# pour s'assurer que le son a le temps de démarrer.

func _changer_de_scene() -> void:
	# Cette fonction est appelée UNIQUEMENT lorsque le son a fini de jouer
	
	if chemin_scene != "":
		print("🚀 Changement de scène vers :", chemin_scene)
		# Sécurité : vérifier que l'arbre existe
		if get_tree():
			# Chercher le noeud Main pour changer de scène
			var main = get_tree().root.get_node_or_null("Main")
			if main and main.has_method("changer_vers_scene"):
				main.changer_vers_scene(chemin_scene)
			else:
				get_tree().change_scene_to_file(chemin_scene)
	else:
		push_warning("Le chemin de la scène n'est pas défini !")
