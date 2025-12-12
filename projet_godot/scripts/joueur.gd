extends CharacterBody2D
class_name Joueur

# --- NÉCESSAIRE : Chemins de la scène ---
const PROJECTILE_SCENE = preload("res://scenes/Projectile.tscn") # Le projectile du joueur
const FAIL_SCENE_PATH = "res://scenes/fail.tscn" 

# --- CONFIGURATION DE LA VIE et AFFICHAGE ---
@export var max_coeurs = 100 
var nombre_coeurs = 0 
var is_dead = false 

# --- Constantes de Mouvement et Attaque ---
const PROJECTILE_DAMAGE = 30 # Dégâts du projectile du Joueur (30)
const COOLDOWN_MAX = 1.2
var cooldown_restant = 0.0 
const SPEED = 300.0
const JUMP_VELOCITY = -500.0
const GRAVITY = 800.0

# --- RÉFÉRENCES AUX NŒUDS ---
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var launch_point: Node2D = $LaunchPoint 

# Audio
@onready var death_sound_player: AudioStreamPlayer2D = $Death
@onready var hurt_sound_player: AudioStreamPlayer2D = $hurt 

# RÉFÉRENCE AU LABEL DE VIE DANS LE HUD (cherché dynamiquement)
var health_label: Label = null


# --- Variables d'État ---
@export var etat_courant = Etat.REPOS

enum Etat {
	REPOS,
	PROMENER,
	SAUT,
	MORT, 
	ATAQUER
}


func _ready() -> void:
	animated_sprite.animation_finished.connect(_on_animation_finished)
	nombre_coeurs = max_coeurs
	
	# Trouver le HUD dans la hiérarchie de la scène
	# Commence par chercher dans le owner (la scène qui contient le joueur)
	var scene_root = owner if owner else get_parent()
	if scene_root:
		var hud = scene_root.get_node_or_null("HUD")
		if hud:
			health_label = hud.get_node_or_null("HBoxContainer/label_perso")
	
	update_health_display() 


# --- FONCTION POUR METTRE À JOUR L'AFFICHAGE DE LA VIE (HUD) ---
func update_health_display() -> void:
	if is_instance_valid(health_label):
		health_label.text = str(nombre_coeurs)
	else:
		print("ERREUR: Label 'label_perso' non trouvé dans le HUD. Vérifiez le chemin.") 


func _process(delta):
	# Gestion du Cooldown d'attaque
	if cooldown_restant > 0:
		cooldown_restant -= delta
		if cooldown_restant < 0:
			cooldown_restant = 0


func _physics_process(delta):
	if is_dead: 
		velocity.x = 0
		move_and_slide()
		return

	# Application de la Gravité
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	# ==========================================================
	# CORRECTION DE L'INDENTATION ICI : TOUTES LES LIGNES SUIVANTES 
	# DOIVENT ÊTRE INDENTÉES UNE FOIS
	# ==========================================================
	
	# Gestion de l'Attaque simplifiée
	if Input.is_action_just_pressed("Ataquer"):
		# 1. Vérifie le cooldown
		if cooldown_restant > 0: 
			return
		
		# 2. Déclenche le cooldown (MAINTENANT DANS LE BLOC 'IF')
		cooldown_restant = COOLDOWN_MAX
		
		# 3. LANCE LE PROJECTILE (MAINTENANT DANS LE BLOC 'IF')
		lancer_projectile()
	
	# Gestion du Saut
	if Input.is_action_just_pressed("sauter") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Gestion du Mouvement Horizontal
	var direction := Input.get_axis("promener_gauche", "promener_droite")
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	# Animation et Orientation
	if velocity.x > 0: animated_sprite.flip_h = false
	elif velocity.x < 0: animated_sprite.flip_h = true

	if animated_sprite.animation != "ataquer" && animated_sprite.animation != "hurt": 
		if is_on_floor():
			if velocity.x == 0:
				etat_courant = Etat.REPOS
				animated_sprite.play("repos")
			else:
				etat_courant = Etat.PROMENER
				animated_sprite.play("promener")
		else:
			etat_courant = Etat.SAUT
			animated_sprite.play("sauter")


func _on_animation_finished(anim_name: StringName) -> void:
	if is_dead: return
		
	if anim_name == "ataquer" and etat_courant == Etat.ATAQUER:
		if is_on_floor():
			etat_courant = Etat.REPOS
			animated_sprite.play("repos")
		else:
			etat_courant = Etat.SAUT
			animated_sprite.play("sauter")
	
	if anim_name == "hurt":
		if is_on_floor():
			animated_sprite.play("repos")
		else:
			animated_sprite.play("sauter")


# --- FONCTION DE DÉGÂTS (Jouer 'hurt' + son) ---
func prendre_degats(amount: int):
	if is_dead: return
		
	nombre_coeurs = max(0, nombre_coeurs - amount)
	update_health_display() 
	
	if nombre_coeurs <= 0:
		die() 
		return

	# Animation de blessure ("hurt" / "mal")
	if animated_sprite.animation != "ataquer":
		animated_sprite.play("hurt")
	
	# Jouer le son de blessure
	if is_instance_valid(hurt_sound_player) and hurt_sound_player.stream != null:
		hurt_sound_player.play() 


# --- FONCTION DE MORT (Jouer 'death' + son + Transition) ---
func die():
	if is_dead: return
		
	is_dead = true
	etat_courant = Etat.MORT
	
	animated_sprite.play("death") 
	
	if is_instance_valid(death_sound_player) and death_sound_player.stream != null:
		death_sound_player.play()
	
	set_physics_process(false)
	
	await get_tree().create_timer(2.0).timeout 
	
	# Sécurité : vérifier que l'arbre existe toujours
	if get_tree():
		# Chercher le noeud Main pour changer de scène
		var main = get_tree().root.get_node_or_null("Main")
		if main and main.has_method("changer_vers_scene"):
			main.changer_vers_scene(FAIL_SCENE_PATH)
		else:
			get_tree().change_scene_to_file(FAIL_SCENE_PATH)


# --- FONCTION D'ATTAQUE DU JOUEUR (Lance le projectile avec 1 argument) ---
func lancer_projectile():
	if not is_instance_valid(launch_point): return
		
	var projectile = PROJECTILE_SCENE.instantiate()
	projectile.global_position = launch_point.global_position
	
	var direction = 1.0 
	if animated_sprite.flip_h: direction = -1.0 
		
	get_parent().add_child(projectile)
	
	if projectile.has_method("lancer"):
		# Appel avec UN SEUL argument pour correspondre au script Projectile.gd
		projectile.lancer(direction)
