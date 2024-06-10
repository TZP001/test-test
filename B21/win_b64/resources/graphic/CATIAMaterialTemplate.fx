//////  UNTWEAKABLES /////////////////////////////////////////////

float4x4 worldIT : WorldIT;
float4x4 wvp     : WorldViewProjection;
float4x4 world   : World;
float4x4 viewIT  : ViewIT;
//CATIA_KRTEXTUREPARAM{
//CATIA_KRTEXTUREPARAM}
//CATIA_KBTEXTUREPARAM2{
//CATIA_KBTEXTUREPARAM2}

struct appdata 
{
  float3 Position : POSITION;
  float4 UV       : TEXCOORD0;
  float4 Normal   : NORMAL;
//CATIA_KBTEXTUREPARAM3{
//CATIA_KBTEXTUREPARAM3}
};

struct vertexOutput2 
{
  float4 HPosition    : POSITION;
  float2 TexCoord     : TEXCOORD0;
  float3 WorldNormal  : TEXCOORD1;
  float3 WorldView    : TEXCOORD2;
//CATIA_KBTEXTUREPARAM4{
//CATIA_KBTEXTUREPARAM4}
  float3 Pw           : TEXCOORD5;
//CATIA_KRTEXTUREPARAM3{
//CATIA_KRTEXTUREPARAM3}
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
};

//
// interface for lights
//

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

//////  UNTWEAKABLES /////////////////////////////////////////////

float  Ka = 1.0;
float3 KaColor = { 0.7, 0.7, 0.7 };

float  Kd = 1.0;
float3 KdColor = { 0.5, 0.5, 0.5 };

float  Ks = 1.0;
float3 KsColor = { 0.8, 0.8, 0.8 };

float KsShi = 0.585938f;

float Kt = 0.0;

//CATIA_KBTEXTUREPARAM{
//CATIA_KBTEXTUREPARAM}

//CATIA_KDTEXTUREPARAM{
//CATIA_KDTEXTUREPARAM}

//CATIA_KRTEXTUREPARAM2{
//CATIA_KRTEXTUREPARAM2}

//------------------------------------------
//  Vertex Shader
//------------------------------------------
vertexOutput2 GraphicMaterialVS( appdata IN,
                                 uniform float4x4 iWorldViewProj,
                                 uniform float4x4 iWorldIT,
                                 uniform float4x4 iWorld,
//CATIA_KRTEXTUREVARS2{
//CATIA_KRTEXTUREVARS2}
                                 uniform float4x4 iViewIT
                               ) 
{
  vertexOutput2 OUT;

  // object coordinates
  //-------------------
  float4 position = float4( IN.Position.xyz, 1.0 );

  // screen clipspace coords
  //------------------------
  OUT.HPosition = mul( iWorldViewProj, position );
  
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
  OUT.WorldNormal  = N;
//CATIA_KBTEXTURECALLS_2{
//CATIA_KBTEXTURECALLS_2}
//CATIA_KRTEXTURECALLS2{
//CATIA_KRTEXTURECALLS2}

  return OUT;
}

//------------------------------------------
//  Pixel Shader
//------------------------------------------
float4 GraphicMaterialPS( vertexOutput2 IN,
                          uniform float  iKa,
                          uniform float3 iKaColor,
                          uniform float  iKd,
                          uniform float3 iKdColor,
                          uniform float  iKs,
                          uniform float  iKsShi,
                          uniform float3 iKsColor,
                          uniform float  iKt,
                          uniform float  iLightNumber
//CATIA_KBTEXTUREVARS{
//CATIA_KBTEXTUREVARS}
//CATIA_KDTEXTUREVARS{
//CATIA_KDTEXTUREVARS}
//CATIA_KRTEXTUREVARS{
//CATIA_KRTEXTUREVARS}
): COLOR 
{
  float alpha = 1.0;
  float3 Nn = normalize( IN.WorldNormal  );
  float3 Vn = normalize( IN.WorldView    );
  float3 Bumps = float3( 0.0,0.0,0.0 );
	
	
//CATIA_KBTEXTURECALLS_3{
//CATIA_KBTEXTURECALLS_3}
//CATIA_KDTEXTURECALLS_1{
//CATIA_KDTEXTURECALLS_1}
//CATIA_KBTEXTURECALLS_1{
//CATIA_KBTEXTURECALLS_1}

  LIGHTRES res;
  res.diffContrib  = float3( 0.0,0.0,0.0 );
  res.specContrib = float3( 0.0,0.0,0.0 );

  LIGHTINFOS infos;
  infos.Vn = Vn;
  infos.Nb = Nn;
  infos.Pw = IN.Pw;
  infos.SpecExpon = 400*iKsShi;

  for(int i=0; i<lights.length*iLightNumber; i++)
  {
    res = lights[i].compute(infos, res);
  }
  
  float4 result = float4( 0.0, 0.0, 0.0, alpha *(1 - iKt) );

  result.xyz += iKa/2 * iKaColor;
  result.xyz += iKd   * iKdColor * res.diffContrib;
  
//CATIA_KDTEXTURECALLS_2{
//CATIA_KDTEXTURECALLS_2}

 result.xyz += iKs*2 * iKsColor * res.specContrib;
 
//CATIA_KRTEXTURECALLS{
//CATIA_KRTEXTURECALLS}

  return result;
}

float4 GraphicMaterialPS_LightOnly_Pass( vertexOutput2 IN,
                                         uniform float  iKa,
                                         uniform float3 iKaColor,
                                         uniform float  iKd,
                                         uniform float3 iKdColor,
                                         uniform float  iKs,
                                         uniform float  iKsShi,
                                         uniform float3 iKsColor,
                                         uniform float  iKt,
                                         uniform float  iStartLight,
                                         uniform float  iEndLight
//CATIA_KBTEXTUREVARS{
//CATIA_KBTEXTUREVARS}
//CATIA_KDTEXTUREVARS{
//CATIA_KDTEXTUREVARS}
//CATIA_KRTEXTUREVARS{
//CATIA_KRTEXTUREVARS}
): COLOR 
{
  float alpha = 1.0;
  float3 Nn = normalize( IN.WorldNormal  );
  float3 Vn = normalize( IN.WorldView    );
  float3 Bumps = float3( 0.0,0.0,0.0 );
  
//CATIA_KBTEXTURECALLS_3{
//CATIA_KBTEXTURECALLS_3}
//CATIA_KDTEXTURECALLS_1{
//CATIA_KDTEXTURECALLS_1}
//CATIA_KBTEXTURECALLS_1{
//CATIA_KBTEXTURECALLS_1}

  LIGHTRES res;
  res.diffContrib  = float3( 0.0,0.0,0.0 );
  res.specContrib = float3( 0.0,0.0,0.0 );

  LIGHTINFOS infos;
  infos.Vn = Vn;
  infos.Nb = Nn;
  infos.Pw = IN.Pw;
  infos.SpecExpon = 400*iKsShi;
  
  for(int i=(lights.length*iStartLight); i<(lights.length*iEndLight); i++)
  {
    res = lights[i].compute(infos, res);
  }
  
  float4 result = float4( 0.0, 0.0, 0.0, 0.0 );

  result.xyz += iKd   * iKdColor * res.diffContrib;
  
//CATIA_KDTEXTURECALLS_2{
//CATIA_KDTEXTURECALLS_2}

 result.xyz += iKs*2 * iKsColor * res.specContrib;
 result.w = 0.0;
   
  return result;
}

////////////////////////////////////////////////////////////////////
/// TECHNIQUES /////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////

//CATIA_NVTECH{
//CATIA_NVTECH}
technique GraphicMaterial_vp40
{
  pass p0 
  {
  PolygonOffset = float2(2.0,2.0); 
  DepthTestEnable=true;
  DepthMask = true;
  DepthFunc = LEqual;
    VertexProgram = compile vp40 GraphicMaterialVS( wvp, worldIT, world, 
//CATIA_KRTEXTUREARGS2{
//CATIA_KRTEXTUREARGS2}
    viewIT );
    FragmentProgram = compile fp40 GraphicMaterialPS( Ka, KaColor, Kd, KdColor, Ks, KsShi, KsColor, Kt, 1.0
//CATIA_KBTEXTUREARGS{
//CATIA_KBTEXTUREARGS}
//CATIA_KDTEXTUREARGS{
//CATIA_KDTEXTUREARGS}
//CATIA_KRTEXTUREARGS{
//CATIA_KRTEXTUREARGS}
    );
  }
}
technique GraphicMaterial_glsl
{
  pass p0 
  {
  PolygonOffset = float2(2.0,2.0); 
  DepthTestEnable=true;
  DepthMask = true;
  DepthFunc = LEqual;
    VertexProgram = compile glslv GraphicMaterialVS( wvp, worldIT, world, 
//CATIA_KRTEXTUREARGS2{
//CATIA_KRTEXTUREARGS2}
    viewIT );
    FragmentProgram = compile glslf GraphicMaterialPS( Ka, KaColor, Kd, KdColor, Ks, KsShi, KsColor, Kt, 1.0
//CATIA_KBTEXTUREARGS{
//CATIA_KBTEXTUREARGS}
//CATIA_KDTEXTUREARGS{
//CATIA_KDTEXTUREARGS}
//CATIA_KRTEXTUREARGS{
//CATIA_KRTEXTUREARGS}
    );
  }
}
technique GraphicMaterial_arb
{
  pass p0 
  {
  PolygonOffset = float2(2.0,2.0); 
  DepthTestEnable=true;
  DepthMask = true;
  DepthFunc = LEqual;
    VertexProgram = compile arbvp1 GraphicMaterialVS( wvp, worldIT, world, 
//CATIA_KRTEXTUREARGS2{
//CATIA_KRTEXTUREARGS2}
    viewIT );
    FragmentProgram = compile arbfp1 GraphicMaterialPS( Ka, KaColor, Kd, KdColor, Ks, KsShi, KsColor, Kt, 1.0
//CATIA_KBTEXTUREARGS{
//CATIA_KBTEXTUREARGS}
//CATIA_KDTEXTUREARGS{
//CATIA_KDTEXTUREARGS}
//CATIA_KRTEXTUREARGS{
//CATIA_KRTEXTUREARGS}
    );
  }
}

technique GraphicMaterial_arb_2_Pass
{
  pass p0 
  {
  PolygonOffset = float2(2.0,2.0); 
  BlendEnable = false;
  DepthTestEnable=true;
  DepthMask = true;
  DepthFunc = LEqual;
    VertexProgram = compile arbvp1 GraphicMaterialVS( wvp, worldIT, world, 
//CATIA_KRTEXTUREARGS2{
//CATIA_KRTEXTUREARGS2}
    viewIT );
    FragmentProgram = compile arbfp1 GraphicMaterialPS( Ka, KaColor, Kd, KdColor, Ks, KsShi, KsColor, Kt, 0.5
//CATIA_KBTEXTUREARGS{
//CATIA_KBTEXTUREARGS}
//CATIA_KDTEXTUREARGS{
//CATIA_KDTEXTUREARGS}
//CATIA_KRTEXTUREARGS{
//CATIA_KRTEXTUREARGS}
    );
  }
  
  pass p1
  {
  PolygonOffset = float2(2.0,2.0);   
  BlendEnable = true;
  DepthTestEnable=true;
  DepthMask = true;
  DepthFunc = Equal;
  BlendFunc = int2(One, One);
  BlendEquation = FuncAdd;
  VertexProgram = compile arbvp1 GraphicMaterialVS( wvp, worldIT, world, 
//CATIA_KRTEXTUREARGS2{
//CATIA_KRTEXTUREARGS2}
  viewIT );
  FragmentProgram = compile arbfp1 GraphicMaterialPS_LightOnly_Pass( Ka, KaColor, Kd, KdColor, Ks, KsShi, KsColor, Kt, 0.5, 1.0
//CATIA_KBTEXTUREARGS{
//CATIA_KBTEXTUREARGS}
//CATIA_KDTEXTUREARGS{
//CATIA_KDTEXTUREARGS}
//CATIA_KRTEXTUREARGS{
//CATIA_KRTEXTUREARGS}
    );
  } 
}

technique GraphicMaterial_arb_3_Pass
{
  pass p0 
  {
  PolygonOffset = float2(2.0,2.0); 
  BlendEnable = false;
  DepthTestEnable=true;
  DepthMask = true;
  DepthFunc = LEqual;
    VertexProgram = compile arbvp1 GraphicMaterialVS( wvp, worldIT, world, 
//CATIA_KRTEXTUREARGS2{
//CATIA_KRTEXTUREARGS2}
    viewIT );
    FragmentProgram = compile arbfp1 GraphicMaterialPS( Ka, KaColor, Kd, KdColor, Ks, KsShi, KsColor, Kt, 0.3
//CATIA_KBTEXTUREARGS{
//CATIA_KBTEXTUREARGS}
//CATIA_KDTEXTUREARGS{
//CATIA_KDTEXTUREARGS}
//CATIA_KRTEXTUREARGS{
//CATIA_KRTEXTUREARGS}
    );
  }
  
  pass p1
  {
  PolygonOffset = float2(2.0,2.0);   
  BlendEnable = true;
  DepthTestEnable=true;
  DepthMask = true;
  DepthFunc = Equal;
  BlendFunc = int2(One, One);
  BlendEquation = FuncAdd;
  VertexProgram = compile arbvp1 GraphicMaterialVS( wvp, worldIT, world, 
//CATIA_KRTEXTUREARGS2{
//CATIA_KRTEXTUREARGS2}
  viewIT );
  FragmentProgram = compile arbfp1 GraphicMaterialPS_LightOnly_Pass( Ka, KaColor, Kd, KdColor, Ks, KsShi, KsColor, Kt, 0.3, 0.6
//CATIA_KBTEXTUREARGS{
//CATIA_KBTEXTUREARGS}
//CATIA_KDTEXTUREARGS{
//CATIA_KDTEXTUREARGS}
//CATIA_KRTEXTUREARGS{
//CATIA_KRTEXTUREARGS}
    );
  } 
  
  pass p2
  {
  PolygonOffset = float2(2.0,2.0);   
  BlendEnable = true;
  DepthTestEnable=true;
  DepthMask = true;
  DepthFunc = Equal;
  BlendFunc = int2(One, One);
  BlendEquation = FuncAdd;
  VertexProgram = compile arbvp1 GraphicMaterialVS( wvp, worldIT, world, 
//CATIA_KRTEXTUREARGS2{
//CATIA_KRTEXTUREARGS2}
  viewIT );
  FragmentProgram = compile arbfp1 GraphicMaterialPS_LightOnly_Pass( Ka, KaColor, Kd, KdColor, Ks, KsShi, KsColor, Kt, 0.6, 1.0
//CATIA_KBTEXTUREARGS{
//CATIA_KBTEXTUREARGS}
//CATIA_KDTEXTUREARGS{
//CATIA_KDTEXTUREARGS}
//CATIA_KRTEXTUREARGS{
//CATIA_KRTEXTUREARGS}
    );
  } 
}

