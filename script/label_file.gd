extends Label

var spinesprite: SpineSprite

func _ready() -> void:
	spinesprite = $"../../../SpineSprite"

func _process(_delta: float) -> void:
	var path_img_show = spinesprite.path_img.duplicate()
	if len(path_img_show) > 5:
		path_img_show.resize(5)
		path_img_show[-1] = "..."
	text = "skel路径 : %s\natlas路径: %s\n图片路径 : %s" % [spinesprite.path_skel, spinesprite.path_atlas, "\n           ".join(path_img_show)]

func _on_file_skel_file_selected(path: String) -> void:
	spinesprite.path_skel = path

func _on_file_atlas_file_selected(path: String) -> void:
	spinesprite.path_atlas = path

func _on_file_img_files_selected(paths: PackedStringArray) -> void:
	spinesprite.path_img = paths
