extends RigidBody2D


@onready var _global = $"/root/Global"
@onready var _light = $"PointLight2D"
@onready var _sprite = $"Sprite"
@onready var _timer = $"Timer"


func _init():
	randomize()


func _ready():
	if randf() > 0.5:
		_on_timer_timeout()
	_timer.start()
	body_entered.connect(_on_collide)


func is_lighted():
	if _sprite.animation == "on":
		return true
	return false


func _on_collide(node):
	if node is CharacterBody2D:
		if is_lighted():
			_global.on_play_sound.emit("double_score_up", position)
		else:
			_global.on_play_sound.emit("score_up", position)
	else:
		_global.on_play_sound.emit("collide_lamp", position)


func _on_timer_timeout():
	if _light.enabled:
		_light.enabled = false
		_sprite.play("off")
	else:
		_light.enabled = true
		_sprite.play("on")
