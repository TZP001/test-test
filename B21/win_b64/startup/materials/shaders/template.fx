/******************************************************************************************/
/******************************************************************************************/
/*                                   TEMPLATE.FX                                          */
/******************************************************************************************/
/******************************************************************************************/

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



/******************************************************************************************/
/*  TWEAKABLES DECLARATIONS                                                               */
/******************************************************************************************/

 float  f1 = 0.0;
 float2 f2 = {0.0,0.0};
 float3 f3 = {0.0,0.0,0.0};      (for vectors or colors)
 float4 f4 = {0.0,0.0,0.0,0.0}   (for vectors or colors)

 sampler2D s2   (for texture 2D)
 <
  	string File = "s2.dds";    (dds, rgb or bw file)
 > = sampler_state
 {
    minFilter = LinearMipMapLinear;  
    magFilter = Linear;
 };

 samplerCUBE sC (for reflexion map texture)
 <
 	string File = "sC.dds";      (dds, rgb or bw file)
 > = sampler_state
 {
    minFilter = LinearMipMapLinear;
    magFilter = Linear;
 };

 refers you to CgFX documentation for others types 

/******************************************************************************************/
/* UNTWEAKABLES DECLARATIONS, TRACKED BY CPU APPLICATION                                  */
/******************************************************************************************/

int NeedTandB = 1;  // necessary if you want to use tangents and binormals

float4x4 worldIT : WorldIT;
float4x4 wvp     : WorldViewProjection;
float4x4 world   : World;
float4x4 viewIT  : ViewIT;

/******************************************************************************************/
/* DATA STRUCTS                                                                           */
/******************************************************************************************/

struct ApplicationData {                 Data from application to vertex shader
    float3 Position	: POSITION;
    float4 Normal	  : NORMAL;
    float4 UV		    : TEXCOORD0;
    float4 Tangent	: TEXCOORD1;         
    float4 Binormal	: TEXCOORD2;
};

struct VertexOutput {                    Vertex output data 
    float4 HPosition	  : POSITION;
    float2 TexCoord	    : TEXCOORD0;
    float3 WorldNormal	: TEXCOORD1;
    float3 WorldView	  : TEXCOORD2;
    float3 WorldTangent	: TEXCOORD3;
    float3 WorldBinorm	: TEXCOORD4;
    float3 Pw			      : TEXCOORD5;
};

/******************************************************************************************/
/* VERTEX AND PIXEL SHADERS                                                               */
/******************************************************************************************/

VertexOutput VertexShader(
    ApplicationData IN,
    uniform float4x4 WorldViewProj,
    uniform float4x4 WorldIT,
    uniform float4x4 World,
    uniform float4x4 ViewIT,
    
    + all tweakables needed in the vertex shader, for example :
    
    uniform float f ...
    
) {

    VertexOutput OUT;
    
    float4 Position  = float4(IN.Position.xyz,1.0);	
    float3 Pw        = mul(World, Position).xyz;		
    float3 eye       = normalize(ViewIT[3].xyz - Pw);	
    float3 Normal    = mul(WorldIT, IN.Normal).xyz;
    float4 Normal2   = mul(ViewIT, float4(Normal,0));
    float s          = sign(Normal2.z);
            
    OUT.HPosition    = mul(WorldViewProj, Position);	    
    OUT.TexCoord     = IN.UV.xy;
    OUT.WorldNormal  = N.xyz * s.xxx;	  
    OUT.WorldView    = eye;
    OUT.WorldTangent = mul(WorldIT, IN.Tangent).xyz;
    OUT.WorldBinorm  = mul(WorldIT, IN.Binormal).xyz;
    OUT.Pw           = Pw;
    
    return OUT;
}

float4 PixelShader(
    VertexOutput IN
    
    + all tweakables needed in the pixel shader, for example : 
    
    uniform float f, 
    uniform sampler2D s2,
    uniform samplerCUBE sC ...

) : COLOR {

    float3 Nb = normalize(IN.WorldNormal);
    float3 Vn = normalize(IN.WorldView);
    float3 Tn = normalize(IN.WorldTangent);
    float3 Bn = normalize(IN.WorldBinorm);

    // for lights computation 
  	LIGHTRES res;
    res.diffContrib = float3(0,0,0);
    res.specContrib = float3(0,0,0);
	  LIGHTINFOS infos;
	  infos.Vn = Vn;
	  infos.Nb = Nb;
	  infos.Pw = IN.Pw;
	  infos.SpecExpon = 32;

	  for(int i=0; i<lights.length; i++)
	  {
	    res = lights[i].compute(infos, res);
	  }
	  
	  // for textures : 
	  float3 textColor = tex2D(s2,IN.TexCoord);
	  // for reflexions :
	  float3 reflVector = reflect(infos.Vn,infos.Nb).xyz;
	  float3 reflColor = texCUBE(sC,reflVector).xyz;
    // for diffuse contribution
    float3 diffuse = res.diffContrib; 
    // for specular contribution 
    float3 specular = res.specContrib; 
    
    // for result example 
    float3 result = textColor * diffuse + specular + reflColor;
    
    return float4(result.xyz,1.0);
}

/******************************************************************************************/
/* TECHNIQUES                                                                             */
/******************************************************************************************/

technique Technique1
{
	pass p0 
	{	
		DepthTestEnable=true;
		DepthMask = true;
		DepthFunc = LEqual;	
		
		VertexProgram = compile arbvp1 VertexShader(wvp,
			                                          worldIT,
			                                          world,
			                                          viewIT
			                                          + tweakables 
			                                          );
			                                          
		FragmentProgram = compile arbfp1 PixelShader(
		                                             + tweakables
                                          			);
	}
	
	// you can do multi-passes techniques
}
