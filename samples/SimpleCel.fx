// 简单的Cel渲染
#include "../include/Api.hlsl"

// 参数区
#if 1
Texture2D <float4> _AlbedoTexture < 
    string UIName = "Albedo Texture";
    string ResourceType = "2D";
>;

float4 _Color<
    string UIName = "Color";
    string UIWidget = "Color";
> = float4( 1, 1, 1, 1 );

float4 _AmbientColor<
    string UIName = "Ambient Color";
    string UIWidget = "Color";
> = float4( 0.4, 0.4, 0.4, 1 );

float4 _SpecularColor<
    string UIName = "Specular Color";
    string UIWidget = "Color";
> = float4( 0.9,0.9,0.9,1.0);

float _Glossiness<
    string UIName = "Glossiness";
    string UIWidget = "slider";
    float UIMin = 1;
    float UIMax = 64;
    float UIStep = 1;
> = 16;		

float4 _RimColor<
    string UIName = "Rim Color";
    string UIWidget = "Color";
> = float4(1,1,1,1);

float _RimAmount<
    string UIName = "Rim Amount";
    string UIWidget = "slider";
    float UIMin = 0;
    float UIMax = 1;
    float UIStep = 0.001;
> = 0.716;	

float _RimThreshold<
    string UIName = "Rim Threshold";
    string UIWidget = "slider";
    float UIMin = 0;
    float UIMax = 1;
    float UIStep = 0.001;
> = 0.1;		

float4 _LightDir : Direction <  
    string UIName = "Light Direction"; 
    string Object = "TargetLight";
    int RefID = 0;
> = {-0.577, -0.577, 0.577,1.0};

float3 _LightColor
<
    string UIName =  "Light Color";
    string UIWidget = "Color";
> = float3(1.0f, 1.0f, 1.0f);

#endif

struct appdata
{
    float4 vertex : POSITION;				
    float4 uv : TEXCOORD0;
    float3 normal : NORMAL;
};

struct v2f {
    float4 pos : SV_POSITION;
    float3 worldNormal : NORMAL;
    float2 uv : TEXCOORD0;
    float3 viewDir : TEXCOORD1;
};

v2f vert(appdata v) {
    v2f o;

    o.pos = UnityObjectToClipPos(v.vertex);
    o.worldNormal = UnityObjectToWorldNormal(v.normal);		
    o.viewDir = WorldSpaceViewDir(v.vertex);
    o.uv = v.uv;

    return o;
}

float4 frag(v2f i) : SV_Target {

    float3 normal = normalize(i.worldNormal);
    float3 viewDir = normalize(i.viewDir);
    float NdotL = max(0,dot(_LightDir, normal));
    float lightIntensity = smoothstep(0, 0.01, NdotL);	
    float4 light = lightIntensity * float4(_LightColor,1.0f);
    float3 halfVector = normalize(_LightDir + viewDir);
    float NdotH = dot(normal, halfVector);

    float specularIntensity = pow(NdotH * lightIntensity, _Glossiness * _Glossiness);
    float specularIntensitySmooth = smoothstep(0.005, 0.01, specularIntensity);
    float4 specular = specularIntensitySmooth * _SpecularColor;	
    
    float rimDot = 1 - dot(viewDir, normal);
    float rimIntensity = rimDot * pow(NdotL, _RimThreshold);
    rimIntensity = smoothstep(_RimAmount - 0.01, _RimAmount + 0.01, rimIntensity);

    float4 rim = rimIntensity * _RimColor;
    float4 samplecolor = tex2D(_AlbedoTexture, i.uv).xyzw;

    return float4(((light + _AmbientColor + specular + rim) * _Color * samplecolor).xyz,1.0);
}

RasterizerState CullOff
{
    FillMode = SOLID;
    CullMode = NONE;
    FrontCounterClockwise = false;
};

fxgroup dx11{
    technique11 Main{
        pass p0
        {
            SetRasterizerState(CullOff);
            SetVertexShader(CompileShader(vs_5_0,vert()));
            SetPixelShader(CompileShader(ps_5_0,frag()));
        }
    }
}
