// Blitz FX NG - Water System Script
// Witcher 3: Next Gen Edition

class CWaterSystem extends CGameplayEntity
{
    private var waveAmplitude : Float;
    private var waveFrequency : Float;
    private var waveSpeed : Float;
    private var waterHeight : Float;
    private var waterColor : Color;
    private var foamColor : Color;
    private var waterTransparency : Float;
    private var time : Float;
    
    public function Initialize() : void
    {
        waveAmplitude = 0.5;
        waveFrequency = 0.3;
        waveSpeed = 2.0;
        waterHeight = 0.0;
        waterColor = new Color(0.2, 0.5, 0.8, 1.0);
        foamColor = new Color(0.9, 0.95, 1.0, 1.0);
        waterTransparency = 0.7;
        time = 0.0;
    }
    
    public function Update(deltaTime : Float) : void
    {
        time += deltaTime * waveSpeed;
        UpdateWaveParameters(deltaTime);
    }
    
    private function UpdateWaveParameters(deltaTime : Float) : void
    {
        // Update wave amplitude based on weather
        if (IsRaining())
        {
            waveAmplitude = Lerp(waveAmplitude, 0.8, deltaTime * 0.5);
        }
        else
        {
            waveAmplitude = Lerp(waveAmplitude, 0.5, deltaTime * 0.3);
        }
        
        UpdateTransparency();
    }
    
    private function UpdateTransparency() : void
    {
        // Dynamic transparency based on time of day
        var hour : Int;
        hour = GetGameTime().GetHours();
        
        if (hour >= 18 || hour < 6)
        {
            waterTransparency = 0.4;
        }
        else
        {
            waterTransparency = 0.7;
        }
    }
    
    public function GetWaveHeight(position : Vector) : Float
    {
        var wave1 : Float;
        var wave2 : Float;
        
        wave1 = SinApprox((position.X * waveFrequency + time) * 6.283);
        wave2 = SinApprox((position.Z * waveFrequency * 0.7 + time * 0.8) * 6.283);
        
        return (wave1 + wave2 * 0.7) * waveAmplitude;
    }
    
    public function SetWaveAmplitude(amplitude : Float) : void
    {
        waveAmplitude = ClampF(amplitude, 0.0, 2.0);
    }
    
    public function SetWaterColor(r : Float, g : Float, b : Float) : void
    {
        waterColor = new Color(r, g, b, 1.0);
    }
    
    public function GetWaterColor() : Color
    {
        return waterColor;
    }
    
    private function IsRaining() : Bool
    {
        return GetWeatherManager().IsRaining();
    }
    
    public function SinApprox(x : Float) : Float
    {
        var sin : Float;
        x = x - 6.283 * FloatFloor(x / 6.283);
        
        if (x < 3.141)
        {
            sin = 4 * x * (3.141 - x) / (3.141 * 3.141);
        }
        else
        {
            sin = 4 * (x - 3.141) * (6.283 - x) / (3.141 * 3.141);
        }
        
        return sin;
    }
}