extends Node2D


@export var warning_time:= 5.0
@export var min_time_between_fly_bys:= 30.0
@export var max_time_between_fly_bys:= 60.0
@export var dive_speed:= 3000

@onready var xsm: State = $xsm

@onready var warning_sfx: AudioStreamPlayer2D = $WarningSfx
@onready var grab_sfx: AudioStreamPlayer2D = $GrabSfx
@onready var flyby_sfx: AudioStreamPlayer2D = $FlyBySfx


func fly_by() -> void:
	Logger.info("Eagle about to attack!")
	warning_sfx.play()
	await get_tree().create_timer(warning_time).timeout
	
	Logger.info("Eagle attacking!")
	flyby_sfx.play()
	if Globals.player.is_under_cover():
		xsm.change_state("flyby")
	else:
		xsm.change_state("dive")
	
