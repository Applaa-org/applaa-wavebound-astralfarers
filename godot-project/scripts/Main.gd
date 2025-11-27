extends Node2D

@onready var player1: CharacterBody2D = $Player1
@onready var player2: CharacterBody2D = $Player2
@onready var wave_shader: ColorRect = $WaveShader
@onready var ui_layer: CanvasLayer = $UILayer
@onready var score_label: Label = $UILayer/ScoreLabel
@onready var weather_label: Label = $UILayer/WeatherLabel

var islands: Array[Node2D] = []
var creatures: Array[Node2D] = []
var weather_timer: float = 0.0
var next_weather_change: float = 10.0

func _ready():
	Global.game_active = true
	
	# Connect global signals
	Global.seed_collected.connect(_on_seed_collected)
	Global.player_damaged.connect(_on_player_damaged)
	Global.weather_changed.connect(_on_weather_changed)
	
	# Spawn initial entities
	_spawn_islands()
	_spawn_creatures()
	
	# Initialize wave shader
	_setup_wave_shader()

func _process(delta):
	if not Global.game_active:
		return
	
	# Update weather system
	weather_timer += delta
	if weather_timer >= next_weather_change:
		_change_weather()
		weather_timer = 0.0
		next_weather_change = randf_range(8.0, 15.0)
	
	# Update UI
	_update_ui()

func _setup_wave_shader():
	var shader_material = ShaderMaterial.new()
	shader_material.shader = preload("res://scripts/WaveShader.gdshader")
	wave_shader.material = shader_material

func _spawn_islands():
	for i in range(5):
		var island = preload("res://scenes/Island.tscn").instantiate()
		island.position = Vector2(
			randf_range(100, 924),
			randf_range(100, 668)
		)
		add_child(island)
		islands.append(island)

func _spawn_creatures():
	for i in range(3):
		var creature = preload("res://scenes/Creature.tscn").instantiate()
		creature.position = Vector2(
			randf_range(100, 924),
			randf_range(100, 668)
		)
		add_child(creature)
		creatures.append(creature)

func _change_weather():
	var weather_types = ["calm", "solar_flares", "void_turbulence", "cosmic_winds"]
	Global.current_weather = weather_types.pick_random()
	Global.weather_changed.emit(Global.current_weather)

func _on_seed_collected(count: int):
	score_label.text = "Seeds: %d/20" % count

func _on_player_damaged(player_id: int, health: int):
	print("Player %d damaged! Health: %d" % [player_id, health])

func _on_weather_changed(weather_type: String):
	weather_label.text = "Weather: " + weather_type.replace("_", " ").capitalize()
	
	# Apply weather effects
	match weather_type:
		"solar_flares":
			_apply_solar_flares()
		"void_turbulence":
			_apply_void_turbulence()
		"cosmic_winds":
			_apply_cosmic_winds()
		_:
			_clear_weather_effects()

func _apply_solar_flares():
	# Add visual effect and damage over time
	wave_shader.modulate = Color(1.2, 0.8, 0.5, 1.0)

func _apply_void_turbulence():
	# Add screen shake and movement disruption
	wave_shader.modulate = Color(0.5, 0.2, 0.8, 1.0)

func _apply_cosmic_winds():
	# Add directional force to players
	wave_shader.modulate = Color(0.3, 0.8, 1.2, 1.0)

func _clear_weather_effects():
	wave_shader.modulate = Color.WHITE

func _update_ui():
	score_label.text = "Seeds: %d/20" % Global.total_seeds