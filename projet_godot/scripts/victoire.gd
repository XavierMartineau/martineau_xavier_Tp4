extends Node

@onready var return_button: Button = $Ending/Panel/ReturnButton

func _ready() -> void:
	return_button.pressed.connect(_on_return_button_pressed)
	return_button.grab_focus.call_deferred()

func _on_return_button_pressed() -> void:
	Main.game_configured = false
	Main.is_mobile = false
	get_tree().change_scene_to_file("res://scenes/configuration_jeu.tscn")
