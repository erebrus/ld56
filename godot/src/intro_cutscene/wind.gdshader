shader_type canvas_item;
uniform float speed = 2.0;
uniform float strength = 20.0;

void vertex() {
	VERTEX.x += sin(TIME * speed) * strength * (UV.y-1.0);
}

