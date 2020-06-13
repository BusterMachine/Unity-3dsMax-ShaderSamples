#ifndef MAX_SHADOWMAP_HLSL
#define MAX_SHADOWMAP_HLSL

// TODO: 光照阴影
// 貌似模型自阴影就足够了
// 没有人会在Max里摆场景
// 是否有做阴影贴图的必要？

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

#ifndef BLACK_SHADOW_PASS // 非纯黑阴影
    float3 N = UnityObjectToWorldNormal(v.normal);
    N = normalize(N);
    o.diff = float4(0.5 + 0.5 * N,1);
#else // 纯黑阴影
    OUT.diff = float4(1,0,0,1);
#endif
    return OUT;
}

// ...

#endif