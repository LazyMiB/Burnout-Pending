extends Node2D


@export var armchair_distance := 10
@export var bed_distance := 10

@onready var _global = $"/root/Global"
@onready var _score = $"HUD/ScoreLabel"
@onready var _day = $"HUD/DayLabel"

var _day_text = ""
var _score_text = ""


func _ready():
	_day_text = _day.text
	_score_text = _score.text
	RenderingServer.set_default_clear_color(Color("#000000"))
	_global.on_day_increased.connect(_on_day_change)
	if _global.night:
		_set_night()
		_global.on_play_sound.emit("back", $"Player".position)
	else:
		_set_day()
		_global.on_play_sound.emit("start", $"Player".position)
	_update_score_label()
	_on_day_change(_global.current_day)


func _exit_tree():
	_global.on_day_increased.disconnect(_on_day_change)


func _process(_delta):
	# armchair handle
	var distance = $"Player".position.distance_to($"Armchair".position)
	if distance < armchair_distance and _is_day():
		get_tree().change_scene_to_file("res://flow/flow.tscn")
	# bed handle
	distance = $"Player".position.distance_to($"Bed".position)
	if distance < bed_distance and not _is_day():
		_global.increase_day()
		_global.reset_current_score()
		_set_day()
		_update_score_label()
		_global.on_play_sound.emit("wake_up", $"Player".position)


func _is_day():
	return $"Window/PointLight2D".enabled


func _set_night():
	$"Window".texture = load("res://assets/images/room/window/window-night.png")
	$"Window/PointLight2D".enabled = false
	$"CanvasModulate".show()


func _set_day():
	$"Window".texture = load("res://assets/images/room/window/window.png")
	$"Window/PointLight2D".enabled = true
	$"CanvasModulate".hide()


func _update_score_label():
	_score.set_deferred("text", _score_text % _global.current_score)


func _on_pause_button_pressed():
	get_tree().paused = true
	$"Pause".show()


func _on_day_change(day):
	_day.set_deferred("text", _day_text % day)
