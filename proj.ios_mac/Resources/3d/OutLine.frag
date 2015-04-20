varying vec4 shadow;
 
void main (void)
{
  if (shadow2DProj(texture, gl_TexCoord[0]).r != 0.0)
    gl_FragColor = gl_Color;
  else
    gl_FragColor = shadow;
}