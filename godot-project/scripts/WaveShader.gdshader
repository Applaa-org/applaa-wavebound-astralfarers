shader_type canvas_item;

uniform float time : hint_range(0, 10) = 0.0;
uniform vec2 resolution = vec2(1024.0, 768.0);

void fragment() {
	vec2 uv = FRAGCOORD.xy / resolution.xy;
	
	// Create wave pattern using noise
	float wave1 = sin(uv.x * 10.0 + time * 2.0) * 0.1;
	float wave2 = sin(uv.y * 8.0 - time * 1.5) * 0.1;
	float wave3 = sin((uv.x + uv.y) * 6.0 + time) * 0.05;
	
	float waves = wave1 + wave2 + wave3;
	
	// Create cosmic color gradient
	vec3 color1 = vec3(0.1, 0.05, 0.2);  // Deep space purple
	vec3 color2 = vec3(0.2, 0.1, 0.4);  // Nebula blue
	vec3 color3 = vec3(0.3, 0.15, 0.5); // Starlight
	
	float gradient = uv.y + waves * 0.5;
	vec3 final_color = mix(color1, color2, gradient);
	final_color = mix(final_color, color3, sin(time + uv.x * 3.0) * 0.5 + 0.5);
	
	// Add star particles
	float stars = step(0.998, sin(uv.x * 100.0) * sin(uv.y * 100.0));
	final_color += stars * 0.5;
	
	COLOR = vec4(final_color, 0.3);
}