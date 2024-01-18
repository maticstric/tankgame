extends CharacterBody2D

# https://kidscancode.org/godot_recipes/4.x/2d/topdown_movement/index.html

const speed = 400  # Move speed in pixels/sec
const rotation_speed = 1.5  # Turning speed in radians/sec

func _physics_process(delta):
	var move_input = Input.get_axis("down", "up")
	var rotation_direction = Input.get_axis("left", "right")
	
	velocity = transform.x * move_input * speed
	rotation += rotation_direction * rotation_speed * delta
	move_and_slide()
