extends PanelContainer

var frog_hyperlog:= false


func _ready() -> void:
	hide()
	for i in Types.BugType:
		%Debuffs.add_item(i, Types.BugType[i])
	for i in Types.COMBOS.size():
		%Combos.add_item(str(i), i)
	

func _input(event: InputEvent) -> void:
	if Debug.debug_build and event.is_action_pressed("debug"):
		visible = not visible
	

func _on_show_frog_debug_pressed():
	if not frog_hyperlog:
		frog_hyperlog = true
		Events.debug_toggled.emit(true)
	

func _on_give_energy_pressed():
	Globals.player.health_component.on_heal(10)
	

func _on_trigger_bird_pressed():
	Globals.level.eagle.trigger_now()
	

func _on_music_tension_toggle_pressed() -> void:
	if Globals.music_manager.current_game_music_id==1:
		Globals.music_manager.change_game_music_to(2)
	else:
		Globals.music_manager.change_game_music_to(1)
	

func _on_deplete_energy_button_pressed():
	Events.energy_depleted.emit()
	Globals.player._on_health_component_died()
	

func _on_death_by_bird_button_pressed():
	Events.game_lost.emit(Types.LossType.BIRD)
	

func _on_next_level_pressed():
	Events.reached_level_end.emit()
	

func _on_win_game_pressed():
	Globals.do_win()
	

func _on_trigger_debuff_pressed():
	var bug = %Debuffs.get_selected_id()
	var scene:PackedScene = Types.DEBUF_MAP[bug]
	var new_debuf:Debuf = scene.instantiate() as Debuf
	Globals.player.process_debuf(new_debuf)


func _on_trigger_combo_pressed():
	var combo = %Combos.get_selected_id()
	Events.combo_achieved.emit(combo)
