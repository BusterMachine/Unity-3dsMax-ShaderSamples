#ifndef MAXHLSL_COMMON_HLSL
#define MAXHLSL_COMMON_HLSL


#define SV_POSITION SV_Position
#define Max_PI 3.14159265359f

// CPU输入前就已经修改了UV的tile和repeat
#define TRANSFORM_TEX(a, b) a

// 顶点着色器全部输入
struct appdata_full{
    float4 vertex : POSITION;
	float3 normal : NORMAL;
	float3 tangent	: TANGENT;
	float3 binormal	: BINORMAL;
	float2 texcoord : TEXCOORD0;	

	// TODO: 未在Max文档中发现对应描述，需要实际测试，现在还没测试 XD
	// 顶点颜色
	float4 color : TEXCOORD1;
	// 顶点alpha
	float4 alpha : TEXCOORD2;
	// 顶点辐射率
	float4 illum : TEXCOORD3;

	float4 texcoord1 : TEXCOORD4;
	float4 texcoord2 : TEXCOORD5;
	float4 texcoord3 : TEXCOORD6;
	float4 texcoord4 : TEXCOORD7;

	// 我觉得没有人会在一个Max场景里复制很多很多个模型
	// 所以不需要实例化 （应该）
	// uint instanceID : SV_InstanceID;
};

// 顶点着色器基本输入
struct appdata_base{
    float4 vertex : POSITION;
	float3 normal : NORMAL;
	float2 texcoord : TEXCOORD0;	
	// uint instanceID : SV_InstanceID;
};

// 带切线的输入
struct appdata_tan {
	float4 vertex : POSITION;
	float4 tangent : TANGENT;
	float3 normal : NORMAL;
	float2 texcoord : TEXCOORD0;
	// uint instanceID : SV_InstanceID;
};

struct appdata_img
{
	float4 vertex : POSITION;
	float2 texcoord : TEXCOORD0;
};

// unity style的矩阵转换函数
float4 UnityObjectToClipPos(float3 pos)
{
	return mul(UNITY_MATRIX_MVP,float4(pos, 1.0));
}

float4 UnityWorldToClipPos(float3 pos)
{
	return mul(UNITY_MATRIX_VP, float4(pos, 1.0));
}

float4 UnityViewToClipPos(float3 pos)
{
	return mul(UNITY_MATRIX_P, float4(pos, 1.0));
}

float3 UnityObjectToViewPos(float3 pos)
{
	return mul(UNITY_MATRIX_V, mul(unity_ObjectToWorld, float4(pos, 1.0))).xyz;
}

float3 UnityObjectToViewPos(float4 pos)
{
	return UnityObjectToViewPos(pos.xyz);
}

float3 UnityWorldToViewPos(float3 pos)
{
	return mul(UNITY_MATRIX_V, float4(pos, 1.0)).xyz;
}

float3 UnityObjectToWorldDir(float3 dir)
{
	return normalize(mul((float3x3)unity_ObjectToWorld, dir));
}

float3 UnityWorldToObjectDir(float3 dir)
{
	return normalize(mul((float3x3)unity_WorldToObject, dir));
}

float3 UnityObjectToWorldNormal(float3 norm)
{
	// mul(IT_M, norm) => mul(norm, I_M)
	// => {dot(norm, I_M.col0), dot(norm, I_M.col1), dot(norm, I_M.col2)}
	return normalize(mul(norm, (float3x3)unity_WorldToObject));
}

float3 UnityWorldSpaceViewDir(float3 worldPos)
{
	return _WorldSpaceCameraPos.xyz - worldPos;
}

float3 WorldSpaceViewDir(float4 localPos)
{
	float3 worldPos = mul(unity_ObjectToWorld, localPos).xyz;
	return UnityWorldSpaceViewDir(worldPos);
}

float3 ObjSpaceViewDir(float4 v)
{
	float3 objSpaceCameraPos = mul(unity_WorldToObject, float4(_WorldSpaceCameraPos.xyz, 1)).xyz;
	return objSpaceCameraPos - v.xyz;
}

#define tex2D(a,b) a.Sample(SamplerLinearWrap,(b).xy).rgba
#define texCUBE(a,b) a.SampleLevel(SamplerCubeMap,(b).xyz,0.0f).rgba
#define texCUBElod(a,b) a.SampleLevel(SamplerCubeMap,(b).xyz,(b).w).rgba

float3 UnpackNormal(float4 packednormal)
{
	// 不打算支持DXT5了
	return packednormal.xyz * 2 - 1;
}

float3 RGBMDecode ( float4 rgbm, float hdrExp, float gammaExp ) 
{
	float3 upackRGBhdr = (rgbm.bgr * rgbm.a) * hdrExp;
	float3 rgbLin = pow(upackRGBhdr.rgb, gammaExp);
	return rgbLin;
}


#endif