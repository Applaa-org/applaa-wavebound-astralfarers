extends Node2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var area: Area2D = $Area2D
@onready var collision: CollisionShape2D = $Area2D/CollisionShape2D
@onready var seed_spawn: Marker2D = $SeedSpawn

var has_seed: bool = true
var float_offset: float = 0.0
var float_speed: float = 1.0

func _ready():
	area.body_entered.connect(_on_body_entered)
	
	# Randomize floating behavior
	float_speed = randf_range(0.5, 2.0)
	float_offset = randf() * PI * 2

func _process(delta):
	# Floating animation
	position.y += sin(Time.get_time_dict_from_system().second * float_speed + float_offset) * 0.5

func _on_body_entered(body):
	if has_seed and (body.name == "Player1" or body.name == "Player2"):
		_spawn_seed()
		has_seed = false

func _spawn_seed():
	var seed_instance = preload("res://scenes/AstralSeed.tscn").instantiate()
	seed_instance.position = seed_spawn.global_position
	get_parent().add_child(seed_instance)