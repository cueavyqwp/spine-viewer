extends Node2D

var is_android = OS.get_name() == "Android"

func clear_tmp() -> void:
	if is_directory("user://tmp"):
		remove_directory("user://tmp")
	else:
		DirAccess.open("user://").make_dir("tmp")

func quit(exit_code: int = 0) -> void:
	clear_tmp()
	get_tree().quit(exit_code)

func get_directory(file_path: String) -> String:
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file:
		return file_path.get_base_dir()
	return ""

func remove_directory(path: String) -> void:
	var directory = DirAccess.open(path)
	if not directory:
		return

	var files = directory.get_files()
	for file in files:
		directory.remove(file)

	var dirs = directory.get_directories()
	for dir in dirs:
		remove_directory(path.path_join(dir))
		directory.remove(dir)

func copy_file(path: String, to: String, override: bool = false) -> void:
	if not override and is_file(to):
		return
	var file = FileAccess.open(path, FileAccess.READ)
	if file:
		var file_to = FileAccess.open(to, FileAccess.WRITE)
		if file_to:
			file_to.store_buffer(file.get_buffer(file.get_length()))
			file.close()
			file_to.close()

func is_in_same_directory(base_path: String, compare_path: String) -> bool:
	return get_directory(base_path) == get_directory(compare_path)

func is_directory(path: String) -> bool:
	return DirAccess.open(path) is DirAccess

func is_file(path: String) -> bool:
	return FileAccess.open(path, FileAccess.READ) is FileAccess

func is_exist(path: String) -> bool:
	return is_directory(path) or is_file(path)

func rotate_point(pos: Vector2, theta: float) -> Vector2:
	var sin_theta = sin(theta)
	var cos_theta = cos(theta)
	return Vector2(pos.x * cos_theta + pos.y * sin_theta, pos.y * cos_theta - pos.x * sin_theta)

func limit_range(origin: Vector2, b: float, c: float, mouse_position: Vector2, theta: float = 0) -> Vector2:
	var local_mouse_position: Vector2 = to_local(mouse_position)
	var relative_position: Vector2 = origin - local_mouse_position
	var zoom: Vector2 = get_viewport().get_camera_2d().zoom
	var viewport_size: Vector2 = Vector2(get_viewport_rect().size) / zoom
	var origin_canvas: Vector2 = get_viewport().get_screen_transform() * get_global_transform_with_canvas() * origin / zoom
	var n = clamp(min(min(origin_canvas.x, viewport_size.x - origin_canvas.x), min(origin_canvas.y, viewport_size.y - origin_canvas.y)) / b, 1, INF)
	var b_sqr: float = pow(b * n, 2)
	var a_sqr: float = b_sqr + pow(c * n, 2)
	var k: float = 1.0
	if theta:
		relative_position = rotate_point(relative_position, theta)
	if pow(relative_position.y, 2) / a_sqr + pow(relative_position.x, 2) / b_sqr > 1:
		k = sqrt((b_sqr * a_sqr) / (pow(relative_position.y, 2) * b_sqr + pow(relative_position.x, 2) * a_sqr))
	return origin + rotate_point(relative_position, PI - theta) * k / n

func limit_range_circle(origin: Vector2, radius: float, mouse_position: Vector2) -> Vector2:
	var local_mouse_position: Vector2 = to_local(mouse_position)
	var relative_position: Vector2 = local_mouse_position - origin
	var zoom: Vector2 = get_viewport().get_camera_2d().zoom
	var viewport_size: Vector2 = Vector2(get_viewport_rect().size) / zoom
	var origin_canvas: Vector2 = get_viewport().get_screen_transform() * get_global_transform_with_canvas() * origin / zoom
	var max_radius = clamp(
		min(origin_canvas.x, viewport_size.x - origin_canvas.x, origin_canvas.y, viewport_size.y - origin_canvas.y),
		1,
		INF
	)
	var final_radius = min(radius, max_radius)
	if relative_position.length_squared() > final_radius * final_radius:
		relative_position = relative_position.normalized() * final_radius
	return origin + relative_position

func judge_circle(origin: Vector2, radius: float, mouse_position: Vector2) -> bool:
	var point = abs(origin) - abs(to_local(mouse_position))
	return pow(point.x, 2) + pow(point.y, 2) <= pow(radius, 2)
