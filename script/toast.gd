extends Control

@onready var toastlabel = $"ToastLabel"
@onready var timer: Timer = $"Timer"

func show_message(message: String, time: float = 1) -> void:
	toastlabel.text = message
	show()
	timer.start(time)

func _on_timer_timeout() -> void:
	hide()
