extends Spatial

export(NodePath) var source
export(bool) var render_acoustic = false

var vel = Vector3()
var dir = Vector3()
const MAX_SPEED = 1
const ACCEL = 4.5
const DEACCEL= 16
const MAX_SLOPE_ANGLE = 40

var MOUSE_SENSITIVITY = 0.05

var _source_node

onready var _volume_l: = 0.5
onready var _volume_r: = 0.5

onready var camera = $PitchAxis/Camera
onready var left_ear = $PitchAxis/LeftEar
onready var right_ear = $PitchAxis/RightEar
onready var pitch_axis = $PitchAxis

signal volume_ready(l, r)

func _ready():
	_source_node = get_node(source)
	connect("volume_ready", _source_node, "set_volume")
	left_ear.listens_to = left_ear.get_path_to(_source_node)
	right_ear.listens_to = right_ear.get_path_to(_source_node)
	if render_acoustic:
		camera.cull_mask |= 1 << 10
	else:
		camera.cull_mask &= ~(1 << 10)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(_delta):
	var v_l = update_ear(left_ear)
	var v_r = update_ear(right_ear)
	if v_l != 0.0:
		_volume_l = v_l
	if v_r != 0.0:
		_volume_r = v_r
	if v_l != 0.0 && v_r != 0.0:
		print_debug(v_l,",",v_r)
		emit_signal("volume_ready", v_l, v_r)

func _physics_process(delta):
	process_input(delta)
	process_movement(delta)

func process_input(delta):
	
	# ----------------------------------
	# Walking
	dir = Vector3()
	var cam_xform = camera.get_global_transform()

	var input_movement_vector = Vector2()

	if Input.is_action_pressed("movement_forward"):
		input_movement_vector.y += 1
	if Input.is_action_pressed("movement_backward"):
		input_movement_vector.y -= 1
	if Input.is_action_pressed("movement_left"):
		input_movement_vector.x -= 1
	if Input.is_action_pressed("movement_right"):
		input_movement_vector.x += 1

	input_movement_vector = input_movement_vector.normalized()

	# Basis vectors are already normalized.
	dir += -cam_xform.basis.z * input_movement_vector.y
	dir += cam_xform.basis.x * input_movement_vector.x
	# ----------------------------------

	# ----------------------------------
	# Capturing/Freeing the cursor
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	# ----------------------------------

func process_movement(delta):
	dir.y = 0
	dir = dir.normalized()

	vel.y = 0


	var target = dir
	target *= MAX_SPEED

	var hvel = vel
	hvel.y = 0
	var accel
	if dir.dot(hvel) > 0:
		accel = ACCEL
	else:
		accel = DEACCEL

	hvel = hvel.linear_interpolate(target, accel * delta)
	vel.x = hvel.x
	vel.z = hvel.z
	#vel = move_and_slide(vel, Vector3(0, 1, 0), 0.05, 4, deg2rad(MAX_SLOPE_ANGLE))

	global_translate(vel * delta)

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		pitch_axis.rotate_x(deg2rad(event.relative.y * MOUSE_SENSITIVITY) * -1)
		self.rotate_y(deg2rad(event.relative.x * MOUSE_SENSITIVITY * -1))

		var camera_rot = pitch_axis.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -70, 70)
		pitch_axis.rotation_degrees = camera_rot

func update_ear(ear):
#	ear.update_viewport()
	var v: float = ear.integrate_volume()
	return v

