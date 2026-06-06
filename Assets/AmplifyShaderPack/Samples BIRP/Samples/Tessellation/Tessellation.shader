// Made with Amplify Shader Editor v1.9.9.7
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AmplifyShaderPack/Tessellation"
{
	Properties
	{
		[Enum(Front,2,Back,1,Both,0)] _Cull( "Render Face", Int ) = 2
		[Header(DISPLACEMENT HEIGHT MAPPING)][SingleLineTexture][Space(10)] _ParallaxMap( "Displacement Map", 2D ) = "black" {}
		[SingleLineTexture] _ParallaxMapMask( "Displacement Mask Map", 2D ) = "white" {}
		_DisplacementStrength( "Strength", Range( 0, 1 ) ) = 1
		[Header(TESSELLATION)][Space(10)] _TessellationStrength( "Tessellation Strength", Range( 0.0001, 100 ) ) = 1
		_TessellationDistanceMin( "Tessellation Distance Min", Float ) = 0
		_TessellationDistanceMax( "Tessellation Distance Max ", Float ) = 25
		[MainColor][Space(15)] _Color( "Base Color", Color ) = ( 1, 1, 1, 1 )
		_Brightness( "Brightness", Range( 0, 2 ) ) = 1
		[SingleLineTexture][MainTexture][Space(10)] _MainTex( "Base Map", 2D ) = "white" {}
		_MainTex_ST( "Main UVs", Vector ) = ( 1, 1, 0, 0 )
		[SingleLineTexture] _MetallicGlossMap( "Metallic Map", 2D ) = "white" {}
		_Metallic( "Metallic", Range( 0, 1 ) ) = 0
		[Enum(MetallicAlpha,0,AlbedoAlpha,1)][Space(10)] _SmoothnesstexturechannelM( "Smoothness texture channel", Float ) = 0
		_GlossMapScale( "Smoothness", Range( 0, 1 ) ) = 0
		[SingleLineTexture][Space(10)] _OcclusionMap( "Occlusion Map", 2D ) = "white" {}
		_OcclusionStrength( "Occlusion Strength", Range( 0, 1 ) ) = 0
		[Enum(Flip,0,Mirror,1,None,2)][Space(15)] _DoubleSidedNormalMode( "Normal Mode", Float ) = 2
		[Normal][SingleLineTexture] _BumpMap( "Normal Map", 2D ) = "bump" {}
		_BumpScale( "Normal Scale", Float ) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull [_Cull]
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#define ASE_VERSION 19907
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float2 uv_texcoord;
			uint ASEIsFrontFace : SV_IsFrontFace;
		};

		uniform int _Cull;
		uniform sampler2D _ParallaxMap;
		uniform float4 _ParallaxMap_ST;
		uniform half _DisplacementStrength;
		uniform sampler2D _ParallaxMapMask;
		uniform float4 _ParallaxMapMask_ST;
		uniform sampler2D _BumpMap;
		uniform float4 _MainTex_ST;
		uniform float _BumpScale;
		uniform float _DoubleSidedNormalMode;
		uniform float4 _Color;
		uniform sampler2D _MainTex;
		uniform half _Brightness;
		uniform float _Metallic;
		uniform sampler2D _MetallicGlossMap;
		uniform float _SmoothnesstexturechannelM;
		uniform float _GlossMapScale;
		uniform sampler2D _OcclusionMap;
		uniform float _OcclusionStrength;
		uniform half _TessellationDistanceMin;
		uniform half _TessellationDistanceMax;
		uniform half _TessellationStrength;


		float3 _NormalModefloat3switch( float m_switch, float3 m_Flip, float3 m_Mirror, float3 m_None )
		{
			switch (m_switch) {
				case 0:
					return m_Flip;
				case 1:
					return m_Mirror;
				default:
				case 2:
					return m_None;
			}
		}


		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityDistanceBasedTess( v0.vertex, v1.vertex, v2.vertex, _TessellationDistanceMin,_TessellationDistanceMax,_TessellationStrength);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float3 ase_normalOS = v.normal.xyz;
			float2 uv_ParallaxMap = v.texcoord * _ParallaxMap_ST.xy + _ParallaxMap_ST.zw;
			float2 uv_ParallaxMapMask = v.texcoord * _ParallaxMapMask_ST.xy + _ParallaxMapMask_ST.zw;
			v.vertex.xyz += ( ( ase_normalOS * ( (tex2Dlod( _ParallaxMap, float4( uv_ParallaxMap, 0, 0.0) )).rgb * _DisplacementStrength ) ) * (tex2Dlod( _ParallaxMapMask, float4( uv_ParallaxMapMask, 0, 0.0) )).rgb );
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 appendResult2941_g2 = (float2(_MainTex_ST.x , _MainTex_ST.y));
			float2 appendResult2944_g2 = (float2(_MainTex_ST.z , _MainTex_ST.w));
			float2 UV__MainTex_ST585_g2 = ( ( i.uv_texcoord * appendResult2941_g2 ) + appendResult2944_g2 );
			float m_switch3729_g2 = _DoubleSidedNormalMode;
			float3 m_Flip3729_g2 = float3( -1, -1, -1 );
			float3 m_Mirror3729_g2 = float3( 1, 1, -1 );
			float3 m_None3729_g2 = float3( 1, 1, 1 );
			float3 local_NormalModefloat3switch3729_g2 = _NormalModefloat3switch( m_switch3729_g2 , m_Flip3729_g2 , m_Mirror3729_g2 , m_None3729_g2 );
			float3 switchResult3728_g2 = (((i.ASEIsFrontFace>0)?(UnpackScaleNormal( tex2D( _BumpMap, UV__MainTex_ST585_g2 ), _BumpScale )):(( UnpackScaleNormal( tex2D( _BumpMap, UV__MainTex_ST585_g2 ), _BumpScale ) * local_NormalModefloat3switch3729_g2 ))));
			o.Normal = switchResult3728_g2;
			float4 temp_output_2_0_g61680 = tex2D( _MainTex, UV__MainTex_ST585_g2 );
			o.Albedo = ( (_Color).rgb * (temp_output_2_0_g61680).rgb * _Brightness );
			float4 tex2DNode606_g2 = tex2D( _MetallicGlossMap, UV__MainTex_ST585_g2 );
			o.Metallic = ( _Metallic * (tex2DNode606_g2).rgb ).x;
			float Alpha_MetallicGlossMap635_g2 = tex2DNode606_g2.a;
			float temp_output_2424_6_g2 = (temp_output_2_0_g61680).a;
			float Alpha_BaseColor634_g2 = temp_output_2424_6_g2;
			float lerpResult4312_g2 = lerp( Alpha_MetallicGlossMap635_g2 , Alpha_BaseColor634_g2 , _SmoothnesstexturechannelM);
			o.Smoothness = saturate( ( lerpResult4312_g2 * _GlossMapScale ) );
			float temp_output_681_0_g2 = saturate( (tex2D( _OcclusionMap, UV__MainTex_ST585_g2 ).r*_OcclusionStrength + ( 1.0 - _OcclusionStrength )) );
			o.Occlusion = temp_output_681_0_g2;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback Off
	CustomEditor "AmplifyShaderEditor.MaterialInspector"
}
/*ASEBEGIN
Version=19907
Node;AmplifyShaderEditor.TexturePropertyNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;39;-1980.083,570.521;Inherit;True;Property;_ParallaxMapMask;Displacement Mask Map;2;1;[SingleLineTexture];Create;False;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;False;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;32;-1967.263,301.7405;Inherit;True;Property;_ParallaxMap;Displacement Map;1;2;[Header];[SingleLineTexture];Create;False;1;DISPLACEMENT HEIGHT MAPPING;0;0;False;1;Space(10);False;None;None;False;black;Auto;Texture2D;False;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;40;-1663.084,567.521;Inherit;True;Property;_TextureSample1;Texture Sample 1;9;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;False;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SwizzleNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;41;-1311.865,569.9087;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;33;-1662.312,302.1247;Inherit;True;Property;_TextureSample3;Texture Sample 3;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;False;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;43;-677.205,603.1266;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwizzleNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;34;-1345.993,301.3852;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;35;-1329.052,402.2212;Half;False;Property;_DisplacementStrength;Strength;3;0;Create;False;1;;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;38;-1031.271,308.6256;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalVertexDataNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;37;-979.9257,155.0146;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;42;-606.7681,579.6476;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;36;-760.3162,285.5139;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;44;-593.9614,389.6817;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;48;-176,528;Half;False;Property;_TessellationDistanceMax;Tessellation Distance Max ;6;0;Create;False;1;;0;0;False;0;False;25;2000;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;49;-176,464;Half;False;Property;_TessellationDistanceMin;Tessellation Distance Min;5;0;Create;False;1;;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;50;-192,384;Half;False;Property;_TessellationStrength;Tessellation Strength;4;1;[Header];Create;False;1;TESSELLATION;0;0;False;1;Space(10);False;1;0.5;0.0001;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;22;-534.4835,281.497;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.IntNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;31;384,-80;Inherit;False;Property;_Cull;Render Face;0;1;[Enum];Create;False;1;;0;1;Front,2,Back,1,Both,0;True;0;False;2;0;False;0;0;0;1;INT;0
Node;AmplifyShaderEditor.DistanceBasedTessNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;47;96,384;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;53;0,-16;Inherit;False;Material Sample Lit BIRP;7;;2;fa2ac23eff248fb4081cb4ddc9dd8b32;15,4308,0,4310,0,4330,0,4322,1,4326,1,3839,0,3370,0,4031,0,3255,0,3257,0,4545,0,4548,0,4580,0,4581,0,4582,0;0;12;FLOAT3;2986;FLOAT3;2985;FLOAT3;3073;FLOAT3;4307;FLOAT;2991;FLOAT;2992;FLOAT3;2989;FLOAT;2987;FLOAT;2988;FLOAT;3667;FLOAT3;3646;FLOAT3;3645
Node;AmplifyShaderEditor.StandardSurfaceOutputNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;29;384,0;Float;False;True;-1;6;AmplifyShaderEditor.MaterialInspector;0;0;Standard;AmplifyShaderPack/Tessellation;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;0;False;;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;True;_Cull;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;45;-2137.207,6.530386;Inherit;False;1772.622;815.522;DISPLACEMENT HEIGHT MAPPING;0;;0,0,0,1;0;0
WireConnection;40;0;39;0
WireConnection;40;7;32;1
WireConnection;41;0;40;0
WireConnection;33;0;32;0
WireConnection;33;7;32;1
WireConnection;43;0;41;0
WireConnection;34;0;33;0
WireConnection;38;0;34;0
WireConnection;38;1;35;0
WireConnection;42;0;43;0
WireConnection;36;0;37;0
WireConnection;36;1;38;0
WireConnection;44;0;42;0
WireConnection;22;0;36;0
WireConnection;22;1;44;0
WireConnection;47;0;50;0
WireConnection;47;1;49;0
WireConnection;47;2;48;0
WireConnection;29;0;53;2986
WireConnection;29;1;53;2985
WireConnection;29;3;53;4307
WireConnection;29;4;53;2991
WireConnection;29;5;53;2992
WireConnection;29;11;22;0
WireConnection;29;14;47;0
ASEEND*/
//CHKSM=8B409C120A60B8C9332E4BCB089B647107214D1F