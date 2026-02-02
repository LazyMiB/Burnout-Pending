extends Node2D


@export var armchair_distance := 15
@export var bed_distance := 20

@onready var _global = $"/root/Global"
@onready var _score = $"HUD/ScoreLabel"
@onready var _day = $"HUD/DayLabel"

var _day_text = ""
var _score_text = ""


func _ready():
	_day_text = _day.text
	_score_text = _score.text
	RenderingServer.set_default_clear_color(Color("#000000"))
	_global.on_day_increased.connect(_on_day_changed)
	_global.on_score_changed.connect(_on_score_changed)
	if _global.night:
		_set_night()
		_global.on_play_sound.emit("back", $"Player".position)
	else:
		_set_day()
		_global.on_play_sound.emit("start", $"Player".position)
	_on_score_changed(_global.current_score)
	_on_day_changed(_global.current_day)


func _exit_tree():
	_global.on_day_increased.disconnect(_on_day_changed)
	_global.on_score_changed.disconnect(_on_score_changed)


func _process(_delta):
	# armchair handle
	var distance = $"Player".position.distance_to($"Armchair".position)
	if distance < armchair_distance and _is_day():
		get_tree().change_scene_to_file("res://flow/flow.tscn")
	# bed handle
	distance = $"Player".position.distance_to($"Bed".position)
	if distance < bed_distance and not _is_day():
		if $"SleepTimer".is_stopped():
			$"SleepTimer".start()


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


func _on_pause_button_pressed():
	get_tree().paused = true
	$"Pause".show()


func _on_day_changed(day):
	_day.set_deferred("text", _day_text % day)


func _on_score_changed(score):
	_score.set_deferred("text", _score_text % score)


func _on_sleep_timer_timeout():
	_global.increase_day()
	_global.reset_current_score()
	call_deferred("_set_day")
	_global.on_play_sound.emit("wake_up", $"Player".position)
