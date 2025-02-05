extends Node2D

var show_hud = true

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("HUD"):
		show_hud = not show_hud
		if show_hud :
			$".".show()
		else :
			$".".hide()
