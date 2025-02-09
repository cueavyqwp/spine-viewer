extends ItemList

var spinesprite: SpineSprite

func _ready() -> void:
	spinesprite = $"../../../SpineSprite"

func _on_option_add_pressed() -> void:
	add_item($"../option_list_animation/option_animation".get_item_name())
	add_item(["不循环", "循环"][int($"../option_list_animation/option_loop".button_pressed)])
	add_item(String.num($"../option_list_animation/option_track".get_selected_id()))

func _on_option_remove_pressed() -> void:
	if is_anything_selected():
		var index = get_selected_items()[0]
		for i in range(3):
			remove_item(index)

func _on_item_selected(index: int) -> void:
	select(index - index % 3)

func _on_option_play_pressed() -> void:
	if spinesprite.is_load:
		spinesprite.reset_animation()
		for num in range(int(item_count / 3)):
			num = num * 3
			var animation = get_item_text(num)
			var loop = {"不循环": false, "循环": true}[get_item_text(num + 1)]
			var track = get_item_text(num + 2).to_int()
			if num == 0:
				spinesprite.get_animation_state().set_animation(animation, loop, track)
			else:
				spinesprite.get_animation_state().add_animation(animation, 0, loop, track)

func _on_option_clear_pressed() -> void:
	clear()

func _on_option_up_pressed() -> void:
	if is_anything_selected():
		var index = get_selected_items()[0]
		index -= index % 3
		if index > 0:
			for i in range(3):
				move_item(index + i, index + i - 3)

func _on_option_down_pressed() -> void:
	if is_anything_selected():
		var index = get_selected_items()[0]
		index -= index % 3
		if index < (item_count - 3):
			for i in range(3):
				move_item(index, index + 5)
