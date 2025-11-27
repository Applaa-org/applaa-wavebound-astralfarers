extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var trail: CPUParticles2D = $Trail

const SPEED: float = 150.0
const BOOST_SPEED: float = 250.0
var health: int = 100
var player_id: int = 2
var boost_cooldown: float = 0.0

func _ready():
	# Set player color (purple for player 2)
	sprite.modulate = Color(0.8, 0.3, 1.0)
	trail.modulate = sprite.modulate

func _physics_process(delta):
	if not Global.game_active:
		return
	
	# Handle boost cooldown
	if boost_cooldown > 0:
		boost_cooldown -= delta
	
	# Get input (Arrow keys for player 2)
	var direction = Vector2.ZERO
	if Input.is_key_pressed(KEY_UP):
		direction.y -= 1
	if Input.is_key_pressed(KEY_DOWN):
		direction.y += 1
	if Input.is_key_pressed(KEY_LEFT):
		direction.x -= 1
	if Input.is_key_pressed(KEY_RIGHT):
		direction.x += 1
	
	# Apply weather effects
	var current_speed = SPEED
	if Global.current_weather == "cosmic_winds":
		direction.x += 0.3  # Wind pushes right
	elif Global.current_weather == "void_turbulence":
		direction += Vector2(randf_range(-0.2, 0.2), randf_range(-0.2, 0.2))
	
	# Handle boost
	if Input.is_key_pressed(KEY_RSHIFT) and boost_cooldown <= 0:
		current_speed = BOOST_SPEED
		boost_cooldown = 2.0
		trail.emitting = true
	else:
		trail.emitting = false
	
	# Apply movement
	if direction.length() > 0:
		velocity = direction.normalized() * current_speed
		# Rotate sprite to face movement direction
		sprite.rotation = velocity.angle() + PI/2
	else:
		velocity = velocity.move_toward(Vector2.ZERO, current_speed * 0.1)
	
	move_and_slide()
	
	# Keep player in bounds
	position.x = clamp(position.x, 50, 974)
	position.y = clamp(position.y, 50, 718)

func take_damage(damage: int):
	health -= damage
	Global.damage_player(player_id, health)
	
	if health <= 0:
		Global.defeat()
	
	# Flash effect
	sprite.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = Color(0.8, 0.3, 1.0)