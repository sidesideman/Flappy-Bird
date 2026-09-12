extends Node

signal player_died
signal score_changed(new_score: int)
signal restart

var score: int = 0
var high_score: int = 0

func add_score(amount: int = 1) -> void:
	score += amount
	score_changed.emit(score)
	
func reset_score() -> void:
	score = 0
	score_changed.emit(score)
	
func save_high_score() -> void:
	if score > high_score:
		high_score = score
		
func has_visibility(node: Node) -> bool:
	return node is CanvasItem

func toggle_visibility(node: Node):
	if node.has_visibility:
		node.visible = !node.visible
