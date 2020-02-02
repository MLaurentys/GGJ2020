extends BaseCharacter

#warning-ignore:unused_class_variable
#warning-ignore:unused_class_variable
export var min_attack_range : float = 0
export var max_attack_range : float = 100
export var stagger_duration : float = 0.0

export(float) var damage = 20

#onready var impact_sounds = $ImpactSounds
onready var locator = Locator.new(get_tree())
#warning-ignore:unused_class_variable
onready var player = locator.find_entity("player")

signal die

var attacking = false
var staggering = 0


export var windup_duration = 0.5
export var attack_duration = 1.0

var dive = null
#func _ready():
	#var wave_manager = locator.find_entity('wave_manager')
	#self.connect('die', wave_manager, 'count_enemy_deaths')

func is_staggering():
	return self.staggering > 0

func _physics_process(delta: float) -> void:
	self.staggering = max(0, self.staggering - delta)
	if not self.is_dead() and not self.attacking and not self.is_staggering():
		if $Tracker.is_within_range(self):
			self.attacking = true
			self.direction = Vector2()
			self.attack($Tracker.track())
		else:
			self.direction = $Tracker.track()
	elif self.is_dead() or self.is_staggering():
		self.direction = Vector2()

	self.check_contact()
	
	if self.dive != null:
		self.direction = self.dive

func _process(_delta):
	if self.stagger_duration > 0:
		$ProgressBar.modulate = Color(1, 1, 1, 1) * (1 + 5 * self.staggering / self.stagger_duration)

func receive_damage(damage_amount: int, origin, attack_phase: int = 0):
	if !self.is_dead():
		.receive_damage(damage_amount, origin.position)
		
		#if attack_phase == 0:
			#impact_sounds.get_node("Strong/Impact0").play()
		#else:
			#impact_sounds.get_node("Weak").get_child(randi()%2).play()
		
		if self.is_dead():
			emit_signal('die')
			if self.has_node("Sprite") and $Sprite.has_method("die"):
				self.collision_layer = 0
				self.collision_mask = 0
				$Sprite.die()
				yield($Sprite, "death_ended")
				self.queue_free()
			else:
				self.queue_free()
		else:
			self.stop_attack()
			self.staggering = self.stagger_duration

func end_attack():
	self.attacking = false

#warning-ignore:unused_argument
func attack(direction):
	yield(get_tree().create_timer(self.windup_duration), "timeout")
	self.dive = direction
	yield(get_tree().create_timer(self.attack_duration), "timeout")
	self.dive = null
	self.end_attack()

func stop_attack():
	self.end_attack()

func check_contact():
	if $DamageCooldown.time_left <= 0:
		for area in $Area2D.get_overlapping_areas():
			if area.is_in_group("player"):
				var damage_vector: Vector2 = (area.position - self.position).normalized()
				print("aqui neh?")
				area.get_parent().receive_damage(self.damage, damage_vector)
				$DamageCooldown.start()
				break
