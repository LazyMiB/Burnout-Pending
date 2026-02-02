extends CanvasLayer


@onready var _record = $"Panel/VBoxContainer/RecordLabel"
@onready var _music_check = $"Panel/VBoxContainer/MusicCheck"
@onready var _sounds_check = $"Panel/VBoxContainer/SoundsCheck"
@onready var _global = $"/root/Global"

var _record_text_backup = ""


func _ready():
	_record_text_backup = _record.text
	_record.text = _record.text % [_global.score, _global.days]
	visibility_changed.connect(_on_visible_toggled)


func _input(event):
	if not visible:
		return
	if event.is_action_released("action"):
		_on_resume_button_pressed()


func _on_resume_button_pressed():
	_global.on_button_click_sound()
	hide()
	get_tree().paused = false


func _on_menu_button_pressed():
	_global.on_button_click_sound()
	get_tree().change_scene_to_file("res://ui/main.tscn")


func _on_visible_toggled():
	_global.on_pause_sound()
	if not visible:
		return
	if _global.is_music_enabled():
		_music_check.set_deferred("button_pressed", true)
	else:
		_music_check.set_deferred("button_pressed", false)
	if _global.is_sounds_enabled():
		_sounds_check.set_deferred("button_pressed", true)
	else:
		_sounds_check.set_deferred("button_pressed", false)
	_record.set_deferred("text", _record_text_backup % [_global.score, _global.days])


func _on_music_check_pressed():
	_global.on_button_click_sound()
	_global.on_music_toggle.emit(_music_check.button_pressed)


func _on_sounds_check_pressed():
	_global.on_button_click_sound()
	_global.on_sounds_toggle.emit(_sounds_check.button_pressed)
