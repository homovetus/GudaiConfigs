// Original shader collected from: https://www.shadertoy.com/view/WsVSzV
// Modified by April Hall (arithefirst)
// Further modified for Light Theme compatibility

float warp = 0.25;         // Curvature amount
float scan = 0.50;         // Darkness of scanlines
float scan_density = 0.5;  // Scanline spacing
float bloom_strength = 0.3;// REDUCED slightly to prevent total washout
float aberration = 0.005;  // Color separation

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    // --- 1. COORDINATE SETUP ---
    vec2 uv = fragCoord / iResolution.xy;
    vec2 dc = abs(0.5 - uv);
    dc *= dc;

    // Warp coordinates
    uv.x -= 0.5; uv.x *= 1.0 + (dc.y * (0.3 * warp)); uv.x += 0.5;
    uv.y -= 0.5; uv.y *= 1.0 + (dc.x * (0.4 * warp)); uv.y += 0.5;

    // Boundary Check (Black outside screen)
    if (uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0) {
        fragColor = vec4(0.0, 0.0, 0.0, 1.0);
        return;
    }

    // --- 2. CHROMATIC ABERRATION ---
    float r = texture(iChannel0, uv + vec2(aberration * dc.x, 0.0)).r;
    float g = texture(iChannel0, uv).g;
    float b = texture(iChannel0, uv - vec2(aberration * dc.x, 0.0)).b;
    vec3 color = vec3(r, g, b);

    // --- 3. BLOOM (Add Glow) ---
    vec3 blur = texture(iChannel0, uv).rgb;
    blur += texture(iChannel0, uv + vec2(0.004, 0.0)).rgb;
    blur += texture(iChannel0, uv - vec2(0.004, 0.0)).rgb;
    blur += texture(iChannel0, uv + vec2(0.0, 0.004)).rgb;
    blur += texture(iChannel0, uv - vec2(0.0, 0.004)).rgb;
    blur /= 5.0;

    color += blur * bloom_strength;

    // --- 4. TONE MAPPING / CLAMP (Crucial Fix for Light Theme) ---
    // We force the color to stay within 0.0 to 1.0.
    // Without this, the scanlines darken "1.5" to "1.2", which is still pure white.
    color = clamp(color, 0.0, 1.0);

    // --- 5. SCANLINES ---
    // I increased the multiplier from 0.25 to 0.35 to make lines clearer on white
    float apply = abs(sin(fragCoord.y * scan_density) * 0.35 * scan);

    // --- 6. VIGNETTE ---
    float vig = (0.0 + 1.0*16.0*uv.x*uv.y*(1.0-uv.x)*(1.0-uv.y));
    color *= vec3(pow(vig, 0.15));

    // Mix scanlines
    fragColor = vec4(mix(color, vec3(0.0), apply), 1.0);
}
