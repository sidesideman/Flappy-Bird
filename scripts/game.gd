extends Node2D

@onready var game_over_timer: Timer = $gameManager/gameOverTimer

func _ready() -> void:
	GameEvents.player_died.connect(_on_player_died)
	
func _on_player_died() -> void:
	game_over_timer.start()
	


func _on_game_over_timer_timeout() -> void:
	get_node("/root/Main").goto_scene("res://scenes/game_over.tscn")
