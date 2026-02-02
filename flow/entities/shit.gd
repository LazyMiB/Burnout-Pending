extends RigidBody2D


@onready var _global = $"/root/Global"


func _ready():
	body_entered.connect(_on_collide)


func _on_collide(node):
	_global.on_collide.emit(self, node)
	if node is CharacterBody2D:
		_global.on_play_sound.emit("collide_player", position)
		_global.on_life_decreased.emit()
