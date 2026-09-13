extends Node

@export var transition_duration: float = 0.4
@export var transition_type: Tween.TransitionType = Tween.TRANS_CUBIC
@export var transition_ease: Tween.EaseType = Tween.EASE_IN_OUT

var current_scene: Node = null
var container: Node = null
var _is_transitioning: bool = false

func set_container(node: Node) -> void:
	container = node

func change_scene(path: String, direction: String = "left") -> void:
	if _is_transitioning:
		return
	if container == null:
		push_error("SceneManager: 尚未設定 container，請先呼叫 set_container()")
		return

	_is_transitioning = true

	var packed: PackedScene = load(path)
	if packed == null:
		push_error("無法載入場景: " + path)
		_is_transitioning = false
		return

	var new_scene: Node = packed.instantiate()
	container.add_child(new_scene)

	# 只有 CanvasItem 才能做 position 動畫
	if not new_scene is CanvasItem:
		push_error("場景根節點必須是 Node2D 或 Control 才能做滑動轉場")
		new_scene.queue_free()
		_is_transitioning = false
		return

	var viewport_size: Vector2 = get_viewport().get_visible_rect().size

	var start_pos: Vector2
	var end_pos: Vector2 = Vector2.ZERO
	var old_end_pos: Vector2

	match direction:
		"left":
			# 新場景從右邊進來，舊場景往左邊出去
			start_pos = Vector2(viewport_size.x, 0)
			old_end_pos = Vector2(-viewport_size.x, 0)
		"right":
			# 新場景從左邊進來，舊場景往右邊出去
			start_pos = Vector2(-viewport_size.x, 0)
			old_end_pos = Vector2(viewport_size.x, 0)
		"up":
			start_pos = Vector2(0, viewport_size.y)
			old_end_pos = Vector2(0, -viewport_size.y)
		"down":
			start_pos = Vector2(0, -viewport_size.y)
			old_end_pos = Vector2(0, viewport_size.y)
		_:
			start_pos = Vector2(viewport_size.x, 0)
			old_end_pos = Vector2(-viewport_size.x, 0)

	new_scene.position = start_pos
	print(start_pos)
	print(old_end_pos)
	print(end_pos)

	var tween := create_tween().set_parallel(true)
	tween.set_trans(transition_type).set_ease(transition_ease)

	# 新場景滑入
	tween.tween_property(new_scene, "position", end_pos, transition_duration)

	# 舊場景滑出
	if current_scene and is_instance_valid(current_scene) and current_scene is CanvasItem:
		tween.tween_property(current_scene, "position", old_end_pos, transition_duration)

	await tween.finished

	if current_scene and is_instance_valid(current_scene):
		current_scene.queue_free()

	current_scene = new_scene
	_is_transitioning = false
	GameEvents.scene_changed.emit(new_scene)
