extends Node2D
@onready var warning: Control = $UI/MC/Warning
@onready var game_over: Control = $UI/MC/GameOver
const SYPHUS = preload("res://Scenes/Syphus/Syphus.tscn")

var _progression: int = 1
@onready var player_boundary: StaticBody2D = $PlayerBoundary
@onready var progression_scene: Node2D = $ProgressionScene
@onready var status: StatusUI = $UI/MC/Status
@onready var npc_marker: Marker2D = $NPCMarker
@onready var zeus_container: Node2D = $ZeusContainer


const npc_base = preload("res://Scenes/NPC/Npc.tscn")
const tutorial_guy = preload("res://Scenes/NPC/1.tscn")
const ZES = preload("res://Scenes/NPC/zes.tscn")

const NPCS: Dictionary = {
	
}
@onready var npc_group: Node2D = $NPCGroup
@onready var zes_marker: Marker2D = $ZesMarker

var _npc_ref: NPC
var _Syphus_ref: Syphus
var _rock_ref: Rock
var _current_npc: NPC
var _zeus: Zes

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"): 
		GameManager.load_main()
func _enter_tree() -> void:
	
	Signals.on_rock_off_screen.connect(on_rock_off_screen)
	Signals.on_syphus_no_will.connect(on_syphus_no_will)
	Signals.on_progress_game.connect(on_progress_game)
	Signals.on_game_over.connect(on_game_over)
	Signals.on_enter_dialog.connect(on_enter_dialog)
	Signals.on_show_zes.connect(show_z)
	
func on_enter_dialog(npc: NPC) -> void: 
	pass
	


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GameManager._show_z: 
		show_z(true)
		
		
	if GameManager._current_npc: 
		_current_npc = GameManager._current_npc.instantiate()
		
		npc_group.add_child(_current_npc)
		GameManager._scene_npc = _current_npc
	else:
		"no current npc"
	

	# initialize
	_Syphus_ref = get_tree().get_first_node_in_group(Syphus.SYPHUS_GROUP)
	_npc_ref = get_tree().get_first_node_in_group(NPC.NPC_GROUP)
	_rock_ref = get_tree().get_first_node_in_group(Rock.ROCK_GROUP)
	if _current_npc:
		_current_npc.global_position = npc_marker.global_position
	print(_Syphus_ref, _npc_ref, _rock_ref)
	_progression = GameManager.progression


func on_rock_off_screen() -> void: 
	warning.show()
	on_game_over()
	
func on_syphus_no_will(will: bool)-> void:

	#player_boundary.collision_layer = 0
	if !will: 
		print('syphus no will')
		GameManager.progression = 1
		GameManager._show_z = false 
		show_z(false)
		GameManager.reset_npc()
		GameManager.willingness = 100
	
		await get_tree().create_timer(4).timeout
		show_game_over()
		await get_tree().create_timer(4).timeout
		on_game_over()
		#Signals.emit_on_syphus_no_will(true)
	


	
	
func reinstante_npc() -> void: 
	pass
	
func show_z(toggle:bool) -> void: 
	if toggle: 
		print('show z func called')
		_zeus = ZES.instantiate()
		zeus_container.add_child(_zeus)
		_zeus.global_position = zes_marker.global_position
		
	if !toggle and _zeus: 
		_zeus.queue_free()
	
		
	 
func on_progress_game() -> void:
	
	print(GameManager.progression)
	show_z(GameManager._show_z)
	status.hide()
	progression_scene.show()
	await get_tree().create_timer(1).timeout
	progression_scene.hide()
	status.show()
	call_deferred("_progress_game_late")
	

func _progress_game_late() -> void:
	_redo_current_level()
	GameManager.progress_game()
	
func show_game_over() -> void: 
	game_over.show()
	print('out of frame syphus')
	
func _redo_current_level() -> void: 
	status.show()
	get_tree().reload_current_scene()
	
func on_game_over() -> void:
	await get_tree().create_timer(1).timeout 
	call_deferred("_redo_current_level")


		

#func let_user_slide() -> void: 
	#Signals.em
