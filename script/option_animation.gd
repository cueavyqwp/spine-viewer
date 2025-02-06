extends OptionButton

func select_animation(index: int):
	select(index)
	_on_item_selected(index)

func _on_item_selected(index: int) -> void:
	$"../../../SpineSprite".get_animation_state().set_animation(get_item_text(index))
