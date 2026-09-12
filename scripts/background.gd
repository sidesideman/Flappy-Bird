extends Parallax2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameEvents.player_died.connect(_on_player_died)
	GameEvents.restart.connect(_on_restart)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()


func _on_player_died():
	autoscroll = Vector2.ZERO
	
func _on_restart():
	autoscroll = Vector2(-100,0)
