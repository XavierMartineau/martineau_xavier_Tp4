extends Area2D
class_name projectile_enemie 

# --- Configuration du projectile ---
const SPEED = 800.0          # Vitesse de déplacement du projectile 
const LIFETIME = 2.0         # Temps en secondes avant la destruction automatique (Sécurité)
const DAMAGE = 30            # Dégâts infligés par ce projectile

# --- Variables de mouvement ---
var direction_h = 1.0        # 1.0 = droite, -1.0 = gauche
var velocity = Vector2.ZERO

# NOUVEAU : Référence au nœud AudioStreamPlayer
@onready var audio_ice = $ice


func _ready():
	# 1. Lancer l'animation
	if $AnimatedSprite2D:
		$AnimatedSprite2D.play("projectile_enemie")
	
	# 2. Démarrer le minuteur de destruction (Sécurité)
	await get_tree().create_timer(LIFETIME).timeout
	queue_free()

# Fonction appelée par le Boss pour donner au projectile sa direction et sa vitesse.
func initialiser(direction: float): 
	direction_h = direction
	
	# ⚡️ NOUVEAU : Jouer le son 'ice' au lancement
	if audio_ice:
		audio_ice.play()
	
	# Initialise la vitesse horizontale
	velocity.x = direction_h * SPEED
	
	# Connexion manuelle du signal de détection de collision
	body_entered.connect(_on_body_entered)


func _process(delta):
	# Applique le mouvement constant à chaque frame.
	position += velocity * delta


# Gère la collision lorsqu'un corps entre dans la zone Area2D du projectile
func _on_body_entered(body: Node2D):
	
	# 1. Ignorer le Boss
	if body is Boss:
		return

	# 2. Logique de Dégâts sur la Cible (le Joueur)
	
	# On vérifie si le corps touché est le Joueur (en utilisant sa class_name)
	if body is Joueur:
		# Le joueur doit avoir une méthode pour prendre des dégâts
		if body.has_method("prendre_degats"):
			print("Projectile ennemi touché le Joueur: ", body.name, ". Dégâts infligés: ", DAMAGE)
			body.prendre_degats(DAMAGE)
	
	# 3. Destruction du Projectile après la collision
	queue_free()
