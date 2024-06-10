
float4x4 wvp : WorldViewProjection;
float4x4 world : World;
float4x4 view : View;
float4x4 proj : PROJECTION;

float4 radius
<
>;

float4 transpo
<
>;

float4 windowSize
<
>;

samplerRECT zMapTexture
<
> = sampler_state
{
  WrapS = ClampToBorder;
  WrapT = ClampToBorder;
};

samplerRECT ssaoTexture
<
>;

struct vertexIN
{
  float4 Position       : POSITION;
  float3 Normal         : NORMAL;
  float4 uv             : TEXCOORD0;
};

struct vertexOUT
{
  float4 ScreenPosition : POSITION;
  float4 uv             : TEXCOORD0;
  float4 pt             : TEXCOORD1;
};

vertexOUT SSAOVS(vertexIN IN,
                 uniform float4x4 iWorldViewProj,
                 uniform float4x4 iWorld,
                 uniform float4x4 iView,
                 uniform float4   iWindowSize)
{
  vertexOUT OUT;

  float4 position = float4( IN.Position.xyz, 1.0 );
  position = mul( iWorldViewProj, position );
  OUT.ScreenPosition = position;

  position = float4( IN.Position.xyz, 1.0 );
  position = mul( iWorld, position);
  position = mul( iView, position);
  OUT.pt = position;

  OUT.uv = float4(IN.uv.xy, IN.uv.xy*iWindowSize.zw + iWindowSize.xy);

  return OUT;
}

struct pixelInput
{
  float4 uv   : TEXCOORD0;
  float4 pt   : TEXCOORD1;
};

float2 GetDepth(const float2            iPtScreen,
                const samplerRECT       iDepthTexture,
                const float4            iTranspo)
{
  float z   = texRECT(iDepthTexture,iPtScreen).x;
  float ret = 0;

  if (z!=1)
  {
    ret=1;
    z = iTranspo.y/(z-iTranspo.x);
  }

  return float2(z, ret);
}

float4 SSAOPS(pixelInput IN,
              uniform float4      iRadius,
              uniform float4      iTranspo,
              uniform float4      iWindowSize,
              uniform samplerRECT iDepthTexture,
              uniform samplerRECT iSSAOTexture) : COLOR
{
  float4 result = float4(0,0,0,0);

  float2 ptScreen = IN.uv.zw;
  float2 depth = GetDepth(ptScreen, iDepthTexture, iTranspo);
  if (depth.y==0) return result;
  
  float total = 0;
  float occ = 0;

  for (int i=-2; i<=2; i++)
  {
	for (int j=-2; j<=2; j++)
	{
		float2 ptScreenDec = ptScreen + float2(i*2,j*2);
		float2 depthDec = GetDepth(ptScreenDec, iDepthTexture, iTranspo);
		
		float ratio = 1/(1+abs(depthDec.x-depth.x));
		/*float delta = abs(depthDec.x-depth.x);
		if (delta<iRadius.x)
		{ 
			float ratio = (1-delta*iRadius.y);*/
		
			occ += ratio*texRECT(iSSAOTexture, ptScreenDec).x;
			total += ratio;
		//}
	}
  }
  
  /*for (int i=-2; i<=2; i++)
  {
	float2 ptScreenDec = ptScreen + float2(i,0);
	float depthDec = GetDepth(ptScreenDec, iDepthTexture, iTranspo);
		
	float ratio = 1/(1+abs(depthDec.x-depth.x));
	occ += ratio*texRECT(iSSAOTexture, ptScreenDec).x;
	total += ratio;
  }
  

	for (int j=-2; j<=2; j++)
	{
		float2 ptScreenDec = ptScreen + float2(0,j);
		float depthDec = GetDepth(ptScreenDec, iDepthTexture, iTranspo);
		
		float ratio = 1/(1+abs(depthDec.x-depth.x));
		occ += ratio*texRECT(iSSAOTexture, ptScreenDec).x;
		total += ratio;
	}*/
  
 
  return float4(0,0,0,occ/total);
}

technique SSAO_NV40
{
  pass p0
  {
    VertexProgram         = compile vp40  SSAOVS(wvp, world, view, windowSize);
    FragmentProgram = compile fp40  SSAOPS(radius, transpo, windowSize, zMapTexture, ssaoTexture);
  }
}

technique SSAO_NV30
{
  pass p0
  {
    VertexProgram         = compile vp30  SSAOVS(wvp, world, view, windowSize);
    FragmentProgram = compile fp30  SSAOPS(radius, transpo, windowSize, zMapTexture, ssaoTexture);
  }
}

technique SSAO_ARB
{
  pass p0
  {
    VertexProgram         = compile arbvp1  SSAOVS(wvp, world, view, windowSize);
    FragmentProgram = compile arbfp1  SSAOPS(radius, transpo, windowSize, zMapTexture, ssaoTexture);
  }
}

