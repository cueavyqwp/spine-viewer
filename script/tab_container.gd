extends TabContainer

func _ready() -> void:
	for i in range(get_tab_count()):
		set_tab_title(i, tr(get_tab_title(i)))
