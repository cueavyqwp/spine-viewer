extends Label

var timer_toast: Timer

func _ready() -> void:
	get_viewport().size_changed.connect(_on_size_changed)
	_on_size_changed()
	timer_toast = $"timer_toast"

func _on_size_changed() -> void:
	position.x = get_viewport().size.x / 2 - size.x / 2
	position.y = get_viewport().size.y - size.y

func show_message(message: String, time: float = 1) -> void:
	timer_toast.wait_time = time
	text = message
	show()
	timer_toast.start()

func _on_timer_toast_timeout() -> void:
	hide()
