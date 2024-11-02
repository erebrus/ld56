extends Control
class_name LoseScreen

@onready var reason_1: Label = $MarginContainer/VBoxContainer/Reason1
@onready var reason_2: Label = $MarginContainer/VBoxContainer/Reason2
@onready var tip_1: Label = $MarginContainer/VBoxContainer/Tip
@onready var tip_2: Label = $MarginContainer/VBoxContainer/Tip2

func show_overlay(type:Types.LossType):
	match type:
		Types.LossType.BIRD:
			reason_1.visible=true
			reason_2.visible=false
			tip_1.visible=true
			tip_2.visible=false
		Types.LossType.ENERGY:
			reason_1.visible=false
			reason_2.visible=true
			tip_1.visible=false
			tip_2.visible=true
	visible=true
	
func _input(e: InputEvent):
	if (e.is_action_pressed("ui_accept") or e.is_action_pressed("ui_cancel")) and visible:
		Globals.show_start_screen()
