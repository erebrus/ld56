extends Path2D

@export var open_texture: Texture2D
@export var closed_texture: Texture2D


@export var warning_time:= 5.0
@export var min_time_between_fly_bys:= 30.0
@export var max_time_between_fly_bys:= 60.0
@export var dive_speed:= 3000
@export var grab_start:= 0.40
@export var grab_end:= 0.43
@export var enabled:= true

@onready var xsm: State = $xsm
@onready var claw = $Claw
@onready var sprite = %Sprite2D
@onready var warning_sfx: AudioStreamPlayer = $WarningSfx
@onready var grab_sfx: AudioStreamPlayer = $GrabSfx
@onready var flyby_sfx: AudioStreamPlayer = $FlyBySfx


func _ready() -> void:
	sprite.texture = open_texture
	

func follow_player(offset: Vector2 = Vector2.ZERO) -> void:
	global_position = Globals.player.global_position + offset
	

func move(delta: float) -> void:
	claw.progress += dive_speed * delta
	

func trigger_now() -> void:
	if xsm.active_states.has("disabled"):
		xsm.change_state("waiting")
	

func fly_by() -> void:
	Logger.info("Eagle attacking!")
	flyby_sfx.play()
	if Globals.player.is_under_cover() or Globals.player.is_dead:
		xsm.change_state("flyby")
	else:
		Globals.player.is_dead = true
		xsm.change_state("dive")
	
