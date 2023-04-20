extends CharacterBody2D

var heads = ["res://heads/861/861.tscn",
"res://heads/884/884.tscn",
"res://heads/866/866.tscn",
"res://heads/829/829.tscn",
"res://heads/844/844.tscn",
"res://heads/881/881.tscn",
"res://heads/819/819.tscn",
"res://heads/834/834.tscn",
"res://heads/856/856.tscn",
"res://heads/871/871.tscn",
"res://heads/814/814.tscn",
"res://heads/839/839.tscn",
"res://heads/889/889.tscn",
"res://heads/809/809.tscn",
"res://heads/876/876.tscn",
"res://heads/849/849.tscn",
"res://heads/824/824.tscn",
"res://heads/894/894.tscn",
"res://heads/905/905.tscn",
"res://heads/912/912.tscn"]

var bodies = ["res://bodies/605/605.tscn",
"res://bodies/621/621.tscn",
"res://bodies/631/631.tscn",
"res://bodies/650/650.tscn",
"res://bodies/673/673.tscn",
"res://bodies/627/627.tscn",
"res://bodies/642/642.tscn",
"res://bodies/658/658.tscn",
"res://bodies/677/677.tscn",
"res://bodies/615/615.tscn",
"res://bodies/666/666.tscn",
"res://bodies/609/609.tscn",
"res://bodies/648/648.tscn",
"res://bodies/662/662.tscn",
"res://bodies/668/668.tscn",
"res://bodies/654/654.tscn",
"res://bodies/635/635.tscn",
"res://bodies/681/681.tscn",
"res://bodies/900/900.tscn",
"res://bodies/907/907.tscn"]

var legs = ["res://legs/768/768.tscn",
"res://legs/689/689.tscn",
"res://legs/774/774.tscn",
"res://legs/780/780.tscn",
"res://legs/737/737.tscn",
"res://legs/724/724.tscn",
"res://legs/757/757.tscn",
"res://legs/764/764.tscn",
"res://legs/753/753.tscn",
"res://legs/745/745.tscn",
"res://legs/784/784.tscn",
"res://legs/731/731.tscn",
"res://legs/800/800.tscn",
"res://legs/715/715.tscn",
"res://legs/706/706.tscn",
"res://legs/698/698.tscn",
"res://legs/804/804.tscn",
"res://legs/898/898.tscn",
"res://legs/274/274.tscn"]

var colors = [
Vector3(0.93, 0.87, 0.8),
Vector3(0.46, 0.93, 0.78),
Vector3(0.88, 0.93, 0.93),
Vector3(0.93, 0.84, 0.72),
Vector3(0, 0, 0.93),
Vector3(0.93, 0.23, 0.23),
Vector3(0.56, 0.9, 0.93),
Vector3(0.46, 0.93, 0),
Vector3(0.93, 0.46, 0.13),
Vector3(0.93, 0.42, 0.31),
Vector3(0, 0.93, 0.93),
Vector3(0.93, 0.68, 0.05),
Vector3(0.74, 0.93, 0.41),
Vector3(0.7, 0.23, 0.93),
Vector3(0.71, 0.93, 0.71),
Vector3(0.93, 0.07, 0.54),
Vector3(0.93, 0.79, 0),
Vector3(0.88, 0.93, 0.88),
Vector3(0.93, 0.42, 0.65),
Vector3(0.93, 0.91, 0.91),
Vector3(1, 1, 1),
Vector3(0, 0, 0)
]

var headIndex = 0;
var bodyIndex = 0;
var legsIndex = 0;

var headColorIndex = 0;
var bodyColorIndex = 0;
var legsColorIndex = 0;

@export var speed: float = 125
var move_target: Vector2
var flipped = false
var moving = false

func _ready():
	move_target = position
	set_initial_scenes()

func _process(delta):
	pass

func _physics_process(_delta):
	velocity = position.direction_to(move_target) * speed
	var need_to_move = position.distance_to(move_target) > 10
	if  need_to_move:
		move_and_slide()
		if (position.x < move_target.x):
			if (flipped == false):
				self.apply_scale(Vector2(-1, 1))
				flipped = true
		else:
			if (flipped == true):
				self.apply_scale(Vector2(-1, 1))
				flipped = false
	update_moving_state(need_to_move)

func _input(event):
	if event.is_action_pressed("Click"):
		move_target = get_global_mouse_position()
	
	if event.is_action_pressed("NextHead"):
		headIndex = 0 if headIndex + 1 == heads.size() else headIndex + 1
		replace_scene($Head, heads[headIndex])
		change_color($Head, colors[headColorIndex])
		if moving:
			play_animation($Head)
	if event.is_action_pressed("NextBody"):
		bodyIndex = 0 if bodyIndex + 1 == bodies.size() else bodyIndex + 1
		replace_scene($Body, bodies[bodyIndex])
		change_color($Body, colors[bodyColorIndex])
	if event.is_action_pressed("NextLegs"):
		legsIndex = 0 if legsIndex + 1 == legs.size() else legsIndex + 1
		replace_scene($Legs, legs[legsIndex])
		change_color($Legs, colors[legsColorIndex])
		if moving:
			play_animation($Legs)
		
	if event.is_action_pressed("NextHeadColor"):
		headColorIndex = 0 if headColorIndex + 1 == colors.size() else headColorIndex + 1
		change_color($Head, colors[headColorIndex])
	if event.is_action_pressed("NextBodyColor"):
		bodyColorIndex = 0 if bodyColorIndex + 1 == colors.size() else bodyColorIndex + 1
		change_color($Body, colors[bodyColorIndex])
	if event.is_action_pressed("NextLegsColor"):
		legsColorIndex = 0 if legsColorIndex + 1 == colors.size() else legsColorIndex + 1
		change_color($Legs, colors[legsColorIndex])

func update_moving_state(new_state):
	if moving == new_state:
		return
	moving = new_state
	if moving:
		play_animations()
	else:
		stop_animations()

func set_initial_scenes():
	var random = RandomNumberGenerator.new()
	
	replace_scene($Head, random_item_in_array(random, heads))
	replace_scene($Body, random_item_in_array(random, bodies))
	replace_scene($Legs, random_item_in_array(random, legs))
	
	change_color($Head, random_item_in_array(random, colors))
	change_color($Body, random_item_in_array(random, colors))
	change_color($Legs, random_item_in_array(random, colors))

func random_item_in_array(random, array):
	return array[random.randi_range(0, array.size() - 1)]

func replace_scene(parent, path):
	var newScene = load(path).instantiate()
	var oldScene = parent.get_child(0)
	parent.add_child(newScene)
	parent.remove_child(oldScene)

func get_materials(node):
	var materials = []
	for child in node.get_children():
		var child_materials = get_materials(child)
		materials.append_array(child_materials)
		
		if child.get_class() == 'Sprite2D':
			if child.material:
				materials.append(child.material);
	return materials

func change_color(node, color):
	var all_materials = get_materials(node)
	for material in all_materials:
		material.set_shader_parameter('color', Vector4(color.x, color.y, color.z, 1));

func get_animation_player(node):
	for child in node.get_children():
		if child.get_class() == 'AnimationPlayer':
			return child
		var child_animation_player = get_animation_player(child)
		if (child_animation_player):
			return child_animation_player
	return null

func play_animations():
	play_animation($Head)
	play_animation($Legs)

func stop_animations():
	stop_animation($Head)
	stop_animation($Legs)

func play_animation(node):
	var animation_player = get_animation_player(node)
	if (animation_player):
		var animation_name = animation_player.get_animation_list()[0]
		animation_player.play(animation_name)

func stop_animation(node):
	var animation_player = get_animation_player(node)
	if (animation_player):
		animation_player.stop()
