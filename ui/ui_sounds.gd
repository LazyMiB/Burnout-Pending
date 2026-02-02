extends Node2D


@onready var _global = $"/root/Global"
@onready var _click = $"Click"
@onready var _pause = $"Pause"


func _ready():
	_global.on_play_sound.connect(_on_play)


func _exit_tree():
	_global.on_play_sound.disconnect(_on_play)


func _on_play(sound_name, pos):
	if sound_name == "click":
		_click.set_deferred("position", pos)
		_click.call_deferred("play")
	elif sound_name == "pause":
		_pause.set_deferred("position", pos)
		_pause.call_deferred("play")
