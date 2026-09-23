extends CanvasLayer
class_name HUD # permet de l'identifier et de l'instancier facilement

# Labels (Utilisation du type Label pour la clarté)
# ATTENTION : Assurez-vous que les noms des nœuds dans l'HBoxContainer sont bien corrects
@onready var label_stars: Label = $HBoxContainer/label_stars
@onready var label_coin: Label = $HBoxContainer/label_coin


# Compteurs
var nb_stars: int = 0 # étoiles
var nb_coin: int = 0 # coin


func _ready() -> void:
	# Initialise l'affichage au démarrage
	label_stars.text = str(nb_stars)
	label_coin.text = str(nb_coin)

	
# Méthode pour ajouter une étoile
func ajouter_star() -> void:
	nb_stars += 1
	label_stars.text = str(nb_stars)
	print("HUD : étoiles =", nb_stars)

# Méthode pour ajouter un coin
func ajouter_coin() -> void:
	nb_coin += 1
	label_coin.text = str(nb_coin)
	print("HUD : Coin =", nb_coin)
	
