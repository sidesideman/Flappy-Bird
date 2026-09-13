extends Node

var _tweens: Dictionary = {}

func create(key: String) -> Tween:
	kill(key)
	
	var tween := create_tween()
	_tweens[key] = tween
	tween.finished.connect(func(): _tweens.erase(key), CONNECT_ONE_SHOT)
	
	return tween

func kill(key: String) -> void:
	if _tweens.has(key):
		var tween: Tween = _tweens[key]
		if tween and tween.is_valid():
			tween.kill()
		_tweens.erase(key)
		
func kill_all():
	for key in _tweens.keys():
		kill(key)

func tween_property(
	key: String,
	object: Object,
	property: String,
	final_val: Variant,
	duration: float,
	trans: Tween.TransitionType = Tween.TRANS_LINEAR,
	ease_type: Tween.EaseType = Tween.EASE_IN_OUT
) -> Tween:
	var tween := create(key)
	tween.set_trans(trans).set_ease(ease_type)
	tween.tween_property(object, property, final_val, duration)
	return tween

func tween_interval(key: String, duration: float) -> Tween:
	var tween := create(key)
	tween.tween_interval(duration)
	return tween
