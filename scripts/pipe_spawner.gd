extends Node2D

@export var pipe_scene: PackedScene
@onready var pipe_spawn_timer: Timer = $pipeSpawnTimer

var margin_x: float = 200
var margin_y: float = 90

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pipe_spawn_timer.start()
	GameEvents.player_died.connect(_on_player_died)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pipe_spawn_timer_timeout() -> void:
	var viewport_size := get_viewport_rect().size
	var cam := get_viewport().get_camera_2d()
	var spawn_x: float
	
	if cam:
		spawn_x = cam.global_position.x + viewport_size.x * 0.5 + margin_x
	else:
		spawn_x = viewport_size.x + margin_x
	var spawn_y := randf_range(viewport_size.y / 2 - margin_y, -viewport_size.y / 2 + margin_y)
	
	var pipe := pipe_scene.instantiate()
	add_child(pipe)
	pipe.global_position = Vector2(spawn_x, spawn_y)
	
	#pipe_spawn_timer.wait_time = max(0.25, pipe_spawn_timer.wait_time * 0.98)
	
func _on_player_died():
	set_process(false)
	pipe_spawn_timer.stop()
