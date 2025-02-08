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

func remove_directory_file(path: String) -> void:
	var directory = DirAccess.open(path)
	for file in directory.get_files():
		directory.remove(file)
	for dir in directory.get_directories():
		remove_directory_file(path.path_join(dir))
		directory.remove(dir)

func clear_tmp() -> void:
	if is_directory("user://tmp"):
		remove_directory_file("user://tmp")
	else:
		DirAccess.open("user://").make_dir("tmp")

func copy_file(path: String, to: String, override: bool = false) -> void:
	if not override and is_file(to):
		return
	var file = FileAccess.open(path, FileAccess.READ)
	var file_to = FileAccess.open(to, FileAccess.WRITE)
	file_to.store_buffer(file.get_buffer(file.get_length()))
	file.close()
	file_to.close()

func change_hud() -> void:
	show_hud = not show_hud
	if show_hud:
		$UI.show()
	else:
		$UI.hide()

func _ready() -> void:
	Engine.max_fps = 260

	get_tree().root.files_dropped.connect(on_files_dropped)

	clear_tmp()

	if OS.get_name() == "Android":
		OS.request_permissions()
		$"UI/dialog/button_skel/file_skel".current_dir = "/storage/emulated/0/"
		$"UI/dialog/button_atlas/file_atlas".current_dir = "/storage/emulated/0/"
		$"UI/dialog/button_img/file_img".current_dir = "/storage/emulated/0/"
		$"UI/dialog/button_dir/file_dir".current_dir = "/storage/emulated/0/"

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		clear_tmp()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("HUD"):
		change_hud()

	if Input.is_action_just_pressed("Fullscreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

	$"UI/info/label_fps".text = "FPS:%d" % Engine.get_frames_per_second()

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed:
			if event.keycode == KEY_ENTER:
				$"UI/control/option_list_animation/option_animation"._on_item_selected($"UI/control/option_list_animation/option_animation".get_selected_id())
			elif event.keycode == KEY_SPACE:
				$"UI/control/list_animation"._on_option_play_pressed()

func _on_button_load_pressed() -> void:
	if not ($"UI/info/label_file".path_skel and $"UI/info/label_file".path_atlas and $"UI/info/label_file".path_img):
		OS.alert("请选择skel文件,atlas文件与图片", "无法加载")
		return
	load_skeleton($"UI/info/label_file".path_skel, $"UI/info/label_file".path_atlas, $"UI/info/label_file".path_img)
	$"UI/control/option_list_animation/option_animation".clear()
	for index in range($"UI/control/option_list_animation/option_animation".animations.size()):
		var animation = $"UI/control/option_list_animation/option_animation".animations[index]
		$"UI/control/option_list_animation/option_animation".append(animation, index)
		if animation == "Idle_01":
			$"UI/control/option_list_animation/option_animation".select_animation(index)

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
		copy_file(path, "user://tmp/".path_join(path.get_file()))
	var path_atlas_to = "user://tmp/".path_join(path_atlas.get_file())
	copy_file(path_atlas, path_atlas_to)
	atlas_res.load_from_atlas_file(path_atlas_to)
	var skeleton_data_res = SpineSkeletonDataResource.new()
	skeleton_data_res.skeleton_file_res = skeleton_file_res
	skeleton_data_res.atlas_res = atlas_res
	$SpineSprite.skeleton_data_res = skeleton_data_res
	$"UI/control/option_list_animation/option_animation".animations = []
	for animation in $SpineSprite.skeleton_data_res.get_animations():
		$"UI/control/option_list_animation/option_animation".animations.append(animation.get_name())

func load_file(path: String) -> void:
	var suffix = path.get_extension()
	if suffix == "skel" or suffix == "json":
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
