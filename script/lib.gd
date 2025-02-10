extends Node

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

func is_in_same_directory(file_path1: String, file_path2: String) -> bool:
	return get_directory(file_path1) == get_directory(file_path2)

func is_directory(path: String) -> bool:
	return DirAccess.open(path) is DirAccess

func is_file(path: String) -> bool:
	var file = FileAccess.open(path, FileAccess.READ)
	return file != null

func is_exist(path: String) -> bool:
	return is_directory(path) or is_file(path)
