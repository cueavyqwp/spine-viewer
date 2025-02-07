extends Node2D

func _on_button_skel_pressed() -> void:
	$"button_skel/file_skel".show()

func _on_button_atlas_pressed() -> void:
	$"button_atlas/file_atlas".show()

func _on_button_img_pressed() -> void:
	$"button_img/file_img".show()

func _on_button_dir_pressed() -> void:
	$"button_dir/file_dir".show()
