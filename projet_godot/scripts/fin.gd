extends Area2D

@export var chemin_scene: String = "res://scenes/fin.tscn"

# Nœud AudioStreamPlayer2D (doit exister comme enfant du nœud actuel)
@onready var audio_level_up: AudioStreamPlayer2D = $Level_up

# Référence au HUD (pour vérifier le nombre de pièces)
@onready var hud = get_tree().current_scene.get_node_or_null("HUD")

# Constante pour le nombre de pièces requis
const COINS_REQUIS = 36

# Cache la porte et désactive l'interactivité par défaut
var est_deverrouillee: bool = false

func _ready() -> void:
	# Connexion standard
	connect("body_entered", Callable(self, "_on_body_entered"))
	
	# Connecte le signal 'finished' du son à la fonction de changement de scène
	audio_level_up.finished.connect(_changer_de_scene)
	
	# Initialiser la porte en mode verrouillé
	verrouiller_porte()
	
	# Commence à surveiller l'état des pièces
	set_process(true)

func _process(_delta: float) -> void:
	# Vérifie la condition de déverrouillage tant qu'elle n'est pas déjà déverrouillée
	if not est_deverrouillee and hud and hud.nb_coin >= COINS_REQUIS:
		deverrouiller_porte()
		# Arrête le _process une fois déverrouillé pour économiser des ressources
		set_process(false)

# --- Fonctions de verrouillage/déverrouillage ---

func verrouiller_porte() -> void:
	# Cache la porte (rend invisible)
	# Assurez-vous que le nœud de rendu (Sprite/AnimatedSprite) est visible initialement dans l'éditeur
	visible = false 
	# Désactive la collision
	$CollisionShape2D.set_deferred("disabled", true)
	print("🔒 Porte verrouillée (Coins requis: ", COINS_REQUIS, ")")

func deverrouiller_porte() -> void:
	est_deverrouillee = true
	# Rend la porte visible
	visible = true
	# Active la collision pour que le joueur puisse y entrer
	$CollisionShape2D.set_deferred("disabled", false)
	print("🔓 PORTE DÉVERROUILLÉE ! (36 pièces atteintes)")

# --- Gestion de l'entrée du joueur ---

func _on_body_entered(body: Node) -> void:
	# On ajoute une vérification rapide ici, même si la collision est désactivée quand la porte est verrouillée
	if body is Joueur and est_deverrouillee: 
		print("🚪 Joueur détecté.")
		
		# Empêche le joueur de toucher plusieurs fois la zone
		$CollisionShape2D.set_deferred("disabled", true)
		
		# Jouer le son. Le changement de scène se fera après la fin du son.
		audio_level_up.play()

func _changer_de_scene() -> void:
	# Cette fonction est appelée UNIQUEMENT lorsque le son a fini de jouer
	
	if chemin_scene != "":
		print("🚀 Changement de scène vers :", chemin_scene)
		if get_tree():
			var main = get_tree().root.get_node_or_null("Main")
			if main and main.has_method("changer_vers_scene"):
				main.changer_vers_scene(chemin_scene)
			else:
				get_tree().change_scene_to_file(chemin_scene)
	else:
		push_warning("Le chemin de la scène n'est pas défini !")
