extends Node

var player_last_position: Vector2 = Vector2.ZERO 
var key_last_foundL: Vector2 = Vector2.ZERO 
var key_last_foundD: Vector2 = Vector2.ZERO
var Lkeys_found: int = 0
var Dkeys_found: int = 0
var last_world: String 
var collected_keys: Array = []

func collect_Lkey(position: Vector2, key_name): 
	Lkeys_found += 1
	key_last_foundL = position
	collected_keys.append(key_name)
	last_world="res://Hackaton-main/Scenes/underworld.tscn"
	print("key collected")

func collect_Dkey(position: Vector2, key_name): 
	Dkeys_found += 1
	key_last_foundD = position
	collected_keys.append(key_name)
	last_world="res://Hackaton-main/Scenes/overworld.tscn"
