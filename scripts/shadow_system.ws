// Blitz FX NG - Shadow System Script
// Witcher 3: Next Gen Edition

class CShadowSystem extends CGameplayEntity
{
    private var shadowIntensity : Float;
    private var shadowSoftness : Float;
    private var shadowBias : Float;
    private var shadowDistance : Float;
    private var dynamicShadows : Bool;
    private var shadowCascades : Int;
    
    public function Initialize() : void
    {
        shadowIntensity = 0.8;
        shadowSoftness = 2.0;
        shadowBias = 0.001;
        shadowDistance = 50.0;
        dynamicShadows = true;
        shadowCascades = 4;
    }
    
    public function Update(deltaTime : Float) : void
    {
        UpdateShadowParameters(deltaTime);
    }
    
    private function UpdateShadowParameters(deltaTime : Float) : void
    {
        // Update shadow intensity based on time of day
        var hour : Int;
        hour = GetGameTime().GetHours();
        var newIntensity : Float;
        
        if (hour >= 18 || hour < 6)
        {
            // Night - softer shadows
            newIntensity = 0.4;
            shadowSoftness = Lerp(shadowSoftness, 3.0, deltaTime * 0.2);
        }
        else if (hour >= 12 && hour < 14)
        {
            // Noon - hard shadows
            newIntensity = 0.95;
            shadowSoftness = Lerp(shadowSoftness, 1.0, deltaTime * 0.2);
        }
        else
        {
            // Day - normal shadows
            newIntensity = 0.8;
            shadowSoftness = Lerp(shadowSoftness, 2.0, deltaTime * 0.2);
        }
        
        shadowIntensity = Lerp(shadowIntensity, newIntensity, deltaTime * 0.3);
        
        UpdateShadowQuality();
    }
    
    private function UpdateShadowQuality() : void
    {
        // Dynamic shadow quality optimization
        if (dynamicShadows)
        {
            var fps : Float;
            fps = GetGameTimeManager().GetFrameTime();
            
            if (fps > 60.0)
            {
                shadowCascades = 4;
            }
            else if (fps > 45.0)
            {
                shadowCascades = 3;
            }
            else
            {
                shadowCascades = 2;
            }
        }
    }
    
    public function SetShadowIntensity(intensity : Float) : void
    {
        shadowIntensity = ClampF(intensity, 0.0, 1.0);
    }
    
    public function SetShadowSoftness(softness : Float) : void
    {
        shadowSoftness = ClampF(softness, 0.5, 5.0);
    }
    
    public function SetShadowBias(bias : Float) : void
    {
        shadowBias = ClampF(bias, 0.0001, 0.01);
    }
    
    public function SetShadowDistance(distance : Float) : void
    {
        shadowDistance = ClampF(distance, 10.0, 200.0);
    }
    
    public function EnableDynamicShadows(enable : Bool) : void
    {
        dynamicShadows = enable;
    }
    
    public function GetShadowIntensity() : Float
    {
        return shadowIntensity;
    }
    
    public function GetShadowSoftness() : Float
    {
        return shadowSoftness;
    }
    
    public function GetShadowCascades() : Int
    {
        return shadowCascades;
    }
    
    public function CalculateShadowFactor(position : Vector, lightDirection : Vector) : Float
    {
        var distance : Float;
        var shadowFactor : Float;
        
        distance = VecDistance(position, GetPlayer().GetWorldPosition());
        
        if (distance > shadowDistance)
        {
            return 1.0;
        }
        
        shadowFactor = 1.0 - (distance / shadowDistance) * shadowIntensity;
        return shadowFactor;
    }
}