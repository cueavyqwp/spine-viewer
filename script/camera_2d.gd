extends Camera2D

var start_position = Vector2.ZERO
var start_camera_position = Vector2.ZERO
var start_touch_position = Vector2.ZERO
var start_touch_index = 0
var is_drag = false
var is_lock = false
var zoom_factor = 1.0
var zoom_speed = 0

func _input(event: InputEvent) -> void:
	zoom_speed = lerp(0.10, 1.0, zoom_factor / 10.0)
	if Input.is_action_pressed("Ctrl"):
		zoom_speed *= 2
	elif Input.is_action_pressed("Shift"):
		zoom_speed *= 0.05
	if Input.is_action_just_pressed("Tab"):
		is_lock = not is_lock
	if Input.is_action_just_pressed("Home"):
		position = Vector2.ZERO
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
	elif event is InputEventScreenTouch:
		if event.index == 0:
			if event.double_tap:
				is_lock = not is_lock
			else:
				start_touch_position = event.position
				if event.is_pressed():
					is_drag = true
					start_position = event.position
					start_camera_position = position
				else:
					is_drag = false
					start_position = Vector2.ZERO
					start_camera_position = Vector2.ZERO
		else:
			if event.pressed:
				if event.index == 1 and start_touch_index == 1:
					$"..".change_hud()
					start_touch_index = -1
				else:
					start_touch_index = event.index
			is_drag = false
			start_position = Vector2.ZERO
			start_camera_position = Vector2.ZERO
	zoom_factor = clamp(zoom_factor, 0.10, 5)
	if is_lock:
		is_drag = false
		start_position = Vector2.ZERO
		start_camera_position = Vector2.ZERO
	else:
		if event is not InputEventKey and is_drag and start_position:
			position = start_camera_position + (start_position - event.position) / zoom_factor
		if Input.is_action_pressed("Up"):
			position.y -= 1
		if Input.is_action_pressed("Down"):
			position.y += 1
		if Input.is_action_pressed("Left"):
			position.x -= 1
		if Input.is_action_pressed("Right"):
			position.x += 1

func _process(delta: float) -> void:
	zoom = lerp(zoom, Vector2(zoom_factor, zoom_factor), 8 * delta)
	$"../UI/control/slider_zoom".set_value_no_signal(zoom.x)
	$"../UI/control/slider_zoom/slider_zoom_label".text = "缩放比例:%.2f" % zoom.x
	$"../UI/info/label_position".text = "相机位置(x,y):(%d,%d)" % [position.x, position.y]
	if is_lock:
		$"../UI/info/label_position".text += "(已锁定)"

func _on_slider_zoom_value_changed(value: float) -> void:
	zoom_factor = value
	zoom = Vector2(value, value)
