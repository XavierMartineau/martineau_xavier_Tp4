extends Area2D
class_name Projectile

# Configuration du projectile
const SPEED = 800.0       # Vitesse de déplacement du projectile
const LIFETIME = 2.0      # Temps en secondes avant la destruction automatique (Sécurité)
const DAMAGE = 30         # Dégâts infligés par ce projectile (Utilisé dans _on_body_entered)

# Variables de mouvement
var direction_h = 1.0     # 1.0 = droite, -1.0 = gauche
var velocity = Vector2.ZERO

# Nœud AudioStreamPlayer
@onready var audio_fire_sound = $fire # Assurez-vous que ce nom correspond à votre nœud enfant

func _ready():
	# 1. Lancer l'animation
	# Assurez-vous d'avoir un nœud AnimatedSprite2D nommé 'AnimatedSprite2D' en enfant
	# et que l'animation est nommée "Projectile".
	if $AnimatedSprite2D:
		$AnimatedSprite2D.play("Projectile")
	
	# 2. Démarrer le minuteur de destruction (Sécurité)
	await get_tree().create_timer(LIFETIME).timeout
	queue_free()

# Fonction appelée par le joueur pour donner au projectile sa direction et sa vitesse.
# ATTEND UN SEUL ARGUMENT : direction (float)
func lancer(direction: float):
	direction_h = direction
	
	# Initialise la vitesse horizontale
	velocity.x = direction_h * SPEED
	
	# --- LOGIQUE DE FLIP DU PROJECTILE ---
	if $AnimatedSprite2D:
		$AnimatedSprite2D.flip_h = (direction_h == -1.0)
	# ------------------------------------
	
	# Jouer le son au moment du lancement
	if audio_fire_sound:
		audio_fire_sound.play()
	
	# Connexion manuelle du signal de détection de collision
	body_entered.connect(_on_body_entered)


func _process(delta):
	# Applique le mouvement constant à chaque frame.
	position += velocity * delta


# Gère la collision lorsqu'un corps entre dans la zone Area2D du projectile
func _on_body_entered(body: Node2D):
	
	# 1. Ignorer le joueur
	if body is Joueur:
		return

	# 2. Logique de Dégâts
	
	# Vérifie si le corps touché est un ennemi (le Boss)
	if body.has_method("prendre_degats"):
		# On utilise la constante DAMAGE (30) définie en haut du script.
		print("Projectile touché: ", body.name, ". Dégâts infligés: ", DAMAGE)
		body.prendre_degats(DAMAGE)
	
	# 3. Destruction du Projectile après la collision
	queue_free()
