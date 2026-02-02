extends Node2D


const TRACKS = [
	"res://assets/music/melancholy-1.ogg",
	"res://assets/music/melancholy-2.ogg",
	"res://assets/music/melancholy-3.ogg",
	"res://assets/music/upbeat.ogg"
]


@export var track := 0

@onready var _player = $"AudioPlayer"


func _ready():
	_play_track(track)


func _play_track(index):
	var res = load(TRACKS[index])
	_player.stream = res
	_player.play()


func _on_next():
	var new_track = track + 1
	if new_track >= TRACKS.size():
		new_track = 0
	set_deferred("track", new_track)
	_play_track(new_track)


func _on_audio_player_finished():
	_on_next()
