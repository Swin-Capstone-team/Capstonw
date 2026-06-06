// Made with Amplify Shader Editor v1.9.9.7
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AmplifyShaderPack/Community/Skybox Cubemap Extended"
{
	Properties
	{
		[Gamma][Header(Cubemap)] _TintColor( "Tint Color", Color ) = ( 0.5, 0.5, 0.5, 1 )
		_Exposure( "Exposure", Range( 0, 8 ) ) = 1
		[NoScaleOffset] _Tex( "Cubemap (HDR)", CUBE ) = "black" {}
		[Header(Rotation)][Toggle( _ENABLEROTATION_ON )] _EnableRotation( "Enable Rotation", Float ) = 0
		[IntRange] _Rotation( "Rotation", Range( 0, 360 ) ) = 0
		_RotationSpeed( "Rotation Speed", Float ) = 1
		[Header(Fog)][Toggle( _ENABLEFOG_ON )] _EnableFog( "Enable Fog", Float ) = 0
		_FogHeight( "Fog Height", Range( 0, 1 ) ) = 1
		_FogSmoothness( "Fog Smoothness", Range( 0.01, 1 ) ) = 0.01
		_FogFill( "Fog Fill", Range( 0, 1 ) ) = 0.5
		[HideInInspector] _Tex_HDR( "DecodeInstructions", Vector ) = ( 0, 0, 0, 0 )

	}

	SubShader
	{
		

		

		Tags { "RenderType"="Background" }

	LOD 0

		

		Blend Off
		AlphaToMask Off
		Cull Back
		ColorMask RGBA
		ZWrite Off
		ZClip True
		ZTest LEqual
		

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
				#define ASE_VERSION 19907

				#pragma vertex vert
				#pragma fragment frag
				#pragma multi_compile_instancing
				#include "UnityCG.cginc"

				#include "UnityShaderVariables.cginc"
				#pragma shader_feature_local _ENABLEFOG_ON
				#pragma shader_feature_local _ENABLEROTATION_ON


				struct appdata
				{
					float4 vertex : POSITION;
					half3 normal : NORMAL;
					
					UNITY_VERTEX_INPUT_INSTANCE_ID
				};

				struct v2f
				{
					float4 pos : SV_POSITION;
					float4 ase_texcoord : TEXCOORD0;
					float4 ase_texcoord1 : TEXCOORD1;
					UNITY_VERTEX_INPUT_INSTANCE_ID
					UNITY_VERTEX_OUTPUT_STEREO
				};

				uniform half4 _Tex_HDR;
				uniform samplerCUBE _Tex;
				uniform half _Rotation;
				uniform half _RotationSpeed;
				uniform half4 _TintColor;
				uniform half _Exposure;
				uniform half _FogHeight;
				uniform half _FogSmoothness;
				uniform half _FogFill;


				inline half3 DecodeHDR1189( float4 Data )
				{
					return DecodeHDR(Data, _Tex_HDR);
				}
				

				v2f vert( appdata v  )
				{
					UNITY_SETUP_INSTANCE_ID(v);
					v2f o;
					UNITY_INITIALIZE_OUTPUT(v2f,o);
					UNITY_TRANSFER_INSTANCE_ID(v,o);
					UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

					float3 ase_positionWS = mul( unity_ObjectToWorld, float4( ( v.vertex ).xyz, 1 ) ).xyz;
					float lerpResult268 = lerp( 1.0 , ( unity_OrthoParams.y / unity_OrthoParams.x ) , unity_OrthoParams.w);
					half CAMERA_MODE300 = lerpResult268;
					float3 appendResult1129 = (float3(ase_positionWS.x , ( ase_positionWS.y * CAMERA_MODE300 ) , ase_positionWS.z));
					float3 normalizeResult1130 = normalize( appendResult1129 );
					float3 appendResult56 = (float3(cos( radians( ( _Rotation + ( _Time.y * _RotationSpeed ) ) ) ) , 0.0 , ( sin( radians( ( _Rotation + ( _Time.y * _RotationSpeed ) ) ) ) * -1.0 )));
					float3 appendResult266 = (float3(0.0 , CAMERA_MODE300 , 0.0));
					float3 appendResult58 = (float3(sin( radians( ( _Rotation + ( _Time.y * _RotationSpeed ) ) ) ) , 0.0 , cos( radians( ( _Rotation + ( _Time.y * _RotationSpeed ) ) ) )));
					float3 normalizeResult247 = normalize( ase_positionWS );
					#ifdef _ENABLEROTATION_ON
					float3 staticSwitch1164 = mul( float3x3( appendResult56, appendResult266, appendResult58 ), normalizeResult247 );
					#else
					float3 staticSwitch1164 = normalizeResult1130;
					#endif
					float3 vertexToFrag774 = staticSwitch1164;
					o.ase_texcoord.xyz = vertexToFrag774;
					o.ase_texcoord1.xyz = ase_positionWS;
					
					
					//setting value to unused interpolator channels and avoid initialization warnings
					o.ase_texcoord.w = 0;
					o.ase_texcoord1.w = 0;

					#ifdef ASE_ABSOLUTE_VERTEX_POS
						float3 defaultVertexValue = v.vertex.xyz;
					#else
						float3 defaultVertexValue = float3(0, 0, 0);
					#endif
					float3 vertexValue = defaultVertexValue;
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

					float3 vertexToFrag774 = IN.ase_texcoord.xyz;
					half4 Data1189 = texCUBE( _Tex, vertexToFrag774 );
					half3 localDecodeHDR1189 = DecodeHDR1189( Data1189 );
					half4 CUBEMAP222 = ( float4( localDecodeHDR1189 , 0.0 ) * unity_ColorSpaceDouble * _TintColor * _Exposure );
					float3 ase_positionWS = IN.ase_texcoord1.xyz;
					float3 normalizeResult319 = normalize( ase_positionWS );
					float lerpResult678 = lerp( saturate( pow(  (0.0 + ( abs( normalizeResult319.y ) - 0.0 ) * ( 1.0 - 0.0 ) / ( _FogHeight - 0.0 ) ) , ( 1.0 - _FogSmoothness ) ) ) , 0.0 , _FogFill);
					half FOG_MASK359 = lerpResult678;
					float4 lerpResult317 = lerp( unity_FogColor , CUBEMAP222 , FOG_MASK359);
					#ifdef _ENABLEFOG_ON
					float4 staticSwitch1179 = lerpResult317;
					#else
					float4 staticSwitch1179 = CUBEMAP222;
					#endif
					

					float4 Color = staticSwitch1179;
					float Alpha = 1;
					half AlphaClipThreshold = 0.5;
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

	
	}
	CustomEditor "AmplifyShaderEditor.MaterialInspector"
	
	Fallback Off
}
/*ASEBEGIN
Version=19907
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1180;-946,1486;Inherit;False;2411;608;Cubemap Coordinates;26;1130;49;1129;247;54;58;266;1128;56;238;55;1127;61;365;1081;310;60;59;1080;62;47;276;255;48;701;260;CUBEMAP;0,0.4980392,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;431;-940.4822,846.6917;Inherit;False;860;219;Switch between Perspective / Orthographic camera;4;268;309;1007;267;CAMERA MODE;1,0,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;260;-896,1792;Half;False;Property;_RotationSpeed;Rotation Speed;5;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;701;-896,1664;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;48;-896,1536;Half;False;Property;_Rotation;Rotation;4;1;[IntRange];Create;True;0;0;0;False;0;False;0;0;0;360;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;255;-640,1664;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OrthoParams, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;267;-892.4822,894.6918;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;276;-512,1536;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1007;-444.4821,894.6918;Half;False;Constant;_Float7;Float 7;47;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;309;-588.4823,894.6918;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;432;-44.48222,846.6917;Inherit;False;305;165;CAMERA MODE OUTPUT;1;300;;0.4980392,1,0,1;0;0
Node;AmplifyShaderEditor.RadiansOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;47;-384,1536;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;268;-252.4821,894.6918;Inherit;False;3;0;FLOAT;1;False;1;FLOAT;0.5;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;700;-944,2512;Inherit;False;1898;485;Fog Coords on Screen;15;678;1110;316;679;677;315;329;1108;314;1109;325;313;320;319;318;BUILT-IN FOG;0,0.4980392,0,1;0;0
Node;AmplifyShaderEditor.RelayNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;62;-224,1792;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1080;128,1664;Half;False;Constant;_Float26;Float 26;50;0;Create;True;0;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;59;128,1600;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;300;3.51777,894.6918;Half;False;CAMERA_MODE;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;60;320,1600;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;310;128,1760;Inherit;False;300;CAMERA_MODE;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1081;128,1840;Half;False;Constant;_Float27;Float 27;50;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CosOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;365;128,1984;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;61;128,1920;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1127;768,1936;Inherit;False;300;CAMERA_MODE;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CosOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;55;128,1536;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;318;-896,2560;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;238;768,1760;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;56;512,1536;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1128;1024,1920;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;266;512,1728;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;58;512,1920;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;319;-640,2560;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.MatrixFromVectors, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;54;768,1536;Inherit;False;FLOAT3x3;0;4;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3x3;0
Node;AmplifyShaderEditor.NormalizeNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;247;1024,1664;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1129;1152,1792;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;320;-448,2560;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1087;1552,1664;Inherit;False;394;188;Enable Clouds Rotation;1;1164;;0,1,0.4980392,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;49;1280,1616;Inherit;False;2;2;0;FLOAT3x3;0,0,0,1,1,1,1,0,1;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1130;1280,1792;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;313;-896,2752;Half;False;Property;_FogHeight;Fog Height;7;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;325;-896,2880;Half;False;Property;_FogSmoothness;Fog Smoothness;8;0;Create;True;0;0;0;False;0;False;0.01;0.01;0.01;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1109;-128,2784;Half;False;Constant;_Float40;Float 40;55;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;314;-128,2560;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1108;-128,2688;Half;False;Constant;_Float39;Float 39;55;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1183;1998,1678;Inherit;False;265;160;Per Vertex;1;774;;1,0,1,1;0;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1164;1600,1728;Float;False;Property;_EnableRotation;Enable Rotation;3;0;Create;True;0;0;0;False;1;Header(Rotation);False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;329;128,2880;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;315;64,2560;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1191;2382,1486;Inherit;False;1115;565;Base;7;1190;1174;1173;1177;1189;1175;41;;0,0.4980392,1,1;0;0
Node;AmplifyShaderEditor.VertexToFragmentNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;774;2048,1728;Inherit;False;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PowerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;677;320,2560;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;41;2432,1536;Inherit;True;Property;_Tex;Cubemap (HDR);2;1;[NoScaleOffset];Create;False;0;0;0;False;0;False;-1;None;None;True;0;False;black;LockedToCube;False;Object;-1;Auto;Cube;False;8;0;SAMPLERCUBE;;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;679;512,2880;Half;False;Property;_FogFill;Fog Fill;9;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;316;512,2560;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1110;512,2752;Half;False;Constant;_Float41;Float 41;55;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;699;1104,2512;Inherit;False;293;165;FOG_MASK OUTPUT;1;359;;0.4980392,1,0,1;0;0
Node;AmplifyShaderEditor.ColorSpaceDouble, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1175;2816,1616;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CustomExpressionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1189;2816,1536;Half;False;DecodeHDR(Data, _Tex_HDR);3;Create;1;True;Data;FLOAT4;0,0,0,0;In;;Float;False;DecodeHDR;True;False;0;;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1177;2816,1968;Half;False;Property;_Exposure;Exposure;1;0;Create;True;0;0;0;False;0;False;1;1;0;8;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1173;2816,1792;Half;False;Property;_TintColor;Tint Color;0;1;[Gamma];Create;True;0;0;0;False;1;Header(Cubemap);False;0.5,0.5,0.5,1;0.5,0.5,0.5,1;False;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.LerpOp, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;678;768,2560;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;915;3664,1488;Inherit;False;293;165;CUBEMAP OUTPUT;1;222;;0.4980392,1,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1167;-946,78;Inherit;False;618;357;;4;312;228;436;317;FINAL COLOR;0.4980392,1,0,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1174;3328,1536;Inherit;False;4;4;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;359;1152,2560;Half;False;FOG_MASK;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;222;3712,1536;Half;False;CUBEMAP;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FogAndAmbientColorsNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;312;-896,128;Inherit;False;unity_FogColor;0;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;436;-896,320;Inherit;False;359;FOG_MASK;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1185;-274,174;Inherit;False;306;188;Enable Fog;1;1179;;0,1,0.4980392,1;0;0
Node;AmplifyShaderEditor.LerpOp, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;317;-512,128;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;228;-896,240;Inherit;False;222;CUBEMAP;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1179;-224,224;Float;False;Property;_EnableFog;Enable Fog;6;0;Create;True;0;0;0;False;1;Header(Fog);False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector4Node, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1190;2432,1792;Half;False;Property;_Tex_HDR;DecodeInstructions;10;1;[HideInInspector];Create;False;0;0;0;True;0;False;0,0,0,0;1,1,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1193;400,144;Float;False;False;-1;3;AmplifyShaderEditor.MaterialInspector;0;1;New Amplify Shader;0770190933193b94aaa3065e307002fa;True;ShadowCaster;0;1;ShadowCaster;0;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;1;False;;True;1;RenderType=Opaque=RenderType;True;3;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;False;;True;3;False;;False;False;True;1;LightMode=ShadowCaster;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1192;128,224;Float;False;True;-1;3;AmplifyShaderEditor.MaterialInspector;0;4;AmplifyShaderPack/Community/Skybox Cubemap Extended;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;7;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;True;2;False;;True;3;False;;True;False;0;False;;0;False;;True;1;False;;True;1;RenderType=Background=RenderType;True;3;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;False;0;;0;0;Standard;5;Alpha Clipping;0;0;  Use Shadow Threshold;0;0;Cast Shadows;0;639042288920553593;Write Depth;0;0;Vertex Position;1;0;0;2;True;False;False;;False;0
WireConnection;255;0;701;0
WireConnection;255;1;260;0
WireConnection;276;0;48;0
WireConnection;276;1;255;0
WireConnection;309;0;267;2
WireConnection;309;1;267;1
WireConnection;47;0;276;0
WireConnection;268;0;1007;0
WireConnection;268;1;309;0
WireConnection;268;2;267;4
WireConnection;62;0;47;0
WireConnection;59;0;62;0
WireConnection;300;0;268;0
WireConnection;60;0;59;0
WireConnection;60;1;1080;0
WireConnection;365;0;62;0
WireConnection;61;0;62;0
WireConnection;55;0;62;0
WireConnection;56;0;55;0
WireConnection;56;1;1081;0
WireConnection;56;2;60;0
WireConnection;1128;0;238;2
WireConnection;1128;1;1127;0
WireConnection;266;0;1081;0
WireConnection;266;1;310;0
WireConnection;266;2;1081;0
WireConnection;58;0;61;0
WireConnection;58;1;1081;0
WireConnection;58;2;365;0
WireConnection;319;0;318;0
WireConnection;54;0;56;0
WireConnection;54;1;266;0
WireConnection;54;2;58;0
WireConnection;247;0;238;0
WireConnection;1129;0;238;1
WireConnection;1129;1;1128;0
WireConnection;1129;2;238;3
WireConnection;320;0;319;0
WireConnection;49;0;54;0
WireConnection;49;1;247;0
WireConnection;1130;0;1129;0
WireConnection;314;0;320;1
WireConnection;1164;1;1130;0
WireConnection;1164;0;49;0
WireConnection;329;0;325;0
WireConnection;315;0;314;0
WireConnection;315;1;1108;0
WireConnection;315;2;313;0
WireConnection;315;3;1108;0
WireConnection;315;4;1109;0
WireConnection;774;0;1164;0
WireConnection;677;0;315;0
WireConnection;677;1;329;0
WireConnection;41;1;774;0
WireConnection;316;0;677;0
WireConnection;1189;0;41;0
WireConnection;678;0;316;0
WireConnection;678;1;1110;0
WireConnection;678;2;679;0
WireConnection;1174;0;1189;0
WireConnection;1174;1;1175;0
WireConnection;1174;2;1173;0
WireConnection;1174;3;1177;0
WireConnection;359;0;678;0
WireConnection;222;0;1174;0
WireConnection;317;0;312;0
WireConnection;317;1;228;0
WireConnection;317;2;436;0
WireConnection;1179;1;228;0
WireConnection;1179;0;317;0
WireConnection;1192;0;1179;0
ASEEND*/
//CHKSM=34F568E6A1259857FE5C7AC6ED0DED989D150EF0