extends BaseCharacter
class_name Player

signal player_attack
signal player_died

const DAMAGE_BOX_SCN = preload("res://Characters/Player/DamageBox.tscn")

export(float) var damage = 20
export(float) var dash_time = 0.15
export(float) var dash_length = 100
export(float) var dash_cooldown = 0.7
export(float) var resistance = 0

onready var can_dash = true
var dash_direction: Vector2
var dashing := false
var dash_speed: float = dash_length / dash_time

var buff_drop_rate = 10

var locator

onready var move_spd_buff_time = 100
onready var attack_buff_time = 100
onready var shield_buff_time = 100

var move_spd_buff_amount = 80
var attack_buff_amount = 100
var shield_buff_amount = 10

onready var buffed_speed = self.max_speed + move_spd_buff_amount
onready var normal_speed = self.max_speed

onready var buffed_attack = self.damage + attack_buff_amount
onready var normal_attack = self.damage

onready var buffed_resistance = self.resistance + shield_buff_amount
onready var normal_resistance = self.resistance

var state_machine
var look_angle: float = 0.0
var attacking := false
var resting := true
onready var is_invulnerable = false

func _ready():
	locator = Locator.new(get_tree())
	hud = locator.find_entity("HUD")
	$DashCooldown.wait_time = dash_cooldown
	state_machine = $AnimationTree.get("parameters/playback")
	change_health(-10)

func _physics_process(delta):
	if not attacking and not dashing:
		update_direction_from_input()

	update_look_angle()
	blink_if_invulnerable()
	handle_dash_input()
	handle_input()

	update_buffs(delta)
	
	if dashing:
		move_and_slide(dash_speed * dash_direction.normalized())

#Handle Input
func _input(event: InputEvent) -> void:
	# Left mouse button is clicked
	if event is InputEventMouseButton and event.button_index == 1 and $Sprite/AnimationPlayer.current_animation != "Reconstruct":
		if event.pressed and not dashing:
			emit_signal("player_attack")
			attacking = true
			direction = Vector2(0, 0)
			var damage_box = DAMAGE_BOX_SCN.instance()
			damage_box.init(self)
			var attack_angle = get_closest_cardinal_angle(self.look_angle)
			var attack_offset = Vector2(50,0).rotated(attack_angle)
			damage_box.position = self.position + $AttackOrigin.position + attack_offset
			get_parent().add_child(damage_box)
			if (attack_angle > 1.0):
				if (attack_angle > 2.0):
					state_machine.travel("Attack_Left")
				else:
					state_machine.travel("Attack_Downward")
			else:
				if (attack_angle < -0.5):
					state_machine.travel("Attack_Upward")
				else:
					state_machine.travel("Attack_Right")
			$Attack.play_sound_once()

func get_closest_cardinal_angle(angle):
	if angle >= -PI/4 and angle <= PI/4:
		return 0
	elif angle >= PI/4 and angle <= 3*PI/4:
		return PI/2
	elif angle >= 3*PI/4 or angle <= -3*PI/4:
		return PI
	elif angle >= -3*PI/4 and angle <= -PI/4:
		return -PI/2

func change_energy(amt):
	if(amt > 0): play_heal()
	move_spd_buff_time += amt
	hud.change_energy(move_spd_buff_time)
func change_attack(amt):
	if(amt > 0): play_heal()
	attack_buff_time += amt
	hud.change_attack(attack_buff_time)
func change_shield(amt):
	if(amt > 0): play_heal()
	shield_buff_time += amt
	hud.change_shield(shield_buff_time)
func change_health(amt):
	if(amt > 0): play_heal()
	health += amt
	hud.change_health(health)
	
func play_move_animation(direction, velocity):
	if (velocity != 0):
		if direction.x == 0 and direction.y < 0:
			state_machine.travel("Walk_Upward")
		elif direction.x == 0 and direction.y > 0:
			state_machine.travel("Walk_Downward")
		elif direction.x > 0 and direction.y == 0:
			state_machine.travel("Walk_Rightward")
		elif direction.x < 0 and direction.y == 0:
			state_machine.travel("Walk_Leftward")
		resting = false
	elif not attacking and not resting:
		state_machine.travel("Rest")
		resting = true
	
func play_heal():
	$Heal.play_sound_once()


func receive_damage(damage: int):
	if damage > 0 and !self.is_invulnerable:
		if not self.is_dead():
			$TakeDamage.play_sound_once()
			if shield_buff_time > 0:
				var final_dmg = max(0, damage - resistance)
				change_health(-final_dmg)
			else:
				change_health(-damage)

			emit_signal('hit', health)
		self.is_invulnerable = true
		$InvulnerabilityTimer.start()
		if(health < 0):
			var gameover = locator.find_entity('gameover')
			var sepia = locator.find_entity('sepia')
			gameover.show()
			sepia.show()

func update_direction_from_input():
	self.direction = Vector2(
		Input.get_action_strength('ui_right') - Input.get_action_strength("ui_left"),
		Input.get_action_strength('ui_down') - Input.get_action_strength("ui_up"))

func update_look_angle():
	var mouse_position = get_viewport().get_mouse_position()
	var player_position = self.get_global_transform_with_canvas().origin
	var look_vector = mouse_position - player_position
	look_angle = look_vector.angle()

func update_buffs(delta):
	var drop_rate = -delta*buff_drop_rate
	
	if move_spd_buff_time > 0:
		change_energy(drop_rate)
		self.max_speed = self.buffed_speed
	else:
		self.max_speed = self.normal_speed
		
	if attack_buff_time > 0:
		change_attack(drop_rate)
		self.damage = self.buffed_attack
	else:
		self.damage = self.normal_attack
		
	if shield_buff_time > 0:
		change_shield(drop_rate)
		self.resistance = self.buffed_resistance
	else:
		self.resistance = self.normal_resistance
	
func blink_if_invulnerable():
	if self.is_invulnerable:
		self.modulate.a = 0.4
	else:
		self.modulate.a = 1.0

func handle_input():
	if Input.is_action_pressed("fix"):
		if self.check_contact_to_fix():
			state_machine.travel("Reconstruct")
			
	if Input.is_action_just_pressed("interact"):
		self.check_contact_to_interact()
	
	if Input.is_action_just_released("fix"):
		state_machine.travel("Rest")
		
func handle_dash_input():
	if Input.is_action_just_pressed("ui_select") and not attacking and can_dash:
		if Input.is_action_pressed("ui_up") and !Input.is_action_pressed("ui_left") and !Input.is_action_pressed("ui_right"):
			dash_direction = Vector2(0,-1)
			$Sprite/AnimationPlayer.current_animation = "Dash_Upward"
			setup_dash()
		elif Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_left") and !Input.is_action_pressed("ui_right"):
			dash_direction = Vector2(-1,-1)
			$Sprite/AnimationPlayer.current_animation = "Dash_Left"
			setup_dash()
		elif !Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_left") and !Input.is_action_pressed("ui_down"):
			dash_direction = Vector2(-1,0)
			$Sprite/AnimationPlayer.current_animation = "Dash_Left"
			setup_dash()
		elif Input.is_action_pressed("ui_left") and Input.is_action_pressed("ui_down") and !Input.is_action_pressed("ui_right"):
			dash_direction = Vector2(-1,1)
			$Sprite/AnimationPlayer.current_animation = "Dash_Left"
			setup_dash()
		elif !Input.is_action_pressed("ui_left") and Input.is_action_pressed("ui_down") and !Input.is_action_pressed("ui_right"):
			dash_direction = Vector2(0,1)
			$Sprite/AnimationPlayer.current_animation = "Dash_Downward"
			setup_dash()
		elif !Input.is_action_pressed("ui_left") and Input.is_action_pressed("ui_down") and Input.is_action_pressed("ui_right"):
			dash_direction = Vector2(1,1)
			$Sprite/AnimationPlayer.current_animation = "Dash_Right"
			setup_dash()
		elif Input.is_action_pressed("ui_right") and !Input.is_action_pressed("ui_down") and !Input.is_action_pressed("ui_up"):
			dash_direction = Vector2(1,0)
			$Sprite/AnimationPlayer.current_animation = "Dash_Right"
			setup_dash()
		elif !Input.is_action_pressed("ui_left") and Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_right"):
			dash_direction = Vector2(1,-1)
			$Sprite/AnimationPlayer.current_animation = "Dash_Right"
			setup_dash()
		else:
			dash_direction = Vector2(0,1)
			$Sprite/AnimationPlayer.current_animation = "Dash_Downward"
			setup_dash()
		$Sprite/AnimationPlayer.play()
		$Dash.play_sound_once()
func setup_dash():
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
	
func check_contact_to_fix():
	if $FixCooldown.time_left <= 0:
		for area in $Area2D.get_overlapping_areas():
			if area.is_in_group("fixarea"):
				if area.get_parent().fix_building():
					$FixCooldown.start()
					return true
	return false
				
func check_contact_to_interact():
	for area in $Area2D.get_overlapping_areas():
		if area.is_in_group("interactarea"):
			area.get_parent().interact()
			break

func _on_Area2D_body_entered(_body):
	pass # Replace with function body.
