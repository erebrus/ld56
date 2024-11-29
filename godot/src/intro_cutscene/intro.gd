extends Node2D

@export var small_tree_material: ShaderMaterial
@export var big_tree_material: ShaderMaterial
@export var reed_material: ShaderMaterial

@export var wind: float = 0:
	set(value):
		wind = value
		small_tree_material.set_shader_parameter("extra", wind * 0.2)
		big_tree_material.set_shader_parameter("extra", wind * 0.5)
		reed_material.set_shader_parameter("extra", wind)

@export var shakiness: float = 2:
	set(value):
		shakiness = value
		small_tree_material.set_shader_parameter("speed", shakiness)
		big_tree_material.set_shader_parameter("speed", shakiness)
		reed_material.set_shader_parameter("speed", shakiness)

@export var strength: float = 10:
	set(value):
		strength = value
		small_tree_material.set_shader_parameter("strength", strength * 0.2)
		big_tree_material.set_shader_parameter("strength", strength * 0.5)
		reed_material.set_shader_parameter("strength", strength)
