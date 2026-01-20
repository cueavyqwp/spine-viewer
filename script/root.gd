extends Node2D

@onready var spinesprite: SpineSprite = $"SpineSprite"
@onready var toast: Control = $"CanvasLayer/Toast"
@onready var ui: Control = $"CanvasLayer/UI"

@export var show_hud: bool = true
@export var wait_time: float = 2.0

var quit_time = 0

func change_hud() -> void:
	show_hud = not show_hud
	if show_hud:
		ui.show()
	else:
		ui.hide()

func _ready() -> void:
	get_tree().root.files_dropped.connect(_on_files_dropped)
	get_viewport().size_changed.connect(_on_size_changed)

	Lib.clear_tmp()
	_on_size_changed()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("HUD"):
		change_hud()

	if Input.is_action_just_pressed("Fullscreen"):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN else DisplayServer.WINDOW_MODE_FULLSCREEN)

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST or what == NOTIFICATION_WM_GO_BACK_REQUEST:
		if Lib.is_android:
			if not show_hud:
				change_hud()
			elif Time.get_unix_time_from_system() - quit_time <= wait_time:
				Lib.quit()
			else:
				toast.show_message("再次返回退出", wait_time)
				quit_time = Time.get_unix_time_from_system()
		else:
			Lib.quit()

func _on_files_dropped(files: PackedStringArray) -> void:
	spinesprite.reset_path()
		for path in files:
			if ".skel" in path:
				spinesprite.path_skel = path
			if ".atlas" in path:
				spinesprite.path_atlas = path
	spinesprite.load_skeleton()

func _on_size_changed() -> void:
	var scale_ui = get_viewport_rect().size / Vector2(ProjectSettings.get_setting("display/window/size/viewport_width"), ProjectSettings.get_setting("display/window/size/viewport_height"))
	ui.scale = scale_ui
	toast.scale = ui.scale
