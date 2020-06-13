#ifndef MAX_SHADOWMAP_HLSL
#define MAX_SHADOWMAP_HLSL

// TODO: ������Ӱ
// ò��ģ������Ӱ���㹻��
// û���˻���Max��ڳ���
// �Ƿ�������Ӱ��ͼ�ı�Ҫ��

#include "Common.hlsl"

struct shadow_v2f {
    float4 pos : SV_Position;
    float4 diff : TEXCOORD0;
};

shadow_v2f shadowGenVS(appdata_base v, uniform float4x4 shadowVP) {
    shadow_v2f o;
    float4 pos_world = mul(unity_ObjectToWorld,v.vertex);			
    float4 pos_light = mul(pos_world,shadowVP); 

    o.pos = pos_light;

#ifndef BLACK_SHADOW_PASS // �Ǵ�����Ӱ
    float3 N = UnityObjectToWorldNormal(v.normal);
    N = normalize(N);
    o.diff = float4(0.5 + 0.5 * N,1);
#else // ������Ӱ
    OUT.diff = float4(1,0,0,1);
#endif
    return OUT;
}

// ...

#endif