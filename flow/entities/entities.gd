extends Node2D


const SHIT = preload("res://flow/entities/shit.tscn")
const LAMP = preload("res://flow/entities/lamp.tscn")

@export var viewport_limit := Vector2i(480, 640)
@export var size := Vector2i(60, 60)
@export var impulse_min := 100.0
@export var impulse_max := 200.0
@export var randomize_x := false
@export var rotate_impulse_min := 0.0
@export var rotate_impulse_max := 2.0
@export var entities_limit := 1
@export var entities_limit_increase := 1
@export var entities_limit_max := 10
@export var lamp_chance := 0.5
@export var lamp_chance_decrease := 0.05
@export var lamp_chance_min := 0.1
@export var spawn_time := 2.0
@export var spawn_time_decrease := 0.2
@export var spawn_time_min := 0.3
@export var difficulty_time := 10.0

@onready var _global = $"/root/Global"
@onready var _spawn_timer = $"SpawnTimer"
@onready var _difficulty_timer = $"DifficultyTimer"

var _entities = []


func _init():
	randomize()


func _ready():
	_spawn_entity()
	_spawn_timer.start(spawn_time)
	_difficulty_timer.start(difficulty_time)


func _process(_delta):
	var limit = _get_limit()
	var y_max = limit.max.y + size.y
	var x_min = limit.min.x - size.x
	var x_max = limit.max.x + size.x
	var for_remove = []
	for entity in _entities:
		if (
			entity.position.x >= x_max
			or entity.position.x <= x_min
			or entity.position.y >= y_max
		):
			for_remove.append(entity)
	for entity in for_remove:
		_remove_entity(entity)


func _spawn_entity():
	var entity: RigidBody2D
	if randf() <= lamp_chance:
		entity = LAMP.instantiate()
	else:
		entity = SHIT.instantiate()
	add_child(entity)
	_entities.append(entity)
	if entity.name == "Shit":
		entity.body_entered.connect(func(_e):
			_on_collide_to_shit(entity)
		)
	elif entity.name == "Lamp":
		entity.body_entered.connect(func(_e):
			_on_collide_to_lamp(entity)
		)
	var limit = _get_limit()
	var x = randi_range(limit.min.x + size.x, limit.max.x - size.y)
	entity.position.x = x
	entity.position.y = limit.min.y
	var impulse_strength = randf_range(impulse_min, impulse_max)
	var x_point = x
	if randomize_x:
		x_point = randi_range(limit.min.x + size.x, limit.max.x - size.y)
	var point = Vector2(x_point, limit.max.y)
	var impulse_direction = entity.position.direction_to(point)
	impulse_direction.x *= impulse_strength
	impulse_direction.y *= impulse_strength
	entity.apply_central_impulse(impulse_direction)
	var rotate_impulse = randf_range(rotate_impulse_min, rotate_impulse_max)
	rotate_impulse *= pow(-1, randi() % 2)
	# still open https://github.com/godotengine/godot/issues/29888
	await get_tree().process_frame
	entity.call_deferred("apply_torque_impulse", rotate_impulse)


func _get_limit():
	var center = Vector2i(get_viewport_rect().size / 2)
	var area = viewport_limit / 2
	var limit = {
		"min": center - area,
		"max": center + area
	}
	return limit


func _on_spawn_timer_timeout():
	if _entities.size() < entities_limit:
		_spawn_entity()


func _on_collide_to_shit(entity):
	_global.on_life_decreased.emit()
	_remove_entity(entity)


func _on_collide_to_lamp(entity):
	if entity.is_lighted():
		_global.double_increase_score()
	else:
		_global.increase_score()
	_remove_entity(entity)


func _remove_entity(entity: RigidBody2D):
	_entities.erase(entity)
	entity.queue_free()


func _on_difficulty_timer_timeout():
	var new_entities_limit = entities_limit + entities_limit_increase
	if new_entities_limit > entities_limit_max:
		new_entities_limit = entities_limit_max
	if new_entities_limit != entities_limit:
		set_deferred("entities_limit", new_entities_limit)
	var new_lamp_chance = lamp_chance - lamp_chance_decrease
	if new_lamp_chance < lamp_chance_min:
		new_lamp_chance = lamp_chance_min
	if new_lamp_chance != lamp_chance:
		set_deferred("lamp_chance", new_lamp_chance)
	var new_spawn_time = spawn_time - spawn_time_decrease
	if spawn_time < spawn_time_min:
		new_spawn_time = spawn_time_min
	if spawn_time != new_spawn_time:
		set_deferred("spawn_time", new_spawn_time)
		_spawn_timer.call_deferred("stop")
		_spawn_timer.call_deferred("start", new_spawn_time)
