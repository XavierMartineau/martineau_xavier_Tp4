extends Button

@export var texture_active: Texture2D
@export var texture_mute: Texture2D

func _ready() -> void:
	toggle_mode = true
	var master_bus_idx := AudioServer.get_bus_index("Master")
	if master_bus_idx == -1:
		return
	set_pressed_no_signal(AudioServer.is_bus_mute(master_bus_idx))
	_update_icon()

func _on_toggled(pressed_state: bool) -> void:
	var master_bus_idx = AudioServer.get_bus_index("Master")
	if master_bus_idx == -1:
		return
	AudioServer.set_bus_mute(master_bus_idx, pressed_state)
	_update_icon()


func _update_icon() -> void:
	if button_pressed:
		if texture_mute:
			icon = texture_mute
	elif texture_active:
		icon = texture_active
