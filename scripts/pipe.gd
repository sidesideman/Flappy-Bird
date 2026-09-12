extends Node2D

const speed: float = 100
@onready var point_audio: AudioStreamPlayer = $scoreArea/pointAudio

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameEvents.player_died.connect(_on_player_died)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x -= speed * delta

	if global_position.x < -200:
		queue_free()
		
func _on_player_died():
	set_process(false)
	set_physics_process(false)


func _on_score_area_body_entered(body: Node2D) -> void:
	point_audio.play()
	GameEvents.add_score()
