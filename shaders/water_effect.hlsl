// Blitz FX NG - Water Effect Shader
// Witcher 3: Next Gen Edition

cbuffer TransformBuffer : register(b0)
{
    float4x4 matWorldViewProj;
    float4x4 matWorld;
    float4x4 matView;
};

cbuffer WaterBuffer : register(b1)
{
    float waterHeight;
    float waveAmplitude;
    float waveFrequency;
    float waveSpeed;
    float4 waterColor;
    float4 foamColor;
    float3 lightDirection;
    float waterTransparency;
};

Texture2D normalMap : register(t0);
Texture2D foamTexture : register(t1);
Texture2D reflectionMap : register(t2);
Texture2D refractionMap : register(t3);

SamplerState samplerLinear : register(s0);

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
    float3 worldPos : TEXCOORD1;
    float depth : TEXCOORD2;
};

// Vertex Shader
PS_INPUT main_vs(VS_INPUT input)
{
    PS_INPUT output;
    
    // Wave animation
    float wave = sin(input.position.x * waveFrequency + waveSpeed) * waveAmplitude;
    wave += sin(input.position.z * waveFrequency * 0.7 + waveSpeed * 0.8) * waveAmplitude * 0.7;
    
    float3 position = input.position;
    position.y += wave;
    
    float4 worldPos = mul(float4(position, 1.0), matWorld);
    output.worldPos = worldPos.xyz;
    output.position = mul(float4(position, 1.0), matWorldViewProj);
    output.normal = mul(input.normal, (float3x3)matWorld);
    output.texCoord = input.texCoord;
    output.depth = output.position.z;
    
    return output;
}

// Pixel Shader
float4 main_ps(PS_INPUT input) : SV_TARGET
{
    // Sample normals from normal map
    float3 normal = normalMap.Sample(samplerLinear, input.texCoord).xyz;
    normal = normalize(normal * 2.0 - 1.0);
    
    // Blend normals for waves
    float2 texCoord2 = input.texCoord + float2(0.5, 0.5);
    float3 normal2 = normalMap.Sample(samplerLinear, texCoord2).xyz;
    normal2 = normalize(normal2 * 2.0 - 1.0);
    normal = normalize(normal + normal2);
    
    // Lighting
    float NdotL = max(dot(normal, lightDirection), 0.0);
    float3 lighting = float3(0.3, 0.5, 0.8) * NdotL + float3(0.1, 0.1, 0.15);
    
    // Foam
    float foam = foamTexture.Sample(samplerLinear, input.texCoord * 0.5).r;
    foam *= max(0.0, 1.0 - input.depth * 0.001);
    
    // Reflection and refraction
    float3 reflection = reflectionMap.Sample(samplerLinear, input.texCoord).rgb;
    float3 refraction = refractionMap.Sample(samplerLinear, input.texCoord).rgb;
    
    // Color blending
    float3 waterColorFinal = waterColor.rgb * lighting;
    float3 finalColor = lerp(waterColorFinal, refraction, 0.3);
    finalColor = lerp(finalColor, reflection, 0.2);
    finalColor = lerp(finalColor, foamColor.rgb, foam * 0.5);
    
    return float4(finalColor, waterTransparency);
}