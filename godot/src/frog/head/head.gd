class_name FrogHead extends Node2D

signal shot_started
signal shot_missed
signal shot_finished

var flip_h: bool = false:
	set(value):
		if value == flip_h:
			return
		flip_h = value
		head_sprite.flip_h = flip_h
		rotation = 2 * PI - rotation
		start_tongue_position.x = -start_tongue_position.x
	
	
var max_angle: float = deg_to_rad(280)
var min_angle: float = deg_to_rad(15)

var tongue_position: Vector2:
	get:
		return global_position + start_tongue_position
	

@onready var head_sprite = %Sprite2D
@onready var tongue = %Tongue

@onready var start_tongue_position = tongue.position

func _ready() -> void:
	remove_child(tongue)
	# TODO: better way to get character's parent?
	var player = get_parent()
	var player_container = player.get_parent()
	await player_container.ready
	player_container.add_child(tongue)
	player_container.move_child(tongue,  player.get_index()) # tongue behind player
	

func point_at(target: Vector2) -> void:
	var angle = global_position.angle_to_point(target)
	angle = fposmod(angle, 2*PI)
	Logger.trace("Angle: %.4fº" % rad_to_deg(angle))
	if flip_h:
		angle = fposmod(angle - PI, 2*PI)
		Logger.trace("Flipped angle: %.4fº" % rad_to_deg(angle))
		if _inside_boundary(fposmod(2*PI - angle, 2*PI)):
			rotation = angle
	else:
		if _inside_boundary(angle):
			rotation = angle
	

func shoot() -> void:
	if tongue.is_shooting:
		return

	shot_started.emit()
	head_sprite.frame = 1
	
	# Shoot at facing direction
	var angle = fposmod(rotation, 2*PI)
	if flip_h:
		angle = fposmod(rotation+PI, 2*PI)
	
	Logger.info("Shooting at angle %.4fº" % rad_to_deg(angle))
	tongue.shoot(global_position + Vector2(100,0).rotated(angle), self)
	
	# Shoot at mouse
	#Logger.info("Shooting at target %s" % get_global_mouse_position())
	#tongue.shoot(get_global_mouse_position(), self)
	
	await tongue.retracted
	
	head_sprite.frame = 0
	shot_finished.emit()
	

func _inside_boundary(angle: float) -> bool:
	Logger.trace("%.4fº should be between %.4fº , %.4fº" % [rad_to_deg(angle), rad_to_deg(min_angle), rad_to_deg(max_angle)])
	if angle < min_angle:
		return true
	if angle > max_angle:
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
