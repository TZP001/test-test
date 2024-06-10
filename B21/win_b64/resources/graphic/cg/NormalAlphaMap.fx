//
// FRAGMENT PROGRAM FRAGMENT PROGRAM FRAGMENT PROGRAM FRAGMENT PROGRAM
//

float4x4  wvp                    : WorldViewProjection;
float4x4  wordlView 		     : WORLDVIEW;


//--------------------------------
// Tweakables
//--------------------------------


float4 overloadNormalPlane
<
>;

//--------------------------------
// Structure
//--------------------------------

struct vertexInput
{
    float4 Position : POSITION;
    float3 Normal   : NORMAL;
    float4 Color    : COLOR;
};

struct vertexOutput
{
    float4 HPosition        : POSITION;
    float4 WorldNormal      : TEXCOORD1;
    float4 Color            : COLOR;
};

struct pixelInput
{
    float4 WorldNormal   	: TEXCOORD1;
    float4 Color            : COLOR;
};

//-----------------------------------------------------------------------------------------
//  Vertex Shader
//-----------------------------------------------------------------------------------------

vertexOutput NormalAlphaMapHighVS( vertexInput IN,
                               uniform float4x4 iWorldViewProj,
                               uniform float4x4 iWordlView,
                               uniform float4   iOverloadNormalPlane
                              ) 
{
    vertexOutput OUT;

    // screen position
    //-------------------
    float4 position = float4( IN.Position.xyz, 1.0 );
    position = mul( iWorldViewProj, position );
    OUT.HPosition = position;

	// Normal
    //------------------------
    float4 N =  (iOverloadNormalPlane.w==1 ? float4(iOverloadNormalPlane.xyz,0) : float4(IN.Normal,0));
    N = mul( iWordlView, N);            
    OUT.WorldNormal = N;
    
      
	// Color
    //------------------------
    OUT.Color = (iOverloadNormalPlane.w==1 ? IN.Color : float4(IN.Color.xyz, 1));
    
    return OUT;
}

vertexOutput NormalAlphaMapLowVS( vertexInput IN,
                               uniform float4x4 iWorldViewProj,
                               uniform float4x4 iWordlView,
                               uniform float4   iOverloadNormalPlane
                              ) 
{
    vertexOutput OUT;

    // screen position
    //-------------------
    float4 position = float4( IN.Position.xyz, 1.0 );
    position = mul( iWorldViewProj, position );
    OUT.HPosition = position;

	// Normal
    //------------------------
    float4 N =  (iOverloadNormalPlane.w==1 ? float4(iOverloadNormalPlane.xyz,0) : float4(IN.Normal,0));
	
    N = mul( iWordlView, N);
    N.xyz = normalize(N.xyz);
    N *= sign(N.z);
    N = N*0.5+0.5;
            
    OUT.WorldNormal = N;
    
      
	// Color
    //------------------------
    OUT.Color = (iOverloadNormalPlane.w==1 ? IN.Color : float4(IN.Color.xyz, 1));
    
    return OUT;
}

//-----------------------------------------------------------------------------------------
//  Pixel Shader
//-----------------------------------------------------------------------------------------

float4 NormalAlphaMapHighPS(pixelInput IN, float vf : FACE ) : COLOR 
{   
    float3 Nn;
    if(vf > 0.0f) Nn = normalize(IN.WorldNormal.xyz);
    else Nn = normalize(-IN.WorldNormal.xyz);

    float4 result = float4(Nn*0.5+0.5, IN.Color.a); 
    
    return result;
}

float4 NormalAlphaMapLowPS(pixelInput IN) : COLOR 
{
    float4 result = float4(IN.WorldNormal.xyz, IN.Color.a); 
    
    return result;
}

//-----------------------------------------------------------------------------------------
//  Techniques
//-----------------------------------------------------------------------------------------

technique NormalAlphaMap_NV40
{
    pass p0 
    {		
        DepthTestEnable=true;
        DepthMask = true;
        DepthFunc = LEqual;
        VertexProgram   = compile vp40 NormalAlphaMapHighVS(wvp, wordlView, overloadNormalPlane);
        FragmentProgram = compile fp40 NormalAlphaMapHighPS();
    }
}

technique NormalAlphaMap_NV30
{
    pass p0 
    {		
        DepthTestEnable=true;
        DepthMask = true;
        DepthFunc = LEqual;
        VertexProgram   = compile vp30 NormalAlphaMapLowVS(wvp, wordlView, overloadNormalPlane);
        FragmentProgram = compile fp30 NormalAlphaMapLowPS();
    }
}

technique NormalAlphaMap_ARB
{
    pass p0 
    {		
        DepthTestEnable=true;
        DepthMask = true;
        DepthFunc = LEqual;
        VertexProgram   = compile arbvp1 NormalAlphaMapLowVS(wvp, wordlView, overloadNormalPlane);
        FragmentProgram = compile arbfp1 NormalAlphaMapLowPS();
    }
}





