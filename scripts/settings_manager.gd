extends Node

signal settings_changed

const SETTINGS_PATH := "user://settings.cfg"

var config := ConfigFile.new()

# 預設值
var resolution: Vector2i = Vector2i(1280, 720)
var window_mode: int = DisplayServer.WINDOW_MODE_WINDOWED
var vsync: bool = true

var master_volume: float = 1.0
var music_volume: float = 1.0
var sfx_volume: float = 1.0

func _ready() -> void:
	load_settings()
	apply_all()

func load_settings() -> void:
	var err := config.load(SETTINGS_PATH)
	if err != OK:
		return

	resolution = config.get_value("display", "resolution", resolution)
	window_mode = config.get_value("display", "window_mode", window_mode)
	vsync = config.get_value("display", "vsync", vsync)

	master_volume = config.get_value("audio", "master", master_volume)
	music_volume = config.get_value("audio", "music", music_volume)
	sfx_volume = config.get_value("audio", "sfx", sfx_volume)

func save_settings() -> void:
	config.set_value("display", "resolution", resolution)
	config.set_value("display", "window_mode", window_mode)
	config.set_value("display", "vsync", vsync)

	config.set_value("audio", "master", master_volume)
	config.set_value("audio", "music", music_volume)
	config.set_value("audio", "sfx", sfx_volume)

	config.save(SETTINGS_PATH)
	settings_changed.emit()

func apply_all() -> void:
	apply_window_mode()
	apply_resolution()
	apply_vsync()
	apply_volume("Master", master_volume)
	apply_volume("Music", music_volume)
	apply_volume("SFX", sfx_volume)

func apply_resolution() -> void:
	if window_mode == DisplayServer.WINDOW_MODE_WINDOWED:
		DisplayServer.window_set_size(resolution)
		# 讓視窗置中
		var screen_size := DisplayServer.screen_get_size()
		var pos := (screen_size - resolution) / 2
		DisplayServer.window_set_position(pos)

func apply_window_mode() -> void:
	DisplayServer.window_set_mode(window_mode)

func apply_vsync() -> void:
	var mode := DisplayServer.VSYNC_ENABLED if vsync else DisplayServer.VSYNC_DISABLED
	DisplayServer.window_set_vsync_mode(mode)

func apply_volume(bus_name: String, linear: float) -> void:
	var bus_idx := AudioServer.get_bus_index(bus_name)
	if bus_idx == -1:
		return

	if linear <= 0.0:
		AudioServer.set_bus_mute(bus_idx, true)
	else:
		AudioServer.set_bus_mute(bus_idx, false)
		AudioServer.set_bus_volume_db(bus_idx, linear_to_db(linear))
