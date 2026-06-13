// Blitz FX NG - Shadow Effect Shader
// Witcher 3: Next Gen Edition

cbuffer ShadowBuffer : register(b0)
{
    float4x4 matShadowView;
    float4x4 matShadowProj;
    float4x4 matWorldView;
    float shadowIntensity;
    float shadowSoftness;
    float shadowBias;
    float padding;
};

Texture2D shadowMap : register(t0);
Texture2D colorTexture : register(t1);
SamplerState samplerPoint : register(s0);
SamplerComparisonState shadowSampler : register(s1);

struct VS_INPUT
{
    float3 position : POSITION;
    float3 normal : NORMAL;
    float2 texCoord : TEXCOORD0;
};

struct PS_INPUT
{
    float4 position : SV_POSITION;
    float3 normal : NORMAL;
    float2 texCoord : TEXCOORD0;
    float4 shadowPos : TEXCOORD1;
    float3 worldPos : TEXCOORD2;
};

// Vertex Shader
PS_INPUT main_vs(VS_INPUT input)
{
    PS_INPUT output;
    
    output.position = mul(float4(input.position, 1.0), matWorldView);
    output.position = mul(output.position, matShadowProj);
    output.shadowPos = mul(float4(input.position, 1.0), matShadowView);
    output.shadowPos = mul(output.shadowPos, matShadowProj);
    output.normal = mul(input.normal, (float3x3)matWorldView);
    output.texCoord = input.texCoord;
    output.worldPos = input.position;
    
    return output;
}

// PCF Shadow Function
float pcfShadow(float4 shadowPos, Texture2D shadowMap, SamplerComparisonState shadowSampler)
{
    float3 projCoords = shadowPos.xyz / shadowPos.w;
    projCoords.x = projCoords.x * 0.5 + 0.5;
    projCoords.y = 1.0 - (projCoords.y * 0.5 + 0.5);
    
    if (projCoords.z > 1.0)
        return 1.0;
    
    float shadow = 0.0;
    float texelSize = shadowSoftness / 2048.0;
    
    for (int x = -2; x <= 2; ++x)
    {
        for (int y = -2; y <= 2; ++y)
        {
            float2 offset = float2(x, y) * texelSize;
            shadow += shadowMap.SampleCmp(shadowSampler, projCoords.xy + offset, projCoords.z - shadowBias);
        }
    }
    
    return shadow / 25.0;
}

// Pixel Shader
float4 main_ps(PS_INPUT input) : SV_TARGET
{
    float3 baseColor = colorTexture.Sample(samplerPoint, input.texCoord).rgb;
    
    // Calculate shadows
    float shadow = pcfShadow(input.shadowPos, shadowMap, shadowSampler);
    
    // Normalize normal
    float3 normal = normalize(input.normal);
    
    // Lighting with shadows
    float3 lightDir = normalize(float3(1.0, 1.0, 1.0));
    float NdotL = max(dot(normal, lightDir), 0.0);
    
    // Ambient lighting
    float3 ambient = baseColor * 0.3;
    
    // Diffuse lighting with shadows
    float3 diffuse = baseColor * NdotL * shadow;
    
    // Final lighting
    float3 finalColor = ambient + diffuse * shadowIntensity;
    
    return float4(finalColor, 1.0);
}