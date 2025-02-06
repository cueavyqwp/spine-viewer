extends Node2D

var show_hud = true

func get_directory(file_path: String) -> String:
	if FileAccess.open(file_path, FileAccess.READ):
		return file_path.get_base_dir()
	return ""

func is_in_same_directory(file_path1: String, file_path2: String) -> bool:
	return get_directory(file_path1) == get_directory(file_path2)

func is_directory(path: String) -> bool:
	return DirAccess.open(path) is DirAccess

func is_file(path: String) -> bool:
	return FileAccess.open(path, FileAccess.READ) is FileAccess

func is_exist(path: String) -> bool:
	return is_directory(path) or is_file(path)

func _ready() -> void:
	Engine.max_fps = 260

	get_tree().root.files_dropped.connect(on_files_dropped)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("HUD"):
		show_hud = not show_hud
		if show_hud:
			$UI.show()
		else:
			$UI.hide()

	if Input.is_action_just_pressed("Fullscreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func _on_button_load_pressed() -> void:
	load_skeleton($UI/info/label_file.path_skel, $UI/info/label_file.path_atlas, $UI/info/label_file.path_img)

func _on_button_unload_pressed() -> void:
	$"UI/info/label_file".path_skel = ""
	$"UI/info/label_file".path_atlas = ""
	$"UI/info/label_file".path_img = []

func _on_file_dir_dir_selected(dir: String) -> void:
	for file in DirAccess.open(dir).get_files():
		load_file(dir.path_join(file))

func load_skeleton(path_skel: String, path_atlas: String, path_img: PackedStringArray) -> void:
	var skeleton_file_res = SpineSkeletonFileResource.new()
	skeleton_file_res.load_from_file(path_skel)
	var atlas_res = SpineAtlasResource.new()
	for path in path_img:
		if is_in_same_directory(path_atlas, path):
			continue
		else:
			var img = Image.load_from_file(path)
			atlas_res.textures.append(img)
	atlas_res.load_from_atlas_file(path_atlas);
	var skeleton_data_res = SpineSkeletonDataResource.new()
	skeleton_data_res.skeleton_file_res = skeleton_file_res
	skeleton_data_res.atlas_res = atlas_res
	$SpineSprite.skeleton_data_res = skeleton_data_res

func load_file(path: String) -> void:
	var suffix = path.get_extension()
	if suffix == "skel":
		$"UI/info/label_file".path_skel = path
	elif suffix == "atlas" or suffix == "txt":
		$"UI/info/label_file".path_atlas = path
	else:
		$"UI/info/label_file".path_img.append(path)

func on_files_dropped(files: PackedStringArray) -> void:
	for path in files:
		if is_file(path):
			load_file(path)
		elif is_directory(path):
			_on_file_dir_dir_selected(path)
