extends Control



func _on_restart_button_pressed() -> void:
	get_node("/root/Main").goto_scene("res://scenes/start_menu.tscn")
	GameEvents.restart.emit()
