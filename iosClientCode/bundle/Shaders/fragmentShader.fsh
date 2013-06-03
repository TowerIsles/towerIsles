uniform sampler2D uSampler;

varying lowp vec2 vTexCoord;

varying lowp vec4 colorVarying;

void main()
{
    lowp vec4 texCol = texture2D(uSampler, vTexCoord); 
    
    gl_FragColor = vec4(texCol.rgb, 1.0);
//    gl_FragColor = vec4(1,1,1,1);
//    gl_FragColor = colorVarying;
}
