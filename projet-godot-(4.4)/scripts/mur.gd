extends StaticBody2D
class_name Wall # Utilise 'Wall' comme nom de classe

# Variable pour stocker le HUD, qui contient le compteur de bombes
@onready var hud = get_tree().current_scene.get_node_or_null("HUD")

# Définir le nombre de bombes nécessaire pour débloquer le mur
const BOMBS_NECESSAIRES = 1 # Débloque si le joueur a 1 bombe (ou plus)

func _ready() -> void:
	if hud:
		print("🔒 Wall prêt. Le HUD est trouvé :", hud.name)
	else:
		# Avertissement si le HUD est manquant
		push_warning("HUD introuvable, le mur de verrouillage ne pourra pas surveiller les bombes.")

func _process(_delta: float) -> void:
	# Vérifie si le HUD est là ET si la variable 'nb_bombs' est suffisamment élevée
	# ATTENTION : Confirmez que 'nb_bombs' est le nom de la variable dans votre script HUD.gd
	if hud and hud.nb_bomb >= BOMBS_NECESSAIRES:
		disparaitre()
		# Arrête le _process une fois la condition remplie
		set_process(false) 

func disparaitre() -> void:
	print("🔓 Wall débloqué par la bombe !")
	
	# Création d'un Tween pour animer la disparition du mur
	var tween = create_tween()
	# Fait rétrécir l'objet jusqu'à zéro en 0.5 seconde
	tween.tween_property(self, "scale", Vector2.ZERO, 0.5)
	# Connecte la suppression de l'objet à la fin de l'animation
	tween.finished.connect(Callable(self, "queue_free"))
