extends OptionButton

var items: Dictionary = {}
var spinesprite: SpineSprite

func _ready() -> void:
	spinesprite = $"../../../../SpineSprite"

func get_item_name(index: int = get_index()) -> String:
	return get_item_text(index)

func clear_all() -> void:
	items.clear()
	clear()

func append(value: String, index: int) -> void:
	items[value] = index
	add_item(value, index)

func select_animation(index: int):
	select(index)
	_on_item_selected(index)

func _on_item_selected(index: int = get_selected_id()) -> void:
	if spinesprite.is_load:
		spinesprite.reset_animation()
		spinesprite.get_animation_state().set_animation(get_item_text(index))
