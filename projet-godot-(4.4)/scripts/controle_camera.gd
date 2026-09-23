## Caméra que fait zoom in quand le joueur est proche d'un panneau.
class_name ControleCamera extends Camera2D

@export var zoom_closed := 1.3
@export var zoom_open := 1.0
@export var zoom_duration := 0.4

var zoom_tween


func _ready() -> void:
	var panneaux = get_tree().get_nodes_in_group("panneaux")
	for p in panneaux:
		p.body_entered.connect(zoom_in)
		p.body_exited.connect(zoom_out)


func zoom_in(_body):
	if zoom_tween:
		zoom_tween.kill()
	zoom_tween = self.create_tween()
	zoom_tween.set_trans(Tween.TRANS_CUBIC)
	zoom_tween.tween_property(self, "zoom", Vector2.ONE * zoom_closed, zoom_duration)


func zoom_out(_body):
	if zoom_tween:
		zoom_tween.kill()
	zoom_tween = self.create_tween()
	zoom_tween.set_trans(Tween.TRANS_CUBIC)
	zoom_tween.tween_property(self, "zoom", Vector2.ONE * zoom_open, zoom_duration)
