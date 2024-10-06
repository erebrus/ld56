extends Parallax2D


@export var warning_time:= 5.0
@export var min_time_between_fly_bys:= 30.0
@export var max_time_between_fly_bys:= 60.0


@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var warning_sfx: AudioStreamPlayer2D = $WarningSfx
@onready var death_sfx: AudioStreamPlayer2D = $DeathSfx


func _ready() -> void:
	schedule_next_flyby()
	

func fly_by() -> void:
	warning_sfx.play()
	
	await get_tree().create_timer(warning_time).timeout
	animation_player.play("fly_by", -1, 0.7)
	

func schedule_next_flyby() -> void:
	var time = randf_range(min_time_between_fly_bys, max_time_between_fly_bys)
	get_tree().create_timer(time).timeout.connect(fly_by)
	
	
