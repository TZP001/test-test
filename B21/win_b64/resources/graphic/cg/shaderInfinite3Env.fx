//////  TWEAKABLES /////////////////////////////////////////////

// positionnement 

float4 Ground 
<
> = float4(0,0,1,0);

float SkyLineRatio
<
> = float(1);

// couleur

float4 ColSky 
<
> = float4(0,0,1,1);

float4 ColSkyMin 
<
> = float4(1,1,1,1);

float SkyIntensity
<
> = float(1);

//////  UNTWEAKABLES /////////////////////////////////////////////

float4x4  wvp                    : WorldViewProjection;
float4x4  world                  : World;
float4x4  viewIT                 : ViewIT;

struct appdata 
{
    float3 Position         : POSITION;
};

struct vertexOutput2 
{
    float4 HPosition        : POSITION;
    float3 Position			: TEXCOORD5;
};

//------------------------------------------
//  Vertex Shader
//------------------------------------------

vertexOutput2 GraphicMaterialVS( appdata IN,
                                uniform float4x4 iWorldViewProj) 
{
    vertexOutput2 OUT;
    
    OUT.Position = IN.Position;

    // screen clipspace coords
    //------------------------
    float4 position = float4( IN.Position.xyz, 1.0 );
    float4 screenPosition= mul( iWorldViewProj, position );
    OUT.HPosition = screenPosition;

    return OUT;
}

//------------------------------------------
//  Pixel Shader
//------------------------------------------

float4 GraphicMaterialPS( vertexOutput2 IN,
						 uniform float4x4 iWorld, 
                         uniform float4x4 iViewIT,
                         uniform float4 Ground, 
                         uniform float	SkyLineRatio,
                         uniform float4 ColSky,
                         uniform float4 ColSkyMin,
                         uniform float  SkyIntensity): COLOR 
{
    float4 result;

    float4 position = float4(IN.Position.xyz, 1.0);
    float3 Pw = mul( iWorld, position).xyz;
    float3 n = -normalize(iViewIT[3].xyz - Pw );
    
	float scaleGround = -dot(n, Ground)*SkyLineRatio;

    //result.a = 1;

    //----------------------
    // Ciel degrade

	result = lerp(ColSkyMin, ColSky, saturate(scaleGround));
	result.xyz *= result.xyz;
	result.xyz *= result.xyz * SkyIntensity;
		
    return result;
}

////////////////////////////////////////////////////////////////////
/// TECHNIQUES /////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
technique GraphicMaterial_NV40
{
    pass p0 
    {
        VertexProgram = compile vp40 GraphicMaterialVS(wvp);
        FragmentProgram = compile fp40 GraphicMaterialPS(world ,  viewIT, 
                                                        Ground, SkyLineRatio,
                                                        ColSky, ColSkyMin, SkyIntensity);
    }
}

technique GraphicMaterial_NV30
{
    pass p0 
    {
        VertexProgram = compile vp30 GraphicMaterialVS(wvp);
        FragmentProgram = compile fp30 GraphicMaterialPS(world ,  viewIT,
                                                        Ground, SkyLineRatio,
                                                        ColSky, ColSkyMin, SkyIntensity);
    }
}

technique GraphicMaterial_arb
{
    pass p0 
    {
        VertexProgram = compile arbvp1 GraphicMaterialVS(wvp);
        FragmentProgram = compile arbfp1 GraphicMaterialPS(world ,  viewIT,
                                                        Ground, SkyLineRatio,
                                                        ColSky, ColSkyMin, SkyIntensity);
    }
}
