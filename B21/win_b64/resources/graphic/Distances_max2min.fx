/******************************************************************/
/*  Distance coloring.                                            */
/*  XXC Fev 2009                                                  */
/******************************************************************/

/******************************************************************/
/* UNTWEAKABLES                                                   */
/******************************************************************/

int NeedTandB = 1; // tangents and binormals

float4x4 worldIT : WorldViewProjection;	

/******************************************************************/
/* DATA STRUCTURES                                                */
/******************************************************************/

struct a2v {
  float4 Position      : POSITION;  // in object space
  
  float2 Distance      : TEXCOORD0;
};

struct v2f {
  float4 Position      : POSITION;  //in projection space
  float  Distance      : TEXCOORD0; //distance
};

struct f2fb
{
  float4 col           : COLOR;
};

/******************************************************************/
/* Vertex and Fragment Programs                                   */
/******************************************************************/

v2f VS(a2v IN, uniform float4x4 WorldIT)
{
  v2f OUT;
  
  //position in screen space
  OUT.Position = mul(WorldIT, IN.Position);
	
  //pass texture coordinates for fetching the normal map
  OUT.Distance = IN.Distance.x;
  return OUT;
}

f2fb PS(v2f IN)
{
  f2fb OUT;
  float r=0,b=0,g=0, distance = IN.Distance, tmp;
  if (distance > (3.0/4.0)){
    tmp = distance - (3.0/4.0);
    r = 1.0;
    g = 1.0 - (4.0*tmp);
    b = 0.0;
  }
  else if (distance > (1.0/2.0)) {
    tmp = distance - (1.0/2.0);
    r = (4.0*tmp);
    g = 1.0;
    b = 0.0;
  }
  else if (distance > (1.0/4.0)) {
    tmp = distance - (1.0/4.0);
    r = 0.0;
    g = 1.0;
    b = 1.0-(4.0*tmp);
  }
  else {
    r = 0.0;
    g = (4.0*distance);
    b = 1.0;
  }

  OUT.col = float4(r,g,b,1.0);
  return OUT;
}

/******************************************************************/
/* TECHNIQUES                                                     */
/******************************************************************/

technique BumpTexDis
{
  pass p0
  {
    DepthTestEnable=true;
    BlendEnable = true;
    DepthMask = true;
    DepthFunc = LEqual;
    VertexProgram = compile arbvp1 VS(worldIT);
    FragmentProgram = compile arbfp1 PS();
  }
}
