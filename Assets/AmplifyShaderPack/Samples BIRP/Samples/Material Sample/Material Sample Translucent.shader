// Made with Amplify Shader Editor v1.9.9.7
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AmplifyShaderPack/Material Sample Translucent"
{
	Properties
	{
		[Enum(Front,2,Back,1,Both,0)] _Cull( "Render Face", Int ) = 2
		[Toggle][Space(10)] _AlphaClip( "Alpha Clipping", Float ) = 0
		_Cutoff( "Threshold", Range( 0, 1 ) ) = 0.5
		[Toggle] _UseShadowThreshold( "Use Shadow Threshold", Float ) = 0
		_AlphaCutoffShadow( "Shadow Threshold", Range( 0.01, 1 ) ) = 0.01
		[MainColor][Space(15)] _Color( "Base Color", Color ) = ( 1, 1, 1, 1 )
		_Brightness( "Brightness", Range( 0, 2 ) ) = 1
		[SingleLineTexture][MainTexture][Space(10)] _MainTex( "Base Map", 2D ) = "white" {}
		_MainTex_ST( "Main UVs", Vector ) = ( 1, 1, 0, 0 )
		[SingleLineTexture] _MetallicGlossMap( "Metallic Map", 2D ) = "white" {}
		_Metallic( "Metallic", Range( 0, 1 ) ) = 0
		[Enum(SpecularAlpha,0,AlbedoAlpha,1)][Space(10)] _Smoothnesstexturechannel( "Smoothness texture channel", Float ) = 0
		_Glossiness( "Smoothness", Range( 0, 1 ) ) = 0
		[SingleLineTexture][Space(10)] _OcclusionMap( "Occlusion Map", 2D ) = "white" {}
		_OcclusionStrength( "Occlusion Strength", Range( 0, 1 ) ) = 0
		[SingleLineTexture][Space(10)] _SpecGlossMap( "Specular Map", 2D ) = "white" {}
		_SpecColor( "Specular Color", Color ) = ( 0.4392157, 0.4392157, 0.4392157, 0 )
		_SpecularStrength( "Specular Strength", Range( 0, 5 ) ) = 0.5
		[Enum(Flip,0,Mirror,1,None,2)][Space(15)] _DoubleSidedNormalMode( "Normal Mode", Float ) = 2
		[Normal][SingleLineTexture] _BumpMap( "Normal Map", 2D ) = "bump" {}
		_BumpScale( "Normal Scale", Float ) = 1
		[Toggle][Space(15)] _EMISSION( "ENABLE EMISSION", Float ) = 0
		[HDR] _EmissionColor( "Emissive Color", Color ) = ( 0, 0, 0, 0 )
		_EmissiveIntensity( "Emissive Intensity", Float ) = 1
		[SingleLineTexture] _EmissionMap( "Emissive Color Map", 2D ) = "white" {}
		_EmissionMap_ST( "Emissive UVs", Vector ) = ( 1, 1, 0, 0 )
		[Toggle][Space(10)] _TranslucencyMapEnable( "ENABLE TRANSLUCENCY", Float ) = 0
		[SingleLineTexture] _TranslucencyMap( "Translucency Map", 2D ) = "white" {}
		[HDR] _TranslucencyColor( "Translucency Color", Color ) = ( 0.35, 0.35, 0.35, 1 )
		_TranslucencyStrength( "Translucency Strength", Range( 0, 50 ) ) = 0.5
		_TranslucencyFeather( "Translucency Feather", Range( 0.25, 2 ) ) = 0.5
		_TranslucencyNormalDistortion( "Translucency Normal Distortion", Range( 0, 1 ) ) = 0.5
		_TranslucencyScattering( "Translucency Scatterring", Range( 1, 50 ) ) = 1
		_TranslucencyDirect( "Translucency Direct", Range( 0, 1 ) ) = 0.4510137
		_TranslucencyAmbient( "Translucency Ambient", Range( 0, 1 ) ) = 0.65
		_IndirectDiffuse( "Indirect Diffuse", Range( 0, 1 ) ) = 0.5
		[Header(ASE TRANSLUCENCY)][Space(10)] _ASETranslucencyStrength( "ASE Translucency Strength", Range( 1, 50 ) ) = 1
		_ASETranslucencyNormalDistortion( "ASE Translucency Normal Distortion ", Range( 0, 1 ) ) = 0.2735869
		_ASETranslucencyScattering( "ASE Translucency Scattering ", Range( 1, 50 ) ) = 2
		_ASETranslucencyDirect( "ASE Translucency Direct ", Range( 0, 1 ) ) = 0
		_ASETranslucencyAmbient( "ASE Translucency Ambient", Range( 0, 1 ) ) = 0.8339342
		_ASETranslucencyShadow( "ASE Translucency Shadow ", Range( 0, 1 ) ) = 0.5


		//_TransmissionShadow( "Transmission Shadow", Range( 0, 1 ) ) = 0.5
		//_TransStrength( "Strength", Range( 0, 50 ) ) = 1
		//_TransNormal( "Normal Distortion", Range( 0, 1 ) ) = 0.5
		//_TransScattering( "Scattering", Range( 1, 50 ) ) = 2
		//_TransDirect( "Direct", Range( 0, 1 ) ) = 0.9
		//_TransAmbient( "Ambient", Range( 0, 1 ) ) = 0.1
		//_TransShadow( "Shadow", Range( 0, 1 ) ) = 0.5

		//_TessPhongStrength( "Tess Phong Strength", Range( 0, 1 ) ) = 0.5
		//_TessValue( "Tess Max Tessellation", Range( 1, 32 ) ) = 16
		//_TessMin( "Tess Min Distance", Float ) = 10
		//_TessMax( "Tess Max Distance", Float ) = 25
		//_TessEdgeLength ( "Tess Edge length", Range( 2, 50 ) ) = 16
		//_TessMaxDisp( "Tess Max Displacement", Float ) = 25

		[ToggleOff] _SpecularHighlights("Specular Highlights", Float) = 1.0
		[ToggleOff] _GlossyReflections("Reflections", Float) = 1.0

		//_InstancedTerrainNormals("Specular Highlights", Float) = 1.0
	}

	SubShader
	{
		

		

		Tags { "RenderType"="Opaque" "Queue"="Geometry" "DisableBatching"="False" }

	LOD 0

		Cull [_Cull]
		AlphaToMask Off
		ZWrite On
		ZTest LEqual
		ColorMask RGBA

		

		Blend Off
		

		CGINCLUDE
			#pragma target 3.5
			// ensure rendering platforms toggle list is visible

			float4 FixedTess( float tessValue )
			{
				return tessValue;
			}

			float CalcDistanceTessFactor (float4 vertex, float minDist, float maxDist, float tess, float4x4 o2w, float3 cameraPos )
			{
				float3 wpos = mul(o2w,vertex).xyz;
				float dist = distance (wpos, cameraPos);
				float f = clamp(1.0 - (dist - minDist) / (maxDist - minDist), 0.01, 1.0) * tess;
				return f;
			}

			float4 CalcTriEdgeTessFactors (float3 triVertexFactors)
			{
				float4 tess;
				tess.x = 0.5 * (triVertexFactors.y + triVertexFactors.z);
				tess.y = 0.5 * (triVertexFactors.x + triVertexFactors.z);
				tess.z = 0.5 * (triVertexFactors.x + triVertexFactors.y);
				tess.w = (triVertexFactors.x + triVertexFactors.y + triVertexFactors.z) / 3.0f;
				return tess;
			}

			float CalcEdgeTessFactor (float3 wpos0, float3 wpos1, float edgeLen, float3 cameraPos, float4 scParams )
			{
				float dist = distance (0.5 * (wpos0+wpos1), cameraPos);
				float len = distance(wpos0, wpos1);
				float f = max(len * scParams.y / (edgeLen * dist), 1.0);
				return f;
			}

			float DistanceFromPlane (float3 pos, float4 plane)
			{
				float d = dot (float4(pos,1.0f), plane);
				return d;
			}

			bool WorldViewFrustumCull (float3 wpos0, float3 wpos1, float3 wpos2, float cullEps, float4 planes[6] )
			{
				float4 planeTest;
				planeTest.x = (( DistanceFromPlane(wpos0, planes[0]) > -cullEps) ? 1.0f : 0.0f ) +
							  (( DistanceFromPlane(wpos1, planes[0]) > -cullEps) ? 1.0f : 0.0f ) +
							  (( DistanceFromPlane(wpos2, planes[0]) > -cullEps) ? 1.0f : 0.0f );
				planeTest.y = (( DistanceFromPlane(wpos0, planes[1]) > -cullEps) ? 1.0f : 0.0f ) +
							  (( DistanceFromPlane(wpos1, planes[1]) > -cullEps) ? 1.0f : 0.0f ) +
							  (( DistanceFromPlane(wpos2, planes[1]) > -cullEps) ? 1.0f : 0.0f );
				planeTest.z = (( DistanceFromPlane(wpos0, planes[2]) > -cullEps) ? 1.0f : 0.0f ) +
							  (( DistanceFromPlane(wpos1, planes[2]) > -cullEps) ? 1.0f : 0.0f ) +
							  (( DistanceFromPlane(wpos2, planes[2]) > -cullEps) ? 1.0f : 0.0f );
				planeTest.w = (( DistanceFromPlane(wpos0, planes[3]) > -cullEps) ? 1.0f : 0.0f ) +
							  (( DistanceFromPlane(wpos1, planes[3]) > -cullEps) ? 1.0f : 0.0f ) +
							  (( DistanceFromPlane(wpos2, planes[3]) > -cullEps) ? 1.0f : 0.0f );
				return !all (planeTest);
			}

			float4 DistanceBasedTess( float4 v0, float4 v1, float4 v2, float tess, float minDist, float maxDist, float4x4 o2w, float3 cameraPos )
			{
				float3 f;
				f.x = CalcDistanceTessFactor (v0,minDist,maxDist,tess,o2w,cameraPos);
				f.y = CalcDistanceTessFactor (v1,minDist,maxDist,tess,o2w,cameraPos);
				f.z = CalcDistanceTessFactor (v2,minDist,maxDist,tess,o2w,cameraPos);

				return CalcTriEdgeTessFactors (f);
			}

			float4 EdgeLengthBasedTess( float4 v0, float4 v1, float4 v2, float edgeLength, float4x4 o2w, float3 cameraPos, float4 scParams )
			{
				float3 pos0 = mul(o2w,v0).xyz;
				float3 pos1 = mul(o2w,v1).xyz;
				float3 pos2 = mul(o2w,v2).xyz;
				float4 tess;
				tess.x = CalcEdgeTessFactor (pos1, pos2, edgeLength, cameraPos, scParams);
				tess.y = CalcEdgeTessFactor (pos2, pos0, edgeLength, cameraPos, scParams);
				tess.z = CalcEdgeTessFactor (pos0, pos1, edgeLength, cameraPos, scParams);
				tess.w = (tess.x + tess.y + tess.z) / 3.0f;
				return tess;
			}

			float4 EdgeLengthBasedTessCull( float4 v0, float4 v1, float4 v2, float edgeLength, float maxDisplacement, float4x4 o2w, float3 cameraPos, float4 scParams, float4 planes[6] )
			{
				float3 pos0 = mul(o2w,v0).xyz;
				float3 pos1 = mul(o2w,v1).xyz;
				float3 pos2 = mul(o2w,v2).xyz;
				float4 tess;

				if (WorldViewFrustumCull(pos0, pos1, pos2, maxDisplacement, planes))
				{
					tess = 0.0f;
				}
				else
				{
					tess.x = CalcEdgeTessFactor (pos1, pos2, edgeLength, cameraPos, scParams);
					tess.y = CalcEdgeTessFactor (pos2, pos0, edgeLength, cameraPos, scParams);
					tess.z = CalcEdgeTessFactor (pos0, pos1, edgeLength, cameraPos, scParams);
					tess.w = (tess.x + tess.y + tess.z) / 3.0f;
				}
				return tess;
			}

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
			
			Name "ForwardBase"
			Tags { "LightMode"="ForwardBase" }

			Blend One Zero

			CGPROGRAM
				#define ASE_GEOMETRY
				#define ASE_FRAGMENT_NORMAL 0
				#define ASE_RECEIVE_SHADOWS
				#pragma shader_feature_local_fragment _SPECULARHIGHLIGHTS_OFF
				#pragma shader_feature_local_fragment _GLOSSYREFLECTIONS_OFF
				#pragma multi_compile_instancing
				#pragma multi_compile _ LOD_FADE_CROSSFADE
				#pragma multi_compile_fog
				#define ASE_FOG
				#define _SPECULAR_SETUP 1
				#define ASE_TRANSLUCENCY 1
				#define _ALPHATEST_ON
				#define _ALPHATEST_SHADOW_ON 1
				#define ASE_VERSION 19907

				#pragma vertex vert
				#pragma fragment frag
				#pragma multi_compile_fwdbase
				#ifndef UNITY_PASS_FORWARDBASE
					#define UNITY_PASS_FORWARDBASE
				#endif
				#include "HLSLSupport.cginc"
				#if defined( ASE_GEOMETRY ) || defined( ASE_IMPOSTOR )
					#ifndef UNITY_INSTANCED_LOD_FADE
						#define UNITY_INSTANCED_LOD_FADE
					#endif
					#ifndef UNITY_INSTANCED_SH
						#define UNITY_INSTANCED_SH
					#endif
					#ifndef UNITY_INSTANCED_LIGHTMAPSTS
						#define UNITY_INSTANCED_LIGHTMAPSTS
					#endif
				#endif
				#include "UnityShaderVariables.cginc"
				#include "UnityCG.cginc"
				#include "Lighting.cginc"
				#include "UnityPBSLighting.cginc"
				#include "AutoLight.cginc"

				#if defined( UNITY_INSTANCING_ENABLED ) && defined( ASE_INSTANCED_TERRAIN ) && ( defined(_TERRAIN_INSTANCED_PERPIXEL_NORMAL) || defined(_INSTANCEDTERRAINNORMALS_PIXEL) )
					#define ENABLE_TERRAIN_PERPIXEL_NORMAL
				#endif

				#include "UnityStandardUtils.cginc"
				#define ASE_NEEDS_TEXTURE_COORDINATES0
				#define ASE_NEEDS_FRAG_TEXTURE_COORDINATES0
				#define ASE_NEEDS_WORLD_TANGENT
				#define ASE_NEEDS_FRAG_WORLD_TANGENT
				#define ASE_NEEDS_WORLD_NORMAL
				#define ASE_NEEDS_FRAG_WORLD_NORMAL
				#define ASE_NEEDS_FRAG_WORLD_BITANGENT
				#define ASE_NEEDS_FRAG_WORLD_VIEW_DIR
				#define ASE_NEEDS_VERT_TEXTURE_COORDINATES1
				#define ASE_NEEDS_VERT_TEXTURE_COORDINATES2
				#define ASE_NEEDS_VERT_NORMAL


				struct appdata
				{
					float4 vertex : POSITION;
					half3 normal : NORMAL;
					half4 tangent : TANGENT;
					float4 texcoord : TEXCOORD0;
					float4 texcoord1 : TEXCOORD1;
					float4 texcoord2 : TEXCOORD2;
					
					UNITY_VERTEX_INPUT_INSTANCE_ID
				};

				struct v2f
				{
					float4 pos : SV_POSITION;
					float4 worldPos : TEXCOORD0; // xyz = positionWS, w = fogCoord
					half3 normalWS : TEXCOORD1;
					float4 tangentWS : TEXCOORD2; // holds terrainUV ifdef ENABLE_TERRAIN_PERPIXEL_NORMAL
					half4 ambientOrLightmapUV : TEXCOORD3;
					UNITY_LIGHTING_COORDS( 4, 5 )
					float4 ase_texcoord6 : TEXCOORD6;
					float4 ase_lmap : TEXCOORD7;
					float4 ase_sh : TEXCOORD8;
					UNITY_VERTEX_INPUT_INSTANCE_ID
					UNITY_VERTEX_OUTPUT_STEREO
				};

				#ifdef ASE_TRANSMISSION
					float _TransmissionShadow;
				#endif
				#ifdef ASE_TRANSLUCENCY
					float _TransStrength;
					float _TransNormal;
					float _TransScattering;
					float _TransDirect;
					float _TransAmbient;
					float _TransShadow;
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
				uniform float _ASETranslucencyAmbient;
				uniform float _ASETranslucencyDirect;
				uniform float _ASETranslucencyScattering;
				uniform float _ASETranslucencyNormalDistortion;
				uniform float _ASETranslucencyStrength;
				uniform float _ASETranslucencyShadow;
				uniform float4 _Color;
				uniform sampler2D _MainTex;
				uniform float4 _MainTex_ST;
				uniform half _Brightness;
				uniform float _Metallic;
				uniform sampler2D _MetallicGlossMap;
				uniform sampler2D _BumpMap;
				uniform float _BumpScale;
				uniform float _DoubleSidedNormalMode;
				uniform sampler2D _SpecGlossMap;
				uniform float _SpecularStrength;
				uniform float _Smoothnesstexturechannel;
				uniform float _Glossiness;
				uniform sampler2D _OcclusionMap;
				uniform float _OcclusionStrength;
				uniform sampler2D _EmissionMap;
				uniform float4 _EmissionMap_ST;
				uniform float4 _EmissionColor;
				uniform half _EmissiveIntensity;
				uniform float _EMISSION;
				uniform float _AlphaClip;
				uniform float _Cutoff;
				uniform float _AlphaCutoffShadow;
				uniform float _UseShadowThreshold;
				uniform float _TranslucencyNormalDistortion;
				uniform float _TranslucencyScattering;
				uniform float _TranslucencyDirect;
				uniform float _IndirectDiffuse;
				uniform float _TranslucencyAmbient;
				uniform sampler2D _TranslucencyMap;
				uniform float _TranslucencyFeather;
				uniform float4 _TranslucencyColor;
				uniform float _TranslucencyStrength;
				uniform float _TranslucencyMapEnable;


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
				

				v2f VertexFunction( appdata v  )
				{
					UNITY_SETUP_INSTANCE_ID(v);
					v2f o;
					UNITY_INITIALIZE_OUTPUT(v2f,o);
					UNITY_TRANSFER_INSTANCE_ID(v,o);
					UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

					#ifdef DYNAMICLIGHTMAP_ON //dynlm
					o.ase_lmap.zw = v.texcoord2.xyzw.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
					#endif //dynlm
					#ifdef LIGHTMAP_ON //stalm
					o.ase_lmap.xy = v.texcoord1.xyzw.xy * unity_LightmapST.xy + unity_LightmapST.zw;
					#endif //stalm
					float3 ase_positionWS = mul( unity_ObjectToWorld, float4( ( v.vertex ).xyz, 1 ) ).xyz;
					float3 ase_normalWS = UnityObjectToWorldNormal( v.normal );
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
					
					o.ase_texcoord6.xy = v.texcoord.xyzw.xy;
					
					//setting value to unused interpolator channels and avoid initialization warnings
					o.ase_texcoord6.zw = 0;
					o.ase_sh.w = 0;

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
					v.tangent = v.tangent;

					float3 positionWS = mul( unity_ObjectToWorld, v.vertex ).xyz;
					half3 normalWS = UnityObjectToWorldNormal( v.normal );
					half3 tangentWS = UnityObjectToWorldDir( v.tangent.xyz );

					o.pos = UnityObjectToClipPos( v.vertex );
					o.worldPos.xyz = positionWS;
					o.normalWS = normalWS;
					o.tangentWS = half4( tangentWS, v.tangent.w );

					o.ambientOrLightmapUV = 0;
					#ifdef LIGHTMAP_ON
						o.ambientOrLightmapUV.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
					#elif UNITY_SHOULD_SAMPLE_SH
						#ifdef VERTEXLIGHT_ON
							o.ambientOrLightmapUV.rgb += Shade4PointLights(
								unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
								unity_LightColor[0].rgb, unity_LightColor[1].rgb, unity_LightColor[2].rgb, unity_LightColor[3].rgb,
								unity_4LightAtten0, positionWS, normalWS );
						#endif
						o.ambientOrLightmapUV.rgb = ShadeSHPerVertex( normalWS, o.ambientOrLightmapUV.rgb );
					#endif
					#ifdef DYNAMICLIGHTMAP_ON
						o.ambientOrLightmapUV.zw = v.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
					#endif

					#if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
						o.tangentWS.zw = v.texcoord.xy;
						o.tangentWS.xy = v.texcoord.xy * unity_LightmapST.xy + unity_LightmapST.zw;
					#endif

					UNITY_TRANSFER_LIGHTING(o, v.texcoord1.xy);
					#if defined( ASE_FOG )
						UNITY_TRANSFER_FOG_COMBINED_WITH_WORLD_POS( o, o.pos );
					#endif
					return o;
				}

				#if defined(ASE_TESSELLATION)
				struct VertexControl
				{
					float4 vertex : INTERNALTESSPOS;
					half4 tangent : TANGENT;
					half3 normal : NORMAL;
					float4 texcoord : TEXCOORD0;
					float4 texcoord1 : TEXCOORD1;
					float4 texcoord2 : TEXCOORD2;
					
					UNITY_VERTEX_INPUT_INSTANCE_ID
				};

				struct TessellationFactors
				{
					float edge[3] : SV_TessFactor;
					float inside : SV_InsideTessFactor;
				};

				VertexControl vert ( appdata v )
				{
					VertexControl o;
					UNITY_SETUP_INSTANCE_ID(v);
					UNITY_TRANSFER_INSTANCE_ID(v, o);
					o.vertex = v.vertex;
					o.tangent = v.tangent;
					o.normal = v.normal;
					o.texcoord = v.texcoord;
					o.texcoord1 = v.texcoord1;
					o.texcoord2 = v.texcoord2;
					
					return o;
				}

				TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
				{
					TessellationFactors o;
					float4 tf = 1;
					float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
					float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
					#if defined(ASE_FIXED_TESSELLATION)
					tf = FixedTess( tessValue );
					#elif defined(ASE_DISTANCE_TESSELLATION)
					tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, UNITY_MATRIX_M, _WorldSpaceCameraPos );
					#elif defined(ASE_LENGTH_TESSELLATION)
					tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, UNITY_MATRIX_M, _WorldSpaceCameraPos, _ScreenParams );
					#elif defined(ASE_LENGTH_CULL_TESSELLATION)
					tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, UNITY_MATRIX_M, _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
					#endif
					o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
					return o;
				}

				[domain("tri")]
				[partitioning("fractional_odd")]
				[outputtopology("triangle_cw")]
				[patchconstantfunc("TessellationFunction")]
				[outputcontrolpoints(3)]
				VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
				{
				   return patch[id];
				}

				[domain("tri")]
				v2f DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
				{
					appdata o = (appdata) 0;
					o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
					o.tangent = patch[0].tangent * bary.x + patch[1].tangent * bary.y + patch[2].tangent * bary.z;
					o.normal = patch[0].normal * bary.x + patch[1].normal * bary.y + patch[2].normal * bary.z;
					o.texcoord = patch[0].texcoord * bary.x + patch[1].texcoord * bary.y + patch[2].texcoord * bary.z;
					o.texcoord1 = patch[0].texcoord1 * bary.x + patch[1].texcoord1 * bary.y + patch[2].texcoord1 * bary.z;
					o.texcoord2 = patch[0].texcoord2 * bary.x + patch[1].texcoord2 * bary.y + patch[2].texcoord2 * bary.z;
					
					#if defined(ASE_PHONG_TESSELLATION)
					float3 pp[3];
					for (int i = 0; i < 3; ++i)
						pp[i] = o.vertex.xyz - patch[i].normal * (dot(o.vertex.xyz, patch[i].normal) - dot(patch[i].vertex.xyz, patch[i].normal));
					float phongStrength = _TessPhongStrength;
					o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
					#endif
					UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
					return VertexFunction(o);
				}
				#else
				v2f vert ( appdata v )
				{
					return VertexFunction( v );
				}
				#endif

				half4 frag( v2f IN , uint ase_vface : SV_IsFrontFace
							#if defined( ASE_DEPTH_WRITE_ON )
								, out float outputDepth : SV_Depth
							#endif
							) : SV_Target
				{
					UNITY_SETUP_INSTANCE_ID(IN);

					#ifdef LOD_FADE_CROSSFADE
						UNITY_APPLY_DITHER_CROSSFADE(IN.pos.xy);
					#endif

					#if defined(ASE_LIGHTING_SIMPLE)
						SurfaceOutput o = (SurfaceOutput)0;
					#else
						#if defined(_SPECULAR_SETUP)
							SurfaceOutputStandardSpecular o = (SurfaceOutputStandardSpecular)0;
						#else
							SurfaceOutputStandard o = (SurfaceOutputStandard)0;
						#endif
					#endif

					half atten;
					{
						#if defined( ASE_RECEIVE_SHADOWS )
							UNITY_LIGHT_ATTENUATION( temp, IN, IN.worldPos.xyz )
							atten = temp;
						#else
							atten = 1;
						#endif
					}

					float3 PositionWS = IN.worldPos.xyz;
					half3 ViewDirWS = normalize( UnityWorldSpaceViewDir( PositionWS ) );
					float4 ScreenPosNorm = float4( IN.pos.xy * ( _ScreenParams.zw - 1.0 ), IN.pos.zw );
					float4 ClipPos = ComputeClipSpacePosition( ScreenPosNorm.xy, IN.pos.z ) * IN.pos.w;
					float4 ScreenPos = ComputeScreenPos( ClipPos );
					half3 NormalWS = IN.normalWS;
					half3 TangentWS = IN.tangentWS.xyz;
					half3 BitangentWS = cross( IN.normalWS, IN.tangentWS.xyz ) * IN.tangentWS.w * unity_WorldTransformParams.w;
					half3 LightAtten = atten;

					#if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
						float2 sampleCoords = (IN.tangentWS.zw / _TerrainHeightmapRecipSize.zw + 0.5f) * _TerrainHeightmapRecipSize.xy;
						NormalWS = UnityObjectToWorldNormal(normalize(tex2D(_TerrainNormalmapTexture, sampleCoords).rgb * 2 - 1));
						TangentWS = -cross(unity_ObjectToWorld._13_23_33, NormalWS);
						BitangentWS = cross(NormalWS, -TangentWS);
					#endif

					float2 appendResult2941_g72783 = (float2(_MainTex_ST.x , _MainTex_ST.y));
					float2 appendResult2944_g72783 = (float2(_MainTex_ST.z , _MainTex_ST.w));
					float2 UV__MainTex_ST585_g72783 = ( ( IN.ase_texcoord6.xy * appendResult2941_g72783 ) + appendResult2944_g72783 );
					float4 temp_output_2_0_g72784 = tex2D( _MainTex, UV__MainTex_ST585_g72783 );
					#ifdef UNITY_COLORSPACE_GAMMA
					float4 staticSwitch4287_g72783 = float4( 0.2209163, 0.2209163, 0.2209163, 0.7790837 );
					#else
					float4 staticSwitch4287_g72783 = float4( 0.04, 0.04, 0.04, 0.96 );
					#endif
					float temp_output_4286_0_g72783 = (staticSwitch4287_g72783).w;
					float3 temp_cast_0 = (temp_output_4286_0_g72783).xxx;
					float4 tex2DNode606_g72783 = tex2D( _MetallicGlossMap, UV__MainTex_ST585_g72783 );
					float3 Metallic4256_g72783 = ( _Metallic * (tex2DNode606_g72783).rgb );
					
					float m_switch3729_g72783 = _DoubleSidedNormalMode;
					float3 m_Flip3729_g72783 = float3( -1, -1, -1 );
					float3 m_Mirror3729_g72783 = float3( 1, 1, -1 );
					float3 m_None3729_g72783 = float3( 1, 1, 1 );
					float3 local_NormalModefloat3switch3729_g72783 = _NormalModefloat3switch( m_switch3729_g72783 , m_Flip3729_g72783 , m_Mirror3729_g72783 , m_None3729_g72783 );
					float3 switchResult3728_g72783 = (((ase_vface>0)?(UnpackScaleNormal( tex2D( _BumpMap, UV__MainTex_ST585_g72783 ), _BumpScale )):(( UnpackScaleNormal( tex2D( _BumpMap, UV__MainTex_ST585_g72783 ), _BumpScale ) * local_NormalModefloat3switch3729_g72783 ))));
					
					float4 temp_output_2_0_g72786 = tex2D( _SpecGlossMap, UV__MainTex_ST585_g72783 );
					float3 lerpResult4289_g72783 = lerp( (staticSwitch4287_g72783).xyz , ( (_Color).rgb * (temp_output_2_0_g72784).rgb * _Brightness ) , Metallic4256_g72783);
					float3 Specular_Color_from_Metallic4292_g72783 = lerpResult4289_g72783;
					
					float Alpha_SpecGlossMap707_g72783 = (temp_output_2_0_g72786).a;
					float temp_output_2424_6_g72783 = (temp_output_2_0_g72784).a;
					float Alpha_BaseColor634_g72783 = temp_output_2424_6_g72783;
					float lerpResult3560_g72783 = lerp( Alpha_SpecGlossMap707_g72783 , Alpha_BaseColor634_g72783 , _Smoothnesstexturechannel);
					
					float temp_output_681_0_g72783 = saturate( (tex2D( _OcclusionMap, UV__MainTex_ST585_g72783 ).r*_OcclusionStrength + ( 1.0 - _OcclusionStrength )) );
					
					half3 color2551_g72783 = IsGammaSpace() ? half3( 0.003921569, 0, 0 ) : half3( 0.000303527, 0, 0 );
					float2 appendResult2951_g72783 = (float2(_EmissionMap_ST.x , _EmissionMap_ST.y));
					float2 appendResult2954_g72783 = (float2(_EmissionMap_ST.z , _EmissionMap_ST.w));
					float2 UV__EmissionMap_ST597_g72783 = ( ( IN.ase_texcoord6.xy * appendResult2951_g72783 ) + appendResult2954_g72783 );
					float3 lerpResult3557_g72783 = lerp( color2551_g72783 , ( (tex2D( _EmissionMap, UV__EmissionMap_ST597_g72783 )).rgb * ( (_EmissionColor).rgb * _EmissiveIntensity ) ) , _EMISSION);
					
					float lerpResult3822_g72783 = lerp( 1.0 , ( temp_output_2424_6_g72783 * 1.0 ) , _AlphaClip);
					
					float lerpResult3858_g72783 = lerp( 0.01 , _AlphaCutoffShadow , _UseShadowThreshold);
					
					float3 ase_mainLightDirection = _WorldSpaceLightPos0.xyz;
					float3 MainLight_Dir4125_g72783 = ase_mainLightDirection;
					float3 BumpMap4675_g72783 = switchResult3728_g72783;
					float3 tanToWorld0 = float3( TangentWS.x, BitangentWS.x, NormalWS.x );
					float3 tanToWorld1 = float3( TangentWS.y, BitangentWS.y, NormalWS.y );
					float3 tanToWorld2 = float3( TangentWS.z, BitangentWS.z, NormalWS.z );
					float3 tanNormal4137_g72783 = BumpMap4675_g72783;
					float3 worldNormal4137_g72783 = float3( dot( tanToWorld0, tanNormal4137_g72783 ), dot( tanToWorld1, tanNormal4137_g72783 ), dot( tanToWorld2, tanNormal4137_g72783 ) );
					float3 Surface_Data_Normal_WS_Bump4138_g72783 = worldNormal4137_g72783;
					float3 Surface_Data_ViewDir_WS4672_g72783 = ViewDirWS;
					float dotResult4639_g72783 = dot( -( MainLight_Dir4125_g72783 + ( Surface_Data_Normal_WS_Bump4138_g72783 * _TranslucencyNormalDistortion ) ) , Surface_Data_ViewDir_WS4672_g72783 );
					float3 tanNormal4227_g72783 = Surface_Data_Normal_WS_Bump4138_g72783;
					UnityGIInput data4227_g72783;
					UNITY_INITIALIZE_OUTPUT( UnityGIInput, data4227_g72783 );
					#if defined(LIGHTMAP_ON) || defined(DYNAMICLIGHTMAP_ON) //dylm4227_g72783
					data4227_g72783.lightmapUV = IN.ase_lmap;
					#endif //dylm4227_g72783
					#if UNITY_SHOULD_SAMPLE_SH //fsh4227_g72783
					data4227_g72783.ambient = IN.ase_sh;
					#endif //fsh4227_g72783
					UnityGI gi4227_g72783 = UnityGI_Base(data4227_g72783, 1, float3( dot( tanToWorld0, tanNormal4227_g72783 ), dot( tanToWorld1, tanNormal4227_g72783 ), dot( tanToWorld2, tanNormal4227_g72783 ) ));
					float Occlusion3640_g72783 = temp_output_681_0_g72783;
					float3 Indirect_Diffuse4210_g72783 = ( gi4227_g72783.indirect.diffuse * Occlusion3640_g72783 * _IndirectDiffuse );
					float3 ase_mainLightColorLDR = _LightColor0.rgb / ( _LightColor0.a + 1e-7 );
					float ase_mainLightIntensity = _LightColor0.a;
					float ase_mainLightShadowAtten = LightAtten.x;
					float3 temp_output_4680_0_g72783 = ( ase_mainLightColorLDR * ase_mainLightIntensity * ase_mainLightShadowAtten );
					float3 MainLight_Scene_Lighting4123_g72783 = temp_output_4680_0_g72783;
					float3 BaseColor_Map4140_g72783 = ( ( (_Color).rgb * (temp_output_2_0_g72784).rgb * _Brightness ) * ( temp_cast_0 - ( temp_output_4286_0_g72783 * Metallic4256_g72783 ) ) );
					

					o.Albedo = ( ( (_Color).rgb * (temp_output_2_0_g72784).rgb * _Brightness ) * ( temp_cast_0 - ( temp_output_4286_0_g72783 * Metallic4256_g72783 ) ) );
					o.Normal = switchResult3728_g72783;

					half3 Specular = saturate( ( ( ( (_SpecColor).rgb * (temp_output_2_0_g72786).rgb ) * _SpecularStrength ) + Specular_Color_from_Metallic4292_g72783 ) );
					half Metallic = 0;
					half Smoothness = saturate( ( lerpResult3560_g72783 * _Glossiness ) );
					half Occlusion = temp_output_681_0_g72783;

					#if defined(ASE_LIGHTING_SIMPLE)
						o.Specular = Specular.x;
						o.Gloss = Smoothness;
					#else
						#if defined(_SPECULAR_SETUP)
							o.Specular = Specular;
						#else
							o.Metallic = Metallic;
						#endif
						o.Occlusion = Occlusion;
						o.Smoothness = Smoothness;
					#endif

					o.Emission = lerpResult3557_g72783;
					o.Alpha = lerpResult3822_g72783;
					half AlphaClipThreshold = _Cutoff;
					half AlphaClipThresholdShadow = lerpResult3858_g72783;
					half3 BakedGI = 0;
					half3 Transmission = 1;
					half3 Translucency = ( ( ( ( pow( saturate( dotResult4639_g72783 ) , _TranslucencyScattering ) * _TranslucencyDirect ) + ( Indirect_Diffuse4210_g72783 * _TranslucencyAmbient ) ) * MainLight_Scene_Lighting4123_g72783 * BaseColor_Map4140_g72783 * ( (tex2D( _TranslucencyMap, UV__MainTex_ST585_g72783 )).rgb / _TranslucencyFeather ) * (_TranslucencyColor).rgb * _TranslucencyStrength ) * _TranslucencyMapEnable );

					#if defined( ASE_DEPTH_WRITE_ON )
						float DeviceDepth = IN.pos.z;
					#endif

					#ifdef _ALPHATEST_ON
						clip( o.Alpha - AlphaClipThreshold );
					#endif

					#if defined( ASE_CHANGES_WORLD_POS )
					{
						#if defined( ASE_RECEIVE_SHADOWS )
							UNITY_LIGHT_ATTENUATION( temp, IN, PositionWS )
							LightAtten = temp;
						#else
							LightAtten = 1;
						#endif
					}
					#endif

					#if ( ASE_FRAGMENT_NORMAL == 0 )
						o.Normal = normalize( o.Normal.x * TangentWS + o.Normal.y * BitangentWS + o.Normal.z * NormalWS );
					#elif ( ASE_FRAGMENT_NORMAL == 1 )
						o.Normal = UnityObjectToWorldNormal( o.Normal );
					#elif ( ASE_FRAGMENT_NORMAL == 2 )
						// @diogo: already in world-space; do nothing
					#endif

					#if defined( ASE_DEPTH_WRITE_ON )
						outputDepth = DeviceDepth;
					#endif

					#ifndef USING_DIRECTIONAL_LIGHT
						half3 lightDir = normalize( UnityWorldSpaceLightDir( PositionWS ) );
					#else
						half3 lightDir = _WorldSpaceLightPos0.xyz;
					#endif

					UnityGI gi;
					UNITY_INITIALIZE_OUTPUT(UnityGI, gi);
					gi.indirect.diffuse = 0;
					gi.indirect.specular = 0;
					gi.light.color = _LightColor0.rgb;
					gi.light.dir = lightDir;

					UnityGIInput giInput;
					UNITY_INITIALIZE_OUTPUT(UnityGIInput, giInput);
					giInput.light = gi.light;
					giInput.worldPos = PositionWS;
					giInput.worldViewDir = ViewDirWS;
					giInput.atten = atten;
					#if defined(LIGHTMAP_ON) || defined(DYNAMICLIGHTMAP_ON)
						giInput.lightmapUV = IN.ambientOrLightmapUV;
					#else
						giInput.lightmapUV = 0.0;
					#endif
					#if UNITY_SHOULD_SAMPLE_SH && !UNITY_SAMPLE_FULL_SH_PER_PIXEL
						giInput.ambient = IN.ambientOrLightmapUV.rgb;
					#else
						giInput.ambient.rgb = 0.0;
					#endif
					giInput.probeHDR[0] = unity_SpecCube0_HDR;
					giInput.probeHDR[1] = unity_SpecCube1_HDR;
					#if defined(UNITY_SPECCUBE_BLENDING) || defined(UNITY_SPECCUBE_BOX_PROJECTION)
						giInput.boxMin[0] = unity_SpecCube0_BoxMin;
					#endif
					#ifdef UNITY_SPECCUBE_BOX_PROJECTION
						giInput.boxMax[0] = unity_SpecCube0_BoxMax;
						giInput.probePosition[0] = unity_SpecCube0_ProbePosition;
						giInput.boxMax[1] = unity_SpecCube1_BoxMax;
						giInput.boxMin[1] = unity_SpecCube1_BoxMin;
						giInput.probePosition[1] = unity_SpecCube1_ProbePosition;
					#endif

					#if defined(ASE_LIGHTING_SIMPLE)
						#if defined(_SPECULAR_SETUP)
							LightingBlinnPhong_GI(o, giInput, gi);
						#else
							LightingLambert_GI(o, giInput, gi);
						#endif
					#else
						#if defined(_SPECULAR_SETUP)
							LightingStandardSpecular_GI(o, giInput, gi);
						#else
							LightingStandard_GI(o, giInput, gi);
						#endif
					#endif

					#ifdef ASE_BAKEDGI
						gi.indirect.diffuse = BakedGI;
					#endif

					#if UNITY_SHOULD_SAMPLE_SH && !defined(LIGHTMAP_ON) && defined(ASE_NO_AMBIENT)
						gi.indirect.diffuse = 0;
					#endif

					half4 c = 0;
					#if defined(ASE_LIGHTING_SIMPLE)
						#if defined(_SPECULAR_SETUP)
							c += LightingBlinnPhong (o, ViewDirWS, gi);
						#else
							c += LightingLambert( o, gi );
						#endif
					#else
						#if defined(_SPECULAR_SETUP)
							c += LightingStandardSpecular (o, ViewDirWS, gi);
						#else
							c += LightingStandard(o, ViewDirWS, gi);
						#endif
					#endif

					#ifdef ASE_TRANSMISSION
					{
						half shadow = _TransmissionShadow;
						#ifdef DIRECTIONAL
							half3 lightAtten = lerp( _LightColor0.rgb, gi.light.color, shadow );
						#else
							half3 lightAtten = gi.light.color;
						#endif
						half3 transmission = max(0 , -dot(o.Normal, gi.light.dir)) * lightAtten * Transmission;
						c.rgb += o.Albedo * transmission;
					}
					#endif

					#ifdef ASE_TRANSLUCENCY
					{
						half shadow = _ASETranslucencyShadow;
						half normal = _ASETranslucencyNormalDistortion;
						half scattering = _ASETranslucencyScattering;
						half direct = _ASETranslucencyDirect;
						half ambient = _ASETranslucencyAmbient;
						half strength = _ASETranslucencyStrength;

						#ifdef DIRECTIONAL
							half3 lightAtten = lerp( _LightColor0.rgb, gi.light.color, shadow );
						#else
							half3 lightAtten = gi.light.color;
						#endif
						half3 lightDir = gi.light.dir + o.Normal * normal;
						half transVdotL = pow( saturate( dot( ViewDirWS, -lightDir ) ), scattering );
						half3 translucency = lightAtten * (transVdotL * direct + gi.indirect.diffuse * ambient) * Translucency;
						c.rgb += o.Albedo * translucency * strength;
					}
					#endif

					c.rgb += o.Emission;

					#if defined( ASE_FOG )
						UNITY_EXTRACT_FOG_FROM_WORLD_POS( IN );
						UNITY_APPLY_FOG(_unity_fogCoord, c.rgb);
					#endif
					return c;
				}
			ENDCG
		}

		
		Pass
		{
			
			Name "ForwardAdd"
			Tags { "LightMode"="ForwardAdd" }
			ZWrite Off
			Blend One One

			CGPROGRAM
				#define ASE_GEOMETRY
				#define ASE_FRAGMENT_NORMAL 0
				#define ASE_RECEIVE_SHADOWS
				#pragma shader_feature_local_fragment _SPECULARHIGHLIGHTS_OFF
				#pragma multi_compile_instancing
				#pragma multi_compile _ LOD_FADE_CROSSFADE
				#pragma multi_compile_fog
				#define ASE_FOG
				#define _SPECULAR_SETUP 1
				#define ASE_TRANSLUCENCY 1
				#define _ALPHATEST_ON
				#define _ALPHATEST_SHADOW_ON 1
				#define ASE_VERSION 19907

				#pragma vertex vert
				#pragma fragment frag
				#pragma skip_variants INSTANCING_ON
				#pragma multi_compile_fwdadd_fullshadows
				#ifndef UNITY_PASS_FORWARDADD
					#define UNITY_PASS_FORWARDADD
				#endif
				#include "HLSLSupport.cginc"
				#if defined( ASE_GEOMETRY ) || defined( ASE_IMPOSTOR )
					#ifndef UNITY_INSTANCED_LOD_FADE
						#define UNITY_INSTANCED_LOD_FADE
					#endif
					#ifndef UNITY_INSTANCED_SH
						#define UNITY_INSTANCED_SH
					#endif
					#ifndef UNITY_INSTANCED_LIGHTMAPSTS
						#define UNITY_INSTANCED_LIGHTMAPSTS
					#endif
				#endif
				#include "UnityShaderVariables.cginc"
				#include "UnityCG.cginc"
				#include "Lighting.cginc"
				#include "UnityPBSLighting.cginc"
				#include "AutoLight.cginc"

				#if defined( UNITY_INSTANCING_ENABLED ) && defined( ASE_INSTANCED_TERRAIN ) && ( defined(_TERRAIN_INSTANCED_PERPIXEL_NORMAL) || defined(_INSTANCEDTERRAINNORMALS_PIXEL) )
					#define ENABLE_TERRAIN_PERPIXEL_NORMAL
				#endif

				#include "UnityStandardUtils.cginc"
				#define ASE_NEEDS_TEXTURE_COORDINATES0
				#define ASE_NEEDS_FRAG_TEXTURE_COORDINATES0
				#define ASE_NEEDS_FRAG_WORLD_TANGENT
				#define ASE_NEEDS_WORLD_NORMAL
				#define ASE_NEEDS_FRAG_WORLD_NORMAL
				#define ASE_NEEDS_FRAG_WORLD_BITANGENT
				#define ASE_NEEDS_FRAG_WORLD_VIEW_DIR
				#define ASE_NEEDS_VERT_TEXTURE_COORDINATES1
				#define ASE_NEEDS_VERT_TEXTURE_COORDINATES2
				#define ASE_NEEDS_VERT_NORMAL


				struct appdata
				{
					float4 vertex : POSITION;
					half3 normal : NORMAL;
					half4 tangent : TANGENT;
					float4 texcoord : TEXCOORD0;
					float4 texcoord1 : TEXCOORD1;
					float4 texcoord2 : TEXCOORD2;
					
					UNITY_VERTEX_INPUT_INSTANCE_ID
				};

				struct v2f
				{
					float4 pos : SV_POSITION;
					float4 worldPos : TEXCOORD0; // xyz = positionWS, w = fogCoord
					half3 normalWS : TEXCOORD1;
					float4 tangentWS : TEXCOORD2; // holds terrainUV ifdef ENABLE_TERRAIN_PERPIXEL_NORMAL
					UNITY_LIGHTING_COORDS( 3, 4 )
					float4 ase_texcoord5 : TEXCOORD5;
					float4 ase_lmap : TEXCOORD6;
					float4 ase_sh : TEXCOORD7;
					UNITY_VERTEX_INPUT_INSTANCE_ID
					UNITY_VERTEX_OUTPUT_STEREO
				};

				#ifdef ASE_TRANSMISSION
					float _TransmissionShadow;
				#endif
				#ifdef ASE_TRANSLUCENCY
					float _TransStrength;
					float _TransNormal;
					float _TransScattering;
					float _TransDirect;
					float _TransAmbient;
					float _TransShadow;
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
				uniform float _ASETranslucencyAmbient;
				uniform float _ASETranslucencyDirect;
				uniform float _ASETranslucencyScattering;
				uniform float _ASETranslucencyNormalDistortion;
				uniform float _ASETranslucencyStrength;
				uniform float _ASETranslucencyShadow;
				uniform float4 _Color;
				uniform sampler2D _MainTex;
				uniform float4 _MainTex_ST;
				uniform half _Brightness;
				uniform float _Metallic;
				uniform sampler2D _MetallicGlossMap;
				uniform sampler2D _BumpMap;
				uniform float _BumpScale;
				uniform float _DoubleSidedNormalMode;
				uniform sampler2D _SpecGlossMap;
				uniform float _SpecularStrength;
				uniform float _Smoothnesstexturechannel;
				uniform float _Glossiness;
				uniform sampler2D _OcclusionMap;
				uniform float _OcclusionStrength;
				uniform sampler2D _EmissionMap;
				uniform float4 _EmissionMap_ST;
				uniform float4 _EmissionColor;
				uniform half _EmissiveIntensity;
				uniform float _EMISSION;
				uniform float _AlphaClip;
				uniform float _Cutoff;
				uniform float _TranslucencyNormalDistortion;
				uniform float _TranslucencyScattering;
				uniform float _TranslucencyDirect;
				uniform float _IndirectDiffuse;
				uniform float _TranslucencyAmbient;
				uniform sampler2D _TranslucencyMap;
				uniform float _TranslucencyFeather;
				uniform float4 _TranslucencyColor;
				uniform float _TranslucencyStrength;
				uniform float _TranslucencyMapEnable;


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
				

				v2f VertexFunction (appdata v  ) {
					UNITY_SETUP_INSTANCE_ID(v);
					v2f o;
					UNITY_INITIALIZE_OUTPUT(v2f,o);
					UNITY_TRANSFER_INSTANCE_ID(v,o);
					UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

					#ifdef DYNAMICLIGHTMAP_ON //dynlm
					o.ase_lmap.zw = v.texcoord2.xyzw.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
					#endif //dynlm
					#ifdef LIGHTMAP_ON //stalm
					o.ase_lmap.xy = v.texcoord1.xyzw.xy * unity_LightmapST.xy + unity_LightmapST.zw;
					#endif //stalm
					float3 ase_positionWS = mul( unity_ObjectToWorld, float4( ( v.vertex ).xyz, 1 ) ).xyz;
					float3 ase_normalWS = UnityObjectToWorldNormal( v.normal );
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
					
					o.ase_texcoord5.xy = v.texcoord.xyzw.xy;
					
					//setting value to unused interpolator channels and avoid initialization warnings
					o.ase_texcoord5.zw = 0;
					o.ase_sh.w = 0;

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
					v.tangent = v.tangent;

					float3 positionWS = mul( unity_ObjectToWorld, v.vertex ).xyz;
					half3 normalWS = UnityObjectToWorldNormal( v.normal );
					half3 tangentWS = UnityObjectToWorldDir( v.tangent.xyz );

					o.pos = UnityObjectToClipPos( v.vertex );
					o.worldPos.xyz = positionWS;
					o.normalWS = normalWS;
					o.tangentWS = half4( tangentWS, v.tangent.w );

					UNITY_TRANSFER_LIGHTING(o, v.texcoord1.xy);
					#if defined( ASE_FOG )
						UNITY_TRANSFER_FOG_COMBINED_WITH_WORLD_POS( o, o.pos );
					#endif

					#if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
						o.tangentWS.zw = v.texcoord.xy;
						o.tangentWS.xy = v.texcoord.xy * unity_LightmapST.xy + unity_LightmapST.zw;
					#endif
					return o;
				}

				#if defined(ASE_TESSELLATION)
				struct VertexControl
				{
					float4 vertex : INTERNALTESSPOS;
					half4 tangent : TANGENT;
					half3 normal : NORMAL;
					float4 texcoord : TEXCOORD0;
					float4 texcoord1 : TEXCOORD1;
					float4 texcoord2 : TEXCOORD2;
					
					UNITY_VERTEX_INPUT_INSTANCE_ID
				};

				struct TessellationFactors
				{
					float edge[3] : SV_TessFactor;
					float inside : SV_InsideTessFactor;
				};

				VertexControl vert ( appdata v )
				{
					VertexControl o;
					UNITY_SETUP_INSTANCE_ID(v);
					UNITY_TRANSFER_INSTANCE_ID(v, o);
					o.vertex = v.vertex;
					o.tangent = v.tangent;
					o.normal = v.normal;
					o.texcoord = v.texcoord;
					o.texcoord1 = v.texcoord1;
					o.texcoord2 = v.texcoord2;
					
					return o;
				}

				TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
				{
					TessellationFactors o;
					float4 tf = 1;
					float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
					float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
					#if defined(ASE_FIXED_TESSELLATION)
					tf = FixedTess( tessValue );
					#elif defined(ASE_DISTANCE_TESSELLATION)
					tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, UNITY_MATRIX_M, _WorldSpaceCameraPos );
					#elif defined(ASE_LENGTH_TESSELLATION)
					tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, UNITY_MATRIX_M, _WorldSpaceCameraPos, _ScreenParams );
					#elif defined(ASE_LENGTH_CULL_TESSELLATION)
					tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, UNITY_MATRIX_M, _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
					#endif
					o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
					return o;
				}

				[domain("tri")]
				[partitioning("fractional_odd")]
				[outputtopology("triangle_cw")]
				[patchconstantfunc("TessellationFunction")]
				[outputcontrolpoints(3)]
				VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
				{
				   return patch[id];
				}

				[domain("tri")]
				v2f DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
				{
					appdata o = (appdata) 0;
					o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
					o.tangent = patch[0].tangent * bary.x + patch[1].tangent * bary.y + patch[2].tangent * bary.z;
					o.normal = patch[0].normal * bary.x + patch[1].normal * bary.y + patch[2].normal * bary.z;
					o.texcoord = patch[0].texcoord * bary.x + patch[1].texcoord * bary.y + patch[2].texcoord * bary.z;
					o.texcoord1 = patch[0].texcoord1 * bary.x + patch[1].texcoord1 * bary.y + patch[2].texcoord1 * bary.z;
					o.texcoord2 = patch[0].texcoord2 * bary.x + patch[1].texcoord2 * bary.y + patch[2].texcoord2 * bary.z;
					
					#if defined(ASE_PHONG_TESSELLATION)
					float3 pp[3];
					for (int i = 0; i < 3; ++i)
						pp[i] = o.vertex.xyz - patch[i].normal * (dot(o.vertex.xyz, patch[i].normal) - dot(patch[i].vertex.xyz, patch[i].normal));
					float phongStrength = _TessPhongStrength;
					o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
					#endif
					UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
					return VertexFunction(o);
				}
				#else
				v2f vert ( appdata v )
				{
					return VertexFunction( v );
				}
				#endif

				half4 frag ( v2f IN , uint ase_vface : SV_IsFrontFace
					#if defined( ASE_DEPTH_WRITE_ON )
					, out float outputDepth : SV_Depth
					#endif
					) : SV_Target
				{
					UNITY_SETUP_INSTANCE_ID(IN);

					#ifdef LOD_FADE_CROSSFADE
						UNITY_APPLY_DITHER_CROSSFADE(IN.pos.xy);
					#endif

					#if defined(ASE_LIGHTING_SIMPLE)
						SurfaceOutput o = (SurfaceOutput)0;
					#else
						#if defined(_SPECULAR_SETUP)
							SurfaceOutputStandardSpecular o = (SurfaceOutputStandardSpecular)0;
						#else
							SurfaceOutputStandard o = (SurfaceOutputStandard)0;
						#endif
					#endif

					half atten;
					{
						#if defined( ASE_RECEIVE_SHADOWS )
							UNITY_LIGHT_ATTENUATION( temp, IN, IN.worldPos.xyz )
							atten = temp;
						#else
							atten = 1;
						#endif
					}

					float3 PositionWS = IN.worldPos.xyz;
					half3 ViewDirWS = normalize( UnityWorldSpaceViewDir( PositionWS ) );
					float4 ScreenPosNorm = float4( IN.pos.xy * ( _ScreenParams.zw - 1.0 ), IN.pos.zw );
					float4 ClipPos = ComputeClipSpacePosition( ScreenPosNorm.xy, IN.pos.z ) * IN.pos.w;
					float4 ScreenPos = ComputeScreenPos( ClipPos );
					half3 NormalWS = IN.normalWS;
					half3 TangentWS = IN.tangentWS.xyz;
					half3 BitangentWS = cross( IN.normalWS, IN.tangentWS.xyz ) * IN.tangentWS.w * unity_WorldTransformParams.w;
					half3 LightAtten = atten;

					#if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
						float2 sampleCoords = (IN.tangentWS.zw / _TerrainHeightmapRecipSize.zw + 0.5f) * _TerrainHeightmapRecipSize.xy;
						NormalWS = UnityObjectToWorldNormal(normalize(tex2D(_TerrainNormalmapTexture, sampleCoords).rgb * 2 - 1));
						TangentWS = -cross(unity_ObjectToWorld._13_23_33, NormalWS);
						BitangentWS = cross(NormalWS, -TangentWS);
					#endif

					float2 appendResult2941_g72783 = (float2(_MainTex_ST.x , _MainTex_ST.y));
					float2 appendResult2944_g72783 = (float2(_MainTex_ST.z , _MainTex_ST.w));
					float2 UV__MainTex_ST585_g72783 = ( ( IN.ase_texcoord5.xy * appendResult2941_g72783 ) + appendResult2944_g72783 );
					float4 temp_output_2_0_g72784 = tex2D( _MainTex, UV__MainTex_ST585_g72783 );
					#ifdef UNITY_COLORSPACE_GAMMA
					float4 staticSwitch4287_g72783 = float4( 0.2209163, 0.2209163, 0.2209163, 0.7790837 );
					#else
					float4 staticSwitch4287_g72783 = float4( 0.04, 0.04, 0.04, 0.96 );
					#endif
					float temp_output_4286_0_g72783 = (staticSwitch4287_g72783).w;
					float3 temp_cast_0 = (temp_output_4286_0_g72783).xxx;
					float4 tex2DNode606_g72783 = tex2D( _MetallicGlossMap, UV__MainTex_ST585_g72783 );
					float3 Metallic4256_g72783 = ( _Metallic * (tex2DNode606_g72783).rgb );
					
					float m_switch3729_g72783 = _DoubleSidedNormalMode;
					float3 m_Flip3729_g72783 = float3( -1, -1, -1 );
					float3 m_Mirror3729_g72783 = float3( 1, 1, -1 );
					float3 m_None3729_g72783 = float3( 1, 1, 1 );
					float3 local_NormalModefloat3switch3729_g72783 = _NormalModefloat3switch( m_switch3729_g72783 , m_Flip3729_g72783 , m_Mirror3729_g72783 , m_None3729_g72783 );
					float3 switchResult3728_g72783 = (((ase_vface>0)?(UnpackScaleNormal( tex2D( _BumpMap, UV__MainTex_ST585_g72783 ), _BumpScale )):(( UnpackScaleNormal( tex2D( _BumpMap, UV__MainTex_ST585_g72783 ), _BumpScale ) * local_NormalModefloat3switch3729_g72783 ))));
					
					float4 temp_output_2_0_g72786 = tex2D( _SpecGlossMap, UV__MainTex_ST585_g72783 );
					float3 lerpResult4289_g72783 = lerp( (staticSwitch4287_g72783).xyz , ( (_Color).rgb * (temp_output_2_0_g72784).rgb * _Brightness ) , Metallic4256_g72783);
					float3 Specular_Color_from_Metallic4292_g72783 = lerpResult4289_g72783;
					
					float Alpha_SpecGlossMap707_g72783 = (temp_output_2_0_g72786).a;
					float temp_output_2424_6_g72783 = (temp_output_2_0_g72784).a;
					float Alpha_BaseColor634_g72783 = temp_output_2424_6_g72783;
					float lerpResult3560_g72783 = lerp( Alpha_SpecGlossMap707_g72783 , Alpha_BaseColor634_g72783 , _Smoothnesstexturechannel);
					
					float temp_output_681_0_g72783 = saturate( (tex2D( _OcclusionMap, UV__MainTex_ST585_g72783 ).r*_OcclusionStrength + ( 1.0 - _OcclusionStrength )) );
					
					half3 color2551_g72783 = IsGammaSpace() ? half3( 0.003921569, 0, 0 ) : half3( 0.000303527, 0, 0 );
					float2 appendResult2951_g72783 = (float2(_EmissionMap_ST.x , _EmissionMap_ST.y));
					float2 appendResult2954_g72783 = (float2(_EmissionMap_ST.z , _EmissionMap_ST.w));
					float2 UV__EmissionMap_ST597_g72783 = ( ( IN.ase_texcoord5.xy * appendResult2951_g72783 ) + appendResult2954_g72783 );
					float3 lerpResult3557_g72783 = lerp( color2551_g72783 , ( (tex2D( _EmissionMap, UV__EmissionMap_ST597_g72783 )).rgb * ( (_EmissionColor).rgb * _EmissiveIntensity ) ) , _EMISSION);
					
					float lerpResult3822_g72783 = lerp( 1.0 , ( temp_output_2424_6_g72783 * 1.0 ) , _AlphaClip);
					
					float3 ase_mainLightDirection = _WorldSpaceLightPos0.xyz;
					float3 MainLight_Dir4125_g72783 = ase_mainLightDirection;
					float3 BumpMap4675_g72783 = switchResult3728_g72783;
					float3 tanToWorld0 = float3( TangentWS.x, BitangentWS.x, NormalWS.x );
					float3 tanToWorld1 = float3( TangentWS.y, BitangentWS.y, NormalWS.y );
					float3 tanToWorld2 = float3( TangentWS.z, BitangentWS.z, NormalWS.z );
					float3 tanNormal4137_g72783 = BumpMap4675_g72783;
					float3 worldNormal4137_g72783 = float3( dot( tanToWorld0, tanNormal4137_g72783 ), dot( tanToWorld1, tanNormal4137_g72783 ), dot( tanToWorld2, tanNormal4137_g72783 ) );
					float3 Surface_Data_Normal_WS_Bump4138_g72783 = worldNormal4137_g72783;
					float3 Surface_Data_ViewDir_WS4672_g72783 = ViewDirWS;
					float dotResult4639_g72783 = dot( -( MainLight_Dir4125_g72783 + ( Surface_Data_Normal_WS_Bump4138_g72783 * _TranslucencyNormalDistortion ) ) , Surface_Data_ViewDir_WS4672_g72783 );
					float3 tanNormal4227_g72783 = Surface_Data_Normal_WS_Bump4138_g72783;
					UnityGIInput data4227_g72783;
					UNITY_INITIALIZE_OUTPUT( UnityGIInput, data4227_g72783 );
					#if defined(LIGHTMAP_ON) || defined(DYNAMICLIGHTMAP_ON) //dylm4227_g72783
					data4227_g72783.lightmapUV = IN.ase_lmap;
					#endif //dylm4227_g72783
					#if UNITY_SHOULD_SAMPLE_SH //fsh4227_g72783
					data4227_g72783.ambient = IN.ase_sh;
					#endif //fsh4227_g72783
					UnityGI gi4227_g72783 = UnityGI_Base(data4227_g72783, 1, float3( dot( tanToWorld0, tanNormal4227_g72783 ), dot( tanToWorld1, tanNormal4227_g72783 ), dot( tanToWorld2, tanNormal4227_g72783 ) ));
					float Occlusion3640_g72783 = temp_output_681_0_g72783;
					float3 Indirect_Diffuse4210_g72783 = ( gi4227_g72783.indirect.diffuse * Occlusion3640_g72783 * _IndirectDiffuse );
					float3 ase_mainLightColorLDR = _LightColor0.rgb / ( _LightColor0.a + 1e-7 );
					float ase_mainLightIntensity = _LightColor0.a;
					float ase_mainLightShadowAtten = LightAtten.x;
					float3 temp_output_4680_0_g72783 = ( ase_mainLightColorLDR * ase_mainLightIntensity * ase_mainLightShadowAtten );
					float3 MainLight_Scene_Lighting4123_g72783 = temp_output_4680_0_g72783;
					float3 BaseColor_Map4140_g72783 = ( ( (_Color).rgb * (temp_output_2_0_g72784).rgb * _Brightness ) * ( temp_cast_0 - ( temp_output_4286_0_g72783 * Metallic4256_g72783 ) ) );
					

					o.Albedo = ( ( (_Color).rgb * (temp_output_2_0_g72784).rgb * _Brightness ) * ( temp_cast_0 - ( temp_output_4286_0_g72783 * Metallic4256_g72783 ) ) );
					o.Normal = switchResult3728_g72783;

					half3 Specular = saturate( ( ( ( (_SpecColor).rgb * (temp_output_2_0_g72786).rgb ) * _SpecularStrength ) + Specular_Color_from_Metallic4292_g72783 ) );
					half Metallic = 0;
					half Smoothness = saturate( ( lerpResult3560_g72783 * _Glossiness ) );
					half Occlusion = temp_output_681_0_g72783;

					#if defined(ASE_LIGHTING_SIMPLE)
						o.Specular = Specular.x;
						o.Gloss = Smoothness;
					#else
						#if defined(_SPECULAR_SETUP)
							o.Specular = Specular;
						#else
							o.Metallic = Metallic;
						#endif
						o.Occlusion = Occlusion;
						o.Smoothness = Smoothness;
					#endif

					o.Emission = lerpResult3557_g72783;
					o.Alpha = lerpResult3822_g72783;
					half AlphaClipThreshold = _Cutoff;
					half3 Transmission = 1;
					half3 Translucency = ( ( ( ( pow( saturate( dotResult4639_g72783 ) , _TranslucencyScattering ) * _TranslucencyDirect ) + ( Indirect_Diffuse4210_g72783 * _TranslucencyAmbient ) ) * MainLight_Scene_Lighting4123_g72783 * BaseColor_Map4140_g72783 * ( (tex2D( _TranslucencyMap, UV__MainTex_ST585_g72783 )).rgb / _TranslucencyFeather ) * (_TranslucencyColor).rgb * _TranslucencyStrength ) * _TranslucencyMapEnable );

					#if defined( ASE_DEPTH_WRITE_ON )
						float DeviceDepth = IN.pos.z;
					#endif

					#ifdef _ALPHATEST_ON
						clip( o.Alpha - AlphaClipThreshold );
					#endif

					#if defined( ASE_CHANGES_WORLD_POS )
					{
						#if defined( ASE_RECEIVE_SHADOWS )
							UNITY_LIGHT_ATTENUATION( temp, IN, PositionWS )
							LightAtten = temp;
						#else
							LightAtten = 1;
						#endif
					}
					#endif

					#if ( ASE_FRAGMENT_NORMAL == 0 )
						o.Normal = normalize( o.Normal.x * TangentWS + o.Normal.y * BitangentWS + o.Normal.z * NormalWS );
					#elif ( ASE_FRAGMENT_NORMAL == 1 )
						o.Normal = UnityObjectToWorldNormal( o.Normal );
					#elif ( ASE_FRAGMENT_NORMAL == 2 )
						// @diogo: already in world-space; do nothing
					#endif

					#if defined( ASE_DEPTH_WRITE_ON )
						outputDepth = DeviceDepth;
					#endif

					#ifndef USING_DIRECTIONAL_LIGHT
						half3 lightDir = normalize( UnityWorldSpaceLightDir( PositionWS ) );
					#else
						half3 lightDir = _WorldSpaceLightPos0.xyz;
					#endif

					UnityGI gi;
					UNITY_INITIALIZE_OUTPUT(UnityGI, gi);
					gi.indirect.diffuse = 0;
					gi.indirect.specular = 0;
					gi.light.color = _LightColor0.rgb;
					gi.light.dir = lightDir;
					gi.light.color *= atten;

					half4 c = 0;
					#if defined(ASE_LIGHTING_SIMPLE)
						#if defined(_SPECULAR_SETUP)
							c += LightingBlinnPhong (o, ViewDirWS, gi);
						#else
							c += LightingLambert( o, gi );
						#endif
					#else
						#if defined(_SPECULAR_SETUP)
							c += LightingStandardSpecular(o, ViewDirWS, gi);
						#else
							c += LightingStandard(o, ViewDirWS, gi);
						#endif
					#endif

					#ifdef ASE_TRANSMISSION
					{
						half shadow = _TransmissionShadow;
						#ifdef DIRECTIONAL
							half3 lightAtten = lerp( _LightColor0.rgb, gi.light.color, shadow );
						#else
							half3 lightAtten = gi.light.color;
						#endif
						half3 transmission = max(0 , -dot(o.Normal, gi.light.dir)) * lightAtten * Transmission;
						c.rgb += o.Albedo * transmission;
					}
					#endif

					#ifdef ASE_TRANSLUCENCY
					{
						half shadow = _ASETranslucencyShadow;
						half normal = _ASETranslucencyNormalDistortion;
						half scattering = _ASETranslucencyScattering;
						half direct = _ASETranslucencyDirect;
						half ambient = _ASETranslucencyAmbient;
						half strength = _ASETranslucencyStrength;

						#ifdef DIRECTIONAL
							half3 lightAtten = lerp( _LightColor0.rgb, gi.light.color, shadow );
						#else
							half3 lightAtten = gi.light.color;
						#endif
						half3 lightDir = gi.light.dir + o.Normal * normal;
						half transVdotL = pow( saturate( dot( ViewDirWS, -lightDir ) ), scattering );
						half3 translucency = lightAtten * (transVdotL * direct + gi.indirect.diffuse * ambient) * Translucency;
						c.rgb += o.Albedo * translucency * strength;
					}
					#endif

					#if defined( ASE_FOG )
						UNITY_EXTRACT_FOG_FROM_WORLD_POS( IN );
						UNITY_APPLY_FOG(_unity_fogCoord, c.rgb);
					#endif
					return c;
				}
			ENDCG
		}

		
		Pass
		{
			
			Name "Meta"
			Tags { "LightMode"="Meta" }
			Cull Off

			CGPROGRAM
				#define ASE_GEOMETRY
				#define ASE_FRAGMENT_NORMAL 0
				#define ASE_RECEIVE_SHADOWS
				#pragma multi_compile_instancing
				#pragma multi_compile _ LOD_FADE_CROSSFADE
				#define ASE_FOG
				#define _SPECULAR_SETUP 1
				#define ASE_TRANSLUCENCY 1
				#define _ALPHATEST_ON
				#define _ALPHATEST_SHADOW_ON 1
				#define ASE_VERSION 19907

				#pragma vertex vert
				#pragma fragment frag
				#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
				#pragma shader_feature EDITOR_VISUALIZATION
				#ifndef UNITY_PASS_META
					#define UNITY_PASS_META
				#endif
				#include "HLSLSupport.cginc"
				#if defined( ASE_GEOMETRY ) || defined( ASE_IMPOSTOR )
					#ifndef UNITY_INSTANCED_LOD_FADE
						#define UNITY_INSTANCED_LOD_FADE
					#endif
					#ifndef UNITY_INSTANCED_SH
						#define UNITY_INSTANCED_SH
					#endif
					#ifndef UNITY_INSTANCED_LIGHTMAPSTS
						#define UNITY_INSTANCED_LIGHTMAPSTS
					#endif
				#endif
				#include "UnityShaderVariables.cginc"
				#include "UnityCG.cginc"
				#include "Lighting.cginc"
				#include "UnityPBSLighting.cginc"
				#include "UnityMetaPass.cginc"

				#define ASE_NEEDS_TEXTURE_COORDINATES0
				#define ASE_NEEDS_FRAG_TEXTURE_COORDINATES0


				struct appdata
				{
					float4 vertex : POSITION;
					half3 normal : NORMAL;
					half4 tangent : TANGENT;
					float4 texcoord : TEXCOORD0;
					float4 texcoord1 : TEXCOORD1;
					float4 texcoord2 : TEXCOORD2;
					
					UNITY_VERTEX_INPUT_INSTANCE_ID
				};

				struct v2f
				{
					float4 pos : SV_POSITION;
					#ifdef EDITOR_VISUALIZATION
						float2 vizUV : TEXCOORD0;
						float4 lightCoord : TEXCOORD1;
					#endif
					float4 ase_texcoord2 : TEXCOORD2;
					UNITY_VERTEX_INPUT_INSTANCE_ID
					UNITY_VERTEX_OUTPUT_STEREO
				};

				#ifdef ASE_TESSELLATION
					float _TessPhongStrength;
					float _TessValue;
					float _TessMin;
					float _TessMax;
					float _TessEdgeLength;
					float _TessMaxDisp;
				#endif

				uniform int _Cull;
				uniform float _ASETranslucencyAmbient;
				uniform float _ASETranslucencyDirect;
				uniform float _ASETranslucencyScattering;
				uniform float _ASETranslucencyNormalDistortion;
				uniform float _ASETranslucencyStrength;
				uniform float _ASETranslucencyShadow;
				uniform float4 _Color;
				uniform sampler2D _MainTex;
				uniform float4 _MainTex_ST;
				uniform half _Brightness;
				uniform float _Metallic;
				uniform sampler2D _MetallicGlossMap;
				uniform sampler2D _EmissionMap;
				uniform float4 _EmissionMap_ST;
				uniform float4 _EmissionColor;
				uniform half _EmissiveIntensity;
				uniform float _EMISSION;
				uniform float _AlphaClip;
				uniform float _Cutoff;


				
				v2f VertexFunction( appdata v  )
				{
					UNITY_SETUP_INSTANCE_ID(v);
					v2f o;
					UNITY_INITIALIZE_OUTPUT(v2f,o);
					UNITY_TRANSFER_INSTANCE_ID(v,o);
					UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

					o.ase_texcoord2.xy = v.texcoord.xyzw.xy;
					
					//setting value to unused interpolator channels and avoid initialization warnings
					o.ase_texcoord2.zw = 0;

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
					v.tangent = v.tangent;

					#ifdef EDITOR_VISUALIZATION
						o.vizUV = 0;
						o.lightCoord = 0;
						if (unity_VisualizationMode == EDITORVIZ_TEXTURE)
							o.vizUV = UnityMetaVizUV(unity_EditorViz_UVIndex, v.texcoord.xy, v.texcoord1.xy, v.texcoord2.xy, unity_EditorViz_Texture_ST);
						else if (unity_VisualizationMode == EDITORVIZ_SHOWLIGHTMASK)
						{
							o.vizUV = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
							o.lightCoord = mul(unity_EditorViz_WorldToLight, mul(unity_ObjectToWorld, float4(v.vertex.xyz, 1)));
						}
					#endif

					o.pos = UnityMetaVertexPosition(v.vertex, v.texcoord1.xy, v.texcoord2.xy, unity_LightmapST, unity_DynamicLightmapST);
					return o;
				}

				#if defined(ASE_TESSELLATION)
				struct VertexControl
				{
					float4 vertex : INTERNALTESSPOS;
					float4 tangent : TANGENT;
					float3 normal : NORMAL;
					float4 texcoord : TEXCOORD0;
					float4 texcoord1 : TEXCOORD1;
					float4 texcoord2 : TEXCOORD2;
					
					UNITY_VERTEX_INPUT_INSTANCE_ID
				};

				struct TessellationFactors
				{
					float edge[3] : SV_TessFactor;
					float inside : SV_InsideTessFactor;
				};

				VertexControl vert ( appdata v )
				{
					VertexControl o;
					UNITY_SETUP_INSTANCE_ID(v);
					UNITY_TRANSFER_INSTANCE_ID(v, o);
					o.vertex = v.vertex;
					o.tangent = v.tangent;
					o.normal = v.normal;
					o.texcoord = v.texcoord;
					o.texcoord1 = v.texcoord1;
					o.texcoord2 = v.texcoord2;
					
					return o;
				}

				TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
				{
					TessellationFactors o;
					float4 tf = 1;
					float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
					float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
					#if defined(ASE_FIXED_TESSELLATION)
					tf = FixedTess( tessValue );
					#elif defined(ASE_DISTANCE_TESSELLATION)
					tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, UNITY_MATRIX_M, _WorldSpaceCameraPos );
					#elif defined(ASE_LENGTH_TESSELLATION)
					tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, UNITY_MATRIX_M, _WorldSpaceCameraPos, _ScreenParams );
					#elif defined(ASE_LENGTH_CULL_TESSELLATION)
					tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, UNITY_MATRIX_M, _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
					#endif
					o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
					return o;
				}

				[domain("tri")]
				[partitioning("fractional_odd")]
				[outputtopology("triangle_cw")]
				[patchconstantfunc("TessellationFunction")]
				[outputcontrolpoints(3)]
				VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
				{
				   return patch[id];
				}

				[domain("tri")]
				v2f DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
				{
					appdata o = (appdata) 0;
					o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
					o.tangent = patch[0].tangent * bary.x + patch[1].tangent * bary.y + patch[2].tangent * bary.z;
					o.normal = patch[0].normal * bary.x + patch[1].normal * bary.y + patch[2].normal * bary.z;
					o.texcoord = patch[0].texcoord * bary.x + patch[1].texcoord * bary.y + patch[2].texcoord * bary.z;
					o.texcoord1 = patch[0].texcoord1 * bary.x + patch[1].texcoord1 * bary.y + patch[2].texcoord1 * bary.z;
					o.texcoord2 = patch[0].texcoord2 * bary.x + patch[1].texcoord2 * bary.y + patch[2].texcoord2 * bary.z;
					
					#if defined(ASE_PHONG_TESSELLATION)
					float3 pp[3];
					for (int i = 0; i < 3; ++i)
						pp[i] = o.vertex.xyz - patch[i].normal * (dot(o.vertex.xyz, patch[i].normal) - dot(patch[i].vertex.xyz, patch[i].normal));
					float phongStrength = _TessPhongStrength;
					o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
					#endif
					UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
					return VertexFunction(o);
				}
				#else
				v2f vert( appdata v )
				{
					return VertexFunction( v );
				}
				#endif

				half4 frag( v2f IN  ) : SV_Target
				{
					UNITY_SETUP_INSTANCE_ID(IN);

					#ifdef LOD_FADE_CROSSFADE
						UNITY_APPLY_DITHER_CROSSFADE(IN.pos.xy);
					#endif

					#if defined(ASE_LIGHTING_SIMPLE)
						SurfaceOutput o = (SurfaceOutput)0;
					#else
						#if defined(_SPECULAR_SETUP)
							SurfaceOutputStandardSpecular o = (SurfaceOutputStandardSpecular)0;
						#else
							SurfaceOutputStandard o = (SurfaceOutputStandard)0;
						#endif
					#endif

					float2 appendResult2941_g72783 = (float2(_MainTex_ST.x , _MainTex_ST.y));
					float2 appendResult2944_g72783 = (float2(_MainTex_ST.z , _MainTex_ST.w));
					float2 UV__MainTex_ST585_g72783 = ( ( IN.ase_texcoord2.xy * appendResult2941_g72783 ) + appendResult2944_g72783 );
					float4 temp_output_2_0_g72784 = tex2D( _MainTex, UV__MainTex_ST585_g72783 );
					#ifdef UNITY_COLORSPACE_GAMMA
					float4 staticSwitch4287_g72783 = float4( 0.2209163, 0.2209163, 0.2209163, 0.7790837 );
					#else
					float4 staticSwitch4287_g72783 = float4( 0.04, 0.04, 0.04, 0.96 );
					#endif
					float temp_output_4286_0_g72783 = (staticSwitch4287_g72783).w;
					float3 temp_cast_0 = (temp_output_4286_0_g72783).xxx;
					float4 tex2DNode606_g72783 = tex2D( _MetallicGlossMap, UV__MainTex_ST585_g72783 );
					float3 Metallic4256_g72783 = ( _Metallic * (tex2DNode606_g72783).rgb );
					
					half3 color2551_g72783 = IsGammaSpace() ? half3( 0.003921569, 0, 0 ) : half3( 0.000303527, 0, 0 );
					float2 appendResult2951_g72783 = (float2(_EmissionMap_ST.x , _EmissionMap_ST.y));
					float2 appendResult2954_g72783 = (float2(_EmissionMap_ST.z , _EmissionMap_ST.w));
					float2 UV__EmissionMap_ST597_g72783 = ( ( IN.ase_texcoord2.xy * appendResult2951_g72783 ) + appendResult2954_g72783 );
					float3 lerpResult3557_g72783 = lerp( color2551_g72783 , ( (tex2D( _EmissionMap, UV__EmissionMap_ST597_g72783 )).rgb * ( (_EmissionColor).rgb * _EmissiveIntensity ) ) , _EMISSION);
					
					float temp_output_2424_6_g72783 = (temp_output_2_0_g72784).a;
					float lerpResult3822_g72783 = lerp( 1.0 , ( temp_output_2424_6_g72783 * 1.0 ) , _AlphaClip);
					

					o.Albedo = ( ( (_Color).rgb * (temp_output_2_0_g72784).rgb * _Brightness ) * ( temp_cast_0 - ( temp_output_4286_0_g72783 * Metallic4256_g72783 ) ) );
					o.Normal = half3( 0, 0, 1 );
					o.Emission = lerpResult3557_g72783;
					o.Alpha = lerpResult3822_g72783;
					half AlphaClipThreshold = _Cutoff;

					#ifdef _ALPHATEST_ON
						clip( o.Alpha - AlphaClipThreshold );
					#endif

					UnityMetaInput metaIN;
					UNITY_INITIALIZE_OUTPUT(UnityMetaInput, metaIN);
					metaIN.Albedo = o.Albedo;
					metaIN.Emission = o.Emission;
					#ifdef EDITOR_VISUALIZATION
						metaIN.VizUV = IN.vizUV;
						metaIN.LightCoord = IN.lightCoord;
					#endif
					return UnityMetaFragment(metaIN);
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
				#define ASE_GEOMETRY
				#define ASE_FRAGMENT_NORMAL 0
				#define ASE_RECEIVE_SHADOWS
				#pragma multi_compile_instancing
				#pragma multi_compile _ LOD_FADE_CROSSFADE
				#define ASE_FOG
				#define _SPECULAR_SETUP 1
				#define ASE_TRANSLUCENCY 1
				#define _ALPHATEST_ON
				#define _ALPHATEST_SHADOW_ON 1
				#define ASE_VERSION 19907

				#pragma vertex vert
				#pragma fragment frag
				#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
				#pragma multi_compile_shadowcaster
				#ifndef UNITY_PASS_SHADOWCASTER
					#define UNITY_PASS_SHADOWCASTER
				#endif
				#include "HLSLSupport.cginc"
				#if defined( ASE_GEOMETRY ) || defined( ASE_IMPOSTOR )
					#ifndef UNITY_INSTANCED_LOD_FADE
						#define UNITY_INSTANCED_LOD_FADE
					#endif
					#ifndef UNITY_INSTANCED_SH
						#define UNITY_INSTANCED_SH
					#endif
					#ifndef UNITY_INSTANCED_LIGHTMAPSTS
						#define UNITY_INSTANCED_LIGHTMAPSTS
					#endif
				#endif
				#include "UnityShaderVariables.cginc"
				#include "UnityCG.cginc"
				#include "Lighting.cginc"
				#include "UnityPBSLighting.cginc"

				#define ASE_NEEDS_TEXTURE_COORDINATES0
				#define ASE_NEEDS_FRAG_TEXTURE_COORDINATES0


				struct appdata
				{
					float4 vertex : POSITION;
					half3 normal : NORMAL;
					half4 tangent : TANGENT;
					float4 texcoord1 : TEXCOORD1;
					float4 texcoord2 : TEXCOORD2;
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

				uniform int _Cull;
				uniform float _ASETranslucencyAmbient;
				uniform float _ASETranslucencyDirect;
				uniform float _ASETranslucencyScattering;
				uniform float _ASETranslucencyNormalDistortion;
				uniform float _ASETranslucencyStrength;
				uniform float _ASETranslucencyShadow;
				uniform sampler2D _MainTex;
				uniform float4 _MainTex_ST;
				uniform float _AlphaClip;
				uniform float _Cutoff;
				uniform float _AlphaCutoffShadow;
				uniform float _UseShadowThreshold;


				
				v2f VertexFunction( appdata v  )
				{
					UNITY_SETUP_INSTANCE_ID(v);
					v2f o;
					UNITY_INITIALIZE_OUTPUT(v2f,o);
					UNITY_TRANSFER_INSTANCE_ID(v,o);
					UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

					o.ase_texcoord1.xy = v.ase_texcoord.xy;
					
					//setting value to unused interpolator channels and avoid initialization warnings
					o.ase_texcoord1.zw = 0;

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
					v.tangent = v.tangent;

				#if defined( ASE_IMPOSTOR )
					// Disable "Normal Bias" because we're rendering billboard impostors and there's no vertex normals.
					unity_LightShadowBias.z = 0;
				#endif

					TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
					return o;
				}

				#if defined(ASE_TESSELLATION)
				struct VertexControl
				{
					float4 vertex : INTERNALTESSPOS;
					half4 tangent : TANGENT;
					half3 normal : NORMAL;
					float4 texcoord1 : TEXCOORD1;
					float4 texcoord2 : TEXCOORD2;
					float4 ase_texcoord : TEXCOORD0;

					UNITY_VERTEX_INPUT_INSTANCE_ID
				};

				struct TessellationFactors
				{
					float edge[3] : SV_TessFactor;
					float inside : SV_InsideTessFactor;
				};

				VertexControl vert ( appdata v )
				{
					VertexControl o;
					UNITY_SETUP_INSTANCE_ID(v);
					UNITY_TRANSFER_INSTANCE_ID(v, o);
					o.vertex = v.vertex;
					o.tangent = v.tangent;
					o.normal = v.normal;
					o.texcoord1 = v.texcoord1;
					o.texcoord2 = v.texcoord2;
					o.ase_texcoord = v.ase_texcoord;
					return o;
				}

				TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
				{
					TessellationFactors o;
					float4 tf = 1;
					float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
					float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
					#if defined(ASE_FIXED_TESSELLATION)
					tf = FixedTess( tessValue );
					#elif defined(ASE_DISTANCE_TESSELLATION)
					tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, UNITY_MATRIX_M, _WorldSpaceCameraPos );
					#elif defined(ASE_LENGTH_TESSELLATION)
					tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, UNITY_MATRIX_M, _WorldSpaceCameraPos, _ScreenParams );
					#elif defined(ASE_LENGTH_CULL_TESSELLATION)
					tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, UNITY_MATRIX_M, _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
					#endif
					o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
					return o;
				}

				[domain("tri")]
				[partitioning("fractional_odd")]
				[outputtopology("triangle_cw")]
				[patchconstantfunc("TessellationFunction")]
				[outputcontrolpoints(3)]
				VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
				{
				   return patch[id];
				}

				[domain("tri")]
				v2f DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
				{
					appdata o = (appdata) 0;
					o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
					o.tangent = patch[0].tangent * bary.x + patch[1].tangent * bary.y + patch[2].tangent * bary.z;
					o.normal = patch[0].normal * bary.x + patch[1].normal * bary.y + patch[2].normal * bary.z;
					o.texcoord1 = patch[0].texcoord1 * bary.x + patch[1].texcoord1 * bary.y + patch[2].texcoord1 * bary.z;
					o.texcoord2 = patch[0].texcoord2 * bary.x + patch[1].texcoord2 * bary.y + patch[2].texcoord2 * bary.z;
					o.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
					#if defined(ASE_PHONG_TESSELLATION)
					float3 pp[3];
					for (int i = 0; i < 3; ++i)
						pp[i] = o.vertex.xyz - patch[i].normal * (dot(o.vertex.xyz, patch[i].normal) - dot(patch[i].vertex.xyz, patch[i].normal));
					float phongStrength = _TessPhongStrength;
					o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
					#endif
					UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
					return VertexFunction(o);
				}
				#else
				v2f vert( appdata v )
				{
					return VertexFunction( v );
				}
				#endif

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

					#if defined(ASE_LIGHTING_SIMPLE)
						SurfaceOutput o = (SurfaceOutput)0;
					#else
						#if defined(_SPECULAR_SETUP)
							SurfaceOutputStandardSpecular o = (SurfaceOutputStandardSpecular)0;
						#else
							SurfaceOutputStandard o = (SurfaceOutputStandard)0;
						#endif
						o.Occlusion = 1;
					#endif

					float2 appendResult2941_g72783 = (float2(_MainTex_ST.x , _MainTex_ST.y));
					float2 appendResult2944_g72783 = (float2(_MainTex_ST.z , _MainTex_ST.w));
					float2 UV__MainTex_ST585_g72783 = ( ( IN.ase_texcoord1.xy * appendResult2941_g72783 ) + appendResult2944_g72783 );
					float4 temp_output_2_0_g72784 = tex2D( _MainTex, UV__MainTex_ST585_g72783 );
					float temp_output_2424_6_g72783 = (temp_output_2_0_g72784).a;
					float lerpResult3822_g72783 = lerp( 1.0 , ( temp_output_2424_6_g72783 * 1.0 ) , _AlphaClip);
					
					float lerpResult3858_g72783 = lerp( 0.01 , _AlphaCutoffShadow , _UseShadowThreshold);
					

					o.Normal = half3( 0, 0, 1 );

					o.Alpha = lerpResult3822_g72783;
					half AlphaClipThreshold = _Cutoff;
					half AlphaClipThresholdShadow = lerpResult3858_g72783;

					#if defined( ASE_DEPTH_WRITE_ON )
						float DeviceDepth = IN.pos.z;
					#endif

					#ifdef _ALPHATEST_SHADOW_ON
						if (unity_LightShadowBias.z != 0.0)
							clip(o.Alpha - AlphaClipThresholdShadow);
						#ifdef _ALPHATEST_ON
						else
							clip(o.Alpha - AlphaClipThreshold);
						#endif
					#else
						#ifdef _ALPHATEST_ON
							clip(o.Alpha - AlphaClipThreshold);
						#endif
					#endif

					#ifdef UNITY_STANDARD_USE_DITHER_MASK
						half alphaRef = tex3D(_DitherMaskLOD, float3(IN.pos.xy*0.25,o.Alpha*0.9375)).a;
						clip(alphaRef - 0.01);
					#endif

					#if defined( ASE_DEPTH_WRITE_ON )
						outputDepth = DeviceDepth;
					#endif

					SHADOW_CASTER_FRAGMENT(IN)
				}
			ENDCG
		}

		
		Pass
		{
			
			Name "SceneSelectionPass"
			Tags { "LightMode"="SceneSelectionPass" }

			ZWrite On

			CGPROGRAM
				#define ASE_GEOMETRY
				#define ASE_FRAGMENT_NORMAL 0
				#define ASE_RECEIVE_SHADOWS
				#pragma multi_compile_instancing
				#pragma multi_compile _ LOD_FADE_CROSSFADE
				#define ASE_FOG
				#define _SPECULAR_SETUP 1
				#define ASE_TRANSLUCENCY 1
				#define _ALPHATEST_ON
				#define _ALPHATEST_SHADOW_ON 1
				#define ASE_VERSION 19907

				#pragma vertex vert
				#pragma fragment frag
				#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2

				#pragma multi_compile_fwdbase
				#ifndef UNITY_PASS_FORWARDBASE
					#define UNITY_PASS_FORWARDBASE
				#endif
				#include "HLSLSupport.cginc"
				#if defined( ASE_GEOMETRY ) || defined( ASE_IMPOSTOR )
					#ifndef UNITY_INSTANCED_LOD_FADE
						#define UNITY_INSTANCED_LOD_FADE
					#endif
					#ifndef UNITY_INSTANCED_SH
						#define UNITY_INSTANCED_SH
					#endif
					#ifndef UNITY_INSTANCED_LIGHTMAPSTS
						#define UNITY_INSTANCED_LIGHTMAPSTS
					#endif
				#endif
				#include "UnityShaderVariables.cginc"
				#include "UnityCG.cginc"
				#include "Lighting.cginc"
				#include "UnityPBSLighting.cginc"
				#include "AutoLight.cginc"

				#define ASE_NEEDS_TEXTURE_COORDINATES0
				#define ASE_NEEDS_FRAG_TEXTURE_COORDINATES0


				int _ObjectId;
				int _PassValue;

				struct appdata
				{
					float4 vertex : POSITION;
					half3 normal : NORMAL;
					half4 tangent : TANGENT;
					float4 ase_texcoord : TEXCOORD0;
					UNITY_VERTEX_INPUT_INSTANCE_ID
				};

				struct v2f
				{
					float4 pos : SV_POSITION;
					float4 worldPos : TEXCOORD0; // xyz = positionWS
					half3 normalWS : TEXCOORD1;
					float4 ase_texcoord2 : TEXCOORD2;
					UNITY_VERTEX_INPUT_INSTANCE_ID
					UNITY_VERTEX_OUTPUT_STEREO
				};

				#ifdef ASE_TESSELLATION
					float _TessPhongStrength;
					float _TessValue;
					float _TessMin;
					float _TessMax;
					float _TessEdgeLength;
					float _TessMaxDisp;
				#endif

				uniform int _Cull;
				uniform float _ASETranslucencyAmbient;
				uniform float _ASETranslucencyDirect;
				uniform float _ASETranslucencyScattering;
				uniform float _ASETranslucencyNormalDistortion;
				uniform float _ASETranslucencyStrength;
				uniform float _ASETranslucencyShadow;
				uniform sampler2D _MainTex;
				uniform float4 _MainTex_ST;
				uniform float _AlphaClip;
				uniform float _Cutoff;


				
				v2f VertexFunction( appdata v  )
				{
					UNITY_SETUP_INSTANCE_ID(v);
					v2f o;
					UNITY_INITIALIZE_OUTPUT(v2f,o);
					UNITY_TRANSFER_INSTANCE_ID(v,o);
					UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

					o.ase_texcoord2.xy = v.ase_texcoord.xy;
					
					//setting value to unused interpolator channels and avoid initialization warnings
					o.ase_texcoord2.zw = 0;

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
					v.tangent = v.tangent;

					float3 positionWS = mul( unity_ObjectToWorld, v.vertex ).xyz;
					half3 normalWS = UnityObjectToWorldNormal( v.normal );

					o.pos = UnityObjectToClipPos( v.vertex );
					o.worldPos.xyz = positionWS;
					o.normalWS = normalWS;
					return o;
				}

				#if defined(ASE_TESSELLATION)
				struct VertexControl
				{
					float4 vertex : INTERNALTESSPOS;
					half3 normal : NORMAL;
					float4 ase_texcoord : TEXCOORD0;

					UNITY_VERTEX_INPUT_INSTANCE_ID
				};

				struct TessellationFactors
				{
					float edge[3] : SV_TessFactor;
					float inside : SV_InsideTessFactor;
				};

				VertexControl vert ( appdata v )
				{
					VertexControl o;
					UNITY_SETUP_INSTANCE_ID(v);
					UNITY_TRANSFER_INSTANCE_ID(v, o);
					o.vertex = v.vertex;
					o.normal = v.normal;
					o.ase_texcoord = v.ase_texcoord;
					return o;
				}

				TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
				{
					TessellationFactors o;
					float4 tf = 1;
					float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
					float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
					#if defined(ASE_FIXED_TESSELLATION)
					tf = FixedTess( tessValue );
					#elif defined(ASE_DISTANCE_TESSELLATION)
					tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, UNITY_MATRIX_M, _WorldSpaceCameraPos );
					#elif defined(ASE_LENGTH_TESSELLATION)
					tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, UNITY_MATRIX_M, _WorldSpaceCameraPos, _ScreenParams );
					#elif defined(ASE_LENGTH_CULL_TESSELLATION)
					tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, UNITY_MATRIX_M, _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
					#endif
					o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
					return o;
				}

				[domain("tri")]
				[partitioning("fractional_odd")]
				[outputtopology("triangle_cw")]
				[patchconstantfunc("TessellationFunction")]
				[outputcontrolpoints(3)]
				VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
				{
				   return patch[id];
				}

				[domain("tri")]
				v2f DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
				{
					appdata o = (appdata) 0;
					o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
					o.normal = patch[0].normal * bary.x + patch[1].normal * bary.y + patch[2].normal * bary.z;
					o.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
					#if defined(ASE_PHONG_TESSELLATION)
					float3 pp[3];
					for (int i = 0; i < 3; ++i)
						pp[i] = o.vertex.xyz - patch[i].normal * (dot(o.vertex.xyz, patch[i].normal) - dot(patch[i].vertex.xyz, patch[i].normal));
					float phongStrength = _TessPhongStrength;
					o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
					#endif
					UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
					return VertexFunction(o);
				}
				#else
				v2f vert ( appdata v )
				{
					return VertexFunction( v );
				}
				#endif

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

					float2 appendResult2941_g72783 = (float2(_MainTex_ST.x , _MainTex_ST.y));
					float2 appendResult2944_g72783 = (float2(_MainTex_ST.z , _MainTex_ST.w));
					float2 UV__MainTex_ST585_g72783 = ( ( IN.ase_texcoord2.xy * appendResult2941_g72783 ) + appendResult2944_g72783 );
					float4 temp_output_2_0_g72784 = tex2D( _MainTex, UV__MainTex_ST585_g72783 );
					float temp_output_2424_6_g72783 = (temp_output_2_0_g72784).a;
					float lerpResult3822_g72783 = lerp( 1.0 , ( temp_output_2424_6_g72783 * 1.0 ) , _AlphaClip);
					

					half Alpha = lerpResult3822_g72783;
					half AlphaClipThreshold = _Cutoff;

					#if defined( ASE_DEPTH_WRITE_ON )
						float DeviceDepth = IN.pos.z;
					#endif

					#ifdef _ALPHATEST_ON
						clip( Alpha - AlphaClipThreshold );
					#endif

					#if defined( ASE_DEPTH_WRITE_ON )
						outputDepth = DeviceDepth;
					#endif

					return float4( _ObjectId, _PassValue, 1.0, 1.0 );
				}
			ENDCG
		}

		
		Pass
		{
			
			Name "ScenePickingPass"
			Tags { "LightMode"="ScenePickingPass" }

			ZWrite On

			CGPROGRAM
				#define ASE_GEOMETRY
				#define ASE_FRAGMENT_NORMAL 0
				#define ASE_RECEIVE_SHADOWS
				#pragma multi_compile_instancing
				#pragma multi_compile _ LOD_FADE_CROSSFADE
				#define ASE_FOG
				#define _SPECULAR_SETUP 1
				#define ASE_TRANSLUCENCY 1
				#define _ALPHATEST_ON
				#define _ALPHATEST_SHADOW_ON 1
				#define ASE_VERSION 19907

				#pragma vertex vert
				#pragma fragment frag
				#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2

				#pragma multi_compile_fwdbase
				#ifndef UNITY_PASS_FORWARDBASE
					#define UNITY_PASS_FORWARDBASE
				#endif
				#include "HLSLSupport.cginc"
				#if defined( ASE_GEOMETRY ) || defined( ASE_IMPOSTOR )
					#ifndef UNITY_INSTANCED_LOD_FADE
						#define UNITY_INSTANCED_LOD_FADE
					#endif
					#ifndef UNITY_INSTANCED_SH
						#define UNITY_INSTANCED_SH
					#endif
					#ifndef UNITY_INSTANCED_LIGHTMAPSTS
						#define UNITY_INSTANCED_LIGHTMAPSTS
					#endif
				#endif
				#include "UnityShaderVariables.cginc"
				#include "UnityCG.cginc"
				#include "Lighting.cginc"
				#include "UnityPBSLighting.cginc"
				#include "AutoLight.cginc"

				#define ASE_NEEDS_TEXTURE_COORDINATES0
				#define ASE_NEEDS_FRAG_TEXTURE_COORDINATES0


				float4 _SelectionID;

				struct appdata
				{
					float4 vertex : POSITION;
					half3 normal : NORMAL;
					half4 tangent : TANGENT;
					float4 ase_texcoord : TEXCOORD0;
					UNITY_VERTEX_INPUT_INSTANCE_ID
				};

				struct v2f
				{
					float4 pos : SV_POSITION;
					float4 worldPos : TEXCOORD0; // xyz = positionWS
					half3 normalWS : TEXCOORD1;
					float4 ase_texcoord2 : TEXCOORD2;
					UNITY_VERTEX_INPUT_INSTANCE_ID
					UNITY_VERTEX_OUTPUT_STEREO
				};

				#ifdef ASE_TESSELLATION
					float _TessPhongStrength;
					float _TessValue;
					float _TessMin;
					float _TessMax;
					float _TessEdgeLength;
					float _TessMaxDisp;
				#endif

				uniform int _Cull;
				uniform float _ASETranslucencyAmbient;
				uniform float _ASETranslucencyDirect;
				uniform float _ASETranslucencyScattering;
				uniform float _ASETranslucencyNormalDistortion;
				uniform float _ASETranslucencyStrength;
				uniform float _ASETranslucencyShadow;
				uniform sampler2D _MainTex;
				uniform float4 _MainTex_ST;
				uniform float _AlphaClip;
				uniform float _Cutoff;


				
				v2f VertexFunction( appdata v  )
				{
					UNITY_SETUP_INSTANCE_ID(v);
					v2f o;
					UNITY_INITIALIZE_OUTPUT(v2f,o);
					UNITY_TRANSFER_INSTANCE_ID(v,o);
					UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

					o.ase_texcoord2.xy = v.ase_texcoord.xy;
					
					//setting value to unused interpolator channels and avoid initialization warnings
					o.ase_texcoord2.zw = 0;

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
					v.tangent = v.tangent;

					float3 positionWS = mul( unity_ObjectToWorld, v.vertex ).xyz;
					half3 normalWS = UnityObjectToWorldNormal( v.normal );

					o.pos = UnityObjectToClipPos( v.vertex );
					o.worldPos.xyz = positionWS;
					o.normalWS = normalWS;
					return o;
				}

				#if defined(ASE_TESSELLATION)
				struct VertexControl
				{
					float4 vertex : INTERNALTESSPOS;
					half3 normal : NORMAL;
					float4 ase_texcoord : TEXCOORD0;

					UNITY_VERTEX_INPUT_INSTANCE_ID
				};

				struct TessellationFactors
				{
					float edge[3] : SV_TessFactor;
					float inside : SV_InsideTessFactor;
				};

				VertexControl vert ( appdata v )
				{
					VertexControl o;
					UNITY_SETUP_INSTANCE_ID(v);
					UNITY_TRANSFER_INSTANCE_ID(v, o);
					o.vertex = v.vertex;
					o.normal = v.normal;
					o.ase_texcoord = v.ase_texcoord;
					return o;
				}

				TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
				{
					TessellationFactors o;
					float4 tf = 1;
					float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
					float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
					#if defined(ASE_FIXED_TESSELLATION)
					tf = FixedTess( tessValue );
					#elif defined(ASE_DISTANCE_TESSELLATION)
					tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, UNITY_MATRIX_M, _WorldSpaceCameraPos );
					#elif defined(ASE_LENGTH_TESSELLATION)
					tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, UNITY_MATRIX_M, _WorldSpaceCameraPos, _ScreenParams );
					#elif defined(ASE_LENGTH_CULL_TESSELLATION)
					tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, UNITY_MATRIX_M, _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
					#endif
					o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
					return o;
				}

				[domain("tri")]
				[partitioning("fractional_odd")]
				[outputtopology("triangle_cw")]
				[patchconstantfunc("TessellationFunction")]
				[outputcontrolpoints(3)]
				VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
				{
				   return patch[id];
				}

				[domain("tri")]
				v2f DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
				{
					appdata o = (appdata) 0;
					o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
					o.normal = patch[0].normal * bary.x + patch[1].normal * bary.y + patch[2].normal * bary.z;
					o.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
					#if defined(ASE_PHONG_TESSELLATION)
					float3 pp[3];
					for (int i = 0; i < 3; ++i)
						pp[i] = o.vertex.xyz - patch[i].normal * (dot(o.vertex.xyz, patch[i].normal) - dot(patch[i].vertex.xyz, patch[i].normal));
					float phongStrength = _TessPhongStrength;
					o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
					#endif
					UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
					return VertexFunction(o);
				}
				#else
				v2f vert ( appdata v )
				{
					return VertexFunction( v );
				}
				#endif

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

					float2 appendResult2941_g72783 = (float2(_MainTex_ST.x , _MainTex_ST.y));
					float2 appendResult2944_g72783 = (float2(_MainTex_ST.z , _MainTex_ST.w));
					float2 UV__MainTex_ST585_g72783 = ( ( IN.ase_texcoord2.xy * appendResult2941_g72783 ) + appendResult2944_g72783 );
					float4 temp_output_2_0_g72784 = tex2D( _MainTex, UV__MainTex_ST585_g72783 );
					float temp_output_2424_6_g72783 = (temp_output_2_0_g72784).a;
					float lerpResult3822_g72783 = lerp( 1.0 , ( temp_output_2424_6_g72783 * 1.0 ) , _AlphaClip);
					

					half Alpha = lerpResult3822_g72783;
					half AlphaClipThreshold = _Cutoff;

					#if defined( ASE_DEPTH_WRITE_ON )
						float DeviceDepth = IN.pos.z;
					#endif

					#ifdef _ALPHATEST_ON
						clip( Alpha - AlphaClipThreshold );
					#endif

					#if defined( ASE_DEPTH_WRITE_ON )
						outputDepth = DeviceDepth;
					#endif

					return _SelectionID;
				}
			ENDCG
		}
		
	}
	CustomEditor "AmplifyShaderEditor.MaterialInspector"
	
	Fallback Off
}
/*ASEBEGIN
Version=19907
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;79;-320,-784;Inherit;False;323.6836;532.5345;ASE TRANSLUCENCY;6;88;89;85;84;83;82;;0,0,0,1;0;0
Node;AmplifyShaderEditor.StickyNoteNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;80;144,-432;Inherit;False;201.2633;100;Render Face;;0,0,0,1;_Cull;0;0
Node;AmplifyShaderEditor.StickyNoteNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;81;-688,-768;Inherit;False;306.8;158.4936;;;0,0,0,1;_ASETranslucencyStrength$_ASETranslucencyNormalDistortion$_ASETranslucencyScattering$_ASETranslucencyDirect$_ASETranslucencyAmbient$_ASETranslucencyShadow;0;0
Node;AmplifyShaderEditor.IntNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;86;144,-320;Inherit;False;Property;_Cull;Render Face;0;1;[Enum];Create;False;1;;0;1;Front,2,Back,1,Both,0;True;0;False;2;0;False;0;0;0;1;INT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;82;-304,-416;Inherit;False;Property;_ASETranslucencyAmbient;ASE Translucency Ambient;72;0;Create;False;1;;0;0;True;0;False;0.8339342;0.639;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;83;-304,-496;Inherit;False;Property;_ASETranslucencyDirect;ASE Translucency Direct ;71;0;Create;False;1;;0;0;True;0;False;0;0.607;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;84;-304,-576;Inherit;False;Property;_ASETranslucencyScattering;ASE Translucency Scattering ;70;0;Create;False;1;;0;0;True;0;False;2;20.1;1;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;85;-304,-656;Inherit;False;Property;_ASETranslucencyNormalDistortion;ASE Translucency Normal Distortion ;69;0;Create;False;1;;0;0;True;0;False;0.2735869;0.763;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;89;-304,-736;Inherit;False;Property;_ASETranslucencyStrength;ASE Translucency Strength;68;0;Create;False;1;;0;0;True;2;Header(ASE TRANSLUCENCY);Space(10);False;1;49.8;1;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;88;-304,-336;Inherit;False;Property;_ASETranslucencyShadow;ASE Translucency Shadow ;73;0;Create;False;0;0;0;True;0;False;0.5;0.822;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;100;-256,-128;Inherit;False;Material Sample Lit BIRP;1;;72783;fa2ac23eff248fb4081cb4ddc9dd8b32;15,4308,1,4310,1,4330,1,4322,1,4326,1,3839,0,3370,0,4031,0,3255,0,3257,0,4545,0,4548,0,4580,0,4581,0,4582,0;0;12;FLOAT3;2986;FLOAT3;2985;FLOAT3;3073;FLOAT3;4307;FLOAT;2991;FLOAT;2992;FLOAT3;2989;FLOAT;2987;FLOAT;2988;FLOAT;3667;FLOAT3;3646;FLOAT3;3645
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;71;132.4658,-74.98228;Float;False;False;-1;3;AmplifyShaderEditor.MaterialInspector;0;1;New Amplify Shader;ed95fe726fd7b4644bb42f4d1ddd2bcd;True;ExtraPrePass;0;0;ExtraPrePass;6;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;False;False;True;3;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;DisableBatching=False=DisableBatching;True;3;True;12;all;0;False;True;1;1;False;;0;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;False;True;1;LightMode=ForwardBase;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;73;132.4658,-74.98228;Float;False;False;-1;3;AmplifyShaderEditor.MaterialInspector;0;1;New Amplify Shader;ed95fe726fd7b4644bb42f4d1ddd2bcd;True;ForwardAdd;0;2;ForwardAdd;0;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;False;False;True;3;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;DisableBatching=False=DisableBatching;True;3;True;12;all;0;False;True;4;1;False;;1;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;True;1;LightMode=ForwardAdd;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;74;132.4658,-74.98228;Float;False;False;-1;3;AmplifyShaderEditor.MaterialInspector;0;1;New Amplify Shader;ed95fe726fd7b4644bb42f4d1ddd2bcd;True;Deferred;0;3;Deferred;0;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;False;False;True;3;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;DisableBatching=False=DisableBatching;True;3;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Deferred;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;75;132.4658,-74.98228;Float;False;False;-1;3;AmplifyShaderEditor.MaterialInspector;0;1;New Amplify Shader;ed95fe726fd7b4644bb42f4d1ddd2bcd;True;Meta;0;4;Meta;0;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;False;False;True;3;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;DisableBatching=False=DisableBatching;True;3;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Meta;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;76;132.4658,-74.98228;Float;False;False;-1;3;AmplifyShaderEditor.MaterialInspector;0;1;New Amplify Shader;ed95fe726fd7b4644bb42f4d1ddd2bcd;True;ShadowCaster;0;5;ShadowCaster;0;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;False;False;True;3;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;DisableBatching=False=DisableBatching;True;3;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;False;;True;3;False;;False;False;True;1;LightMode=ShadowCaster;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;77;132.4658,-74.98228;Float;False;False;-1;3;AmplifyShaderEditor.MaterialInspector;0;1;New Amplify Shader;ed95fe726fd7b4644bb42f4d1ddd2bcd;True;SceneSelectionPass;0;6;SceneSelectionPass;0;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;False;False;True;3;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;DisableBatching=False=DisableBatching;True;3;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;False;;False;False;False;True;1;LightMode=SceneSelectionPass;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;78;132.4658,-74.98228;Float;False;False;-1;3;AmplifyShaderEditor.MaterialInspector;0;1;New Amplify Shader;ed95fe726fd7b4644bb42f4d1ddd2bcd;True;ScenePickingPass;0;7;ScenePickingPass;0;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;False;False;True;3;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;DisableBatching=False=DisableBatching;True;3;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;False;;False;False;False;True;1;LightMode=ScenePickingPass;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;72;128,-128;Float;False;True;-1;3;AmplifyShaderEditor.MaterialInspector;0;12;AmplifyShaderPack/Material Sample Translucent;ed95fe726fd7b4644bb42f4d1ddd2bcd;True;ForwardBase;0;1;ForwardBase;17;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;True;True;0;True;_Cull;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;False;False;True;3;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;DisableBatching=False=DisableBatching;True;3;True;12;all;0;False;True;1;1;False;;0;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;False;0;;0;0;Standard;44;Category;0;0;  Instanced Terrain Normals;1;0;Workflow;0;638926737668598260;Surface;0;0;  Blend;0;0;  Dither Shadows;1;0;Two Sided;1;0;Alpha Clipping;1;639038528987499015;  Use Shadow Threshold;1;639038528993630190;Deferred Pass;0;0;Normal Space;0;0;Transmission;0;0;  Transmission Shadow;0.5,True,_ASETransmissionShadow;0;Translucency;1;638926737713931551;  Translucency Strength;1,True,_ASETranslucencyStrength;639038527365420713;  Normal Distortion;0.5,True,_ASETranslucencyNormalDistortion;639038527414169788;  Scattering;2,True,_ASETranslucencyScattering;639038527467091228;  Direct;0.9,True,_ASETranslucencyDirect;639038527501488296;  Ambient;0.1,True,_ASETranslucencyAmbient;639038527549596687;  Shadow;0.5,True,_ASETranslucencyShadow;639040142328204765;Cast Shadows;1;0;Receive Shadows;1;0;Receive Specular;2;0;Receive Reflections;2;0;GPU Instancing;1;0;LOD CrossFade;1;0;Built-in Fog;1;0;Ambient Light;1;0;Meta Pass;1;0;Add Pass;1;0;Override Baked GI;0;0;Write Depth;0;0;Extra Pre Pass;0;0;Tessellation;0;0;  Phong;0;0;  Strength;0.5,False,;0;  Type;0;0;  Tess;16,True,_TessellationStrength;0;  Min;10,True,_TessellationDistanceMin;0;  Max;25,True,_TessellationDistanceMax;0;  Edge Length;16,False,;0;  Max Displacement;25,False,;0;Disable Batching;0;0;Vertex Position;1;0;0;8;False;True;True;False;True;True;True;True;False;;False;0
WireConnection;72;0;100;2986
WireConnection;72;1;100;2985
WireConnection;72;3;100;3073
WireConnection;72;5;100;2991
WireConnection;72;6;100;2992
WireConnection;72;2;100;2989
WireConnection;72;7;100;2987
WireConnection;72;8;100;2988
WireConnection;72;9;100;3667
WireConnection;72;14;100;3645
ASEEND*/
//CHKSM=028ED2933ECBB2BFAF8BFDCB61BC84E3B77A6302