extends Node2D

var spinesprite: SpineSprite
var option_animation: OptionButton

var show_hud = true

func change_hud() -> void:
	show_hud = not show_hud
	if show_hud:
		$UI.show()
	else:
		$UI.hide()

func _ready() -> void:
	Engine.max_fps = 260

	get_tree().root.files_dropped.connect(_on_files_dropped)

	Lib.clear_tmp()

	if Lib.is_android:
		OS.request_permissions()
		$"UI/dialog/button_skel/file_skel".current_dir = "/storage/emulated/0/"
		$"UI/dialog/button_atlas/file_atlas".current_dir = "/storage/emulated/0/"
		$"UI/dialog/button_img/file_img".current_dir = "/storage/emulated/0/"
		$"UI/dialog/button_dir/file_dir".current_dir = "/storage/emulated/0/"

	spinesprite = $"SpineSprite"
	option_animation = $"UI/control/option_list_animation/option_animation"

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST or what == NOTIFICATION_WM_GO_BACK_REQUEST:
		Lib.clear_tmp()

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
				option_animation._on_item_selected()
			elif event.keycode == KEY_SPACE:
				$"UI/control/list_animation"._on_option_play_pressed()

func _on_button_load_pressed() -> void:
	if not (spinesprite.path_skel and spinesprite.path_atlas and spinesprite.path_img):
		OS.alert("请选择skel文件,atlas文件与图片", "无法加载")
		return
	spinesprite.load_skeleton()
	option_animation.clear_all()
	for index in range(spinesprite.animations.size()):
		var animation = spinesprite.animations[index]
		option_animation.append(animation, index)
		if animation == "Idle_01":
			option_animation.select_animation(index)

func _on_button_unload_pressed() -> void:
	spinesprite.reset_path()

func _on_file_dir_dir_selected(path: String) -> void:
	var directory = DirAccess.open(path)
	for file in directory.get_files():
		load_file(path.path_join(file))
	for dir in directory.get_directories():
		_on_file_dir_dir_selected(path.path_join(dir))

func load_file(path: String) -> void:
	var suffix = path.get_extension()
	if suffix == "skel" or suffix == "json":
		spinesprite.path_skel = path
	elif suffix == "atlas" or suffix == "txt":
		spinesprite.path_atlas = path
	else:
		spinesprite.path_img.append(path)

func _on_files_dropped(files: PackedStringArray) -> void:
	spinesprite.reset_path()
	for path in files:
		if Lib.is_file(path):
			load_file(path)
		elif Lib.is_directory(path):
			_on_file_dir_dir_selected(path)
		if len(spinesprite.path_img) >= 20:
			spinesprite.path_img.resize(20)
			break
