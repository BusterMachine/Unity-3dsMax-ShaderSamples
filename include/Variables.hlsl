#ifndef MAXHLSL_VARIABLE_HLSL
#define MAXHLSL_VARIABLE_HLSL

cbuffer UpdatePerFrame : register(b0){
    // 时间滑块值
    float Max_Time : Time;

    // 一些矩阵
    float4x4 Max_M : World;
    float4x4 Max_M_I : WorldInverse;
    float4x4 Max_VP : ViewProjection;
    float4x4 Max_P : Projection;
    float4x4 Max_V : View;
    float4x4 Max_V_I : ViewInverse;
    float4x4 Max_MVP : WorldViewProjection;
    float4x4 Max_MV : WorldView;
    float4x4 Max_MV_T : WorldViewTranspose;
    float4x4 Max_MV_I_T : WORLDVIEWIT;
    float4 Max_CamPosW : WORLD_CAMERA_POSITION;
}


// 纯粹是为了对齐unity
#if 1
    // 注意row与colum的转换
    #define glstate_matrix_projection  transpose(Max_P) 
    #define unity_MatrixV transpose(Max_V) 
    #define unity_MatrixInvV transpose(Max_V_I) 
    #define unity_MatrixVP transpose(Max_VP) 
    #define unity_ObjectToWorld transpose(Max_M) 
    #define unity_WorldToObject transpose(Max_M_I)

    #define UNITY_MATRIX_P glstate_matrix_projection
    #define UNITY_MATRIX_V unity_MatrixV
    #define UNITY_MATRIX_I_V unity_MatrixInvV
    #define UNITY_MATRIX_VP unity_MatrixVP
    #define UNITY_MATRIX_M unity_ObjectToWorld

    #define _WorldSpaceCameraPos Max_CamPosW.xyz   

    #define _Time float4(Max_Time / 20,Max_Time,Max_Time + Max_Time,Max_Time + Max_Time + Max_Time)

    #define unity_MatrixMVP transpose(Max_MVP)
    #define unity_MatrixMV transpose(Max_MV)
    #define unity_MatrixTMV transpose(Max_MV_T)
    #define unity_MatrixITMV transpose(WORLDVIEWIT)

    #define UNITY_MATRIX_MVP unity_MatrixMVP
    #define UNITY_MATRIX_MV  unity_MatrixMV
    #define UNITY_MATRIX_T_MV  unity_MatrixTMV
    #define UNITY_MATRIX_IT_MV  unity_MatrixITMV
#endif

#endif
