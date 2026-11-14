extends CharacterBody3D

@export var walk_speed := 5.2
@export var sprint_speed := 8.0
@export var acceleration := 18.0
@export var gravity := 22.0
@export var mouse_sensitivity := 0.003

var touch_move := Vector2.ZERO
var sprinting := false
var camera_pitch := -0.18
@onready var pivot: Node3D = $CameraPivot
@onready var body_mesh: MeshInstance3D = $Body

func _ready() -> void:
    var capsule := CapsuleMesh.new()
    capsule.radius = 0.42
    capsule.height = 1.8
    body_mesh.mesh = capsule
    var material := StandardMaterial3D.new()
    material.albedo_color = Color(0.12, 0.42, 0.78)
    material.roughness = 0.7
    body_mesh.material_override = material

func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
        rotate_y(-event.relative.x * mouse_sensitivity)
        camera_pitch = clamp(camera_pitch - event.relative.y * mouse_sensitivity, -0.8, 0.35)
        pivot.rotation.x = camera_pitch
    if event is InputEventMouseButton and event.pressed:
        Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
    if event.is_action_pressed("ui_cancel"):
        Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _physics_process(delta: float) -> void:
    var keyboard := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
    var input_dir := keyboard if keyboard.length() > 0.05 else touch_move
    var forward := -global_transform.basis.z
    var right := global_transform.basis.x
    var direction := (right * input_dir.x + forward * -input_dir.y).normalized()
    var speed := sprint_speed if sprinting else walk_speed
    var target := direction * speed
    velocity.x = move_toward(velocity.x, target.x, acceleration * delta)
    velocity.z = move_toward(velocity.z, target.z, acceleration * delta)
    if not is_on_floor():
        velocity.y -= gravity * delta
    else:
        velocity.y = -0.2
    if direction.length() > 0.1:
        body_mesh.rotation.y = lerp_angle(body_mesh.rotation.y, atan2(direction.x, direction.z), 10.0 * delta)
    move_and_slide()

func set_touch_move(value: Vector2) -> void:
    touch_move = value

func set_sprinting(value: bool) -> void:
    sprinting = value
