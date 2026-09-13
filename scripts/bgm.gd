extends Node

@onready var swoosh_audio: AudioStreamPlayer = $SwooshAudio

func _ready() -> void:
	GameEvents.button_clicked.connect(_on_button_clicked)
	
func _on_button_clicked():
	swoosh_audio.play()
