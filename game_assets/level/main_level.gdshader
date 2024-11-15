shader_type canvas_item;

uniform sampler2D noise_img;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	COLOR.rgb = texture(noise_img, UV).rgb;
	COLOR.a = 0.3;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
