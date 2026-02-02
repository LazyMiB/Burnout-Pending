extends Node


var days := 0
var score := 0
var current_day := 0
var current_score := 0
var night := false


signal on_music_toggle(state)
signal on_sounds_toggle(state)
signal on_life_decreased()
signal on_score_increased()
signal on_day_increased()
signal on_died()
signal on_play_sound()


func _ready():
	on_sounds_toggle.connect(_on_sounds_toggle)
	on_music_toggle.connect(_on_music_toggle)


func increase_day():
	current_day += 1
	if current_day > days:
		days = current_day
	on_day_increased.emit(current_day)


func increase_score():
	current_score += 1
	if current_score > score:
		score = current_score
	on_score_increased.emit(current_score)


func double_increase_score():
	current_score += 2
	if current_score > score:
		score = current_score
	on_score_increased.emit(current_score)


func reset():
	night = false
	current_day = 0
	current_score = 0


func reset_current_score():
	current_score = 0


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
