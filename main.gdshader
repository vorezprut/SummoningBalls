shader_type canvas_item;
render_mode blend_mix;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void fragment(){
  vec4 c = texture(screen_texture, SCREEN_UV);
  c *= 35.0;
  c = vec4( round(c.r), round(c.r)/4.0, round(c.r)/8.0, c.a);
  c /= 35.0;
  COLOR = c;
}
