/******************************************************************/
/* CarPaint                                                       */
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
float4x4 viewIT : ViewIT;

/******************************************************************/
/* TWEAKABLES                                                     */
/******************************************************************/

float Diffuse
<
  float uimin = 0;
  float uimax = 2;
> = 1.0;

float Roughness 
<
  float uimin = 0;
  float uimax = 20;
> = 15.0;

float Specular : Power 
<
  float uimin = 0;
  float uimax = 128;
> = 70.0;

float ReflectivityMax
<
  float uimin = 0;
  float uimax = 1;
> = 1.0;

float ReflectivityMin
<
  float uimin = 0;
  float uimax = 1;
> = 0.13;

float Fresnel : Power 
<
  float uimin = 0.0;
  float uimax = 7.0;
> = 5.0;

float3 DiffuseColor : Diffuse
<
    string Desc = "Surface Color";
> = {0.5f, 0.0f, 0.0f};

float3 SpecularColor : Specular
<
    string Desc = "Specular Color";
> = {1.0f, 1.0f, 1.0f};

float3 AmbientColor 
<
    string Desc = "Ambient Color";
> = {0.2f, 0.0f, 0.0f};

sampler2D NoiseMap
<
    string File = "dark_noise.bw";
> = sampler_state
{
    minFilter = LinearMipMapLinear;
    magFilter = Linear;
};

samplerCUBE EnvironmentMap
<
    string File = "Default_reflection.dds";
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
    float3 Pw			      : TEXCOORD5;
};

struct vertexOutput {
    float4 HPosition	: POSITION;
    float4 DiffColor	: COLOR0;
};

/******************************************************************/
/* VERTEX AND FRAGMENT PROGRAMS                                   */
/******************************************************************/

vertexOutput2 CarPaintVS(appdata IN,
    uniform float4x4 WorldViewProj,
    uniform float4x4 WorldIT,
    uniform float4x4 World,
    uniform float4x4 ViewIT
) {
    vertexOutput2 OUT;
    float3 nono =  float3(1,1,0);
    float3 N = mul(WorldIT, IN.Normal).xyz;
    float4 Po = float4(IN.Position.xyz,1.0);	// object coordinates
    OUT.HPosition = mul(WorldViewProj, Po);	// screen clipspace coords
    float3 Pw = mul(World, Po).xyz;		// world coordinates
	  OUT.Pw = Pw;
    float3 eye = normalize(ViewIT[3].xyz - Pw);	// obj coords
  	OUT.WorldView = eye;
    OUT.TexCoord = IN.UV.xy;
    float4 N2 = mul(ViewIT, float4(N,0));
  	float s = sign(N2.z); // CATIA assure the orientation of the normals;
  	N *= s.xxx;
  	OUT.WorldNormal = N;
    return OUT;
}

float4 CarPaintPS(vertexOutput2 IN,
    uniform samplerCUBE EnvMap,
    uniform sampler2D PaintMap,
    uniform float Kd,
    uniform float Ks,
    uniform float SpecExpon,
    uniform float Kr,
    uniform float KrMin,
    uniform float Fres,
    uniform float3 AmbiColor,
    uniform float3 SurfColor,
    uniform float3 SpecColor
    ) : COLOR 
{
  float3 Nn = normalize(IN.WorldNormal);
  float3 Vn = normalize(IN.WorldView);
  LIGHTRES res;
  res.diffContrib = float3(0,0,0);
  res.specContrib = float3(0,0,0);
  LIGHTINFOS infos;
  infos.Vn = Vn;
  infos.Nb = Nn;
  infos.Pw = IN.Pw;
  infos.SpecExpon = SpecExpon;

  for(int i=0; i<lights.length; i++)
  {
	  res = lights[i].compute(infos, res);
  }


  // reflection
  float3 reflVect = reflect(infos.Vn,infos.Nb);
  float vdn = dot(infos.Vn,infos.Nb);
  
  float fres = KrMin + (Kr-KrMin) * pow(1-abs(vdn),Fres);
  float3 reflColor = fres * texCUBE(EnvMap,float3(reflVect.y,reflVect.z,reflVect.x)).xyz;  
  //float3 reflColor = fres * texCUBE(EnvMap,reflVect).xyz;  
  
  //float3 reflColor = Kr * texCUBE(EnvMap,reflVect).xyz;
  // add, incorporating ambient light term
  float3 painttex = tex2D(PaintMap,IN.TexCoord).xyz;
  float3 specContrib = res.specContrib * tex2D(PaintMap,IN.TexCoord).xyz;
  float3 result = ((painttex+SurfColor)*Kd*res.diffContrib)+reflColor+AmbiColor+(Ks*SpecColor*specContrib);
  return float4(result.xyz,1.0);
}

/******************************************************************/
/* TECHNIQUES                                                     */
/******************************************************************/

technique CarPaint
{
	pass p0 
	{		
		DepthTestEnable=true;
		DepthMask = true;
		DepthFunc = LEqual;
		VertexProgram = compile arbvp1 CarPaintVS(wvp, worldIT, world, viewIT);
		FragmentProgram = compile arbfp1 CarPaintPS(
			EnvironmentMap, NoiseMap,
			Diffuse,Roughness,Specular,
			ReflectivityMax,ReflectivityMin,Fresnel,
			AmbientColor,DiffuseColor,SpecularColor
			);
	}
}
