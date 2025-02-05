extends Node2D

func _on_button_skel_pressed() -> void:
	$file_skel.show()

func _on_button_atlas_pressed() -> void:
	$file_atlas.show()

func _on_button_img_pressed() -> void:
	$file_img.show()
