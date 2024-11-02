extends Control

@onready var debuffs = $Debuffs
@onready var combos = $Combos


func _ready() -> void:
	hide()


func _on_debuff_button_toggled(toggled_on):
	debuffs.visible = not toggled_on
	combos.visible = toggled_on
