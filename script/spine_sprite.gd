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
	# 重置眼部追踪与摸头
	spine_bone_eye.bone_mode = SpineConstant.BoneMode.BoneMode_Follow
	spine_bone_touch.bone_mode = SpineConstant.BoneMode.BoneMode_Follow
	# 若存在待机动画则播放
	if "Idle_01" in animations:
		# 播放开始动画
		get_animation_state().set_animation("Start_Idle_01", false, 0)
		get_animation_state().add_animation("Idle_01", 0, true, 0)

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

enum TYPES {NONE = -1, HEAD = 0, EYE = 1, CHEEK = 2}

class interact:
	var pos: Vector2 = Vector2.ZERO
	var start: bool = false
	var end: bool = false
	var speed: float = 12.0
	var base_l: float = 200.0
	var time_hold: float = 0.25
	var type: TYPES = TYPES.NONE
	var spine_sprite: SpineSprite
	var spine_bone_eye: SpineBoneNode
	var spine_bone_touch: SpineBoneNode
	var talk_index: int = 0
	var pressed: bool = false
	var to_look: bool = false
	var time_last: float = -1.0
	func _init(_spine_sprite, _spine_bone_eye, _spine_bone_touch) -> void:
		self.spine_sprite = _spine_sprite
		self.spine_bone_eye = _spine_bone_eye
		self.spine_bone_touch = _spine_bone_touch
	func judge(mouse_position: Vector2):
		if self.spine_bone_touch.position != Vector2.ZERO and Lib.judge_circle(self.spine_bone_touch.position, 200, mouse_position):
			self.spine_sprite.get_animation_state().set_animation("Pat_01_A", true, 1)
			self.spine_sprite.get_animation_state().set_animation("Pat_01_M", true, 2)
			self.spine_bone_touch.bone_mode = SpineConstant.BoneMode.BoneMode_Drive
			self.pos = self.spine_bone_touch.position
			self.type = TYPES.HEAD
			self.start = true
		else:
			self.time_last = Time.get_unix_time_from_system()
	func release():
		if self.time_last != -1.0 and Time.get_unix_time_from_system() - self.time_last <= self.time_hold:
			talk()
		self.time_last = -1.0
		self.start = false
		self.end = true
	func process(delta: float, mouse_position: Vector2):
		if self.time_last != -1.0 and Time.get_unix_time_from_system() - self.time_last > self.time_hold:
			self.spine_sprite.get_animation_state().set_animation("Look_01_A", true, 1)
			self.spine_sprite.get_animation_state().set_animation("Look_01_M", true, 2)
			self.spine_bone_eye.bone_mode = SpineConstant.BoneMode.BoneMode_Drive
			self.pos = self.spine_bone_eye.position
			self.time_last = -1.0
			self.type = TYPES.EYE
			self.to_look = false
			self.start = true
		match self.type:
			TYPES.HEAD:
				if self.end:
					self.spine_bone_touch.position = lerp(self.spine_bone_touch.position, self.pos, delta * self.speed)
					var diff = abs(abs(self.spine_bone_touch.position) - abs(self.pos))
					diff = diff.x + diff.y
					if diff <= 5:
						self.end = false
						self.spine_sprite.get_animation_state().set_animation("PatEnd_01_A", false, 1)
						self.spine_sprite.get_animation_state().set_animation("PatEnd_01_M", false, 2)
						self.spine_bone_touch.bone_mode = SpineConstant.BoneMode.BoneMode_Follow
				elif self.start:
					var children: Array = spine_bone_touch.find_bone().get_children()
					var l: float = base_l
					if children:
						l = children[0].get_data().get_length()
					l *= 0.6
					var to = Lib.limit_range_circle(self.pos, l, mouse_position)
					self.spine_bone_touch.position = lerp(self.spine_bone_touch.position, to, delta * self.speed)
			TYPES.EYE:
				if self.end:
					self.spine_bone_eye.position = lerp(self.spine_bone_eye.position, self.pos, delta * self.speed)
					var diff = abs(abs(self.spine_bone_eye.position) - abs(self.pos))
					diff = diff.x + diff.y
					if diff <= 5:
						self.end = false
						self.spine_sprite.get_animation_state().set_animation("LookEnd_01_A", false, 1)
						self.spine_sprite.get_animation_state().set_animation("LookEnd_01_M", false, 2)
						self.spine_bone_eye.bone_mode = SpineConstant.BoneMode.BoneMode_Follow
				elif self.start:
					var children: Array = self.spine_bone_eye.find_bone().get_children()
					var l: float = 200.0
					if children:
						l = children[0].get_data().get_length()
					var to = Lib.limit_range(pos, 0.8 * l, 0.4 * l, mouse_position, self.spine_bone_eye.rotation)
					self.spine_bone_eye.position = lerp(self.spine_bone_eye.position, to, delta * self.speed)
	func talk():
		# self.spine_sprite.get_animation_state().add_animation("Talk_0%d_M" % self.talk_index, 0.1, false, 1)
		# self.spine_sprite.get_animation_state().add_animation("Talk_0%d_A" % self.talk_index, 0.1, false, 2)
		# self.talk_index += 1
		# if self.talk_index >= 5:
		# 	self.talk_index = 0
		pass

@onready var interactr: interact = interact.new(self, spine_bone_eye, spine_bone_touch)

func _ready() -> void:
	self.connect("animation_event", _animation_event)

func _animation_event(_sprite: SpineSprite, _state: SpineAnimationState, _entry: SpineTrackEntry, event: SpineEvent) -> void:
	print(event.get_data().get_audio_path())

func _process(delta: float) -> void:
	interactr.process(delta, get_global_mouse_position())

func _input(event: InputEvent) -> void:
	if tab_container.current_tab == 1 and is_load and event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				interactr.judge(get_global_mouse_position())
			else:
				interactr.release()
