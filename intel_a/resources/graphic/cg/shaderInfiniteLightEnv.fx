//////  TWEAKABLES /////////////////////////////////////////////

// positionnement 

float4 SolDir 
<
> = float4(0,1,-0.2,0);

float4 SolSize
<
> = float4(0.95, 0.998, 0,0);

float4 Ground 
<
> = float4(0,0,1,0);

// couleur

float4 ColSol
<
> = float4(1,1,1,1);

float4 ColHalo 
<
> = float4(1,1,0.8,1);



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
                                uniform float4x4 iWorldViewProj
                                ) 
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
                         uniform float4 SolDir, 
                         uniform float4 SolSize, 
                         uniform float4 Ground , 
                         uniform float4 ColSol, 
                         uniform float4 ColHalo): COLOR 
{
    float4 result = float4(1,1,1,0);

    float4 position = float4( IN.Position.xyz, 1.0 );
    float3 Pw = mul( iWorld, position).xyz;
    float3 n = -normalize( iViewIT[3].xyz - Pw );
    
    //----------------------
    // Soleil

    float scaleSol = -dot(n, SolDir);
    
    if (scaleSol>SolSize.x)
    {
		if (scaleSol<SolSize.y)
        {
			// Halo
			scaleSol = (scaleSol-SolSize.x)/(SolSize.y - SolSize.x);
            scaleSol = 1 - pow(scaleSol,5);
            result.a = 0;
            result.xyz = ColHalo.xyz;
            result.a = ColHalo.a * (1.0-scaleSol);
        }
        else
        {
			// sun
			result = ColSol; 
        }
    }

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
													    SolDir, SolSize, 
                                                        Ground, 
                                                        ColSol, ColHalo);
    }
}

technique GraphicMaterial_NV30
{
    pass p0 
    {
        VertexProgram = compile vp30 GraphicMaterialVS(wvp);
        FragmentProgram = compile fp30 GraphicMaterialPS(world ,  viewIT, 
													    SolDir, SolSize, 
                                                        Ground, 
                                                        ColSol, ColHalo);
    }
}

technique GraphicMaterial_arb
{
    pass p0 
    {
        VertexProgram = compile arbvp1 GraphicMaterialVS(wvp);
        FragmentProgram = compile arbfp1 GraphicMaterialPS(world ,  viewIT, 
														SolDir, SolSize, 
                                                        Ground, 
                                                        ColSol, ColHalo);
    }
}
