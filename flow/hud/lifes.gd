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
	var new_lifes = _lifes - 1
	set_deferred("_lifes", new_lifes)
	if new_lifes == 2:
		_heart_3.set_deferred("texture", _heart_empty)
	elif new_lifes == 1:
		_heart_2.set_deferred("texture", _heart_empty)
	else:
		_heart_1.set_deferred("texture", _heart_empty)
		_timer.call_deferred("start")
		_global.on_died.emit()


func _on_dead_timer_timeout():
	_global.set_night(true)
	get_tree().change_scene_to_file("res://room/room.tscn")
