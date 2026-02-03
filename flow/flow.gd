extends Node2D


@onready var _global = $"/root/Global"

var _rect_pos = Vector2.ZERO
var _rect_size = Vector2(480, 640)
var _rect_color = Color("#090909")


func _ready():
	RenderingServer.set_default_clear_color(Color("#000000"))
	queue_redraw()
	_global.on_play_sound.emit("start_flow", position)
	get_window().size_changed.connect(_on_size_changed)


func _on_size_changed():
	queue_redraw()


func _input(event):
	if event.is_action_released("pause"):
		get_tree().paused = true
		$"Pause".show()


func _draw():
	var draw_area = Rect2(_rect_pos, _rect_size)
	draw_rect(draw_area, _rect_color, true)


func _on_pause_button_pressed():
	get_tree().paused = true
	$"Pause".show()
