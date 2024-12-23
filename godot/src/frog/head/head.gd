class_name FrogHead extends Node2D

signal shot_started
signal shot_missed
signal shot_finished

enum Mode {
	LastDirection, # Shoot at last valid direction the mouse pointed at (facing direction)
	MouseRaw, # Shoot at mouse position, without limits
	MouseLimited # Shoot at mouse position, angle clamped to max-min angle
}

@export var shooting_mode := Mode.MouseLimited

var flip_h: bool = false:
	set(value):
		if value == flip_h:
			return
		flip_h = value
		head_sprite.flip_h = flip_h
		rotation = 2 * PI - rotation
		tongue_marker.position.x *= -1
		guide.position = tongue_marker.position
		guide.points[1].x = -guide.points[1].x
	
	
var max_angle: float = deg_to_rad(280)
var min_angle: float = deg_to_rad(15)
var angle: float


@onready var head_sprite = %Sprite2D
@onready var tongue = %Tongue
@onready var tongue_marker = $TonguePosition

@onready var guide: Line2D = $Guide
var can_shoot:bool = true


func _ready() -> void:
	hide()
	tongue_marker.position = tongue.position
	guide.position = tongue.position
	guide.add_point(Vector2.ZERO)
	guide.add_point(Vector2(50, 0))
	
	
	var level = get_parent()
	while level != null and level is not GameLevel:
		level = level.get_parent()
	
	if level != null:
		remove_child(tongue)
		await level.ready
		level.add_child(tongue)
		#player_container.move_child(tongue,  player.get_index()) # tongue behind player
	

func point_at(target: Vector2) -> void:
	var tmp = angle_to_point(target)
	if _inside_boundary(tmp):
		angle = tmp
		guide.rotation = angle
	

func shoot() -> void:
	if tongue.is_shooting:
		return
	
	if Globals.player != null and Globals.player.is_dead:
		return
	
	match shooting_mode:
		Mode.LastDirection:
			_shoot_at_direction()
		Mode.MouseRaw:
			_shoot_at_mouse_raw()
		Mode.MouseLimited:
			if not _shoot_at_mouse_limited():
				return
	
	shot_started.emit()
	
	await tongue.retracted
	
	shot_finished.emit()
	

func _shoot_at_direction():
	_shoot_at_angle(angle)
	

func _shoot_at_angle(shoot_angle: float):
	var tmp = fposmod(shoot_angle, 2*PI)
	if flip_h:
		tmp = fposmod(shoot_angle+PI, 2*PI)
	
	Logger.info("Shooting at angle %.4fº" % rad_to_deg(tmp))
	tongue.shoot(Vector2.RIGHT.rotated(tmp), self)
	

func _shoot_at_mouse_raw():
	Logger.info("Shooting at target %s" % get_global_mouse_position())
	tongue.shoot(tongue_marker.global_position.direction_to(get_global_mouse_position()), self)
	

func _shoot_at_mouse_limited() -> bool:
	var target = get_global_mouse_position()
	Logger.info("Shooting at target %s" % target)
	var shoot_angle = angle_to_point(target)
	
	if _inside_boundary(shoot_angle):
		_shoot_at_angle(shoot_angle)
		return true
		
	return false
	

func angle_to_point(target: Vector2) -> float:
	var tmp = tongue_marker.global_position.angle_to_point(target)
	tmp = fposmod(tmp, 2*PI)
	Logger.trace("Angle: %.4fº" % rad_to_deg(tmp))
	if flip_h:
		return fposmod(tmp - PI, 2*PI)
	else:
		return tmp
	

func _inside_boundary(current: float) -> bool:
	var tmp = current
	if flip_h:
		Logger.trace("Flipped angle: %.4fº" % rad_to_deg(tmp))
		tmp = fposmod(2*PI - tmp, 2*PI)
	
	Logger.trace("%.4fº should be between %.4fº , %.4fº" % [rad_to_deg(current), rad_to_deg(min_angle), rad_to_deg(max_angle)])
	if tmp < min_angle:
		return true
	if tmp > max_angle:
		return true
	else:
		return false
	

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mouse_position = get_global_mouse_position()
		point_at(mouse_position)
		
	if event.is_action_pressed("left_click"):
		shoot()
	

func _on_tongue_missed() -> void:
	shot_missed.emit()
