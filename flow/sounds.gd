extends Node2D


@onready var _global = $"/root/Global"
@onready var _collide = $"Collide"
@onready var _player = $"CollidePlayer"
@onready var _double_up = $"DoubleScoreUp"
@onready var _up = $"ScoreUp"
@onready var _crash = $"Crash"
@onready var _start_flow = $"StartFlow"


func _ready():
	_global.on_play_sound.connect(_on_play)
	_global.on_collide.connect(_on_collide)


func _exit_tree():
	_global.on_play_sound.disconnect(_on_play)
	_global.on_collide.disconnect(_on_collide)


func _on_collide(from, to):
	if from is not CharacterBody2D and to is not CharacterBody2D:
		_on_play("collide", from.position)


func _on_play(sound_name, pos):
	if sound_name == "collide":
		_collide.set_deferred("position", pos)
		_collide.call_deferred("play")
	elif sound_name == "collide_player":
		_player.set_deferred("position", pos)
		_player.call_deferred("play")
	elif sound_name == "score_up":
		_up.set_deferred("position", pos)
		_up.call_deferred("play")
	elif sound_name == "double_score_up":
		_double_up.set_deferred("position", pos)
		_double_up.call_deferred("play")
	elif sound_name == "crash":
		_crash.set_deferred("position", pos)
		_crash.call_deferred("play")
	elif sound_name == "start_flow":
		_start_flow.set_deferred("position", pos)
		_start_flow.call_deferred("play")
