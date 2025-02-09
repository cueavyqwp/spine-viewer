extends SpineSprite

var path_skel = "";
var path_atlas = "";
var path_img: PackedStringArray = [];

var animations: PackedStringArray = []
var is_load = false;

func load_skeleton(_path_skel: String = path_skel, _path_atlas: String = path_atlas, _path_img: PackedStringArray = path_img) -> void:
	var skeleton_file_res = SpineSkeletonFileResource.new()
	var atlas_res = SpineAtlasResource.new()
	var is_copy = false
	skeleton_file_res.load_from_file(_path_skel)
	for path in _path_img:
		if not Lib.is_in_same_directory(path, _path_atlas):
			is_copy = true
			break
	if is_copy:
		for path in _path_img:
			Lib.copy_file(path, "user://tmp".path_join(path.get_file()))
		var path_atlas_source = _path_atlas
		_path_atlas = "user://tmp".path_join(_path_atlas.get_file())
		Lib.copy_file(path_atlas_source, _path_atlas)
	atlas_res.load_from_atlas_file(_path_atlas)
	skeleton_data_res = SpineSkeletonDataResource.new()
	skeleton_data_res.skeleton_file_res = skeleton_file_res
	skeleton_data_res.atlas_res = atlas_res
	animations.clear()
	for animation in skeleton_data_res.get_animations():
		animations.append(animation.get_name())
	is_load = true

func reset_animation() -> void:
	if is_load:
		get_animation_state().clear_tracks()
		get_animation_state().set_empty_animations(0)
		get_skeleton().set_bones_to_setup_pose()
		get_skeleton().set_slots_to_setup_pose()
