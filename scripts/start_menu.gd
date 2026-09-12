extends Control



func _on_start_button_pressed() -> void:
	get_node("/root/Main").goto_scene("res://scenes/game.tscn")


func _on_settings_button_pressed() -> void:
	get_node("/root/Main").goto_scene("res://scenes/setting_menu.tscn")
