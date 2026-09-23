extends CharacterBody2D
class_name NPC

# --- Constantes (inutilisées si le NPC est immobile) ---
# Nous les laissons pour référence si un mouvement est ajouté plus tard.
const SPEED = 100.0
const GRAVITY = 800.0

# --- État de l'NPC (visible dans l'éditeur) ---
@export var etat_courant = Etat.idle 

# Nous laissons les autres états pour que l'énumération soit complète,
# mais seul 'idle' sera utilisé dans le code actuel.
enum Etat {
	idle, # Repos, immobile au sol
	move, # Mouvement horizontal au sol (non utilisé)
	fall, # Chute ou saut (non utilisé)
}

func _physics_process(delta):
	# Le PNJ est supposé être au sol et immobile, 
	# donc la gravité et le déplacement ne sont plus nécessaires.
	
	# La vitesse est mise à zéro pour garantir l'immobilité.
	velocity.x = 0
	velocity.y = 0

	# --- 2. LOGIQUE D'ÉTAT (Simplicité : toujours 'idle') ---
	
	# Si l'état actuel n'est pas "idle", nous le forçons à le devenir
	if etat_courant != Etat.idle:
		etat_courant = Etat.idle
		
	# Nous jouons l'animation "repos" une seule fois si l'état vient de changer
	# (Bien que dans ce script, l'état ne changera jamais après le _ready)
	$AnimatedSprite2D.play("idle") 
			
	# NOTE: move_and_slide() n'est plus appelé car le PNJ est statique.
	# Si vous voulez qu'il reste affecté par des collisions externes,
	# vous devriez le laisser, mais avec velocity.x = 0 et velocity.y = 0.
