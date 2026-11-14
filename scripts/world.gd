extends Node3D

const PLAYER_SCENE := preload("res://scenes/player.tscn")
const CITY_RADIUS := 7
const BLOCK_SIZE := 24.0
const ROAD_WIDTH := 8.0

func _ready() -> void:
    _make_environment()
    _make_ground_and_roads()
    _make_city()
    var player = PLAYER_SCENE.instantiate()
    player.position = Vector3(0, 1.2, 13)
    add_child(player)

func _make_environment() -> void:
    var env := WorldEnvironment.new()
    var e := Environment.new()
    e.background_mode = Environment.BG_SKY
    e.sky = Sky.new()
    e.sky.sky_material = ProceduralSkyMaterial.new()
    e.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
    e.ambient_light_color = Color(0.72, 0.78, 0.9)
    e.ambient_light_energy = 0.65
    e.tonemap_mode = Environment.TONE_MAPPER_FILMIC
    env.environment = e
    add_child(env)

    var sun := DirectionalLight3D.new()
    sun.rotation_degrees = Vector3(-48, -32, 0)
    sun.light_energy = 1.15
    sun.shadow_enabled = true
    add_child(sun)

func _mat(color: Color, roughness := 0.85) -> StandardMaterial3D:
    var m := StandardMaterial3D.new()
    m.albedo_color = color
    m.roughness = roughness
    return m

func _box(parent: Node3D, size: Vector3, pos: Vector3, material: Material) -> MeshInstance3D:
    var mesh := BoxMesh.new()
    mesh.size = size
    var instance := MeshInstance3D.new()
    instance.mesh = mesh
    instance.position = pos
    instance.material_override = material
    parent.add_child(instance)
    return instance

func _make_ground_and_roads() -> void:
    var ground := _mat(Color(0.20, 0.32, 0.22))
    _box(self, Vector3(420, 1, 420), Vector3(0, -0.55, 0), ground)

    var asphalt := _mat(Color(0.105, 0.115, 0.13))
    var line := _mat(Color(0.92, 0.83, 0.43))
    for i in range(-CITY_RADIUS, CITY_RADIUS + 1):
        var p := float(i) * BLOCK_SIZE
        _box(self, Vector3(ROAD_WIDTH, 0.12, 420), Vector3(p, 0.02, 0), asphalt)
        _box(self, Vector3(420, 0.12, ROAD_WIDTH), Vector3(0, 0.025, p), asphalt)
        for z in range(-190, 191, 12):
            _box(self, Vector3(0.18, 0.025, 4.0), Vector3(p, 0.095, z), line)
        for x in range(-190, 191, 12):
            _box(self, Vector3(4.0, 0.025, 0.18), Vector3(x, 0.10, p), line)

func _make_city() -> void:
    var rng := RandomNumberGenerator.new()
    rng.seed = 87231
    var palettes = [
        Color(0.64, 0.67, 0.70), Color(0.76, 0.68, 0.56),
        Color(0.46, 0.55, 0.63), Color(0.78, 0.77, 0.70),
        Color(0.52, 0.58, 0.52)
    ]
    for x in range(-CITY_RADIUS, CITY_RADIUS):
        for z in range(-CITY_RADIUS, CITY_RADIUS):
            if abs(x) <= 1 and abs(z) <= 1:
                continue
            var center_x := (float(x) + 0.5) * BLOCK_SIZE
            var center_z := (float(z) + 0.5) * BLOCK_SIZE
            var width := rng.randf_range(10.0, 14.0)
            var depth := rng.randf_range(10.0, 14.0)
            var floors := rng.randi_range(2, 9)
            var height := float(floors) * rng.randf_range(2.8, 3.4)
            var building := Node3D.new()
            building.position = Vector3(center_x, 0, center_z)
            add_child(building)
            var color: Color = palettes[rng.randi_range(0, palettes.size() - 1)]
            _box(building, Vector3(width, height, depth), Vector3(0, height / 2.0, 0), _mat(color))
            _box(building, Vector3(width + 0.5, 0.35, depth + 0.5), Vector3(0, height + 0.17, 0), _mat(Color(0.18, 0.2, 0.23)))
            _add_windows(building, width, depth, height, rng)
            _add_tree(Vector3(center_x + 8.0, 0, center_z + 8.0), rng)

func _add_windows(parent: Node3D, width: float, depth: float, height: float, rng: RandomNumberGenerator) -> void:
    var glass := _mat(Color(0.12, 0.22, 0.29), 0.28)
    var rows := int(height / 3.2)
    for floor in range(rows):
        var y := 1.2 + float(floor) * 3.1
        for side in [-1.0, 1.0]:
            for i in range(3):
                var x := (float(i) - 1.0) * (width / 3.3)
                _box(parent, Vector3(1.35, 1.15, 0.08), Vector3(x, y, side * (depth / 2.0 + 0.045)), glass)
                var z := (float(i) - 1.0) * (depth / 3.3)
                _box(parent, Vector3(0.08, 1.15, 1.35), Vector3(side * (width / 2.0 + 0.045), y, z), glass)

func _add_tree(pos: Vector3, rng: RandomNumberGenerator) -> void:
    var trunk := _mat(Color(0.25, 0.15, 0.09))
    var leaves := _mat(Color(0.12, rng.randf_range(0.28, 0.42), 0.18))
    var t := MeshInstance3D.new()
    var tm := CylinderMesh.new()
    tm.top_radius = 0.18
    tm.bottom_radius = 0.28
    tm.height = 2.2
    t.mesh = tm
    t.position = pos + Vector3(0, 1.1, 0)
    t.material_override = trunk
    add_child(t)
    var crown := MeshInstance3D.new()
    var cm := SphereMesh.new()
    cm.radius = 1.35
    cm.height = 2.5
    crown.mesh = cm
    crown.position = pos + Vector3(0, 2.8, 0)
    crown.material_override = leaves
    add_child(crown)
