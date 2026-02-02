extends Node2D


@onready var _global = $"/root/Global"
@onready var _wake_up = $"WakeUp"
@onready var _start = $"Start"
@onready var _back = $"Back"


func _ready():
	_global.on_play_sound.connect(_on_play)


func _exit_tree():
	_global.on_play_sound.disconnect(_on_play)


func _on_play(sound_name, pos):
	if sound_name == "wake_up":
		_wake_up.set_deferred("position", pos)
		_wake_up.call_deferred("play")
	elif sound_name == "start":
		_start.set_deferred("position", pos)
		_start.call_deferred("play")
	elif sound_name == "back":
		_back.set_deferred("position", pos)
		_back.call_deferred("play")
