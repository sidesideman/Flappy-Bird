extends Node

func change_scene(path: String) -> void:
	# 這裡可以先播放轉場動畫，再切換
	var packed: PackedScene = load(path)
	get_tree().change_scene_to_packed(packed)
