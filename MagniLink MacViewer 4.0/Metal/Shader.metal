//
//  Shader.metal
//  MagniLink MacViewer 4.0
//
//  Created by Erik Sandstrom on 2023-06-20.
//

#include <metal_stdlib>
using namespace metal;

struct UniformsFrame
{
    float4x4 modelViewMatrix;
    float3 color;
};

struct UniformsRender
{
    float4x4 modelViewMatrix;
};

struct UniformsRenderToTexture
{
    float4x4 modelViewMatrix;
    float3 backColor;
    float gain;
    float3 foreColor;
    float pn;
    float contrast;
    float brightness;
    bool artificial;
    bool grayscale;
    float reflineWidth;
    float reflinePosition;
    int reflineType;
    float3 reflineColor;
};

struct VertexIn
{
    float2 position [[attribute(0)]];
    float2 texCoord [[attribute(1)]];
};

struct VertexOut
{
    float4 position [[position]];
    float2 texCoord;
};

//RENDER
vertex VertexOut render_vertex(uint vertexID [[ vertex_id ]],
                            constant VertexIn* vertexIn [[buffer(0)]],
                            constant UniformsRender &uniforms [[buffer(1)]])
{
    VertexOut out;
    
    float2 pos = vertexIn[vertexID].position;
    out.position = uniforms.modelViewMatrix * float4(pos, 0.0, 1.0);

    out.texCoord = vertexIn[vertexID].texCoord;
    
    return out;
}

fragment half4 render_fragment(float2 texCoord [[stage_in]],
                              texture2d<half> colorTexture [[ texture(0) ]],
                              constant UniformsRender &uniforms [[buffer(1)]])
{
    constexpr sampler textureSampler (mag_filter::linear,
                                      min_filter::linear);

    half4 sample = colorTexture.sample(textureSampler, texCoord);
            
    return sample.xyzw;
}


//RENDER TO TEXTURE
vertex VertexOut render_to_texture_vertex(uint vertexID [[ vertex_id ]],
                            constant VertexIn* vertexIn [[buffer(0)]],
                            constant UniformsRenderToTexture &uniforms [[buffer(1)]])
{
    VertexOut out;
    
    float2 pos = vertexIn[vertexID].position;
    out.position = uniforms.modelViewMatrix * float4(pos, 0.0, 1.0);

    out.texCoord = vertexIn[vertexID].texCoord;
    
    return out;
}

fragment float4 render_to_texture_fragment(float2 texCoord [[stage_in]],
                              texture2d<float> colorTexture [[ texture(0) ]],
                              constant UniformsRenderToTexture &uniforms [[buffer(1)]])
{
    constexpr sampler textureSampler (mag_filter::linear,
                                      min_filter::linear);

    float4 sourceValue = colorTexture.sample(textureSampler, texCoord);
        
    float4 outValue;
    
    if(uniforms.artificial)
    {
        float intensity = 0.2989 * sourceValue.x + 0.5870 * sourceValue.y + 0.1140 * sourceValue.z;
        intensity = clamp((intensity - uniforms.pn * 0.95) * uniforms.gain, 0.0, 1.0);
        outValue = float4(uniforms.backColor * intensity + (1.0 - intensity) * uniforms.foreColor , 1.0);
    }
    else if(uniforms.grayscale)
    {
        float intensity = 0.2989 * sourceValue.x + 0.5870 * sourceValue.y + 0.1140 * sourceValue.z;
        intensity += (intensity - 0.5f) * max(uniforms.contrast, 0.0f);
        intensity += uniforms.brightness;
        outValue = float4(intensity, intensity, intensity, 1.0);
    }
    else
    {
        sourceValue.rgb += (sourceValue.rgb - 0.5f) * (0.1 + uniforms.contrast * 0.9);
        sourceValue.rgb += 0.2 + uniforms.brightness * 0.8;
        outValue = sourceValue;
    }
    
    if(uniforms.reflineType == 1)
    {
        outValue = uniforms.reflinePosition - uniforms.reflineWidth < texCoord.x && texCoord.x < uniforms.reflinePosition + uniforms.reflineWidth ? float4(uniforms.reflineColor, 1.0) : outValue;
    }
    else if(uniforms.reflineType == 2)
    {
        outValue = uniforms.reflinePosition - uniforms.reflineWidth < texCoord.y && texCoord.y < uniforms.reflinePosition + uniforms.reflineWidth ?  float4(uniforms.reflineColor, 1.0) : outValue;
    }
    else if(uniforms.reflineType == 3)
    {
        outValue = uniforms.reflinePosition < texCoord.x && texCoord.x < 1.0 - uniforms.reflinePosition ? outValue : float4(0.0, 0.0, 0.0, 1.0);
    }
    else if(uniforms.reflineType == 4)
    {
        outValue = uniforms.reflinePosition < texCoord.y && texCoord.y < 1.0 - uniforms.reflinePosition ? outValue : float4(0.0, 0.0, 0.0, 1.0);
    }
    
    return outValue;
}

vertex VertexOut color_vertex(uint vertexID [[ vertex_id ]],
                            constant VertexIn* vertexIn [[buffer(0)]],
                            constant UniformsFrame &uniforms [[buffer(1)]])
{
    VertexOut out;
    
    float2 pos = vertexIn[vertexID].position;
    out.position = uniforms.modelViewMatrix * float4(pos, 0.0, 1.0);

    out.texCoord = vertexIn[vertexID].texCoord;
    
    return out;
}

fragment half4 color_fragment(constant UniformsFrame &uniforms [[buffer(0)]])
{
    float3 out = uniforms.color;
    return half4(out.x,out.y,out.z,1.0);
}


