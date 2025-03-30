extends Label

@onready var camera: Camera2D = get_tree().get_root().get_camera_2d()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("Info"):
		visible = not visible

func _process(_delta: float) -> void:
	text = tr("Info") % [camera.position, tr("CameraLock") if camera.is_lock else "", camera.zoom.x, Engine.get_frames_per_second()]
