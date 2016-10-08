Shader "Hidden/FisheyeShader" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "" {}
	}
	
	// Shader code pasted into all further CGPROGRAM blocks
	CGINCLUDE
	
	#include "UnityCG.cginc"
	
	struct v2f {
		float4 pos : SV_POSITION;
		float2 uv : TEXCOORD0;
	};
	
	sampler2D _MainTex;
	half4 _MainTex_ST;

	float2 intensity;
	
	v2f vert( appdata_img v ) 
	{
		v2f o;
		o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
		o.uv = v.texcoord.xy;
		return o;
	} 
	
	half4 frag(v2f i) : SV_Target 
	{
		half2 coords = i.uv;
		coords = (coords - 0.5) * 2.0;		
		
		half2 realCoordOffs;
		realCoordOffs.x = (1-coords.y * coords.y) * intensity.y * (coords.x); 
		realCoordOffs.y = (1-coords.x * coords.x) * intensity.x * (coords.y);
		
		half4 color = tex2D (_MainTex, UnityStereoScreenSpaceUVAdjust(i.uv - realCoordOffs, _MainTex_ST));
		
		return color;
	}

	ENDCG 
	
Subshader {
 // but before any other overlays
       
       // Tags {"Queue" = "Overlay-10" }
       
        // Turn off lighting, because it's expensive and the thing is supposed to be
        // invisible anyway.
       
        Lighting Off

        // Draw into the depth buffer in the usual way.  This is probably the default,
        // but it doesn't hurt to be explicit.

        ZTest Always
        ZWrite On

        // Draw black background into the RGBA channel
		Color (0,0,0,0)
        ColorMask RGBA

		// compare stencil buffer		
		Stencil {
			Ref 0
			Comp Equal
		}

        // Do nothing specific in the pass:

        Pass {}
}

Fallback off
	
} // shader
