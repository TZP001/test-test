//////  TWEAKABLES /////////////////////////////////////////////

float4 windowSize
<
> = float4(1,1,0,0);

float reflexionCoef
<
float uimin = 0;
float uimax = 1;
> = 0;

float isTextureRGBA
<
float uimin = 0;
float uimax = 1;
> = 0;

samplerRECT mirrorTexture
<
>;

//////  UNTWEAKABLES /////////////////////////////////////////////

float4x4  worldIT                : WorldIT;
float4x4  wvp                    : WorldViewProjection;
float4x4  world                  : World;
float4x4  view                   : View;
float4x4  viewIT                 : ViewIT;
float     useDiffuseTexture      : USEDIFFUSETEXTURE;
float     diffuseTextureFunction : DIFFUSETEXTUREFUNCTION;
float     diffuseTextureMappingFunction : DIFFUSETEXTUREMAPPINGFUNCTION;
sampler2D currentTexture         : DIFFUSETEXTURE;
float     globalAmbientColor     : GLOBALAMBIENTCOLOR;

float3 KaColor                 : AMBIENTCOLOR;
float  Ka                      : AMBIENTCOEFF;
float3 KdColor                 : DIFFUSE;
float  Kd                      : DIFFUSECOEFF;
float3 KsColor                 : SPECULAR;
float  Ks                      : SPECULARCOEFF;
float  Kt                      : TRANSPARENCYCOEFF;
float  KsShi                   : SHININESSCOEFF;




struct appdata 
{
    float3 Position : POSITION;
    float4 UV       : TEXCOORD0;
    float4 Normal   : NORMAL;
    float3 Color    : COLOR;
};

struct vertexOutput2 
{
    float4 HPosition        : POSITION;
    float2 TexCoord         : TEXCOORD0;
    float3 WorldNormal      : TEXCOORD1;
    float3 WorldView        : TEXCOORD2;
    float3 ReflVect         : TEXCOORD4;  
    float3 Pw               : TEXCOORD5;
    float4 ScreenPosition   : TEXCOORD6;
    float3 Color            : COLOR;
};

struct LIGHTRES
{
    float3 diffContrib;
    float3 specContrib;
};

struct LIGHTINFOS
{
    float3 Pw;
    float3 Vn;
    float3 Nb;
    float SpecExpon;
    float2 tc;
};

//
// interface for lights
//

float4 offset_lookup(sampler2D i_map, float4 i_position, float2 i_offset, int i_mapSize)
{
    return tex2Dproj(i_map, float4(i_position.xy + i_offset * float2(1/(float)i_mapSize, 1/(float)i_mapSize) * i_position.w, i_position.z, i_position.w));
}

interface Light
{
    LIGHTRES compute(const LIGHTINFOS infos, LIGHTRES prevres);
};
struct SLightDir : Light
{
    const float3 LightPos;
    const float3 LightDir;
    const float3 LightColor;
    const float3 LightColorSpec;
    const float3 lightI_SCos_SExp;
    const float  LightCastShadowFlag;
    const sampler2D LightShadowMap;
    const float4x4 LightShadowMapMatrix;
    LIGHTRES compute(const LIGHTINFOS infos, LIGHTRES prevres)
    {
        LIGHTRES res;
        float3 Ln = normalize(LightDir); // we could do normalize outside...
        float3 Hn = normalize(infos.Vn + Ln);
        float4 litVec = lit(dot(Ln,infos.Nb),dot(Hn,infos.Nb),infos.SpecExpon);
        res.diffContrib = prevres.diffContrib + (litVec.y * lightI_SCos_SExp.x) * LightColor;
        res.specContrib = prevres.specContrib + (litVec.z * res.diffContrib) * LightColorSpec;
        return res;
    }
};
struct SLightPoint : Light
{
    const float3 LightPos;
    const float3 LightDir;
    const float3 LightColor;
    const float3 LightColorSpec;
    const float3 lightI_SCos_SExp;
    const float  LightCastShadowFlag;
    const sampler2D LightShadowMap;
    const float4x4 LightShadowMapMatrix;
    LIGHTRES compute(const LIGHTINFOS infos, LIGHTRES prevres)
    {
        LIGHTRES res;
        float3 Ln = normalize(LightPos - infos.Pw);
        float3 Hn = normalize(infos.Vn + Ln);
        float4 litVec = lit(dot(Ln,infos.Nb),dot(Hn,infos.Nb),infos.SpecExpon);
        res.diffContrib = prevres.diffContrib + (litVec.y * lightI_SCos_SExp.x) * LightColor;
        res.specContrib = prevres.specContrib + (litVec.z * res.diffContrib) * LightColorSpec;
        return res;
    }
};
struct SLightSpot : Light
{
    const float3 LightPos;
    const float3 LightDir;
    const float3 LightColor;
    const float3 LightColorSpec;
    const float3 lightI_SCos_SExp;
    const float  LightCastShadowFlag;
    const sampler2D LightShadowMap;
    const float4x4 LightShadowMapMatrix;
    LIGHTRES compute(const LIGHTINFOS infos, LIGHTRES prevres)
    {
        LIGHTRES res;
        float3 Ln = normalize(LightPos - infos.Pw);
        float3 Hn = normalize(infos.Vn + Ln);
        float Ca = dot(-Ln, normalize(LightDir));
        if(Ca < lightI_SCos_SExp.y) Ca = 0.0;
        float4 litVec;
        Ca = lit(Ca, Ca, lightI_SCos_SExp.z).z;
        litVec = lit(dot(Ln,infos.Nb),dot(Hn,infos.Nb),infos.SpecExpon);
        res.diffContrib = prevres.diffContrib + Ca * (litVec.y * lightI_SCos_SExp.x) * LightColor;
        res.specContrib = prevres.specContrib + Ca * (litVec.z * res.diffContrib) * LightColorSpec;

        float shadowCoeff = 1.0;
        if (LightCastShadowFlag)
        {
            float4 texCoordLight = mul(LightShadowMapMatrix,float4(infos.Pw, 1));

            float sum = 0.0;
            float x=0.0, y=0.0;

            float texelSizeSample = 6.0;
            float maxValue = 2.5;
            float minValue = -2.5;
            for (y = minValue; y <= maxValue; y += 1.0)
            {
                for (x = minValue; x <= maxValue; x += 1.0)
                {
                    sum += offset_lookup(LightShadowMap, texCoordLight, float2(x, y), 512);
                }
            }
            shadowCoeff = sum/36.0;
        }

        res.diffContrib *= shadowCoeff;
        res.specContrib *= shadowCoeff;

        return res;
    }
};
//
// Unsized arrays to be determined by the app
//
Light lights[];

//------------------------------------
//  ComputeEnvironementCoord
//------------------------------------
float2 ComputeEnvironementCoord( const float3 iVect )
{
    float2 st = float2( 0.0, 0.0 );
    float3 iVect2 = normalize(iVect);
    float x = iVect2.x;
    float y = iVect2.y;
    float z = iVect2.z;

    float m = sqrt(2*(-z+1));
    st.x = ((-x/m)+1)/2;
    st.y = ((-y/m)+1)/2;

    return st;
}

//------------------------------------------
//  Vertex Shader
//------------------------------------------
vertexOutput2 GraphicMaterialVS( appdata IN,
                                uniform float4x4 iWorldViewProj,
                                uniform float4x4 iWorldIT,
                                uniform float4x4 iWorld,
                                uniform float4x4 iView,
                                uniform float4x4 iViewIT
                                ) 
{
    vertexOutput2 OUT;

    // object coordinates
    //-------------------
    float4 position = float4( IN.Position.xyz, 1.0 );
    float4 screenPosition= mul( iWorldViewProj, position );

    // screen clipspace coords
    //------------------------
    OUT.HPosition = screenPosition;
    OUT.ScreenPosition = screenPosition;

    // world position
    //---------------
    float3 Pw = mul( iWorld, position ).xyz;
    OUT.Pw = Pw;

    // Eye position
    //-------------
    float3 eye = normalize( iViewIT[ 3 ].xyz - Pw );
    OUT.WorldView = eye;

    // Coordonne de Textures
    //----------------------
    OUT.TexCoord = IN.UV.xy;

    float3 N = mul( iWorldIT, IN.Normal ).xyz;
    float4 N2 = mul(iViewIT, float4(N,0));
    float s = sign(N2.z); // CATIA assure the orientation of the normals;
    N *= s.xxx;


    OUT.Color = IN.Color;

    OUT.WorldNormal = N;

    float3 EyeDir       = mul( iView, float4(eye,0)).xyz;
    float3 EyeNormal    = mul( iView, float4(N,0)).xyz; 
    OUT.ReflVect        = reflect(EyeDir, EyeNormal);

    OUT.ReflVect = reflect(EyeDir, EyeNormal);

    return OUT;
}

//------------------------------------------
//  Pixel Shader
//------------------------------------------
float4 GraphicMaterialPS( vertexOutput2 IN,
                         uniform float3    i_globalAmbientColor,
                         uniform float     iKa,
                         uniform float3    iKaColor,
                         uniform float     iKd,
                         uniform float3    iKdColor,
                         uniform float     iKs,
                         uniform float     iKsShi,
                         uniform float3    iKsColor,
                         uniform float     iKt,
                         uniform float     i_useDiffuseTexture,
                         uniform float     i_diffuseTextureFunction,
                         uniform float     i_diffuseTextureMappingFunction,
                         uniform sampler2D i_diffuseTexture,
                         uniform float     iLightNumber,
                         uniform float     iReflexionCoef,
                         uniform float4    iWindowSize,
                         uniform samplerRECT iReflexionSampler,
                         uniform int       iTextureRGBA
                         ): COLOR 
{
    float3 Nn = normalize( IN.WorldNormal  );
    float3 Vn = normalize( IN.WorldView    );

    LIGHTRES res;
    res.diffContrib  = float3( 0.0,0.0,0.0 );
    res.specContrib = float3( 0.0,0.0,0.0 );

    LIGHTINFOS infos;
    infos.Vn = Vn;
    infos.Nb = Nn;
    infos.Pw = IN.Pw;
    infos.SpecExpon = 400*iKsShi;
    infos.tc = IN.TexCoord;

    for(int i=0; i<lights.length*iLightNumber; i++)
    {
        res = lights[i].compute(infos, res);
    }

    float4 result = float4( 0.0, 0.0, 0.0, 1.);

    result.xyz += i_globalAmbientColor * iKaColor;

    // WARNING result.xyz += iKa * iKaColor * res.ambContrib; //ambContrib est tout le temps nulle dans CATIA.
    result.xyz +=  iKd * iKdColor * res.diffContrib;

    if (i_useDiffuseTexture == 1)
    {
        float4 textureColor;
        if (i_diffuseTextureMappingFunction == 0)
        {
            textureColor = tex2D(i_diffuseTexture, IN.TexCoord);
        }
        else
        {
            //***** SPHERE ************
            //      9218   ************
            float3 Re = normalize( IN.ReflVect );
            textureColor = tex2D(i_diffuseTexture,ComputeEnvironementCoord(Re));      
        }

        if (i_diffuseTextureFunction == 8448)
        {
            //***** MODULATE ******
            result.xyz *= textureColor;
            result.xyz += iKs*2 * iKsColor * res.specContrib;
            result.a *= textureColor.a;
        }	 
        else if( i_diffuseTextureFunction == 8449)
        {
            //******* DECAL *******
            result.xyz = (1-textureColor.a)*result.xyz + textureColor.a*textureColor.xyz;
            result.xyz += iKs*2 * iKsColor * res.specContrib;
        }
        else if ( i_diffuseTextureFunction == 7681)
        {
            //******* REPLACE *****
            result = textureColor;
        }
        else if ( i_diffuseTextureFunction == 3042 )
        {
            //******** BLEND *******
            result.xyz = (1-textureColor.xyz)*result.xyz+textureColor.xyz*result.xyz;
            result.a *= textureColor.a;
            result.xyz += iKs*2 * iKsColor * res.specContrib;
        }
    }
    else
    {
        result.xyz += iKs*2 * iKsColor * res.specContrib;
    }

    if (reflexionCoef!=0)
    {
        // projection sur l'ecran de la position
        float4 screenCoord = IN.ScreenPosition;
        screenCoord.xy = ((screenCoord.xy / screenCoord.w)+1) * iWindowSize.xy * 0.5 
                      + iWindowSize.zw;

        // blend de la couleur de l'objet avec celle du mirroir
        if (iTextureRGBA)
        {
            result.xyz =  lerp(result.xyz, 
                texRECT(iReflexionSampler, screenCoord.xy), 
                iReflexionCoef * (1-result.a));
        }
        else
        {
            result.xyz =  lerp(result.xyz, 
                texRECT(iReflexionSampler, screenCoord.xy), 
                iReflexionCoef);
        }

        // dans le cas d'un mirroir, le chanel alpha correspond a un chanel de reflexion
        result.a = 1;
    }

    // transparence du materiau
    // blend de la couleur de l'objet avec celle du fond
    // Si le blending est active, le chanel alpha est interprete 
    // par le moteur openGL selon la fonction courante de blending
    result.a *= (1-iKt);

    return result;
}

////////////////////////////////////////////////////////////////////
/// TECHNIQUES /////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
technique GraphicMaterial_NV40
{
    pass p0 
    {
        VertexProgram = compile vp40 GraphicMaterialVS( wvp, worldIT, world , view, viewIT );
        FragmentProgram = compile fp40 GraphicMaterialPS( globalAmbientColor, Ka, KaColor, Kd, KdColor, Ks, KsShi, KsColor, Kt, useDiffuseTexture, diffuseTextureFunction, diffuseTextureMappingFunction, currentTexture, 1.0, 
            reflexionCoef, windowSize, mirrorTexture, isTextureRGBA);
    }
}

technique GraphicMaterial_NV30
{
    pass p0 
    {
        VertexProgram = compile vp30 GraphicMaterialVS( wvp, worldIT, world , view, viewIT );
        FragmentProgram = compile fp30 GraphicMaterialPS( globalAmbientColor, Ka, KaColor, Kd, KdColor, Ks, KsShi, KsColor, Kt, useDiffuseTexture, diffuseTextureFunction, diffuseTextureMappingFunction, currentTexture, 1.0, 
            reflexionCoef, windowSize, mirrorTexture, isTextureRGBA);
    }
}

technique GraphicMaterial_arb
{
    pass p0 
    {
        VertexProgram = compile arbvp1 GraphicMaterialVS( wvp, worldIT, world , view, viewIT );
        FragmentProgram = compile arbfp1 GraphicMaterialPS( globalAmbientColor, Ka, KaColor, Kd, KdColor, Ks, KsShi, KsColor, Kt, useDiffuseTexture, diffuseTextureFunction, diffuseTextureMappingFunction, currentTexture, 1.0, 
            reflexionCoef, windowSize, mirrorTexture, isTextureRGBA);
    }
}
