shader_type spatial;

uniform vec3 color : source_color;

render_mode cull_disabled;

void vertex() {
	VERTEX.z += (NORMAL * sin(3.0*(TIME + VERTEX.x))).x;
	VERTEX.z = clamp(VERTEX.z, -1, 0.5);
}

void fragment(){
	ALBEDO = color;
}