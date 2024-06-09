//////  TWEAKABLES /////////////////////////////////////////////

sampler2D textureMap
<
    string File = "";  
> = sampler_state 
{                                    
  minFilter = LinearMipMapLinear; 
  magFilter = Linear;           
};

float4 projectionDataMap
<
> = float4(0,0,0,0);

sampler2D texture1
<
    string File = "";  
> = sampler_state 
{                                    
  minFilter = LinearMipMapLinear; 
  magFilter = Linear;           
};

float4 projectionDataTexture1
<
> = float4(0,0,0,0);

sampler2D texture2
<
    string File = "";  
> = sampler_state 
{                                    
  minFilter = LinearMipMapLinear; 
  magFilter = Linear;           
};

float4 projectionDataTexture2
<
> = float4(0,0,0,0);

float4 windowSize
<
> = float4(1,1,0,0);

samplerRECT mirrorTexture
<
    string File = "";  
> = sampler_state 
{                                    
  minFilter = LinearMipMapLinear; 
  magFilter = Linear;           
};

float4 mirrorCoef
<
> = float4(0.25f,1.f,1.f,0);




//////  UNTWEAKABLES /////////////////////////////////////////////

float4x4  wvp       : WorldViewProjection;

struct appdata 
{
    float3 Position : POSITION;
    float4 Normal   : NORMAL;
    float4 Color    : COLOR;
};

struct vertexOutput 
{
    float4 HPosition       : POSITION;
    float3 TextCoordMap    : TEXCOORD1;
    float3 TextCoord1      : TEXCOORD2;
    float3 TextCoord2      : TEXCOORD3;
    float4 ScreenPosition  : TEXCOORD4;
    float4 Color           : COLOR;
};

//------------------------------------------
//  Vertex Shader
//------------------------------------------

vertexOutput GraphicMaterialVS( appdata IN,
                                uniform float4x4 iWorldViewProj,
                                uniform float4 iProjectionDataMap,
                                uniform float4 iProjectionDataTexture1,
                                uniform float4 iProjectionDataTexture2) 
{
    vertexOutput OUT;
    
    float4 position = float4( IN.Position.xyz, 1.0 );
    float4 screenPosition= mul( iWorldViewProj, position );

    OUT.HPosition = screenPosition;
    OUT.ScreenPosition = screenPosition;

    float3x3 matMap = float3x3(
                    float3(iProjectionDataMap.x,-iProjectionDataMap.y,iProjectionDataMap.z),
                    float3(iProjectionDataMap.y,iProjectionDataMap.x,iProjectionDataMap.w),
                    float3(0,0,1.f)
                    );
    OUT.TextCoordMap = mul(matMap, float3(position.xy,1.f));

    
    float3x3 mat1 = float3x3(
                    float3(iProjectionDataTexture1.x,-iProjectionDataTexture1.y,iProjectionDataTexture1.z),
                    float3(iProjectionDataTexture1.y,iProjectionDataTexture1.x,iProjectionDataTexture1.w),
                    float3(0,0,1.f)
                    );
    OUT.TextCoord1 = mul(mat1, float3(OUT.TextCoordMap.xy,1.f));

    
    float3x3 mat2 = float3x3(
                    float3(iProjectionDataTexture2.x,-iProjectionDataTexture2.y,iProjectionDataTexture2.z),
                    float3(iProjectionDataTexture2.y,iProjectionDataTexture2.x,iProjectionDataTexture2.w),
                    float3(0,0,1.f)
                    );
    OUT.TextCoord2 = mul(mat2, float3(OUT.TextCoordMap.xy,1.f));

    OUT.Color = IN.Color;
    
    return OUT;
}

//------------------------------------------
//  Pixel Shader
//------------------------------------------

float4 luminance = float4(0.3f,0.6f,0.1f,0);

float4 GraphicMaterialPS(vertexOutput IN,
                         uniform sampler2D iTextureMap,
                         uniform sampler2D iTexture1,
                         uniform sampler2D iTexture2,
                         uniform float4    iWindowSize,
                         uniform float4    iMirrorCoef,
                         uniform samplerRECT iMirrorTexture): COLOR 
{
    //--------------------------------------
    // calcul du ratio %texture1/%texture2
    float4 result = tex2D(iTextureMap, (IN.TextCoordMap.xy)); 

    float ratio = dot (result,luminance);


    //--------------------------------------
    // mix des textures fonction du ratio
    result = lerp(
        tex2D(iTexture1, (IN.TextCoord1.xy)), 
        tex2D(iTexture2, (IN.TextCoord2.xy)), 
        ratio);

    //--------------------------------------
    // blend avec la couleur de l'objet
    result *= IN.Color;

    //--------------------------------------
    // ajout de l'effet mirroir
    float mirrorCoef = iMirrorCoef.x * lerp(iMirrorCoef.y, iMirrorCoef.z, ratio);
    if (mirrorCoef!=0)
    {
        float4 screenCoord = IN.ScreenPosition;
        screenCoord.xy = ((screenCoord.xy / screenCoord.w)+1) * iWindowSize.xy * 0.5 
            + iWindowSize.zw;

        result = lerp(result, texRECT(iMirrorTexture, screenCoord.xy), mirrorCoef);  
    }

    //--------------------------------------
    // set de la transparence
    result.w=IN.Color.w;

    return result;
}

////////////////////////////////////////////////////////////////////
/// TECHNIQUES /////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
technique GraphicMaterial_NV40
{
    pass p0 
    {
        VertexProgram = compile vp40 GraphicMaterialVS(wvp, 
                                                       projectionDataMap,
                                                       projectionDataTexture1,
                                                       projectionDataTexture2);

        FragmentProgram = compile fp40 GraphicMaterialPS(textureMap, 
                                                         texture1, 
                                                         texture2,
                                                         windowSize,
                                                         mirrorCoef,
                                                         mirrorTexture);
    }
}

technique GraphicMaterial_NV30
{
    pass p0 
    {
        VertexProgram = compile vp30 GraphicMaterialVS(wvp, 
                                                       projectionDataMap,
                                                       projectionDataTexture1,
                                                       projectionDataTexture2);

        FragmentProgram = compile fp30 GraphicMaterialPS(textureMap, 
                                                         texture1, 
                                                         texture2,
                                                         windowSize,
                                                         mirrorCoef,
                                                         mirrorTexture);
    }
}

technique GraphicMaterial_arb
{
    pass p0 
    {
        VertexProgram = compile arbvp1 GraphicMaterialVS(wvp, 
                                                       projectionDataMap,
                                                       projectionDataTexture1,
                                                       projectionDataTexture2);

        FragmentProgram = compile arbfp1 GraphicMaterialPS(textureMap, 
                                                           texture1, 
                                                           texture2,
                                                           windowSize,
                                                           mirrorCoef,
                                                           mirrorTexture);
    }
}
