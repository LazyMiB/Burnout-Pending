extends CharacterBody2D


@export var speed := 10000
@export var zoom_step := 0.1
@export var zoom_max := 2.0
@export var zoom_min := 0.5
@export var bed_distance := 20

var _pos_to = Vector2.ZERO


func _input(event):
	# handle keys
	if event.is_action_pressed("zoom-in") and $"Camera2D".zoom.x < zoom_max:
		$"Camera2D".zoom.x += zoom_step
		$"Camera2D".zoom.y += zoom_step
	elif event.is_action_pressed("zoom-out") and $"Camera2D".zoom.x > zoom_min:
		$"Camera2D".zoom.x -= zoom_step
		$"Camera2D".zoom.y -= zoom_step
	if event.is_action_released("pause"):
		get_tree().paused = true
		get_parent().get_node("Pause").show()
	# handle touches
	if not event.is_action("touch") and event is not InputEventScreenTouch:
		return
	if event.is_pressed():
		_pos_to = get_canvas_transform().affine_inverse() * event.position
	elif event.is_released():
		_pos_to = Vector2.ZERO


func _physics_process(delta):
	# hadle touches
	if _pos_to and position.distance_to(_pos_to) <= 5:
		_pos_to = Vector2.ZERO
	# get directions
	var directions = Input.get_vector("left", "right", "up", "down").normalized()
	if directions:
		_pos_to = Vector2.ZERO
	elif _pos_to:
		directions = (_pos_to - position).normalized()
	# set velocity
	if directions.x:
		velocity.x = directions.x * speed * delta
	else:
		velocity.x = 0
	if directions.y:
		velocity.y = directions.y * speed * delta
	else:
		velocity.y = 0
	# animation
	if directions.y and $"Sprite".animation != "right":
		$"Sprite".play("right")
	if directions.x < 0 and ($"Sprite".animation != "right" or not $"Sprite".flip_h):
		$"Sprite".flip_h = true
		$"Sprite".play("right")
	if directions.x > 0 and ($"Sprite".animation != "right" or $"Sprite".flip_h):
		$"Sprite".flip_h = false
		$"Sprite".play("right")
	if not directions.x and not directions.y and $"Sprite".animation != "idle":
		$"Sprite".flip_h = false
		$"Sprite".play("idle")
	# sleep animation
	var bed_pos = get_parent().get_node("Bed").position
	if $"Sprite".animation == "idle" and position.distance_to(bed_pos) < bed_distance:
		$"Sprite".play("sleep")
	# move
	move_and_slide()
