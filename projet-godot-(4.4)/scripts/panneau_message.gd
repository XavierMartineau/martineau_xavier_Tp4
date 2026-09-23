## Montre un message quand le joueur est proche.
class_name PanneauMessage extends Area2D

@export var message := "Un message défaut."


func _ready() -> void:
	$Message.hide()


func show_message(_body):
	$Timer.start()
	$Message.show()
	$Message/Fond/Etiquette.text = message
	await $Timer.timeout
	$Message.hide()


func hide_message(_body) -> void:
	$Timer.stop()
	$Message.hide()
