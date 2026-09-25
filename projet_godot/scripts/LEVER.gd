extends Area2D

signal activated

var is_activated := false
var player_nearby := false
@onready var sprite: Sprite2D = $Sprite2D
@onready var prompt: Label = $Prompt

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	prompt.hide()

func _process(_delta: float) -> void:
	if player_nearby and not is_activated and Input.is_action_just_pressed("Ataquer"):
		activate()

func _on_body_entered(body: Node) -> void:
	if body is Joueur:
		player_nearby = true
		prompt.show()

func _on_body_exited(body: Node) -> void:
	if body is Joueur:
		player_nearby = false
		prompt.hide()

func activate() -> void:
	if is_activated:
		return
	is_activated = true
	sprite.texture = load("res://assets/sprites/lever_right.png")
	prompt.text = "ACTIVE"
	activated.emit()
