extends CharacterBody2D


@export var energy_min := 0.5
@export var energy_max := 1.0
@export var speed := 20000
@export var friction := 900
@export var gravity := 2200
@export var zoom_step := 0.1
@export var zoom_max := 2.0
@export var zoom_min := 0.5

@onready var _global = $"/root/Global"

var _pos_to = Vector2.ZERO
var _follow_touch = false
var _is_dead = false


func _ready():
	randomize()
	_global.on_died.connect(_on_die)


func _exit_tree():
	_global.on_died.disconnect(_on_die)


func _input(event):
	# handle keys
	if event.is_action_pressed("zoom-in") and $"Camera2D".zoom.x < zoom_max:
		$"Camera2D".zoom.x += zoom_step
		$"Camera2D".zoom.y += zoom_step
	elif event.is_action_pressed("zoom-out") and $"Camera2D".zoom.x > zoom_min:
		$"Camera2D".zoom.x -= zoom_step
		$"Camera2D".zoom.y -= zoom_step
	# handle touches
	if (
		not event.is_action("touch")
		and event is not InputEventScreenTouch
		and event is not InputEventMouseMotion
		and event is not InputEventScreenDrag
	):
		return
	if event.is_action("touch") or event is InputEventScreenTouch:
		if event.is_pressed():
			_follow_touch = true
		elif event.is_released():
			_follow_touch = false
			_pos_to = Vector2.ZERO
	if _follow_touch:
		_pos_to = get_canvas_transform().affine_inverse() * event.position


func _physics_process(delta):
	# get directions
	var directions = Input.get_vector("left", "right", "up", "down").normalized()
	if directions:
		_pos_to = Vector2.ZERO
	elif _follow_touch and _pos_to and position.distance_to(_pos_to) > 5:
		directions = (_pos_to - position).normalized()
	if _is_dead:
		directions = Vector2.ZERO
	# set velocity
	if directions.x:
		velocity.x = directions.x * speed * delta
	if directions.y:
		velocity.y = directions.y * speed * delta
	# friction
	if not directions.x:
		if velocity.x > 0:
			velocity.x -= friction * delta
			if velocity.x < 0:
				velocity.x = 0
		elif velocity.x < 0:
			velocity.x += friction * delta
			if velocity.x > 0:
				velocity.x = 0
		velocity.x = velocity.x
	if not directions.y:
		if velocity.y > 0:
			velocity.y -= friction * delta
			if velocity.y < 0:
				velocity.y = 0
		elif velocity.y < 0:
			velocity.y += friction * delta
			if velocity.y > 0:
				velocity.y = 0
		velocity.y = velocity.y
	# gravity
	if not is_on_floor() and not velocity.y and not _pos_to:
		velocity.y = gravity * delta
	# correcting
	if _pos_to and position.distance_to(_pos_to) < 5:
		velocity = Vector2.ZERO
	# go
	move_and_slide()


func _on_timer_timeout():
	var energy = randf_range(energy_min, energy_max)
	$"PointLight2D".energy = energy


func _on_die():
	_global.on_play_sound.emit("crash", position)
	$"Sprite".play("dead")
	$"CollisionPolygon2D".set_deferred("disabled", true)
	$"PointLight2D".set_deferred("enabled", false)
	$"Timer".stop()
	$"CPUParticles2D".set_deferred("emitting", false)
	_is_dead = true
