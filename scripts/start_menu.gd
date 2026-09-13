extends Control

@onready var settings_button: Button = $MarginContainer2/settingsButton



func _on_start_button_pressed() -> void:
	SceneManager.change_scene("res://scenes/game.tscn", "up")
	GameEvents.button_clicked.emit()


func _on_settings_button_pressed() -> void:
	SceneManager.change_scene("res://scenes/setting_menu.tscn", "left")
	GameEvents.button_clicked.emit()

func _ready() -> void:
	settings_button.pivot_offset = settings_button.size / 2.0
	settings_button.mouse_entered.connect(func(): _scale_to(Vector2(1.25, 1.25)))
	settings_button.mouse_exited.connect(func(): _scale_to(Vector2.ONE))

func _scale_to(target: Vector2) -> void:
	TweenManager.tween_property(
		"btn_scale_%s" % settings_button.get_instance_id(),
		settings_button,
		"scale",
		target,
		0.15,
		Tween.TRANS_BACK,
		Tween.EASE_OUT
	)
