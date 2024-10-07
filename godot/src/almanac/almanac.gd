extends Control

@onready var debuffs = $Debuffs
@onready var combos = $Combos


func _ready() -> void:
	hide()

#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("almanac"):
		#visible = not visible


func _on_debuff_button_toggled(toggled_on):
	debuffs.visible = not toggled_on
	combos.visible = toggled_on
