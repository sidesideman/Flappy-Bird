extends Control

@onready var resolution_option: OptionButton = %resolutionOption
@onready var window_mode_option: OptionButton = %windowModeOption
@onready var vsync_check: CheckButton = %vsyncCheck
@onready var master_slider: HSlider = %masterSlider
@onready var music_slider: HSlider = %musicSlider
@onready var sfx_slider: HSlider = %sfxSlider
@onready var setting_exit_button: Button = %settingExitButton



var resolutions := [
	Vector2i(1280, 720),
	Vector2i(1600, 900),
	Vector2i(1920, 1080),
	Vector2i(2560, 1440),
	Vector2i(3840, 2160),
]

func _ready() -> void:
	_setup_resolution_options()
	_setup_window_mode_options()
	_load_current_settings()
	_connect_signals()
	
	setting_exit_button.pivot_offset = setting_exit_button.size / 2.0
	setting_exit_button.mouse_entered.connect(func(): _scale_to(Vector2(1.25, 1.25)))
	setting_exit_button.mouse_exited.connect(func(): _scale_to(Vector2.ONE))
	
func _setup_resolution_options() -> void:
	resolution_option.clear()
	for res in resolutions:
		resolution_option.add_item("%d x %d" % [res.x, res.y])
		resolution_option.set_item_metadata(resolution_option.item_count - 1, res)

func _setup_window_mode_options() -> void:
	var native := DisplayServer.screen_get_size()
	if not resolutions.has(native):
		resolutions.append(native)
	window_mode_option.clear()
	window_mode_option.add_item("Windowed")
	window_mode_option.add_item("FullScreen")
	window_mode_option.add_item("Exclusive Fullscreen")
	window_mode_option.set_item_metadata(0, DisplayServer.WINDOW_MODE_WINDOWED)
	window_mode_option.set_item_metadata(1, DisplayServer.WINDOW_MODE_FULLSCREEN)
	window_mode_option.set_item_metadata(2, DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)

func _load_current_settings() -> void:
	# 解析度
	for i in resolution_option.item_count:
		var res: Vector2i = resolution_option.get_item_metadata(i)
		if res == SettingsManager.resolution:
			resolution_option.select(i)
			break

	# 視窗模式
	for i in window_mode_option.item_count:
		var mode: int = window_mode_option.get_item_metadata(i)
		if mode == SettingsManager.window_mode:
			window_mode_option.select(i)
			break

	vsync_check.button_pressed = SettingsManager.vsync

	master_slider.value = SettingsManager.master_volume
	music_slider.value = SettingsManager.music_volume
	sfx_slider.value = SettingsManager.sfx_volume

func _connect_signals() -> void:
	resolution_option.item_selected.connect(_on_resolution_selected)
	window_mode_option.item_selected.connect(_on_window_mode_selected)
	vsync_check.toggled.connect(_on_vsync_toggled)
	master_slider.value_changed.connect(_on_master_changed)
	music_slider.value_changed.connect(_on_music_changed)
	sfx_slider.value_changed.connect(_on_sfx_changed)

func _on_resolution_selected(index: int) -> void:
	var res: Vector2i = resolution_option.get_item_metadata(index)
	SettingsManager.resolution = res
	SettingsManager.apply_resolution()
	SettingsManager.save_settings()

func _on_window_mode_selected(index: int) -> void:
	var mode: int = window_mode_option.get_item_metadata(index)
	SettingsManager.window_mode = mode
	SettingsManager.apply_window_mode()
	SettingsManager.apply_resolution()
	SettingsManager.save_settings()

func _on_vsync_toggled(pressed: bool) -> void:
	SettingsManager.vsync = pressed
	SettingsManager.apply_vsync()
	SettingsManager.save_settings()

func _on_master_changed(value: float) -> void:
	SettingsManager.master_volume = value
	SettingsManager.apply_volume("Master", value)
	SettingsManager.save_settings()

func _on_music_changed(value: float) -> void:
	SettingsManager.music_volume = value
	SettingsManager.apply_volume("Music", value)
	SettingsManager.save_settings()

func _on_sfx_changed(value: float) -> void:
	SettingsManager.sfx_volume = value
	SettingsManager.apply_volume("SFX", value)
	SettingsManager.save_settings()




func _on_setting_exit_button_pressed() -> void:
	SceneManager.change_scene("res://scenes/start_menu.tscn", "right")
	GameEvents.button_clicked.emit()



func _scale_to(target: Vector2) -> void:
	TweenManager.tween_property(
		"btn_scale_%s" % setting_exit_button.get_instance_id(),
		setting_exit_button,
		"scale",
		target,
		0.15,
		Tween.TRANS_BACK,
		Tween.EASE_OUT
	)
