//
//  Shader.metal
//  MagniLink MacViewer 4.0
//
//  Created by Erik Sandstrom on 2023-06-20.
//

#include <metal_stdlib>
using namespace metal;

struct UniformsRender
{
    float4x4 modelViewMatrix;
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
            
    return sample.zyxw;
}

