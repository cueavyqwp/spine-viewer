extends Label

var path_skel = "";
var path_atlas = "";
var path_img: PackedStringArray = [];

func _process(_delta: float) -> void:
	var path_img_show = path_img.duplicate()
	if len(path_img_show) > 5:
		path_img_show.resize(5)
		path_img_show[-1] = "..."
	text = "skel路径 : %s\natlas路径: %s\n图片路径 : %s" % [path_skel, path_atlas, "\n           ".join(path_img_show)]

func _on_file_skel_file_selected(path: String) -> void:
	path_skel = path

func _on_file_atlas_file_selected(path: String) -> void:
	path_atlas = path

func _on_file_img_files_selected(paths: PackedStringArray) -> void:
	path_img = paths
