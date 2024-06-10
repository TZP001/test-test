/******************************************************************************************/
/* CATIA LIGHTS                                                                           */
/******************************************************************************************/

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
	  float3 Ln = normalize(LightDir); 
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

Light lights[];

/******************************************************************************************/

float4x4 worldIT : WorldIT;
float4x4 wvp : WorldViewProjection;
float4x4 world : World;
float4x4 view : View;
float4x4 viewIT : ViewIT;

// TWEAKABLES


// DATA STRUCTS

struct appdata {
    float3 Position	: POSITION;
    float4 UV		    : TEXCOORD0;
    float4 Normal	  : NORMAL;
};

struct vertexOutput2 {
    float4 HPosition	  : POSITION;
    float2 TexCoord	    : TEXCOORD0;
    float3 WorldNormal	: TEXCOORD1;
    float3 WorldView	  : TEXCOORD2;
    float3 Pw			      : TEXCOORD3;
    float3 ReflVect     : TEXCOORD4;
};

//  ComputeEnvironementCoord

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

// VERTEX SHADER

vertexOutput2 generic_materialVS(appdata IN,
    uniform float4x4 WorldViewProj,
    uniform float4x4 WorldIT,
    uniform float4x4 World,
    uniform float4x4 View,
    uniform float4x4 ViewIT ) 
{
    
    float4 position = float4(IN.Position.xyz,1.0);	
    float3 Pw = mul(World, position).xyz;		
    float3 eye = normalize(ViewIT[3].xyz - Pw);	
    
    float3 N = mul(WorldIT, IN.Normal).xyz;
    float4 N2 = mul(ViewIT, float4(N,0));
	  float s = sign(N2.z); 
	  N *= s.xxx;

    vertexOutput2 OUT;	  
    OUT.HPosition = mul(WorldViewProj, position);		  
	  OUT.Pw = Pw;
	  OUT.WorldView = eye;
	  OUT.TexCoord = IN.UV.xy;
	  OUT.WorldNormal = N;
	  float3 EyeDir       = mul( View, float4(eye,0)).xyz;
    float3 EyeNormal    = mul( View, float4(N,0)).xyz; 
    OUT.ReflVect        = reflect(EyeDir, EyeNormal);
	  
    return OUT;
}

// PIXEL SHADER 

float4 generic_materialPS(vertexOutput2 IN,
   // PARAMETERS 
   
   ) : COLOR 
{
  float3 Nn = normalize(IN.WorldNormal);
  float3 Vn = normalize(IN.WorldView);
  float3 Re = normalize( IN.ReflVect );
  LIGHTRES res;
  res.diffContrib = float3(0,0,0);
  res.specContrib = float3(0,0,0);
  LIGHTINFOS infos;
  infos.Vn = Vn;
  infos.Nb = Nn;
  infos.Pw = IN.Pw;
  infos.SpecExpon = 32; 
  for(int i=0; i<lights.length; i++)
  {
	  res = lights[i].compute(infos, res);
  }
  
  float3 FB;
 
  // PIXEL SHADER 

  return float4(FB,1.0);
}

// TECHNIQUE
technique Generic_Material
{
	pass p0 
	{		
		DepthTestEnable=true;
		DepthMask = true;
		DepthFunc = LEqual;
		VertexProgram = compile arbvp1 generic_materialVS(wvp, worldIT, world, view, viewIT);
		FragmentProgram = compile arbfp1 generic_materialPS(
			//CALLS
			);
	}
}
