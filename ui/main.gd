extends Control


@onready var _record = $"VBoxContainer/RecordLabel"
@onready var _info = $"VBoxContainer/InfoLabel"
@onready var _music_check = $"VBoxContainer/MusicCheck"
@onready var _sounds_check = $"VBoxContainer/SoundsCheck"
@onready var _global = $"/root/Global"


func _ready():
	get_tree().paused = false
	RenderingServer.set_default_clear_color(Color("151515"))
	_record.text = _record.text % [_global.score, _global.days]
	_info.text = _info.text % ProjectSettings.get_setting("application/config/version")
	if _global.is_music_enabled():
		_music_check.set_deferred("button_pressed", true)
	else:
		_music_check.set_deferred("button_pressed", false)
	if _global.is_sounds_enabled():
		_sounds_check.set_deferred("button_pressed", true)
	else:
		_sounds_check.set_deferred("button_pressed", false)


func _on_play_button_pressed():
	_global.reset()
	_global.increase_day()
	_global.on_button_click_sound()
	get_tree().change_scene_to_file("res://room/room.tscn")


func _on_music_check_pressed():
	_global.on_button_click_sound()
	_global.on_music_toggle.emit(_music_check.button_pressed)


func _on_sounds_check_pressed():
	_global.on_button_click_sound()
	_global.on_sounds_toggle.emit(_sounds_check.button_pressed)
