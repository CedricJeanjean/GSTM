// Common Stuff:
const string DEFAULT_LOG_NAME = Meta::ExecutingPlugin().Name;

void log(const string&in msg) { log(DEFAULT_LOG_NAME, msg); }
void log(const string&in name, const string&in msg) { print("[\\$669" + name + "\\$z] " + msg); }

vec4 ChangeBrightness(const vec4&in color, float factor) {
    float r = color.x;
    float g = color.y;
    float b = color.z;
    if (factor < 0) {
        factor = 1 + factor;
        r *= factor;
        g *= factor;
        b *= factor;
    } else {
        r = (1.0 - r) * factor + r;
        g = (1.0 - g) * factor + g;
        b = (1.0 - b) * factor + b;
    }
    return vec4(r,g,b,color.w);
}

bool IsInterfaceVisible(bool ignoreNotPlaying = false) {
    auto playground = GetApp().CurrentPlayground;
    if (playground is null || playground.Interface is null || playground.Interface.ManialinkPage is null)
        return ignoreNotPlaying;
    return !playground.Interface.ManialinkPage.IsHiddenExternal;
}
