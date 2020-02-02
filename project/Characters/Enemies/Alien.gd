extends BaseCharacter

class_name alien
#warning-ignore:unused_class_variable
#warning-ignore:unused_class_variable
export var min_attack_range : float = 0
export var max_attack_range : float = 100
export var stagger_duration : float = 0.5

export(float) var damage = 20

#onready var impact_sounds = $ImpactSounds
onready var locator = Locator.new(get_tree())
#warning-ignore:unused_class_variable
onready var player = locator.find_entity("player")
signal die

var target

var attacking = false
var staggering = 0
var toDel = false

export var windup_duration = 0.5
export var attack_duration = 1.0

var dive = null
func _ready():
	target = player
	hud = $HealthBar
	#var wave_manager = locator.find_entity('wave_manager')
	#self.connect('die', wave_manager, 'count_enemy_deaths')

func is_staggering():
	return self.staggering > 0

func _physics_process(delta: float) -> void:
	if(toDel):
		pass
	self.staggering = max(0, self.staggering - delta)
	if not self.is_dead() and not self.attacking and not self.is_staggering():
		if is_within_range():
			self.attacking = true
			attack()
	elif self.is_dead() or self.is_staggering():
		self.direction = Vector2()

	self.check_contact()
	
	if self.dive != null:
		self.direction = self.dive

func _process(_delta):
	track()
	if self.stagger_duration > 0:
		$HealthBar.modulate = Color(1, 1, 1, 1) * (1 + 5 * self.staggering / self.stagger_duration)

func receive_damage(damage_amount: int):
	if !self.is_dead():
		health += -damage_amount
		$HealthBar/Health.rect_size.x = health
		if self.is_dead():
			emit_signal('die')
			if self.has_node("Sprite") and $Sprite.has_method("die"):
				self.collision_layer = 0
				self.collision_mask = 0
				$Sprite.die()
				yield($Sprite, "death_ended")
				toDel = true
			else:
				toDel = true				
		else:
			self.stop_attack()
			self.staggering = self.stagger_duration

func end_attack():
	self.attacking = false

#warning-ignore:unused_argument
func attack():
	yield(get_tree().create_timer(self.windup_duration), "timeout")
	self.dive = direction
	yield(get_tree().create_timer(self.attack_duration), "timeout")
	self.dive = null
	self.end_attack()

func stop_attack():
	self.end_attack()

func change_target():
	get_new_target()

func check_contact():
	if $DamageCooldown.time_left <= 0:
		var areas = $Area2D.get_overlapping_areas()
		var imps = []
		for a in areas:
			if not a.is_in_group("enemy"):
				imps.append(a)
		for area in imps:
			if area.is_in_group("fixarea"):
				area.get_parent().get_attacked(self.damage/10.0)
				$DamageCooldown.start()
				break
			if area.is_in_group("player"):
				#var damage_vector: Vector2 = (area.position - self.position).normalized()
				area.get_parent().receive_damage(self.damage)
				$DamageCooldown.start()
				break

				
export(float) var amplitude = 0
export(float) var period = 0.3


var running = false
var deviation := 0.0


func is_within_range() -> bool:
	if target == null:
		return false
	var target_position = target.position
	var enemy_position = position
	var enemy_min_range = min_attack_range
	var enemy_max_range = max_attack_range
	var dist = target_position - enemy_position
	
	self.running = false
	if dist.length() > enemy_max_range:
		return false
	elif self.direction.length() < enemy_min_range:
		self.running = true
		return false
	
	return true

func track():
	direction = (target.position - position).normalized()

func get_new_target():
	var spos = position
	var buildings = get_tree().get_nodes_in_group("buildings")
	var dist = player.position.distance_squared_to(spos)
	var newt = player
	for b in buildings:
		var nd = b.position.distance_squared_to(spos)
		if(nd < dist):
			dist = nd
			newt = b
	target = newt
	
