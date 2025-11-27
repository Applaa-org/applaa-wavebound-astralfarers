extends Area2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var particles: CPUParticles2D = $CPUParticles2D

var collected: bool = false
var rotation_speed: float = 2.0

func _ready():
	body_entered.connect(_on_body_entered)

func _process(delta):
	# Rotate and float
	rotation += rotation_speed * delta
	position.y += sin(Time.get_time_dict_from_system().second * 2.0) * 0.3

func _on_body_entered(body):
	if not collected and (body.name == "Player1" or body.name == "Player2"):
		collected = true
		_collect()

func _collect():
	Global.collect_seed()
	
	# Create collection effect
	particles.emitting = true
	sprite.visible = false
	
	# Play collection sound (if available)
	
	# Remove after effect
	await get_tree().create_timer(1.0).timeout
	queue_free()