// Made with Amplify Shader Editor v1.9.9.7
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AmplifyShaderPack/Community/Physical Based Rendering Hair"
{
	Properties
	{
		[Enum(Front,2,Back,1,Both,0)] _Cull( "Render Face", Int ) = 2
		[Toggle] _AlphaClip( "Alpha Clipping", Float ) = 0
		_Cutoff( "Threshold", Range( 0, 1 ) ) = 0.5
		_AlphaRemapMin( "Alpha Remap Min", Range( 0, 1 ) ) = 0
		_AlphaRemapMax( "Alpha Remap Max", Range( 0, 1 ) ) = 1
		[Toggle] _UseShadowThreshold( "Use Shadow Threshold", Float ) = 0
		_AlphaCutoffShadow( "Shadow Threshold", Range( 0.01, 1 ) ) = 0.5
		[Toggle] _EnableClipGlancingAngle( "Enable Clip Glancing Angle", Float ) = 0
		[Header(COLOR)][MainColor] _BaseColor( "Base Color", Color ) = ( 1, 1, 1 )
		_Saturation( "Saturation", Range( 0, 1 ) ) = 0
		_Brightness( "Brightness", Range( 0, 2 ) ) = 1
		[Header(SURFACE INPUTS)][SingleLineTexture][MainTexture] _MainTex( "BaseColor Map", 2D ) = "white" {}
		_MainTex_ST( "Main UVs", Vector ) = ( 1, 1, 0, 0 )
		[SingleLineTexture][Space(15)] _MainMaskMap( "Main Mask Map", 2D ) = "white" {}
		[Enum(MSO,0,MRO,1)] _MainMaskType( "Main Mask Type", Float ) = 0
		_MetallicStrength( "Metallic Strength", Range( 0, 1 ) ) = 0.15
		_SmoothnessStrength( "Smoothness Strength", Range( 0, 1 ) ) = 0.55
		_OcclusionStrengthAO( "Occlusion Strength", Range( 0, 1 ) ) = 0
		[SingleLineTexture][Space(15)] _SpecularMap( "Specular Map", 2D ) = "white" {}
		_SpecularColor( "Specular Color", Color ) = ( 0.4745098, 0.4745098, 0.4745098, 1 )
		[Normal][SingleLineTexture][Space(10)] _BumpMap( "Normal Map", 2D ) = "bump" {}
		[Enum(Flip,0,Mirror,1,None,2)] _DoubleSidedNormalMode( "Normal Mode", Float ) = 0
		_NormalStrength( "Normal Strength", Float ) = 1
		[Header(FRESNEL TERM)] _fresnelIOR( "fresnel IOR", Range( 1, 4 ) ) = 1.5
		[Header(NORMAL DISTRIBUTION)] _NDFAnistropic( "NDF Anistropic", Range( -20, 1 ) ) = -2
		[Space(15)][Header(GEOMETRIC SHADOWING)] _LightWrapping( "Light Wrapping", Range( 0, 1 ) ) = 0
		[ToggleUI][Space(10)][Header(GEOMETRIC SHADOWING)] _ShadowColorEnable( "Enable Shadow Color", Float ) = 0
		[HDR] _ShadowColor( "Shadow Color", Color ) = ( 0.05882353, 0.05882353, 0.05882353, 0.4901961 )
		[HDR][Header(INDIRECT LIGHTING)] _IndirectSpecColor( "Indirect Specular Color", Color ) = ( 0.4745098, 0.4745098, 0.4745098 )
		_IndirectSpecular( "Indirect Specular ", Range( 0, 1 ) ) = 0.85
		_IndirectSpecularSmoothness( "Indirect Specular Smoothness", Range( 0, 1 ) ) = 1
		_IndirectDiffuse( "Indirect Diffuse", Range( 0, 1 ) ) = 0.5

	}

	SubShader
	{
		

		

		Tags { "RenderType"="Opaque" }

	LOD 0

		

		Blend Off
		AlphaToMask Off
		Cull [_Cull]
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
				#define _ALPHATEST_SHADOW_ON 1
				#define ASE_VERSION 19907
				#pragma multi_compile_fwdbase
				#define ASE_USING_SAMPLING_MACROS 1

				#pragma vertex vert
				#pragma fragment frag
				#pragma multi_compile_instancing
				#include "UnityCG.cginc"

				#include "UnityStandardUtils.cginc"
				#include "Lighting.cginc"
				#include "UnityStandardBRDF.cginc"
				#include "AutoLight.cginc"
				#include "UnityShaderVariables.cginc"
				#define ASE_NEEDS_TEXTURE_COORDINATES0
				#define ASE_NEEDS_FRAG_TEXTURE_COORDINATES0
				#define ASE_NEEDS_VERT_NORMAL
				#define ASE_SHADOWS
				#define ASE_NEEDS_VERT_POSITION
				#if defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL) || (defined(SHADER_TARGET_SURFACE_ANALYSIS) && !defined(SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER))//ASE Sampler Macros
				#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex.Sample(samplerTex,coord)
				#define SAMPLE_TEXTURE2D_LOD(tex,samplerTex,coord,lod) tex.SampleLevel(samplerTex,coord, lod)
				#define SAMPLE_TEXTURE2D_BIAS(tex,samplerTex,coord,bias) tex.SampleBias(samplerTex,coord,bias)
				#define SAMPLE_TEXTURE2D_GRAD(tex,samplerTex,coord,ddx,ddy) tex.SampleGrad(samplerTex,coord,ddx,ddy)
				#else//ASE Sampling Macros
				#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex2D(tex,coord)
				#define SAMPLE_TEXTURE2D_LOD(tex,samplerTex,coord,lod) tex2Dlod(tex,float4(coord,0,lod))
				#define SAMPLE_TEXTURE2D_BIAS(tex,samplerTex,coord,bias) tex2Dbias(tex,float4(coord,0,bias))
				#define SAMPLE_TEXTURE2D_GRAD(tex,samplerTex,coord,ddx,ddy) tex2Dgrad(tex,coord,ddx,ddy)
				#endif//ASE Sampling Macros
				


				struct appdata
				{
					float4 vertex : POSITION;
					half3 normal : NORMAL;
					float4 ase_texcoord : TEXCOORD0;
					float4 ase_tangent : TANGENT;
					float4 texcoord1 : TEXCOORD1;
					float4 texcoord2 : TEXCOORD2;
					float4 ase_color : COLOR;
					UNITY_VERTEX_INPUT_INSTANCE_ID
				};

				struct v2f
				{
					float4 pos : SV_POSITION;
					float4 ase_texcoord : TEXCOORD0;
					float4 ase_texcoord1 : TEXCOORD1;
					float4 ase_texcoord2 : TEXCOORD2;
					float4 ase_texcoord3 : TEXCOORD3;
					float4 ase_texcoord4 : TEXCOORD4;
					float4 ase_lmap : TEXCOORD5;
					float4 ase_sh : TEXCOORD6;
					float4 ase_color : COLOR;
					UNITY_SHADOW_COORDS(7)
					float4 ase_texcoord8 : TEXCOORD8;
					UNITY_VERTEX_INPUT_INSTANCE_ID
					UNITY_VERTEX_OUTPUT_STEREO
				};

				uniform int _Cull;
				uniform half3 _BaseColor;
				UNITY_DECLARE_TEX2D_NOSAMPLER(_MainTex);
				uniform float4 _MainTex_ST;
				float4 _MainTex_TexelSize;
				SamplerState sampler_MainTex;
				uniform float _Saturation;
				uniform half _Brightness;
				uniform float _MetallicStrength;
				UNITY_DECLARE_TEX2D_NOSAMPLER(_MainMaskMap);
				float4 _MainMaskMap_TexelSize;
				UNITY_DECLARE_TEX2D_NOSAMPLER(_BumpMap);
				float4 _BumpMap_TexelSize;
				SamplerState sampler_BumpMap;
				uniform half _NormalStrength;
				uniform float _DoubleSidedNormalMode;
				uniform float _MainMaskType;
				uniform half _SmoothnessStrength;
				uniform half _OcclusionStrengthAO;
				uniform float _IndirectDiffuse;
				uniform half _IndirectSpecularSmoothness;
				uniform float3 _IndirectSpecColor;
				uniform half _IndirectSpecular;
				uniform float4 _SpecularColor;
				UNITY_DECLARE_TEX2D_NOSAMPLER(_SpecularMap);
				float4 _SpecularMap_TexelSize;
				uniform float _LightWrapping;
				uniform float _NDFAnistropic;
				uniform float _fresnelIOR;
				uniform float4 _ShadowColor;
				uniform float _ShadowColorEnable;
				uniform float _AlphaRemapMin;
				uniform float _AlphaRemapMax;
				uniform float _EnableClipGlancingAngle;
				uniform float _AlphaClip;
				uniform float _Cutoff;
				uniform float _AlphaCutoffShadow;
				uniform float _UseShadowThreshold;


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
				
				float4x4 InverseProjectionMatrix()
				{
					float4x4 m = UNITY_MATRIX_P;
					float n11 = m[ 0 ][ 0 ];
					float n22 = m[ 1 ][ 1 ];
					float n33 = m[ 2 ][ 2 ];
					float n34 = m[ 3 ][ 2 ];
					float n43 = m[ 2 ][ 3 ];
					float t11 = -n22 * n34 * n43;
					float det = n11 * t11;
					float idet = 1.0f / det;
					m[ 0 ][ 0 ] = +t11* idet;
					m[ 1 ][ 1 ] = -n11* n34 * n43* idet;
					m[ 2 ][ 2 ] = 0;
					m[ 2 ][ 3 ] = -n11* n22 * n43* idet;
					m[ 3 ][ 2 ] = -n11* n22 * n34* idet;
					m[ 3 ][ 3 ] = +n11* n22 * n33* idet;
					return m;
				}
				

				v2f vert( appdata v  )
				{
					UNITY_SETUP_INSTANCE_ID(v);
					v2f o;
					UNITY_INITIALIZE_OUTPUT(v2f,o);
					UNITY_TRANSFER_INSTANCE_ID(v,o);
					UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

					float3 ase_tangentWS = UnityObjectToWorldDir( v.ase_tangent );
					o.ase_texcoord1.xyz = ase_tangentWS;
					float3 ase_normalWS = UnityObjectToWorldNormal( v.normal );
					o.ase_texcoord2.xyz = ase_normalWS;
					float ase_tangentSign = v.ase_tangent.w * ( unity_WorldTransformParams.w >= 0.0 ? 1.0 : -1.0 );
					float3 ase_bitangentWS = cross( ase_normalWS, ase_tangentWS ) * ase_tangentSign;
					o.ase_texcoord3.xyz = ase_bitangentWS;
					float3 ase_positionWS = mul( unity_ObjectToWorld, float4( ( v.vertex ).xyz, 1 ) ).xyz;
					o.ase_texcoord4.xyz = ase_positionWS;
					#ifdef DYNAMICLIGHTMAP_ON //dynlm
					o.ase_lmap.zw = v.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
					#endif //dynlm
					#ifdef LIGHTMAP_ON //stalm
					o.ase_lmap.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
					#endif //stalm
					#ifndef LIGHTMAP_ON //nstalm
					#if UNITY_SHOULD_SAMPLE_SH //sh
					o.ase_sh.xyz = 0;
					#ifdef VERTEXLIGHT_ON //vl
					o.ase_sh.xyz += Shade4PointLights (
					unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
					unity_LightColor[0].rgb, unity_LightColor[1].rgb, unity_LightColor[2].rgb, unity_LightColor[3].rgb,
					unity_4LightAtten0, ase_positionWS, ase_normalWS);
					#endif //vl
					o.ase_sh.xyz = ShadeSHPerVertex (ase_normalWS, o.ase_sh.xyz);
					#endif //sh
					#endif //nstalm
					
					float4 ase_positionCS = UnityObjectToClipPos( v.vertex );
					float4x4 ase_matrixInvP = InverseProjectionMatrix();
					float4 ase_hpositionVS = mul( ase_matrixInvP, ase_positionCS );
					float3 ase_positionRWS = mul( ( float3x3 )UNITY_MATRIX_I_V, ase_hpositionVS.xyz / ase_hpositionVS.w );
					o.ase_texcoord8.xyz = ase_positionRWS;
					
					o.ase_texcoord.xy = v.ase_texcoord.xy;
					o.ase_color = v.ase_color;
					
					//setting value to unused interpolator channels and avoid initialization warnings
					o.ase_texcoord.zw = 0;
					o.ase_texcoord1.w = 0;
					o.ase_texcoord2.w = 0;
					o.ase_texcoord3.w = 0;
					o.ase_texcoord4.w = 0;
					o.ase_sh.w = 0;
					o.ase_texcoord8.w = 0;

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

				half4 frag( v2f IN , uint ase_vface : SV_IsFrontFace
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

					float localStochasticTiling2_g71073 = ( 0.0 );
					float2 UV_Raw_UV2902_g71068 = ( ( IN.ase_texcoord.xy * (_MainTex_ST).xy ) + (_MainTex_ST).zw );
					float2 UV2_g71073 = UV_Raw_UV2902_g71068;
					float4 TexelSize2_g71073 = _MainTex_TexelSize;
					float4 Offsets2_g71073 = float4( 0,0,0,0 );
					float2 Weights2_g71073 = float2( 0,0 );
					{
					UV2_g71073 = UV2_g71073 * TexelSize2_g71073.zw - 0.5;
					float2 f = frac( UV2_g71073 );
					UV2_g71073 -= f;
					float4 xn = float4( 1.0, 2.0, 3.0, 4.0 ) - f.xxxx;
					float4 yn = float4( 1.0, 2.0, 3.0, 4.0 ) - f.yyyy;
					float4 xs = xn * xn * xn;
					float4 ys = yn * yn * yn;
					float3 xv = float3( xs.x, xs.y - 4.0 * xs.x, xs.z - 4.0 * xs.y + 6.0 * xs.x );
					float3 yv = float3( ys.x, ys.y - 4.0 * ys.x, ys.z - 4.0 * ys.y + 6.0 * ys.x );
					float4 xc = float4( xv.xyz, 6.0 - xv.x - xv.y - xv.z );
					float4 yc = float4( yv.xyz, 6.0 - yv.x - yv.y - yv.z );
					float4 c = float4( UV2_g71073.x - 0.5, UV2_g71073.x + 1.5, UV2_g71073.y - 0.5, UV2_g71073.y + 1.5 );
					float4 s = float4( xc.x + xc.y, xc.z + xc.w, yc.x + yc.y, yc.z + yc.w );
					float w0 = s.x / ( s.x + s.y );
					float w1 = s.z / ( s.z + s.w );
					Offsets2_g71073 = ( c + float4( xc.y, xc.w, yc.y, yc.w ) / s ) * TexelSize2_g71073.xyxy;
					Weights2_g71073 = float2( w0, w1 );
					}
					float4 Input_FetchOffsets197_g71080 = Offsets2_g71073;
					float2 Input_FetchWeights200_g71080 = Weights2_g71073;
					float2 break187_g71080 = Input_FetchWeights200_g71080;
					float4 lerpResult181_g71080 = lerp( SAMPLE_TEXTURE2D( _MainTex, sampler_MainTex, (Input_FetchOffsets197_g71080).yw ) , SAMPLE_TEXTURE2D( _MainTex, sampler_MainTex, (Input_FetchOffsets197_g71080).xw ) , break187_g71080.x);
					float4 lerpResult182_g71080 = lerp( SAMPLE_TEXTURE2D( _MainTex, sampler_MainTex, (Input_FetchOffsets197_g71080).yz ) , SAMPLE_TEXTURE2D( _MainTex, sampler_MainTex, (Input_FetchOffsets197_g71080).xz ) , break187_g71080.x);
					float4 lerpResult176_g71080 = lerp( lerpResult181_g71080 , lerpResult182_g71080 , break187_g71080.y);
					float4 Output_Fetch2D_Auto202_g71080 = lerpResult176_g71080;
					float4 temp_output_2_0_g71110 = Output_Fetch2D_Auto202_g71080;
					float3 temp_output_12_0_g71084 = (temp_output_2_0_g71110).rgb;
					float dotResult28_g71084 = dot( float3( 0.2126729, 0.7151522, 0.072175 ) , temp_output_12_0_g71084 );
					float3 temp_cast_0 = (dotResult28_g71084).xxx;
					float temp_output_21_0_g71084 = ( 1.0 - _Saturation );
					float3 lerpResult31_g71084 = lerp( temp_cast_0 , temp_output_12_0_g71084 , temp_output_21_0_g71084);
					float3 temp_output_48_0_g71068 = ( _BaseColor * lerpResult31_g71084 * _Brightness );
					#ifdef UNITY_COLORSPACE_GAMMA
					float4 staticSwitch7584_g71068 = float4( 0.2209163, 0.2209163, 0.2209163, 0.7790837 );
					#else
					float4 staticSwitch7584_g71068 = float4( 0.04, 0.04, 0.04, 0.96 );
					#endif
					float4 temp_output_2_0_g71093 = staticSwitch7584_g71068;
					float temp_output_7591_6_g71068 = (temp_output_2_0_g71093).w;
					float localStochasticTiling2_g71089 = ( 0.0 );
					float2 UV2_g71089 = UV_Raw_UV2902_g71068;
					float4 TexelSize2_g71089 = _MainMaskMap_TexelSize;
					float4 Offsets2_g71089 = float4( 0,0,0,0 );
					float2 Weights2_g71089 = float2( 0,0 );
					{
					UV2_g71089 = UV2_g71089 * TexelSize2_g71089.zw - 0.5;
					float2 f = frac( UV2_g71089 );
					UV2_g71089 -= f;
					float4 xn = float4( 1.0, 2.0, 3.0, 4.0 ) - f.xxxx;
					float4 yn = float4( 1.0, 2.0, 3.0, 4.0 ) - f.yyyy;
					float4 xs = xn * xn * xn;
					float4 ys = yn * yn * yn;
					float3 xv = float3( xs.x, xs.y - 4.0 * xs.x, xs.z - 4.0 * xs.y + 6.0 * xs.x );
					float3 yv = float3( ys.x, ys.y - 4.0 * ys.x, ys.z - 4.0 * ys.y + 6.0 * ys.x );
					float4 xc = float4( xv.xyz, 6.0 - xv.x - xv.y - xv.z );
					float4 yc = float4( yv.xyz, 6.0 - yv.x - yv.y - yv.z );
					float4 c = float4( UV2_g71089.x - 0.5, UV2_g71089.x + 1.5, UV2_g71089.y - 0.5, UV2_g71089.y + 1.5 );
					float4 s = float4( xc.x + xc.y, xc.z + xc.w, yc.x + yc.y, yc.z + yc.w );
					float w0 = s.x / ( s.x + s.y );
					float w1 = s.z / ( s.z + s.w );
					Offsets2_g71089 = ( c + float4( xc.y, xc.w, yc.y, yc.w ) / s ) * TexelSize2_g71089.xyxy;
					Weights2_g71089 = float2( w0, w1 );
					}
					float4 Input_FetchOffsets197_g71094 = Offsets2_g71089;
					float2 Input_FetchWeights200_g71094 = Weights2_g71089;
					float2 break187_g71094 = Input_FetchWeights200_g71094;
					float4 lerpResult181_g71094 = lerp( SAMPLE_TEXTURE2D( _MainMaskMap, sampler_MainTex, (Input_FetchOffsets197_g71094).yw ) , SAMPLE_TEXTURE2D( _MainMaskMap, sampler_MainTex, (Input_FetchOffsets197_g71094).xw ) , break187_g71094.x);
					float4 lerpResult182_g71094 = lerp( SAMPLE_TEXTURE2D( _MainMaskMap, sampler_MainTex, (Input_FetchOffsets197_g71094).yz ) , SAMPLE_TEXTURE2D( _MainMaskMap, sampler_MainTex, (Input_FetchOffsets197_g71094).xz ) , break187_g71094.x);
					float4 lerpResult176_g71094 = lerp( lerpResult181_g71094 , lerpResult182_g71094 , break187_g71094.y);
					float4 Output_Fetch2D_Auto202_g71094 = lerpResult176_g71094;
					float3 break8066_g71068 = (Output_Fetch2D_Auto202_g71094).rgb;
					float temp_output_400_0_g71068 = ( _MetallicStrength * break8066_g71068.x );
					float4 appendResult7592_g71068 = (float4((temp_output_2_0_g71093).xyz , ( temp_output_7591_6_g71068 - ( temp_output_7591_6_g71068 * temp_output_400_0_g71068 ) )));
					float4 Dieletric7593_g71068 = appendResult7592_g71068;
					float Metallic403_g71068 = temp_output_400_0_g71068;
					float localStochasticTiling2_g71085 = ( 0.0 );
					float2 UV2_g71085 = UV_Raw_UV2902_g71068;
					float4 TexelSize2_g71085 = _BumpMap_TexelSize;
					float4 Offsets2_g71085 = float4( 0,0,0,0 );
					float2 Weights2_g71085 = float2( 0,0 );
					{
					UV2_g71085 = UV2_g71085 * TexelSize2_g71085.zw - 0.5;
					float2 f = frac( UV2_g71085 );
					UV2_g71085 -= f;
					float4 xn = float4( 1.0, 2.0, 3.0, 4.0 ) - f.xxxx;
					float4 yn = float4( 1.0, 2.0, 3.0, 4.0 ) - f.yyyy;
					float4 xs = xn * xn * xn;
					float4 ys = yn * yn * yn;
					float3 xv = float3( xs.x, xs.y - 4.0 * xs.x, xs.z - 4.0 * xs.y + 6.0 * xs.x );
					float3 yv = float3( ys.x, ys.y - 4.0 * ys.x, ys.z - 4.0 * ys.y + 6.0 * ys.x );
					float4 xc = float4( xv.xyz, 6.0 - xv.x - xv.y - xv.z );
					float4 yc = float4( yv.xyz, 6.0 - yv.x - yv.y - yv.z );
					float4 c = float4( UV2_g71085.x - 0.5, UV2_g71085.x + 1.5, UV2_g71085.y - 0.5, UV2_g71085.y + 1.5 );
					float4 s = float4( xc.x + xc.y, xc.z + xc.w, yc.x + yc.y, yc.z + yc.w );
					float w0 = s.x / ( s.x + s.y );
					float w1 = s.z / ( s.z + s.w );
					Offsets2_g71085 = ( c + float4( xc.y, xc.w, yc.y, yc.w ) / s ) * TexelSize2_g71085.xyxy;
					Weights2_g71085 = float2( w0, w1 );
					}
					float4 Input_FetchOffsets197_g71091 = Offsets2_g71085;
					float2 Input_FetchWeights200_g71091 = Weights2_g71085;
					float2 break187_g71091 = Input_FetchWeights200_g71091;
					float4 lerpResult181_g71091 = lerp( SAMPLE_TEXTURE2D( _BumpMap, sampler_BumpMap, (Input_FetchOffsets197_g71091).yw ) , SAMPLE_TEXTURE2D( _BumpMap, sampler_BumpMap, (Input_FetchOffsets197_g71091).xw ) , break187_g71091.x);
					float4 lerpResult182_g71091 = lerp( SAMPLE_TEXTURE2D( _BumpMap, sampler_BumpMap, (Input_FetchOffsets197_g71091).yz ) , SAMPLE_TEXTURE2D( _BumpMap, sampler_BumpMap, (Input_FetchOffsets197_g71091).xz ) , break187_g71091.x);
					float4 lerpResult176_g71091 = lerp( lerpResult181_g71091 , lerpResult182_g71091 , break187_g71091.y);
					float4 Output_Fetch2D_Auto202_g71091 = lerpResult176_g71091;
					float m_switch5216_g71068 = _DoubleSidedNormalMode;
					float3 m_Flip5216_g71068 = float3( -1, -1, -1 );
					float3 m_Mirror5216_g71068 = float3( 1, 1, -1 );
					float3 m_None5216_g71068 = float3( 1, 1, 1 );
					float3 local_NormalModefloat3switch5216_g71068 = _NormalModefloat3switch( m_switch5216_g71068 , m_Flip5216_g71068 , m_Mirror5216_g71068 , m_None5216_g71068 );
					float3 switchResult5218_g71068 = (((ase_vface>0)?(UnpackScaleNormal( Output_Fetch2D_Auto202_g71091, _NormalStrength )):(( UnpackScaleNormal( Output_Fetch2D_Auto202_g71091, _NormalStrength ) * local_NormalModefloat3switch5216_g71068 ))));
					float3 BumpMap_Final4620_g71068 = switchResult5218_g71068;
					float3 ase_tangentWS = IN.ase_texcoord1.xyz;
					float3 ase_normalWS = IN.ase_texcoord2.xyz;
					float3 ase_bitangentWS = IN.ase_texcoord3.xyz;
					float3 tanToWorld0 = float3( ase_tangentWS.x, ase_bitangentWS.x, ase_normalWS.x );
					float3 tanToWorld1 = float3( ase_tangentWS.y, ase_bitangentWS.y, ase_normalWS.y );
					float3 tanToWorld2 = float3( ase_tangentWS.z, ase_bitangentWS.z, ase_normalWS.z );
					float3 tanNormal4619_g71068 = BumpMap_Final4620_g71068;
					float3 worldNormal4619_g71068 = float3( dot( tanToWorld0, tanNormal4619_g71068 ), dot( tanToWorld1, tanNormal4619_g71068 ), dot( tanToWorld2, tanNormal4619_g71068 ) );
					float3 normalizeResult7695_g71068 = normalize( worldNormal4619_g71068 );
					float3 Surface_Data_Normal_WS_BumpNormalized1160_g71068 = normalizeResult7695_g71068;
					float3 Surface_Data_Normal_WS_Final7693_g71068 = Surface_Data_Normal_WS_BumpNormalized1160_g71068;
					float3 ase_mainLightDirection = _WorldSpaceLightPos0.xyz;
					float3 MainLight_Dir1116_g71068 = ase_mainLightDirection;
					float dotResult5651_g71068 = dot( Surface_Data_Normal_WS_Final7693_g71068 , MainLight_Dir1116_g71068 );
					float DotProducts_NdotL_total2267_g71068 = max( dotResult5651_g71068, 1E-37 );
					float3 ase_positionWS = IN.ase_texcoord4.xyz;
					float3 ase_viewVectorWS = ( _WorldSpaceCameraPos.xyz - ase_positionWS );
					float3 ase_viewDirSafeWS = Unity_SafeNormalize( ase_viewVectorWS );
					float3 Surface_Data_ViewDir_WS_Normalized1115_g71068 = ase_viewDirSafeWS;
					float dotResult5568_g71068 = dot( Surface_Data_Normal_WS_Final7693_g71068 , Surface_Data_ViewDir_WS_Normalized1115_g71068 );
					float DotProducts_NdotV_Zero210_g71068 = max( dotResult5568_g71068, 1E-37 );
					float2 appendResult7181_g71068 = (float2(DotProducts_NdotL_total2267_g71068 , DotProducts_NdotV_Zero210_g71068));
					float2 temp_output_7173_0_g71068 = saturate( ( 1.0 - appendResult7181_g71068 ) );
					float2 temp_output_7174_0_g71068 = ( temp_output_7173_0_g71068 * temp_output_7173_0_g71068 * temp_output_7173_0_g71068 * temp_output_7173_0_g71068 * temp_output_7173_0_g71068 );
					float3 normalizeResult5682_g71068 = normalize( ( Surface_Data_ViewDir_WS_Normalized1115_g71068 + MainLight_Dir1116_g71068 ) );
					float3 Surface_Data_HalfDir7369_g71068 = normalizeResult5682_g71068;
					float dotResult5705_g71068 = dot( MainLight_Dir1116_g71068 , Surface_Data_HalfDir7369_g71068 );
					float DotProducts_LdotH_Total2265_g71068 = max( dotResult5705_g71068, 1E-37 );
					float lerpResult750_g71068 = lerp( break8066_g71068.y , ( 1.0 - break8066_g71068.y ) , _MainMaskType);
					float temp_output_53_0_g71068 = ( ( lerpResult750_g71068 * _SmoothnessStrength ) * ( lerpResult750_g71068 * _SmoothnessStrength ) );
					float temp_output_47_0_g71068 = ( 1.0 - temp_output_53_0_g71068 );
					float temp_output_1292_0_g71068 = ( temp_output_47_0_g71068 * temp_output_47_0_g71068 );
					float Roughness730_g71068 = temp_output_1292_0_g71068;
					float2 break7191_g71068 = ( ( 1.0 - temp_output_7174_0_g71068 ) + ( temp_output_7174_0_g71068 * ( ( DotProducts_LdotH_Total2265_g71068 * DotProducts_LdotH_Total2265_g71068 * Roughness730_g71068 * 2.0 ) + 0.5 ) ) );
					UnityGIInput data7058_g71068;
					UNITY_INITIALIZE_OUTPUT( UnityGIInput, data7058_g71068 );
					#if defined(LIGHTMAP_ON) || defined(DYNAMICLIGHTMAP_ON) //dylm7058_g71068
					data7058_g71068.lightmapUV = IN.ase_lmap;
					#endif //dylm7058_g71068
					#if UNITY_SHOULD_SAMPLE_SH //fsh7058_g71068
					data7058_g71068.ambient = IN.ase_sh;
					#endif //fsh7058_g71068
					UnityGI gi7058_g71068 = UnityGI_Base(data7058_g71068, 1, Surface_Data_Normal_WS_Final7693_g71068);
					float Occlusion435_g71068 = saturate( (min( break8066_g71068.z, IN.ase_color.a )*_OcclusionStrengthAO + ( 1.0 - _OcclusionStrengthAO )) );
					float3 Indirect_Diffuse644_g71068 = ( gi7058_g71068.indirect.diffuse * Occlusion435_g71068 * _IndirectDiffuse );
					float3 ase_viewDirWS = normalize( ase_viewVectorWS );
					float Smoothness_417_g71068 = ( lerpResult750_g71068 * _SmoothnessStrength );
					UnityGIInput data;
					UNITY_INITIALIZE_OUTPUT( UnityGIInput, data );
					data.worldPos = ase_positionWS;
					data.worldViewDir = ase_viewDirWS;
					data.probeHDR[0] = unity_SpecCube0_HDR;
					data.probeHDR[1] = unity_SpecCube1_HDR;
					#if UNITY_SPECCUBE_BLENDING || UNITY_SPECCUBE_BOX_PROJECTION //specdataif0
					data.boxMin[0] = unity_SpecCube0_BoxMin;
					#endif //specdataif0
					#if UNITY_SPECCUBE_BOX_PROJECTION //specdataif1
					data.boxMax[0] = unity_SpecCube0_BoxMax;
					data.probePosition[0] = unity_SpecCube0_ProbePosition;
					data.boxMax[1] = unity_SpecCube1_BoxMax;
					data.boxMin[1] = unity_SpecCube1_BoxMin;
					data.probePosition[1] = unity_SpecCube1_ProbePosition;
					#endif //specdataif1
					Unity_GlossyEnvironmentData g647_g71068 = UnityGlossyEnvironmentSetup( (_IndirectSpecularSmoothness*( 1.0 - Smoothness_417_g71068 ) + Smoothness_417_g71068), ase_viewDirWS, Surface_Data_Normal_WS_Final7693_g71068, float3(0,0,0));
					float3 indirectSpecular647_g71068 = UnityGI_IndirectSpecular( data, Occlusion435_g71068, Surface_Data_Normal_WS_Final7693_g71068, g647_g71068 );
					float3 ase_mainLightColorLDR = _LightColor0.rgb / ( _LightColor0.a + 1e-7 );
					float ase_mainLightIntensity = _LightColor0.a;
					UNITY_LIGHT_ATTENUATION( ase_lightAtten, IN, ase_positionWS )
					float ase_mainLightShadowAtten = ase_lightAtten;
					float3 temp_output_7980_0_g71068 = ( ase_mainLightColorLDR * ase_mainLightIntensity * ase_mainLightShadowAtten );
					float3 MainLight_Scene_Lighting1527_g71068 = temp_output_7980_0_g71068;
					float temp_output_6993_0_g71068 = (_IndirectSpecular*( 1.0 - Metallic403_g71068 ) + Metallic403_g71068);
					float3 temp_output_7000_0_g71068 = (( indirectSpecular647_g71068 * ( _IndirectSpecColor * MainLight_Scene_Lighting1527_g71068 ) )*temp_output_6993_0_g71068 + ( 1.0 - temp_output_6993_0_g71068 ));
					float3 Indirect_Specular600_g71068 = temp_output_7000_0_g71068;
					float localStochasticTiling2_g71087 = ( 0.0 );
					float2 UV2_g71087 = UV_Raw_UV2902_g71068;
					float4 TexelSize2_g71087 = _SpecularMap_TexelSize;
					float4 Offsets2_g71087 = float4( 0,0,0,0 );
					float2 Weights2_g71087 = float2( 0,0 );
					{
					UV2_g71087 = UV2_g71087 * TexelSize2_g71087.zw - 0.5;
					float2 f = frac( UV2_g71087 );
					UV2_g71087 -= f;
					float4 xn = float4( 1.0, 2.0, 3.0, 4.0 ) - f.xxxx;
					float4 yn = float4( 1.0, 2.0, 3.0, 4.0 ) - f.yyyy;
					float4 xs = xn * xn * xn;
					float4 ys = yn * yn * yn;
					float3 xv = float3( xs.x, xs.y - 4.0 * xs.x, xs.z - 4.0 * xs.y + 6.0 * xs.x );
					float3 yv = float3( ys.x, ys.y - 4.0 * ys.x, ys.z - 4.0 * ys.y + 6.0 * ys.x );
					float4 xc = float4( xv.xyz, 6.0 - xv.x - xv.y - xv.z );
					float4 yc = float4( yv.xyz, 6.0 - yv.x - yv.y - yv.z );
					float4 c = float4( UV2_g71087.x - 0.5, UV2_g71087.x + 1.5, UV2_g71087.y - 0.5, UV2_g71087.y + 1.5 );
					float4 s = float4( xc.x + xc.y, xc.z + xc.w, yc.x + yc.y, yc.z + yc.w );
					float w0 = s.x / ( s.x + s.y );
					float w1 = s.z / ( s.z + s.w );
					Offsets2_g71087 = ( c + float4( xc.y, xc.w, yc.y, yc.w ) / s ) * TexelSize2_g71087.xyxy;
					Weights2_g71087 = float2( w0, w1 );
					}
					float4 Input_FetchOffsets197_g71092 = Offsets2_g71087;
					float2 Input_FetchWeights200_g71092 = Weights2_g71087;
					float2 break187_g71092 = Input_FetchWeights200_g71092;
					float4 lerpResult181_g71092 = lerp( SAMPLE_TEXTURE2D( _SpecularMap, sampler_MainTex, (Input_FetchOffsets197_g71092).yw ) , SAMPLE_TEXTURE2D( _SpecularMap, sampler_MainTex, (Input_FetchOffsets197_g71092).xw ) , break187_g71092.x);
					float4 lerpResult182_g71092 = lerp( SAMPLE_TEXTURE2D( _SpecularMap, sampler_MainTex, (Input_FetchOffsets197_g71092).yz ) , SAMPLE_TEXTURE2D( _SpecularMap, sampler_MainTex, (Input_FetchOffsets197_g71092).xz ) , break187_g71092.x);
					float4 lerpResult176_g71092 = lerp( lerpResult181_g71092 , lerpResult182_g71092 , break187_g71092.y);
					float4 Output_Fetch2D_Auto202_g71092 = lerpResult176_g71092;
					float3 Specular_Map64_g71068 = ( (_SpecularColor).rgb * (Output_Fetch2D_Auto202_g71092).rgb );
					float3 lerpResult7213_g71068 = lerp( ( temp_output_48_0_g71068 * (Dieletric7593_g71068).a ) , ( ( 1.0 - (Dieletric7593_g71068).rgb ) * Specular_Map64_g71068 ) , ( Metallic403_g71068 * 0.5 ));
					float3 specColor7214_g71068 = lerpResult7213_g71068;
					float grazingTerm4732_g71068 = saturate( ( temp_output_400_0_g71068 + temp_output_1292_0_g71068 ) );
					float3 temp_cast_3 = (grazingTerm4732_g71068).xxx;
					float temp_output_7196_0_g71068 = saturate( ( 1.0 - DotProducts_NdotV_Zero210_g71068 ) );
					float3 lerpResult7195_g71068 = lerp( specColor7214_g71068 , temp_cast_3 , ( temp_output_7196_0_g71068 * temp_output_7196_0_g71068 * temp_output_7196_0_g71068 * temp_output_7196_0_g71068 * temp_output_7196_0_g71068 ));
					float dotResult5563_g71068 = dot( Surface_Data_Normal_WS_Final7693_g71068 , Surface_Data_HalfDir7369_g71068 );
					float2 appendResult7502_g71068 = (float2(dotResult5651_g71068 , dotResult5563_g71068));
					float2 DotProducts_GSFdots_totalRaw7498_g71068 = appendResult7502_g71068;
					float temp_output_7509_0_g71068 = ( _LightWrapping * 0.5 );
					float2 break7510_g71068 = max( (DotProducts_GSFdots_totalRaw7498_g71068*( 1.0 - temp_output_7509_0_g71068 ) + temp_output_7509_0_g71068), 1E-37 );
					float Shadow_65_g71068 = ( ( DotProducts_NdotV_Zero210_g71068 * break7510_g71068.x ) / ( DotProducts_LdotH_Total2265_g71068 * max( break7510_g71068.x, DotProducts_NdotV_Zero210_g71068 ) ) );
					float3 normalizeResult5429_g71068 = normalize( ase_tangentWS );
					float3 Surface_Data_Tangent_WS_Noralized2280_g71068 = normalizeResult5429_g71068;
					float dotResult5693_g71068 = dot( Surface_Data_Tangent_WS_Noralized2280_g71068 , Surface_Data_HalfDir7369_g71068 );
					float3 normalizeResult5428_g71068 = normalize( ase_bitangentWS );
					float3 Surface_Data_Bitangent_WS_Noralized2279_g71068 = normalizeResult5428_g71068;
					float dotResult5692_g71068 = dot( Surface_Data_Bitangent_WS_Noralized2279_g71068 , Surface_Data_HalfDir7369_g71068 );
					float2 appendResult7841_g71068 = (float2(dotResult5693_g71068 , dotResult5692_g71068));
					float2 DotProducts_HdotXY7842_g71068 = appendResult7841_g71068;
					float temp_output_6623_0_g71068 = ( 1.0 - Smoothness_417_g71068 );
					float temp_output_6624_0_g71068 = ( temp_output_6623_0_g71068 * temp_output_6623_0_g71068 );
					float temp_output_6625_0_g71068 = sqrt( ( 1.0 - ( _NDFAnistropic * 0.9 ) ) );
					float2 appendResult6628_g71068 = (float2(( temp_output_6624_0_g71068 / temp_output_6625_0_g71068 ) , ( temp_output_6625_0_g71068 * temp_output_6624_0_g71068 )));
					float2 NDF_Anistropic_AspectVec6955_g71068 = ( max( appendResult6628_g71068, 0.001 ) * 5 );
					float2 temp_output_6580_0_g71068 = ( DotProducts_HdotXY7842_g71068 / NDF_Anistropic_AspectVec6955_g71068 );
					float DotProducts_NdotH_Zero655_g71068 = max( dotResult5563_g71068, 1E-37 );
					float3 appendResult6581_g71068 = (float3(temp_output_6580_0_g71068 , DotProducts_NdotH_Zero655_g71068));
					float dotResult6582_g71068 = dot( appendResult6581_g71068 , appendResult6581_g71068 );
					float2 break6589_g71068 = NDF_Anistropic_AspectVec6955_g71068;
					#if ( SHADER_TARGET >= 50 )
					float recip6586_g71068 = rcp( max( ( ( dotResult6582_g71068 * dotResult6582_g71068 ) * break6589_g71068.x * break6589_g71068.y * UNITY_PI ), 0.1 ) );
					#else
					float recip6586_g71068 = 1.0 / max( ( ( dotResult6582_g71068 * dotResult6582_g71068 ) * break6589_g71068.x * break6589_g71068.y * UNITY_PI ), 0.1 );
					#endif
					float Specular200_g71068 = recip6586_g71068;
					float clampResult7104_g71068 = clamp( _fresnelIOR , 1.0 , 4.0 );
					float temp_output_7101_0_g71068 = ( pow( ( clampResult7104_g71068 - 1.0 ) , 2.0 ) / pow( ( clampResult7104_g71068 + 1.0 ) , 2.0 ) );
					float temp_output_7108_0_g71068 = saturate( ( 1.0 - DotProducts_LdotH_Total2265_g71068 ) );
					float Fresnel_Term201_g71068 = ( temp_output_7101_0_g71068 + ( ( 1.0 - temp_output_7101_0_g71068 ) * ( temp_output_7108_0_g71068 * temp_output_7108_0_g71068 * temp_output_7108_0_g71068 * temp_output_7108_0_g71068 * temp_output_7108_0_g71068 ) ) );
					float DotProducts_NdotL_LWrap7545_g71068 = break7510_g71068.x;
					float MainLight_Atten5446_g71068 = ase_mainLightShadowAtten;
					float MainLight_FinalAtten7914_g71068 = MainLight_Atten5446_g71068;
					float temp_output_7917_0_g71068 = ( 1.0 - ( DotProducts_NdotL_LWrap7545_g71068 * MainLight_FinalAtten7914_g71068 ) );
					float3 lerpResult4741_g71068 = lerp( ( temp_output_48_0_g71068 * _ShadowColor.rgb ) , _ShadowColor.rgb , _ShadowColor.a);
					float3 Shadow_Color4747_g71068 = ( lerpResult4741_g71068 * Occlusion435_g71068 * _ShadowColorEnable );
					
					float3 ase_positionRWS = IN.ase_texcoord8.xyz;
					float3 temp_output_102_0_g71077 = ( cross( ddx( ase_positionRWS ) , ddy( ase_positionRWS ) ) * _ProjectionParams.x );
					float3 normalizeResult79_g71077 = normalize( temp_output_102_0_g71077 );
					float dotResult3700_g71068 = dot( normalizeResult79_g71077 , Surface_Data_ViewDir_WS_Normalized1115_g71068 );
					float temp_output_3702_0_g71068 = ( 1.0 - abs( dotResult3700_g71068 ) );
					float temp_output_3704_0_g71068 = ( 1.0 - ( temp_output_3702_0_g71068 * temp_output_3702_0_g71068 ) );
					float lerpResult3708_g71068 = lerp( 1.0 , temp_output_3704_0_g71068 , _EnableClipGlancingAngle);
					float temp_output_5306_0_g71068 = ( (  (0.0 + ( ( 1.0 - (temp_output_2_0_g71110).a ) - 0.0 ) * ( _AlphaRemapMin - 0.0 ) / ( 1.0 - 0.0 ) ) +  (0.0 + ( (temp_output_2_0_g71110).a - 0.0 ) * ( _AlphaRemapMax - 0.0 ) / ( 1.0 - 0.0 ) ) ) * lerpResult3708_g71068 );
					float lerpResult5304_g71068 = lerp( 1.0 , temp_output_5306_0_g71068 , _AlphaClip);
					
					float lerpResult5320_g71068 = lerp( 0.01 , _AlphaCutoffShadow , _UseShadowThreshold);
					

					float4 Color = float4( max( ( ( ( ( temp_output_48_0_g71068 * (Dieletric7593_g71068).a ) * ( 1.0 - Metallic403_g71068 ) * ( break7191_g71068.x * break7191_g71068.y ) ) + Indirect_Diffuse644_g71068 + ( Indirect_Specular600_g71068 * lerpResult7195_g71068 * max( Metallic403_g71068, 0.15 ) * ( 1.0 - ( Roughness730_g71068 * Roughness730_g71068 * Roughness730_g71068 ) ) ) + ( ( Shadow_65_g71068 * ( Specular200_g71068 * lerpResult7213_g71068 ) * ( Fresnel_Term201_g71068 * lerpResult7213_g71068 ) ) / ( max( DotProducts_NdotL_LWrap7545_g71068, 0.1 ) * max( 0.1, DotProducts_NdotV_Zero210_g71068 ) * 4.0 ) ) ) * MainLight_Scene_Lighting1527_g71068 * DotProducts_NdotL_LWrap7545_g71068 ), ( temp_output_7917_0_g71068 * temp_output_7917_0_g71068 * Shadow_Color4747_g71068 ) ) , 0.0 );
					float Alpha = lerpResult5304_g71068;
					half AlphaClipThreshold = _Cutoff;
					half AlphaClipThresholdShadow = lerpResult5320_g71068;

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
				#define _ALPHATEST_SHADOW_ON 1
				#define ASE_VERSION 19907
				#define ASE_USING_SAMPLING_MACROS 1

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

				#include "UnityStandardBRDF.cginc"
				#define ASE_NEEDS_TEXTURE_COORDINATES0
				#define ASE_NEEDS_FRAG_TEXTURE_COORDINATES0
				#define ASE_NEEDS_VERT_POSITION
				#if defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL) || (defined(SHADER_TARGET_SURFACE_ANALYSIS) && !defined(SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER))//ASE Sampler Macros
				#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex.Sample(samplerTex,coord)
				#else//ASE Sampling Macros
				#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex2D(tex,coord)
				#endif//ASE Sampling Macros
				


				struct appdata
				{
					float4 vertex : POSITION;
					half3 normal : NORMAL;
					float4 ase_texcoord : TEXCOORD0;
					UNITY_VERTEX_INPUT_INSTANCE_ID
				};

				struct v2f
				{
					V2F_SHADOW_CASTER;
					float4 ase_texcoord1 : TEXCOORD1;
					float4 ase_texcoord2 : TEXCOORD2;
					float4 ase_texcoord3 : TEXCOORD3;
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

				uniform int _Cull;
				UNITY_DECLARE_TEX2D_NOSAMPLER(_MainTex);
				uniform float4 _MainTex_ST;
				float4 _MainTex_TexelSize;
				SamplerState sampler_MainTex;
				uniform float _AlphaRemapMin;
				uniform float _AlphaRemapMax;
				uniform float _EnableClipGlancingAngle;
				uniform float _AlphaClip;
				uniform float _Cutoff;
				uniform float _AlphaCutoffShadow;
				uniform float _UseShadowThreshold;


				float4x4 InverseProjectionMatrix()
				{
					float4x4 m = UNITY_MATRIX_P;
					float n11 = m[ 0 ][ 0 ];
					float n22 = m[ 1 ][ 1 ];
					float n33 = m[ 2 ][ 2 ];
					float n34 = m[ 3 ][ 2 ];
					float n43 = m[ 2 ][ 3 ];
					float t11 = -n22 * n34 * n43;
					float det = n11 * t11;
					float idet = 1.0f / det;
					m[ 0 ][ 0 ] = +t11* idet;
					m[ 1 ][ 1 ] = -n11* n34 * n43* idet;
					m[ 2 ][ 2 ] = 0;
					m[ 2 ][ 3 ] = -n11* n22 * n43* idet;
					m[ 3 ][ 2 ] = -n11* n22 * n34* idet;
					m[ 3 ][ 3 ] = +n11* n22 * n33* idet;
					return m;
				}
				

				v2f vert( appdata v  )
				{
					UNITY_SETUP_INSTANCE_ID( v );
					v2f o;
					UNITY_INITIALIZE_OUTPUT( v2f, o );
					UNITY_TRANSFER_INSTANCE_ID( v, o );
					UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );

					float4 ase_positionCS = UnityObjectToClipPos( v.vertex );
					float4x4 ase_matrixInvP = InverseProjectionMatrix();
					float4 ase_hpositionVS = mul( ase_matrixInvP, ase_positionCS );
					float3 ase_positionRWS = mul( ( float3x3 )UNITY_MATRIX_I_V, ase_hpositionVS.xyz / ase_hpositionVS.w );
					o.ase_texcoord2.xyz = ase_positionRWS;
					float3 ase_positionWS = mul( unity_ObjectToWorld, float4( ( v.vertex ).xyz, 1 ) ).xyz;
					o.ase_texcoord3.xyz = ase_positionWS;
					
					o.ase_texcoord1.xy = v.ase_texcoord.xy;
					
					//setting value to unused interpolator channels and avoid initialization warnings
					o.ase_texcoord1.zw = 0;
					o.ase_texcoord2.w = 0;
					o.ase_texcoord3.w = 0;

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

					float localStochasticTiling2_g71073 = ( 0.0 );
					float2 UV_Raw_UV2902_g71068 = ( ( IN.ase_texcoord1.xy * (_MainTex_ST).xy ) + (_MainTex_ST).zw );
					float2 UV2_g71073 = UV_Raw_UV2902_g71068;
					float4 TexelSize2_g71073 = _MainTex_TexelSize;
					float4 Offsets2_g71073 = float4( 0,0,0,0 );
					float2 Weights2_g71073 = float2( 0,0 );
					{
					UV2_g71073 = UV2_g71073 * TexelSize2_g71073.zw - 0.5;
					float2 f = frac( UV2_g71073 );
					UV2_g71073 -= f;
					float4 xn = float4( 1.0, 2.0, 3.0, 4.0 ) - f.xxxx;
					float4 yn = float4( 1.0, 2.0, 3.0, 4.0 ) - f.yyyy;
					float4 xs = xn * xn * xn;
					float4 ys = yn * yn * yn;
					float3 xv = float3( xs.x, xs.y - 4.0 * xs.x, xs.z - 4.0 * xs.y + 6.0 * xs.x );
					float3 yv = float3( ys.x, ys.y - 4.0 * ys.x, ys.z - 4.0 * ys.y + 6.0 * ys.x );
					float4 xc = float4( xv.xyz, 6.0 - xv.x - xv.y - xv.z );
					float4 yc = float4( yv.xyz, 6.0 - yv.x - yv.y - yv.z );
					float4 c = float4( UV2_g71073.x - 0.5, UV2_g71073.x + 1.5, UV2_g71073.y - 0.5, UV2_g71073.y + 1.5 );
					float4 s = float4( xc.x + xc.y, xc.z + xc.w, yc.x + yc.y, yc.z + yc.w );
					float w0 = s.x / ( s.x + s.y );
					float w1 = s.z / ( s.z + s.w );
					Offsets2_g71073 = ( c + float4( xc.y, xc.w, yc.y, yc.w ) / s ) * TexelSize2_g71073.xyxy;
					Weights2_g71073 = float2( w0, w1 );
					}
					float4 Input_FetchOffsets197_g71080 = Offsets2_g71073;
					float2 Input_FetchWeights200_g71080 = Weights2_g71073;
					float2 break187_g71080 = Input_FetchWeights200_g71080;
					float4 lerpResult181_g71080 = lerp( SAMPLE_TEXTURE2D( _MainTex, sampler_MainTex, (Input_FetchOffsets197_g71080).yw ) , SAMPLE_TEXTURE2D( _MainTex, sampler_MainTex, (Input_FetchOffsets197_g71080).xw ) , break187_g71080.x);
					float4 lerpResult182_g71080 = lerp( SAMPLE_TEXTURE2D( _MainTex, sampler_MainTex, (Input_FetchOffsets197_g71080).yz ) , SAMPLE_TEXTURE2D( _MainTex, sampler_MainTex, (Input_FetchOffsets197_g71080).xz ) , break187_g71080.x);
					float4 lerpResult176_g71080 = lerp( lerpResult181_g71080 , lerpResult182_g71080 , break187_g71080.y);
					float4 Output_Fetch2D_Auto202_g71080 = lerpResult176_g71080;
					float4 temp_output_2_0_g71110 = Output_Fetch2D_Auto202_g71080;
					float3 ase_positionRWS = IN.ase_texcoord2.xyz;
					float3 temp_output_102_0_g71077 = ( cross( ddx( ase_positionRWS ) , ddy( ase_positionRWS ) ) * _ProjectionParams.x );
					float3 normalizeResult79_g71077 = normalize( temp_output_102_0_g71077 );
					float3 ase_positionWS = IN.ase_texcoord3.xyz;
					float3 ase_viewVectorWS = ( _WorldSpaceCameraPos.xyz - ase_positionWS );
					float3 ase_viewDirSafeWS = Unity_SafeNormalize( ase_viewVectorWS );
					float3 Surface_Data_ViewDir_WS_Normalized1115_g71068 = ase_viewDirSafeWS;
					float dotResult3700_g71068 = dot( normalizeResult79_g71077 , Surface_Data_ViewDir_WS_Normalized1115_g71068 );
					float temp_output_3702_0_g71068 = ( 1.0 - abs( dotResult3700_g71068 ) );
					float temp_output_3704_0_g71068 = ( 1.0 - ( temp_output_3702_0_g71068 * temp_output_3702_0_g71068 ) );
					float lerpResult3708_g71068 = lerp( 1.0 , temp_output_3704_0_g71068 , _EnableClipGlancingAngle);
					float temp_output_5306_0_g71068 = ( (  (0.0 + ( ( 1.0 - (temp_output_2_0_g71110).a ) - 0.0 ) * ( _AlphaRemapMin - 0.0 ) / ( 1.0 - 0.0 ) ) +  (0.0 + ( (temp_output_2_0_g71110).a - 0.0 ) * ( _AlphaRemapMax - 0.0 ) / ( 1.0 - 0.0 ) ) ) * lerpResult3708_g71068 );
					float lerpResult5304_g71068 = lerp( 1.0 , temp_output_5306_0_g71068 , _AlphaClip);
					
					float lerpResult5320_g71068 = lerp( 0.01 , _AlphaCutoffShadow , _UseShadowThreshold);
					

					float Alpha = lerpResult5304_g71068;
					half AlphaClipThreshold = _Cutoff;
					half AlphaClipThresholdShadow = lerpResult5320_g71068;

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
Node;AmplifyShaderEditor.StickyNoteNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;451;1664,-1056;Inherit;False;291.9852;124.964;Physical Based Rendering Hair;;0,0,0,1;Physical Based Rendering Hair$-- GSF Ashikhmin Shirley$-- NDF Trowbridge Reitz Anisotropic$-- Schlick IOR Fresnel$;0;0
Node;AmplifyShaderEditor.IntNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;263;2048,-1024;Inherit;False;Property;_Cull;Render Face;0;1;[Enum];Create;False;1;;0;1;Front,2,Back,1,Both,0;True;0;False;2;0;False;0;0;0;1;INT;0
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;469;1664,-896;Inherit;False;PBR Core;1;;71068;d226ce46eb9ddb04ba9f0a949b5fddfe;85,213,1,7304,1,7367,1,7550,1,7548,1,7501,1,6310,1,7285,5,240,5,6530,0,6571,0,4772,2,215,2,7120,1,7607,1,7616,1,7596,1,4196,1,4154,1,4195,1,4106,1,4107,1,4230,1,4153,1,4229,1,4421,0,4271,0,4032,0,4095,0,4094,0,4031,0,4502,0,4501,0,4503,0,4504,0,3744,1,3830,1,545,1,7651,1,2985,0,2970,0,2944,0,3324,0,4114,0,4193,0,3560,0,4505,0,4494,0,4159,0,3561,0,3022,0,4232,0,3400,0,4231,0,4194,0,4152,0,3398,0,3399,0,4495,0,4514,0,1588,0,5143,0,5140,0,5157,0,5158,0,5089,0,5141,0,5139,0,5034,0,3650,1,7694,0,3273,0,3281,0,1886,0,1463,0,1887,0,5667,0,5737,0,5643,0,7839,0,5744,0,7913,0,5802,0,5638,0,5632,0;0;4;FLOAT3;0;FLOAT;156;FLOAT;159;FLOAT;158
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;454;2048,-944;Float;False;False;-1;3;AmplifyShaderEditor.MaterialInspector;0;1;New Amplify Shader;0770190933193b94aaa3065e307002fa;True;ShadowCaster;0;1;ShadowCaster;0;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;1;False;;True;1;RenderType=Opaque=RenderType;True;3;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;False;;True;3;False;;False;False;True;1;LightMode=ShadowCaster;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;453;2048,-896;Float;False;True;-1;3;AmplifyShaderEditor.MaterialInspector;0;4;AmplifyShaderPack/Community/Physical Based Rendering Hair;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;7;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;True;True;0;True;_Cull;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;1;False;;True;1;RenderType=Opaque=RenderType;True;3;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;False;0;;0;0;Standard;5;Alpha Clipping;1;639042284250199950;  Use Shadow Threshold;1;639042284256833961;Cast Shadows;1;0;Write Depth;0;0;Vertex Position;1;0;0;2;True;True;False;;True;0
WireConnection;453;0;469;0
WireConnection;453;7;469;156
WireConnection;453;8;469;159
WireConnection;453;9;469;158
ASEEND*/
//CHKSM=64E139E8CBD750199F037C13B29B757EC1766901