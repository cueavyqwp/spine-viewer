extends Camera2D

@export var speed_factor_normal: float = 1.0
@export var speed_factor_fast: float = 2.0
@export var speed_factor_slow: float = 0.5
@export var zoom_speed: float = 0.05
@export var zoom_min: float = 0.1
@export var zoom_max: float = 5.0
@export var is_lock: bool = false

var speed_factor: float = 1.0
var zoom_factor: float = zoom.x
var is_drag: bool = false
var start_position: Vector2 = Vector2.ZERO

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Tab"):
		is_lock = not is_lock
	if Input.is_action_just_pressed("Home"):
		position = Vector2.ZERO

	if Input.is_action_pressed("Shift"):
		speed_factor = speed_factor_slow
	elif Input.is_action_pressed("Ctrl"):
		speed_factor = speed_factor_fast
	else:
		speed_factor = speed_factor_normal

	if not is_lock:
		if Input.is_action_pressed("Up"):
			position.y -= 1 * speed_factor
		if Input.is_action_pressed("Down"):
			position.y += 1 * speed_factor
		if Input.is_action_pressed("Left"):
			position.x -= 1 * speed_factor
		if Input.is_action_pressed("Right"):
			position.x += 1 * speed_factor

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if is_lock:
				start_position = Vector2.ZERO
			elif event.is_pressed():
				is_drag = true
				start_position = event.position
			else:
				is_drag = false
				start_position = Vector2.ZERO

		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom_factor *= 1.0 + zoom_speed * speed_factor
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom_factor *= 1.0 - zoom_speed * speed_factor

	elif event is InputEventMouseMotion:
		if is_drag:
			position -= (event.position - start_position) / Vector2(zoom_factor, zoom_factor)
			start_position = event.position

	elif event is InputEventScreenTouch:
		if event.index == 0:
			if event.double_tap:
				is_lock = not is_lock
			elif is_lock:
				start_position = Vector2.ZERO
			else:
				is_drag = true
				start_position = event.position
		else:
			is_drag = false

	elif event is InputEventScreenDrag:
		if event.index == 0:
			if is_lock:
				start_position = Vector2.ZERO
			elif is_drag:
				position -= (event.position - start_position) / Vector2(zoom_factor, zoom_factor)
			else:
				is_drag = true
			start_position = event.position
		else:
			is_drag = false

	zoom_factor = clamp(zoom_factor, zoom_min, zoom_max)

func _process(delta: float) -> void:
	zoom = lerp(zoom, Vector2(zoom_factor, zoom_factor), 8 * delta)
