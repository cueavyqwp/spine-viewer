extends SpineSprite

@onready var camera: Camera2D = $"../Camera2D"

var path_skel = ""
var path_atlas = ""
var path_img: PackedStringArray = []

var animations: PackedStringArray = []
var is_load = false;

func load_skeleton(_path_skel: String = path_skel, _path_atlas: String = path_atlas, _path_img: PackedStringArray = path_img) -> void:
	skeleton_data_res.skeleton_file_res.load_from_file(_path_skel)
	skeleton_data_res.atlas_res.load_from_atlas_file(_path_atlas)
	skeleton_data_res.update_skeleton_data()
	animations.clear()
	for animation in skeleton_data_res.get_animations():
		animations.append(animation.get_name())
	is_load = true
	if "Idle_01" in animations:
		get_animation_state().set_animation("Idle_01", true, 0)
		# TODO 加载时对齐画面(可选项)
		# camera.zoom_factor = max(get_viewport_rect().size.x / skeleton_data_res.get_width(), get_viewport_rect().size.y / skeleton_data_res.get_height()) * 1.05
		# camera.position = Vector2(4 / camera.zoom_factor, -skeleton_data_res.get_height() / 2 + 200 / camera.zoom_factor)
		# p = camera.position

func reset_path() -> void:
	path_skel = ""
	path_atlas = ""
	path_img.clear()

func reset_animation() -> void:
	if is_load:
		get_animation_state().clear_tracks()
		get_animation_state().set_empty_animations(0)
		get_skeleton().set_bones_to_setup_pose()
		get_skeleton().set_slots_to_setup_pose()

@onready var tab_container: TabContainer = $"../CanvasLayer/UI/TabContainer"
@onready var spine_bone_eye: SpineBoneNode = $"SpineBoneEye"
@onready var spine_bone_touch: SpineBoneNode = $"SpineBoneTouch"
var pos: Vector2 = Vector2.ZERO
var to: Vector2 = Vector2.ZERO
var follow_end: bool = false
var pat_end: bool = false
var follow: bool = false
var pat: bool = false

func _ready() -> void:
	self.connect("animation_event", _animation_event)

func _animation_event(_sprite: SpineSprite, _state: SpineAnimationState, _entry: SpineTrackEntry, event: SpineEvent) -> void:
	print(event.get_data().get_audio_path())

func _process(delta: float) -> void:
	if follow:
		var children: Array = spine_bone_eye.find_bone().get_children()
		var l: float = 200.0
		if children:
			l = children[0].get_data().get_length()
		to = Lib.limit_range(pos, 0.8 * l, 0.4 * l, spine_bone_eye.rotation)
		spine_bone_eye.position = lerp(spine_bone_eye.position, to, delta * 12)
	elif follow_end:
		spine_bone_eye.position = lerp(spine_bone_eye.position, pos, delta * 12)
		if Vector2i(spine_bone_eye.position) == Vector2i(pos):
			follow_end = false
			get_animation_state().set_animation("LookEnd_01_A", false, 1)
			get_animation_state().set_animation("LookEnd_01_M", false, 2)
			spine_bone_eye.bone_mode = SpineConstant.BoneMode.BoneMode_Follow
	if pat:
		var children: Array = spine_bone_touch.find_bone().get_children()
		var l: float = 200.0
		if children:
			l = children[0].get_data().get_length()
		l *= 0.6
		to = Lib.limit_range_circle(pos, l)
		spine_bone_touch.position = lerp(spine_bone_touch.position, to, delta * 12)
	elif pat_end:
		spine_bone_touch.position = lerp(spine_bone_touch.position, pos, delta * 12)
		if Vector2i(spine_bone_touch.position) == Vector2i(pos):
			follow_end = false
			get_animation_state().set_animation("PatEnd_01_A", false, 1)
			get_animation_state().set_animation("PatEnd_01_M", false, 2)
			spine_bone_touch.bone_mode = SpineConstant.BoneMode.BoneMode_Follow

func _input(event: InputEvent) -> void:
	if tab_container.current_tab == 1 and is_load and event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				if "Pat_01_M" in animations and not (follow or pat) and spine_bone_touch.bone_mode == SpineConstant.BoneMode.BoneMode_Follow and Lib.judge_circle(spine_bone_touch.position, 200):
					get_animation_state().set_animation("Pat_01_A", true, 1)
					get_animation_state().set_animation("Pat_01_M", true, 2)
					pos = spine_bone_touch.position
					spine_bone_touch.bone_mode = SpineConstant.BoneMode.BoneMode_Drive
					pat = true
				elif "Look_01_M" in animations and not follow and spine_bone_eye.bone_mode == SpineConstant.BoneMode.BoneMode_Follow:
					get_animation_state().set_animation("Look_01_M", true, 1)
					pos = spine_bone_eye.position
					spine_bone_eye.bone_mode = SpineConstant.BoneMode.BoneMode_Drive
					follow = true
			else:
				pat = false
				follow = false
				pat_end = true
				follow_end = true
