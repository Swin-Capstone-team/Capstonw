// Made with Amplify Shader Editor v1.9.9.7
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AmplifyShaderPack/Terrain/Simple"
{
	Properties
	{
		[HideInInspector] _TerrainHolesTexture( "_TerrainHolesTexture", 2D ) = "white" {}
		[HideInInspector] _Control( "Control", 2D ) = "white" {}
		[HideInInspector] _Splat0( "Splat0", 2D ) = "gray" {}
		[HideInInspector] _DiffuseRemapScale0( "_DiffuseRemapScale0", Vector ) = ( 1, 1, 1, 1 )
		[HideInInspector] _Normal0( "Normal0", 2D ) = "bump" {}
		[HideInInspector] _NormalScale0( "NormalScale0", Float ) = 1
		[HideInInspector] _Mask0( "Mask0", 2D ) = "gray" {}
		[HideInInspector] _Metallic0( "Metallic0", Range( 0, 1 ) ) = 0
		[HideInInspector] _Smoothness0( "Smoothness 0", Range( 0, 1 ) ) = 0
		[HideInInspector] _Specular0( "_Specular0", Vector ) = ( 0, 0, 0, 0 )
		[HideInInspector] _NormalScale1( "NormalScale1", Float ) = 1
		[HideInInspector] _Splat1( "Splat1", 2D ) = "gray" {}
		[HideInInspector] _Normal1( "Normal1", 2D ) = "bump" {}
		[HideInInspector] _DiffuseRemapScale1( "_DiffuseRemapScale1", Vector ) = ( 1, 1, 1, 1 )
		[HideInInspector] _Metallic1( "Metallic1", Range( 0, 1 ) ) = 0
		[HideInInspector] _Mask1( "Mask1", 2D ) = "gray" {}
		[HideInInspector] _Smoothness1( "Smoothness1", Range( 0, 1 ) ) = 0
		[HideInInspector] _NormalScale2( "NormalScale2", Float ) = 1
		[HideInInspector] _Metallic2( "Metallic2", Range( 0, 1 ) ) = 0
		[HideInInspector] _Splat2( "Splat2", 2D ) = "gray" {}
		[HideInInspector] _Smoothness2( "Smoothness2", Range( 0, 1 ) ) = 0
		[HideInInspector] _Specular1( "_Specular1", Vector ) = ( 0, 0, 0, 0 )
		[HideInInspector] _Normal2( "Normal2", 2D ) = "bump" {}
		[HideInInspector] _DiffuseRemapScale2( "_DiffuseRemapScale2", Vector ) = ( 1, 1, 1, 1 )
		[HideInInspector] _Mask2( "Mask2", 2D ) = "gray" {}
		[HideInInspector] _NormalScale3( "_NormalScale3", Float ) = 1
		[HideInInspector] _Metallic3( "Metallic3", Range( 0, 1 ) ) = 0
		[HideInInspector] _Smoothness3( "Smoothness3", Range( 0, 1 ) ) = 0
		[HideInInspector] _Splat3( "Splat3", 2D ) = "gray" {}
		[HideInInspector] _Normal3( "Normal3", 2D ) = "bump" {}
		[HideInInspector] _Mask3( "Mask3", 2D ) = "gray" {}
		[HideInInspector] _DiffuseRemapScale3( "_DiffuseRemapScale3", Vector ) = ( 1, 1, 1, 1 )
		[HideInInspector] _Specular2( "_Specular2", Vector ) = ( 0, 0, 0, 0 )
		[HideInInspector] _Specular3( "_Specular3", Vector ) = ( 0, 0, 0, 0 )
		[HideInInspector] _texcoord( "", 2D ) = "white" {}


		//_TransmissionShadow( "Transmission Shadow", Range( 0, 1 ) ) = 0.5
		//_TransStrength( "Trans Strength", Range( 0, 50 ) ) = 1
		//_TransNormal( "Trans Normal Distortion", Range( 0, 1 ) ) = 0.5
		//_TransScattering( "Trans Scattering", Range( 1, 50 ) ) = 2
		//_TransDirect( "Trans Direct", Range( 0, 1 ) ) = 0.9
		//_TransAmbient( "Trans Ambient", Range( 0, 1 ) ) = 0.1
		//_TransShadow( "Trans Shadow", Range( 0, 1 ) ) = 0.5

		//_TessPhongStrength( "Tess Phong Strength", Range( 0, 1 ) ) = 0.5
		//_TessValue( "Tess Max Tessellation", Range( 1, 32 ) ) = 16
		//_TessMin( "Tess Min Distance", Float ) = 10
		//_TessMax( "Tess Max Distance", Float ) = 25
		//_TessEdgeLength ( "Tess Edge length", Range( 2, 50 ) ) = 16
		//_TessMaxDisp( "Tess Max Displacement", Float ) = 25

		[ToggleOff] _SpecularHighlights("Specular Highlights", Float) = 1.0
		[ToggleOff] _GlossyReflections("Reflections", Float) = 1.0

		[KeywordEnum(Vertex, Pixel)] _InstancedTerrainNormals("Instanced Terrain Normals", Float) = 1.0
	}

	SubShader
	{
		

		

		Tags { "RenderType"="Opaque" "Queue"="Geometry-100" "DisableBatching"="False" "TerrainCompatible"="True" "IgnoreProjector"="True" "SplatCount"="4" "MaskMapR"="Metallic" "MaskMapG"="AO" "MaskMapB"="Height" "MaskMapA"="Smoothness" }

	LOD 0

		Cull Back
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
			Tags { "LightMode"="ForwardBase" "TerrainCompatible"="True" "IgnoreProjector"="True" "SplatCount"="4" "MaskMapR"="Metallic" "MaskMapG"="AO" "MaskMapB"="Height" "MaskMapA"="Smoothness" }

			Blend One Zero

			CGPROGRAM
				#define ASE_FRAGMENT_NORMAL 0
				#define ASE_RECEIVE_SHADOWS
				#pragma shader_feature_local_fragment _SPECULARHIGHLIGHTS_OFF
				#pragma shader_feature_local_fragment _GLOSSYREFLECTIONS_OFF
				#pragma multi_compile _ LOD_FADE_CROSSFADE
				#pragma multi_compile_fog
				#define ASE_FOG
				#define ASE_TERRAIN
				#pragma shader_feature _INSTANCEDTERRAINNORMALS_PIXEL
				#define _SPECULAR_SETUP 1
				#define _ALPHATEST_ON
				#define ASE_VERSION 19907
				#define ASE_USING_SAMPLING_MACROS 1

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
				#define ASE_NEEDS_VERT_NORMAL
				#define ASE_NEEDS_TEXTURE_COORDINATES0
				#define ASE_NEEDS_VERT_TEXTURE_COORDINATES0
				#define ASE_NEEDS_FRAG_TEXTURE_COORDINATES0
				#define ASE_INSTANCED_TERRAIN
				#define ASE_NEEDS_VERT_POSITION
				#pragma multi_compile_instancing
				#pragma instancing_options assumeuniformscaling nomatrices nolightprobe nolightmap forwardadd
				#define TERRAIN_SPLAT_FIRSTPASS 1
				#define TERRAIN_STANDARD_SHADER
				#define _DEFERRED_CAPABLE_MATERIAL
				#pragma shader_feature_local _TERRAIN_4_LAYERS
				#pragma shader_feature_local _NORMALMAP
				#pragma shader_feature_local _MASKMAP
				#pragma editor_sync_compilation
				#if defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL) || (defined(SHADER_TARGET_SURFACE_ANALYSIS) && !defined(SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER))//ASE Sampler Macros
				#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex.Sample(samplerTex,coord)
				#else//ASE Sampling Macros
				#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex2D(tex,coord)
				#endif//ASE Sampling Macros
				


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

				UNITY_DECLARE_TEX2D_NOSAMPLER(_Control);
				uniform float4 _Control_ST;
				SamplerState sampler_Control;
				uniform float4 _DiffuseRemapScale0;
				UNITY_DECLARE_TEX2D_NOSAMPLER(_Splat0);
				uniform float4 _Splat0_ST;
				SamplerState sampler_Splat0;
				uniform float4 _DiffuseRemapScale1;
				UNITY_DECLARE_TEX2D_NOSAMPLER(_Splat1);
				uniform float4 _Splat1_ST;
				uniform float4 _DiffuseRemapScale2;
				UNITY_DECLARE_TEX2D_NOSAMPLER(_Splat2);
				uniform float4 _Splat2_ST;
				uniform float4 _DiffuseRemapScale3;
				UNITY_DECLARE_TEX2D_NOSAMPLER(_Splat3);
				uniform float4 _Splat3_ST;
				UNITY_DECLARE_TEX2D_NOSAMPLER(_TerrainHolesTexture);
				uniform float4 _TerrainHolesTexture_ST;
				SamplerState sampler_TerrainHolesTexture;
				uniform float _Metallic0;
				UNITY_DECLARE_TEX2D_NOSAMPLER(_Mask0);
				SamplerState sampler_Mask0;
				uniform float _Metallic1;
				UNITY_DECLARE_TEX2D_NOSAMPLER(_Mask1);
				uniform float _Metallic2;
				UNITY_DECLARE_TEX2D_NOSAMPLER(_Mask2);
				uniform float _Metallic3;
				UNITY_DECLARE_TEX2D_NOSAMPLER(_Mask3);
				UNITY_DECLARE_TEX2D_NOSAMPLER(_Normal0);
				SamplerState sampler_Normal0;
				uniform half _NormalScale0;
				UNITY_DECLARE_TEX2D_NOSAMPLER(_Normal1);
				uniform half _NormalScale1;
				UNITY_DECLARE_TEX2D_NOSAMPLER(_Normal2);
				uniform half _NormalScale2;
				UNITY_DECLARE_TEX2D_NOSAMPLER(_Normal3);
				uniform half _NormalScale3;
				uniform float4 _Specular0;
				uniform float4 _Specular1;
				uniform float4 _Specular2;
				uniform float4 _Specular3;
				uniform float _Smoothness0;
				uniform float _Smoothness1;
				uniform float _Smoothness2;
				uniform float _Smoothness3;
				#ifdef UNITY_INSTANCING_ENABLED//ASE Terrain Instancing
					sampler2D _TerrainHeightmapTexture;//ASE Terrain Instancing
					sampler2D _TerrainNormalmapTexture;//ASE Terrain Instancing
				#endif//ASE Terrain Instancing
				UNITY_INSTANCING_BUFFER_START( Terrain )//ASE Terrain Instancing
					UNITY_DEFINE_INSTANCED_PROP( float4, _TerrainPatchInstanceData )//ASE Terrain Instancing
				UNITY_INSTANCING_BUFFER_END( Terrain)//ASE Terrain Instancing
				CBUFFER_START( UnityTerrain)//ASE Terrain Instancing
					#ifdef UNITY_INSTANCING_ENABLED//ASE Terrain Instancing
						float4 _TerrainHeightmapRecipSize;//ASE Terrain Instancing
						float4 _TerrainHeightmapScale;//ASE Terrain Instancing
					#endif//ASE Terrain Instancing
				CBUFFER_END//ASE Terrain Instancing


				float3 ASEComputeDiffuseAndFresnel0( float3 baseColor, float metallic, out float3 specularColor, out float oneMinusReflectivity )
				{
					#ifdef UNITY_COLORSPACE_GAMMA
						const float dielectricF0 = 0.220916301;
					#else
						const float dielectricF0 = 0.04;
					#endif
					specularColor = lerp( dielectricF0.xxx, baseColor, metallic );
					oneMinusReflectivity = 1.0 - metallic;
					return baseColor * oneMinusReflectivity;
				}
				
				void TerrainApplyMeshModification( inout float3 position, inout half3 normal, inout float4 texcoord )
				{
				#ifdef UNITY_INSTANCING_ENABLED
					float2 patchVertex = position.xy;
					float4 instanceData = UNITY_ACCESS_INSTANCED_PROP( Terrain, _TerrainPatchInstanceData );
					float4 uvscale = instanceData.z * _TerrainHeightmapRecipSize;
					float4 uvoffset = instanceData.xyxy * uvscale;
					uvoffset.xy += 0.5f * _TerrainHeightmapRecipSize.xy;
					float2 sampleCoords = (patchVertex.xy * uvscale.xy + uvoffset.xy);
					texcoord.xyzw = float4(patchVertex.xy * uvscale.zw + uvoffset.zw, 0, 0);
					float height = UnpackHeightmap( tex2Dlod( _TerrainHeightmapTexture, float4(sampleCoords, 0, 0) ) );
					position.xz = (patchVertex.xy + instanceData.xy) * _TerrainHeightmapScale.xz * instanceData.z;
					position.y = height * _TerrainHeightmapScale.y;
					normal = tex2Dlod( _TerrainNormalmapTexture, texcoord.xyzw ).rgb * 2 - 1;
				#endif
				}
				

				v2f VertexFunction( appdata v  )
				{
					UNITY_SETUP_INSTANCE_ID(v);
					v2f o;
					UNITY_INITIALIZE_OUTPUT(v2f,o);
					UNITY_TRANSFER_INSTANCE_ID(v,o);
					UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

					#if defined( ASE_INSTANCED_TERRAIN ) && !defined( ASE_TESSELLATION )
						TerrainApplyMeshModification( v.vertex.xyz, v.normal, v.texcoord.xyzw );
					#endif
					
					float localCalculateTangentsStandard706_g23 = ( 0.0 );
					{
					v.tangent.xyz = cross ( v.normal, float3( 0, 0, 1 ) );
					v.tangent.w = -1;
					}
					float3 temp_output_707_0_g23 = ( localCalculateTangentsStandard706_g23 + v.normal );
					
					float4 appendResult704_g23 = (float4(cross( v.normal , float3( 0, 0, 1 ) ) , -1.0));
					
					float2 TecCoord01519_g23 = v.texcoord.xyzw.xy;
					float2 break1507_g23 = _Control_ST.zw;
					float2 appendResult1501_g23 = (float2(( break1507_g23.x + 0.001 ) , ( break1507_g23.y + 0.0001 )));
					float2 vertexToFrag1508_g23 = ( ( TecCoord01519_g23 * _Control_ST.xy ) + appendResult1501_g23 );
					o.ase_texcoord6.xy = vertexToFrag1508_g23;
					
					o.ase_texcoord6.zw = v.texcoord.xyzw.xy;

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
					v.normal = temp_output_707_0_g23;
					v.tangent = appendResult704_g23;

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
					#if defined( ASE_INSTANCED_TERRAIN )
						TerrainApplyMeshModification( o.vertex.xyz, o.normal, o.texcoord );
					#endif
					
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

					float2 vertexToFrag1508_g23 = IN.ase_texcoord6.xy;
					float4 tex2DNode1505_g23 = SAMPLE_TEXTURE2D( _Control, sampler_Control, vertexToFrag1508_g23 );
					float dotResult278_g23 = dot( tex2DNode1505_g23 , half4( 1, 1, 1, 1 ) );
					float localSplatClip276_g23 = ( dotResult278_g23 );
					float SplatWeight276_g23 = dotResult278_g23;
					{
					#if !defined(SHADER_API_MOBILE) && defined(TERRAIN_SPLAT_ADDPASS)
					clip(SplatWeight276_g23 == 0.0f ? -1 : 1);
					#endif
					}
					float4 Control26_g23 = ( tex2DNode1505_g23 / ( localSplatClip276_g23 + 0.001 ) );
					float2 TecCoord01519_g23 = IN.ase_texcoord6.zw;
					float2 temp_output_1607_0_g23 = ( ( TecCoord01519_g23 * _Splat0_ST.xy ) + _Splat0_ST.zw );
					float4 tex2DNode1539_g23 = SAMPLE_TEXTURE2D( _Splat0, sampler_Splat0, temp_output_1607_0_g23 );
					float3 Splat0342_g23 = (tex2DNode1539_g23).rgb;
					float2 temp_output_1563_0_g23 = ( ( TecCoord01519_g23 * _Splat1_ST.xy ) + _Splat1_ST.zw );
					float4 tex2DNode1547_g23 = SAMPLE_TEXTURE2D( _Splat1, sampler_Splat0, temp_output_1563_0_g23 );
					float3 Splat1379_g23 = (tex2DNode1547_g23).rgb;
					float2 temp_output_1575_0_g23 = ( ( TecCoord01519_g23 * _Splat2_ST.xy ) + _Splat2_ST.zw );
					float4 tex2DNode1565_g23 = SAMPLE_TEXTURE2D( _Splat2, sampler_Splat0, temp_output_1575_0_g23 );
					float3 Splat2357_g23 = (tex2DNode1565_g23).rgb;
					float2 temp_output_1595_0_g23 = ( ( TecCoord01519_g23 * _Splat3_ST.xy ) + _Splat3_ST.zw );
					float4 tex2DNode1587_g23 = SAMPLE_TEXTURE2D( _Splat3, sampler_Splat0, temp_output_1595_0_g23 );
					float3 Splat3390_g23 = (tex2DNode1587_g23).rgb;
					float4 weightedBlendVar1445_g23 = Control26_g23;
					float3 weightedBlend1445_g23 = ( weightedBlendVar1445_g23.x*( (_DiffuseRemapScale0).xyz * Splat0342_g23 ) + weightedBlendVar1445_g23.y*( (_DiffuseRemapScale1).xyz * Splat1379_g23 ) + weightedBlendVar1445_g23.z*( (_DiffuseRemapScale2).xyz * Splat2357_g23 ) + weightedBlendVar1445_g23.w*( (_DiffuseRemapScale3).xyz * Splat3390_g23 ) );
					float3 localClipHoles1474_g23 = ( weightedBlend1445_g23 );
					float2 uv_TerrainHolesTexture = IN.ase_texcoord6.zw * _TerrainHolesTexture_ST.xy + _TerrainHolesTexture_ST.zw;
					float Hole1474_g23 = SAMPLE_TEXTURE2D( _TerrainHolesTexture, sampler_TerrainHolesTexture, uv_TerrainHolesTexture ).r;
					{
					#ifdef _ALPHATEST_ON
					clip(Hole1474_g23 == 0.0005f? -1 : 1);
					#endif
					}
					float4 tex2DNode1616_g23 = SAMPLE_TEXTURE2D( _Mask0, sampler_Mask0, temp_output_1607_0_g23 );
					float Mask0R334_g23 = tex2DNode1616_g23.r;
					float4 tex2DNode1551_g23 = SAMPLE_TEXTURE2D( _Mask1, sampler_Mask0, temp_output_1563_0_g23 );
					float Mask1R370_g23 = tex2DNode1551_g23.r;
					float4 tex2DNode1632_g23 = SAMPLE_TEXTURE2D( _Mask2, sampler_Mask0, temp_output_1575_0_g23 );
					float Mask2R359_g23 = tex2DNode1632_g23.r;
					float4 tex2DNode1648_g23 = SAMPLE_TEXTURE2D( _Mask3, sampler_Mask0, temp_output_1595_0_g23 );
					float Mask3R388_g23 = tex2DNode1648_g23.r;
					float4 weightedBlendVar1370_g23 = Control26_g23;
					float weightedBlend1370_g23 = ( weightedBlendVar1370_g23.x*( _Metallic0 * Mask0R334_g23 ) + weightedBlendVar1370_g23.y*( _Metallic1 * Mask1R370_g23 ) + weightedBlendVar1370_g23.z*( _Metallic2 * Mask2R359_g23 ) + weightedBlendVar1370_g23.w*( _Metallic3 * Mask3R388_g23 ) );
					float3 specularColor1403_g23 = (0).xxx;
					float oneMinusReflectivity1403_g23 = 0;
					float3 diffuseColor1403_g23 = ASEComputeDiffuseAndFresnel0( localClipHoles1474_g23, weightedBlend1370_g23, specularColor1403_g23, oneMinusReflectivity1403_g23 );
					
					float4 Normal0341_g23 = SAMPLE_TEXTURE2D( _Normal0, sampler_Normal0, temp_output_1607_0_g23 );
					float4 Normal1378_g23 = SAMPLE_TEXTURE2D( _Normal1, sampler_Normal0, temp_output_1563_0_g23 );
					float4 Normal2356_g23 = SAMPLE_TEXTURE2D( _Normal2, sampler_Normal0, temp_output_1575_0_g23 );
					float4 Normal3398_g23 = SAMPLE_TEXTURE2D( _Normal3, sampler_Normal0, temp_output_1595_0_g23 );
					float4 weightedBlendVar473_g23 = Control26_g23;
					float3 weightedBlend473_g23 = ( weightedBlendVar473_g23.x*UnpackScaleNormal( Normal0341_g23, _NormalScale0 ) + weightedBlendVar473_g23.y*UnpackScaleNormal( Normal1378_g23, _NormalScale1 ) + weightedBlendVar473_g23.z*UnpackScaleNormal( Normal2356_g23, _NormalScale2 ) + weightedBlendVar473_g23.w*UnpackScaleNormal( Normal3398_g23, _NormalScale3 ) );
					float3 break513_g23 = weightedBlend473_g23;
					float3 appendResult514_g23 = (float3(break513_g23.x , break513_g23.y , ( break513_g23.z + 0.001 )));
					
					float4 weightedBlendVar1390_g23 = Control26_g23;
					float4 weightedBlend1390_g23 = ( weightedBlendVar1390_g23.x*_Specular0 + weightedBlendVar1390_g23.y*_Specular1 + weightedBlendVar1390_g23.z*_Specular2 + weightedBlendVar1390_g23.w*_Specular3 );
					
					float Mask0A335_g23 = tex2DNode1616_g23.a;
					float Mask1A369_g23 = tex2DNode1551_g23.a;
					float Mask2A360_g23 = tex2DNode1632_g23.a;
					float Mask3A391_g23 = tex2DNode1648_g23.a;
					float4 weightedBlendVar1253_g23 = Control26_g23;
					float weightedBlend1253_g23 = ( weightedBlendVar1253_g23.x*( _Smoothness0 * Mask0A335_g23 ) + weightedBlendVar1253_g23.y*( _Smoothness1 * Mask1A369_g23 ) + weightedBlendVar1253_g23.z*( _Smoothness2 * Mask2A360_g23 ) + weightedBlendVar1253_g23.w*( _Smoothness3 * Mask3A391_g23 ) );
					
					float Mask0G409_g23 = tex2DNode1616_g23.g;
					float temp_output_1319_0_g23 = ( ( ( Mask0G409_g23 - 0.5 ) * 0.25 ) + ( 1.0 - 0.25 ) );
					float Mask1G371_g23 = tex2DNode1551_g23.g;
					float temp_output_1295_0_g23 = ( ( ( Mask1G371_g23 - 0.5 ) * 0.25 ) + ( 1.0 - 0.25 ) );
					float Mask2G358_g23 = tex2DNode1632_g23.g;
					float temp_output_1294_0_g23 = ( ( ( Mask2G358_g23 - 0.5 ) * 0.25 ) + ( 1.0 - 0.25 ) );
					float Mask3G389_g23 = tex2DNode1648_g23.g;
					float temp_output_1303_0_g23 = ( ( ( Mask3G389_g23 - 0.5 ) * 0.25 ) + ( 1.0 - 0.25 ) );
					float4 weightedBlendVar1313_g23 = Control26_g23;
					float weightedBlend1313_g23 = ( weightedBlendVar1313_g23.x*saturate( temp_output_1319_0_g23 ) + weightedBlendVar1313_g23.y*saturate( temp_output_1295_0_g23 ) + weightedBlendVar1313_g23.z*saturate( temp_output_1294_0_g23 ) + weightedBlendVar1313_g23.w*saturate( temp_output_1303_0_g23 ) );
					
					float Alpha1491_g23 = dotResult278_g23;
					
					float4 tex2DNode451_g23 = SAMPLE_TEXTURE2D( _TerrainHolesTexture, sampler_TerrainHolesTexture, uv_TerrainHolesTexture );
					

					o.Albedo = diffuseColor1403_g23;
					o.Normal = appendResult514_g23;

					half3 Specular = ( specularColor1403_g23 + (weightedBlend1390_g23).xyz );
					half Metallic = 0;
					half Smoothness = weightedBlend1253_g23;
					half Occlusion = saturate( weightedBlend1313_g23 );

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

					o.Emission = half3( 0, 0, 0 );
					o.Alpha = ( 0.0001 + Alpha1491_g23 );
					half AlphaClipThreshold = ( 1.0 - tex2DNode451_g23 ).r;
					half AlphaClipThresholdShadow = 0.5;
					half3 BakedGI = 0;
					half3 Transmission = 1;
					half3 Translucency = 1;

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
						half shadow = _TransShadow;
						half normal = _TransNormal;
						half scattering = _TransScattering;
						half direct = _TransDirect;
						half ambient = _TransAmbient;
						half strength = _TransStrength;

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
				#define ASE_FRAGMENT_NORMAL 0
				#define ASE_RECEIVE_SHADOWS
				#pragma shader_feature_local_fragment _SPECULARHIGHLIGHTS_OFF
				#pragma multi_compile _ LOD_FADE_CROSSFADE
				#pragma multi_compile_fog
				#define ASE_FOG
				#define ASE_TERRAIN
				#pragma shader_feature _INSTANCEDTERRAINNORMALS_PIXEL
				#define _SPECULAR_SETUP 1
				#define _ALPHATEST_ON
				#define ASE_VERSION 19907
				#define ASE_USING_SAMPLING_MACROS 1

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
				#define ASE_NEEDS_VERT_NORMAL
				#define ASE_NEEDS_TEXTURE_COORDINATES0
				#define ASE_NEEDS_VERT_TEXTURE_COORDINATES0
				#define ASE_NEEDS_FRAG_TEXTURE_COORDINATES0
				#define ASE_INSTANCED_TERRAIN
				#define ASE_NEEDS_VERT_POSITION
				#pragma multi_compile_instancing
				#pragma instancing_options assumeuniformscaling nomatrices nolightprobe nolightmap forwardadd
				#define TERRAIN_SPLAT_FIRSTPASS 1
				#define TERRAIN_STANDARD_SHADER
				#define _DEFERRED_CAPABLE_MATERIAL
				#pragma shader_feature_local _TERRAIN_4_LAYERS
				#pragma shader_feature_local _NORMALMAP
				#pragma shader_feature_local _MASKMAP
				#pragma editor_sync_compilation
				#if defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL) || (defined(SHADER_TARGET_SURFACE_ANALYSIS) && !defined(SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER))//ASE Sampler Macros
				#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex.Sample(samplerTex,coord)
				#else//ASE Sampling Macros
				#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex2D(tex,coord)
				#endif//ASE Sampling Macros
				


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

				UNITY_DECLARE_TEX2D_NOSAMPLER(_Control);
				uniform float4 _Control_ST;
				SamplerState sampler_Control;
				uniform float4 _DiffuseRemapScale0;
				UNITY_DECLARE_TEX2D_NOSAMPLER(_Splat0);
				uniform float4 _Splat0_ST;
				SamplerState sampler_Splat0;
				uniform float4 _DiffuseRemapScale1;
				UNITY_DECLARE_TEX2D_NOSAMPLER(_Splat1);
				uniform float4 _Splat1_ST;
				uniform float4 _DiffuseRemapScale2;
				UNITY_DECLARE_TEX2D_NOSAMPLER(_Splat2);
				uniform float4 _Splat2_ST;
				uniform float4 _DiffuseRemapScale3;
				UNITY_DECLARE_TEX2D_NOSAMPLER(_Splat3);
				uniform float4 _Splat3_ST;
				UNITY_DECLARE_TEX2D_NOSAMPLER(_TerrainHolesTexture);
				uniform float4 _TerrainHolesTexture_ST;
				SamplerState sampler_TerrainHolesTexture;
				uniform float _Metallic0;
				UNITY_DECLARE_TEX2D_NOSAMPLER(_Mask0);
				SamplerState sampler_Mask0;
				uniform float _Metallic1;
				UNITY_DECLARE_TEX2D_NOSAMPLER(_Mask1);
				uniform float _Metallic2;
				UNITY_DECLARE_TEX2D_NOSAMPLER(_Mask2);
				uniform float _Metallic3;
				UNITY_DECLARE_TEX2D_NOSAMPLER(_Mask3);
				UNITY_DECLARE_TEX2D_NOSAMPLER(_Normal0);
				SamplerState sampler_Normal0;
				uniform half _NormalScale0;
				UNITY_DECLARE_TEX2D_NOSAMPLER(_Normal1);
				uniform half _NormalScale1;
				UNITY_DECLARE_TEX2D_NOSAMPLER(_Normal2);
				uniform half _NormalScale2;
				UNITY_DECLARE_TEX2D_NOSAMPLER(_Normal3);
				uniform half _NormalScale3;
				uniform float4 _Specular0;
				uniform float4 _Specular1;
				uniform float4 _Specular2;
				uniform float4 _Specular3;
				uniform float _Smoothness0;
				uniform float _Smoothness1;
				uniform float _Smoothness2;
				uniform float _Smoothness3;
				#ifdef UNITY_INSTANCING_ENABLED//ASE Terrain Instancing
					sampler2D _TerrainHeightmapTexture;//ASE Terrain Instancing
					sampler2D _TerrainNormalmapTexture;//ASE Terrain Instancing
				#endif//ASE Terrain Instancing
				UNITY_INSTANCING_BUFFER_START( Terrain )//ASE Terrain Instancing
					UNITY_DEFINE_INSTANCED_PROP( float4, _TerrainPatchInstanceData )//ASE Terrain Instancing
				UNITY_INSTANCING_BUFFER_END( Terrain)//ASE Terrain Instancing
				CBUFFER_START( UnityTerrain)//ASE Terrain Instancing
					#ifdef UNITY_INSTANCING_ENABLED//ASE Terrain Instancing
						float4 _TerrainHeightmapRecipSize;//ASE Terrain Instancing
						float4 _TerrainHeightmapScale;//ASE Terrain Instancing
					#endif//ASE Terrain Instancing
				CBUFFER_END//ASE Terrain Instancing


				float3 ASEComputeDiffuseAndFresnel0( float3 baseColor, float metallic, out float3 specularColor, out float oneMinusReflectivity )
				{
					#ifdef UNITY_COLORSPACE_GAMMA
						const float dielectricF0 = 0.220916301;
					#else
						const float dielectricF0 = 0.04;
					#endif
					specularColor = lerp( dielectricF0.xxx, baseColor, metallic );
					oneMinusReflectivity = 1.0 - metallic;
					return baseColor * oneMinusReflectivity;
				}
				
				void TerrainApplyMeshModification( inout float3 position, inout half3 normal, inout float4 texcoord )
				{
				#ifdef UNITY_INSTANCING_ENABLED
					float2 patchVertex = position.xy;
					float4 instanceData = UNITY_ACCESS_INSTANCED_PROP( Terrain, _TerrainPatchInstanceData );
					float4 uvscale = instanceData.z * _TerrainHeightmapRecipSize;
					float4 uvoffset = instanceData.xyxy * uvscale;
					uvoffset.xy += 0.5f * _TerrainHeightmapRecipSize.xy;
					float2 sampleCoords = (patchVertex.xy * uvscale.xy + uvoffset.xy);
					texcoord.xyzw = float4(patchVertex.xy * uvscale.zw + uvoffset.zw, 0, 0);
					float height = UnpackHeightmap( tex2Dlod( _TerrainHeightmapTexture, float4(sampleCoords, 0, 0) ) );
					position.xz = (patchVertex.xy + instanceData.xy) * _TerrainHeightmapScale.xz * instanceData.z;
					position.y = height * _TerrainHeightmapScale.y;
					normal = tex2Dlod( _TerrainNormalmapTexture, texcoord.xyzw ).rgb * 2 - 1;
				#endif
				}
				

				v2f VertexFunction (appdata v  ) {
					UNITY_SETUP_INSTANCE_ID(v);
					v2f o;
					UNITY_INITIALIZE_OUTPUT(v2f,o);
					UNITY_TRANSFER_INSTANCE_ID(v,o);
					UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

					#if defined( ASE_INSTANCED_TERRAIN ) && !defined( ASE_TESSELLATION )
						TerrainApplyMeshModification( v.vertex.xyz, v.normal, v.texcoord.xyzw );
					#endif
					
					float localCalculateTangentsStandard706_g23 = ( 0.0 );
					{
					v.tangent.xyz = cross ( v.normal, float3( 0, 0, 1 ) );
					v.tangent.w = -1;
					}
					float3 temp_output_707_0_g23 = ( localCalculateTangentsStandard706_g23 + v.normal );
					
					float4 appendResult704_g23 = (float4(cross( v.normal , float3( 0, 0, 1 ) ) , -1.0));
					
					float2 TecCoord01519_g23 = v.texcoord.xyzw.xy;
					float2 break1507_g23 = _Control_ST.zw;
					float2 appendResult1501_g23 = (float2(( break1507_g23.x + 0.001 ) , ( break1507_g23.y + 0.0001 )));
					float2 vertexToFrag1508_g23 = ( ( TecCoord01519_g23 * _Control_ST.xy ) + appendResult1501_g23 );
					o.ase_texcoord5.xy = vertexToFrag1508_g23;
					
					o.ase_texcoord5.zw = v.texcoord.xyzw.xy;

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
					v.normal = temp_output_707_0_g23;
					v.tangent = appendResult704_g23;

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
					#if defined( ASE_INSTANCED_TERRAIN )
						TerrainApplyMeshModification( o.vertex.xyz, o.normal, o.texcoord );
					#endif
					
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

				half4 frag ( v2f IN 
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

					float2 vertexToFrag1508_g23 = IN.ase_texcoord5.xy;
					float4 tex2DNode1505_g23 = SAMPLE_TEXTURE2D( _Control, sampler_Control, vertexToFrag1508_g23 );
					float dotResult278_g23 = dot( tex2DNode1505_g23 , half4( 1, 1, 1, 1 ) );
					float localSplatClip276_g23 = ( dotResult278_g23 );
					float SplatWeight276_g23 = dotResult278_g23;
					{
					#if !defined(SHADER_API_MOBILE) && defined(TERRAIN_SPLAT_ADDPASS)
					clip(SplatWeight276_g23 == 0.0f ? -1 : 1);
					#endif
					}
					float4 Control26_g23 = ( tex2DNode1505_g23 / ( localSplatClip276_g23 + 0.001 ) );
					float2 TecCoord01519_g23 = IN.ase_texcoord5.zw;
					float2 temp_output_1607_0_g23 = ( ( TecCoord01519_g23 * _Splat0_ST.xy ) + _Splat0_ST.zw );
					float4 tex2DNode1539_g23 = SAMPLE_TEXTURE2D( _Splat0, sampler_Splat0, temp_output_1607_0_g23 );
					float3 Splat0342_g23 = (tex2DNode1539_g23).rgb;
					float2 temp_output_1563_0_g23 = ( ( TecCoord01519_g23 * _Splat1_ST.xy ) + _Splat1_ST.zw );
					float4 tex2DNode1547_g23 = SAMPLE_TEXTURE2D( _Splat1, sampler_Splat0, temp_output_1563_0_g23 );
					float3 Splat1379_g23 = (tex2DNode1547_g23).rgb;
					float2 temp_output_1575_0_g23 = ( ( TecCoord01519_g23 * _Splat2_ST.xy ) + _Splat2_ST.zw );
					float4 tex2DNode1565_g23 = SAMPLE_TEXTURE2D( _Splat2, sampler_Splat0, temp_output_1575_0_g23 );
					float3 Splat2357_g23 = (tex2DNode1565_g23).rgb;
					float2 temp_output_1595_0_g23 = ( ( TecCoord01519_g23 * _Splat3_ST.xy ) + _Splat3_ST.zw );
					float4 tex2DNode1587_g23 = SAMPLE_TEXTURE2D( _Splat3, sampler_Splat0, temp_output_1595_0_g23 );
					float3 Splat3390_g23 = (tex2DNode1587_g23).rgb;
					float4 weightedBlendVar1445_g23 = Control26_g23;
					float3 weightedBlend1445_g23 = ( weightedBlendVar1445_g23.x*( (_DiffuseRemapScale0).xyz * Splat0342_g23 ) + weightedBlendVar1445_g23.y*( (_DiffuseRemapScale1).xyz * Splat1379_g23 ) + weightedBlendVar1445_g23.z*( (_DiffuseRemapScale2).xyz * Splat2357_g23 ) + weightedBlendVar1445_g23.w*( (_DiffuseRemapScale3).xyz * Splat3390_g23 ) );
					float3 localClipHoles1474_g23 = ( weightedBlend1445_g23 );
					float2 uv_TerrainHolesTexture = IN.ase_texcoord5.zw * _TerrainHolesTexture_ST.xy + _TerrainHolesTexture_ST.zw;
					float Hole1474_g23 = SAMPLE_TEXTURE2D( _TerrainHolesTexture, sampler_TerrainHolesTexture, uv_TerrainHolesTexture ).r;
					{
					#ifdef _ALPHATEST_ON
					clip(Hole1474_g23 == 0.0005f? -1 : 1);
					#endif
					}
					float4 tex2DNode1616_g23 = SAMPLE_TEXTURE2D( _Mask0, sampler_Mask0, temp_output_1607_0_g23 );
					float Mask0R334_g23 = tex2DNode1616_g23.r;
					float4 tex2DNode1551_g23 = SAMPLE_TEXTURE2D( _Mask1, sampler_Mask0, temp_output_1563_0_g23 );
					float Mask1R370_g23 = tex2DNode1551_g23.r;
					float4 tex2DNode1632_g23 = SAMPLE_TEXTURE2D( _Mask2, sampler_Mask0, temp_output_1575_0_g23 );
					float Mask2R359_g23 = tex2DNode1632_g23.r;
					float4 tex2DNode1648_g23 = SAMPLE_TEXTURE2D( _Mask3, sampler_Mask0, temp_output_1595_0_g23 );
					float Mask3R388_g23 = tex2DNode1648_g23.r;
					float4 weightedBlendVar1370_g23 = Control26_g23;
					float weightedBlend1370_g23 = ( weightedBlendVar1370_g23.x*( _Metallic0 * Mask0R334_g23 ) + weightedBlendVar1370_g23.y*( _Metallic1 * Mask1R370_g23 ) + weightedBlendVar1370_g23.z*( _Metallic2 * Mask2R359_g23 ) + weightedBlendVar1370_g23.w*( _Metallic3 * Mask3R388_g23 ) );
					float3 specularColor1403_g23 = (0).xxx;
					float oneMinusReflectivity1403_g23 = 0;
					float3 diffuseColor1403_g23 = ASEComputeDiffuseAndFresnel0( localClipHoles1474_g23, weightedBlend1370_g23, specularColor1403_g23, oneMinusReflectivity1403_g23 );
					
					float4 Normal0341_g23 = SAMPLE_TEXTURE2D( _Normal0, sampler_Normal0, temp_output_1607_0_g23 );
					float4 Normal1378_g23 = SAMPLE_TEXTURE2D( _Normal1, sampler_Normal0, temp_output_1563_0_g23 );
					float4 Normal2356_g23 = SAMPLE_TEXTURE2D( _Normal2, sampler_Normal0, temp_output_1575_0_g23 );
					float4 Normal3398_g23 = SAMPLE_TEXTURE2D( _Normal3, sampler_Normal0, temp_output_1595_0_g23 );
					float4 weightedBlendVar473_g23 = Control26_g23;
					float3 weightedBlend473_g23 = ( weightedBlendVar473_g23.x*UnpackScaleNormal( Normal0341_g23, _NormalScale0 ) + weightedBlendVar473_g23.y*UnpackScaleNormal( Normal1378_g23, _NormalScale1 ) + weightedBlendVar473_g23.z*UnpackScaleNormal( Normal2356_g23, _NormalScale2 ) + weightedBlendVar473_g23.w*UnpackScaleNormal( Normal3398_g23, _NormalScale3 ) );
					float3 break513_g23 = weightedBlend473_g23;
					float3 appendResult514_g23 = (float3(break513_g23.x , break513_g23.y , ( break513_g23.z + 0.001 )));
					
					float4 weightedBlendVar1390_g23 = Control26_g23;
					float4 weightedBlend1390_g23 = ( weightedBlendVar1390_g23.x*_Specular0 + weightedBlendVar1390_g23.y*_Specular1 + weightedBlendVar1390_g23.z*_Specular2 + weightedBlendVar1390_g23.w*_Specular3 );
					
					float Mask0A335_g23 = tex2DNode1616_g23.a;
					float Mask1A369_g23 = tex2DNode1551_g23.a;
					float Mask2A360_g23 = tex2DNode1632_g23.a;
					float Mask3A391_g23 = tex2DNode1648_g23.a;
					float4 weightedBlendVar1253_g23 = Control26_g23;
					float weightedBlend1253_g23 = ( weightedBlendVar1253_g23.x*( _Smoothness0 * Mask0A335_g23 ) + weightedBlendVar1253_g23.y*( _Smoothness1 * Mask1A369_g23 ) + weightedBlendVar1253_g23.z*( _Smoothness2 * Mask2A360_g23 ) + weightedBlendVar1253_g23.w*( _Smoothness3 * Mask3A391_g23 ) );
					
					float Mask0G409_g23 = tex2DNode1616_g23.g;
					float temp_output_1319_0_g23 = ( ( ( Mask0G409_g23 - 0.5 ) * 0.25 ) + ( 1.0 - 0.25 ) );
					float Mask1G371_g23 = tex2DNode1551_g23.g;
					float temp_output_1295_0_g23 = ( ( ( Mask1G371_g23 - 0.5 ) * 0.25 ) + ( 1.0 - 0.25 ) );
					float Mask2G358_g23 = tex2DNode1632_g23.g;
					float temp_output_1294_0_g23 = ( ( ( Mask2G358_g23 - 0.5 ) * 0.25 ) + ( 1.0 - 0.25 ) );
					float Mask3G389_g23 = tex2DNode1648_g23.g;
					float temp_output_1303_0_g23 = ( ( ( Mask3G389_g23 - 0.5 ) * 0.25 ) + ( 1.0 - 0.25 ) );
					float4 weightedBlendVar1313_g23 = Control26_g23;
					float weightedBlend1313_g23 = ( weightedBlendVar1313_g23.x*saturate( temp_output_1319_0_g23 ) + weightedBlendVar1313_g23.y*saturate( temp_output_1295_0_g23 ) + weightedBlendVar1313_g23.z*saturate( temp_output_1294_0_g23 ) + weightedBlendVar1313_g23.w*saturate( temp_output_1303_0_g23 ) );
					
					float Alpha1491_g23 = dotResult278_g23;
					
					float4 tex2DNode451_g23 = SAMPLE_TEXTURE2D( _TerrainHolesTexture, sampler_TerrainHolesTexture, uv_TerrainHolesTexture );
					

					o.Albedo = diffuseColor1403_g23;
					o.Normal = appendResult514_g23;

					half3 Specular = ( specularColor1403_g23 + (weightedBlend1390_g23).xyz );
					half Metallic = 0;
					half Smoothness = weightedBlend1253_g23;
					half Occlusion = saturate( weightedBlend1313_g23 );

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

					o.Emission = half3( 0, 0, 0 );
					o.Alpha = ( 0.0001 + Alpha1491_g23 );
					half AlphaClipThreshold = ( 1.0 - tex2DNode451_g23 ).r;
					half3 Transmission = 1;
					half3 Translucency = 1;

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
						half shadow = _TransShadow;
						half normal = _TransNormal;
						half scattering = _TransScattering;
						half direct = _TransDirect;
						half ambient = _TransAmbient;
						half strength = _TransStrength;

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
			
			Name "Deferred"
			Tags { "LightMode"="Deferred" }

			AlphaToMask Off

			CGPROGRAM
				#define ASE_FRAGMENT_NORMAL 0
				#define ASE_RECEIVE_SHADOWS
				#pragma shader_feature_local_fragment _SPECULARHIGHLIGHTS_OFF
				#pragma shader_feature_local_fragment _GLOSSYREFLECTIONS_OFF
				#pragma multi_compile _ LOD_FADE_CROSSFADE
				#define ASE_FOG
				#define ASE_TERRAIN
				#pragma shader_feature _INSTANCEDTERRAINNORMALS_PIXEL
				#define _SPECULAR_SETUP 1
				#define _ALPHATEST_ON
				#define ASE_VERSION 19907
				#define ASE_USING_SAMPLING_MACROS 1

				#pragma vertex vert
				#pragma fragment frag
				#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
				#pragma multi_compile_prepassfinal
				#ifndef UNITY_PASS_DEFERRED
					#define UNITY_PASS_DEFERRED
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

				#if defined( UNITY_INSTANCING_ENABLED ) && defined( ASE_INSTANCED_TERRAIN ) && ( defined(_TERRAIN_INSTANCED_PERPIXEL_NORMAL) || defined(_INSTANCEDTERRAINNORMALS_PIXEL) )
					#define ENABLE_TERRAIN_PERPIXEL_NORMAL
				#endif

				#include "UnityStandardUtils.cginc"
				#define ASE_NEEDS_VERT_NORMAL
				#define ASE_NEEDS_TEXTURE_COORDINATES0
				#define ASE_NEEDS_VERT_TEXTURE_COORDINATES0
				#define ASE_NEEDS_FRAG_TEXTURE_COORDINATES0
				#define ASE_INSTANCED_TERRAIN
				#define ASE_NEEDS_VERT_POSITION
				#pragma multi_compile_instancing
				#pragma instancing_options assumeuniformscaling nomatrices nolightprobe nolightmap forwardadd
				#define TERRAIN_SPLAT_FIRSTPASS 1
				#define TERRAIN_STANDARD_SHADER
				#define _DEFERRED_CAPABLE_MATERIAL
				#pragma shader_feature_local _TERRAIN_4_LAYERS
				#pragma shader_feature_local _NORMALMAP
				#pragma shader_feature_local _MASKMAP
				#pragma editor_sync_compilation
				#if defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL) || (defined(SHADER_TARGET_SURFACE_ANALYSIS) && !defined(SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER))//ASE Sampler Macros
				#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex.Sample(samplerTex,coord)
				#else//ASE Sampling Macros
				#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex2D(tex,coord)
				#endif//ASE Sampling Macros
				


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
					float4 ase_texcoord4 : TEXCOORD4;
					UNITY_VERTEX_INPUT_INSTANCE_ID
					UNITY_VERTEX_OUTPUT_STEREO
				};

				#ifdef LIGHTMAP_ON
				float4 unity_LightmapFade;
				#endif
				half4 unity_Ambient;
				#ifdef ASE_TESSELLATION
					float _TessPhongStrength;
					float _TessValue;
					float _TessMin;
					float _TessMax;
					float _TessEdgeLength;
					float _TessMaxDisp;
				#endif

				UNITY_DECLARE_TEX2D_NOSAMPLER(_Control);
				uniform float4 _Control_ST;
				SamplerState sampler_Control;
				uniform float4 _DiffuseRemapScale0;
				UNITY_DECLARE_TEX2D_NOSAMPLER(_Splat0);
				uniform float4 _Splat0_ST;
				SamplerState sampler_Splat0;
				uniform float4 _DiffuseRemapScale1;
				UNITY_DECLARE_TEX2D_NOSAMPLER(_Splat1);
				uniform float4 _Splat1_ST;
				uniform float4 _DiffuseRemapScale2;
				UNITY_DECLARE_TEX2D_NOSAMPLER(_Splat2);
				uniform float4 _Splat2_ST;
				uniform float4 _DiffuseRemapScale3;
				UNITY_DECLARE_TEX2D_NOSAMPLER(_Splat3);
				uniform float4 _Splat3_ST;
				UNITY_DECLARE_TEX2D_NOSAMPLER(_TerrainHolesTexture);
				uniform float4 _TerrainHolesTexture_ST;
				SamplerState sampler_TerrainHolesTexture;
				uniform float _Metallic0;
				UNITY_DECLARE_TEX2D_NOSAMPLER(_Mask0);
				SamplerState sampler_Mask0;
				uniform float _Metallic1;
				UNITY_DECLARE_TEX2D_NOSAMPLER(_Mask1);
				uniform float _Metallic2;
				UNITY_DECLARE_TEX2D_NOSAMPLER(_Mask2);
				uniform float _Metallic3;
				UNITY_DECLARE_TEX2D_NOSAMPLER(_Mask3);
				UNITY_DECLARE_TEX2D_NOSAMPLER(_Normal0);
				SamplerState sampler_Normal0;
				uniform half _NormalScale0;
				UNITY_DECLARE_TEX2D_NOSAMPLER(_Normal1);
				uniform half _NormalScale1;
				UNITY_DECLARE_TEX2D_NOSAMPLER(_Normal2);
				uniform half _NormalScale2;
				UNITY_DECLARE_TEX2D_NOSAMPLER(_Normal3);
				uniform half _NormalScale3;
				uniform float4 _Specular0;
				uniform float4 _Specular1;
				uniform float4 _Specular2;
				uniform float4 _Specular3;
				uniform float _Smoothness0;
				uniform float _Smoothness1;
				uniform float _Smoothness2;
				uniform float _Smoothness3;
				#ifdef UNITY_INSTANCING_ENABLED//ASE Terrain Instancing
					sampler2D _TerrainHeightmapTexture;//ASE Terrain Instancing
					sampler2D _TerrainNormalmapTexture;//ASE Terrain Instancing
				#endif//ASE Terrain Instancing
				UNITY_INSTANCING_BUFFER_START( Terrain )//ASE Terrain Instancing
					UNITY_DEFINE_INSTANCED_PROP( float4, _TerrainPatchInstanceData )//ASE Terrain Instancing
				UNITY_INSTANCING_BUFFER_END( Terrain)//ASE Terrain Instancing
				CBUFFER_START( UnityTerrain)//ASE Terrain Instancing
					#ifdef UNITY_INSTANCING_ENABLED//ASE Terrain Instancing
						float4 _TerrainHeightmapRecipSize;//ASE Terrain Instancing
						float4 _TerrainHeightmapScale;//ASE Terrain Instancing
					#endif//ASE Terrain Instancing
				CBUFFER_END//ASE Terrain Instancing


				float3 ASEComputeDiffuseAndFresnel0( float3 baseColor, float metallic, out float3 specularColor, out float oneMinusReflectivity )
				{
					#ifdef UNITY_COLORSPACE_GAMMA
						const float dielectricF0 = 0.220916301;
					#else
						const float dielectricF0 = 0.04;
					#endif
					specularColor = lerp( dielectricF0.xxx, baseColor, metallic );
					oneMinusReflectivity = 1.0 - metallic;
					return baseColor * oneMinusReflectivity;
				}
				
				void TerrainApplyMeshModification( inout float3 position, inout half3 normal, inout float4 texcoord )
				{
				#ifdef UNITY_INSTANCING_ENABLED
					float2 patchVertex = position.xy;
					float4 instanceData = UNITY_ACCESS_INSTANCED_PROP( Terrain, _TerrainPatchInstanceData );
					float4 uvscale = instanceData.z * _TerrainHeightmapRecipSize;
					float4 uvoffset = instanceData.xyxy * uvscale;
					uvoffset.xy += 0.5f * _TerrainHeightmapRecipSize.xy;
					float2 sampleCoords = (patchVertex.xy * uvscale.xy + uvoffset.xy);
					texcoord.xyzw = float4(patchVertex.xy * uvscale.zw + uvoffset.zw, 0, 0);
					float height = UnpackHeightmap( tex2Dlod( _TerrainHeightmapTexture, float4(sampleCoords, 0, 0) ) );
					position.xz = (patchVertex.xy + instanceData.xy) * _TerrainHeightmapScale.xz * instanceData.z;
					position.y = height * _TerrainHeightmapScale.y;
					normal = tex2Dlod( _TerrainNormalmapTexture, texcoord.xyzw ).rgb * 2 - 1;
				#endif
				}
				

				v2f VertexFunction (appdata v  ) {
					UNITY_SETUP_INSTANCE_ID(v);
					v2f o;
					UNITY_INITIALIZE_OUTPUT(v2f,o);
					UNITY_TRANSFER_INSTANCE_ID(v,o);
					UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

					#if defined( ASE_INSTANCED_TERRAIN ) && !defined( ASE_TESSELLATION )
						TerrainApplyMeshModification( v.vertex.xyz, v.normal, v.texcoord.xyzw );
					#endif
					
					float localCalculateTangentsStandard706_g23 = ( 0.0 );
					{
					v.tangent.xyz = cross ( v.normal, float3( 0, 0, 1 ) );
					v.tangent.w = -1;
					}
					float3 temp_output_707_0_g23 = ( localCalculateTangentsStandard706_g23 + v.normal );
					
					float4 appendResult704_g23 = (float4(cross( v.normal , float3( 0, 0, 1 ) ) , -1.0));
					
					float2 TecCoord01519_g23 = v.texcoord.xyzw.xy;
					float2 break1507_g23 = _Control_ST.zw;
					float2 appendResult1501_g23 = (float2(( break1507_g23.x + 0.001 ) , ( break1507_g23.y + 0.0001 )));
					float2 vertexToFrag1508_g23 = ( ( TecCoord01519_g23 * _Control_ST.xy ) + appendResult1501_g23 );
					o.ase_texcoord4.xy = vertexToFrag1508_g23;
					
					o.ase_texcoord4.zw = v.texcoord.xyzw.xy;

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
					v.normal = temp_output_707_0_g23;
					v.tangent = appendResult704_g23;

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
					#if defined( ASE_INSTANCED_TERRAIN )
						TerrainApplyMeshModification( o.vertex.xyz, o.normal, o.texcoord );
					#endif
					
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

				void frag (v2f IN 
					, out half4 outGBuffer0 : SV_Target0
					, out half4 outGBuffer1 : SV_Target1
					, out half4 outGBuffer2 : SV_Target2
					, out half4 outEmission : SV_Target3
					#if defined(SHADOWS_SHADOWMASK) && (UNITY_ALLOWED_MRT_COUNT > 4)
					, out half4 outShadowMask : SV_Target4
					#endif
					#if defined( ASE_DEPTH_WRITE_ON )
					, out float outputDepth : SV_Depth
					#endif
				)
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

					float3 PositionWS = IN.worldPos.xyz;
					half3 ViewDirWS = normalize( UnityWorldSpaceViewDir( PositionWS ) );
					float4 ScreenPosNorm = float4( IN.pos.xy * ( _ScreenParams.zw - 1.0 ), IN.pos.zw );
					float4 ClipPos = ComputeClipSpacePosition( ScreenPosNorm.xy, IN.pos.z ) * IN.pos.w;
					float4 ScreenPos = ComputeScreenPos( ClipPos );
					half3 NormalWS = IN.normalWS;
					half3 TangentWS = IN.tangentWS.xyz;
					half3 BitangentWS = cross( IN.normalWS, IN.tangentWS.xyz ) * IN.tangentWS.w * unity_WorldTransformParams.w;

					#if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
						float2 sampleCoords = (IN.tangentWS.zw / _TerrainHeightmapRecipSize.zw + 0.5f) * _TerrainHeightmapRecipSize.xy;
						NormalWS = UnityObjectToWorldNormal(normalize(tex2D(_TerrainNormalmapTexture, sampleCoords).rgb * 2 - 1));
						TangentWS = -cross(unity_ObjectToWorld._13_23_33, NormalWS);
						BitangentWS = cross(NormalWS, -TangentWS);
					#endif

					float2 vertexToFrag1508_g23 = IN.ase_texcoord4.xy;
					float4 tex2DNode1505_g23 = SAMPLE_TEXTURE2D( _Control, sampler_Control, vertexToFrag1508_g23 );
					float dotResult278_g23 = dot( tex2DNode1505_g23 , half4( 1, 1, 1, 1 ) );
					float localSplatClip276_g23 = ( dotResult278_g23 );
					float SplatWeight276_g23 = dotResult278_g23;
					{
					#if !defined(SHADER_API_MOBILE) && defined(TERRAIN_SPLAT_ADDPASS)
					clip(SplatWeight276_g23 == 0.0f ? -1 : 1);
					#endif
					}
					float4 Control26_g23 = ( tex2DNode1505_g23 / ( localSplatClip276_g23 + 0.001 ) );
					float2 TecCoord01519_g23 = IN.ase_texcoord4.zw;
					float2 temp_output_1607_0_g23 = ( ( TecCoord01519_g23 * _Splat0_ST.xy ) + _Splat0_ST.zw );
					float4 tex2DNode1539_g23 = SAMPLE_TEXTURE2D( _Splat0, sampler_Splat0, temp_output_1607_0_g23 );
					float3 Splat0342_g23 = (tex2DNode1539_g23).rgb;
					float2 temp_output_1563_0_g23 = ( ( TecCoord01519_g23 * _Splat1_ST.xy ) + _Splat1_ST.zw );
					float4 tex2DNode1547_g23 = SAMPLE_TEXTURE2D( _Splat1, sampler_Splat0, temp_output_1563_0_g23 );
					float3 Splat1379_g23 = (tex2DNode1547_g23).rgb;
					float2 temp_output_1575_0_g23 = ( ( TecCoord01519_g23 * _Splat2_ST.xy ) + _Splat2_ST.zw );
					float4 tex2DNode1565_g23 = SAMPLE_TEXTURE2D( _Splat2, sampler_Splat0, temp_output_1575_0_g23 );
					float3 Splat2357_g23 = (tex2DNode1565_g23).rgb;
					float2 temp_output_1595_0_g23 = ( ( TecCoord01519_g23 * _Splat3_ST.xy ) + _Splat3_ST.zw );
					float4 tex2DNode1587_g23 = SAMPLE_TEXTURE2D( _Splat3, sampler_Splat0, temp_output_1595_0_g23 );
					float3 Splat3390_g23 = (tex2DNode1587_g23).rgb;
					float4 weightedBlendVar1445_g23 = Control26_g23;
					float3 weightedBlend1445_g23 = ( weightedBlendVar1445_g23.x*( (_DiffuseRemapScale0).xyz * Splat0342_g23 ) + weightedBlendVar1445_g23.y*( (_DiffuseRemapScale1).xyz * Splat1379_g23 ) + weightedBlendVar1445_g23.z*( (_DiffuseRemapScale2).xyz * Splat2357_g23 ) + weightedBlendVar1445_g23.w*( (_DiffuseRemapScale3).xyz * Splat3390_g23 ) );
					float3 localClipHoles1474_g23 = ( weightedBlend1445_g23 );
					float2 uv_TerrainHolesTexture = IN.ase_texcoord4.zw * _TerrainHolesTexture_ST.xy + _TerrainHolesTexture_ST.zw;
					float Hole1474_g23 = SAMPLE_TEXTURE2D( _TerrainHolesTexture, sampler_TerrainHolesTexture, uv_TerrainHolesTexture ).r;
					{
					#ifdef _ALPHATEST_ON
					clip(Hole1474_g23 == 0.0005f? -1 : 1);
					#endif
					}
					float4 tex2DNode1616_g23 = SAMPLE_TEXTURE2D( _Mask0, sampler_Mask0, temp_output_1607_0_g23 );
					float Mask0R334_g23 = tex2DNode1616_g23.r;
					float4 tex2DNode1551_g23 = SAMPLE_TEXTURE2D( _Mask1, sampler_Mask0, temp_output_1563_0_g23 );
					float Mask1R370_g23 = tex2DNode1551_g23.r;
					float4 tex2DNode1632_g23 = SAMPLE_TEXTURE2D( _Mask2, sampler_Mask0, temp_output_1575_0_g23 );
					float Mask2R359_g23 = tex2DNode1632_g23.r;
					float4 tex2DNode1648_g23 = SAMPLE_TEXTURE2D( _Mask3, sampler_Mask0, temp_output_1595_0_g23 );
					float Mask3R388_g23 = tex2DNode1648_g23.r;
					float4 weightedBlendVar1370_g23 = Control26_g23;
					float weightedBlend1370_g23 = ( weightedBlendVar1370_g23.x*( _Metallic0 * Mask0R334_g23 ) + weightedBlendVar1370_g23.y*( _Metallic1 * Mask1R370_g23 ) + weightedBlendVar1370_g23.z*( _Metallic2 * Mask2R359_g23 ) + weightedBlendVar1370_g23.w*( _Metallic3 * Mask3R388_g23 ) );
					float3 specularColor1403_g23 = (0).xxx;
					float oneMinusReflectivity1403_g23 = 0;
					float3 diffuseColor1403_g23 = ASEComputeDiffuseAndFresnel0( localClipHoles1474_g23, weightedBlend1370_g23, specularColor1403_g23, oneMinusReflectivity1403_g23 );
					
					float4 Normal0341_g23 = SAMPLE_TEXTURE2D( _Normal0, sampler_Normal0, temp_output_1607_0_g23 );
					float4 Normal1378_g23 = SAMPLE_TEXTURE2D( _Normal1, sampler_Normal0, temp_output_1563_0_g23 );
					float4 Normal2356_g23 = SAMPLE_TEXTURE2D( _Normal2, sampler_Normal0, temp_output_1575_0_g23 );
					float4 Normal3398_g23 = SAMPLE_TEXTURE2D( _Normal3, sampler_Normal0, temp_output_1595_0_g23 );
					float4 weightedBlendVar473_g23 = Control26_g23;
					float3 weightedBlend473_g23 = ( weightedBlendVar473_g23.x*UnpackScaleNormal( Normal0341_g23, _NormalScale0 ) + weightedBlendVar473_g23.y*UnpackScaleNormal( Normal1378_g23, _NormalScale1 ) + weightedBlendVar473_g23.z*UnpackScaleNormal( Normal2356_g23, _NormalScale2 ) + weightedBlendVar473_g23.w*UnpackScaleNormal( Normal3398_g23, _NormalScale3 ) );
					float3 break513_g23 = weightedBlend473_g23;
					float3 appendResult514_g23 = (float3(break513_g23.x , break513_g23.y , ( break513_g23.z + 0.001 )));
					
					float4 weightedBlendVar1390_g23 = Control26_g23;
					float4 weightedBlend1390_g23 = ( weightedBlendVar1390_g23.x*_Specular0 + weightedBlendVar1390_g23.y*_Specular1 + weightedBlendVar1390_g23.z*_Specular2 + weightedBlendVar1390_g23.w*_Specular3 );
					
					float Mask0A335_g23 = tex2DNode1616_g23.a;
					float Mask1A369_g23 = tex2DNode1551_g23.a;
					float Mask2A360_g23 = tex2DNode1632_g23.a;
					float Mask3A391_g23 = tex2DNode1648_g23.a;
					float4 weightedBlendVar1253_g23 = Control26_g23;
					float weightedBlend1253_g23 = ( weightedBlendVar1253_g23.x*( _Smoothness0 * Mask0A335_g23 ) + weightedBlendVar1253_g23.y*( _Smoothness1 * Mask1A369_g23 ) + weightedBlendVar1253_g23.z*( _Smoothness2 * Mask2A360_g23 ) + weightedBlendVar1253_g23.w*( _Smoothness3 * Mask3A391_g23 ) );
					
					float Mask0G409_g23 = tex2DNode1616_g23.g;
					float temp_output_1319_0_g23 = ( ( ( Mask0G409_g23 - 0.5 ) * 0.25 ) + ( 1.0 - 0.25 ) );
					float Mask1G371_g23 = tex2DNode1551_g23.g;
					float temp_output_1295_0_g23 = ( ( ( Mask1G371_g23 - 0.5 ) * 0.25 ) + ( 1.0 - 0.25 ) );
					float Mask2G358_g23 = tex2DNode1632_g23.g;
					float temp_output_1294_0_g23 = ( ( ( Mask2G358_g23 - 0.5 ) * 0.25 ) + ( 1.0 - 0.25 ) );
					float Mask3G389_g23 = tex2DNode1648_g23.g;
					float temp_output_1303_0_g23 = ( ( ( Mask3G389_g23 - 0.5 ) * 0.25 ) + ( 1.0 - 0.25 ) );
					float4 weightedBlendVar1313_g23 = Control26_g23;
					float weightedBlend1313_g23 = ( weightedBlendVar1313_g23.x*saturate( temp_output_1319_0_g23 ) + weightedBlendVar1313_g23.y*saturate( temp_output_1295_0_g23 ) + weightedBlendVar1313_g23.z*saturate( temp_output_1294_0_g23 ) + weightedBlendVar1313_g23.w*saturate( temp_output_1303_0_g23 ) );
					
					float Alpha1491_g23 = dotResult278_g23;
					
					float4 tex2DNode451_g23 = SAMPLE_TEXTURE2D( _TerrainHolesTexture, sampler_TerrainHolesTexture, uv_TerrainHolesTexture );
					

					o.Albedo = diffuseColor1403_g23;
					o.Normal = appendResult514_g23;

					half3 Specular = ( specularColor1403_g23 + (weightedBlend1390_g23).xyz );
					half Metallic = 0;
					half Smoothness = weightedBlend1253_g23;
					half Occlusion = saturate( weightedBlend1313_g23 );

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

					o.Emission = half3( 0, 0, 0 );
					o.Alpha = ( 0.0001 + Alpha1491_g23 );
					half AlphaClipThreshold = ( 1.0 - tex2DNode451_g23 ).r;
					half3 BakedGI = 0;

					#if defined( ASE_DEPTH_WRITE_ON )
						float DeviceDepth = IN.pos.z;
					#endif

					#if ( ASE_FRAGMENT_NORMAL == 0 )
						o.Normal = normalize( o.Normal.x * TangentWS + o.Normal.y * BitangentWS + o.Normal.z * NormalWS );
					#elif ( ASE_FRAGMENT_NORMAL == 1 )
						o.Normal = UnityObjectToWorldNormal( o.Normal );
					#elif ( ASE_FRAGMENT_NORMAL == 2 )
						// @diogo: already in world-space; do nothing
					#endif

					#ifdef _ALPHATEST_ON
						clip( o.Alpha - AlphaClipThreshold );
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
					gi.light.color = 0;
					gi.light.dir = half3( 0, 1, 0 );

					UnityGIInput giInput;
					UNITY_INITIALIZE_OUTPUT(UnityGIInput, giInput);
					giInput.light = gi.light;
					giInput.worldPos = PositionWS;
					giInput.worldViewDir = ViewDirWS;
					giInput.atten = 1;
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

					#if defined(ASE_LIGHTING_SIMPLE)
						#if defined(_SPECULAR_SETUP)
							outEmission = LightingBlinnPhong_Deferred( o, ViewDirWS, gi, outGBuffer0, outGBuffer1, outGBuffer2 );
						#else
							outEmission = LightingLambert_Deferred( o, gi, outGBuffer0, outGBuffer1, outGBuffer2 );
						#endif
					#else
						#if defined(_SPECULAR_SETUP)
							outEmission = LightingStandardSpecular_Deferred( o, ViewDirWS, gi, outGBuffer0, outGBuffer1, outGBuffer2 );
						#else
							outEmission = LightingStandard_Deferred( o, ViewDirWS, gi, outGBuffer0, outGBuffer1, outGBuffer2 );
						#endif
					#endif

					#if defined(SHADOWS_SHADOWMASK) && (UNITY_ALLOWED_MRT_COUNT > 4)
						outShadowMask = UnityGetRawBakedOcclusions( IN.ambientOrLightmapUV.xy, float3( 0, 0, 0 ) );
					#endif
					#ifndef UNITY_HDR_ON
						outEmission.rgb = exp2(-outEmission.rgb);
					#endif
				}
			ENDCG
		}

		
		Pass
		{
			
			Name "Meta"
			Tags { "LightMode"="Meta" }
			Cull Off

			CGPROGRAM
				#define ASE_FRAGMENT_NORMAL 0
				#define ASE_RECEIVE_SHADOWS
				#pragma multi_compile _ LOD_FADE_CROSSFADE
				#define ASE_FOG
				#define ASE_TERRAIN
				#define _SPECULAR_SETUP 1
				#define _ALPHATEST_ON
				#define ASE_VERSION 19907
				#define ASE_USING_SAMPLING_MACROS 1

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

				#define ASE_NEEDS_VERT_NORMAL
				#define ASE_NEEDS_TEXTURE_COORDINATES0
				#define ASE_NEEDS_VERT_TEXTURE_COORDINATES0
				#define ASE_NEEDS_FRAG_TEXTURE_COORDINATES0
				#define ASE_INSTANCED_TERRAIN
				#define ASE_NEEDS_VERT_POSITION
				#pragma multi_compile_instancing
				#pragma instancing_options assumeuniformscaling nomatrices nolightprobe nolightmap forwardadd
				#define TERRAIN_SPLAT_FIRSTPASS 1
				#define TERRAIN_STANDARD_SHADER
				#define _DEFERRED_CAPABLE_MATERIAL
				#pragma shader_feature_local _TERRAIN_4_LAYERS
				#pragma shader_feature_local _NORMALMAP
				#pragma shader_feature_local _MASKMAP
				#pragma editor_sync_compilation
				#if defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL) || (defined(SHADER_TARGET_SURFACE_ANALYSIS) && !defined(SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER))//ASE Sampler Macros
				#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex.Sample(samplerTex,coord)
				#else//ASE Sampling Macros
				#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex2D(tex,coord)
				#endif//ASE Sampling Macros
				


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

				UNITY_DECLARE_TEX2D_NOSAMPLER(_Control);
				uniform float4 _Control_ST;
				SamplerState sampler_Control;
				uniform float4 _DiffuseRemapScale0;
				UNITY_DECLARE_TEX2D_NOSAMPLER(_Splat0);
				uniform float4 _Splat0_ST;
				SamplerState sampler_Splat0;
				uniform float4 _DiffuseRemapScale1;
				UNITY_DECLARE_TEX2D_NOSAMPLER(_Splat1);
				uniform float4 _Splat1_ST;
				uniform float4 _DiffuseRemapScale2;
				UNITY_DECLARE_TEX2D_NOSAMPLER(_Splat2);
				uniform float4 _Splat2_ST;
				uniform float4 _DiffuseRemapScale3;
				UNITY_DECLARE_TEX2D_NOSAMPLER(_Splat3);
				uniform float4 _Splat3_ST;
				UNITY_DECLARE_TEX2D_NOSAMPLER(_TerrainHolesTexture);
				uniform float4 _TerrainHolesTexture_ST;
				SamplerState sampler_TerrainHolesTexture;
				uniform float _Metallic0;
				UNITY_DECLARE_TEX2D_NOSAMPLER(_Mask0);
				SamplerState sampler_Mask0;
				uniform float _Metallic1;
				UNITY_DECLARE_TEX2D_NOSAMPLER(_Mask1);
				uniform float _Metallic2;
				UNITY_DECLARE_TEX2D_NOSAMPLER(_Mask2);
				uniform float _Metallic3;
				UNITY_DECLARE_TEX2D_NOSAMPLER(_Mask3);
				#ifdef UNITY_INSTANCING_ENABLED//ASE Terrain Instancing
					sampler2D _TerrainHeightmapTexture;//ASE Terrain Instancing
					sampler2D _TerrainNormalmapTexture;//ASE Terrain Instancing
				#endif//ASE Terrain Instancing
				UNITY_INSTANCING_BUFFER_START( Terrain )//ASE Terrain Instancing
					UNITY_DEFINE_INSTANCED_PROP( float4, _TerrainPatchInstanceData )//ASE Terrain Instancing
				UNITY_INSTANCING_BUFFER_END( Terrain)//ASE Terrain Instancing
				CBUFFER_START( UnityTerrain)//ASE Terrain Instancing
					#ifdef UNITY_INSTANCING_ENABLED//ASE Terrain Instancing
						float4 _TerrainHeightmapRecipSize;//ASE Terrain Instancing
						float4 _TerrainHeightmapScale;//ASE Terrain Instancing
					#endif//ASE Terrain Instancing
				CBUFFER_END//ASE Terrain Instancing


				float3 ASEComputeDiffuseAndFresnel0( float3 baseColor, float metallic, out float3 specularColor, out float oneMinusReflectivity )
				{
					#ifdef UNITY_COLORSPACE_GAMMA
						const float dielectricF0 = 0.220916301;
					#else
						const float dielectricF0 = 0.04;
					#endif
					specularColor = lerp( dielectricF0.xxx, baseColor, metallic );
					oneMinusReflectivity = 1.0 - metallic;
					return baseColor * oneMinusReflectivity;
				}
				
				void TerrainApplyMeshModification( inout float3 position, inout half3 normal, inout float4 texcoord )
				{
				#ifdef UNITY_INSTANCING_ENABLED
					float2 patchVertex = position.xy;
					float4 instanceData = UNITY_ACCESS_INSTANCED_PROP( Terrain, _TerrainPatchInstanceData );
					float4 uvscale = instanceData.z * _TerrainHeightmapRecipSize;
					float4 uvoffset = instanceData.xyxy * uvscale;
					uvoffset.xy += 0.5f * _TerrainHeightmapRecipSize.xy;
					float2 sampleCoords = (patchVertex.xy * uvscale.xy + uvoffset.xy);
					texcoord.xyzw = float4(patchVertex.xy * uvscale.zw + uvoffset.zw, 0, 0);
					float height = UnpackHeightmap( tex2Dlod( _TerrainHeightmapTexture, float4(sampleCoords, 0, 0) ) );
					position.xz = (patchVertex.xy + instanceData.xy) * _TerrainHeightmapScale.xz * instanceData.z;
					position.y = height * _TerrainHeightmapScale.y;
					normal = tex2Dlod( _TerrainNormalmapTexture, texcoord.xyzw ).rgb * 2 - 1;
				#endif
				}
				

				v2f VertexFunction( appdata v  )
				{
					UNITY_SETUP_INSTANCE_ID(v);
					v2f o;
					UNITY_INITIALIZE_OUTPUT(v2f,o);
					UNITY_TRANSFER_INSTANCE_ID(v,o);
					UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

					#if defined( ASE_INSTANCED_TERRAIN ) && !defined( ASE_TESSELLATION )
						TerrainApplyMeshModification( v.vertex.xyz, v.normal, v.texcoord.xyzw );
					#endif
					
					float localCalculateTangentsStandard706_g23 = ( 0.0 );
					{
					v.tangent.xyz = cross ( v.normal, float3( 0, 0, 1 ) );
					v.tangent.w = -1;
					}
					float3 temp_output_707_0_g23 = ( localCalculateTangentsStandard706_g23 + v.normal );
					
					float4 appendResult704_g23 = (float4(cross( v.normal , float3( 0, 0, 1 ) ) , -1.0));
					
					float2 TecCoord01519_g23 = v.texcoord.xyzw.xy;
					float2 break1507_g23 = _Control_ST.zw;
					float2 appendResult1501_g23 = (float2(( break1507_g23.x + 0.001 ) , ( break1507_g23.y + 0.0001 )));
					float2 vertexToFrag1508_g23 = ( ( TecCoord01519_g23 * _Control_ST.xy ) + appendResult1501_g23 );
					o.ase_texcoord2.xy = vertexToFrag1508_g23;
					
					o.ase_texcoord2.zw = v.texcoord.xyzw.xy;

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
					v.normal = temp_output_707_0_g23;
					v.tangent = appendResult704_g23;

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
					#if defined( ASE_INSTANCED_TERRAIN )
						TerrainApplyMeshModification( o.vertex.xyz, o.normal, o.texcoord );
					#endif
					
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

					float2 vertexToFrag1508_g23 = IN.ase_texcoord2.xy;
					float4 tex2DNode1505_g23 = SAMPLE_TEXTURE2D( _Control, sampler_Control, vertexToFrag1508_g23 );
					float dotResult278_g23 = dot( tex2DNode1505_g23 , half4( 1, 1, 1, 1 ) );
					float localSplatClip276_g23 = ( dotResult278_g23 );
					float SplatWeight276_g23 = dotResult278_g23;
					{
					#if !defined(SHADER_API_MOBILE) && defined(TERRAIN_SPLAT_ADDPASS)
					clip(SplatWeight276_g23 == 0.0f ? -1 : 1);
					#endif
					}
					float4 Control26_g23 = ( tex2DNode1505_g23 / ( localSplatClip276_g23 + 0.001 ) );
					float2 TecCoord01519_g23 = IN.ase_texcoord2.zw;
					float2 temp_output_1607_0_g23 = ( ( TecCoord01519_g23 * _Splat0_ST.xy ) + _Splat0_ST.zw );
					float4 tex2DNode1539_g23 = SAMPLE_TEXTURE2D( _Splat0, sampler_Splat0, temp_output_1607_0_g23 );
					float3 Splat0342_g23 = (tex2DNode1539_g23).rgb;
					float2 temp_output_1563_0_g23 = ( ( TecCoord01519_g23 * _Splat1_ST.xy ) + _Splat1_ST.zw );
					float4 tex2DNode1547_g23 = SAMPLE_TEXTURE2D( _Splat1, sampler_Splat0, temp_output_1563_0_g23 );
					float3 Splat1379_g23 = (tex2DNode1547_g23).rgb;
					float2 temp_output_1575_0_g23 = ( ( TecCoord01519_g23 * _Splat2_ST.xy ) + _Splat2_ST.zw );
					float4 tex2DNode1565_g23 = SAMPLE_TEXTURE2D( _Splat2, sampler_Splat0, temp_output_1575_0_g23 );
					float3 Splat2357_g23 = (tex2DNode1565_g23).rgb;
					float2 temp_output_1595_0_g23 = ( ( TecCoord01519_g23 * _Splat3_ST.xy ) + _Splat3_ST.zw );
					float4 tex2DNode1587_g23 = SAMPLE_TEXTURE2D( _Splat3, sampler_Splat0, temp_output_1595_0_g23 );
					float3 Splat3390_g23 = (tex2DNode1587_g23).rgb;
					float4 weightedBlendVar1445_g23 = Control26_g23;
					float3 weightedBlend1445_g23 = ( weightedBlendVar1445_g23.x*( (_DiffuseRemapScale0).xyz * Splat0342_g23 ) + weightedBlendVar1445_g23.y*( (_DiffuseRemapScale1).xyz * Splat1379_g23 ) + weightedBlendVar1445_g23.z*( (_DiffuseRemapScale2).xyz * Splat2357_g23 ) + weightedBlendVar1445_g23.w*( (_DiffuseRemapScale3).xyz * Splat3390_g23 ) );
					float3 localClipHoles1474_g23 = ( weightedBlend1445_g23 );
					float2 uv_TerrainHolesTexture = IN.ase_texcoord2.zw * _TerrainHolesTexture_ST.xy + _TerrainHolesTexture_ST.zw;
					float Hole1474_g23 = SAMPLE_TEXTURE2D( _TerrainHolesTexture, sampler_TerrainHolesTexture, uv_TerrainHolesTexture ).r;
					{
					#ifdef _ALPHATEST_ON
					clip(Hole1474_g23 == 0.0005f? -1 : 1);
					#endif
					}
					float4 tex2DNode1616_g23 = SAMPLE_TEXTURE2D( _Mask0, sampler_Mask0, temp_output_1607_0_g23 );
					float Mask0R334_g23 = tex2DNode1616_g23.r;
					float4 tex2DNode1551_g23 = SAMPLE_TEXTURE2D( _Mask1, sampler_Mask0, temp_output_1563_0_g23 );
					float Mask1R370_g23 = tex2DNode1551_g23.r;
					float4 tex2DNode1632_g23 = SAMPLE_TEXTURE2D( _Mask2, sampler_Mask0, temp_output_1575_0_g23 );
					float Mask2R359_g23 = tex2DNode1632_g23.r;
					float4 tex2DNode1648_g23 = SAMPLE_TEXTURE2D( _Mask3, sampler_Mask0, temp_output_1595_0_g23 );
					float Mask3R388_g23 = tex2DNode1648_g23.r;
					float4 weightedBlendVar1370_g23 = Control26_g23;
					float weightedBlend1370_g23 = ( weightedBlendVar1370_g23.x*( _Metallic0 * Mask0R334_g23 ) + weightedBlendVar1370_g23.y*( _Metallic1 * Mask1R370_g23 ) + weightedBlendVar1370_g23.z*( _Metallic2 * Mask2R359_g23 ) + weightedBlendVar1370_g23.w*( _Metallic3 * Mask3R388_g23 ) );
					float3 specularColor1403_g23 = (0).xxx;
					float oneMinusReflectivity1403_g23 = 0;
					float3 diffuseColor1403_g23 = ASEComputeDiffuseAndFresnel0( localClipHoles1474_g23, weightedBlend1370_g23, specularColor1403_g23, oneMinusReflectivity1403_g23 );
					
					float Alpha1491_g23 = dotResult278_g23;
					
					float4 tex2DNode451_g23 = SAMPLE_TEXTURE2D( _TerrainHolesTexture, sampler_TerrainHolesTexture, uv_TerrainHolesTexture );
					

					o.Albedo = diffuseColor1403_g23;
					o.Normal = half3( 0, 0, 1 );
					o.Emission = half3( 0, 0, 0 );
					o.Alpha = ( 0.0001 + Alpha1491_g23 );
					half AlphaClipThreshold = ( 1.0 - tex2DNode451_g23 ).r;

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
				#define ASE_FRAGMENT_NORMAL 0
				#define ASE_RECEIVE_SHADOWS
				#pragma multi_compile _ LOD_FADE_CROSSFADE
				#define ASE_FOG
				#define ASE_TERRAIN
				#define _SPECULAR_SETUP 1
				#define _ALPHATEST_ON
				#define ASE_VERSION 19907
				#define ASE_USING_SAMPLING_MACROS 1

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

				#define ASE_NEEDS_VERT_NORMAL
				#define ASE_NEEDS_TEXTURE_COORDINATES0
				#define ASE_NEEDS_VERT_TEXTURE_COORDINATES0
				#define ASE_INSTANCED_TERRAIN
				#define ASE_NEEDS_VERT_POSITION
				#pragma multi_compile_instancing
				#pragma instancing_options assumeuniformscaling nomatrices nolightprobe nolightmap forwardadd
				#define TERRAIN_SPLAT_FIRSTPASS 1
				#define TERRAIN_STANDARD_SHADER
				#define _DEFERRED_CAPABLE_MATERIAL
				#pragma shader_feature_local _TERRAIN_4_LAYERS
				#pragma shader_feature_local _NORMALMAP
				#pragma shader_feature_local _MASKMAP
				#pragma editor_sync_compilation
				#if defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL) || (defined(SHADER_TARGET_SURFACE_ANALYSIS) && !defined(SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER))//ASE Sampler Macros
				#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex.Sample(samplerTex,coord)
				#else//ASE Sampling Macros
				#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex2D(tex,coord)
				#endif//ASE Sampling Macros
				


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

				UNITY_DECLARE_TEX2D_NOSAMPLER(_Control);
				uniform float4 _Control_ST;
				SamplerState sampler_Control;
				UNITY_DECLARE_TEX2D_NOSAMPLER(_TerrainHolesTexture);
				uniform float4 _TerrainHolesTexture_ST;
				SamplerState sampler_TerrainHolesTexture;
				#ifdef UNITY_INSTANCING_ENABLED//ASE Terrain Instancing
					sampler2D _TerrainHeightmapTexture;//ASE Terrain Instancing
					sampler2D _TerrainNormalmapTexture;//ASE Terrain Instancing
				#endif//ASE Terrain Instancing
				UNITY_INSTANCING_BUFFER_START( Terrain )//ASE Terrain Instancing
					UNITY_DEFINE_INSTANCED_PROP( float4, _TerrainPatchInstanceData )//ASE Terrain Instancing
				UNITY_INSTANCING_BUFFER_END( Terrain)//ASE Terrain Instancing
				CBUFFER_START( UnityTerrain)//ASE Terrain Instancing
					#ifdef UNITY_INSTANCING_ENABLED//ASE Terrain Instancing
						float4 _TerrainHeightmapRecipSize;//ASE Terrain Instancing
						float4 _TerrainHeightmapScale;//ASE Terrain Instancing
					#endif//ASE Terrain Instancing
				CBUFFER_END//ASE Terrain Instancing


				void TerrainApplyMeshModification( inout float3 position, inout half3 normal, inout float4 texcoord )
				{
				#ifdef UNITY_INSTANCING_ENABLED
					float2 patchVertex = position.xy;
					float4 instanceData = UNITY_ACCESS_INSTANCED_PROP( Terrain, _TerrainPatchInstanceData );
					float4 uvscale = instanceData.z * _TerrainHeightmapRecipSize;
					float4 uvoffset = instanceData.xyxy * uvscale;
					uvoffset.xy += 0.5f * _TerrainHeightmapRecipSize.xy;
					float2 sampleCoords = (patchVertex.xy * uvscale.xy + uvoffset.xy);
					texcoord.xyzw = float4(patchVertex.xy * uvscale.zw + uvoffset.zw, 0, 0);
					float height = UnpackHeightmap( tex2Dlod( _TerrainHeightmapTexture, float4(sampleCoords, 0, 0) ) );
					position.xz = (patchVertex.xy + instanceData.xy) * _TerrainHeightmapScale.xz * instanceData.z;
					position.y = height * _TerrainHeightmapScale.y;
					normal = tex2Dlod( _TerrainNormalmapTexture, texcoord.xyzw ).rgb * 2 - 1;
				#endif
				}
				

				v2f VertexFunction( appdata v  )
				{
					UNITY_SETUP_INSTANCE_ID(v);
					v2f o;
					UNITY_INITIALIZE_OUTPUT(v2f,o);
					UNITY_TRANSFER_INSTANCE_ID(v,o);
					UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

					#if defined( ASE_INSTANCED_TERRAIN ) && !defined( ASE_TESSELLATION )
						TerrainApplyMeshModification( v.vertex.xyz, v.normal, v.ase_texcoord );
					#endif
					
					float localCalculateTangentsStandard706_g23 = ( 0.0 );
					{
					v.tangent.xyz = cross ( v.normal, float3( 0, 0, 1 ) );
					v.tangent.w = -1;
					}
					float3 temp_output_707_0_g23 = ( localCalculateTangentsStandard706_g23 + v.normal );
					
					float4 appendResult704_g23 = (float4(cross( v.normal , float3( 0, 0, 1 ) ) , -1.0));
					
					float2 TecCoord01519_g23 = v.ase_texcoord.xy;
					float2 break1507_g23 = _Control_ST.zw;
					float2 appendResult1501_g23 = (float2(( break1507_g23.x + 0.001 ) , ( break1507_g23.y + 0.0001 )));
					float2 vertexToFrag1508_g23 = ( ( TecCoord01519_g23 * _Control_ST.xy ) + appendResult1501_g23 );
					o.ase_texcoord1.xy = vertexToFrag1508_g23;
					
					o.ase_texcoord1.zw = v.ase_texcoord.xy;

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
					v.normal = temp_output_707_0_g23;
					v.tangent = appendResult704_g23;

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
					#if defined( ASE_INSTANCED_TERRAIN )
						TerrainApplyMeshModification( o.vertex.xyz, o.normal, o.ase_texcoord );
					#endif
					
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

					float2 vertexToFrag1508_g23 = IN.ase_texcoord1.xy;
					float4 tex2DNode1505_g23 = SAMPLE_TEXTURE2D( _Control, sampler_Control, vertexToFrag1508_g23 );
					float dotResult278_g23 = dot( tex2DNode1505_g23 , half4( 1, 1, 1, 1 ) );
					float Alpha1491_g23 = dotResult278_g23;
					
					float2 uv_TerrainHolesTexture = IN.ase_texcoord1.zw * _TerrainHolesTexture_ST.xy + _TerrainHolesTexture_ST.zw;
					float4 tex2DNode451_g23 = SAMPLE_TEXTURE2D( _TerrainHolesTexture, sampler_TerrainHolesTexture, uv_TerrainHolesTexture );
					

					o.Normal = half3( 0, 0, 1 );

					o.Alpha = ( 0.0001 + Alpha1491_g23 );
					half AlphaClipThreshold = ( 1.0 - tex2DNode451_g23 ).r;
					half AlphaClipThresholdShadow = 0.5;

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
				#define ASE_FRAGMENT_NORMAL 0
				#define ASE_RECEIVE_SHADOWS
				#pragma multi_compile _ LOD_FADE_CROSSFADE
				#define ASE_FOG
				#define ASE_TERRAIN
				#define _SPECULAR_SETUP 1
				#define _ALPHATEST_ON
				#define ASE_VERSION 19907
				#define ASE_USING_SAMPLING_MACROS 1

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

				#define ASE_NEEDS_VERT_NORMAL
				#define ASE_NEEDS_TEXTURE_COORDINATES0
				#define ASE_NEEDS_VERT_TEXTURE_COORDINATES0
				#define ASE_INSTANCED_TERRAIN
				#define ASE_NEEDS_VERT_POSITION
				#pragma multi_compile_instancing
				#pragma instancing_options assumeuniformscaling nomatrices nolightprobe nolightmap forwardadd
				#define TERRAIN_SPLAT_FIRSTPASS 1
				#define TERRAIN_STANDARD_SHADER
				#define _DEFERRED_CAPABLE_MATERIAL
				#pragma shader_feature_local _TERRAIN_4_LAYERS
				#pragma shader_feature_local _NORMALMAP
				#pragma shader_feature_local _MASKMAP
				#pragma editor_sync_compilation
				#if defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL) || (defined(SHADER_TARGET_SURFACE_ANALYSIS) && !defined(SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER))//ASE Sampler Macros
				#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex.Sample(samplerTex,coord)
				#else//ASE Sampling Macros
				#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex2D(tex,coord)
				#endif//ASE Sampling Macros
				


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

				UNITY_DECLARE_TEX2D_NOSAMPLER(_Control);
				uniform float4 _Control_ST;
				SamplerState sampler_Control;
				UNITY_DECLARE_TEX2D_NOSAMPLER(_TerrainHolesTexture);
				uniform float4 _TerrainHolesTexture_ST;
				SamplerState sampler_TerrainHolesTexture;
				#ifdef UNITY_INSTANCING_ENABLED//ASE Terrain Instancing
					sampler2D _TerrainHeightmapTexture;//ASE Terrain Instancing
					sampler2D _TerrainNormalmapTexture;//ASE Terrain Instancing
				#endif//ASE Terrain Instancing
				UNITY_INSTANCING_BUFFER_START( Terrain )//ASE Terrain Instancing
					UNITY_DEFINE_INSTANCED_PROP( float4, _TerrainPatchInstanceData )//ASE Terrain Instancing
				UNITY_INSTANCING_BUFFER_END( Terrain)//ASE Terrain Instancing
				CBUFFER_START( UnityTerrain)//ASE Terrain Instancing
					#ifdef UNITY_INSTANCING_ENABLED//ASE Terrain Instancing
						float4 _TerrainHeightmapRecipSize;//ASE Terrain Instancing
						float4 _TerrainHeightmapScale;//ASE Terrain Instancing
					#endif//ASE Terrain Instancing
				CBUFFER_END//ASE Terrain Instancing


				void TerrainApplyMeshModification( inout float3 position, inout half3 normal, inout float4 texcoord )
				{
				#ifdef UNITY_INSTANCING_ENABLED
					float2 patchVertex = position.xy;
					float4 instanceData = UNITY_ACCESS_INSTANCED_PROP( Terrain, _TerrainPatchInstanceData );
					float4 uvscale = instanceData.z * _TerrainHeightmapRecipSize;
					float4 uvoffset = instanceData.xyxy * uvscale;
					uvoffset.xy += 0.5f * _TerrainHeightmapRecipSize.xy;
					float2 sampleCoords = (patchVertex.xy * uvscale.xy + uvoffset.xy);
					texcoord.xyzw = float4(patchVertex.xy * uvscale.zw + uvoffset.zw, 0, 0);
					float height = UnpackHeightmap( tex2Dlod( _TerrainHeightmapTexture, float4(sampleCoords, 0, 0) ) );
					position.xz = (patchVertex.xy + instanceData.xy) * _TerrainHeightmapScale.xz * instanceData.z;
					position.y = height * _TerrainHeightmapScale.y;
					normal = tex2Dlod( _TerrainNormalmapTexture, texcoord.xyzw ).rgb * 2 - 1;
				#endif
				}
				

				v2f VertexFunction( appdata v  )
				{
					UNITY_SETUP_INSTANCE_ID(v);
					v2f o;
					UNITY_INITIALIZE_OUTPUT(v2f,o);
					UNITY_TRANSFER_INSTANCE_ID(v,o);
					UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

					#if defined( ASE_INSTANCED_TERRAIN ) && !defined( ASE_TESSELLATION )
						TerrainApplyMeshModification( v.vertex.xyz, v.normal, v.ase_texcoord );
					#endif
					
					float localCalculateTangentsStandard706_g23 = ( 0.0 );
					{
					v.tangent.xyz = cross ( v.normal, float3( 0, 0, 1 ) );
					v.tangent.w = -1;
					}
					float3 temp_output_707_0_g23 = ( localCalculateTangentsStandard706_g23 + v.normal );
					
					float4 appendResult704_g23 = (float4(cross( v.normal , float3( 0, 0, 1 ) ) , -1.0));
					
					float2 TecCoord01519_g23 = v.ase_texcoord.xy;
					float2 break1507_g23 = _Control_ST.zw;
					float2 appendResult1501_g23 = (float2(( break1507_g23.x + 0.001 ) , ( break1507_g23.y + 0.0001 )));
					float2 vertexToFrag1508_g23 = ( ( TecCoord01519_g23 * _Control_ST.xy ) + appendResult1501_g23 );
					o.ase_texcoord2.xy = vertexToFrag1508_g23;
					
					o.ase_texcoord2.zw = v.ase_texcoord.xy;

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
					v.normal = temp_output_707_0_g23;
					v.tangent = appendResult704_g23;

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
					#if defined( ASE_INSTANCED_TERRAIN )
						TerrainApplyMeshModification( o.vertex.xyz, o.normal, o.ase_texcoord );
					#endif
					
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

					float2 vertexToFrag1508_g23 = IN.ase_texcoord2.xy;
					float4 tex2DNode1505_g23 = SAMPLE_TEXTURE2D( _Control, sampler_Control, vertexToFrag1508_g23 );
					float dotResult278_g23 = dot( tex2DNode1505_g23 , half4( 1, 1, 1, 1 ) );
					float Alpha1491_g23 = dotResult278_g23;
					
					float2 uv_TerrainHolesTexture = IN.ase_texcoord2.zw * _TerrainHolesTexture_ST.xy + _TerrainHolesTexture_ST.zw;
					float4 tex2DNode451_g23 = SAMPLE_TEXTURE2D( _TerrainHolesTexture, sampler_TerrainHolesTexture, uv_TerrainHolesTexture );
					

					half Alpha = ( 0.0001 + Alpha1491_g23 );
					half AlphaClipThreshold = ( 1.0 - tex2DNode451_g23 ).r;

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
			Tags { "LightMode"="Picking" }

			ZWrite On

			CGPROGRAM
				#define ASE_FRAGMENT_NORMAL 0
				#define ASE_RECEIVE_SHADOWS
				#pragma multi_compile _ LOD_FADE_CROSSFADE
				#define ASE_FOG
				#define ASE_TERRAIN
				#define _SPECULAR_SETUP 1
				#define _ALPHATEST_ON
				#define ASE_VERSION 19907
				#define ASE_USING_SAMPLING_MACROS 1

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

				#define ASE_NEEDS_VERT_NORMAL
				#define ASE_NEEDS_TEXTURE_COORDINATES0
				#define ASE_NEEDS_VERT_TEXTURE_COORDINATES0
				#define ASE_INSTANCED_TERRAIN
				#define ASE_NEEDS_VERT_POSITION
				#pragma multi_compile_instancing
				#pragma instancing_options assumeuniformscaling nomatrices nolightprobe nolightmap forwardadd
				#define TERRAIN_SPLAT_FIRSTPASS 1
				#define TERRAIN_STANDARD_SHADER
				#define _DEFERRED_CAPABLE_MATERIAL
				#pragma shader_feature_local _TERRAIN_4_LAYERS
				#pragma shader_feature_local _NORMALMAP
				#pragma shader_feature_local _MASKMAP
				#pragma editor_sync_compilation
				#if defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL) || (defined(SHADER_TARGET_SURFACE_ANALYSIS) && !defined(SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER))//ASE Sampler Macros
				#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex.Sample(samplerTex,coord)
				#else//ASE Sampling Macros
				#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex2D(tex,coord)
				#endif//ASE Sampling Macros
				


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

				UNITY_DECLARE_TEX2D_NOSAMPLER(_Control);
				uniform float4 _Control_ST;
				SamplerState sampler_Control;
				UNITY_DECLARE_TEX2D_NOSAMPLER(_TerrainHolesTexture);
				uniform float4 _TerrainHolesTexture_ST;
				SamplerState sampler_TerrainHolesTexture;
				#ifdef UNITY_INSTANCING_ENABLED//ASE Terrain Instancing
					sampler2D _TerrainHeightmapTexture;//ASE Terrain Instancing
					sampler2D _TerrainNormalmapTexture;//ASE Terrain Instancing
				#endif//ASE Terrain Instancing
				UNITY_INSTANCING_BUFFER_START( Terrain )//ASE Terrain Instancing
					UNITY_DEFINE_INSTANCED_PROP( float4, _TerrainPatchInstanceData )//ASE Terrain Instancing
				UNITY_INSTANCING_BUFFER_END( Terrain)//ASE Terrain Instancing
				CBUFFER_START( UnityTerrain)//ASE Terrain Instancing
					#ifdef UNITY_INSTANCING_ENABLED//ASE Terrain Instancing
						float4 _TerrainHeightmapRecipSize;//ASE Terrain Instancing
						float4 _TerrainHeightmapScale;//ASE Terrain Instancing
					#endif//ASE Terrain Instancing
				CBUFFER_END//ASE Terrain Instancing


				void TerrainApplyMeshModification( inout float3 position, inout half3 normal, inout float4 texcoord )
				{
				#ifdef UNITY_INSTANCING_ENABLED
					float2 patchVertex = position.xy;
					float4 instanceData = UNITY_ACCESS_INSTANCED_PROP( Terrain, _TerrainPatchInstanceData );
					float4 uvscale = instanceData.z * _TerrainHeightmapRecipSize;
					float4 uvoffset = instanceData.xyxy * uvscale;
					uvoffset.xy += 0.5f * _TerrainHeightmapRecipSize.xy;
					float2 sampleCoords = (patchVertex.xy * uvscale.xy + uvoffset.xy);
					texcoord.xyzw = float4(patchVertex.xy * uvscale.zw + uvoffset.zw, 0, 0);
					float height = UnpackHeightmap( tex2Dlod( _TerrainHeightmapTexture, float4(sampleCoords, 0, 0) ) );
					position.xz = (patchVertex.xy + instanceData.xy) * _TerrainHeightmapScale.xz * instanceData.z;
					position.y = height * _TerrainHeightmapScale.y;
					normal = tex2Dlod( _TerrainNormalmapTexture, texcoord.xyzw ).rgb * 2 - 1;
				#endif
				}
				

				v2f VertexFunction( appdata v  )
				{
					UNITY_SETUP_INSTANCE_ID(v);
					v2f o;
					UNITY_INITIALIZE_OUTPUT(v2f,o);
					UNITY_TRANSFER_INSTANCE_ID(v,o);
					UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

					#if defined( ASE_INSTANCED_TERRAIN ) && !defined( ASE_TESSELLATION )
						TerrainApplyMeshModification( v.vertex.xyz, v.normal, v.ase_texcoord );
					#endif
					
					float localCalculateTangentsStandard706_g23 = ( 0.0 );
					{
					v.tangent.xyz = cross ( v.normal, float3( 0, 0, 1 ) );
					v.tangent.w = -1;
					}
					float3 temp_output_707_0_g23 = ( localCalculateTangentsStandard706_g23 + v.normal );
					
					float4 appendResult704_g23 = (float4(cross( v.normal , float3( 0, 0, 1 ) ) , -1.0));
					
					float2 TecCoord01519_g23 = v.ase_texcoord.xy;
					float2 break1507_g23 = _Control_ST.zw;
					float2 appendResult1501_g23 = (float2(( break1507_g23.x + 0.001 ) , ( break1507_g23.y + 0.0001 )));
					float2 vertexToFrag1508_g23 = ( ( TecCoord01519_g23 * _Control_ST.xy ) + appendResult1501_g23 );
					o.ase_texcoord2.xy = vertexToFrag1508_g23;
					
					o.ase_texcoord2.zw = v.ase_texcoord.xy;

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
					v.normal = temp_output_707_0_g23;
					v.tangent = appendResult704_g23;

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
					#if defined( ASE_INSTANCED_TERRAIN )
						TerrainApplyMeshModification( o.vertex.xyz, o.normal, o.ase_texcoord );
					#endif
					
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

					float2 vertexToFrag1508_g23 = IN.ase_texcoord2.xy;
					float4 tex2DNode1505_g23 = SAMPLE_TEXTURE2D( _Control, sampler_Control, vertexToFrag1508_g23 );
					float dotResult278_g23 = dot( tex2DNode1505_g23 , half4( 1, 1, 1, 1 ) );
					float Alpha1491_g23 = dotResult278_g23;
					
					float2 uv_TerrainHolesTexture = IN.ase_texcoord2.zw * _TerrainHolesTexture_ST.xy + _TerrainHolesTexture_ST.zw;
					float4 tex2DNode451_g23 = SAMPLE_TEXTURE2D( _TerrainHolesTexture, sampler_TerrainHolesTexture, uv_TerrainHolesTexture );
					

					half Alpha = ( 0.0001 + Alpha1491_g23 );
					half AlphaClipThreshold = ( 1.0 - tex2DNode451_g23 ).r;

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
	
	Dependency "AddPassShader"="Hidden/AmplifyShaderPack/Terrain/Simple AddPass"
	Dependency "BaseMapShader"="Hidden/TerrainEngine/Splatmap/Specular-Base"
	Dependency "BaseMapGenShader"="Hidden/TerrainEngine/Splatmap/Diffuse-BaseGen"

	Fallback "Nature/Terrain/Diffuse"
}
/*ASEBEGIN
Version=19907
Node;AmplifyShaderEditor.StickyNoteNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;50;896,0;Inherit;False;421.8427;385.3923;BIRP First Pass;;0,0,0,1;***Additional Directives***$#Define TERRAIN_SPLAT_FIRSTPASS 1$#Define TERRAIN_STANDARD_SHADER$#Define _DEFERRED_CAPABLE_MATERIAL$#pragma shader_feature_local _TERRAIN_4_LAYERS$#pragma multi_compile_local __ _NORMALMAP$#pragma shader_feature_local _MASKMAP$#pragma editor_sync_compilation$$$*** Custom SubShader Tags ***$DisableBatching = False$IgnoreProjector = True$TerrainCompatible = True$SplatCount = 4$$MaskMapR = Metallic$MaskMapG = AO$MaskMapB = Height$MaskMapA = Smoothness$;0;0
Node;AmplifyShaderEditor.StickyNoteNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;106;896,400;Inherit;False;422.3334;190.6667;Dependencies;;0,0,0,1;AddPassShader$Hidden/AmplifyShaderPack/Terrain/Simple AddPass$$BaseMapShader$Hidden/TerrainEngine/Splatmap/Specular-Base$$BaseMapGenShader$Hidden/TerrainEngine/Splatmap/Diffuse-BaseGen;0;0
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;105;320,0;Inherit;False;Terrain 4 Layer;0;;23;a8a57459582f78d4ca5db58f601fb616;6,504,0,102,1,1481,1,1482,1,668,0,669,0;0;9;FLOAT3;0;FLOAT3;14;FLOAT3;1415;FLOAT;45;FLOAT;200;FLOAT;282;COLOR;1488;FLOAT3;709;FLOAT4;701
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;93;645.0565,40.11808;Float;False;False;-1;3;AmplifyShaderEditor.MaterialInspector;0;1;New Amplify Shader;ed95fe726fd7b4644bb42f4d1ddd2bcd;True;ExtraPrePass;0;0;ExtraPrePass;6;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;False;False;True;3;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;DisableBatching=False=DisableBatching;True;3;True;12;all;0;False;True;1;1;False;;0;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;False;True;1;LightMode=ForwardBase;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;95;645.0565,40.11808;Float;False;False;-1;3;AmplifyShaderEditor.MaterialInspector;0;1;New Amplify Shader;ed95fe726fd7b4644bb42f4d1ddd2bcd;True;ForwardAdd;0;2;ForwardAdd;0;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;False;False;True;3;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;DisableBatching=False=DisableBatching;True;3;True;12;all;0;False;True;4;1;False;;1;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;True;1;LightMode=ForwardAdd;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;96;645.0565,40.11808;Float;False;False;-1;3;AmplifyShaderEditor.MaterialInspector;0;1;New Amplify Shader;ed95fe726fd7b4644bb42f4d1ddd2bcd;True;Deferred;0;3;Deferred;0;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;False;False;True;3;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;DisableBatching=False=DisableBatching;True;3;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Deferred;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;97;645.0565,40.11808;Float;False;False;-1;3;AmplifyShaderEditor.MaterialInspector;0;1;New Amplify Shader;ed95fe726fd7b4644bb42f4d1ddd2bcd;True;Meta;0;4;Meta;0;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;False;False;True;3;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;DisableBatching=False=DisableBatching;True;3;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Meta;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;98;645.0565,40.11808;Float;False;False;-1;3;AmplifyShaderEditor.MaterialInspector;0;1;New Amplify Shader;ed95fe726fd7b4644bb42f4d1ddd2bcd;True;ShadowCaster;0;5;ShadowCaster;0;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;False;False;True;3;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;DisableBatching=False=DisableBatching;True;3;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;False;;True;3;False;;False;False;True;1;LightMode=ShadowCaster;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;99;645.0565,40.11808;Float;False;False;-1;3;AmplifyShaderEditor.MaterialInspector;0;1;New Amplify Shader;ed95fe726fd7b4644bb42f4d1ddd2bcd;True;SceneSelectionPass;0;6;SceneSelectionPass;0;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;False;False;True;3;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;DisableBatching=False=DisableBatching;True;3;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;False;;False;False;False;True;1;LightMode=SceneSelectionPass;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;100;645.0565,40.11808;Float;False;False;-1;3;AmplifyShaderEditor.MaterialInspector;0;1;New Amplify Shader;ed95fe726fd7b4644bb42f4d1ddd2bcd;True;ScenePickingPass;0;7;ScenePickingPass;0;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;False;False;True;3;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;DisableBatching=False=DisableBatching;True;3;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;False;;False;False;False;True;1;LightMode=Picking;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;94;640,0;Float;False;True;-1;3;AmplifyShaderEditor.MaterialInspector;0;12;AmplifyShaderPack/Terrain/Simple;ed95fe726fd7b4644bb42f4d1ddd2bcd;True;ForwardBase;0;1;ForwardBase;17;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;False;False;True;10;RenderType=Opaque=RenderType;Queue=Geometry=Queue=-100;DisableBatching=False=DisableBatching;TerrainCompatible=True;IgnoreProjector=True;SplatCount=4;MaskMapR=Metallic;MaskMapG=AO;MaskMapB=Height;MaskMapA=Smoothness;True;3;True;12;all;0;False;True;1;1;False;;0;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;8;LightMode=ForwardBase;TerrainCompatible=True;IgnoreProjector=True;SplatCount=4;MaskMapR=Metallic;MaskMapG=AO;MaskMapB=Height;MaskMapA=Smoothness;False;False;8;Include;;False;;Native;False;0;0;;Define;TERRAIN_SPLAT_FIRSTPASS 1;False;;Custom;False;0;0;;Define;TERRAIN_STANDARD_SHADER;False;;Custom;False;0;0;;Define;_DEFERRED_CAPABLE_MATERIAL;False;;Custom;False;0;0;;Pragma;shader_feature_local _TERRAIN_4_LAYERS;False;;Custom;False;0;0;;Pragma;shader_feature_local _NORMALMAP;False;;Custom;False;0;0;;Pragma;shader_feature_local _MASKMAP;False;;Custom;False;0;0;;Pragma;editor_sync_compilation;False;;Custom;False;0;0;;Nature/Terrain/Diffuse;3;AddPassShader=Hidden/AmplifyShaderPack/Terrain/Simple AddPass;BaseMapShader=Hidden/TerrainEngine/Splatmap/Specular-Base;BaseMapGenShader=Hidden/TerrainEngine/Splatmap/Diffuse-BaseGen;0;Standard;44;Category;1;638957214245189176;  Instanced Terrain Normals;2;638957214272628100;Workflow;0;638957214407034097;Surface;0;0;  Blend;0;0;  Dither Shadows;1;0;Two Sided;1;0;Alpha Clipping;1;638957214479543484;  Use Shadow Threshold;0;0;Deferred Pass;1;0;Normal Space;0;0;Transmission;0;0;  Transmission Shadow;0.5,True,_ASETransmissionShadow;0;Translucency;0;0;  Translucency Strength;1,True,_ASETranslucencyStrength;0;  Normal Distortion;0.5,True,_ASETranslucencyNormalDistortion;0;  Scattering;2,True,_ASETranslucencyScattering;0;  Direct;0.9,True,_ASETranslucencyDirect;0;  Ambient;0.1,True,_ASETranslucencyAmbient;0;  Shadow;0.5,True,_ASETransmissionShadow;0;Cast Shadows;1;0;Receive Shadows;1;0;Receive Specular;2;0;Receive Reflections;2;0;GPU Instancing;0;638957228243920039;LOD CrossFade;1;0;Built-in Fog;1;0;Ambient Light;1;0;Meta Pass;1;0;Add Pass;1;0;Override Baked GI;0;0;Write Depth;0;0;Extra Pre Pass;0;0;Tessellation;0;0;  Phong;0;0;  Strength;0.5,False,;0;  Type;0;0;  Tess;16,True,_TessellationStrength;0;  Min;10,True,_TessellationDistanceMin;0;  Max;25,True,_TessellationDistanceMax;0;  Edge Length;16,False,;0;  Max Displacement;25,False,;0;Disable Batching;0;0;Vertex Position;1;0;0;8;False;True;True;True;True;True;True;True;True;;True;0
WireConnection;94;0;105;0
WireConnection;94;1;105;14
WireConnection;94;3;105;1415
WireConnection;94;5;105;45
WireConnection;94;6;105;200
WireConnection;94;7;105;282
WireConnection;94;8;105;1488
WireConnection;94;16;105;709
WireConnection;94;17;105;701
ASEEND*/
//CHKSM=037D6DE8963B74B73712C990C720DBD6A297BFB1