extends OptionButton

var items: Dictionary = {}
var animations: PackedStringArray = []

func clear_all() -> void:
	items.clear()
	clear()

func append(value: String, index: int) -> void:
	items[value] = index
	add_item(value, index)

func select_animation(index: int):
	select(index)
	_on_item_selected(index)

func _on_item_selected(index: int) -> void:
	$"../../../../SpineSprite".get_animation_state().clear_tracks()
	$"../../../../SpineSprite".get_animation_state().set_animation(get_item_text(index))
