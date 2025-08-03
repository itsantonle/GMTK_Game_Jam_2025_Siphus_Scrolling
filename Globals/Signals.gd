extends Node

signal on_rock_off_screen
signal on_syphus_no_will(will:bool)
signal on_syphus_out_frame
signal on_progress_game
signal on_rock_getting_lost(lost: bool)
signal on_game_over
signal on_will_bar_change(percent: float)
signal on_number_bar_change()
signal on_enter_dialog(npc: NPC) 
signal on_show_zes(toggle:bool)






func emit_on_rock_off_screen() -> void: 
	on_rock_off_screen.emit()
	
func emit_on_syphus_no_will(will: bool)-> void: 

	on_syphus_no_will.emit(will)

func emit_on_progress_game() -> void: 
	on_progress_game.emit()

func emit_on_rock_getting_lost(lost:bool) -> void: 
	on_rock_getting_lost.emit(lost)

func emit_on_game_over() -> void: 
	on_game_over.emit()
	
func emit_on_syphus_out_frame() -> void: 
	on_syphus_out_frame.emit()

func emit_on_will_bar_change(percent: float) -> void: 
	on_will_bar_change.emit(percent)

func emit_on_number_bar_change() -> void: 
	on_number_bar_change.emit()

func emit_on_enter_dialog() -> void: 
	on_enter_dialog.emit()
	
func emit_on_show_zes(toggle:bool): 
	on_show_zes.emit(toggle)
