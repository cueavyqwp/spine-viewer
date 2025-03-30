extends FileDialog

func show_dialog(dialog_mode: FileMode = FILE_MODE_OPEN_ANY, filter: PackedStringArray = [], root: String = "") -> void:
	file_mode = dialog_mode
	title = tr("FileDialogTitle%d" % file_mode)
	ok_button_text = tr("FileDialogOK%d" % file_mode)
	root_subfolder = root
	filters = filter
	show()

func _ready() -> void:
	if Lib.is_android:
		root_subfolder = "/storage/emulated/0/"
	cancel_button_text = tr("FileDialogCancel")
