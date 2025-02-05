extends Label

var path_skel = "";
var path_atlas = "";
var path_img : PackedStringArray = [];

func _process(_delta: float) -> void:
	$".".text = "skel路径 : " + path_skel + "\natlas路径: " + path_atlas + "\n图片路径 : " + "\n           ".join( path_img )

func _on_file_skel_file_selected(path: String) -> void:
	path_skel = path

func _on_file_atlas_file_selected(path: String) -> void:
	path_atlas = path

func _on_file_img_files_selected(paths: PackedStringArray) -> void:
	path_img = paths
