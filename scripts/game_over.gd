extends Control

@onready var pipe_spawner: Node2D = %pipeSpawner


func _on_restart_button_pressed() -> void:
	var viewport_size: Vector2 = get_viewport().get_visible_rect().size
	TweenManager.tween_property(
		"btn_scale_%s" % pipe_spawner.get_instance_id(),
		pipe_spawner,
		"position",
		Vector2(-viewport_size.x - 300, -viewport_size.y),
		0.3,
		Tween.TRANS_CUBIC,
		Tween.EASE_IN_OUT
	)
	SceneManager.change_scene("res://scenes/start_menu.tscn", "down")
	GameEvents.restart.emit()
	GameEvents.button_clicked.emit()
