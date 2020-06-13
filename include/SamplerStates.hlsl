#ifndef MAX_STATES_HLSL
#define MAX_STATES_HLSL

// 贴图采样器

// 正常做法是需要使用那种采样器
// 再初始化该类型的着色器
// 这里为了方便
// 所有采样器全部初始化
// 不需要节约这点资源

SamplerState SamplerLinearClamp	
{																   
	Filter = MIN_MAG_MIP_LINEAR;								   
	AddressU = Clamp;											   
	AddressV = Clamp;											   
};

SamplerState SamplerLinearWrap	
{																  
	Filter = MIN_MAG_MIP_LINEAR;								   
	AddressU = Wrap;											    
	AddressV = Wrap;											  
};

SamplerState SamplerShadowDepth		
{																	
	Filter = MIN_MAG_MIP_POINT;										
	AddressU = Border;												
	AddressV = Border;												
	BorderColor = float4(1.0f, 1.0f, 1.0f, 1.0f);					
};

SamplerState SamplerAnisoClampUV	
{																	
    Filter = ANISOTROPIC;											
    AddressU = Clamp;											
    AddressV = Clamp;												
};		

SamplerState SamplerAnisoWrap			
{																	
    Filter = ANISOTROPIC;											
    AddressU = Wrap;												
    AddressV = Wrap;												
};	

SamplerState SamplerAnisoWrapU		
{																	
    Filter = ANISOTROPIC;											
    AddressU = Wrap;												
    AddressV = Clamp;												
};				

SamplerState SamplerAnisoWrapV		
{																	
    Filter = ANISOTROPIC;											
    AddressU = Clamp;												
    AddressV = Wrap;												
};	

SamplerState SamplerLinearWrapU			
{																	
	Filter = MIN_MAG_MIP_LINEAR;									
	AddressU = Wrap;												
	AddressV = Clamp;												
};			

SamplerState SamplerCubeMap                 
{                                                                
    Filter = ANISOTROPIC;                                           
    AddressU = Clamp;                                              
    AddressV = Clamp;                                               
    AddressW = Clamp;                                              
};


#endif