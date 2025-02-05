extends Node2D

func get_directory(file_path: String) -> String:
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file:
		return file_path.get_base_dir()
	return ""

func is_in_same_directory(file_path1: String, file_path2: String) -> bool:
	return get_directory(file_path1) == get_directory(file_path2)

func _ready() -> void:
	Engine.max_fps = 260

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Fullscreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_button_load_pressed() -> void:
	var path_skel : String = $UI/info/label_file.path_skel
	var path_atlas : String = $UI/info/label_file.path_atlas
	var path_img : PackedStringArray = $UI/info/label_file.path_img
	var skeleton_file_res = SpineSkeletonFileResource.new()
	skeleton_file_res.load_from_file(path_skel)
	var atlas_res = SpineAtlasResource.new()
	for path in path_img :
		if is_in_same_directory( path_atlas , path ) :
			continue
		else :
			var img = Image.load_from_file( path )
			atlas_res.textures.append( img )
	atlas_res.load_from_atlas_file(path_atlas);
	var skeleton_data_res = SpineSkeletonDataResource.new()
	skeleton_data_res.skeleton_file_res = skeleton_file_res
	skeleton_data_res.atlas_res = atlas_res
	$SpineSprite.skeleton_data_res = skeleton_data_res
