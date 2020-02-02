extends KinematicBody2D
class_name BaseCharacter

signal hit(damage)

const SPEED_EPSILON: float = 2e-5

#export(float) var damage = 20
export(float) var acceleration := 100.0
export(float) var max_speed: float
export(int) var max_health: int

var hud
var health: int
var direction: Vector2 = Vector2() setget set_direction
var velocity: float = 0

var block_movement : bool = false

func set_health(value):
  health = value
  emit_signal("hit", value)

func _ready():
	var locator = Locator.new(get_tree())
	hud = locator.find_entity("HUD")
	self.health = max_health

func _physics_process(_delta) -> void:
	if not block_movement:
		accelerate()
		var movement = self.direction * self.velocity
		var remaining_movement = move_and_slide(movement)
		self.direction = remaining_movement
		self.velocity = remaining_movement.length()
		deaccelerate()
		#if has_node("Sprite") and $Sprite is CreatureSpriteBase:$Sprite.move(movement)

func accelerate() -> void:
	if self.direction.length_squared() > 0:
		self.velocity += acceleration
	limit_velocity()

func limit_velocity() -> void:
	self.velocity = clamp(self.velocity, 0, self.max_speed)

func deaccelerate() -> void:
	if self.velocity > SPEED_EPSILON:
		var frames_until_stop = 5
		self.velocity -= self.max_speed * (1 / frames_until_stop)
	stop_if_too_slow()

func stop_if_too_slow() -> void:
	if self.velocity <= SPEED_EPSILON:
		self.velocity = 0

func is_dead() -> bool:
	return health <= 0

func set_direction(vector) -> void:
	direction = vector.normalized()

func change_health(amt :int):
	health += amt
	hud.change_health(health)
	
func receive_damage(damage: int, _origin: Vector2, _attack_phase: int = 0):
	if not self.is_dead():
		change_health(-damage)
		#health -= damage
		emit_signal('hit', health)
