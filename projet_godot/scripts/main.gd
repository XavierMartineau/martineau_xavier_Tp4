extends Node

@onready var NiveauTestNode: Node = $NiveauTest
@onready var Niveau2Node: Node = $niveau_2
@onready var Niveau3Node: Node = $niveau_3
@onready var BOSSNode: Node = $BOSS
@onready var FinNode: Node = $fin
@onready var FailNode: Node = $fail
@onready var VictoireNode: Node = $victoire
@onready var MenuControleNode: Node = $MenuControle

func _ready() -> void:
	# Tous les niveaux désactivés sauf le premier
	set_niveau_active(NiveauTestNode, true)
	set_niveau_active(Niveau2Node, false)
	set_niveau_active(Niveau3Node, false)
	set_niveau_active(BOSSNode, false)
	set_niveau_active(FinNode, false)
	set_niveau_active(FailNode, false)
	set_niveau_active(VictoireNode, false)
	set_niveau_active(MenuControleNode, false)

# Active/désactive tous les enfants visuels d'un niveau
func set_niveau_active(niveau: Node, actif: bool) -> void:
	if not niveau:
		return
	for child in niveau.get_children():
		if child is CanvasItem or child is Node2D:
			child.visible = actif
			# Réactiver le traitement si le niveau est activé
			if child is Node:
				child.set_process(actif)
				child.set_physics_process(actif)

# Fonction globale pour changer de scène dans l'architecture Main
func changer_vers_scene(chemin_scene: String) -> void:
	# Désactiver tous les niveaux
	set_niveau_active(NiveauTestNode, false)
	set_niveau_active(Niveau2Node, false)
	set_niveau_active(Niveau3Node, false)
	set_niveau_active(BOSSNode, false)
	set_niveau_active(FinNode, false)
	set_niveau_active(FailNode, false)
	set_niveau_active(VictoireNode, false)
	set_niveau_active(MenuControleNode, false)
	
	# Activer le niveau demandé selon le chemin
	match chemin_scene:
		"res://scenes/niveau_test.tscn":
			set_niveau_active(NiveauTestNode, true)
		"res://scenes/niveau_2.tscn":
			set_niveau_active(Niveau2Node, true)
		"res://scenes/niveau_3.tscn":
			set_niveau_active(Niveau3Node, true)
		"res://scenes/BOSS.tscn":
			set_niveau_active(BOSSNode, true)
		"res://scenes/fin.tscn":
			set_niveau_active(FinNode, true)
		"res://scenes/fail.tscn":
			set_niveau_active(FailNode, true)
		"res://scenes/victoire.tscn":
			set_niveau_active(VictoireNode, true)
		"res://scenes/main.tscn":
			set_niveau_active(NiveauTestNode, true)
		_:
			print("Scène non reconnue: ", chemin_scene)

# Passe du niveau 1 au niveau 2
func passer_au_niveau_2():
	# Désactive tous les enfants du niveau 1
	set_niveau_active(NiveauTestNode, false)

	# Active tous les enfants du niveau 2
	set_niveau_active(Niveau2Node, true)
