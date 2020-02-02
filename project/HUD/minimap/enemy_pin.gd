extends Node2D

onready var already_dead = false
var enemy
var pos

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func set_enemy(enmy):
	enemy = enmy
	
func _process(delta):
	pass
