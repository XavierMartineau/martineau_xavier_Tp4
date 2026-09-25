extends CanvasLayer
class_name HUD # permet de l'identifier et de l'instancier facilement

# Labels (Utilisation du type Label pour la clarté)
# ATTENTION : Assurez-vous que les noms des nœuds dans l'HBoxContainer sont bien corrects
@onready var label_stars: Label = $HBoxContainer/label_stars
@onready var label_coin: Label = $HBoxContainer/label_coin
@onready var health_title: Label = $HBoxContainer/Label
@onready var objective_label: Label = $ObjectiveLabel
@onready var mechanics_label: Label = $MechanicsLabel


# Compteurs
var nb_stars: int = 0 # étoiles
var nb_coin: int = 0 # coin
var total_levers := 0
var active_levers := 0
var total_collectibles := 0
var collected_items := 0


func _ready() -> void:
	# Initialise l'affichage au démarrage
	label_stars.text = str(nb_stars)
	label_coin.text = str(nb_coin)
	health_title.text = Main.translate_text(health_title.text)
	_update_mechanics_label()

	
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

func set_objective(text: String) -> void:
	objective_label.text = text

func register_mechanics(levers: int, collectibles: int) -> void:
	total_levers = levers
	total_collectibles = collectibles
	_update_mechanics_label()

func lever_activated() -> void:
	active_levers += 1
	_update_mechanics_label()

func collectible_collected() -> void:
	collected_items += 1
	_update_mechanics_label()

func _update_mechanics_label() -> void:
	if not is_instance_valid(mechanics_label):
		return
	mechanics_label.text = "LEVIERS %d/%d   OBJETS %d/%d" % [active_levers, total_levers, collected_items, total_collectibles]
	
