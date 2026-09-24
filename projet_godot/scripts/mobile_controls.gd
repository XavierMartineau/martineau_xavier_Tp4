extends Control

@onready var left_button: Button = $LeftButton
@onready var right_button: Button = $RightButton
@onready var jump_button: Button = $JumpButton
@onready var attack_button: Button = $AttackButton

func _ready() -> void:
	set_process_input(false)
	_bind_button(left_button, "promener_gauche")
	_bind_button(right_button, "promener_droite")
	_bind_button(jump_button, "sauter")
	_bind_button(attack_button, "Ataquer")
	set_language("fr")

func set_language(language: String) -> void:
	if language == "en":
		jump_button.text = "SPACE\nJUMP"
		attack_button.text = "E\nATTACK"
	else:
		jump_button.text = "ESPACE\nSAUT"
		attack_button.text = "E\nATTAQUE"

func _bind_button(button: Button, action: StringName) -> void:
	button.button_down.connect(func() -> void:
		Input.action_press(action)
		_animate_button(button, true)
	)
	button.button_up.connect(func() -> void:
		Input.action_release(action)
		_animate_button(button, false)
	)


func _animate_button(button: Button, is_pressed: bool) -> void:
	var target_color := Color(1.0, 0.9, 0.55, 1.0) if is_pressed else Color.WHITE
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(button, "modulate", target_color, 0.08)

func release_all() -> void:
	Input.action_release("promener_gauche")
	Input.action_release("promener_droite")
	Input.action_release("sauter")
	Input.action_release("Ataquer")
