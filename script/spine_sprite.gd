extends SpineSprite

var last_mouse_position = Vector2.ZERO
var zoom_factor = 1.0
var zoom_speed = 0

func _input(_event: InputEvent) -> void:
	if Input.is_action_pressed("MouseRight"):
		if last_mouse_position == Vector2.ZERO:
			last_mouse_position = get_global_mouse_position()
		position += get_global_mouse_position() - last_mouse_position
		last_mouse_position = get_global_mouse_position()
	elif Input.is_action_just_released("MouseRight"):
		last_mouse_position = Vector2.ZERO

	if Input.is_action_pressed("Ctrl"):
		zoom_speed = 0.1
	elif Input.is_action_pressed("Shift"):
		zoom_speed = 0.001
	else:
		zoom_speed = 0.05

	if Input.is_action_just_released("WheelUp"):
		zoom_factor += zoom_speed
	elif Input.is_action_just_released("WheelDown"):
		zoom_factor -= zoom_speed

	zoom_factor = clamp( zoom_factor , 0.01 , 8 )

	print(zoom_speed," ",zoom_factor)

	scale = Vector2(zoom_factor, zoom_factor)
