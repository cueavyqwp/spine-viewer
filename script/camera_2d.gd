extends Camera2D

var start_position = Vector2.ZERO
var start_camera_position = Vector2.ZERO
var is_drag = false
var zoom_factor = 1.0
var zoom_speed = 0

func _input(event: InputEvent) -> void:
	zoom_speed = lerp(0.001, 1.0, zoom_factor / 10.0)
	if Input.is_action_pressed("Ctrl"):
		zoom_speed *= 1.25
	elif Input.is_action_pressed("Shift"):
		zoom_speed *= 0.25
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.is_pressed():
				is_drag = true
				start_position = event.position
				start_camera_position = position
			else:
				is_drag = false
				start_position = Vector2.ZERO
				start_camera_position = Vector2.ZERO
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			start_position = Vector2.ZERO
			zoom_factor += zoom_speed
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			start_position = Vector2.ZERO
			zoom_factor -= zoom_speed
		zoom_factor = clamp(zoom_factor, 0.01, 10)
	if event is not InputEventKey and is_drag and start_position:
		position = start_camera_position + (start_position - event.position) / zoom_factor

func _process(delta: float) -> void:
	zoom = lerp(zoom, Vector2(zoom_factor, zoom_factor), 8 * delta)
