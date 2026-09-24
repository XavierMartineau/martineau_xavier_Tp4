extends CanvasLayer

const PLAY_ICON = preload("res://assets/spritesheets/play_icon.tres")
const PAUSE_ICON = preload("res://assets/spritesheets/pause_icon.tres")

@onready var pause_button: Button = $PauseButton
@onready var pause_menu: Panel = $PauseMenu
@onready var instructions_screen: Panel = %InstructionsScreen
@onready var instructions_button: Button = %ShowInstructionsButton
@onready var continue_button: Button = %ContinueButton
@onready var device_menu: Panel = $DeviceMenu
@onready var mobile_controls: Control = $MobileControls
@onready var volume_button: Button = $Volume
@onready var language_option: OptionButton = $DeviceMenu/LanguageOption
@onready var start_button: Button = $DeviceMenu/StartButton

var device_selection_started := false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	pause_button.icon = PAUSE_ICON
	pause_menu.hide()
	instructions_screen.hide()
	mobile_controls.hide()
	language_option.add_item("Français")
	language_option.add_item("English")
	language_option.select(1 if Main.language == "en" else 0)
	language_option.item_selected.connect(_on_language_selected)
	_apply_language(Main.language)
	if Main.game_configured and not _is_configuration_scene():
		device_menu.hide()
		mobile_controls.visible = Main.is_mobile
		pause_button.show()
		volume_button.show()
		get_tree().paused = false
		return
	device_menu.show()
	$DeviceMenu/PortableButton.hide()
	$DeviceMenu/MobileButton.hide()
	pause_button.hide()
	volume_button.hide()
	get_tree().paused = true
	start_button.grab_focus.call_deferred()


func _is_configuration_scene() -> bool:
	return get_tree().current_scene.scene_file_path == "res://scenes/configuration_jeu.tscn"


func _on_pause_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		pauser()
	else:
		continuer()


func pauser() -> void:
	pause_button.icon = PLAY_ICON
	pause_menu.show()
	get_tree().paused = true
	continue_button.grab_focus.call_deferred()


func continuer() -> void:
	pause_button.icon = PAUSE_ICON
	pause_menu.hide()
	instructions_screen.hide()
	get_tree().paused = false


func _on_show_instructions_button_pressed() -> void:
	instructions_screen.show()
	%InstructionsScreen/CloseButton.grab_focus.call_deferred()


func _on_close_instructions_button_pressed() -> void:
	instructions_screen.hide()
	instructions_button.grab_focus.call_deferred()


func _on_portable_button_pressed() -> void:
	_select_device(false)


func _on_mobile_button_pressed() -> void:
	_select_device(true)


func _on_start_button_pressed() -> void:
	device_selection_started = true
	start_button.hide()
	$DeviceMenu/PortableButton.show()
	$DeviceMenu/MobileButton.show()
	_apply_language(Main.language)
	$DeviceMenu/PortableButton.grab_focus.call_deferred()


func _select_device(is_mobile: bool) -> void:
	Main.game_configured = true
	Main.is_mobile = is_mobile
	device_menu.hide()
	mobile_controls.visible = is_mobile
	pause_button.show()
	volume_button.show()
	if _is_configuration_scene():
		get_tree().change_scene_to_file("res://scenes/main.tscn")
		return
	get_tree().paused = false


func _on_language_selected(index: int) -> void:
	_apply_language("en" if index == 1 else "fr")


func _apply_language(language: String) -> void:
	var is_english := language == "en"
	Main.language = language
	$DeviceMenu/Title.text = ("CHOOSE YOUR CONTROL" if is_english else "CHOISIS TON CONTRÔLE") if device_selection_started else ("READY TO PLAY?" if is_english else "PRÊT À JOUER ?")
	$DeviceMenu/Description.text = ("Laptop: arrow keys, Space to jump, E to attack\nMobile: touch buttons on screen" if is_english else "Portable : flèches, Espace pour sauter, E pour attaquer\nMobile : boutons tactiles à l'écran") if device_selection_started else ("Choose your language, then press Play." if is_english else "Choisis ta langue, puis appuie sur Jouer.")
	start_button.text = "PLAY" if is_english else "JOUER"
	$DeviceMenu/PortableButton.text = "LAPTOP" if is_english else "PORTABLE"
	$DeviceMenu/MobileButton.text = "MOBILE"
	$PauseMenu/PauseTitle.text = "PAUSE"
	$PauseMenu/ShowInstructionsButton.text = "Instructions"
	$PauseMenu/ContinueButton.text = "Resume" if is_english else "Continuer"
	$PauseMenu/InstructionsScreen/InstructionsTitle.text = "Instructions"
	$PauseMenu/InstructionsScreen/InstructionsLabel.text = "A / D: Move\nSpace: Jump\nEscape: Pause" if is_english else "A / D : Marcher\nEspace : Sauter\nÉchap : Pause"
	pause_button.tooltip_text = "Pause the game" if is_english else "Mettre le jeu en pause"
	volume_button.tooltip_text = "Mute or unmute sound" if is_english else "Activer ou couper le son"
	mobile_controls.set_language(language)
