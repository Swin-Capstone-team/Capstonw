// Made with Amplify Shader Editor v1.9.9.7
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AmplifyShaderPack/Orientation Based Sprite"
{
	Properties
	{
		_Spritesheet( "Spritesheet", 2D ) = "white" {}
		_Columns( "Columns", Float ) = 0
		_Rows( "Rows", Float ) = 0
		_AnimSpeed( "Anim Speed", Float ) = 0

	}

	SubShader
	{
		

		

		Tags { "RenderType"="Opaque" }

	LOD 0

		

		Blend Off
		AlphaToMask Off
		Cull Back
		ColorMask RGBA
		ZWrite On
		ZClip True
		ZTest LEqual
		Offset 0 , 0
		

		CGINCLUDE
			#pragma target 3.5
			// ensure rendering platforms toggle list is visible

			float4 ComputeClipSpacePosition( float2 screenPosNorm, float deviceDepth )
			{
				float4 positionCS = float4( screenPosNorm * 2.0 - 1.0, deviceDepth, 1.0 );
			#if UNITY_UV_STARTS_AT_TOP
				positionCS.y = -positionCS.y;
			#endif
				return positionCS;
			}
		ENDCG

		
		Pass
		{
			Name "Unlit"
			Tags { "LightMode"="ForwardBase" }

			CGPROGRAM
				#define _ALPHATEST_ON
				#define ASE_VERSION 19907

				#pragma vertex vert
				#pragma fragment frag
				#pragma multi_compile_instancing
				#include "UnityCG.cginc"

				#include "UnityShaderVariables.cginc"
				#define ASE_NEEDS_VERT_POSITION
				#define ASE_NEEDS_VERT_NORMAL
				#define ASE_NEEDS_TEXTURE_COORDINATES0


				struct appdata
				{
					float4 vertex : POSITION;
					half3 normal : NORMAL;
					float4 ase_tangent : TANGENT;
					float4 ase_texcoord : TEXCOORD0;
					UNITY_VERTEX_INPUT_INSTANCE_ID
				};

				struct v2f
				{
					float4 pos : SV_POSITION;
					float4 ase_texcoord : TEXCOORD0;
					UNITY_VERTEX_INPUT_INSTANCE_ID
					UNITY_VERTEX_OUTPUT_STEREO
				};

				uniform sampler2D _Spritesheet;
				uniform float _Rows;
				uniform float _Columns;
				uniform float _AnimSpeed;


				
				v2f vert( appdata v  )
				{
					UNITY_SETUP_INSTANCE_ID(v);
					v2f o;
					UNITY_INITIALIZE_OUTPUT(v2f,o);
					UNITY_TRANSFER_INSTANCE_ID(v,o);
					UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

					//Calculate new billboard vertex position and normal;
					float3 upCamVec = float3( 0, 1, 0 );
					float3 forwardCamVec = -normalize ( UNITY_MATRIX_V._m20_m21_m22 );
					float3 rightCamVec = normalize( UNITY_MATRIX_V._m00_m01_m02 );
					float4x4 rotationCamMatrix = float4x4( rightCamVec, 0, upCamVec, 0, forwardCamVec, 0, 0, 0, 0, 1 );
					v.normal = normalize( mul( float4( v.normal , 0 ), rotationCamMatrix )).xyz;
					v.ase_tangent.xyz = normalize( mul( float4( v.ase_tangent.xyz , 0 ), rotationCamMatrix )).xyz;
					v.vertex.x *= length( unity_ObjectToWorld._m00_m10_m20 );
					v.vertex.y *= length( unity_ObjectToWorld._m01_m11_m21 );
					v.vertex.z *= length( unity_ObjectToWorld._m02_m12_m22 );
					v.vertex.xyz = mul( float4( v.vertex.xyz, 0 ), rotationCamMatrix ).xyz;
					v.vertex.xyz = mul( unity_WorldToObject, float4( v.vertex.xyz, 0 ) ).xyz;
					float3 normalizeResult8_g12 = normalize( ( (float4( unity_ObjectToWorld[ 0 ][ 3 ], unity_ObjectToWorld[ 1 ][ 3 ], unity_ObjectToWorld[ 2 ][ 3 ], unity_ObjectToWorld[ 3 ][ 3 ] )).xyz - _WorldSpaceCameraPos ) );
					float3 break11_g12 = normalizeResult8_g12;
					float temp_output_41_0_g12 = _Rows;
					float temp_output_28_0_g12 = ( 1.0 / temp_output_41_0_g12 );
					float2 texCoord29_g12 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
					float2 temp_output_43_0_g12 = texCoord29_g12;
					float2 break44_g12 = temp_output_43_0_g12;
					float temp_output_45_0_g12 = _Columns;
					float2 appendResult36_g12 = (float2(( ( floor( ( ( atan2( break11_g12.z , break11_g12.x ) + UNITY_PI ) / ( 6.28318548202515 / temp_output_41_0_g12 ) ) ) * temp_output_28_0_g12 ) + ( temp_output_28_0_g12 * break44_g12.x ) ) , (( ( break44_g12.y + ( temp_output_45_0_g12 - fmod( ( 1.0 + round( ( _AnimSpeed * _Time.y ) ) ) , temp_output_45_0_g12 ) ) ) / temp_output_45_0_g12 )).x));
					float2 vertexToFrag37_g12 = appendResult36_g12;
					o.ase_texcoord.xy = vertexToFrag37_g12;
					
					
					//setting value to unused interpolator channels and avoid initialization warnings
					o.ase_texcoord.zw = 0;

					#ifdef ASE_ABSOLUTE_VERTEX_POS
						float3 defaultVertexValue = v.vertex.xyz;
					#else
						float3 defaultVertexValue = float3(0, 0, 0);
					#endif
					float3 vertexValue = 0;
					#ifdef ASE_ABSOLUTE_VERTEX_POS
						v.vertex.xyz = vertexValue;
					#else
						v.vertex.xyz += vertexValue;
					#endif
					v.vertex.w = 1;
					v.normal = v.normal;

					o.pos = UnityObjectToClipPos( v.vertex );

					#if defined( ASE_SHADOWS )
						UNITY_TRANSFER_SHADOW( o, v.texcoord );
					#endif
					return o;
				}

				half4 frag( v2f IN 
							#if defined( ASE_DEPTH_WRITE_ON )
								, out float outputDepth : SV_Depth
							#endif
				) : SV_Target
				{
					UNITY_SETUP_INSTANCE_ID( IN );
					UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

					float4 ScreenPosNorm = float4( IN.pos.xy * ( _ScreenParams.zw - 1.0 ), IN.pos.zw );
					float4 ClipPos = ComputeClipSpacePosition( ScreenPosNorm.xy, IN.pos.z ) * IN.pos.w;
					float4 ScreenPos = ComputeScreenPos( ClipPos );

					float2 vertexToFrag37_g12 = IN.ase_texcoord.xy;
					float4 temp_output_635_0 = tex2D( _Spritesheet, vertexToFrag37_g12 );
					

					float4 Color = float4( (temp_output_635_0).rgb , 0.0 );
					float Alpha = (temp_output_635_0).a;
					half AlphaClipThreshold = 0.45;
					half AlphaClipThresholdShadow = 0.5;

					#if defined( ASE_DEPTH_WRITE_ON )
						outputDepth = IN.pos.z;
					#endif

					#ifdef _ALPHATEST_ON
						clip( Alpha - AlphaClipThreshold );
					#endif

					return Color;
				}
			ENDCG
		}

		
		Pass
		{
			
			Name "ShadowCaster"
			Tags { "LightMode"="ShadowCaster" }
			ZWrite On
			ZTest LEqual
			AlphaToMask Off

			CGPROGRAM
				#define _ALPHATEST_ON
				#define ASE_VERSION 19907

				#pragma vertex vert
				#pragma fragment frag
				#pragma multi_compile_shadowcaster
				#ifndef UNITY_PASS_SHADOWCASTER
					#define UNITY_PASS_SHADOWCASTER
				#endif
				#include "HLSLSupport.cginc"
				#include "UnityShaderVariables.cginc"
				#include "UnityCG.cginc"
				#include "Lighting.cginc"
				#include "UnityPBSLighting.cginc"

				#define ASE_NEEDS_VERT_POSITION
				#define ASE_NEEDS_VERT_NORMAL
				#define ASE_NEEDS_TEXTURE_COORDINATES0


				struct appdata
				{
					float4 vertex : POSITION;
					half3 normal : NORMAL;
					float4 ase_tangent : TANGENT;
					float4 ase_texcoord : TEXCOORD0;
					UNITY_VERTEX_INPUT_INSTANCE_ID
				};

				struct v2f
				{
					V2F_SHADOW_CASTER;
					float4 ase_texcoord1 : TEXCOORD1;
					UNITY_VERTEX_INPUT_INSTANCE_ID
					UNITY_VERTEX_OUTPUT_STEREO
				};

				#ifdef UNITY_STANDARD_USE_DITHER_MASK
					sampler3D _DitherMaskLOD;
				#endif
				#ifdef ASE_TESSELLATION
					float _TessPhongStrength;
					float _TessValue;
					float _TessMin;
					float _TessMax;
					float _TessEdgeLength;
					float _TessMaxDisp;
				#endif

				uniform sampler2D _Spritesheet;
				uniform float _Rows;
				uniform float _Columns;
				uniform float _AnimSpeed;


				
				v2f vert( appdata v  )
				{
					UNITY_SETUP_INSTANCE_ID( v );
					v2f o;
					UNITY_INITIALIZE_OUTPUT( v2f, o );
					UNITY_TRANSFER_INSTANCE_ID( v, o );
					UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );

					//Calculate new billboard vertex position and normal;
					float3 upCamVec = float3( 0, 1, 0 );
					float3 forwardCamVec = -normalize ( UNITY_MATRIX_V._m20_m21_m22 );
					float3 rightCamVec = normalize( UNITY_MATRIX_V._m00_m01_m02 );
					float4x4 rotationCamMatrix = float4x4( rightCamVec, 0, upCamVec, 0, forwardCamVec, 0, 0, 0, 0, 1 );
					v.normal = normalize( mul( float4( v.normal , 0 ), rotationCamMatrix )).xyz;
					v.ase_tangent.xyz = normalize( mul( float4( v.ase_tangent.xyz , 0 ), rotationCamMatrix )).xyz;
					v.vertex.x *= length( unity_ObjectToWorld._m00_m10_m20 );
					v.vertex.y *= length( unity_ObjectToWorld._m01_m11_m21 );
					v.vertex.z *= length( unity_ObjectToWorld._m02_m12_m22 );
					v.vertex.xyz = mul( float4( v.vertex.xyz, 0 ), rotationCamMatrix ).xyz;
					v.vertex.xyz = mul( unity_WorldToObject, float4( v.vertex.xyz, 0 ) ).xyz;
					float3 normalizeResult8_g12 = normalize( ( (float4( unity_ObjectToWorld[ 0 ][ 3 ], unity_ObjectToWorld[ 1 ][ 3 ], unity_ObjectToWorld[ 2 ][ 3 ], unity_ObjectToWorld[ 3 ][ 3 ] )).xyz - _WorldSpaceCameraPos ) );
					float3 break11_g12 = normalizeResult8_g12;
					float temp_output_41_0_g12 = _Rows;
					float temp_output_28_0_g12 = ( 1.0 / temp_output_41_0_g12 );
					float2 texCoord29_g12 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
					float2 temp_output_43_0_g12 = texCoord29_g12;
					float2 break44_g12 = temp_output_43_0_g12;
					float temp_output_45_0_g12 = _Columns;
					float2 appendResult36_g12 = (float2(( ( floor( ( ( atan2( break11_g12.z , break11_g12.x ) + UNITY_PI ) / ( 6.28318548202515 / temp_output_41_0_g12 ) ) ) * temp_output_28_0_g12 ) + ( temp_output_28_0_g12 * break44_g12.x ) ) , (( ( break44_g12.y + ( temp_output_45_0_g12 - fmod( ( 1.0 + round( ( _AnimSpeed * _Time.y ) ) ) , temp_output_45_0_g12 ) ) ) / temp_output_45_0_g12 )).x));
					float2 vertexToFrag37_g12 = appendResult36_g12;
					o.ase_texcoord1.xy = vertexToFrag37_g12;
					
					
					//setting value to unused interpolator channels and avoid initialization warnings
					o.ase_texcoord1.zw = 0;

					#ifdef ASE_ABSOLUTE_VERTEX_POS
						float3 defaultVertexValue = v.vertex.xyz;
					#else
						float3 defaultVertexValue = float3(0, 0, 0);
					#endif
					float3 vertexValue = 0;
					#ifdef ASE_ABSOLUTE_VERTEX_POS
						v.vertex.xyz = vertexValue;
					#else
						v.vertex.xyz += vertexValue;
					#endif
					v.vertex.w = 1;
					v.normal = v.normal;

					TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
					return o;
				}

				half4 frag( v2f IN 
							#if defined( ASE_DEPTH_WRITE_ON )
								, out float outputDepth : SV_Depth
							#endif
							) : SV_Target
				{
					UNITY_SETUP_INSTANCE_ID(IN);

					#ifdef LOD_FADE_CROSSFADE
						UNITY_APPLY_DITHER_CROSSFADE(IN.pos.xy);
					#endif

					float2 vertexToFrag37_g12 = IN.ase_texcoord1.xy;
					float4 temp_output_635_0 = tex2D( _Spritesheet, vertexToFrag37_g12 );
					

					float Alpha = (temp_output_635_0).a;
					half AlphaClipThreshold = 0.45;
					half AlphaClipThresholdShadow = 0.5;

					#if defined( ASE_DEPTH_WRITE_ON )
						outputDepth = IN.pos.z;
					#endif

					#ifdef _ALPHATEST_SHADOW_ON
						if (unity_LightShadowBias.z != 0.0)
							clip(Alpha - AlphaClipThresholdShadow);
						#ifdef _ALPHATEST_ON
						else
							clip(Alpha - AlphaClipThreshold);
						#endif
					#else
						#ifdef _ALPHATEST_ON
							clip(Alpha - AlphaClipThreshold);
						#endif
					#endif

					#ifdef UNITY_STANDARD_USE_DITHER_MASK
						half alphaRef = tex3D(_DitherMaskLOD, float3(IN.pos.xy*0.25,Alpha*0.9375)).a;
						clip(alphaRef - 0.01);
					#endif

					SHADOW_CASTER_FRAGMENT(IN)
				}
			ENDCG
		}
		
	}
	CustomEditor "AmplifyShaderEditor.MaterialInspector"
	
	Fallback Off
}
/*ASEBEGIN
Version=19907
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;625;14592,624;Float;False;Property;_Rows;Rows;2;0;Create;True;0;0;0;False;0;False;0;8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;626;14592,704;Float;False;Property;_Columns;Columns;1;0;Create;True;0;0;0;False;0;False;0;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;628;14560,784;Float;False;Property;_AnimSpeed;Anim Speed;3;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;622;14304,560;Float;True;Property;_Spritesheet;Spritesheet;0;0;Create;True;0;0;0;False;0;False;None;8bad0b0ea8a87cd4ab57ff281be3b6df;False;white;Auto;Texture2D;False;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;635;14784,560;Inherit;False;Orientation Based Sprite;-1;;12;39b23917f94c7994fb9f6c0ea9ccc6f9;1,46,1;6;40;SAMPLER2D;0.0;False;43;FLOAT2;0,0;False;48;FLOAT;0;False;41;FLOAT;1;False;45;FLOAT;1;False;42;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SwizzleNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;623;15056,560;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwizzleNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;624;15056,640;Inherit;False;FLOAT;3;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;639;15024,480;Inherit;False;Constant;_Float0;Float 0;4;0;Create;True;0;0;0;False;0;False;0.45;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BillboardNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;636;15024,720;Inherit;False;Cylindrical;True;True;0;1;FLOAT3;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;638;15232,512;Float;False;False;-1;3;AmplifyShaderEditor.MaterialInspector;0;1;New Amplify Shader;0770190933193b94aaa3065e307002fa;True;ShadowCaster;0;1;ShadowCaster;0;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;1;False;;True;1;RenderType=Opaque=RenderType;True;3;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;False;;True;3;False;;False;False;True;1;LightMode=ShadowCaster;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;637;15280,560;Float;False;True;-1;3;AmplifyShaderEditor.MaterialInspector;0;4;AmplifyShaderPack/Orientation Based Sprite;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;7;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;1;False;;True;1;RenderType=Opaque=RenderType;True;3;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;False;0;;0;0;Standard;5;Alpha Clipping;1;639042318459463414;  Use Shadow Threshold;0;0;Cast Shadows;1;0;Write Depth;0;0;Vertex Position;1;0;0;2;True;True;False;;False;0
WireConnection;635;40;622;0
WireConnection;635;41;625;0
WireConnection;635;45;626;0
WireConnection;635;42;628;0
WireConnection;623;0;635;0
WireConnection;624;0;635;0
WireConnection;637;0;623;0
WireConnection;637;7;624;0
WireConnection;637;8;639;0
WireConnection;637;15;636;0
ASEEND*/
//CHKSM=773DF1FEBECF7C5D1AB953B73EA7DF68F62547FA