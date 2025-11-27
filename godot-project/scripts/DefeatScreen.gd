extends Control

@onready var score_label: Label = $VBoxContainer/ScoreLabel

func _ready():
	$VBoxContainer/RestartButton.pressed.connect(_on_restart_pressed)
	$VBoxContainer/MainMenuButton.pressed.connect(_on_main_menu_pressed)
	$VBoxContainer/CloseButton.pressed.connect(_on_close_pressed)
	
	# Display final scores
	score_label.text = "Seeds Collected: %d/20" % Global.total_seeds
	
	# Style the UI
	var style_box = StyleBoxFlat.new()
	style_box.bg_color = Color(0.2, 0.1, 0.1, 0.9)
	style_box.border_width_left = 3
	style_box.border_width_right = 3
	style_box.border_width_top = 3
	style_box.border_width_bottom = 3
	style_box.border_color = Color(1.0, 0.2, 0.2, 0.8)
	style_box.corner_radius_top_left = 10
	style_box.corner_radius_top_right = 10
	style_box.corner_radius_bottom_left = 10
	style_box.corner_radius_bottom_right = 10
	
	$Panel.add_theme_stylebox_override("panel", style_box)

func _on_restart_pressed():
	Global.reset_game()
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_main_menu_pressed():
	Global.reset_game()
	get_tree().change_scene_to_file("res://scenes/StartScreen.tscn")

func _on_close_pressed():
	get_tree().quit()