#version 330 core
in vec3 vFragPos;
in vec3 vNormal;
in vec2 vUV;

out vec4 fragColor;

uniform sampler2D tex0;
uniform vec3  lightPos;
uniform vec3  lightColor;
uniform float ambientStr;
uniform vec3  viewPos;
uniform float fogDensity;

void main()
{
    vec3 ambient = ambientStr * lightColor;

    vec3  norm     = normalize(vNormal);
    vec3  lightDir = normalize(lightPos - vFragPos);
    float diff     = max(dot(norm, lightDir), 0.0);

    float dist     = length(lightPos - vFragPos);
    float attn     = 1.0 / (1.0 + 0.14 * dist + 0.07 * dist * dist);

    vec3  diffuse  = diff * lightColor * attn;

    vec3  viewDir  = normalize(viewPos - vFragPos);
    vec3  halfDir  = normalize(lightDir + viewDir);
    float spec     = pow(max(dot(norm, halfDir), 0.0), 16.0);
    vec3  specular = spec * lightColor * 0.15 * attn;

    vec4 texColor = texture(tex0, vUV);
    vec3 result   = (ambient + diffuse + specular) * vec3(texColor);

    float fogFactor = exp(-fogDensity * dist);
    fogFactor       = clamp(fogFactor, 0.0, 1.0);
    vec3  fogColor  = vec3(0.04, 0.01, 0.08);

    result = mix(fogColor, result, fogFactor);

    fragColor = vec4(result, texColor.a);
}