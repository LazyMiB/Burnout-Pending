extends Node


var days := 0
var score := 0
var current_day := 0
var current_score := 0
var night := false


signal on_music_toggle(state)
signal on_sounds_toggle(state)
signal on_life_decreased()
signal on_score_changed()
signal on_day_increased()
signal on_died()
signal on_play_sound()
signal on_collide()


func _ready():
	on_sounds_toggle.connect(_on_sounds_toggle)
	on_music_toggle.connect(_on_music_toggle)


func set_night(value):
	set_deferred("night", value)


func increase_day():
	var new_day = current_day + 1
	if new_day > days:
		set_deferred("days", new_day)
	set_deferred("current_day", new_day)
	on_day_increased.emit(new_day)


func _increase_score(doubled):
	var new_score = current_score + (2 if doubled else 1)
	if new_score > score:
		set_deferred("score", new_score)
	set_deferred("current_score", new_score)
	on_score_changed.emit(new_score)


func increase_score():
	_increase_score(false)


func double_increase_score():
	_increase_score(true)


func reset():
	set_deferred("night", false)
	set_deferred("current_score", 0)
	set_deferred("current_day", 1)
	if 1 > days:
		set_deferred("days", 1)


func reset_current_score():
	set_deferred("current_score", 0)
	on_score_changed.emit(0)


func on_button_click_sound():
	on_play_sound.emit("click", Vector2.ZERO)


func on_pause_sound():
	on_play_sound.emit("pause", Vector2.ZERO)


func is_sounds_enabled():
	return not AudioServer.is_bus_mute(1)


func is_music_enabled():
	return not AudioServer.is_bus_mute(2)


func _on_sounds_toggle(state):
	AudioServer.call_deferred("set_bus_mute", 1, not state)


func _on_music_toggle(state):
	AudioServer.call_deferred("set_bus_mute", 2, not state)
