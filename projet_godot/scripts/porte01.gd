extends Area2D

@export var chemin_scene: String = "res://scenes/main.tscn"

func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node) -> void:
	if body is Joueur:
		print("🚪 Joueur détecté → changement de scène différé")
		call_deferred("_changer_de_scene")

func _changer_de_scene() -> void:
	if chemin_scene != "":
		if get_tree():
			var main = get_tree().root.get_node_or_null("Main")
			if main and main.has_method("changer_vers_scene"):
				main.changer_vers_scene(chemin_scene)
			else:
				get_tree().change_scene_to_file(chemin_scene)
	else:
		push_warning("Le chemin de la scène n'est pas défini !")
