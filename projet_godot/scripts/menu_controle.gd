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

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	pause_button.icon = PAUSE_ICON
	pause_menu.hide()
	instructions_screen.hide()
	mobile_controls.hide()
	device_menu.show()
	pause_button.hide()
	volume_button.hide()
	get_tree().paused = true
	$DeviceMenu/PortableButton.grab_focus.call_deferred()


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


func _select_device(is_mobile: bool) -> void:
	device_menu.hide()
	mobile_controls.visible = is_mobile
	pause_button.show()
	volume_button.show()
	get_tree().paused = false
