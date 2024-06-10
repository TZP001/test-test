/******************************************************************/
/* Brushed Metal                                                  */
/******************************************************************/

/******************************************************************/
/* UNTWEAKABLES                                                   */
/******************************************************************/

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


float4x4 worldIT : WorldIT;
float4x4 wvp : WorldViewProjection;
float4x4 world : World;
float4x4 view : View;
float4x4 viewIT : ViewIT;

/******************************************************************/
/* TWEAKABLES                                                     */
/******************************************************************/

float3 DiffuseColor  = {0.8, 0.8, 0.85};
float  Diffuse = 0.4;
float  Roughness = 30.0;
float  ReflectivityMin = 0.2;
float  ReflectivityMax = 0.7;
float  Fresnel = 3.0;
float  TextureScale = 10.0;
float  NoiseScale = 10.0;
float  Specular = 7.0;

sampler2D NoiseMap
<
    string File = "dark_noise.bw";
> = sampler_state
{
    minFilter = LinearMipMapLinear;
    magFilter = Linear;
};

sampler2D TextureMap
<
    string File = "brushed.rgb";
> = sampler_state
{
    minFilter = LinearMipMapLinear;
    magFilter = Linear;
};

sampler2D EnvironmentMap
<
    string File = "envBlur.rgb";
> = sampler_state
{
    minFilter = LinearMipMapLinear;
    magFilter = Linear;
};

/******************************************************************/
/* DATA STRUCTURES                                                */
/******************************************************************/

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

/******************************************************************/
/* METHODS                                                        */
/******************************************************************/

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

/******************************************************************/
/* VERTEX AND FRAGMENT PROGRAMS                                   */
/******************************************************************/

vertexOutput2 BrushedMetalVS(appdata IN,
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

float4 BrushedMetalPS(vertexOutput2 IN,
  uniform float3    iColor,
  uniform float     iDiffuse,
  uniform float     iShininess,
  uniform float     iReflectivityMin,
  uniform float     iTexture_scaleY,
  uniform float     iNoise_scaleY,
  uniform float     iKs,
  uniform float     iReflectivityMax,
  uniform float     iFresnel,
  uniform sampler2D iNoise,
  uniform sampler2D iTexture,
  uniform sampler2D iEnvironment) : COLOR 
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
  infos.SpecExpon = iShininess;
  for(int i=0; i<lights.length; i++)
  {
	  res = lights[i].compute(infos, res);
  }

  float3 result = float3(0.0,0.0,0.0);
  
  float3 texture = tex2D(iTexture,float2(IN.TexCoord.x,iTexture_scaleY*IN.TexCoord.y)).xyz;
  float3 noise = tex2D(iNoise,float2(IN.TexCoord.x,iNoise_scaleY*IN.TexCoord.y)).xyz;
  float3 env = tex2D(iEnvironment,ComputeEnvironementCoord(Re)).xyz;
  
  float3 diffuse = res.diffContrib * iColor * iDiffuse * texture;
  float3 specular = res.specContrib * iKs * noise;
  
  float vdn = dot(infos.Vn,infos.Nb);
  float fres = iReflectivityMin + (iReflectivityMax - iReflectivityMin) * pow(1-abs(vdn),Fresnel);
  
  result = diffuse + specular + fres * env;
 
  return float4(result,1.0);
}

/******************************************************************/
/* TECHNIQUES                                                     */
/******************************************************************/

technique BrushedMetal
{
	pass p0 
	{		
		DepthTestEnable=true;
		DepthMask = true;
		DepthFunc = LEqual;
		VertexProgram = compile arbvp1 BrushedMetalVS(wvp, worldIT, world, view, viewIT);
		FragmentProgram = compile arbfp1 BrushedMetalPS(
		  DiffuseColor,
	    Diffuse,
      Roughness,
      ReflectivityMin,
      TextureScale,
      NoiseScale,
      Specular,
      ReflectivityMax,
      Fresnel,
      NoiseMap,
      TextureMap,
      EnvironmentMap
			);
	}
}
 
