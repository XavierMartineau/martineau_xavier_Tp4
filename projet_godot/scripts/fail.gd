extends Node

@onready var title_label: Label = $DeathMenu/Panel/Title
@onready var message_label: Label = $DeathMenu/Panel/Message
@onready var boss_button: Button = $DeathMenu/Panel/RetryBossButton
@onready var level_button: Button = $DeathMenu/Panel/RetryLevelButton

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = false
	var language: String = Main.language
	_apply_language(language)
	boss_button.grab_focus.call_deferred()

func _apply_language(language: String) -> void:
	if language == "en":
		title_label.text = "YOU DIED"
		message_label.text = "Choose where you want to continue."
		boss_button.text = "RETRY BOSS"
		level_button.text = "RETRY LEVEL"
	else:
		title_label.text = "VOUS ÊTES MORT"
		message_label.text = "Choisissez où vous souhaitez continuer."
		boss_button.text = "RÉESSAYER LE BOSS"
		level_button.text = "RÉESSAYER LE NIVEAU"

func _on_retry_boss_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/BOSS.tscn")

func _on_retry_level_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")
