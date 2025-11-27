extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var area: Area2D = $Area2D
@onready var area_collision: CollisionShape2D = $Area2D/CollisionShape2D

const SPEED: float = 80.0
var health: int = 50
var patrol_direction: Vector2 = Vector2.ZERO
var patrol_timer: float = 0.0
var damage_cooldown: float = 0.0

func _ready():
	# Set random patrol direction
	patrol_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	area.body_entered.connect(_on_body_entered)
	
	# Set creature color (red/orange)
	sprite.modulate = Color(1.0, 0.4, 0.2)

func _physics_process(delta):
	if not Global.game_active:
		return
	
	# Handle damage cooldown
	if damage_cooldown > 0:
		damage_cooldown -= delta
	
	# Patrol behavior
	patrol_timer += delta
	if patrol_timer >= 3.0:
		patrol_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
		patrol_timer = 0.0
	
	# Apply movement
	velocity = patrol_direction * SPEED
	move_and_slide()
	
	# Bounce off walls
	if is_on_wall():
		patrol_direction = -patrol_direction
	
	# Keep in bounds
	position.x = clamp(position.x, 50, 974)
	position.y = clamp(position.y, 50, 718)

func _on_body_entered(body):
	if damage_cooldown <= 0 and (body.name == "Player1" or body.name == "Player2"):
		body.take_damage(20)
		damage_cooldown = 2.0
		
		# Knockback
		var knockback_direction = (body.position - position).normalized()
		body.velocity = knockback_direction * 200