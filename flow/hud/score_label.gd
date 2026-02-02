extends Label


@onready var _global = $"/root/Global"

var _score_text = ""


func _ready():
	_score_text = text
	_on_score_changed(_global.current_score)
	_global.on_score_changed.connect(_on_score_changed)


func _exit_tree():
	_global.on_score_changed.disconnect(_on_score_changed)


func _on_score_changed(score):
	set_deferred("text", _score_text % score)
