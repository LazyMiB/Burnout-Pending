extends Node2D


const COLORS := [
	Color.WHITE,
	Color(0.943, 0.943, 0.943, 1.0),
	Color(0.904, 0.904, 0.904, 1.0),
	Color(0.865, 0.865, 0.865, 1.0),
	Color(0.822, 0.822, 0.822, 1.0),
	Color(0.784, 0.784, 0.784, 1.0),
	Color(0.746, 0.746, 0.746, 1.0),
	Color(0.706, 0.706, 0.706, 1.0),
]
const SQUARE_AREA := 10000

@export var size_min := 1.0
@export var size_max := 2.0
@export var speed_min := 25.0
@export var speed_max := 50.0
@export var density := 1.0
@export var amount_limit := 50
@export var enabled := true
@export var limit_x := 480
@export var limit_y := 640

var _stars = []


func _init():
	randomize()


func _ready():
	_fill_stars()
	queue_redraw()


func _process(delta):
	if not visible or not get_parent().visible:
		return
	if not enabled:
		return
	var for_remove := []
	var limit = _get_limit()
	for star in _stars:
		star.pos.y = star.pos.y + star.speed * delta
		if (
			star.pos.y > limit.max.y + star.size
			or star.pos.x >= limit.max.x + star.size
			or star.pos.x <= limit.min.x - star.size
		):
			for_remove.append(star)
	for star in for_remove:
		_stars.erase(star)
	var in_start = true if _stars.size() else false
	for i in range(for_remove.size()):
		_stars.append(_make_random_star(in_start))
	queue_redraw()


func _draw():
	for star in _stars:
		draw_circle(star.pos, star.size, star.color)


func _fill_stars():
	var size: Vector2 = get_viewport().size
	var amount = _calc_amount(size)
	_stars.clear()
	for i in amount:
		var star = _make_random_star(false)
		_stars.append(star)


func _calc_amount(size):
	var area = size.x * size.y
	var amount = int(area / SQUARE_AREA * density)
	if amount > amount_limit:
		amount = amount_limit
	return amount


func _make_random_star(in_start):
	var size_star = randf_range(size_min, size_max)
	var limit = _get_limit()
	var x = randf_range(limit.min.x + size_star, limit.max.x - size_star)
	var y = limit.min.y + size_star
	if not in_start:
		y = randf_range(limit.min.y + size_star, limit.max.y - size_star)
	var pos = Vector2(x, y)
	var star := {
		"pos": pos,
		"size": size_star,
		"color": COLORS[randi_range(0, COLORS.size() - 1)],
		"speed": randf_range(speed_min, speed_max),
	}
	return star


func _get_limit():
	var center = get_viewport_rect().size / 2
	var area = Vector2(limit_x, limit_y) / 2
	var limit = {
		"min": center - area,
		"max": center + area
	}
	return limit
