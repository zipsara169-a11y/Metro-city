extends CanvasLayer

var player: CharacterBody3D
var joystick_origin := Vector2.ZERO
var joystick_active := false
var move_vector := Vector2.ZERO
var sprint_button_down := false

func _ready() -> void:
    await get_tree().process_frame
    player = get_parent().get_node_or_null("Player")
    _build_hud()

func _build_hud() -> void:
    var root := Control.new()
    root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(root)

    var title := Label.new()
    title.text = "METRO CITY  |  OPEN WORLD PROTOTYPE"
    title.position = Vector2(22, 18)
    title.add_theme_font_size_override("font_size", 19)
    title.add_theme_color_override("font_color", Color(1, 1, 1))
    root.add_child(title)

    var hint := Label.new()
    hint.text = "Explore the city  •  WASD / touch controls"
    hint.position = Vector2(22, 47)
    hint.add_theme_font_size_override("font_size", 14)
    hint.add_theme_color_override("font_color", Color(0.88, 0.93, 1))
    root.add_child(hint)

    var pad := ColorRect.new()
    pad.name = "TouchPad"
    pad.position = Vector2(28, -190)
    pad.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
    pad.size = Vector2(160, 160)
    pad.color = Color(0.08, 0.12, 0.18, 0.35)
    pad.mouse_filter = Control.MOUSE_FILTER_STOP
    root.add_child(pad)
    pad.gui_input.connect(_on_pad_input)

    var sprint := Button.new()
    sprint.text = "RUN"
    sprint.position = Vector2(-132, -120)
    sprint.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
    sprint.size = Vector2(104, 72)
    sprint.add_theme_font_size_override("font_size", 20)
    root.add_child(sprint)
    sprint.button_down.connect(_set_sprint.bind(true))
    sprint.button_up.connect(_set_sprint.bind(false))

    var jump := Button.new()
    jump.text = "JUMP"
    jump.position = Vector2(-132, -205)
    jump.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
    jump.size = Vector2(104, 68)
    root.add_child(jump)
    jump.pressed.connect(_jump)

func _on_pad_input(event: InputEvent) -> void:
    if event is InputEventScreenTouch:
        joystick_active = event.pressed
        if not joystick_active:
            move_vector = Vector2.ZERO
            _send_move()
    elif event is InputEventScreenDrag and joystick_active:
        var center := Vector2(80, 80)
        move_vector = ((event.position - center) / 58.0).limit_length(1.0)
        _send_move()
    elif event is InputEventMouseButton:
        joystick_active = event.pressed
        if not joystick_active:
            move_vector = Vector2.ZERO
            _send_move()
    elif event is InputEventMouseMotion and joystick_active:
        move_vector = ((event.position - Vector2(80, 80)) / 58.0).limit_length(1.0)
        _send_move()

func _send_move() -> void:
    if is_instance_valid(player):
        player.set_touch_move(move_vector)

func _set_sprint(value: bool) -> void:
    if is_instance_valid(player):
        player.set_sprinting(value)

func _jump() -> void:
    if is_instance_valid(player) and player.is_on_floor():
        player.velocity.y = 7.0
