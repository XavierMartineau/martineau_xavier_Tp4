extends Area2D

var transition_started := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if transition_started or not body is Joueur:
		return
	transition_started = true
	get_tree().call_deferred("change_scene_to_file", "res://scenes/VICTOIRE.tscn")
