extends Node


onready var new_enemies = []


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_new_enemies():
	var ne = new_enemies
	new_enemies.clear()
	return ne

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
