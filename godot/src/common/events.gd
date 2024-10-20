extends Node

signal bug_caught(bug: Bug)
signal tongue_attached(to: Vector2)
signal tongue_detached

signal debug_toggled(value:bool)

signal debuf_applied(debuf:Debuf)
#signal debuf_tick(debuf:Debuf)
signal debuf_cancelled(debuf:Debuf)

signal eagle_incoming
signal eagle_left
signal frog_grabbed
signal threat_on()
signal threat_off()

signal energy_depleted
signal reached_level_end()
signal game_lost()

signal combo_achieved(idx:int)

signal bug_freeze_toggle(val:bool)
signal block_max_hp(val:float)
