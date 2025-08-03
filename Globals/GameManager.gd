extends Node
const GAME = preload("res://Scenes/Game/Game.tscn")
const MAIN = preload("res://Scenes/Main/Main.tscn")

const npcc = preload("res://Scenes/NPC/Npc.tscn")
var progression: int = 1
var willingness: int = 100

const _1 = preload("res://Scenes/NPC/1.tscn")
const _2 = preload("res://Scenes/NPC/2.tscn")
const _3 = preload("res://Scenes/NPC/3.tscn")
const _4 = preload("res://Scenes/NPC/4.tscn")
const Ziss = preload("res://Scenes/NPC/zes.tscn")

var _current_npc: PackedScene 
var _scene_npc: NPC
var _show_z: bool = false

func _enter_tree() -> void:
	pass

func load_game() -> void: 
	get_tree().change_scene_to_packed(GAME)

func load_main() -> void: 
	get_tree().change_scene_to_packed(MAIN)
	
func progress_game() -> void: 
	# bro i was rushing so much like don't even look at this part
	progression += 1 
	
	if progression == 1: 
		_current_npc = null
	elif progression == 2:
		_current_npc = _1
	elif progression == 3: 
		_current_npc = _2
	elif progression == 4: 
		_current_npc = _3
	elif  progression == 5: 
		_current_npc = _4
	else: 
		_current_npc = null
		_show_z = true
		Signals.emit_on_show_zes(true)
	
	print(willingness)
	print(progression)


func set_willingness(number:int) -> void: 
	willingness = number

func start_dialog() -> void: 
	get_tree().paused = true 
	
func reset_npc() -> void: 
	_current_npc = npcc
	
	
