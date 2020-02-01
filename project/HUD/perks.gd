extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func change_health (health: int) :
	$HealthBar/Health.rect_size.x = health

func change_energy (energy: int) :
	$EnergyBar/Energy.rect_size.x = energy

func change_attack (attack: int) :
	$AttackBar/Attack.rect_size.x = attack

func change_shield (shield: int) :
	$ShieldBar/Shield.rect_size.x = shield
