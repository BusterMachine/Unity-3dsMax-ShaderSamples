// 采样一张纹理图并直接显示
#include "../include/Api.hlsl"

Texture2D <float4> _AlbedoTexture < 
	string UIName = "Albedo Texture";
	string ResourceType = "2D";
>;

struct v2f {
    float4 pos : SV_Position;
    float2 uv : TEXCOORD0;
};
 
v2f vert(appdata_img v) {
    v2f o;

    o.pos = UnityObjectToClipPos(v.vertex);
    o.uv = v.texcoord.xy;

    return o;
}

float4 frag(v2f v) : SV_Target {
    return float4(tex2D(_AlbedoTexture,v.uv.xy).xyz,1);
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