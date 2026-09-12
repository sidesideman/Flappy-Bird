extends Node2D

@onready var content: Node = $Content
var current_scene: Node = null

func _ready() -> void:
	goto_scene("res://scenes/start_menu.tscn")

func goto_scene(path: String) -> void:
	if current_scene:
		current_scene.queue_free()
		await current_scene.tree_exited

	var packed: PackedScene = load(path)
	current_scene = packed.instantiate()
	content.add_child(current_scene)
