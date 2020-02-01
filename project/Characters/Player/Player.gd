extends BaseCharacter
class_name Player

export(float) var dash_time = 0.15
export(float) var dash_length = 100
export(float) var dash_cooldown = 0.7

#var look_angle: float = 0.0
var attacking := false

onready var can_dash = true
var dash_direction: Vector2
var dashing := false
var dash_speed: float = dash_length / dash_time
onready var is_invulnerable = false

func _ready():
	var locator = Locator.new(get_tree())
	#var player = locator.find_entity("player")
	$DashCooldown.wait_time = dash_cooldown

func _physics_process(_delta):
	if not attacking and not dashing:
		update_direction_from_input()

	#update_look_angle()

	if self.is_invulnerable:
		self.modulate.a = 0.4
	else:
		self.modulate.a = 1.0

	if Input.is_action_just_pressed("ui_select") and not attacking and can_dash:
		if Input.is_action_pressed("ui_up") and !Input.is_action_pressed("ui_left") and !Input.is_action_pressed("ui_right"):
			dash_direction = Vector2(0,-1)
			dash()
		elif Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_left") and !Input.is_action_pressed("ui_right"):
			dash_direction = Vector2(-1,-1)
			dash()
		elif !Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_left") and !Input.is_action_pressed("ui_down"):
			dash_direction = Vector2(-1,0)
			dash()
		elif Input.is_action_pressed("ui_left") and Input.is_action_pressed("ui_down") and !Input.is_action_pressed("ui_right"):
			dash_direction = Vector2(-1,1)
			dash()
		elif !Input.is_action_pressed("ui_left") and Input.is_action_pressed("ui_down") and !Input.is_action_pressed("ui_right"):
			dash_direction = Vector2(0,1)
			dash()
		elif !Input.is_action_pressed("ui_left") and Input.is_action_pressed("ui_down") and Input.is_action_pressed("ui_right"):
			dash_direction = Vector2(1,1)
			dash()
		elif Input.is_action_pressed("ui_right") and !Input.is_action_pressed("ui_down") and !Input.is_action_pressed("ui_up"):
			dash_direction = Vector2(1,0)
			dash()
		elif !Input.is_action_pressed("ui_left") and Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_right"):
			dash_direction = Vector2(1,-1)
			dash()
		else:
			dash_direction = Vector2(0,1)
			dash()

	if dashing:
		move_and_slide(dash_speed * dash_direction.normalized())

	if self.is_dead():
#    emit_signal("player_died")
		get_tree().paused = true

#func _input(event: InputEvent) -> void:
#  if event is InputEventMouseButton:
#    if event.pressed and not dashing:
#      emit_signal("player_attack")
#      attacking = true
#      direction = Vector2(0, 0)
#      if casting_pact:
#        # Display the casting animation
#        $Sprite.display_casting_animation(Vector2(1, 0).rotated(look_angle))
#      else:
#        # Perform a basic attack
#        var damage_box = DAMAGE_BOX_SCN.instance()
#        damage_box.player = self
#        var attack_angle = get_closest_cardinal_angle(self.look_angle)
#        var attack_offset = Vector2(50,0).rotated(attack_angle)
#        damage_box.position = self.position + $AttackOrigin.position + attack_offset
#        get_parent().add_child(damage_box)
#        $Sprite.strike(attack_offset)

#func receive_damage(damage: int, vector: Vector2, attack_phase: int = 0):
#  if damage > 0 and !self.is_invulnerable:
#    .receive_damage(damage, vector, attack_phase)
#    $Sprite/SFXDamageSound.get_child(randi()%2).play()
#    
#    self.is_invulnerable = true
#    $InvulnerabilityTimer.start()

func update_direction_from_input():
	self.direction = Vector2(
		Input.get_action_strength('ui_right') - Input.get_action_strength("ui_left"),
		Input.get_action_strength('ui_down') - Input.get_action_strength("ui_up"))

#func update_look_angle():
#  var mouse_position = get_viewport().get_mouse_position()
#  var player_position = self.get_global_transform_with_canvas().origin
#  var look_vector = mouse_position - player_position
#  look_angle = look_vector.angle()

func dash():
	#$Sprite/SFXDash.pitch_scale = randf() + 1.0
	#$Sprite/SFXDash.play()
	dashing = true
	self.is_invulnerable = true
	can_dash = false
	self.block_movement = true
	#set_collision_layer(0)
	#set_collision_mask(4)
	$DashTimer.wait_time = dash_time
	$DashTimer.start()

func stop_dash():
	can_dash = false
	dashing = false
	self.is_invulnerable = false
	self.block_movement = false
	set_collision_layer(1)
	set_collision_mask(7)
	yield(get_tree().create_timer(self.dash_cooldown), "timeout")
	can_dash = true

func _on_InvulnerabilityTimer_timeout():
	self.is_invulnerable = false
