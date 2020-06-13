#include "../include/Api.hlsl"
#include "../include/PbrHelp.hlsl"
#include "../include/ToneMapping.hlsl"

// ������
#if 1
Texture2D <float4> _AlbedoMap < 
    string UIName = "Albedo Texture";
    string ResourceType = "2D";
>;

Texture2D <float4> _NormalMap < 
    string UIName = "Normal Texture";
    string ResourceType = "2D";
>;

Texture2D <float4> _AOMap < 
    string UIName = "AO Texture";
    string ResourceType = "2D";
>;

Texture2D <float4> _MetalRoughnessMap < 
    string UIName = "Metallic Roughness Texture";
    string ResourceType = "2D";
>;

Texture2D <float4> _EmissionMap < 
    string UIName = "Emissions Texture";
    string ResourceType = "2D";
>;


Texture2D <float4> _PrefilterMap < 
    string UIName = "PrefilterMap Texture";
    string ResourceType = "2D";
>;

Texture2D <float4> _BRDF < 
    string UIName = "BRDF Texture";
    string ResourceType = "2D";
>;


TextureCube _IrradianceMap : environment	
<																											
    string UIName ="Irradiance Map";					
    string ResourceType = "Cube";							
    int mipmaplevels = 0;																		
>;

float envLightingExp	
<															
    string UIWidget = "Slider";						
    float UIMin = 0.001;							
    float UISoftMax = 100.000;						
	float UIMax = 100.0f;	                        
    float UIStep = 0.001;							
    string UIName = "Env lighting Expose";											
> = 5.0f;

float emissionExp	
<															
    string UIWidget = "Slider";						
    float UIMin = 0.001;							
    float UISoftMax = 100.000;						
    float UIMax = 100.0f;	                        
    float UIStep = 0.001;							
    string UIName = "Emission Expose";											
> = 1.0f;

bool linearOutput	
<																										
    string UIName = "Linear";																					
> = true;

#endif

struct v2f
{
	float4 pos : SV_POSITION;
	float2 uv : TEXCOORD0;
	float4 worldPos : TEXCOORD1;
	float3 worldNormal : TEXCOORD2;
    float3x3 TWMtx	: TEXCOORD3_centroid;
};

v2f vert(appdata_full v)
{
	v2f o;

	o.pos = UnityObjectToClipPos(v.vertex);
	o.worldPos = mul(unity_ObjectToWorld,v.vertex);
	o.worldNormal = UnityObjectToWorldNormal(v.normal);	
	o.uv = v.texcoord;

    float3x3 tLocal;

    o.TWMtx[0] = UnityObjectToWorldNormal(v.tangent);
    o.TWMtx[1] = UnityObjectToWorldNormal(v.binormal);
    o.TWMtx[2] = o.worldNormal;

	return o;
}


float4 frag(v2f v) : SV_Target
{
// �����ɼ�
#if 1
    // ��������
    float3 albedo = pow(tex2D(_AlbedoMap, v.uv).rgb, 1.0f / 2.2f);
    float ao = tex2D(_AOMap, v.uv).r;
    float metallic = tex2D(_MetalRoughnessMap, v.uv).b;
    float roughness = tex2D(_MetalRoughnessMap, v.uv).g;

    // ���㷨��
    #if 1
        float3 tangentNormal = tex2D(_NormalMap, v.uv).xyz * 2.0f - 1.0f;
        float3 N = (tangentNormal.x * v.TWMtx[0] + tangentNormal.y * v.TWMtx[1]) + tangentNormal.z * v.TWMtx[2];
        N = normalize(N);
        // �ӽǷ���
        float3 V = normalize(_WorldSpaceCameraPos - v.worldPos);
        // �ӽǷ��䷽��
        float3 R = reflect(-V, N); 
    #endif

    // �Է���
    float3 emission = tex2D(_EmissionMap,v.uv).rgb;

    const float rMipCount = 4;
    float lod = rMipCount * roughness;

    float2 brdf  = tex2D(_BRDF, float2(max(dot(N, V), 0.0), roughness)).rg;
    float3 prefilteredColor = RGBMDecode(texCUBElod(_PrefilterMap, float4(R, lod)), envLightingExp, 1.0f/2.2f);
    float3 irradiance = RGBMDecode(texCUBE(_IrradianceMap, N), envLightingExp, 1.0f/2.2f);
#endif

    //���㷨������ʱ�ķ����� 
    float3 F0 = 0; 
    F0 = lerp(F0, albedo, metallic);

    // ambient lighting
    float3 F = FresnelSchlickRoughness(max(dot(N, V), 0.0), F0, roughness);

    float3 kS = F;
    float3 kD = 1.0 - kS;
    kD *= 1.0 - metallic;	  

    // ��������ɫ����
    float3 diffuse = irradiance * albedo;

    //����IBL���淴�䲿��
    float3 specular = prefilteredColor * (F * brdf.x + brdf.y);

    float3 ambient = (kD * diffuse + specular) * ao;
    float3 color = ambient + emission * emissionExp;

    // tonemapping
    color = reinhardExp(color, 1.3, linearOutput ? 1.0f/2.2f : 1/ pow(2.2f, 2));
	return float4(color,1.0f);
}

fxgroup dx11{
    technique11 Main{
        pass p0
        {
            SetVertexShader(CompileShader(vs_5_0,vert()));
            SetPixelShader(CompileShader(ps_5_0,frag()));
        }
    }
}