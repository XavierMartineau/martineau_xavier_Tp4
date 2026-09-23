extends CanvasLayer

const PLAY_ICON = preload("res://assets/spritesheets/play_icon.tres")
const PAUSE_ICON = preload("res://assets/spritesheets/pause_icon.tres")



func _ready() -> void:
	$PauseButton.icon = PAUSE_ICON
	$PauseMenu.hide()
	%InstructionsScreen.hide()


func _on_pause_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		pauser()
	else:
		continuer()


func pauser():
	print("PAUSE MODE")
	$PauseButton.icon = PLAY_ICON
	$PauseMenu.show()
	get_tree().paused = true
	%ShowInstructionsButton.grab_focus.call_deferred()


func continuer():
	print("PLAY MODE")
	$PauseButton.icon = PAUSE_ICON
	$PauseMenu.hide()
	%InstructionsScreen.hide()
	get_tree().paused = false


func _on_show_instructions_button_pressed() -> void:
	%InstructionsScreen.show()
	%InstructionsScreen/CloseButton.grab_focus.call_deferred()


func _on_close_instructions_button_pressed() -> void:
	%InstructionsScreen.hide()
	%ShowInstructionsButton.grab_focus.call_deferred()
