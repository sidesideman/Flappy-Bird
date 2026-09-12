extends HBoxContainer

@export var digit_textures: Array[Texture2D] = []
var min_digits: int = 1
var digit_rects: Array[TextureRect] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if digit_textures.size() != 10:
		push_error("digit_textures number not matching (0~9)")
		return
		
	for i in range(min_digits):
		_create_digit_rect()
		
	GameEvents.score_changed.connect(_on_score_changed)
	_update_score(GameEvents.score)

func _create_digit_rect() -> void:
	var rect := TextureRect.new()
	rect.stretch_mode = TextureRect.STRETCH_KEEP
	rect.expand_mode = TextureRect.EXPAND_KEEP_SIZE
	rect.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	add_child(rect)
	digit_rects.append(rect)
	
func _on_score_changed(new_score: int) -> void:
	_update_score(new_score)
	
func _update_score(score: int) -> void:
	var score_str := str(score)

	# 補前導零，避免寬度一直跳動
	while score_str.length() < min_digits:
		score_str = "0" + score_str

	# 如果分數位數超過目前節點數量，動態增加
	while digit_rects.size() < score_str.length():
		_create_digit_rect()

	# 更新每個 TextureRect 的貼圖
	for i in range(score_str.length()):
		var digit := int(score_str[i])
		digit_rects[i].texture = digit_textures[digit]
		digit_rects[i].visible = true

	# 隱藏多出來的位數
	for i in range(score_str.length(), digit_rects.size()):
		digit_rects[i].visible = false
