//
// FRAGMENT PROGRAM FRAGMENT PROGRAM FRAGMENT PROGRAM FRAGMENT PROGRAM
//

//--------------------------------
// Structure
//--------------------------------

struct appdata 
{
    float3 Position     : POSITION;
    float3 Color        : COLOR;
};

struct vertexOutput
{
    float4 HPosition      : POSITION;
    float4 ScreenPosition : TEXCOORD6;
    float3 Color          : COLOR;
};


//--------------------------------
// Tweakables
//--------------------------------

float effectSize
<
    float uimin = 0;
    float uimax = 100;
> = 4;

float4 windowSize
<
> = float4(1,1,0,0);

samplerRECT inputTexture
<
>;

//--------------------------------
// Global
//--------------------------------

float4x4  wvp : WorldViewProjection;

//-----------------------------------------------------------------------------------------
//  Vertex Shader
//-----------------------------------------------------------------------------------------

vertexOutput SmoothVS(appdata IN,
                       uniform float4x4 iWorldViewProj) 
{
    vertexOutput OUT;

    // object coordinates
    //-------------------
    float4 position = float4( IN.Position.xyz, 1.0 );
    position = mul( iWorldViewProj, position );

    // screen clipspace coords
    //------------------------
    OUT.HPosition = position;
    OUT.ScreenPosition = position;

    OUT.Color = IN.Color;

    return OUT;
}

//-----------------------------------------------------------------------------------------
//  Pixel Shader
//-----------------------------------------------------------------------------------------

#define NUM_BLUR 12
#define INV_NUM_BLUR 0.08333334
float2 filterBlurData[NUM_BLUR]=
{
    {-0.326212f, -0.405805f},
    {-0.840144f, -0.07358f},
    {-0.695914f, 0.457137f},
    {-0.203345f, 0.620716f},
    {0.96234f,   -0.194983f},
    {0.473434f,  -0.480026f},
    {0.519456f, 0.767022f},
    {0.185461f, -0.893124f},
    {0.507431f, 0.064425f},
    {0.89642f,  0.412458f},
    {-0.32194f, -0.932615f},
    {0.791559f, -0.597705f}
};

float4 SmoothPS(vertexOutput IN,
                uniform float       iEffectSize,
                uniform samplerRECT iSmoothTexture,
                uniform float4      iWindowSize
                ) : COLOR 
{
    float4 result = float4(0,0,0,1); 

    float4 screenCoord = IN.ScreenPosition;
    screenCoord.xy = ((screenCoord.xy / screenCoord.w)+1) * iWindowSize.xy * 0.5 
                      + iWindowSize.zw;

    float k = iEffectSize;

    for(int i=0; i<NUM_BLUR; i++)
    {
        float2 coord = screenCoord.xy + k * filterBlurData[i];
        result += (texRECT(iSmoothTexture, coord));
    }

    result.xyz *= INV_NUM_BLUR;
    result.w = 1;

    return result;
}

//-----------------------------------------------------------------------------------------
//  Techniques
//-----------------------------------------------------------------------------------------

technique SmoothTexture_NV40
{
    pass p0 
    {		
        DepthTestEnable=true;
        DepthMask = true;
        DepthFunc = LEqual;
        LightingEnable = false;
        LightEnable[0] = false;
        LightEnable[1] = false;

        VertexProgram = compile vp40 SmoothVS( wvp);
        FragmentProgram = compile fp40 SmoothPS(effectSize, inputTexture, windowSize);
    }
}

technique SmoothTexture_NV30
{
    pass p0 
    {		
        DepthTestEnable=true;
        DepthMask = true;
        DepthFunc = LEqual;
        LightingEnable = false;
        LightEnable[0] = false;
        LightEnable[1] = false;

        VertexProgram = compile vp30 SmoothVS( wvp);
        FragmentProgram = compile fp30 SmoothPS(effectSize, inputTexture, windowSize);
    }
}

technique SmoothTexture_ARB
{
    pass p0 
    {		
        DepthTestEnable=true;
        DepthMask = true;
        DepthFunc = LEqual;
        LightingEnable = false;
        LightEnable[0] = false;
        LightEnable[1] = false;

        VertexProgram = compile arbvp1 SmoothVS( wvp);
        FragmentProgram = compile arbfp1 SmoothPS(effectSize, inputTexture, windowSize);
    }
}


