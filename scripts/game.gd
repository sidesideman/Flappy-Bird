extends Node2D

@onready var game_over_timer: Timer = $gameManager/gameOverTimer
@onready var start_timer: Timer = $gameManager/startTimer
@onready var game_over: Control = $GameOver

func _ready() -> void:
	GameEvents.player_died.connect(_on_player_died)
	start_timer.start()
	process_mode = Node.PROCESS_MODE_DISABLED
	
func _on_player_died() -> void:
	game_over_timer.start()
	

func _on_game_over_timer_timeout() -> void:
	game_over.visible = true


func _on_start_timer_timeout() -> void:
	process_mode = Node.PROCESS_MODE_INHERIT
	
