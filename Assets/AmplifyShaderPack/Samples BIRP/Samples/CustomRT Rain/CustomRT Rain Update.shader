// Made with Amplify Shader Editor v1.9.9.7
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AmplifyShaderPack/CustomRT Rain Update"
{
	Properties
	{
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#pragma target 3.5
		#define ASE_VERSION 19907
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			half filler;
		};


		float Hash12( float2 pos, float hashScale )
		{
			float3 p3  = frac(float3(pos.xyx) * hashScale);
			p3 += dot(p3, p3.yzx + 19.19);
			return frac((p3.x + p3.y) * p3.z);
		}


		float Hash22( float2 pos, float3 hashScale3 )
		{
			float3 p3 = frac(float3(pos.xyx) * hashScale3);
			p3 += dot(p3, p3.yzx+19.19);
			return frac((p3.xx+p3.yz)*p3.zy);
		}


		void CalculateRipples( float resolution, float2 uv, int maxRadius, float time, float hashScale, float3 hashScale3, float IntensityScale, out float2 rippleUVOffset, out float rippleIntensity )
		{
			uv *= resolution;
			float2 p0 = floor(uv);
			float2 circles = float2(0,0);
			float maxRadiusf = maxRadius;
			for (int j = -maxRadius; j <= maxRadius; ++j)
			{
				for (int i = -maxRadius; i <= maxRadius; ++i)
				{
					float2 pi = p0 + float2(i, j);
					#if DOUBLE_HASH
					float2 hsh = Hash22(pi,hashScale3);
					#else
					float2 hsh = pi;
					#endif
					float2 p = pi + Hash22(hsh,hashScale3);
					float t = frac(0.3*time + Hash12(hsh,hashScale));
					float2 v = p - uv;
					float d = length(v) - (maxRadiusf + 1.0)*t;
					float h = 1e-3;
					float d1 = d - h;
					float d2 = d + h;
					float p1 = sin(31.*d1) * smoothstep(-0.6, -0.3, d1) * smoothstep(0.0, -0.3, d1);
					float p2 = sin(31.*d2) * smoothstep(-0.6, -0.3, d2) * smoothstep(0.0, -0.3, d2);
					circles += 0.5 * normalize(v) * ((p2 - p1) / (2 * h) * (1.0 - t) * (1.0 - t));
				}
			}
			circles /= float((maxRadiusf*2.0+1.0)*(maxRadiusf*2.0+1.0));
			float intensity = lerp(0.01, 0.15, smoothstep(0.1, 0.6, abs(frac(0.05*time + 0.5)*2.0-1.0)));
			float3 n = float3(circles, sqrt(1.0 - dot(circles, circles)));
			rippleUVOffset = intensity*n.xy;
			rippleIntensity = IntensityScale*pow(clamp(dot(n, normalize(float3(1.0, 0.7, 0.5))), 0.0, 1.0), 6.0);
			return;
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback Off
	CustomEditor "AmplifyShaderEditor.MaterialInspector"
}
/*ASEBEGIN
Version=19907
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;19;-668.1813,58.74764;Float;False;Property;_TimeScale;Time Scale;2;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;13;-476.2354,-106.7111;Float;False;Property;_Resolution;Resolution;0;0;Create;True;0;0;0;False;0;False;1;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;15;-477.3196,-14.1702;Float;False;Property;_MaxRadius;Max Radius;1;0;Create;True;0;0;0;False;0;False;2;2;False;0;0;0;1;INT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;12;-713.1935,-76.62443;Inherit;False;1;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;16;-494.0656,60.1933;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;17;-485.1784,130.7374;Float;False;Constant;_Float3;Float 3;1;0;Create;True;0;0;0;False;0;False;0.1031;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;18;-507.0694,207.9735;Float;False;Constant;_Vector0;Vector 0;1;0;Create;True;0;0;0;False;0;False;0.1031,0.103,0.0973;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;22;-507.0617,356.0229;Inherit;False;Property;_RippleIntensity;Ripple Intensity;3;0;Create;True;0;0;0;False;0;False;0;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;8;-272,-128;Float;False;uv *= resolution@$float2 p0 = floor(uv)@$float2 circles = float2(0,0)@$float maxRadiusf = maxRadius@$for (int j = -maxRadius@ j <= maxRadius@ ++j)${$	for (int i = -maxRadius@ i <= maxRadius@ ++i)$	{$		float2 pi = p0 + float2(i, j)@$		#if DOUBLE_HASH$		float2 hsh = Hash22(pi,hashScale3)@$		#else$		float2 hsh = pi@$		#endif$		float2 p = pi + Hash22(hsh,hashScale3)@$$		float t = frac(0.3*time + Hash12(hsh,hashScale))@$		float2 v = p - uv@$		float d = length(v) - (maxRadiusf + 1.0)*t@$$		float h = 1e-3@$		float d1 = d - h@$		float d2 = d + h@$		float p1 = sin(31.*d1) * smoothstep(-0.6, -0.3, d1) * smoothstep(0.0, -0.3, d1)@$		float p2 = sin(31.*d2) * smoothstep(-0.6, -0.3, d2) * smoothstep(0.0, -0.3, d2)@$		circles += 0.5 * normalize(v) * ((p2 - p1) / (2 * h) * (1.0 - t) * (1.0 - t))@$	}$}$circles /= float((maxRadiusf*2.0+1.0)*(maxRadiusf*2.0+1.0))@$$float intensity = lerp(0.01, 0.15, smoothstep(0.1, 0.6, abs(frac(0.05*time + 0.5)*2.0-1.0)))@$float3 n = float3(circles, sqrt(1.0 - dot(circles, circles)))@$rippleUVOffset = intensity*n.xy@$rippleIntensity = IntensityScale*pow(clamp(dot(n, normalize(float3(1.0, 0.7, 0.5))), 0.0, 1.0), 6.0)@$return@$;8;Create;9;True;resolution;FLOAT;0;In;;Float;False;True;uv;FLOAT2;0,0;In;;Float;False;True;maxRadius;INT;0;In;;Float;False;True;time;FLOAT;0;In;;Float;False;True;hashScale;FLOAT;0;In;;Float;False;True;hashScale3;FLOAT3;0,0,0;In;;Float;False;True;IntensityScale;FLOAT;0;In;;Inherit;False;True;rippleUVOffset;FLOAT2;0,0;Out;;Float;False;True;rippleIntensity;FLOAT;0;Out;;Float;False;CalculateRipples;False;True;2;6;7;;False;10;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT2;0,0;False;3;INT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT;0;False;8;FLOAT2;0,0;False;9;FLOAT;0;False;3;FLOAT;0;FLOAT2;9;FLOAT;10
Node;AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;10;64.19357,-101.3532;Inherit;False;FLOAT4;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StickyNoteNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;23;66.81777,-247.0343;Inherit;False;337.828;100;Rain ripple effect based on;;0,0,0,1; https://www.shadertoy.com/view/ldfyzl;0;0
Node;AmplifyShaderEditor.CustomExpressionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;6;-264.6907,-225.2016;Float;False;float3 p3  = frac(float3(pos.xyx) * hashScale)@$p3 += dot(p3, p3.yzx + 19.19)@$return frac((p3.x + p3.y) * p3.z)@;1;Create;2;True;pos;FLOAT2;0,0;In;;Float;False;True;hashScale;FLOAT;0;In;;Float;False;Hash12;False;True;0;;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;7;-266.2346,-319.4936;Float;False;float3 p3 = frac(float3(pos.xyx) * hashScale3)@$p3 += dot(p3, p3.yzx+19.19)@$return frac((p3.xx+p3.yz)*p3.zy)@;1;Create;2;True;pos;FLOAT2;0,0;In;;Float;False;True;hashScale3;FLOAT3;0,0,0;In;;Float;False;Hash22;False;True;0;;False;2;0;FLOAT2;0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;24;212.1444,-102.355;Float;False;True;-1;3;AmplifyShaderEditor.MaterialInspector;0;0;Standard;AmplifyShaderPack/CustomRT Rain Update;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;0;False;;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;16;0;19;0
WireConnection;8;1;13;0
WireConnection;8;2;12;0
WireConnection;8;3;15;0
WireConnection;8;4;16;0
WireConnection;8;5;17;0
WireConnection;8;6;18;0
WireConnection;8;7;22;0
WireConnection;10;0;8;9
WireConnection;10;3;8;10
ASEEND*/
//CHKSM=AFD545E2D385B4DCAEA7456C90CEECE057B570C5