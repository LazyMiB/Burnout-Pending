extends Node2D


@onready var _global = $"/root/Global"
@onready var _timer = $"DeadTimer"
@onready var _heart_1 = $"Heart1"
@onready var _heart_2 = $"Heart2"
@onready var _heart_3 = $"Heart3"

var _lifes = 3
var _heart_empty = preload("res://assets/images/game/heart/heart.png")


func _ready():
	_global.on_life_decreased.connect(_on_decrease)


func _exit_tree():
	_global.on_life_decreased.disconnect(_on_decrease)


func _on_decrease():
	_lifes -= 1
	if _lifes == 2:
		_heart_3.texture = _heart_empty
	elif _lifes == 1:
		_heart_2.texture = _heart_empty
	else:
		_heart_1.texture = _heart_empty
		_timer.start()
		_global.on_died.emit()


func _on_dead_timer_timeout():
	_global.night = true
	get_tree().change_scene_to_file("res://room/room.tscn")
