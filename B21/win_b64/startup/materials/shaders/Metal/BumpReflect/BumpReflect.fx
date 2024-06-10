/******************************************************************/
/*  Bump Reflect                                                  */
/******************************************************************/

/******************************************************************/
/* UNTWEAKABLES                                                   */
/******************************************************************/

int NeedTandB = 1; // tangents and binormals
float4x4 worldMatrix : World;	 
float4x4 wvpMatrix : WorldViewProjection;	
float4x4 worldViewMatrix : WorldView;
float4x4 worldViewMatrixI : WorldViewI;
float4x4 viewInverseMatrix : ViewIT;
float4x4 viewMatrix : View;

/******************************************************************/
/* TWEAKABLES                                                     */
/******************************************************************/

float BumpHeight
<
	string gui = "slider";
	float uimin = 0.0;
	float uimax = 2.0;
	float uistep = 0.1;
> = 0.2;

sampler2D NormalMap
<
	string File = "NoSkid1_normal.dds";
> = sampler_state
{
    minFilter = LinearMipMapLinear;
    magFilter = Linear;
};

samplerCUBE EnvironmentMap
<
	string File = "sky_cube_mipmap.dds";
> = sampler_state
{
    minFilter = LinearMipMapLinear;
    magFilter = Linear;
};

/******************************************************************/
/* DATA STRUCTURES                                                */
/******************************************************************/

struct a2v {
	float4 Position : POSITION;  // in object space
	float3 Tangent  : TEXCOORD1; //in object space
	float3 Binormal : TEXCOORD2; //in object space
	float3 Normal   : NORMAL;    //in object space
	float2 TexCoord : TEXCOORD0;
};

struct v2f {
	float4 Position  : POSITION;  //in projection space
	float4 TexCoord  : TEXCOORD0;
	float4 TexCoord1 : TEXCOORD1; //first row of the 3x3 transform from tangent to cube space
	float4 TexCoord2 : TEXCOORD2; //second row of the 3x3 transform from tangent to cube space
	float4 TexCoord3 : TEXCOORD3; //third row of the 3x3 transform from tangent to cube space
};

struct f2fb
{
	float4 col : COLOR;
};

/******************************************************************/
/* Vertex and Fragment Programs                                   */
/******************************************************************/

v2f BumpReflectVS(a2v IN,
		uniform float4x4 WorldViewProj,
		uniform float4x4 World,
		uniform float4x4 ViewIT)
{
	v2f OUT;

	// Position in screen space.
	OUT.Position = mul(WorldViewProj, IN.Position);
	
	// pass texture coordinates for fetching the normal map
	OUT.TexCoord.xy = IN.TexCoord;

	// compute the 4x4 tranform from tangent space to object space
	float3x3 TangentToObjSpace;

	// first rows are the tangent and binormal scaled by the bump scale
	TangentToObjSpace[0] = float3(IN.Tangent.x, IN.Binormal.x, IN.Normal.x);
	TangentToObjSpace[1] = float3(IN.Tangent.y, IN.Binormal.y, IN.Normal.y);
	TangentToObjSpace[2] = float3(IN.Tangent.z, IN.Binormal.z, IN.Normal.z);

	OUT.TexCoord1.x = dot(World[0].xyz, TangentToObjSpace[0]);
  OUT.TexCoord1.y = dot(World[1].xyz, TangentToObjSpace[0]);
  OUT.TexCoord1.z = dot(World[2].xyz, TangentToObjSpace[0]);

	OUT.TexCoord2.x = dot(World[0].xyz, TangentToObjSpace[1]);
  OUT.TexCoord2.y = dot(World[1].xyz, TangentToObjSpace[1]);
  OUT.TexCoord2.z = dot(World[2].xyz, TangentToObjSpace[1]);

	OUT.TexCoord3.x = dot(World[0].xyz, TangentToObjSpace[2]);
  OUT.TexCoord3.y = dot(World[1].xyz, TangentToObjSpace[2]);
  OUT.TexCoord3.z = dot(World[2].xyz, TangentToObjSpace[2]);

	float4 worldPos = mul(World,IN.Position);
	// compute the eye vector (going from shaded point to eye) in cube space
	float4 eyeVector = worldPos - ViewIT[3]; // view inv. transpose contains eye position in world space in last row.
	OUT.TexCoord1.w = eyeVector.x;
	OUT.TexCoord2.w = eyeVector.y;
	OUT.TexCoord3.w = eyeVector.z;

	return OUT;
}

f2fb BumpReflectPS(v2f IN,
				uniform sampler2D NormalMap,
				uniform samplerCUBE EnvironmentMap,
        uniform float BumpScale) 
{
	f2fb OUT;

	// fetch the bump normal from the normal map
	float3 normal = tex2D(NormalMap, IN.TexCoord.xy).xyz * 2.0 - 1.0;

  //OUT.col = IN.TexCoord;
  //return OUT;

  normal = normalize(float3(normal.x * BumpScale, normal.y * BumpScale, normal.z)); 

	// transform the bump normal into cube space
	// then use the transformed normal and eye vector to compute a reflection vector
	// used to fetch the cube map
	// (we multiply by 2 only to increase brightness)

  float3 eyevec = float3(IN.TexCoord1.w, IN.TexCoord2.w, IN.TexCoord3.w);
  float3 worldNorm;
  worldNorm.x = dot(IN.TexCoord1.xyz,normal);
  worldNorm.y = dot(IN.TexCoord2.xyz,normal);
  worldNorm.z = dot(IN.TexCoord3.xyz,normal);

  float3 lookup = reflect(eyevec, worldNorm);
  OUT.col = texCUBE(EnvironmentMap, lookup);

	return OUT;
}

/******************************************************************/
/* TECHNIQUES                                                     */
/******************************************************************/

technique BumpReflect
{
	pass p0
	{
		DepthTestEnable=true;
		DepthMask = true;
		DepthFunc = LEqual;
		VertexProgram = compile arbvp1 BumpReflectVS(wvpMatrix,worldMatrix,viewInverseMatrix);
		FragmentProgram = compile arbfp1 BumpReflectPS(NormalMap,EnvironmentMap,BumpHeight);
	}
}

