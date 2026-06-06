// Made with Amplify Shader Editor v1.9.9.7
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader  "AmplifyShaderPack/Decal Parallax Mapping Normal"
{
	Properties
    {
        [HideInInspector] _EmissionColor("Emission Color", Color) = (1,1,1,1)
        _DecalOpacity( "Global Opacity", Range( 0, 1 ) ) = 0
        [Enum(Base Color Map Alpha,0,Mask Map Blue Channel,1)] _NormalOpacityChannel( "Normal Opacity Channel", Float ) = 0
        [Enum(Base Color Map Alpha,0,Mask Map Blue Channel,1)] _MaskOpacityChannel( "Mask Opacity Channel", Float ) = 0
        _DecalMaskMapBlueScale1( "Scale Mask Map Blue Channel", Range( 0, 1 ) ) = 0
        [Space(25)] _BaseColor( "MainColor", Color ) = ( 1, 1, 1, 0 )
        [SingleLineTexture] _BaseColorMap( "Base Color Map", 2D ) = "white" {}
        _Rotation( "Rotation", Float ) = 0
        _BaseColorMap_ST( "Main UVs", Vector ) = ( 1, 1, 0, 0 )
        _FlipbookID( "Flipbook ID", Float ) = 0
        _FlipbookSpeed( "Flipbook Speed", Float ) = 0
        _FlipbookColumns( "Flipbook Columns", Float ) = 1
        _FlipbookRows( "Flipbook Rows", Float ) = 1
        [Normal][SingleLineTexture][Space(15)] _NormalMap( "Normal Map", 2D ) = "bump" {}
        _NormalScale( "Normal Strength", Range( 0, 1 ) ) = 1
        [SingleLineTexture][Space(10)] _MaskMap( "Mask Map MAOS", 2D ) = "white" {}
        _MaskmapMetal( "Metallic", Range( 0, 1 ) ) = 0
        _MaskmapAO( "Ambient Occlusion", Range( 0, 1 ) ) = 0
        _MaskmapSmoothness( "Smoothness", Range( 0, 1 ) ) = 0
        [SingleLineTexture][Space(15)] _ParallaxMap( "Height Map", 2D ) = "white" {}
        [Toggle] _EnableHeight( "Enable Height", Float ) = 0
        _HeightScale( "Height Scale", Float ) = 0
        _HeightOffset( "Height Offset", Float ) = 0
        [Toggle][Space(15)] _EnableParallax( "Enable Parallax", Float ) = 0
        _ParallaxAmplitude( "Parallax Amplitude", Float ) = 1
        [Toggle][Space(15)] _AffectEmission( "Affect Emission", Float ) = 0
        [SingleLineTexture] _EmissiveColorMap( "Emissive Color Map", 2D ) = "white" {}
        [HDR] _EmissiveColor( "Emissive Color", Color ) = ( 0, 0, 0 )
        [Toggle] _AlbedoAffectEmissive( "Albedo Affect Emissive", Float ) = 0
        _EmissiveIntensity( "Emissive Intensity", Float ) = 1


        [HideInInspector] _DrawOrder("Draw Order", Range(-50, 50)) = 0
        [HideInInspector][Enum(Depth Bias, 0, View Bias, 1)] _DecalMeshBiasType("DecalMesh BiasType", Float) = 0

        [HideInInspector] _DecalMeshDepthBias("DecalMesh DepthBias", Float) = 0
        [HideInInspector] _DecalMeshViewBias("DecalMesh ViewBias", Float) = 0

        [HideInInspector][NoScaleOffset] unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset] unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset] unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}

        [HideInInspector] _DecalAngleFadeSupported("Decal Angle Fade Supported", Float) = 1
    }

    SubShader
    {
		LOD 0

		

		Tags { "RenderPipeline"="UniversalPipeline" "PreviewType"="Plane" "DisableBatching"="LODFading" "ShaderGraphShader"="true" "ShaderGraphTargetId"="UniversalDecalSubTarget" }

		HLSLINCLUDE
		#pragma target 3.5
		#pragma prefer_hlslcc gles
		// ensure rendering platforms toggle list is visible

		#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
		#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Filtering.hlsl"
		ENDHLSL

		
        Pass
        {
			
            Name "DBufferProjector"
            Tags { "LightMode"="DBufferProjector" }

			Cull Front
			Blend 0 SrcAlpha OneMinusSrcAlpha, Zero OneMinusSrcAlpha
			Blend 1 SrcAlpha OneMinusSrcAlpha, Zero OneMinusSrcAlpha
			Blend 2 SrcAlpha OneMinusSrcAlpha, Zero OneMinusSrcAlpha
			ZTest Greater
			ZWrite Off
			ColorMask RGBA
			ColorMask RGBA 1
			ColorMask RGBA 2

            HLSLPROGRAM

			#define _MATERIAL_AFFECTS_ALBEDO 1
			#define _MATERIAL_AFFECTS_NORMAL 1
			#define _MATERIAL_AFFECTS_NORMAL_BLEND 1
			#define DECAL_ANGLE_FADE 1
			#define  _MATERIAL_AFFECTS_MAOS 1
			#define _MATERIAL_AFFECTS_EMISSION 1
			#define ASE_VERSION 19907
			#define ASE_SRP_VERSION 170300
			#define ASE_USING_SAMPLING_MACROS 1


			#pragma vertex Vert
			#pragma fragment Frag

		    #pragma exclude_renderers glcore gles gles3 switch2 webgpu 
			#pragma multi_compile_instancing
			#pragma editor_sync_compilation

			#pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
			#pragma multi_compile _ _DECAL_LAYERS

            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            #define HAVE_MESH_MODIFICATION
            #define SHADERPASS SHADERPASS_DBUFFER_PROJECTOR

			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Fog.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
            #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ProbeVolumeVariants.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DecalInput.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderVariablesDecal.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"

			#if defined(LOD_FADE_CROSSFADE)
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
            #endif

            #if _RENDER_PASS_ENABLED
            #define GBUFFER3 0
            FRAMEBUFFER_INPUT_X_FLOAT(GBUFFER3);
            #define GBUFFER4 1
            FRAMEBUFFER_INPUT_X_UINT(GBUFFER4);
            #endif

			#define ASE_NEEDS_TEXTURE_COORDINATES0
			#define ASE_NEEDS_FRAG_TEXTURE_COORDINATES0
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_NEEDS_FRAG_WORLD_TANGENT
			#define ASE_NEEDS_FRAG_WORLD_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_BITANGENT
			#define ASE_NEEDS_FRAG_OBJECT_POSITION


			struct SurfaceDescription
			{
				float3 BaseColor;
				float Alpha;
				float3 NormalTS;
				float NormalAlpha;
				float Metallic;
				float Occlusion;
				float Smoothness;
				float MAOSAlpha;
			};

			struct Attributes
			{
				float3 positionOS : POSITION;
				float3 normalOS : NORMAL;
				float4 tangentOS : TANGENT;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct PackedVaryings
			{
				float4 positionCS : SV_POSITION;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

            CBUFFER_START(UnityPerMaterial)
			float4 _BaseColorMap_ST;
			float4 _BaseColor;
			float3 _EmissiveColor;
			float _Rotation;
			half _EmissiveIntensity;
			float _MaskOpacityChannel;
			half _MaskmapSmoothness;
			half _MaskmapAO;
			half _MaskmapMetal;
			float _DecalMaskMapBlueScale1;
			float _NormalOpacityChannel;
			float _NormalScale;
			float _HeightOffset;
			float _AlbedoAffectEmissive;
			float _HeightScale;
			half _DecalOpacity;
			float _EnableParallax;
			float _ParallaxAmplitude;
			half _FlipbookID;
			half _FlipbookSpeed;
			half _FlipbookRows;
			half _FlipbookColumns;
			float _EnableHeight;
			float _AffectEmission;
			float _DrawOrder;
			float _DecalMeshBiasType;
			float _DecalMeshDepthBias;
			float _DecalMeshViewBias;
			#if defined(DECAL_ANGLE_FADE)
			float _DecalAngleFadeSupported;
			#endif
			UNITY_TEXTURE_STREAMING_DEBUG_VARS;
			CBUFFER_END

            #ifdef SCENEPICKINGPASS
				float4 _SelectionID;
            #endif

            #ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
            #endif

			TEXTURE2D(_BaseColorMap);
			TEXTURE2D(_ParallaxMap);
			SAMPLER(sampler_ParallaxMap);
			SAMPLER(sampler_BaseColorMap);
			TEXTURE2D(_NormalMap);
			SAMPLER(sampler_NormalMap);
			TEXTURE2D(_MaskMap);


			float _SwitchNormalOpacity( float m_switch, float m_BaseColorMapAlpha, float m_MaskMapBlue )
			{
				if(m_switch ==0)
					return m_BaseColorMapAlpha;
				else if(m_switch ==1)
					return m_MaskMapBlue;
				else
				return float(0);
			}
			
			float _SwitchMaskOpacity( float m_switch, float m_BaseColorMapAlpha, float m_MaskMapBlue )
			{
				if(m_switch ==0)
					return m_BaseColorMapAlpha;
				else if(m_switch ==1)
					return m_MaskMapBlue;
				else
				return float(0);
			}
			

            void GetSurfaceData(SurfaceDescription surfaceDescription, float angleFadeFactor, out DecalSurfaceData surfaceData)
            {
                half4x4 normalToWorld = UNITY_ACCESS_INSTANCED_PROP(Decal, _NormalToWorld);
                half fadeFactor = clamp(normalToWorld[0][3], 0.0f, 1.0f) * angleFadeFactor;
                float2 scale = float2(normalToWorld[3][0], normalToWorld[3][1]);
                float2 offset = float2(normalToWorld[3][2], normalToWorld[3][3]);

                ZERO_INITIALIZE(DecalSurfaceData, surfaceData);
                surfaceData.occlusion = half(1.0);
                surfaceData.smoothness = half(0);

                #ifdef _MATERIAL_AFFECTS_NORMAL
                    surfaceData.normalWS.w = half(1.0);
                #else
                    surfaceData.normalWS.w = half(0.0);
                #endif

                surfaceData.baseColor.xyz = half3(surfaceDescription.BaseColor);
                surfaceData.baseColor.w = half(surfaceDescription.Alpha * fadeFactor);

                #if (SHADERPASS == SHADERPASS_DBUFFER_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_PROJECTOR)
                    #if defined(_MATERIAL_AFFECTS_NORMAL)
						surfaceData.normalWS.xyz = normalize(mul((half3x3)normalToWorld, surfaceDescription.NormalTS.xyz));
                    #else
						surfaceData.normalWS.xyz = normalize(normalToWorld[2].xyz);
                    #endif
                #elif (SHADERPASS == SHADERPASS_DBUFFER_MESH) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_MESH) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_MESH)
                    #if defined(_MATERIAL_AFFECTS_NORMAL)
                        float sgn = input.tangentWS.w;
                        float3 bitangent = sgn * cross(input.normalWS.xyz, input.tangentWS.xyz);
                        half3x3 tangentToWorld = half3x3(input.tangentWS.xyz, bitangent.xyz, input.normalWS.xyz);
                        surfaceData.normalWS.xyz = normalize(TransformTangentToWorld(surfaceDescription.NormalTS, tangentToWorld));
                    #else
						surfaceData.normalWS.xyz = normalize(half3(input.normalWS));
                    #endif
                #endif

                surfaceData.normalWS.w = surfaceDescription.NormalAlpha * fadeFactor;

				#if defined( _MATERIAL_AFFECTS_MAOS )
					surfaceData.metallic = half(surfaceDescription.Metallic);
					surfaceData.occlusion = half(surfaceDescription.Occlusion);
					surfaceData.smoothness = half(surfaceDescription.Smoothness);
					surfaceData.MAOSAlpha = half(surfaceDescription.MAOSAlpha * fadeFactor);
				#endif
            }

            #if (SHADERPASS == SHADERPASS_DBUFFER_PROJECTOR) || (SHADERPASS == SHADERPASS_FORWARD_EMISSIVE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_PROJECTOR)
            #define DECAL_PROJECTOR
            #endif

            #if (SHADERPASS == SHADERPASS_DBUFFER_MESH) || (SHADERPASS == SHADERPASS_FORWARD_EMISSIVE_MESH) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_MESH) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_MESH)
            #define DECAL_MESH
            #endif

            #if (SHADERPASS == SHADERPASS_DBUFFER_PROJECTOR) || (SHADERPASS == SHADERPASS_DBUFFER_MESH)
            #define DECAL_DBUFFER
            #endif

            #if (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_MESH)
            #define DECAL_SCREEN_SPACE
            #endif

            #if (SHADERPASS == SHADERPASS_DECAL_GBUFFER_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_MESH)
            #define DECAL_GBUFFER
            #endif

            #if (SHADERPASS == SHADERPASS_FORWARD_EMISSIVE_PROJECTOR) || (SHADERPASS == SHADERPASS_FORWARD_EMISSIVE_MESH)
            #define DECAL_FORWARD_EMISSIVE
            #endif

            #if ((!defined(_MATERIAL_AFFECTS_NORMAL) && defined(_MATERIAL_AFFECTS_ALBEDO)) || (defined(_MATERIAL_AFFECTS_NORMAL) && defined(_MATERIAL_AFFECTS_NORMAL_BLEND))) && (defined(DECAL_SCREEN_SPACE) || defined(DECAL_GBUFFER))
            #define DECAL_RECONSTRUCT_NORMAL
            #elif defined(DECAL_ANGLE_FADE)
            #define DECAL_LOAD_NORMAL
            #endif

            #ifdef _DECAL_LAYERS
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DeclareRenderingLayerTexture.hlsl"
            #endif

            #if defined(DECAL_LOAD_NORMAL)
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DeclareNormalsTexture.hlsl"
            #endif

            #if defined(DECAL_PROJECTOR) || defined(DECAL_RECONSTRUCT_NORMAL)
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DeclareDepthTexture.hlsl"
            #endif

            #ifdef DECAL_MESH
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DecalMeshBiasTypeEnum.cs.hlsl"
            #endif

            #ifdef DECAL_RECONSTRUCT_NORMAL
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/NormalReconstruction.hlsl"
            #endif

			PackedVaryings Vert(Attributes inputMesh  )
			{
				PackedVaryings packedOutput;
				ZERO_INITIALIZE(PackedVaryings, packedOutput);

				UNITY_SETUP_INSTANCE_ID(inputMesh);
				UNITY_TRANSFER_INSTANCE_ID(inputMesh, packedOutput);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(packedOutput);

				inputMesh.tangentOS = float4( 1, 0, 0, -1 );
				inputMesh.normalOS = float3( 0, 1, 0 );

				packedOutput.ase_texcoord.xy = inputMesh.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				packedOutput.ase_texcoord.zw = 0;

				VertexPositionInputs vertexInput = GetVertexPositionInputs(inputMesh.positionOS.xyz);

				float3 positionWS = TransformObjectToWorld(inputMesh.positionOS);
				packedOutput.positionCS = TransformWorldToHClip(positionWS);

				return packedOutput;
			}

			void Frag(PackedVaryings packedInput,
				OUTPUT_DBUFFER(outDBuffer)
				
			)
			{
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(packedInput);
				UNITY_SETUP_INSTANCE_ID(packedInput);

				half angleFadeFactor = 1.0;

            // Only screen space needs flip logic, other passes do not setup needed properties so we skip here
            #if defined(DECAL_SCREEN_SPACE)
				TransformScreenUV(packedInput.positionCS, _ScreenSize.y);
            #endif

            #ifdef _DECAL_LAYERS
            #ifdef _RENDER_PASS_ENABLED
				uint surfaceRenderingLayer = LOAD_FRAMEBUFFER_X_INPUT(GBUFFER4, packedInput.positionCS.xy).r;
            #else
				uint surfaceRenderingLayer = LoadSceneRenderingLayer(packedInput.positionCS.xy);
            #endif
				uint projectorRenderingLayer = asuint(UNITY_ACCESS_INSTANCED_PROP(Decal, _DecalLayerMaskFromDecal));
				clip((surfaceRenderingLayer & projectorRenderingLayer) - 0.1);
            #endif

			#if defined(DECAL_PROJECTOR)
			#if UNITY_REVERSED_Z
			#if _RENDER_PASS_ENABLED
				float depth = LOAD_FRAMEBUFFER_X_INPUT(GBUFFER3, packedInput.positionCS.xy).x;
			#else
				float depth = LoadSceneDepth(packedInput.positionCS.xy);
			#endif
			#else
			#if _RENDER_PASS_ENABLED
				float depth = lerp(UNITY_NEAR_CLIP_VALUE, 1, LOAD_FRAMEBUFFER_X_INPUT(GBUFFER3, packedInput.positionCS.xy));
			#else
			    // Adjust z to match NDC for OpenGL
				float depth = lerp(UNITY_NEAR_CLIP_VALUE, 1, LoadSceneDepth(packedInput.positionCS.xy));
			#endif
			#endif
			#endif

			#if defined(DECAL_RECONSTRUCT_NORMAL)
				#if defined(_RENDER_PASS_ENABLED)
					half3 normalWS = half3(ReconstructNormalDerivative(packedInput.positionCS.xy, LOAD_FRAMEBUFFER_X_INPUT(GBUFFER3, packedInput.positionCS.xy).x));
				#elif defined(_DECAL_NORMAL_BLEND_HIGH)
					half3 normalWS = half3(ReconstructNormalTap9(packedInput.positionCS.xy));
				#elif defined(_DECAL_NORMAL_BLEND_MEDIUM)
					half3 normalWS = half3(ReconstructNormalTap5(packedInput.positionCS.xy));
				#else
					half3 normalWS = half3(ReconstructNormalDerivative(packedInput.positionCS.xy));
				#endif
			#elif defined(DECAL_LOAD_NORMAL)
				#if defined(_RENDER_PASS_ENABLED)
				half3 normalWS = normalize(LOAD_FRAMEBUFFER_X_INPUT(GBUFFER2, packedInput.positionCS.xy).rgb);
				#else
				half3 normalWS = normalize(LoadSceneNormals(packedInput.positionCS.xy).rgb);
				#endif
			#endif

				float2 positionSS = FoveatedRemapNonUniformToLinearCS(packedInput.positionCS.xy) * _ScreenSize.zw;

				float4 positionCS = ComputeClipSpacePosition( positionSS, depth );
				float4 hpositionVS = mul( UNITY_MATRIX_I_P, positionCS );

				float4 ScreenPosNorm = float4( positionSS, positionCS.zw );
				float4 ClipPos = positionCS * packedInput.positionCS.w;
				float4 ScreenPos = ComputeScreenPos( ClipPos );
				float3 PositionRWS = mul( ( float3x3 )UNITY_MATRIX_I_V, hpositionVS.xyz / hpositionVS.w );
				float3 PositionWS = PositionRWS + _WorldSpaceCameraPos;
				float3 PositionOS = TransformWorldToObject( PositionWS );
				float3 PositionVS = TransformWorldToView( PositionWS );

				float3 positionDS = TransformWorldToObject(PositionWS);
				positionDS = positionDS * float3(1.0, -1.0, 1.0);

				float clipValue = 0.5 - Max3(abs(positionDS).x, abs(positionDS).y, abs(positionDS).z);
				clip(clipValue);

				float2 texCoord = positionDS.xz + float2(0.5, 0.5);

				float4x4 normalToWorld = UNITY_ACCESS_INSTANCED_PROP(Decal, _NormalToWorld);
				float2 scale = float2(normalToWorld[3][0], normalToWorld[3][1]);
				float2 offset = float2(normalToWorld[3][2], normalToWorld[3][3]);
				texCoord.xy = texCoord.xy * scale + offset;

				float2 texCoord0 = texCoord;
				float2 texCoord1 = texCoord;
				float2 texCoord2 = texCoord;
				float2 texCoord3 = texCoord;

				float3 worldTangent = TransformObjectToWorldDir(float3(1, 0, 0));
				float3 worldNormal = TransformObjectToWorldDir(float3(0, 1, 0));
				float3 worldBitangent = TransformObjectToWorldDir(float3(0, 0, 1));

			#ifdef DECAL_ANGLE_FADE
				half2 angleFade = half2(normalToWorld[1][3], normalToWorld[2][3]);

				if (angleFade.y < 0.0f)
				{
					half3 decalNormal = half3(normalToWorld[0].z, normalToWorld[1].z, normalToWorld[2].z);
					half dotAngle = dot(normalWS, decalNormal);
					angleFadeFactor = saturate(angleFade.x + angleFade.y * (dotAngle * (dotAngle - 2.0)));
				}
			#endif

				half3 viewDirectionWS = half3(1.0, 1.0, 1.0);
				DecalSurfaceData surfaceData;

				SurfaceDescription surfaceDescription = (SurfaceDescription)0;

				float temp_output_1307_0 = radians( _Rotation );
				float temp_output_1301_0 = cos( temp_output_1307_0 );
				float2 break1305 = ( texCoord0 - float2( 0.5,0.5 ) );
				float temp_output_1300_0 = sin( temp_output_1307_0 );
				float2 appendResult1295 = (float2(( ( temp_output_1301_0 * break1305.x ) + ( temp_output_1300_0 * break1305.y ) ) , ( ( temp_output_1301_0 * break1305.y ) - ( temp_output_1300_0 * break1305.x ) )));
				float2 temp_output_1353_0 = (_BaseColorMap_ST).xy;
				float2 _Vector0 = float2(0.5,0.5);
				// *** BEGIN Flipbook UV Animation vars ***
				// Total tiles of Flipbook Texture
				float fbtotaltiles1358 = min( _FlipbookColumns * _FlipbookRows, 9.0 + 1 );
				// Offsets for cols and rows of Flipbook Texture
				float fbcolsoffset1358 = 1.0f / _FlipbookColumns;
				float fbrowsoffset1358 = 1.0f / _FlipbookRows;
				// Speed of animation
				float fbspeed1358 = _Time[ 1 ] * _FlipbookSpeed;
				// UV Tiling (col and row offset)
				float2 fbtiling1358 = float2(fbcolsoffset1358, fbrowsoffset1358);
				// UV Offset - calculate current tile linear index, and convert it to (X * coloffset, Y * rowoffset)
				// Calculate current tile linear index
				float fbcurrenttileindex1358 = floor( fmod( fbspeed1358 + _FlipbookID, fbtotaltiles1358) );
				fbcurrenttileindex1358 += ( fbcurrenttileindex1358 < 0) ? fbtotaltiles1358 : 0;
				// Obtain Offset X coordinate from current tile linear index
				float fblinearindextox1358 = round ( fmod ( fbcurrenttileindex1358, _FlipbookColumns ) );
				// Reverse X animation if speed is negative
				fblinearindextox1358 = (_FlipbookSpeed > 0 ? fblinearindextox1358 : (int)_FlipbookColumns - fblinearindextox1358);
				// Multiply Offset X by coloffset
				float fboffsetx1358 = fblinearindextox1358 * fbcolsoffset1358;
				// Obtain Offset Y coordinate from current tile linear index
				float fblinearindextoy1358 = round( fmod( ( fbcurrenttileindex1358 - fblinearindextox1358 ) / _FlipbookColumns, _FlipbookRows ) );
				// Reverse Y to get tiles from Top to Bottom and Reverse Y animation if speed is negative
				fblinearindextoy1358 = (_FlipbookSpeed <  0 ? fblinearindextoy1358 : (int)_FlipbookRows - fblinearindextoy1358);
				// Multiply Offset Y by rowoffset
				float fboffsety1358 = fblinearindextoy1358 * fbrowsoffset1358;
				// UV Offset
				float2 fboffset1358 = float2(fboffsetx1358, fboffsety1358);
				// Flipbook UV
				float2 fbuv1358 = ( ( ( ( appendResult1295 * temp_output_1353_0 ) + float2( 0.5,0.5 ) ) + (_BaseColorMap_ST).zw ) - ( ( ( temp_output_1353_0 / 1.0 ) * _Vector0 ) - _Vector0 ) ) * fbtiling1358 + fboffset1358;
				// *** END Flipbook UV Animation vars ***
				int flipbookFrame1358 = ( ( int )fbcurrenttileindex1358);
				float2 temp_output_1490_0 = ddx( fbuv1358 );
				float2 temp_output_1491_0 = ddy( fbuv1358 );
				float temp_output_410_0 = ( _ParallaxAmplitude * 0.001 );
				float3 tanToWorld0 = float3( worldTangent.x, worldBitangent.x, worldNormal.x );
				float3 tanToWorld1 = float3( worldTangent.y, worldBitangent.y, worldNormal.y );
				float3 tanToWorld2 = float3( worldTangent.z, worldBitangent.z, worldNormal.z );
				float3 ase_viewVectorTS =  tanToWorld0 * ( _WorldSpaceCameraPos.xyz - PositionWS ).x + tanToWorld1 * ( _WorldSpaceCameraPos.xyz - PositionWS ).y  + tanToWorld2 * ( _WorldSpaceCameraPos.xyz - PositionWS ).z;
				float2 Offset1512 = ( ( SAMPLE_TEXTURE2D_GRAD( _ParallaxMap, sampler_ParallaxMap, fbuv1358, temp_output_1490_0, temp_output_1491_0 ).r - 1 ) * ase_viewVectorTS.xy * temp_output_410_0 ) + fbuv1358;
				float2 Offset1554 = ( ( SAMPLE_TEXTURE2D_GRAD( _ParallaxMap, sampler_ParallaxMap, fbuv1358, temp_output_1490_0, temp_output_1491_0 ).r - 1 ) * ase_viewVectorTS.xy * temp_output_410_0 ) + Offset1512;
				float2 Offset1605 = ( ( SAMPLE_TEXTURE2D_GRAD( _ParallaxMap, sampler_ParallaxMap, fbuv1358, temp_output_1490_0, temp_output_1491_0 ).r - 1 ) * ase_viewVectorTS.xy * temp_output_410_0 ) + Offset1554;
				float2 Offset1606 = ( ( SAMPLE_TEXTURE2D_GRAD( _ParallaxMap, sampler_ParallaxMap, fbuv1358, temp_output_1490_0, temp_output_1491_0 ).r - 1 ) * ase_viewVectorTS.xy * temp_output_410_0 ) + Offset1605;
				float2 lerpResult1376 = lerp( fbuv1358 , Offset1606 , _EnableParallax);
				float2 UV1050 = lerpResult1376;
				float2 UV_DDX1265 = temp_output_1490_0;
				float2 UV_DDY1266 = temp_output_1491_0;
				float4 tex2DNode445 = SAMPLE_TEXTURE2D_GRAD( _BaseColorMap, sampler_BaseColorMap, UV1050, UV_DDX1265, UV_DDY1266 );
				float3 BaseColor554 = ( (tex2DNode445).rgb * (_BaseColor).rgb );
				
				float BaseColorMap_Alpha631 = tex2DNode445.a;
				float temp_output_523_0 = ( BaseColorMap_Alpha631 * ( 1.0 - _DecalOpacity ) );
				float3 temp_output_702_0 = ( PositionOS + float3( 0.5,0.5,0.5 ) );
				float temp_output_698_0 = saturate( ( ( _HeightScale * ( temp_output_702_0 * ( 1.0 - temp_output_702_0 ) ).y ) + _HeightOffset ) );
				float smoothstepResult705 = smoothstep( temp_output_698_0 , ( temp_output_698_0 + 0.001 ) , ( SAMPLE_TEXTURE2D_GRAD( _ParallaxMap, sampler_ParallaxMap, UV1050, UV_DDX1265, UV_DDY1266 ).r * SAMPLE_TEXTURE2D_GRAD( _ParallaxMap, sampler_ParallaxMap, UV1050, UV_DDX1265, UV_DDY1266 ).r ));
				float Height746 = smoothstepResult705;
				float lerpResult1383 = lerp( temp_output_523_0 , ( temp_output_523_0 * Height746 ) , _EnableHeight);
				float Alpha635 = lerpResult1383;
				
				float3 unpack444 = UnpackNormalScale( SAMPLE_TEXTURE2D_GRAD( _NormalMap, sampler_NormalMap, UV1050, UV_DDX1265, UV_DDY1266 ), _NormalScale );
				unpack444.z = lerp( 1, unpack444.z, saturate(_NormalScale) );
				float3 Normal556 = unpack444;
				
				float m_switch857 = _NormalOpacityChannel;
				float m_BaseColorMapAlpha857 = temp_output_523_0;
				float4 tex2DNode607 = SAMPLE_TEXTURE2D_GRAD( _MaskMap, sampler_BaseColorMap, UV1050, UV_DDX1265, UV_DDY1266 );
				float Opacity_Mask632 = tex2DNode607.b;
				float m_MaskMapBlue857 = ( _DecalMaskMapBlueScale1 * Opacity_Mask632 );
				float local_SwitchNormalOpacity857 = _SwitchNormalOpacity( m_switch857 , m_BaseColorMapAlpha857 , m_MaskMapBlue857 );
				float lerpResult1382 = lerp( local_SwitchNormalOpacity857 , ( local_SwitchNormalOpacity857 * Height746 ) , _EnableHeight);
				float Alpha_Normal636 = lerpResult1382;
				
				float Metallic624 = ( _MaskmapMetal * tex2DNode607.r );
				
				float Occlusion626 = saturate( ( ( 1.0 - _MaskmapAO ) * tex2DNode607.g ) );
				
				float Smoothness625 = ( _MaskmapSmoothness * tex2DNode607.a );
				
				float m_switch858 = _MaskOpacityChannel;
				float m_BaseColorMapAlpha858 = temp_output_523_0;
				float m_MaskMapBlue858 = ( _DecalMaskMapBlueScale1 * Opacity_Mask632 );
				float local_SwitchMaskOpacity858 = _SwitchMaskOpacity( m_switch858 , m_BaseColorMapAlpha858 , m_MaskMapBlue858 );
				float lerpResult1381 = lerp( local_SwitchMaskOpacity858 , ( local_SwitchMaskOpacity858 * Height746 ) , _EnableHeight);
				float Alpha_MSO637 = lerpResult1381;
				

				surfaceDescription.BaseColor = BaseColor554;
				surfaceDescription.Alpha = Alpha635;
				surfaceDescription.NormalTS = Normal556;
				surfaceDescription.NormalAlpha = Alpha_Normal636;

			#if defined( _MATERIAL_AFFECTS_MAOS )
				surfaceDescription.Metallic = Metallic624;
				surfaceDescription.Occlusion = Occlusion626;
				surfaceDescription.Smoothness =Smoothness625;
				surfaceDescription.MAOSAlpha = Alpha_MSO637;
			#endif

				GetSurfaceData(surfaceDescription, angleFadeFactor, surfaceData);
				ENCODE_INTO_DBUFFER(surfaceData, outDBuffer);

			}
            ENDHLSL
        }

		
        Pass
        {
			
            Name "DecalProjectorForwardEmissive"
            Tags { "LightMode"="DecalProjectorForwardEmissive" }

			Cull Front
			Blend 0 SrcAlpha One
			ZTest Greater
			ZWrite Off

			HLSLPROGRAM

			#define _MATERIAL_AFFECTS_ALBEDO 1
			#define _MATERIAL_AFFECTS_NORMAL 1
			#define _MATERIAL_AFFECTS_NORMAL_BLEND 1
			#define DECAL_ANGLE_FADE 1
			#define  _MATERIAL_AFFECTS_MAOS 1
			#define _MATERIAL_AFFECTS_EMISSION 1
			#define USE_UNITY_CROSSFADE 1
			#pragma multi_compile_fragment _ LOD_FADE_CROSSFADE
			#define ASE_VERSION 19907
			#define ASE_SRP_VERSION 170300
			#define ASE_USING_SAMPLING_MACROS 1


			#pragma vertex Vert
			#pragma fragment Frag
			#pragma multi_compile_instancing
			#pragma editor_sync_compilation

			#pragma multi_compile _ _DECAL_LAYERS

            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            #define HAVE_MESH_MODIFICATION

            #define SHADERPASS SHADERPASS_FORWARD_EMISSIVE_PROJECTOR

			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Fog.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
            #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ProbeVolumeVariants.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DecalInput.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderVariablesDecal.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"

		    #if defined(LOD_FADE_CROSSFADE)
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
            #endif

            #if _RENDER_PASS_ENABLED
            #define GBUFFER3 0
            FRAMEBUFFER_INPUT_X_FLOAT(GBUFFER3);
            #define GBUFFER4 1
            FRAMEBUFFER_INPUT_X_UINT(GBUFFER4);
            #endif

			#define ASE_NEEDS_TEXTURE_COORDINATES0
			#define ASE_NEEDS_FRAG_TEXTURE_COORDINATES0
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_NEEDS_FRAG_WORLD_TANGENT
			#define ASE_NEEDS_FRAG_WORLD_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_BITANGENT
			#define ASE_NEEDS_FRAG_OBJECT_POSITION


			struct SurfaceDescription
			{
				float Alpha;
				float3 Emission;
			};

			struct Attributes
			{
				float3 positionOS : POSITION;
				float3 normalOS : NORMAL;
				float4 tangentOS : TANGENT;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct PackedVaryings
			{
				float4 positionCS : SV_POSITION;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

            CBUFFER_START(UnityPerMaterial)
			float4 _BaseColorMap_ST;
			float4 _BaseColor;
			float3 _EmissiveColor;
			float _Rotation;
			half _EmissiveIntensity;
			float _MaskOpacityChannel;
			half _MaskmapSmoothness;
			half _MaskmapAO;
			half _MaskmapMetal;
			float _DecalMaskMapBlueScale1;
			float _NormalOpacityChannel;
			float _NormalScale;
			float _HeightOffset;
			float _AlbedoAffectEmissive;
			float _HeightScale;
			half _DecalOpacity;
			float _EnableParallax;
			float _ParallaxAmplitude;
			half _FlipbookID;
			half _FlipbookSpeed;
			half _FlipbookRows;
			half _FlipbookColumns;
			float _EnableHeight;
			float _AffectEmission;
			float _DrawOrder;
			float _DecalMeshBiasType;
			float _DecalMeshDepthBias;
			float _DecalMeshViewBias;
			#if defined(DECAL_ANGLE_FADE)
			float _DecalAngleFadeSupported;
			#endif
			UNITY_TEXTURE_STREAMING_DEBUG_VARS;
			CBUFFER_END

            #ifdef SCENEPICKINGPASS
				float4 _SelectionID;
            #endif

            #ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			TEXTURE2D(_BaseColorMap);
			TEXTURE2D(_ParallaxMap);
			SAMPLER(sampler_ParallaxMap);
			SAMPLER(sampler_BaseColorMap);
			TEXTURE2D(_EmissiveColorMap);
			SAMPLER(sampler_EmissiveColorMap);


			
            void GetSurfaceData(SurfaceDescription surfaceDescription, float angleFadeFactor, out DecalSurfaceData surfaceData)
            {
                half4x4 normalToWorld = UNITY_ACCESS_INSTANCED_PROP(Decal, _NormalToWorld);
                half fadeFactor = clamp(normalToWorld[0][3], 0.0f, 1.0f) * angleFadeFactor;
                float2 scale = float2(normalToWorld[3][0], normalToWorld[3][1]);
                float2 offset = float2(normalToWorld[3][2], normalToWorld[3][3]);

                ZERO_INITIALIZE(DecalSurfaceData, surfaceData);
                surfaceData.occlusion = half(1.0);
                surfaceData.smoothness = half(0);

                #ifdef _MATERIAL_AFFECTS_NORMAL
                    surfaceData.normalWS.w = half(1.0);
                #else
                    surfaceData.normalWS.w = half(0.0);
                #endif

				#if defined( _MATERIAL_AFFECTS_EMISSION )
                	surfaceData.emissive.rgb = half3(surfaceDescription.Emission.rgb * fadeFactor);
				#endif

                surfaceData.baseColor.w = half(surfaceDescription.Alpha * fadeFactor);
            }

            #if (SHADERPASS == SHADERPASS_DBUFFER_PROJECTOR) || (SHADERPASS == SHADERPASS_FORWARD_EMISSIVE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_PROJECTOR)
            #define DECAL_PROJECTOR
            #endif

            #if (SHADERPASS == SHADERPASS_DBUFFER_MESH) || (SHADERPASS == SHADERPASS_FORWARD_EMISSIVE_MESH) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_MESH) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_MESH)
            #define DECAL_MESH
            #endif

            #if (SHADERPASS == SHADERPASS_DBUFFER_PROJECTOR) || (SHADERPASS == SHADERPASS_DBUFFER_MESH)
            #define DECAL_DBUFFER
            #endif

            #if (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_MESH)
            #define DECAL_SCREEN_SPACE
            #endif

            #if (SHADERPASS == SHADERPASS_DECAL_GBUFFER_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_MESH)
            #define DECAL_GBUFFER
            #endif

            #if (SHADERPASS == SHADERPASS_FORWARD_EMISSIVE_PROJECTOR) || (SHADERPASS == SHADERPASS_FORWARD_EMISSIVE_MESH)
            #define DECAL_FORWARD_EMISSIVE
            #endif

            #if ((!defined(_MATERIAL_AFFECTS_NORMAL) && defined(_MATERIAL_AFFECTS_ALBEDO)) || (defined(_MATERIAL_AFFECTS_NORMAL) && defined(_MATERIAL_AFFECTS_NORMAL_BLEND))) && (defined(DECAL_SCREEN_SPACE) || defined(DECAL_GBUFFER))
            #define DECAL_RECONSTRUCT_NORMAL
            #elif defined(DECAL_ANGLE_FADE)
            #define DECAL_LOAD_NORMAL
            #endif

            #ifdef _DECAL_LAYERS
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DeclareRenderingLayerTexture.hlsl"
            #endif

            #if defined(DECAL_LOAD_NORMAL)
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DeclareNormalsTexture.hlsl"
            #endif

            #if defined(DECAL_PROJECTOR) || defined(DECAL_RECONSTRUCT_NORMAL)
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DeclareDepthTexture.hlsl"
            #endif

            #ifdef DECAL_MESH
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DecalMeshBiasTypeEnum.cs.hlsl"
            #endif

            #ifdef DECAL_RECONSTRUCT_NORMAL
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/NormalReconstruction.hlsl"
            #endif

			PackedVaryings Vert(Attributes inputMesh  )
			{
				PackedVaryings packedOutput;
				ZERO_INITIALIZE(PackedVaryings, packedOutput);

				UNITY_SETUP_INSTANCE_ID(inputMesh);
				UNITY_TRANSFER_INSTANCE_ID(inputMesh, packedOutput);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(packedOutput);

				inputMesh.tangentOS = float4( 1, 0, 0, -1 );
				inputMesh.normalOS = float3( 0, 1, 0 );

				packedOutput.ase_texcoord.xy = inputMesh.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				packedOutput.ase_texcoord.zw = 0;

				VertexPositionInputs vertexInput = GetVertexPositionInputs(inputMesh.positionOS.xyz);
				float3 positionWS = TransformObjectToWorld(inputMesh.positionOS);
				packedOutput.positionCS = TransformWorldToHClip(positionWS);

				return packedOutput;
			}

			void Frag(PackedVaryings packedInput,
				out half4 outEmissive : SV_Target0
				
			)
			{
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(packedInput);
				UNITY_SETUP_INSTANCE_ID(packedInput);

				half angleFadeFactor = 1.0;

            // Only screen space needs flip logic, other passes do not setup needed properties so we skip here
            #if defined(DECAL_SCREEN_SPACE)
				TransformScreenUV(packedInput.positionCS, _ScreenSize.y);
            #endif

            #ifdef _DECAL_LAYERS
            #ifdef _RENDER_PASS_ENABLED
				uint surfaceRenderingLayer = LOAD_FRAMEBUFFER_X_INPUT(GBUFFER4, packedInput.positionCS.xy).r;
            #else
				uint surfaceRenderingLayer = LoadSceneRenderingLayer(packedInput.positionCS.xy);
            #endif
				uint projectorRenderingLayer = asuint(UNITY_ACCESS_INSTANCED_PROP(Decal, _DecalLayerMaskFromDecal));
				clip((surfaceRenderingLayer & projectorRenderingLayer) - 0.1);
            #endif

			#if defined(DECAL_PROJECTOR)
			#if UNITY_REVERSED_Z
			#if _RENDER_PASS_ENABLED
				float depth = LOAD_FRAMEBUFFER_X_INPUT(GBUFFER3, packedInput.positionCS.xy).x;
			#else
				float depth = LoadSceneDepth(packedInput.positionCS.xy);
			#endif
			#else
			#if _RENDER_PASS_ENABLED
				float depth = lerp(UNITY_NEAR_CLIP_VALUE, 1, LOAD_FRAMEBUFFER_X_INPUT(GBUFFER3, packedInput.positionCS.xy));
			#else
			    // Adjust z to match NDC for OpenGL
				float depth = lerp(UNITY_NEAR_CLIP_VALUE, 1, LoadSceneDepth(packedInput.positionCS.xy));
			#endif
			#endif
			#endif

			#if defined(DECAL_RECONSTRUCT_NORMAL)
				#if defined(_RENDER_PASS_ENABLED)
					half3 normalWS = half3(ReconstructNormalDerivative(packedInput.positionCS.xy, LOAD_FRAMEBUFFER_X_INPUT(GBUFFER3, packedInput.positionCS.xy).x));
				#elif defined(_DECAL_NORMAL_BLEND_HIGH)
					half3 normalWS = half3(ReconstructNormalTap9(packedInput.positionCS.xy));
				#elif defined(_DECAL_NORMAL_BLEND_MEDIUM)
					half3 normalWS = half3(ReconstructNormalTap5(packedInput.positionCS.xy));
				#else
					half3 normalWS = half3(ReconstructNormalDerivative(packedInput.positionCS.xy));
				#endif
			#elif defined(DECAL_LOAD_NORMAL)
				#if defined(_RENDER_PASS_ENABLED)
				half3 normalWS = normalize(LOAD_FRAMEBUFFER_X_INPUT(GBUFFER2, packedInput.positionCS.xy).rgb);
				#else
				half3 normalWS = normalize(LoadSceneNormals(packedInput.positionCS.xy).rgb);
				#endif
			#endif

				float2 positionSS = FoveatedRemapNonUniformToLinearCS(packedInput.positionCS.xy) * _ScreenSize.zw;

				float4 positionCS = ComputeClipSpacePosition( positionSS, depth );
				float4 hpositionVS = mul( UNITY_MATRIX_I_P, positionCS );

				float4 ScreenPosNorm = float4( positionSS, positionCS.zw );
				float4 ClipPos = positionCS * packedInput.positionCS.w;
				float4 ScreenPos = ComputeScreenPos( ClipPos );
				float3 PositionRWS = mul( ( float3x3 )UNITY_MATRIX_I_V, hpositionVS.xyz / hpositionVS.w );
				float3 PositionWS = PositionRWS + _WorldSpaceCameraPos;
				float3 PositionOS = TransformWorldToObject( PositionWS );
				float3 PositionVS = TransformWorldToView( PositionWS );

				float3 positionDS = TransformWorldToObject(PositionWS);
				positionDS = positionDS * float3(1.0, -1.0, 1.0);

				float clipValue = 0.5 - Max3(abs(positionDS).x, abs(positionDS).y, abs(positionDS).z);
				clip(clipValue);

				float2 texCoord = positionDS.xz + float2(0.5, 0.5);

				float4x4 normalToWorld = UNITY_ACCESS_INSTANCED_PROP(Decal, _NormalToWorld);
				float2 scale = float2(normalToWorld[3][0], normalToWorld[3][1]);
				float2 offset = float2(normalToWorld[3][2], normalToWorld[3][3]);
				texCoord.xy = texCoord.xy * scale + offset;

			#ifdef DECAL_ANGLE_FADE
				half2 angleFade = half2(normalToWorld[1][3], normalToWorld[2][3]);

				if (angleFade.y < 0.0f)
				{
					half3 decalNormal = half3(normalToWorld[0].z, normalToWorld[1].z, normalToWorld[2].z);
					half dotAngle = dot(normalWS, decalNormal);
					angleFadeFactor = saturate(angleFade.x + angleFade.y * (dotAngle * (dotAngle - 2.0)));
				}
			#endif

				half3 viewDirectionWS = half3(1.0, 1.0, 1.0);
				DecalSurfaceData surfaceData;

				SurfaceDescription surfaceDescription = (SurfaceDescription)0;

				float2 texCoord0 = texCoord;
				float2 texCoord1 = texCoord;
				float2 texCoord2 = texCoord;
				float2 texCoord3 = texCoord;

				float3 worldTangent = TransformObjectToWorldDir(float3(1, 0, 0));
				float3 worldNormal = TransformObjectToWorldDir(float3(0, 1, 0));
				float3 worldBitangent = TransformObjectToWorldDir(float3(0, 0, 1));

				float temp_output_1307_0 = radians( _Rotation );
				float temp_output_1301_0 = cos( temp_output_1307_0 );
				float2 break1305 = ( texCoord0 - float2( 0.5,0.5 ) );
				float temp_output_1300_0 = sin( temp_output_1307_0 );
				float2 appendResult1295 = (float2(( ( temp_output_1301_0 * break1305.x ) + ( temp_output_1300_0 * break1305.y ) ) , ( ( temp_output_1301_0 * break1305.y ) - ( temp_output_1300_0 * break1305.x ) )));
				float2 temp_output_1353_0 = (_BaseColorMap_ST).xy;
				float2 _Vector0 = float2(0.5,0.5);
				// *** BEGIN Flipbook UV Animation vars ***
				// Total tiles of Flipbook Texture
				float fbtotaltiles1358 = min( _FlipbookColumns * _FlipbookRows, 9.0 + 1 );
				// Offsets for cols and rows of Flipbook Texture
				float fbcolsoffset1358 = 1.0f / _FlipbookColumns;
				float fbrowsoffset1358 = 1.0f / _FlipbookRows;
				// Speed of animation
				float fbspeed1358 = _Time[ 1 ] * _FlipbookSpeed;
				// UV Tiling (col and row offset)
				float2 fbtiling1358 = float2(fbcolsoffset1358, fbrowsoffset1358);
				// UV Offset - calculate current tile linear index, and convert it to (X * coloffset, Y * rowoffset)
				// Calculate current tile linear index
				float fbcurrenttileindex1358 = floor( fmod( fbspeed1358 + _FlipbookID, fbtotaltiles1358) );
				fbcurrenttileindex1358 += ( fbcurrenttileindex1358 < 0) ? fbtotaltiles1358 : 0;
				// Obtain Offset X coordinate from current tile linear index
				float fblinearindextox1358 = round ( fmod ( fbcurrenttileindex1358, _FlipbookColumns ) );
				// Reverse X animation if speed is negative
				fblinearindextox1358 = (_FlipbookSpeed > 0 ? fblinearindextox1358 : (int)_FlipbookColumns - fblinearindextox1358);
				// Multiply Offset X by coloffset
				float fboffsetx1358 = fblinearindextox1358 * fbcolsoffset1358;
				// Obtain Offset Y coordinate from current tile linear index
				float fblinearindextoy1358 = round( fmod( ( fbcurrenttileindex1358 - fblinearindextox1358 ) / _FlipbookColumns, _FlipbookRows ) );
				// Reverse Y to get tiles from Top to Bottom and Reverse Y animation if speed is negative
				fblinearindextoy1358 = (_FlipbookSpeed <  0 ? fblinearindextoy1358 : (int)_FlipbookRows - fblinearindextoy1358);
				// Multiply Offset Y by rowoffset
				float fboffsety1358 = fblinearindextoy1358 * fbrowsoffset1358;
				// UV Offset
				float2 fboffset1358 = float2(fboffsetx1358, fboffsety1358);
				// Flipbook UV
				float2 fbuv1358 = ( ( ( ( appendResult1295 * temp_output_1353_0 ) + float2( 0.5,0.5 ) ) + (_BaseColorMap_ST).zw ) - ( ( ( temp_output_1353_0 / 1.0 ) * _Vector0 ) - _Vector0 ) ) * fbtiling1358 + fboffset1358;
				// *** END Flipbook UV Animation vars ***
				int flipbookFrame1358 = ( ( int )fbcurrenttileindex1358);
				float2 temp_output_1490_0 = ddx( fbuv1358 );
				float2 temp_output_1491_0 = ddy( fbuv1358 );
				float temp_output_410_0 = ( _ParallaxAmplitude * 0.001 );
				float3 tanToWorld0 = float3( worldTangent.x, worldBitangent.x, worldNormal.x );
				float3 tanToWorld1 = float3( worldTangent.y, worldBitangent.y, worldNormal.y );
				float3 tanToWorld2 = float3( worldTangent.z, worldBitangent.z, worldNormal.z );
				float3 ase_viewVectorTS =  tanToWorld0 * ( _WorldSpaceCameraPos.xyz - PositionWS ).x + tanToWorld1 * ( _WorldSpaceCameraPos.xyz - PositionWS ).y  + tanToWorld2 * ( _WorldSpaceCameraPos.xyz - PositionWS ).z;
				float2 Offset1512 = ( ( SAMPLE_TEXTURE2D_GRAD( _ParallaxMap, sampler_ParallaxMap, fbuv1358, temp_output_1490_0, temp_output_1491_0 ).r - 1 ) * ase_viewVectorTS.xy * temp_output_410_0 ) + fbuv1358;
				float2 Offset1554 = ( ( SAMPLE_TEXTURE2D_GRAD( _ParallaxMap, sampler_ParallaxMap, fbuv1358, temp_output_1490_0, temp_output_1491_0 ).r - 1 ) * ase_viewVectorTS.xy * temp_output_410_0 ) + Offset1512;
				float2 Offset1605 = ( ( SAMPLE_TEXTURE2D_GRAD( _ParallaxMap, sampler_ParallaxMap, fbuv1358, temp_output_1490_0, temp_output_1491_0 ).r - 1 ) * ase_viewVectorTS.xy * temp_output_410_0 ) + Offset1554;
				float2 Offset1606 = ( ( SAMPLE_TEXTURE2D_GRAD( _ParallaxMap, sampler_ParallaxMap, fbuv1358, temp_output_1490_0, temp_output_1491_0 ).r - 1 ) * ase_viewVectorTS.xy * temp_output_410_0 ) + Offset1605;
				float2 lerpResult1376 = lerp( fbuv1358 , Offset1606 , _EnableParallax);
				float2 UV1050 = lerpResult1376;
				float2 UV_DDX1265 = temp_output_1490_0;
				float2 UV_DDY1266 = temp_output_1491_0;
				float4 tex2DNode445 = SAMPLE_TEXTURE2D_GRAD( _BaseColorMap, sampler_BaseColorMap, UV1050, UV_DDX1265, UV_DDY1266 );
				float BaseColorMap_Alpha631 = tex2DNode445.a;
				float temp_output_523_0 = ( BaseColorMap_Alpha631 * ( 1.0 - _DecalOpacity ) );
				float3 temp_output_702_0 = ( PositionOS + float3( 0.5,0.5,0.5 ) );
				float temp_output_698_0 = saturate( ( ( _HeightScale * ( temp_output_702_0 * ( 1.0 - temp_output_702_0 ) ).y ) + _HeightOffset ) );
				float smoothstepResult705 = smoothstep( temp_output_698_0 , ( temp_output_698_0 + 0.001 ) , ( SAMPLE_TEXTURE2D_GRAD( _ParallaxMap, sampler_ParallaxMap, UV1050, UV_DDX1265, UV_DDY1266 ).r * SAMPLE_TEXTURE2D_GRAD( _ParallaxMap, sampler_ParallaxMap, UV1050, UV_DDX1265, UV_DDY1266 ).r ));
				float Height746 = smoothstepResult705;
				float lerpResult1383 = lerp( temp_output_523_0 , ( temp_output_523_0 * Height746 ) , _EnableHeight);
				float Alpha635 = lerpResult1383;
				
				float3 color1672 = IsGammaSpace() ? float3( 0, 0, 0 ) : float3( 0, 0, 0 );
				float2 UV_Parallax_Off1456 = fbuv1358;
				float3 BaseColor554 = ( (tex2DNode445).rgb * (_BaseColor).rgb );
				float temp_output_2_0_g61768 = _AlbedoAffectEmissive;
				float temp_output_3_0_g61768 = ( 1.0 - temp_output_2_0_g61768 );
				float3 appendResult7_g61768 = (float3(temp_output_3_0_g61768 , temp_output_3_0_g61768 , temp_output_3_0_g61768));
				float3 lerpResult1671 = lerp( color1672 , ( (SAMPLE_TEXTURE2D_GRAD( _EmissiveColorMap, sampler_EmissiveColorMap, UV_Parallax_Off1456, UV_DDX1265, UV_DDY1266 )).rgb * ( ( _EmissiveColor * _EmissiveIntensity ) * ( ( BaseColor554 * temp_output_2_0_g61768 ) + appendResult7_g61768 ) ) ) , _AffectEmission);
				float3 Emissive558 = lerpResult1671;
				

				surfaceDescription.Alpha = Alpha635;

			#if defined( _MATERIAL_AFFECTS_EMISSION )
				surfaceDescription.Emission = Emissive558;
			#endif

				GetSurfaceData( surfaceDescription, angleFadeFactor, surfaceData);

				outEmissive.rgb = surfaceData.emissive * GetCurrentExposureMultiplier();
				outEmissive.a = surfaceData.baseColor.a;

			}
            ENDHLSL
        }

		
        Pass
        {
			
            Name "DecalScreenSpaceProjector"
            Tags { "LightMode"="DecalScreenSpaceProjector" }

			Cull Front
			Blend SrcAlpha OneMinusSrcAlpha
			ZTest Greater
			ZWrite Off

			HLSLPROGRAM

			#define _MATERIAL_AFFECTS_ALBEDO 1
			#define _MATERIAL_AFFECTS_NORMAL 1
			#define _MATERIAL_AFFECTS_NORMAL_BLEND 1
			#define DECAL_ANGLE_FADE 1
			#define  _MATERIAL_AFFECTS_MAOS 1
			#define _MATERIAL_AFFECTS_EMISSION 1
			#define ASE_VERSION 19907
			#define ASE_SRP_VERSION 170300
			#define ASE_USING_SAMPLING_MACROS 1


			#pragma vertex Vert
			#pragma fragment Frag
			#pragma multi_compile_instancing
			#pragma editor_sync_compilation

			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
			#pragma multi_compile_fragment _ _SCREEN_SPACE_IRRADIANCE
			#pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
			#pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
            #pragma multi_compile_fragment _ _SHADOWS_SOFT _SHADOWS_SOFT_LOW _SHADOWS_SOFT_MEDIUM _SHADOWS_SOFT_HIGH
			#pragma multi_compile _ _CLUSTER_LIGHT_LOOP
			#pragma multi_compile_fragment _ _LIGHT_COOKIES
			#pragma multi_compile_fragment _ DEBUG_DISPLAY
			#pragma multi_compile _DECAL_NORMAL_BLEND_LOW _DECAL_NORMAL_BLEND_MEDIUM _DECAL_NORMAL_BLEND_HIGH
			#pragma multi_compile _ _DECAL_LAYERS

            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            #define ATTRIBUTES_NEED_NORMAL
			#define ATTRIBUTES_NEED_TEXCOORD0
            #define VARYINGS_NEED_NORMAL_WS
			#define VARYINGS_NEED_TEXCOORD0
            #define VARYINGS_NEED_VIEWDIRECTION_WS
            #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
            #define VARYINGS_NEED_SH
            #define VARYINGS_NEED_STATIC_LIGHTMAP_UV
            #define VARYINGS_NEED_DYNAMIC_LIGHTMAP_UV

            #define HAVE_MESH_MODIFICATION

            #define SHADERPASS SHADERPASS_DECAL_SCREEN_SPACE_PROJECTOR

			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Fog.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
            #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ProbeVolumeVariants.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DecalInput.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderVariablesDecal.hlsl"

		    #if defined(LOD_FADE_CROSSFADE)
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
            #endif

            #if _RENDER_PASS_ENABLED
            #define GBUFFER3 0
            FRAMEBUFFER_INPUT_X_FLOAT(GBUFFER3);
            #define GBUFFER4 1
            FRAMEBUFFER_INPUT_X_UINT(GBUFFER4);
            #endif

			#define ASE_NEEDS_TEXTURE_COORDINATES0
			#define ASE_NEEDS_FRAG_TEXTURE_COORDINATES0
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_NEEDS_FRAG_WORLD_TANGENT
			#define ASE_NEEDS_WORLD_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_BITANGENT
			#define ASE_NEEDS_FRAG_OBJECT_POSITION


			struct SurfaceDescription
			{
				float3 BaseColor;
				float Alpha;
				float3 NormalTS;
				float NormalAlpha;
				float Metallic;
				float Occlusion;
				float Smoothness;
				float MAOSAlpha;
				float3 Emission;
			};

			struct Attributes
			{
				float3 positionOS : POSITION;
				float3 normalOS : NORMAL;
				float4 tangentOS : TANGENT;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct PackedVaryings
			{
				float4 positionCS : SV_POSITION;
				float3 normalWS : TEXCOORD0;
				float3 viewDirectionWS : TEXCOORD1;
				float4 lightmapUVs : TEXCOORD2; // @diogo: packs both static (xy) and dynamic (zw)
				float3 sh : TEXCOORD3;
				float4 fogFactorAndVertexLight : TEXCOORD4;
				#ifdef USE_APV_PROBE_OCCLUSION
					float4 probeOcclusion : TEXCOORD5;
				#endif
				float4 ase_texcoord6 : TEXCOORD6;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

            CBUFFER_START(UnityPerMaterial)
			float4 _BaseColorMap_ST;
			float4 _BaseColor;
			float3 _EmissiveColor;
			float _Rotation;
			half _EmissiveIntensity;
			float _MaskOpacityChannel;
			half _MaskmapSmoothness;
			half _MaskmapAO;
			half _MaskmapMetal;
			float _DecalMaskMapBlueScale1;
			float _NormalOpacityChannel;
			float _NormalScale;
			float _HeightOffset;
			float _AlbedoAffectEmissive;
			float _HeightScale;
			half _DecalOpacity;
			float _EnableParallax;
			float _ParallaxAmplitude;
			half _FlipbookID;
			half _FlipbookSpeed;
			half _FlipbookRows;
			half _FlipbookColumns;
			float _EnableHeight;
			float _AffectEmission;
			float _DrawOrder;
			float _DecalMeshBiasType;
			float _DecalMeshDepthBias;
			float _DecalMeshViewBias;
			#if defined(DECAL_ANGLE_FADE)
			float _DecalAngleFadeSupported;
			#endif
			UNITY_TEXTURE_STREAMING_DEBUG_VARS;
			CBUFFER_END

            #ifdef SCENEPICKINGPASS
				float4 _SelectionID;
            #endif

            #ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
            #endif

			TEXTURE2D(_BaseColorMap);
			TEXTURE2D(_ParallaxMap);
			SAMPLER(sampler_ParallaxMap);
			SAMPLER(sampler_BaseColorMap);
			TEXTURE2D(_NormalMap);
			SAMPLER(sampler_NormalMap);
			TEXTURE2D(_MaskMap);
			TEXTURE2D(_EmissiveColorMap);
			SAMPLER(sampler_EmissiveColorMap);


			float _SwitchNormalOpacity( float m_switch, float m_BaseColorMapAlpha, float m_MaskMapBlue )
			{
				if(m_switch ==0)
					return m_BaseColorMapAlpha;
				else if(m_switch ==1)
					return m_MaskMapBlue;
				else
				return float(0);
			}
			
			float _SwitchMaskOpacity( float m_switch, float m_BaseColorMapAlpha, float m_MaskMapBlue )
			{
				if(m_switch ==0)
					return m_BaseColorMapAlpha;
				else if(m_switch ==1)
					return m_MaskMapBlue;
				else
				return float(0);
			}
			

            void GetSurfaceData(SurfaceDescription surfaceDescription, float angleFadeFactor, out DecalSurfaceData surfaceData)
            {
                half4x4 normalToWorld = UNITY_ACCESS_INSTANCED_PROP(Decal, _NormalToWorld);
                half fadeFactor = clamp(normalToWorld[0][3], 0.0f, 1.0f) * angleFadeFactor;
                float2 scale = float2(normalToWorld[3][0], normalToWorld[3][1]);
                float2 offset = float2(normalToWorld[3][2], normalToWorld[3][3]);

                ZERO_INITIALIZE(DecalSurfaceData, surfaceData);
                surfaceData.occlusion = half(1.0);
                surfaceData.smoothness = half(0);

                #ifdef _MATERIAL_AFFECTS_NORMAL
                    surfaceData.normalWS.w = half(1.0);
                #else
                    surfaceData.normalWS.w = half(0.0);
                #endif

				#if defined( _MATERIAL_AFFECTS_EMISSION )
                	surfaceData.emissive.rgb = half3(surfaceDescription.Emission.rgb * fadeFactor);
				#endif

                surfaceData.baseColor.xyz = half3(surfaceDescription.BaseColor);
                surfaceData.baseColor.w = half(surfaceDescription.Alpha * fadeFactor);

                #if (SHADERPASS == SHADERPASS_DBUFFER_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_PROJECTOR)
                    #if defined(_MATERIAL_AFFECTS_NORMAL)
						surfaceData.normalWS.xyz = normalize(mul((half3x3)normalToWorld, surfaceDescription.NormalTS.xyz));
                    #else
						surfaceData.normalWS.xyz = normalize(normalToWorld[2].xyz);
                    #endif
                #elif (SHADERPASS == SHADERPASS_DBUFFER_MESH) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_MESH) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_MESH)
                    #if defined(_MATERIAL_AFFECTS_NORMAL)
                        float sgn = input.tangentWS.w;
                        float3 bitangent = sgn * cross(input.normalWS.xyz, input.tangentWS.xyz);
                        half3x3 tangentToWorld = half3x3(input.tangentWS.xyz, bitangent.xyz, input.normalWS.xyz);
                        surfaceData.normalWS.xyz = normalize(TransformTangentToWorld(surfaceDescription.NormalTS, tangentToWorld));
                    #else
						surfaceData.normalWS.xyz = normalize(half3(input.normalWS));
                    #endif
                #endif

                surfaceData.normalWS.w = surfaceDescription.NormalAlpha * fadeFactor;

				#if defined( _MATERIAL_AFFECTS_MAOS )
					surfaceData.metallic = half(surfaceDescription.Metallic);
					surfaceData.occlusion = half(surfaceDescription.Occlusion);
					surfaceData.smoothness = half(surfaceDescription.Smoothness);
					surfaceData.MAOSAlpha = half(surfaceDescription.MAOSAlpha * fadeFactor);
				#endif
            }

            #if (SHADERPASS == SHADERPASS_DBUFFER_PROJECTOR) || (SHADERPASS == SHADERPASS_FORWARD_EMISSIVE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_PROJECTOR)
            #define DECAL_PROJECTOR
            #endif

            #if (SHADERPASS == SHADERPASS_DBUFFER_MESH) || (SHADERPASS == SHADERPASS_FORWARD_EMISSIVE_MESH) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_MESH) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_MESH)
            #define DECAL_MESH
            #endif

            #if (SHADERPASS == SHADERPASS_DBUFFER_PROJECTOR) || (SHADERPASS == SHADERPASS_DBUFFER_MESH)
            #define DECAL_DBUFFER
            #endif

            #if (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_MESH)
            #define DECAL_SCREEN_SPACE
            #endif

            #if (SHADERPASS == SHADERPASS_DECAL_GBUFFER_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_MESH)
            #define DECAL_GBUFFER
            #endif

            #if (SHADERPASS == SHADERPASS_FORWARD_EMISSIVE_PROJECTOR) || (SHADERPASS == SHADERPASS_FORWARD_EMISSIVE_MESH)
            #define DECAL_FORWARD_EMISSIVE
            #endif

            #if ((!defined(_MATERIAL_AFFECTS_NORMAL) && defined(_MATERIAL_AFFECTS_ALBEDO)) || (defined(_MATERIAL_AFFECTS_NORMAL) && defined(_MATERIAL_AFFECTS_NORMAL_BLEND))) && (defined(DECAL_SCREEN_SPACE) || defined(DECAL_GBUFFER))
            #define DECAL_RECONSTRUCT_NORMAL
            #elif defined(DECAL_ANGLE_FADE)
            #define DECAL_LOAD_NORMAL
            #endif

            #ifdef _DECAL_LAYERS
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DeclareRenderingLayerTexture.hlsl"
            #endif

            #if defined(DECAL_LOAD_NORMAL)
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DeclareNormalsTexture.hlsl"
            #endif

            #if defined(DECAL_PROJECTOR) || defined(DECAL_RECONSTRUCT_NORMAL)
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DeclareDepthTexture.hlsl"
            #endif

            #ifdef DECAL_MESH
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DecalMeshBiasTypeEnum.cs.hlsl"
            #endif

            #ifdef DECAL_RECONSTRUCT_NORMAL
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/NormalReconstruction.hlsl"
            #endif

			void InitializeInputData(PackedVaryings input, float3 positionWS, half3 normalWS, half3 viewDirectionWS, out InputData inputData)
			{
				inputData = (InputData)0;

				inputData.positionWS = positionWS;
				inputData.normalWS = normalWS;
				inputData.viewDirectionWS = viewDirectionWS;
				inputData.shadowCoord = float4(0, 0, 0, 0);

				#ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
					inputData.fogCoord = InitializeInputDataFog(float4(positionWS, 1.0), input.fogFactorAndVertexLight.x);
					inputData.vertexLighting = input.fogFactorAndVertexLight.yzw;
				#endif

				#if defined(VARYINGS_NEED_DYNAMIC_LIGHTMAP_UV) && defined(DYNAMICLIGHTMAP_ON)
					inputData.bakedGI = SAMPLE_GI(input.lightmapUVs.xy, input.lightmapUVs.zw, half3(input.sh), normalWS);
					#if defined(VARYINGS_NEED_STATIC_LIGHTMAP_UV)
					inputData.shadowMask = SAMPLE_SHADOWMASK(input.lightmapUVs.xy);
					#endif
				#elif defined(VARYINGS_NEED_STATIC_LIGHTMAP_UV)
				#if !defined(LIGHTMAP_ON) && (defined(PROBE_VOLUMES_L1) || defined(PROBE_VOLUMES_L2))
    				inputData.bakedGI = SAMPLE_GI(input.sh,
					GetAbsolutePositionWS(inputData.positionWS),
					inputData.normalWS,
					inputData.viewDirectionWS,
					input.positionCS.xy,
					input.probeOcclusion,
					inputData.shadowMask);
				#else
					inputData.bakedGI = SAMPLE_GI(input.lightmapUVs.xy, half3(input.sh), normalWS);
					#if defined(VARYINGS_NEED_STATIC_LIGHTMAP_UV)
					inputData.shadowMask = SAMPLE_SHADOWMASK(input.lightmapUVs.xy);
					#endif
				#endif
				#endif

				#if defined(DEBUG_DISPLAY)
					#if defined(VARYINGS_NEED_DYNAMIC_LIGHTMAP_UV) && defined(DYNAMICLIGHTMAP_ON)
						inputData.dynamicLightmapUV = input.lightmapUVs.zw;
					#endif
					#if defined(VARYINGS_NEED_STATIC_LIGHTMAP_UV) && defined(LIGHTMAP_ON)
						inputData.staticLightmapUV = input.lightmapUVs.xy;
					#elif defined(VARYINGS_NEED_SH)
						inputData.vertexSH = input.sh;
					#endif
					#if defined(USE_APV_PROBE_OCCLUSION)
						inputData.probeOcclusion = input.probeOcclusion;
					#endif
				#endif

				inputData.normalizedScreenSpaceUV = GetNormalizedScreenSpaceUV(input.positionCS);
			}

			void GetSurface(DecalSurfaceData decalSurfaceData, inout SurfaceData surfaceData)
			{
				surfaceData.albedo = decalSurfaceData.baseColor.rgb;
				surfaceData.metallic = saturate(decalSurfaceData.metallic);
				surfaceData.specular = 0;
				surfaceData.smoothness = saturate(decalSurfaceData.smoothness);
				surfaceData.occlusion = decalSurfaceData.occlusion;
				surfaceData.emission = decalSurfaceData.emissive;
				surfaceData.alpha = saturate(decalSurfaceData.baseColor.w);
				surfaceData.clearCoatMask = 0;
				surfaceData.clearCoatSmoothness = 1;
			}

			PackedVaryings Vert(Attributes inputMesh  )
			{
				PackedVaryings packedOutput;
				ZERO_INITIALIZE(PackedVaryings, packedOutput);

				UNITY_SETUP_INSTANCE_ID(inputMesh);
				UNITY_TRANSFER_INSTANCE_ID(inputMesh, packedOutput);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(packedOutput);

				inputMesh.tangentOS = float4( 1, 0, 0, -1 );
				inputMesh.normalOS = float3( 0, 1, 0 );

				packedOutput.ase_texcoord6.xy = inputMesh.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				packedOutput.ase_texcoord6.zw = 0;

				VertexPositionInputs vertexInput = GetVertexPositionInputs(inputMesh.positionOS.xyz);
				float3 positionWS = TransformObjectToWorld(inputMesh.positionOS);

				float3 normalWS = TransformObjectToWorldNormal(inputMesh.normalOS);

				packedOutput.positionCS = TransformWorldToHClip(positionWS);

				half fogFactor = 0;
				#if !defined(_FOG_FRAGMENT)
					fogFactor = ComputeFogFactor(packedOutput.positionCS.z);
				#endif
				half3 vertexLight = VertexLighting(positionWS, normalWS);
				packedOutput.fogFactorAndVertexLight = half4(fogFactor, vertexLight);

				packedOutput.normalWS.xyz =  normalWS;
				packedOutput.viewDirectionWS.xyz =  GetWorldSpaceViewDir(positionWS);

				#if defined(LIGHTMAP_ON)
					OUTPUT_LIGHTMAP_UV(inputMesh.uv1, unity_LightmapST, packedOutput.lightmapUVs.xy);
				#endif

				#if defined(DYNAMICLIGHTMAP_ON)
					packedOutput.lightmapUVs.zw = inputMesh.uv2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
				#endif

				#if !defined(LIGHTMAP_ON)
					packedOutput.sh.xyz =  float3(SampleSHVertex(half3(normalWS)));
				#endif

				return packedOutput;
			}

			void Frag(PackedVaryings packedInput,
				out half4 outColor : SV_Target0
				
			)
			{
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(packedInput);
				UNITY_SETUP_INSTANCE_ID(packedInput);

				half angleFadeFactor = 1.0;

            // Only screen space needs flip logic, other passes do not setup needed properties so we skip here 
			// to-do check DecalScreenSpaceProjector pass
            //#if defined(DECAL_SCREEN_SPACE)
				//TransformScreenUV(packedInput.positionCS, _ScreenSize.y);
            //#endif

            #ifdef _DECAL_LAYERS
            #ifdef _RENDER_PASS_ENABLED
				uint surfaceRenderingLayer = LOAD_FRAMEBUFFER_X_INPUT(GBUFFER4, packedInput.positionCS.xy).r;
            #else
				uint surfaceRenderingLayer = LoadSceneRenderingLayer(packedInput.positionCS.xy);
            #endif
				uint projectorRenderingLayer = asuint(UNITY_ACCESS_INSTANCED_PROP(Decal, _DecalLayerMaskFromDecal));
				clip((surfaceRenderingLayer & projectorRenderingLayer) - 0.1);
            #endif

			#if defined(DECAL_PROJECTOR)
			#if UNITY_REVERSED_Z
			#if _RENDER_PASS_ENABLED
				float depth = LOAD_FRAMEBUFFER_X_INPUT(GBUFFER3, packedInput.positionCS.xy).x;
			#else
				float depth = LoadSceneDepth(packedInput.positionCS.xy);
			#endif
			#else
			#if _RENDER_PASS_ENABLED
				float depth = lerp(UNITY_NEAR_CLIP_VALUE, 1, LOAD_FRAMEBUFFER_X_INPUT(GBUFFER3, packedInput.positionCS.xy));
			#else
			    // Adjust z to match NDC for OpenGL
				float depth = lerp(UNITY_NEAR_CLIP_VALUE, 1, LoadSceneDepth(packedInput.positionCS.xy));
			#endif
			#endif
			#endif

			#if defined(DECAL_RECONSTRUCT_NORMAL)
				#if defined(_RENDER_PASS_ENABLED)
					half3 normalWS = half3(ReconstructNormalDerivative(packedInput.positionCS.xy, LOAD_FRAMEBUFFER_X_INPUT(GBUFFER3, packedInput.positionCS.xy).x));
				#elif defined(_DECAL_NORMAL_BLEND_HIGH)
					half3 normalWS = half3(ReconstructNormalTap9(packedInput.positionCS.xy));
				#elif defined(_DECAL_NORMAL_BLEND_MEDIUM)
					half3 normalWS = half3(ReconstructNormalTap5(packedInput.positionCS.xy));
				#else
					half3 normalWS = half3(ReconstructNormalDerivative(packedInput.positionCS.xy));
				#endif
			#elif defined(DECAL_LOAD_NORMAL)
				#if defined(_RENDER_PASS_ENABLED)
				half3 normalWS = normalize(LOAD_FRAMEBUFFER_X_INPUT(GBUFFER2, packedInput.positionCS.xy).rgb);
				#else
				half3 normalWS = normalize(LoadSceneNormals(packedInput.positionCS.xy).rgb);
				#endif
			#endif

				float2 positionSS = FoveatedRemapNonUniformToLinearCS(packedInput.positionCS.xy) * _ScreenSize.zw;

				float4 positionCS = ComputeClipSpacePosition( positionSS, depth );
				float4 hpositionVS = mul( UNITY_MATRIX_I_P, positionCS );

				float4 ScreenPosNorm = float4( positionSS, positionCS.zw );
				float4 ClipPos = positionCS * packedInput.positionCS.w;
				float4 ScreenPos = ComputeScreenPos( ClipPos );
				float3 PositionRWS = mul( ( float3x3 )UNITY_MATRIX_I_V, hpositionVS.xyz / hpositionVS.w );
				float3 PositionWS = PositionRWS + _WorldSpaceCameraPos;
				float3 PositionOS = TransformWorldToObject( PositionWS );
				float3 PositionVS = TransformWorldToView( PositionWS );

				float3 positionDS = TransformWorldToObject(PositionWS);
				positionDS = positionDS * float3(1.0, -1.0, 1.0);

				float clipValue = 0.5 - Max3(abs(positionDS).x, abs(positionDS).y, abs(positionDS).z);
				clip(clipValue);

				float2 texCoord = positionDS.xz + float2(0.5, 0.5);

				float4x4 normalToWorld = UNITY_ACCESS_INSTANCED_PROP(Decal, _NormalToWorld);
				float2 scale = float2(normalToWorld[3][0], normalToWorld[3][1]);
				float2 offset = float2(normalToWorld[3][2], normalToWorld[3][3]);
				texCoord.xy = texCoord.xy * scale + offset;

				float2 texCoord0 = texCoord;
				float2 texCoord1 = texCoord;
				float2 texCoord2 = texCoord;
				float2 texCoord3 = texCoord;

				float3 worldTangent = TransformObjectToWorldDir(float3(1, 0, 0));
				float3 worldNormal = TransformObjectToWorldDir(float3(0, 1, 0));
				float3 worldBitangent = TransformObjectToWorldDir(float3(0, 0, 1));

			#ifdef DECAL_ANGLE_FADE
				half2 angleFade = half2(normalToWorld[1][3], normalToWorld[2][3]);

				if (angleFade.y < 0.0f)
				{
					half3 decalNormal = half3(normalToWorld[0].z, normalToWorld[1].z, normalToWorld[2].z);
					half dotAngle = dot(normalWS, decalNormal);
					angleFadeFactor = saturate(angleFade.x + angleFade.y * (dotAngle * (dotAngle - 2.0)));
				}
			#endif

				half3 viewDirectionWS = half3(packedInput.viewDirectionWS);

				DecalSurfaceData surfaceData;

				float temp_output_1307_0 = radians( _Rotation );
				float temp_output_1301_0 = cos( temp_output_1307_0 );
				float2 break1305 = ( texCoord0 - float2( 0.5,0.5 ) );
				float temp_output_1300_0 = sin( temp_output_1307_0 );
				float2 appendResult1295 = (float2(( ( temp_output_1301_0 * break1305.x ) + ( temp_output_1300_0 * break1305.y ) ) , ( ( temp_output_1301_0 * break1305.y ) - ( temp_output_1300_0 * break1305.x ) )));
				float2 temp_output_1353_0 = (_BaseColorMap_ST).xy;
				float2 _Vector0 = float2(0.5,0.5);
				// *** BEGIN Flipbook UV Animation vars ***
				// Total tiles of Flipbook Texture
				float fbtotaltiles1358 = min( _FlipbookColumns * _FlipbookRows, 9.0 + 1 );
				// Offsets for cols and rows of Flipbook Texture
				float fbcolsoffset1358 = 1.0f / _FlipbookColumns;
				float fbrowsoffset1358 = 1.0f / _FlipbookRows;
				// Speed of animation
				float fbspeed1358 = _Time[ 1 ] * _FlipbookSpeed;
				// UV Tiling (col and row offset)
				float2 fbtiling1358 = float2(fbcolsoffset1358, fbrowsoffset1358);
				// UV Offset - calculate current tile linear index, and convert it to (X * coloffset, Y * rowoffset)
				// Calculate current tile linear index
				float fbcurrenttileindex1358 = floor( fmod( fbspeed1358 + _FlipbookID, fbtotaltiles1358) );
				fbcurrenttileindex1358 += ( fbcurrenttileindex1358 < 0) ? fbtotaltiles1358 : 0;
				// Obtain Offset X coordinate from current tile linear index
				float fblinearindextox1358 = round ( fmod ( fbcurrenttileindex1358, _FlipbookColumns ) );
				// Reverse X animation if speed is negative
				fblinearindextox1358 = (_FlipbookSpeed > 0 ? fblinearindextox1358 : (int)_FlipbookColumns - fblinearindextox1358);
				// Multiply Offset X by coloffset
				float fboffsetx1358 = fblinearindextox1358 * fbcolsoffset1358;
				// Obtain Offset Y coordinate from current tile linear index
				float fblinearindextoy1358 = round( fmod( ( fbcurrenttileindex1358 - fblinearindextox1358 ) / _FlipbookColumns, _FlipbookRows ) );
				// Reverse Y to get tiles from Top to Bottom and Reverse Y animation if speed is negative
				fblinearindextoy1358 = (_FlipbookSpeed <  0 ? fblinearindextoy1358 : (int)_FlipbookRows - fblinearindextoy1358);
				// Multiply Offset Y by rowoffset
				float fboffsety1358 = fblinearindextoy1358 * fbrowsoffset1358;
				// UV Offset
				float2 fboffset1358 = float2(fboffsetx1358, fboffsety1358);
				// Flipbook UV
				float2 fbuv1358 = ( ( ( ( appendResult1295 * temp_output_1353_0 ) + float2( 0.5,0.5 ) ) + (_BaseColorMap_ST).zw ) - ( ( ( temp_output_1353_0 / 1.0 ) * _Vector0 ) - _Vector0 ) ) * fbtiling1358 + fboffset1358;
				// *** END Flipbook UV Animation vars ***
				int flipbookFrame1358 = ( ( int )fbcurrenttileindex1358);
				float2 temp_output_1490_0 = ddx( fbuv1358 );
				float2 temp_output_1491_0 = ddy( fbuv1358 );
				float temp_output_410_0 = ( _ParallaxAmplitude * 0.001 );
				float3 tanToWorld0 = float3( worldTangent.x, worldBitangent.x, worldNormal.x );
				float3 tanToWorld1 = float3( worldTangent.y, worldBitangent.y, worldNormal.y );
				float3 tanToWorld2 = float3( worldTangent.z, worldBitangent.z, worldNormal.z );
				float3 ase_viewVectorTS =  tanToWorld0 * ( _WorldSpaceCameraPos.xyz - PositionWS ).x + tanToWorld1 * ( _WorldSpaceCameraPos.xyz - PositionWS ).y  + tanToWorld2 * ( _WorldSpaceCameraPos.xyz - PositionWS ).z;
				float2 Offset1512 = ( ( SAMPLE_TEXTURE2D_GRAD( _ParallaxMap, sampler_ParallaxMap, fbuv1358, temp_output_1490_0, temp_output_1491_0 ).r - 1 ) * ase_viewVectorTS.xy * temp_output_410_0 ) + fbuv1358;
				float2 Offset1554 = ( ( SAMPLE_TEXTURE2D_GRAD( _ParallaxMap, sampler_ParallaxMap, fbuv1358, temp_output_1490_0, temp_output_1491_0 ).r - 1 ) * ase_viewVectorTS.xy * temp_output_410_0 ) + Offset1512;
				float2 Offset1605 = ( ( SAMPLE_TEXTURE2D_GRAD( _ParallaxMap, sampler_ParallaxMap, fbuv1358, temp_output_1490_0, temp_output_1491_0 ).r - 1 ) * ase_viewVectorTS.xy * temp_output_410_0 ) + Offset1554;
				float2 Offset1606 = ( ( SAMPLE_TEXTURE2D_GRAD( _ParallaxMap, sampler_ParallaxMap, fbuv1358, temp_output_1490_0, temp_output_1491_0 ).r - 1 ) * ase_viewVectorTS.xy * temp_output_410_0 ) + Offset1605;
				float2 lerpResult1376 = lerp( fbuv1358 , Offset1606 , _EnableParallax);
				float2 UV1050 = lerpResult1376;
				float2 UV_DDX1265 = temp_output_1490_0;
				float2 UV_DDY1266 = temp_output_1491_0;
				float4 tex2DNode445 = SAMPLE_TEXTURE2D_GRAD( _BaseColorMap, sampler_BaseColorMap, UV1050, UV_DDX1265, UV_DDY1266 );
				float3 BaseColor554 = ( (tex2DNode445).rgb * (_BaseColor).rgb );
				
				float BaseColorMap_Alpha631 = tex2DNode445.a;
				float temp_output_523_0 = ( BaseColorMap_Alpha631 * ( 1.0 - _DecalOpacity ) );
				float3 temp_output_702_0 = ( PositionOS + float3( 0.5,0.5,0.5 ) );
				float temp_output_698_0 = saturate( ( ( _HeightScale * ( temp_output_702_0 * ( 1.0 - temp_output_702_0 ) ).y ) + _HeightOffset ) );
				float smoothstepResult705 = smoothstep( temp_output_698_0 , ( temp_output_698_0 + 0.001 ) , ( SAMPLE_TEXTURE2D_GRAD( _ParallaxMap, sampler_ParallaxMap, UV1050, UV_DDX1265, UV_DDY1266 ).r * SAMPLE_TEXTURE2D_GRAD( _ParallaxMap, sampler_ParallaxMap, UV1050, UV_DDX1265, UV_DDY1266 ).r ));
				float Height746 = smoothstepResult705;
				float lerpResult1383 = lerp( temp_output_523_0 , ( temp_output_523_0 * Height746 ) , _EnableHeight);
				float Alpha635 = lerpResult1383;
				
				float3 unpack444 = UnpackNormalScale( SAMPLE_TEXTURE2D_GRAD( _NormalMap, sampler_NormalMap, UV1050, UV_DDX1265, UV_DDY1266 ), _NormalScale );
				unpack444.z = lerp( 1, unpack444.z, saturate(_NormalScale) );
				float3 Normal556 = unpack444;
				
				float m_switch857 = _NormalOpacityChannel;
				float m_BaseColorMapAlpha857 = temp_output_523_0;
				float4 tex2DNode607 = SAMPLE_TEXTURE2D_GRAD( _MaskMap, sampler_BaseColorMap, UV1050, UV_DDX1265, UV_DDY1266 );
				float Opacity_Mask632 = tex2DNode607.b;
				float m_MaskMapBlue857 = ( _DecalMaskMapBlueScale1 * Opacity_Mask632 );
				float local_SwitchNormalOpacity857 = _SwitchNormalOpacity( m_switch857 , m_BaseColorMapAlpha857 , m_MaskMapBlue857 );
				float lerpResult1382 = lerp( local_SwitchNormalOpacity857 , ( local_SwitchNormalOpacity857 * Height746 ) , _EnableHeight);
				float Alpha_Normal636 = lerpResult1382;
				
				float Metallic624 = ( _MaskmapMetal * tex2DNode607.r );
				
				float Occlusion626 = saturate( ( ( 1.0 - _MaskmapAO ) * tex2DNode607.g ) );
				
				float Smoothness625 = ( _MaskmapSmoothness * tex2DNode607.a );
				
				float m_switch858 = _MaskOpacityChannel;
				float m_BaseColorMapAlpha858 = temp_output_523_0;
				float m_MaskMapBlue858 = ( _DecalMaskMapBlueScale1 * Opacity_Mask632 );
				float local_SwitchMaskOpacity858 = _SwitchMaskOpacity( m_switch858 , m_BaseColorMapAlpha858 , m_MaskMapBlue858 );
				float lerpResult1381 = lerp( local_SwitchMaskOpacity858 , ( local_SwitchMaskOpacity858 * Height746 ) , _EnableHeight);
				float Alpha_MSO637 = lerpResult1381;
				
				float3 color1672 = IsGammaSpace() ? float3( 0, 0, 0 ) : float3( 0, 0, 0 );
				float2 UV_Parallax_Off1456 = fbuv1358;
				float temp_output_2_0_g61768 = _AlbedoAffectEmissive;
				float temp_output_3_0_g61768 = ( 1.0 - temp_output_2_0_g61768 );
				float3 appendResult7_g61768 = (float3(temp_output_3_0_g61768 , temp_output_3_0_g61768 , temp_output_3_0_g61768));
				float3 lerpResult1671 = lerp( color1672 , ( (SAMPLE_TEXTURE2D_GRAD( _EmissiveColorMap, sampler_EmissiveColorMap, UV_Parallax_Off1456, UV_DDX1265, UV_DDY1266 )).rgb * ( ( _EmissiveColor * _EmissiveIntensity ) * ( ( BaseColor554 * temp_output_2_0_g61768 ) + appendResult7_g61768 ) ) ) , _AffectEmission);
				float3 Emissive558 = lerpResult1671;
				

				SurfaceDescription surfaceDescription = (SurfaceDescription)0;

				surfaceDescription.BaseColor = BaseColor554;
				surfaceDescription.Alpha = Alpha635;
				surfaceDescription.NormalTS = Normal556;
				surfaceDescription.NormalAlpha = Alpha_Normal636;
			#if defined( _MATERIAL_AFFECTS_MAOS )
				surfaceDescription.Metallic = Metallic624;
				surfaceDescription.Occlusion = Occlusion626;
				surfaceDescription.Smoothness = Smoothness625;
				surfaceDescription.MAOSAlpha = Alpha_MSO637;
			#endif

			#if defined( _MATERIAL_AFFECTS_EMISSION )
				surfaceDescription.Emission = Emissive558;
			#endif

				GetSurfaceData( surfaceDescription, angleFadeFactor, surfaceData);

				half3 normalToPack = surfaceData.normalWS.xyz;
			#ifdef DECAL_RECONSTRUCT_NORMAL
				surfaceData.normalWS.xyz = normalize(lerp(normalWS.xyz, surfaceData.normalWS.xyz, surfaceData.normalWS.w));
			#endif

				InputData inputData;
				InitializeInputData( packedInput, PositionWS, surfaceData.normalWS.xyz, viewDirectionWS, inputData);

				SurfaceData surface = (SurfaceData)0;
				GetSurface(surfaceData, surface);

				half4 color = UniversalFragmentPBR(inputData, surface);
				color.rgb = MixFog(color.rgb, inputData.fogCoord);
				outColor = color;

			}
			ENDHLSL
        }

		
        Pass
        {
            
			Name "DecalGBufferProjector"
            Tags { "LightMode"="DecalGBufferProjector" }

			Cull Front
			Blend 0 SrcAlpha OneMinusSrcAlpha
			Blend 1 SrcAlpha OneMinusSrcAlpha
			Blend 2 SrcAlpha OneMinusSrcAlpha
			Blend 3 SrcAlpha OneMinusSrcAlpha
			ZTest Greater
			ZWrite Off
			ColorMask RGB
			ColorMask 0 1
			ColorMask RGB 2
			ColorMask RGB 3

			HLSLPROGRAM

			#define _MATERIAL_AFFECTS_ALBEDO 1
			#define _MATERIAL_AFFECTS_NORMAL 1
			#define _MATERIAL_AFFECTS_NORMAL_BLEND 1
			#define DECAL_ANGLE_FADE 1
			#define  _MATERIAL_AFFECTS_MAOS 1
			#define _MATERIAL_AFFECTS_EMISSION 1
			#define ASE_VERSION 19907
			#define ASE_SRP_VERSION 170300
			#define ASE_USING_SAMPLING_MACROS 1


			#pragma vertex Vert
			#pragma fragment Frag
			#pragma multi_compile_instancing
			#pragma editor_sync_compilation

			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
            #pragma multi_compile_fragment _ _SHADOWS_SOFT _SHADOWS_SOFT_LOW _SHADOWS_SOFT_MEDIUM _SHADOWS_SOFT_HIGH
			#pragma multi_compile _DECAL_NORMAL_BLEND_LOW _DECAL_NORMAL_BLEND_MEDIUM _DECAL_NORMAL_BLEND_HIGH
			#pragma multi_compile _ _DECAL_LAYERS
			#pragma multi_compile_fragment _ _GBUFFER_NORMALS_OCT
			#pragma multi_compile_fragment _ _RENDER_PASS_ENABLED

			//fix for SRP Additional Lighting in Deferred+
			#pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
			#pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
			#pragma multi_compile _ _CLUSTER_LIGHT_LOOP

            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            #define ATTRIBUTES_NEED_NORMAL
			#define ATTRIBUTES_NEED_TEXCOORD0
			#define VARYINGS_NEED_NORMAL_WS
			#define VARYINGS_NEED_TEXCOORD0
            #define VARYINGS_NEED_VIEWDIRECTION_WS
            #define VARYINGS_NEED_SH
            #define VARYINGS_NEED_STATIC_LIGHTMAP_UV
            #define VARYINGS_NEED_DYNAMIC_LIGHTMAP_UV

            #define HAVE_MESH_MODIFICATION

            #define SHADERPASS SHADERPASS_DECAL_GBUFFER_PROJECTOR

			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Fog.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
            #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ProbeVolumeVariants.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/GBufferOutput.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DecalInput.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderVariablesDecal.hlsl"

		    #if defined(LOD_FADE_CROSSFADE)
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
            #endif

            #if _RENDER_PASS_ENABLED
            #define GBUFFER3 0
            FRAMEBUFFER_INPUT_X_FLOAT(GBUFFER3);
            #define GBUFFER4 1
            FRAMEBUFFER_INPUT_X_UINT(GBUFFER4);
            #endif

			#define ASE_NEEDS_TEXTURE_COORDINATES0
			#define ASE_NEEDS_FRAG_TEXTURE_COORDINATES0
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_NEEDS_FRAG_WORLD_TANGENT
			#define ASE_NEEDS_WORLD_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_BITANGENT
			#define ASE_NEEDS_FRAG_OBJECT_POSITION


			struct SurfaceDescription
			{
				float3 BaseColor;
				float Alpha;
				float3 NormalTS;
				float NormalAlpha;
				float Metallic;
				float Occlusion;
				float Smoothness;
				float MAOSAlpha;
				float3 Emission;
			};

			struct Attributes
			{
				float3 positionOS : POSITION;
				float3 normalOS : NORMAL;
				float4 tangentOS : TANGENT;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct PackedVaryings
			{
				float4 positionCS : SV_POSITION;
				float3 normalWS : TEXCOORD0;
				float3 viewDirectionWS : TEXCOORD1;
				float4 lightmapUVs : TEXCOORD2; // @diogo: packs both static (xy) and dynamic (zw)
				float3 sh : TEXCOORD3;
				#ifdef USE_APV_PROBE_OCCLUSION
					float4 probeOcclusion : TEXCOORD4;
				#endif
				float4 ase_texcoord5 : TEXCOORD5;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

            CBUFFER_START(UnityPerMaterial)
			float4 _BaseColorMap_ST;
			float4 _BaseColor;
			float3 _EmissiveColor;
			float _Rotation;
			half _EmissiveIntensity;
			float _MaskOpacityChannel;
			half _MaskmapSmoothness;
			half _MaskmapAO;
			half _MaskmapMetal;
			float _DecalMaskMapBlueScale1;
			float _NormalOpacityChannel;
			float _NormalScale;
			float _HeightOffset;
			float _AlbedoAffectEmissive;
			float _HeightScale;
			half _DecalOpacity;
			float _EnableParallax;
			float _ParallaxAmplitude;
			half _FlipbookID;
			half _FlipbookSpeed;
			half _FlipbookRows;
			half _FlipbookColumns;
			float _EnableHeight;
			float _AffectEmission;
			float _DrawOrder;
			float _DecalMeshBiasType;
			float _DecalMeshDepthBias;
			float _DecalMeshViewBias;
			#if defined(DECAL_ANGLE_FADE)
			float _DecalAngleFadeSupported;
			#endif
			UNITY_TEXTURE_STREAMING_DEBUG_VARS;
			CBUFFER_END

            #ifdef SCENEPICKINGPASS
				float4 _SelectionID;
            #endif

            #ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
            #endif

			TEXTURE2D(_BaseColorMap);
			TEXTURE2D(_ParallaxMap);
			SAMPLER(sampler_ParallaxMap);
			SAMPLER(sampler_BaseColorMap);
			TEXTURE2D(_NormalMap);
			SAMPLER(sampler_NormalMap);
			TEXTURE2D(_MaskMap);
			TEXTURE2D(_EmissiveColorMap);
			SAMPLER(sampler_EmissiveColorMap);


			float _SwitchNormalOpacity( float m_switch, float m_BaseColorMapAlpha, float m_MaskMapBlue )
			{
				if(m_switch ==0)
					return m_BaseColorMapAlpha;
				else if(m_switch ==1)
					return m_MaskMapBlue;
				else
				return float(0);
			}
			
			float _SwitchMaskOpacity( float m_switch, float m_BaseColorMapAlpha, float m_MaskMapBlue )
			{
				if(m_switch ==0)
					return m_BaseColorMapAlpha;
				else if(m_switch ==1)
					return m_MaskMapBlue;
				else
				return float(0);
			}
			

            void GetSurfaceData(SurfaceDescription surfaceDescription, float angleFadeFactor, out DecalSurfaceData surfaceData)
            {
                half4x4 normalToWorld = UNITY_ACCESS_INSTANCED_PROP(Decal, _NormalToWorld);
                half fadeFactor = clamp(normalToWorld[0][3], 0.0f, 1.0f) * angleFadeFactor;
                float2 scale = float2(normalToWorld[3][0], normalToWorld[3][1]);
                float2 offset = float2(normalToWorld[3][2], normalToWorld[3][3]);

                ZERO_INITIALIZE(DecalSurfaceData, surfaceData);
                surfaceData.occlusion = half(1.0);
                surfaceData.smoothness = half(0);

                #ifdef _MATERIAL_AFFECTS_NORMAL
                    surfaceData.normalWS.w = half(1.0);
                #else
                    surfaceData.normalWS.w = half(0.0);
                #endif

				#if defined( _MATERIAL_AFFECTS_EMISSION )
					surfaceData.emissive.rgb = half3(surfaceDescription.Emission.rgb * fadeFactor);
				#endif

                surfaceData.baseColor.xyz = half3(surfaceDescription.BaseColor);
                surfaceData.baseColor.w = half(surfaceDescription.Alpha * fadeFactor);

                #if (SHADERPASS == SHADERPASS_DBUFFER_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_PROJECTOR)
                    #if defined(_MATERIAL_AFFECTS_NORMAL)
						surfaceData.normalWS.xyz = normalize(mul((half3x3)normalToWorld, surfaceDescription.NormalTS.xyz));
                    #else
						surfaceData.normalWS.xyz = normalize(normalToWorld[2].xyz);
                    #endif
                #elif (SHADERPASS == SHADERPASS_DBUFFER_MESH) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_MESH) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_MESH)
                    #if defined(_MATERIAL_AFFECTS_NORMAL)
                        float sgn = input.tangentWS.w;
                        float3 bitangent = sgn * cross(input.normalWS.xyz, input.tangentWS.xyz);
                        half3x3 tangentToWorld = half3x3(input.tangentWS.xyz, bitangent.xyz, input.normalWS.xyz);
                        surfaceData.normalWS.xyz = normalize(TransformTangentToWorld(surfaceDescription.NormalTS, tangentToWorld));
                    #else
						surfaceData.normalWS.xyz = normalize(half3(input.normalWS));
                    #endif
                #endif

                surfaceData.normalWS.w = surfaceDescription.NormalAlpha * fadeFactor;

				#if defined( _MATERIAL_AFFECTS_MAOS )
					surfaceData.metallic = half(surfaceDescription.Metallic);
					surfaceData.occlusion = half(surfaceDescription.Occlusion);
					surfaceData.smoothness = half(surfaceDescription.Smoothness);
					surfaceData.MAOSAlpha = half(surfaceDescription.MAOSAlpha * fadeFactor);
				#endif
            }

            #if (SHADERPASS == SHADERPASS_DBUFFER_PROJECTOR) || (SHADERPASS == SHADERPASS_FORWARD_EMISSIVE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_PROJECTOR)
            #define DECAL_PROJECTOR
            #endif

            #if (SHADERPASS == SHADERPASS_DBUFFER_MESH) || (SHADERPASS == SHADERPASS_FORWARD_EMISSIVE_MESH) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_MESH) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_MESH)
            #define DECAL_MESH
            #endif

            #if (SHADERPASS == SHADERPASS_DBUFFER_PROJECTOR) || (SHADERPASS == SHADERPASS_DBUFFER_MESH)
            #define DECAL_DBUFFER
            #endif

            #if (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_MESH)
            #define DECAL_SCREEN_SPACE
            #endif

            #if (SHADERPASS == SHADERPASS_DECAL_GBUFFER_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_MESH)
            #define DECAL_GBUFFER
            #endif

            #if (SHADERPASS == SHADERPASS_FORWARD_EMISSIVE_PROJECTOR) || (SHADERPASS == SHADERPASS_FORWARD_EMISSIVE_MESH)
            #define DECAL_FORWARD_EMISSIVE
            #endif

            #if ((!defined(_MATERIAL_AFFECTS_NORMAL) && defined(_MATERIAL_AFFECTS_ALBEDO)) || (defined(_MATERIAL_AFFECTS_NORMAL) && defined(_MATERIAL_AFFECTS_NORMAL_BLEND))) && (defined(DECAL_SCREEN_SPACE) || defined(DECAL_GBUFFER))
            #define DECAL_RECONSTRUCT_NORMAL
            #elif defined(DECAL_ANGLE_FADE)
            #define DECAL_LOAD_NORMAL
            #endif

            #ifdef _DECAL_LAYERS
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DeclareRenderingLayerTexture.hlsl"
            #endif

            #if defined(DECAL_LOAD_NORMAL)
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DeclareNormalsTexture.hlsl"
            #endif

            #if defined(DECAL_PROJECTOR) || defined(DECAL_RECONSTRUCT_NORMAL)
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DeclareDepthTexture.hlsl"
            #endif

            #ifdef DECAL_MESH
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DecalMeshBiasTypeEnum.cs.hlsl"
            #endif

            #ifdef DECAL_RECONSTRUCT_NORMAL
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/NormalReconstruction.hlsl"
            #endif

			void InitializeInputData(PackedVaryings input, float3 positionWS, half3 normalWS, half3 viewDirectionWS, out InputData inputData)
			{
				inputData = (InputData)0;

				inputData.positionWS = positionWS;
				inputData.normalWS = normalWS;
				inputData.viewDirectionWS = viewDirectionWS;
				inputData.shadowCoord = float4(0, 0, 0, 0);

				#ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
					inputData.fogCoord = InitializeInputDataFog(float4(positionWS, 1.0), input.fogFactorAndVertexLight.x);
					inputData.vertexLighting = input.fogFactorAndVertexLight.yzw;
				#endif

				#if defined(VARYINGS_NEED_DYNAMIC_LIGHTMAP_UV) && defined(DYNAMICLIGHTMAP_ON)
					inputData.bakedGI = SAMPLE_GI(input.lightmapUVs.xy, input.lightmapUVs.zw, half3(input.sh), normalWS);
					#if defined(VARYINGS_NEED_STATIC_LIGHTMAP_UV)
					inputData.shadowMask = SAMPLE_SHADOWMASK(input.lightmapUVs.xy);
					#endif
				#elif defined(VARYINGS_NEED_STATIC_LIGHTMAP_UV)
				#if !defined(LIGHTMAP_ON) && (defined(PROBE_VOLUMES_L1) || defined(PROBE_VOLUMES_L2))
    				inputData.bakedGI = SAMPLE_GI(input.sh,
					GetAbsolutePositionWS(inputData.positionWS),
					inputData.normalWS,
					inputData.viewDirectionWS,
					input.positionCS.xy,
					input.probeOcclusion,
					inputData.shadowMask);
				#else
					inputData.bakedGI = SAMPLE_GI(input.lightmapUVs.xy, half3(input.sh), normalWS);
					#if defined(VARYINGS_NEED_STATIC_LIGHTMAP_UV)
					inputData.shadowMask = SAMPLE_SHADOWMASK(input.lightmapUVs.xy);
					#endif
				#endif
				#endif

				#if defined(DEBUG_DISPLAY)
					#if defined(VARYINGS_NEED_DYNAMIC_LIGHTMAP_UV) && defined(DYNAMICLIGHTMAP_ON)
						inputData.dynamicLightmapUV = input.lightmapUVs.zw;
					#endif
					#if defined(VARYINGS_NEED_STATIC_LIGHTMAP_UV) && defined(LIGHTMAP_ON)
						inputData.staticLightmapUV = input.lightmapUVs.xy;
					#elif defined(VARYINGS_NEED_SH)
						inputData.vertexSH = input.sh;
					#endif
					#if defined(USE_APV_PROBE_OCCLUSION)
						inputData.probeOcclusion = input.probeOcclusion;
					#endif
				#endif

				inputData.normalizedScreenSpaceUV = GetNormalizedScreenSpaceUV(input.positionCS);
			}

			void GetSurface(DecalSurfaceData decalSurfaceData, inout SurfaceData surfaceData)
			{
				surfaceData.albedo = decalSurfaceData.baseColor.rgb;
				surfaceData.metallic = saturate(decalSurfaceData.metallic);
				surfaceData.specular = 0;
				surfaceData.smoothness = saturate(decalSurfaceData.smoothness);
				surfaceData.occlusion = decalSurfaceData.occlusion;
				surfaceData.emission = decalSurfaceData.emissive;
				surfaceData.alpha = saturate(decalSurfaceData.baseColor.w);
				surfaceData.clearCoatMask = 0;
				surfaceData.clearCoatSmoothness = 1;
			}

			PackedVaryings Vert(Attributes inputMesh  )
			{
				PackedVaryings packedOutput;
				ZERO_INITIALIZE(PackedVaryings, packedOutput);

				UNITY_SETUP_INSTANCE_ID(inputMesh);
				UNITY_TRANSFER_INSTANCE_ID(inputMesh, packedOutput);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(packedOutput);

				inputMesh.tangentOS = float4( 1, 0, 0, -1 );
				inputMesh.normalOS = float3( 0, 1, 0 );

				packedOutput.ase_texcoord5.xy = inputMesh.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				packedOutput.ase_texcoord5.zw = 0;

				float3 positionWS = TransformObjectToWorld(inputMesh.positionOS);
				float3 normalWS = TransformObjectToWorldNormal(inputMesh.normalOS);

				packedOutput.positionCS = TransformWorldToHClip(positionWS);
				packedOutput.normalWS.xyz =  normalWS;
				packedOutput.viewDirectionWS.xyz =  GetWorldSpaceViewDir(positionWS);

				#if defined(LIGHTMAP_ON)
					OUTPUT_LIGHTMAP_UV(inputMesh.uv1, unity_LightmapST, packedOutput.lightmapUVs.xy);
				#endif

				#if defined(DYNAMICLIGHTMAP_ON)
					packedOutput.lightmapUVs.zw = inputMesh.uv2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
				#endif

				#if !defined(LIGHTMAP_ON)
					packedOutput.sh = float3(SampleSHVertex(half3(normalWS)));
				#endif

				return packedOutput;
			}

			void Frag(PackedVaryings packedInput,
				out GBufferFragOutput fragmentOutput
				
			)
			{
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(packedInput);
				UNITY_SETUP_INSTANCE_ID(packedInput);

				half angleFadeFactor = 1.0;

            // Only screen space needs flip logic, other passes do not setup needed properties so we skip here
            #if defined(DECAL_SCREEN_SPACE)
				TransformScreenUV(packedInput.positionCS, _ScreenSize.y);
            #endif

            #ifdef _DECAL_LAYERS
            #ifdef _RENDER_PASS_ENABLED
				uint surfaceRenderingLayer = LOAD_FRAMEBUFFER_X_INPUT(GBUFFER4, packedInput.positionCS.xy).r;
            #else
				uint surfaceRenderingLayer = LoadSceneRenderingLayer(packedInput.positionCS.xy);
            #endif
				uint projectorRenderingLayer = asuint(UNITY_ACCESS_INSTANCED_PROP(Decal, _DecalLayerMaskFromDecal));
				clip((surfaceRenderingLayer & projectorRenderingLayer) - 0.1);
            #endif

			#if defined(DECAL_PROJECTOR)
			#if UNITY_REVERSED_Z
			#if _RENDER_PASS_ENABLED
				float depth = LOAD_FRAMEBUFFER_X_INPUT(GBUFFER3, packedInput.positionCS.xy).x;
			#else
				float depth = LoadSceneDepth(packedInput.positionCS.xy);
			#endif
			#else
			#if _RENDER_PASS_ENABLED
				float depth = lerp(UNITY_NEAR_CLIP_VALUE, 1, LOAD_FRAMEBUFFER_X_INPUT(GBUFFER3, packedInput.positionCS.xy));
			#else
			    // Adjust z to match NDC for OpenGL
				float depth = lerp(UNITY_NEAR_CLIP_VALUE, 1, LoadSceneDepth(packedInput.positionCS.xy));
			#endif
			#endif
			#endif

			#if defined(DECAL_RECONSTRUCT_NORMAL)
				#if defined(_RENDER_PASS_ENABLED)
					half3 normalWS = half3(ReconstructNormalDerivative(packedInput.positionCS.xy, LOAD_FRAMEBUFFER_X_INPUT(GBUFFER3, packedInput.positionCS.xy).x));
				#elif defined(_DECAL_NORMAL_BLEND_HIGH)
					half3 normalWS = half3(ReconstructNormalTap9(packedInput.positionCS.xy));
				#elif defined(_DECAL_NORMAL_BLEND_MEDIUM)
					half3 normalWS = half3(ReconstructNormalTap5(packedInput.positionCS.xy));
				#else
					half3 normalWS = half3(ReconstructNormalDerivative(packedInput.positionCS.xy));
				#endif
			#elif defined(DECAL_LOAD_NORMAL)
				#if defined(_RENDER_PASS_ENABLED)
				half3 normalWS = normalize(LOAD_FRAMEBUFFER_X_INPUT(GBUFFER2, packedInput.positionCS.xy).rgb);
				#else
				half3 normalWS = normalize(LoadSceneNormals(packedInput.positionCS.xy).rgb);
				#endif
			#endif

				float2 positionSS = FoveatedRemapNonUniformToLinearCS(packedInput.positionCS.xy) * _ScreenSize.zw;

				float4 positionCS = ComputeClipSpacePosition( positionSS, depth );
				float4 hpositionVS = mul( UNITY_MATRIX_I_P, positionCS );

				float4 ScreenPosNorm = float4( positionSS, positionCS.zw );
				float4 ClipPos = positionCS * packedInput.positionCS.w;
				float4 ScreenPos = ComputeScreenPos( ClipPos );
				float3 PositionRWS = mul( ( float3x3 )UNITY_MATRIX_I_V, hpositionVS.xyz / hpositionVS.w );
				float3 PositionWS = PositionRWS + _WorldSpaceCameraPos;
				float3 PositionOS = TransformWorldToObject( PositionWS );
				float3 PositionVS = TransformWorldToView( PositionWS );

				float3 positionDS = TransformWorldToObject(PositionWS);
				positionDS = positionDS * float3(1.0, -1.0, 1.0);

				float clipValue = 0.5 - Max3(abs(positionDS).x, abs(positionDS).y, abs(positionDS).z);
				clip(clipValue);

				float2 texCoord = positionDS.xz + float2(0.5, 0.5);

				float4x4 normalToWorld = UNITY_ACCESS_INSTANCED_PROP(Decal, _NormalToWorld);
				float2 scale = float2(normalToWorld[3][0], normalToWorld[3][1]);
				float2 offset = float2(normalToWorld[3][2], normalToWorld[3][3]);
				texCoord.xy = texCoord.xy * scale + offset;

				float2 texCoord0 = texCoord;
				float2 texCoord1 = texCoord;
				float2 texCoord2 = texCoord;
				float2 texCoord3 = texCoord;

				float3 worldTangent = TransformObjectToWorldDir(float3(1, 0, 0));
				float3 worldNormal = TransformObjectToWorldDir(float3(0, 1, 0));
				float3 worldBitangent = TransformObjectToWorldDir(float3(0, 0, 1));

			#ifdef DECAL_ANGLE_FADE
				half2 angleFade = half2(normalToWorld[1][3], normalToWorld[2][3]);

				if (angleFade.y < 0.0f)
				{
					half3 decalNormal = half3(normalToWorld[0].z, normalToWorld[1].z, normalToWorld[2].z);
					half dotAngle = dot(normalWS, decalNormal);
					angleFadeFactor = saturate(angleFade.x + angleFade.y * (dotAngle * (dotAngle - 2.0)));
				}
			#endif

				half3 viewDirectionWS = half3(packedInput.viewDirectionWS);
				DecalSurfaceData surfaceData;

				SurfaceDescription surfaceDescription = (SurfaceDescription)0;

				float temp_output_1307_0 = radians( _Rotation );
				float temp_output_1301_0 = cos( temp_output_1307_0 );
				float2 break1305 = ( texCoord0 - float2( 0.5,0.5 ) );
				float temp_output_1300_0 = sin( temp_output_1307_0 );
				float2 appendResult1295 = (float2(( ( temp_output_1301_0 * break1305.x ) + ( temp_output_1300_0 * break1305.y ) ) , ( ( temp_output_1301_0 * break1305.y ) - ( temp_output_1300_0 * break1305.x ) )));
				float2 temp_output_1353_0 = (_BaseColorMap_ST).xy;
				float2 _Vector0 = float2(0.5,0.5);
				// *** BEGIN Flipbook UV Animation vars ***
				// Total tiles of Flipbook Texture
				float fbtotaltiles1358 = min( _FlipbookColumns * _FlipbookRows, 9.0 + 1 );
				// Offsets for cols and rows of Flipbook Texture
				float fbcolsoffset1358 = 1.0f / _FlipbookColumns;
				float fbrowsoffset1358 = 1.0f / _FlipbookRows;
				// Speed of animation
				float fbspeed1358 = _Time[ 1 ] * _FlipbookSpeed;
				// UV Tiling (col and row offset)
				float2 fbtiling1358 = float2(fbcolsoffset1358, fbrowsoffset1358);
				// UV Offset - calculate current tile linear index, and convert it to (X * coloffset, Y * rowoffset)
				// Calculate current tile linear index
				float fbcurrenttileindex1358 = floor( fmod( fbspeed1358 + _FlipbookID, fbtotaltiles1358) );
				fbcurrenttileindex1358 += ( fbcurrenttileindex1358 < 0) ? fbtotaltiles1358 : 0;
				// Obtain Offset X coordinate from current tile linear index
				float fblinearindextox1358 = round ( fmod ( fbcurrenttileindex1358, _FlipbookColumns ) );
				// Reverse X animation if speed is negative
				fblinearindextox1358 = (_FlipbookSpeed > 0 ? fblinearindextox1358 : (int)_FlipbookColumns - fblinearindextox1358);
				// Multiply Offset X by coloffset
				float fboffsetx1358 = fblinearindextox1358 * fbcolsoffset1358;
				// Obtain Offset Y coordinate from current tile linear index
				float fblinearindextoy1358 = round( fmod( ( fbcurrenttileindex1358 - fblinearindextox1358 ) / _FlipbookColumns, _FlipbookRows ) );
				// Reverse Y to get tiles from Top to Bottom and Reverse Y animation if speed is negative
				fblinearindextoy1358 = (_FlipbookSpeed <  0 ? fblinearindextoy1358 : (int)_FlipbookRows - fblinearindextoy1358);
				// Multiply Offset Y by rowoffset
				float fboffsety1358 = fblinearindextoy1358 * fbrowsoffset1358;
				// UV Offset
				float2 fboffset1358 = float2(fboffsetx1358, fboffsety1358);
				// Flipbook UV
				float2 fbuv1358 = ( ( ( ( appendResult1295 * temp_output_1353_0 ) + float2( 0.5,0.5 ) ) + (_BaseColorMap_ST).zw ) - ( ( ( temp_output_1353_0 / 1.0 ) * _Vector0 ) - _Vector0 ) ) * fbtiling1358 + fboffset1358;
				// *** END Flipbook UV Animation vars ***
				int flipbookFrame1358 = ( ( int )fbcurrenttileindex1358);
				float2 temp_output_1490_0 = ddx( fbuv1358 );
				float2 temp_output_1491_0 = ddy( fbuv1358 );
				float temp_output_410_0 = ( _ParallaxAmplitude * 0.001 );
				float3 tanToWorld0 = float3( worldTangent.x, worldBitangent.x, worldNormal.x );
				float3 tanToWorld1 = float3( worldTangent.y, worldBitangent.y, worldNormal.y );
				float3 tanToWorld2 = float3( worldTangent.z, worldBitangent.z, worldNormal.z );
				float3 ase_viewVectorTS =  tanToWorld0 * ( _WorldSpaceCameraPos.xyz - PositionWS ).x + tanToWorld1 * ( _WorldSpaceCameraPos.xyz - PositionWS ).y  + tanToWorld2 * ( _WorldSpaceCameraPos.xyz - PositionWS ).z;
				float2 Offset1512 = ( ( SAMPLE_TEXTURE2D_GRAD( _ParallaxMap, sampler_ParallaxMap, fbuv1358, temp_output_1490_0, temp_output_1491_0 ).r - 1 ) * ase_viewVectorTS.xy * temp_output_410_0 ) + fbuv1358;
				float2 Offset1554 = ( ( SAMPLE_TEXTURE2D_GRAD( _ParallaxMap, sampler_ParallaxMap, fbuv1358, temp_output_1490_0, temp_output_1491_0 ).r - 1 ) * ase_viewVectorTS.xy * temp_output_410_0 ) + Offset1512;
				float2 Offset1605 = ( ( SAMPLE_TEXTURE2D_GRAD( _ParallaxMap, sampler_ParallaxMap, fbuv1358, temp_output_1490_0, temp_output_1491_0 ).r - 1 ) * ase_viewVectorTS.xy * temp_output_410_0 ) + Offset1554;
				float2 Offset1606 = ( ( SAMPLE_TEXTURE2D_GRAD( _ParallaxMap, sampler_ParallaxMap, fbuv1358, temp_output_1490_0, temp_output_1491_0 ).r - 1 ) * ase_viewVectorTS.xy * temp_output_410_0 ) + Offset1605;
				float2 lerpResult1376 = lerp( fbuv1358 , Offset1606 , _EnableParallax);
				float2 UV1050 = lerpResult1376;
				float2 UV_DDX1265 = temp_output_1490_0;
				float2 UV_DDY1266 = temp_output_1491_0;
				float4 tex2DNode445 = SAMPLE_TEXTURE2D_GRAD( _BaseColorMap, sampler_BaseColorMap, UV1050, UV_DDX1265, UV_DDY1266 );
				float3 BaseColor554 = ( (tex2DNode445).rgb * (_BaseColor).rgb );
				
				float BaseColorMap_Alpha631 = tex2DNode445.a;
				float temp_output_523_0 = ( BaseColorMap_Alpha631 * ( 1.0 - _DecalOpacity ) );
				float3 temp_output_702_0 = ( PositionOS + float3( 0.5,0.5,0.5 ) );
				float temp_output_698_0 = saturate( ( ( _HeightScale * ( temp_output_702_0 * ( 1.0 - temp_output_702_0 ) ).y ) + _HeightOffset ) );
				float smoothstepResult705 = smoothstep( temp_output_698_0 , ( temp_output_698_0 + 0.001 ) , ( SAMPLE_TEXTURE2D_GRAD( _ParallaxMap, sampler_ParallaxMap, UV1050, UV_DDX1265, UV_DDY1266 ).r * SAMPLE_TEXTURE2D_GRAD( _ParallaxMap, sampler_ParallaxMap, UV1050, UV_DDX1265, UV_DDY1266 ).r ));
				float Height746 = smoothstepResult705;
				float lerpResult1383 = lerp( temp_output_523_0 , ( temp_output_523_0 * Height746 ) , _EnableHeight);
				float Alpha635 = lerpResult1383;
				
				float3 unpack444 = UnpackNormalScale( SAMPLE_TEXTURE2D_GRAD( _NormalMap, sampler_NormalMap, UV1050, UV_DDX1265, UV_DDY1266 ), _NormalScale );
				unpack444.z = lerp( 1, unpack444.z, saturate(_NormalScale) );
				float3 Normal556 = unpack444;
				
				float m_switch857 = _NormalOpacityChannel;
				float m_BaseColorMapAlpha857 = temp_output_523_0;
				float4 tex2DNode607 = SAMPLE_TEXTURE2D_GRAD( _MaskMap, sampler_BaseColorMap, UV1050, UV_DDX1265, UV_DDY1266 );
				float Opacity_Mask632 = tex2DNode607.b;
				float m_MaskMapBlue857 = ( _DecalMaskMapBlueScale1 * Opacity_Mask632 );
				float local_SwitchNormalOpacity857 = _SwitchNormalOpacity( m_switch857 , m_BaseColorMapAlpha857 , m_MaskMapBlue857 );
				float lerpResult1382 = lerp( local_SwitchNormalOpacity857 , ( local_SwitchNormalOpacity857 * Height746 ) , _EnableHeight);
				float Alpha_Normal636 = lerpResult1382;
				
				float Metallic624 = ( _MaskmapMetal * tex2DNode607.r );
				
				float Occlusion626 = saturate( ( ( 1.0 - _MaskmapAO ) * tex2DNode607.g ) );
				
				float Smoothness625 = ( _MaskmapSmoothness * tex2DNode607.a );
				
				float m_switch858 = _MaskOpacityChannel;
				float m_BaseColorMapAlpha858 = temp_output_523_0;
				float m_MaskMapBlue858 = ( _DecalMaskMapBlueScale1 * Opacity_Mask632 );
				float local_SwitchMaskOpacity858 = _SwitchMaskOpacity( m_switch858 , m_BaseColorMapAlpha858 , m_MaskMapBlue858 );
				float lerpResult1381 = lerp( local_SwitchMaskOpacity858 , ( local_SwitchMaskOpacity858 * Height746 ) , _EnableHeight);
				float Alpha_MSO637 = lerpResult1381;
				
				float3 color1672 = IsGammaSpace() ? float3( 0, 0, 0 ) : float3( 0, 0, 0 );
				float2 UV_Parallax_Off1456 = fbuv1358;
				float temp_output_2_0_g61768 = _AlbedoAffectEmissive;
				float temp_output_3_0_g61768 = ( 1.0 - temp_output_2_0_g61768 );
				float3 appendResult7_g61768 = (float3(temp_output_3_0_g61768 , temp_output_3_0_g61768 , temp_output_3_0_g61768));
				float3 lerpResult1671 = lerp( color1672 , ( (SAMPLE_TEXTURE2D_GRAD( _EmissiveColorMap, sampler_EmissiveColorMap, UV_Parallax_Off1456, UV_DDX1265, UV_DDY1266 )).rgb * ( ( _EmissiveColor * _EmissiveIntensity ) * ( ( BaseColor554 * temp_output_2_0_g61768 ) + appendResult7_g61768 ) ) ) , _AffectEmission);
				float3 Emissive558 = lerpResult1671;
				

				surfaceDescription.BaseColor = BaseColor554;
				surfaceDescription.Alpha = Alpha635;
				surfaceDescription.NormalTS = Normal556;
				surfaceDescription.NormalAlpha = Alpha_Normal636;

			#if defined( _MATERIAL_AFFECTS_MAOS )
				surfaceDescription.Metallic = Metallic624;
				surfaceDescription.Occlusion =Occlusion626;
				surfaceDescription.Smoothness = Smoothness625;
				surfaceDescription.MAOSAlpha = Alpha_MSO637;
			#endif

			#if defined( _MATERIAL_AFFECTS_EMISSION )
				surfaceDescription.Emission = Emissive558;
			#endif

				GetSurfaceData(surfaceDescription, angleFadeFactor, surfaceData);

				// Need to reconstruct normal here for inputData.bakedGI, but also save off surfaceData.normalWS for correct GBuffer blending
				half3 normalToPack = surfaceData.normalWS.xyz;

			#ifdef DECAL_RECONSTRUCT_NORMAL
				surfaceData.normalWS.xyz = normalize(lerp(normalWS.xyz, surfaceData.normalWS.xyz, surfaceData.normalWS.w));
			#endif

				InputData inputData;
				InitializeInputData(packedInput, PositionWS, surfaceData.normalWS.xyz, viewDirectionWS, inputData);

				SurfaceData surface = (SurfaceData)0;
				GetSurface(surfaceData, surface);

				BRDFData brdfData;
				InitializeBRDFData(surface.albedo, surface.metallic, 0, surface.smoothness, surface.alpha, brdfData);

            // Skip GI if there is no abledo
			#ifdef _MATERIAL_AFFECTS_ALBEDO
				Light mainLight = GetMainLight(inputData.shadowCoord, inputData.positionWS, inputData.shadowMask);
				MixRealtimeAndBakedGI(mainLight, surfaceData.normalWS.xyz, inputData.bakedGI, inputData.shadowMask);
				half3 color = GlobalIllumination(brdfData, inputData.bakedGI, surface.occlusion, surfaceData.normalWS.xyz, inputData.viewDirectionWS);
			#else
				half3 color = 0;
			#endif

				// ShaderPassDecal.hlsl
				// We can not use usual GBuffer functions (etc. BRDFDataToGbuffer) as we use alpha for blending
				#pragma warning (disable : 3578) // The output value isn't completely initialized.
				half3 packedNormalWS = PackGBufferNormal(surfaceData.normalWS.xyz);
				fragmentOutput = (GBufferFragOutput)0;
				fragmentOutput.gBuffer0 = half4(surfaceData.baseColor.rgb, surfaceData.baseColor.a);
				fragmentOutput.gBuffer1 = 0;
				fragmentOutput.gBuffer2 = half4(packedNormalWS, surfaceData.normalWS.a);
				fragmentOutput.color = half4(surfaceData.emissive + color, surfaceData.baseColor.a);

			#if defined(GBUFFER_FEATURE_SHADOWMASK)
				fragmentOutput.shadowMask = inputData.shadowMask; // will have unity_ProbesOcclusion value if subtractive lighting is used (baked)
			#endif

			#pragma warning (default : 3578) // Restore output value isn't completely initialized.

			#if defined(DECAL_FORWARD_EMISSIVE)
				// Emissive need to be pre-exposed
				outEmissive.rgb = surfaceData.emissive * GetCurrentExposureMultiplier();
				outEmissive.a = surfaceData.baseColor.a;
			#endif

			}
            ENDHLSL
        }

		
        Pass
        {
            
			Name "DBufferMesh"
            Tags { "LightMode"="DBufferMesh" }

			Blend 0 SrcAlpha OneMinusSrcAlpha, Zero OneMinusSrcAlpha
			Blend 1 SrcAlpha OneMinusSrcAlpha, Zero OneMinusSrcAlpha
			Blend 2 SrcAlpha OneMinusSrcAlpha, Zero OneMinusSrcAlpha
			ZTest LEqual
			ZWrite Off
			ColorMask RGBA
			ColorMask RGBA 1
			ColorMask RGBA 2

			HLSLPROGRAM

			#define _MATERIAL_AFFECTS_ALBEDO 1
			#define _MATERIAL_AFFECTS_NORMAL 1
			#define _MATERIAL_AFFECTS_NORMAL_BLEND 1
			#define  _MATERIAL_AFFECTS_MAOS 1
			#define _MATERIAL_AFFECTS_EMISSION 1
			#pragma multi_compile_fragment _ LOD_FADE_CROSSFADE
			#define ASE_VERSION 19907
			#define ASE_SRP_VERSION 170300
			#define ASE_USING_SAMPLING_MACROS 1


			#pragma vertex Vert
			#pragma fragment Frag
			#pragma multi_compile_instancing
			#pragma editor_sync_compilation

			#pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
			#pragma multi_compile _ _DECAL_LAYERS

            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define ATTRIBUTES_NEED_TEXCOORD2
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_NORMAL_WS
            #define VARYINGS_NEED_TANGENT_WS
            #define VARYINGS_NEED_TEXCOORD0

            #define HAVE_MESH_MODIFICATION

            #define SHADERPASS SHADERPASS_DBUFFER_MESH

			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Fog.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
            #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ProbeVolumeVariants.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DecalInput.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderVariablesDecal.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"

			#if defined(LOD_FADE_CROSSFADE)
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
            #endif

            #if _RENDER_PASS_ENABLED
            #define GBUFFER3 0
            FRAMEBUFFER_INPUT_X_FLOAT(GBUFFER3);
            #define GBUFFER4 1
            FRAMEBUFFER_INPUT_X_UINT(GBUFFER4);
            #endif

            #define ASE_NEEDS_TEXTURE_COORDINATES0
            #define ASE_NEEDS_FRAG_TEXTURE_COORDINATES0
            #define ASE_NEEDS_WORLD_POSITION
            #define ASE_NEEDS_FRAG_WORLD_POSITION
            #define ASE_NEEDS_WORLD_TANGENT
            #define ASE_NEEDS_FRAG_WORLD_TANGENT
            #define ASE_NEEDS_WORLD_NORMAL
            #define ASE_NEEDS_FRAG_WORLD_NORMAL
            #define ASE_NEEDS_VERT_NORMAL
            #define ASE_NEEDS_VERT_TANGENT


			struct SurfaceDescription
			{
				float3 BaseColor;
				float Alpha;
				float3 NormalTS;
				float NormalAlpha;
				float Metallic;
				float Occlusion;
				float Smoothness;
				float MAOSAlpha;
			};

			struct Attributes
			{
				float3 positionOS : POSITION;
				float3 normalOS : NORMAL;
				float4 tangentOS : TANGENT;
				float4 uv0 : TEXCOORD0;
				float4 uv1 : TEXCOORD1;
				float4 uv2 : TEXCOORD2;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct PackedVaryings
			{
				float4 positionCS : SV_POSITION;
				float3 positionWS : TEXCOORD0;
				float3 normalWS : TEXCOORD1;
				float4 tangentWS : TEXCOORD2;
				float4 texCoord0 : TEXCOORD3;
				float4 ase_texcoord4 : TEXCOORD4;
				float4 ase_texcoord5 : TEXCOORD5;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

            CBUFFER_START(UnityPerMaterial)
			float4 _BaseColorMap_ST;
			float4 _BaseColor;
			float3 _EmissiveColor;
			float _Rotation;
			half _EmissiveIntensity;
			float _MaskOpacityChannel;
			half _MaskmapSmoothness;
			half _MaskmapAO;
			half _MaskmapMetal;
			float _DecalMaskMapBlueScale1;
			float _NormalOpacityChannel;
			float _NormalScale;
			float _HeightOffset;
			float _AlbedoAffectEmissive;
			float _HeightScale;
			half _DecalOpacity;
			float _EnableParallax;
			float _ParallaxAmplitude;
			half _FlipbookID;
			half _FlipbookSpeed;
			half _FlipbookRows;
			half _FlipbookColumns;
			float _EnableHeight;
			float _AffectEmission;
			float _DrawOrder;
			float _DecalMeshBiasType;
			float _DecalMeshDepthBias;
			float _DecalMeshViewBias;
			#if defined(DECAL_ANGLE_FADE)
			float _DecalAngleFadeSupported;
			#endif
			UNITY_TEXTURE_STREAMING_DEBUG_VARS;
			CBUFFER_END

            #ifdef SCENEPICKINGPASS
				float4 _SelectionID;
            #endif

            #ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
            #endif

			TEXTURE2D(_BaseColorMap);
			TEXTURE2D(_ParallaxMap);
			SAMPLER(sampler_ParallaxMap);
			SAMPLER(sampler_BaseColorMap);
			TEXTURE2D(_NormalMap);
			SAMPLER(sampler_NormalMap);
			TEXTURE2D(_MaskMap);


			float _SwitchNormalOpacity( float m_switch, float m_BaseColorMapAlpha, float m_MaskMapBlue )
			{
				if(m_switch ==0)
					return m_BaseColorMapAlpha;
				else if(m_switch ==1)
					return m_MaskMapBlue;
				else
				return float(0);
			}
			
			float _SwitchMaskOpacity( float m_switch, float m_BaseColorMapAlpha, float m_MaskMapBlue )
			{
				if(m_switch ==0)
					return m_BaseColorMapAlpha;
				else if(m_switch ==1)
					return m_MaskMapBlue;
				else
				return float(0);
			}
			

            void GetSurfaceData(PackedVaryings input, SurfaceDescription surfaceDescription, out DecalSurfaceData surfaceData)
            {
                #if defined(LOD_FADE_CROSSFADE)
					LODFadeCrossFade( input.positionCS );
                #endif

                half fadeFactor = half(1.0);

                ZERO_INITIALIZE(DecalSurfaceData, surfaceData);
                surfaceData.occlusion = half(1.0);
                surfaceData.smoothness = half(0);

                #ifdef _MATERIAL_AFFECTS_NORMAL
                    surfaceData.normalWS.w = half(1.0);
                #else
                    surfaceData.normalWS.w = half(0.0);
                #endif

                surfaceData.baseColor.xyz = half3(surfaceDescription.BaseColor);
                surfaceData.baseColor.w = half(surfaceDescription.Alpha * fadeFactor);

                #if (SHADERPASS == SHADERPASS_DBUFFER_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_PROJECTOR)
                    #if defined(_MATERIAL_AFFECTS_NORMAL)
						surfaceData.normalWS.xyz = normalize(mul((half3x3)normalToWorld, surfaceDescription.NormalTS.xyz));
                    #else
						surfaceData.normalWS.xyz = normalize(normalToWorld[2].xyz);
                    #endif
                #elif (SHADERPASS == SHADERPASS_DBUFFER_MESH) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_MESH) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_MESH)
                    #if defined(_MATERIAL_AFFECTS_NORMAL)
                        float sgn = input.tangentWS.w;
                        float3 bitangent = sgn * cross(input.normalWS.xyz, input.tangentWS.xyz);
                        half3x3 tangentToWorld = half3x3(input.tangentWS.xyz, bitangent.xyz, input.normalWS.xyz);
                        surfaceData.normalWS.xyz = normalize(TransformTangentToWorld(surfaceDescription.NormalTS, tangentToWorld));
                    #else
						surfaceData.normalWS.xyz = normalize(half3(input.normalWS));
                    #endif
                #endif

                surfaceData.normalWS.w = surfaceDescription.NormalAlpha * fadeFactor;

				#if defined( _MATERIAL_AFFECTS_MAOS )
					surfaceData.metallic = half(surfaceDescription.Metallic);
					surfaceData.occlusion = half(surfaceDescription.Occlusion);
					surfaceData.smoothness = half(surfaceDescription.Smoothness);
					surfaceData.MAOSAlpha = half(surfaceDescription.MAOSAlpha * fadeFactor);
				#endif
            }

            #if (SHADERPASS == SHADERPASS_DBUFFER_PROJECTOR) || (SHADERPASS == SHADERPASS_FORWARD_EMISSIVE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_PROJECTOR)
            #define DECAL_PROJECTOR
            #endif

            #if (SHADERPASS == SHADERPASS_DBUFFER_MESH) || (SHADERPASS == SHADERPASS_FORWARD_EMISSIVE_MESH) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_MESH) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_MESH)
            #define DECAL_MESH
            #endif

            #if (SHADERPASS == SHADERPASS_DBUFFER_PROJECTOR) || (SHADERPASS == SHADERPASS_DBUFFER_MESH)
            #define DECAL_DBUFFER
            #endif

            #if (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_MESH)
            #define DECAL_SCREEN_SPACE
            #endif

            #if (SHADERPASS == SHADERPASS_DECAL_GBUFFER_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_MESH)
            #define DECAL_GBUFFER
            #endif

            #if (SHADERPASS == SHADERPASS_FORWARD_EMISSIVE_PROJECTOR) || (SHADERPASS == SHADERPASS_FORWARD_EMISSIVE_MESH)
            #define DECAL_FORWARD_EMISSIVE
            #endif

            #if ((!defined(_MATERIAL_AFFECTS_NORMAL) && defined(_MATERIAL_AFFECTS_ALBEDO)) || (defined(_MATERIAL_AFFECTS_NORMAL) && defined(_MATERIAL_AFFECTS_NORMAL_BLEND))) && (defined(DECAL_SCREEN_SPACE) || defined(DECAL_GBUFFER))
            #define DECAL_RECONSTRUCT_NORMAL
            #elif defined(DECAL_ANGLE_FADE)
            #define DECAL_LOAD_NORMAL
            #endif

            #ifdef _DECAL_LAYERS
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DeclareRenderingLayerTexture.hlsl"
            #endif

            #if defined(DECAL_LOAD_NORMAL)
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DeclareNormalsTexture.hlsl"
            #endif

            #if defined(DECAL_PROJECTOR) || defined(DECAL_RECONSTRUCT_NORMAL)
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DeclareDepthTexture.hlsl"
            #endif

            #ifdef DECAL_MESH
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DecalMeshBiasTypeEnum.cs.hlsl"
            #endif

            #ifdef DECAL_RECONSTRUCT_NORMAL
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/NormalReconstruction.hlsl"
            #endif

			void MeshDecalsPositionZBias(inout PackedVaryings input)
			{
            #if UNITY_REVERSED_Z
				input.positionCS.z -= _DecalMeshDepthBias;
            #else
				input.positionCS.z += _DecalMeshDepthBias;
            #endif
			}

			PackedVaryings Vert(Attributes inputMesh  )
			{
				if (_DecalMeshBiasType == DECALMESHDEPTHBIASTYPE_VIEW_BIAS)
				{
					float3 viewDirectionOS = GetObjectSpaceNormalizeViewDir(inputMesh.positionOS);
					inputMesh.positionOS += viewDirectionOS * (_DecalMeshViewBias);
				}

				PackedVaryings packedOutput;
				ZERO_INITIALIZE(PackedVaryings, packedOutput);

				UNITY_SETUP_INSTANCE_ID(inputMesh);
				UNITY_TRANSFER_INSTANCE_ID(inputMesh, packedOutput);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(packedOutput);

				float3 ase_normalWS = TransformObjectToWorldNormal( inputMesh.normalOS );
				float3 ase_tangentWS = TransformObjectToWorldDir( inputMesh.tangentOS.xyz );
				float ase_tangentSign = inputMesh.tangentOS.w * ( unity_WorldTransformParams.w >= 0.0 ? 1.0 : -1.0 );
				float3 ase_bitangentWS = cross( ase_normalWS, ase_tangentWS ) * ase_tangentSign;
				packedOutput.ase_texcoord4.xyz = ase_bitangentWS;
				
				packedOutput.ase_texcoord5 = float4(inputMesh.positionOS,1);
				
				//setting value to unused interpolator channels and avoid initialization warnings
				packedOutput.ase_texcoord4.w = 0;

				VertexPositionInputs vertexInput = GetVertexPositionInputs(inputMesh.positionOS.xyz);

				float3 positionWS = TransformObjectToWorld(inputMesh.positionOS);

				float3 normalWS = TransformObjectToWorldNormal(inputMesh.normalOS);
				float4 tangentWS = float4(TransformObjectToWorldDir(inputMesh.tangentOS.xyz), inputMesh.tangentOS.w);

				packedOutput.positionWS.xyz =  positionWS;
				packedOutput.normalWS.xyz =  normalWS;
				packedOutput.tangentWS.xyzw =  tangentWS;
				packedOutput.texCoord0.xyzw =  inputMesh.uv0;
				packedOutput.positionCS = TransformWorldToHClip(positionWS);

				if (_DecalMeshBiasType == DECALMESHDEPTHBIASTYPE_DEPTH_BIAS)
				{
					MeshDecalsPositionZBias(packedOutput);
				}

				return packedOutput;
			}

			void Frag(PackedVaryings packedInput,
				OUTPUT_DBUFFER(outDBuffer)
				
			)
			{
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(packedInput);
				UNITY_SETUP_INSTANCE_ID(packedInput);

				half angleFadeFactor = 1.0;

            // Only screen space needs flip logic, other passes do not setup needed properties so we skip here
            #if defined(DECAL_SCREEN_SPACE)
				TransformScreenUV(packedInput.positionCS, _ScreenSize.y);
            #endif

            #ifdef _DECAL_LAYERS
            #ifdef _RENDER_PASS_ENABLED
				uint surfaceRenderingLayer = LOAD_FRAMEBUFFER_X_INPUT(GBUFFER4, packedInput.positionCS.xy).r;
            #else
				uint surfaceRenderingLayer = LoadSceneRenderingLayer(packedInput.positionCS.xy);
            #endif
				uint projectorRenderingLayer = asuint(UNITY_ACCESS_INSTANCED_PROP(Decal, _DecalLayerMaskFromDecal));
				clip((surfaceRenderingLayer & projectorRenderingLayer) - 0.1);
            #endif

			#if defined(DECAL_PROJECTOR)
			#if UNITY_REVERSED_Z
			#if _RENDER_PASS_ENABLED
				float depth = LOAD_FRAMEBUFFER_X_INPUT(GBUFFER3, packedInput.positionCS.xy).x;
			#else
				float depth = LoadSceneDepth(packedInput.positionCS.xy);
			#endif
			#else
			#if _RENDER_PASS_ENABLED
				float depth = lerp(UNITY_NEAR_CLIP_VALUE, 1, LOAD_FRAMEBUFFER_X_INPUT(GBUFFER3, packedInput.positionCS.xy));
			#else
			    // Adjust z to match NDC for OpenGL
				float depth = lerp(UNITY_NEAR_CLIP_VALUE, 1, LoadSceneDepth(packedInput.positionCS.xy));
			#endif
			#endif
			#endif

			#if defined(DECAL_RECONSTRUCT_NORMAL)
				#if defined(_RENDER_PASS_ENABLED)
					half3 normalWS = half3(ReconstructNormalDerivative(packedInput.positionCS.xy, LOAD_FRAMEBUFFER_X_INPUT(GBUFFER3, packedInput.positionCS.xy).x));
				#elif defined(_DECAL_NORMAL_BLEND_HIGH)
					half3 normalWS = half3(ReconstructNormalTap9(packedInput.positionCS.xy));
				#elif defined(_DECAL_NORMAL_BLEND_MEDIUM)
					half3 normalWS = half3(ReconstructNormalTap5(packedInput.positionCS.xy));
				#else
					half3 normalWS = half3(ReconstructNormalDerivative(packedInput.positionCS.xy));
				#endif
			#elif defined(DECAL_LOAD_NORMAL)
				#if defined(_RENDER_PASS_ENABLED)
				half3 normalWS = normalize(LOAD_FRAMEBUFFER_X_INPUT(GBUFFER2, packedInput.positionCS.xy).rgb);
				#else
				half3 normalWS = normalize(LoadSceneNormals(packedInput.positionCS.xy).rgb);
				#endif
			#endif

				float2 positionSS = FoveatedRemapNonUniformToLinearCS(packedInput.positionCS.xy) * _ScreenSize.zw;

				float3 positionWS = packedInput.positionWS.xyz;
				half3 viewDirectionWS = half3(1.0, 1.0, 1.0);

				DecalSurfaceData surfaceData;
				SurfaceDescription surfaceDescription;

				float temp_output_1307_0 = radians( _Rotation );
				float temp_output_1301_0 = cos( temp_output_1307_0 );
				float2 break1305 = ( packedInput.texCoord0.xy - float2( 0.5,0.5 ) );
				float temp_output_1300_0 = sin( temp_output_1307_0 );
				float2 appendResult1295 = (float2(( ( temp_output_1301_0 * break1305.x ) + ( temp_output_1300_0 * break1305.y ) ) , ( ( temp_output_1301_0 * break1305.y ) - ( temp_output_1300_0 * break1305.x ) )));
				float2 temp_output_1353_0 = (_BaseColorMap_ST).xy;
				float2 _Vector0 = float2(0.5,0.5);
				// *** BEGIN Flipbook UV Animation vars ***
				// Total tiles of Flipbook Texture
				float fbtotaltiles1358 = min( _FlipbookColumns * _FlipbookRows, 9.0 + 1 );
				// Offsets for cols and rows of Flipbook Texture
				float fbcolsoffset1358 = 1.0f / _FlipbookColumns;
				float fbrowsoffset1358 = 1.0f / _FlipbookRows;
				// Speed of animation
				float fbspeed1358 = _Time[ 1 ] * _FlipbookSpeed;
				// UV Tiling (col and row offset)
				float2 fbtiling1358 = float2(fbcolsoffset1358, fbrowsoffset1358);
				// UV Offset - calculate current tile linear index, and convert it to (X * coloffset, Y * rowoffset)
				// Calculate current tile linear index
				float fbcurrenttileindex1358 = floor( fmod( fbspeed1358 + _FlipbookID, fbtotaltiles1358) );
				fbcurrenttileindex1358 += ( fbcurrenttileindex1358 < 0) ? fbtotaltiles1358 : 0;
				// Obtain Offset X coordinate from current tile linear index
				float fblinearindextox1358 = round ( fmod ( fbcurrenttileindex1358, _FlipbookColumns ) );
				// Reverse X animation if speed is negative
				fblinearindextox1358 = (_FlipbookSpeed > 0 ? fblinearindextox1358 : (int)_FlipbookColumns - fblinearindextox1358);
				// Multiply Offset X by coloffset
				float fboffsetx1358 = fblinearindextox1358 * fbcolsoffset1358;
				// Obtain Offset Y coordinate from current tile linear index
				float fblinearindextoy1358 = round( fmod( ( fbcurrenttileindex1358 - fblinearindextox1358 ) / _FlipbookColumns, _FlipbookRows ) );
				// Reverse Y to get tiles from Top to Bottom and Reverse Y animation if speed is negative
				fblinearindextoy1358 = (_FlipbookSpeed <  0 ? fblinearindextoy1358 : (int)_FlipbookRows - fblinearindextoy1358);
				// Multiply Offset Y by rowoffset
				float fboffsety1358 = fblinearindextoy1358 * fbrowsoffset1358;
				// UV Offset
				float2 fboffset1358 = float2(fboffsetx1358, fboffsety1358);
				// Flipbook UV
				float2 fbuv1358 = ( ( ( ( appendResult1295 * temp_output_1353_0 ) + float2( 0.5,0.5 ) ) + (_BaseColorMap_ST).zw ) - ( ( ( temp_output_1353_0 / 1.0 ) * _Vector0 ) - _Vector0 ) ) * fbtiling1358 + fboffset1358;
				// *** END Flipbook UV Animation vars ***
				int flipbookFrame1358 = ( ( int )fbcurrenttileindex1358);
				float2 temp_output_1490_0 = ddx( fbuv1358 );
				float2 temp_output_1491_0 = ddy( fbuv1358 );
				float temp_output_410_0 = ( _ParallaxAmplitude * 0.001 );
				float3 ase_bitangentWS = packedInput.ase_texcoord4.xyz;
				float3 tanToWorld0 = float3( packedInput.tangentWS.xyz.x, ase_bitangentWS.x, packedInput.normalWS.x );
				float3 tanToWorld1 = float3( packedInput.tangentWS.xyz.y, ase_bitangentWS.y, packedInput.normalWS.y );
				float3 tanToWorld2 = float3( packedInput.tangentWS.xyz.z, ase_bitangentWS.z, packedInput.normalWS.z );
				float3 ase_viewVectorTS =  tanToWorld0 * ( _WorldSpaceCameraPos.xyz - packedInput.positionWS ).x + tanToWorld1 * ( _WorldSpaceCameraPos.xyz - packedInput.positionWS ).y  + tanToWorld2 * ( _WorldSpaceCameraPos.xyz - packedInput.positionWS ).z;
				float2 Offset1512 = ( ( SAMPLE_TEXTURE2D_GRAD( _ParallaxMap, sampler_ParallaxMap, fbuv1358, temp_output_1490_0, temp_output_1491_0 ).r - 1 ) * ase_viewVectorTS.xy * temp_output_410_0 ) + fbuv1358;
				float2 Offset1554 = ( ( SAMPLE_TEXTURE2D_GRAD( _ParallaxMap, sampler_ParallaxMap, fbuv1358, temp_output_1490_0, temp_output_1491_0 ).r - 1 ) * ase_viewVectorTS.xy * temp_output_410_0 ) + Offset1512;
				float2 Offset1605 = ( ( SAMPLE_TEXTURE2D_GRAD( _ParallaxMap, sampler_ParallaxMap, fbuv1358, temp_output_1490_0, temp_output_1491_0 ).r - 1 ) * ase_viewVectorTS.xy * temp_output_410_0 ) + Offset1554;
				float2 Offset1606 = ( ( SAMPLE_TEXTURE2D_GRAD( _ParallaxMap, sampler_ParallaxMap, fbuv1358, temp_output_1490_0, temp_output_1491_0 ).r - 1 ) * ase_viewVectorTS.xy * temp_output_410_0 ) + Offset1605;
				float2 lerpResult1376 = lerp( fbuv1358 , Offset1606 , _EnableParallax);
				float2 UV1050 = lerpResult1376;
				float2 UV_DDX1265 = temp_output_1490_0;
				float2 UV_DDY1266 = temp_output_1491_0;
				float4 tex2DNode445 = SAMPLE_TEXTURE2D_GRAD( _BaseColorMap, sampler_BaseColorMap, UV1050, UV_DDX1265, UV_DDY1266 );
				float3 BaseColor554 = ( (tex2DNode445).rgb * (_BaseColor).rgb );
				
				float BaseColorMap_Alpha631 = tex2DNode445.a;
				float temp_output_523_0 = ( BaseColorMap_Alpha631 * ( 1.0 - _DecalOpacity ) );
				float3 temp_output_702_0 = ( packedInput.ase_texcoord5.xyz + float3( 0.5,0.5,0.5 ) );
				float temp_output_698_0 = saturate( ( ( _HeightScale * ( temp_output_702_0 * ( 1.0 - temp_output_702_0 ) ).y ) + _HeightOffset ) );
				float smoothstepResult705 = smoothstep( temp_output_698_0 , ( temp_output_698_0 + 0.001 ) , ( SAMPLE_TEXTURE2D_GRAD( _ParallaxMap, sampler_ParallaxMap, UV1050, UV_DDX1265, UV_DDY1266 ).r * SAMPLE_TEXTURE2D_GRAD( _ParallaxMap, sampler_ParallaxMap, UV1050, UV_DDX1265, UV_DDY1266 ).r ));
				float Height746 = smoothstepResult705;
				float lerpResult1383 = lerp( temp_output_523_0 , ( temp_output_523_0 * Height746 ) , _EnableHeight);
				float Alpha635 = lerpResult1383;
				
				float3 unpack444 = UnpackNormalScale( SAMPLE_TEXTURE2D_GRAD( _NormalMap, sampler_NormalMap, UV1050, UV_DDX1265, UV_DDY1266 ), _NormalScale );
				unpack444.z = lerp( 1, unpack444.z, saturate(_NormalScale) );
				float3 Normal556 = unpack444;
				
				float m_switch857 = _NormalOpacityChannel;
				float m_BaseColorMapAlpha857 = temp_output_523_0;
				float4 tex2DNode607 = SAMPLE_TEXTURE2D_GRAD( _MaskMap, sampler_BaseColorMap, UV1050, UV_DDX1265, UV_DDY1266 );
				float Opacity_Mask632 = tex2DNode607.b;
				float m_MaskMapBlue857 = ( _DecalMaskMapBlueScale1 * Opacity_Mask632 );
				float local_SwitchNormalOpacity857 = _SwitchNormalOpacity( m_switch857 , m_BaseColorMapAlpha857 , m_MaskMapBlue857 );
				float lerpResult1382 = lerp( local_SwitchNormalOpacity857 , ( local_SwitchNormalOpacity857 * Height746 ) , _EnableHeight);
				float Alpha_Normal636 = lerpResult1382;
				
				float Metallic624 = ( _MaskmapMetal * tex2DNode607.r );
				
				float Occlusion626 = saturate( ( ( 1.0 - _MaskmapAO ) * tex2DNode607.g ) );
				
				float Smoothness625 = ( _MaskmapSmoothness * tex2DNode607.a );
				
				float m_switch858 = _MaskOpacityChannel;
				float m_BaseColorMapAlpha858 = temp_output_523_0;
				float m_MaskMapBlue858 = ( _DecalMaskMapBlueScale1 * Opacity_Mask632 );
				float local_SwitchMaskOpacity858 = _SwitchMaskOpacity( m_switch858 , m_BaseColorMapAlpha858 , m_MaskMapBlue858 );
				float lerpResult1381 = lerp( local_SwitchMaskOpacity858 , ( local_SwitchMaskOpacity858 * Height746 ) , _EnableHeight);
				float Alpha_MSO637 = lerpResult1381;
				

				surfaceDescription.BaseColor = BaseColor554;
				surfaceDescription.Alpha = Alpha635;
				surfaceDescription.NormalTS = Normal556;
				surfaceDescription.NormalAlpha = Alpha_Normal636;

			#if defined( _MATERIAL_AFFECTS_MAOS )
				surfaceDescription.Metallic = Metallic624;
				surfaceDescription.Occlusion = Occlusion626;
				surfaceDescription.Smoothness = Smoothness625;
				surfaceDescription.MAOSAlpha = Alpha_MSO637;
			#endif

				GetSurfaceData(packedInput, surfaceDescription, surfaceData);
				ENCODE_INTO_DBUFFER(surfaceData, outDBuffer);

			}

            ENDHLSL
        }

		
        Pass
        {
            
			Name "DecalMeshForwardEmissive"
            Tags { "LightMode"="DecalMeshForwardEmissive" }

			Blend 0 SrcAlpha One
			ZTest LEqual
			ZWrite Off

			HLSLPROGRAM

			#define _MATERIAL_AFFECTS_ALBEDO 1
			#define _MATERIAL_AFFECTS_NORMAL 1
			#define _MATERIAL_AFFECTS_NORMAL_BLEND 1
			#define  _MATERIAL_AFFECTS_MAOS 1
			#define _MATERIAL_AFFECTS_EMISSION 1
			#define ASE_VERSION 19907
			#define ASE_SRP_VERSION 170300
			#define ASE_USING_SAMPLING_MACROS 1


			#pragma vertex Vert
			#pragma fragment Frag
			#pragma multi_compile_instancing
			#pragma editor_sync_compilation

			#pragma multi_compile _ _DECAL_LAYERS

            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define ATTRIBUTES_NEED_TEXCOORD2
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_NORMAL_WS
            #define VARYINGS_NEED_TANGENT_WS
            #define VARYINGS_NEED_TEXCOORD0

            #define HAVE_MESH_MODIFICATION

            #define SHADERPASS SHADERPASS_FORWARD_EMISSIVE_MESH

			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Fog.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
            #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ProbeVolumeVariants.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DecalInput.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderVariablesDecal.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"

			#if defined(LOD_FADE_CROSSFADE)
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
            #endif

            #if _RENDER_PASS_ENABLED
            #define GBUFFER3 0
            FRAMEBUFFER_INPUT_X_FLOAT(GBUFFER3);
            #define GBUFFER4 1
            FRAMEBUFFER_INPUT_X_UINT(GBUFFER4);
            #endif

			#define ASE_NEEDS_TEXTURE_COORDINATES0
			#define ASE_NEEDS_FRAG_TEXTURE_COORDINATES0
			#define ASE_NEEDS_WORLD_POSITION
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_NEEDS_WORLD_TANGENT
			#define ASE_NEEDS_FRAG_WORLD_TANGENT
			#define ASE_NEEDS_WORLD_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_NORMAL
			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_VERT_TANGENT


			struct SurfaceDescription
			{
				float3 BaseColor;
				float Alpha;
				float3 NormalTS;
				float NormalAlpha;
				float Metallic;
				float Occlusion;
				float Smoothness;
				float MAOSAlpha;
				float3 Emission;
			};

            struct Attributes
			{
				float3 positionOS : POSITION;
				float3 normalOS : NORMAL;
				float4 tangentOS : TANGENT;
				float4 uv0 : TEXCOORD0;
				float4 uv1 : TEXCOORD1;
				float4 uv2 : TEXCOORD2;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct PackedVaryings
			{
				float4 positionCS : SV_POSITION;
				float3 positionWS : TEXCOORD0;
				float3 normalWS : TEXCOORD1;
				float4 tangentWS : TEXCOORD2;
				float4 texCoord0 : TEXCOORD3;
				float4 ase_texcoord4 : TEXCOORD4;
				float4 ase_texcoord5 : TEXCOORD5;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

            CBUFFER_START(UnityPerMaterial)
			float4 _BaseColorMap_ST;
			float4 _BaseColor;
			float3 _EmissiveColor;
			float _Rotation;
			half _EmissiveIntensity;
			float _MaskOpacityChannel;
			half _MaskmapSmoothness;
			half _MaskmapAO;
			half _MaskmapMetal;
			float _DecalMaskMapBlueScale1;
			float _NormalOpacityChannel;
			float _NormalScale;
			float _HeightOffset;
			float _AlbedoAffectEmissive;
			float _HeightScale;
			half _DecalOpacity;
			float _EnableParallax;
			float _ParallaxAmplitude;
			half _FlipbookID;
			half _FlipbookSpeed;
			half _FlipbookRows;
			half _FlipbookColumns;
			float _EnableHeight;
			float _AffectEmission;
			float _DrawOrder;
			float _DecalMeshBiasType;
			float _DecalMeshDepthBias;
			float _DecalMeshViewBias;
			#if defined(DECAL_ANGLE_FADE)
			float _DecalAngleFadeSupported;
			#endif
			UNITY_TEXTURE_STREAMING_DEBUG_VARS;
			CBUFFER_END

            #ifdef SCENEPICKINGPASS
				float4 _SelectionID;
            #endif

            #ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
            #endif

			TEXTURE2D(_BaseColorMap);
			TEXTURE2D(_ParallaxMap);
			SAMPLER(sampler_ParallaxMap);
			SAMPLER(sampler_BaseColorMap);
			TEXTURE2D(_NormalMap);
			SAMPLER(sampler_NormalMap);
			TEXTURE2D(_MaskMap);
			TEXTURE2D(_EmissiveColorMap);
			SAMPLER(sampler_EmissiveColorMap);


			float _SwitchNormalOpacity( float m_switch, float m_BaseColorMapAlpha, float m_MaskMapBlue )
			{
				if(m_switch ==0)
					return m_BaseColorMapAlpha;
				else if(m_switch ==1)
					return m_MaskMapBlue;
				else
				return float(0);
			}
			
			float _SwitchMaskOpacity( float m_switch, float m_BaseColorMapAlpha, float m_MaskMapBlue )
			{
				if(m_switch ==0)
					return m_BaseColorMapAlpha;
				else if(m_switch ==1)
					return m_MaskMapBlue;
				else
				return float(0);
			}
			

            void GetSurfaceData(SurfaceDescription surfaceDescription, float4 positionCS, out DecalSurfaceData surfaceData)
            {
                #if defined(LOD_FADE_CROSSFADE)
					LODFadeCrossFade( positionCS );
                #endif

                half fadeFactor = half(1.0);

                ZERO_INITIALIZE(DecalSurfaceData, surfaceData);
                surfaceData.occlusion = half(1.0);
                surfaceData.smoothness = half(0);

                #ifdef _MATERIAL_AFFECTS_NORMAL
                    surfaceData.normalWS.w = half(1.0);
                #else
                    surfaceData.normalWS.w = half(0.0);
                #endif

				#if defined( _MATERIAL_AFFECTS_EMISSION )
					surfaceData.emissive.rgb = half3(surfaceDescription.Emission.rgb * fadeFactor);
				#endif

                surfaceData.baseColor.xyz = half3(surfaceDescription.BaseColor);
                surfaceData.baseColor.w = half(surfaceDescription.Alpha * fadeFactor);

                surfaceData.normalWS.w = surfaceDescription.NormalAlpha * fadeFactor;

				#if defined( _MATERIAL_AFFECTS_MAOS )
					surfaceData.metallic = half(surfaceDescription.Metallic);
					surfaceData.occlusion = half(surfaceDescription.Occlusion);
					surfaceData.smoothness = half(surfaceDescription.Smoothness);
					surfaceData.MAOSAlpha = half(surfaceDescription.MAOSAlpha * fadeFactor);
				#endif
            }

            #if (SHADERPASS == SHADERPASS_DBUFFER_PROJECTOR) || (SHADERPASS == SHADERPASS_FORWARD_EMISSIVE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_PROJECTOR)
            #define DECAL_PROJECTOR
            #endif

            #if (SHADERPASS == SHADERPASS_DBUFFER_MESH) || (SHADERPASS == SHADERPASS_FORWARD_EMISSIVE_MESH) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_MESH) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_MESH)
            #define DECAL_MESH
            #endif

            #if (SHADERPASS == SHADERPASS_DBUFFER_PROJECTOR) || (SHADERPASS == SHADERPASS_DBUFFER_MESH)
            #define DECAL_DBUFFER
            #endif

            #if (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_MESH)
            #define DECAL_SCREEN_SPACE
            #endif

            #if (SHADERPASS == SHADERPASS_DECAL_GBUFFER_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_MESH)
            #define DECAL_GBUFFER
            #endif

            #if (SHADERPASS == SHADERPASS_FORWARD_EMISSIVE_PROJECTOR) || (SHADERPASS == SHADERPASS_FORWARD_EMISSIVE_MESH)
            #define DECAL_FORWARD_EMISSIVE
            #endif

            #if ((!defined(_MATERIAL_AFFECTS_NORMAL) && defined(_MATERIAL_AFFECTS_ALBEDO)) || (defined(_MATERIAL_AFFECTS_NORMAL) && defined(_MATERIAL_AFFECTS_NORMAL_BLEND))) && (defined(DECAL_SCREEN_SPACE) || defined(DECAL_GBUFFER))
            #define DECAL_RECONSTRUCT_NORMAL
            #elif defined(DECAL_ANGLE_FADE)
            #define DECAL_LOAD_NORMAL
            #endif

            #ifdef _DECAL_LAYERS
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DeclareRenderingLayerTexture.hlsl"
            #endif

            #if defined(DECAL_LOAD_NORMAL)
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DeclareNormalsTexture.hlsl"
            #endif

            #if defined(DECAL_PROJECTOR) || defined(DECAL_RECONSTRUCT_NORMAL)
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DeclareDepthTexture.hlsl"
            #endif

            #ifdef DECAL_MESH
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DecalMeshBiasTypeEnum.cs.hlsl"
            #endif

            #ifdef DECAL_RECONSTRUCT_NORMAL
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/NormalReconstruction.hlsl"
            #endif

			void MeshDecalsPositionZBias(inout PackedVaryings input)
			{
			#if UNITY_REVERSED_Z
				input.positionCS.z -= _DecalMeshDepthBias;
			#else
				input.positionCS.z += _DecalMeshDepthBias;
			#endif
			}

			PackedVaryings Vert(Attributes inputMesh  )
			{
				if (_DecalMeshBiasType == DECALMESHDEPTHBIASTYPE_VIEW_BIAS)
				{
					float3 viewDirectionOS = GetObjectSpaceNormalizeViewDir(inputMesh.positionOS);
					inputMesh.positionOS += viewDirectionOS * (_DecalMeshViewBias);
				}

				PackedVaryings packedOutput;
				ZERO_INITIALIZE(PackedVaryings, packedOutput);

				UNITY_SETUP_INSTANCE_ID(inputMesh);
				UNITY_TRANSFER_INSTANCE_ID(inputMesh, packedOutput);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(packedOutput);

				float3 ase_normalWS = TransformObjectToWorldNormal( inputMesh.normalOS );
				float3 ase_tangentWS = TransformObjectToWorldDir( inputMesh.tangentOS.xyz );
				float ase_tangentSign = inputMesh.tangentOS.w * ( unity_WorldTransformParams.w >= 0.0 ? 1.0 : -1.0 );
				float3 ase_bitangentWS = cross( ase_normalWS, ase_tangentWS ) * ase_tangentSign;
				packedOutput.ase_texcoord4.xyz = ase_bitangentWS;
				
				packedOutput.ase_texcoord5 = float4(inputMesh.positionOS,1);
				
				//setting value to unused interpolator channels and avoid initialization warnings
				packedOutput.ase_texcoord4.w = 0;

				VertexPositionInputs vertexInput = GetVertexPositionInputs(inputMesh.positionOS.xyz);

				float3 positionWS = TransformObjectToWorld(inputMesh.positionOS);
				float3 normalWS = TransformObjectToWorldNormal(inputMesh.normalOS);
				float4 tangentWS = float4(TransformObjectToWorldDir(inputMesh.tangentOS.xyz), inputMesh.tangentOS.w);

				packedOutput.positionCS = TransformWorldToHClip(positionWS);

				if (_DecalMeshBiasType == DECALMESHDEPTHBIASTYPE_DEPTH_BIAS)
				{
					MeshDecalsPositionZBias(packedOutput);
				}

				packedOutput.positionWS.xyz = positionWS;
				packedOutput.normalWS.xyz =  normalWS;
				packedOutput.tangentWS.xyzw =  tangentWS;
				packedOutput.texCoord0.xyzw =  inputMesh.uv0;

				return packedOutput;
			}

			void Frag(PackedVaryings packedInput,
				out half4 outEmissive : SV_Target0
				
			)
			{
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(packedInput);
				UNITY_SETUP_INSTANCE_ID(packedInput);

				half angleFadeFactor = 1.0;

            // Only screen space needs flip logic, other passes do not setup needed properties so we skip here
            #if defined(DECAL_SCREEN_SPACE)
				TransformScreenUV(packedInput.positionCS, _ScreenSize.y);
            #endif

            #ifdef _DECAL_LAYERS
            #ifdef _RENDER_PASS_ENABLED
				uint surfaceRenderingLayer = LOAD_FRAMEBUFFER_X_INPUT(GBUFFER4, packedInput.positionCS.xy).r;
            #else
				uint surfaceRenderingLayer = LoadSceneRenderingLayer(packedInput.positionCS.xy);
            #endif
				uint projectorRenderingLayer = asuint(UNITY_ACCESS_INSTANCED_PROP(Decal, _DecalLayerMaskFromDecal));
				clip((surfaceRenderingLayer & projectorRenderingLayer) - 0.1);
            #endif

			#if defined(DECAL_PROJECTOR)
			#if UNITY_REVERSED_Z
			#if _RENDER_PASS_ENABLED
				float depth = LOAD_FRAMEBUFFER_X_INPUT(GBUFFER3, packedInput.positionCS.xy).x;
			#else
				float depth = LoadSceneDepth(packedInput.positionCS.xy);
			#endif
			#else
			#if _RENDER_PASS_ENABLED
				float depth = lerp(UNITY_NEAR_CLIP_VALUE, 1, LOAD_FRAMEBUFFER_X_INPUT(GBUFFER3, packedInput.positionCS.xy));
			#else
			    // Adjust z to match NDC for OpenGL
				float depth = lerp(UNITY_NEAR_CLIP_VALUE, 1, LoadSceneDepth(packedInput.positionCS.xy));
			#endif
			#endif
			#endif

			#if defined(DECAL_RECONSTRUCT_NORMAL)
				#if defined(_RENDER_PASS_ENABLED)
					half3 normalWS = half3(ReconstructNormalDerivative(packedInput.positionCS.xy, LOAD_FRAMEBUFFER_X_INPUT(GBUFFER3, packedInput.positionCS.xy).x));
				#elif defined(_DECAL_NORMAL_BLEND_HIGH)
					half3 normalWS = half3(ReconstructNormalTap9(packedInput.positionCS.xy));
				#elif defined(_DECAL_NORMAL_BLEND_MEDIUM)
					half3 normalWS = half3(ReconstructNormalTap5(packedInput.positionCS.xy));
				#else
					half3 normalWS = half3(ReconstructNormalDerivative(packedInput.positionCS.xy));
				#endif
			#elif defined(DECAL_LOAD_NORMAL)
				#if defined(_RENDER_PASS_ENABLED)
				half3 normalWS = normalize(LOAD_FRAMEBUFFER_X_INPUT(GBUFFER2, packedInput.positionCS.xy).rgb);
				#else
				half3 normalWS = normalize(LoadSceneNormals(packedInput.positionCS.xy).rgb);
				#endif
			#endif

				float2 positionSS = FoveatedRemapNonUniformToLinearCS(packedInput.positionCS.xy) * _ScreenSize.zw;

				float3 positionWS = packedInput.positionWS.xyz;
				half3 viewDirectionWS = half3(1.0, 1.0, 1.0);

				DecalSurfaceData surfaceData;
				SurfaceDescription surfaceDescription = (SurfaceDescription)0;

				float temp_output_1307_0 = radians( _Rotation );
				float temp_output_1301_0 = cos( temp_output_1307_0 );
				float2 break1305 = ( packedInput.texCoord0.xy - float2( 0.5,0.5 ) );
				float temp_output_1300_0 = sin( temp_output_1307_0 );
				float2 appendResult1295 = (float2(( ( temp_output_1301_0 * break1305.x ) + ( temp_output_1300_0 * break1305.y ) ) , ( ( temp_output_1301_0 * break1305.y ) - ( temp_output_1300_0 * break1305.x ) )));
				float2 temp_output_1353_0 = (_BaseColorMap_ST).xy;
				float2 _Vector0 = float2(0.5,0.5);
				// *** BEGIN Flipbook UV Animation vars ***
				// Total tiles of Flipbook Texture
				float fbtotaltiles1358 = min( _FlipbookColumns * _FlipbookRows, 9.0 + 1 );
				// Offsets for cols and rows of Flipbook Texture
				float fbcolsoffset1358 = 1.0f / _FlipbookColumns;
				float fbrowsoffset1358 = 1.0f / _FlipbookRows;
				// Speed of animation
				float fbspeed1358 = _Time[ 1 ] * _FlipbookSpeed;
				// UV Tiling (col and row offset)
				float2 fbtiling1358 = float2(fbcolsoffset1358, fbrowsoffset1358);
				// UV Offset - calculate current tile linear index, and convert it to (X * coloffset, Y * rowoffset)
				// Calculate current tile linear index
				float fbcurrenttileindex1358 = floor( fmod( fbspeed1358 + _FlipbookID, fbtotaltiles1358) );
				fbcurrenttileindex1358 += ( fbcurrenttileindex1358 < 0) ? fbtotaltiles1358 : 0;
				// Obtain Offset X coordinate from current tile linear index
				float fblinearindextox1358 = round ( fmod ( fbcurrenttileindex1358, _FlipbookColumns ) );
				// Reverse X animation if speed is negative
				fblinearindextox1358 = (_FlipbookSpeed > 0 ? fblinearindextox1358 : (int)_FlipbookColumns - fblinearindextox1358);
				// Multiply Offset X by coloffset
				float fboffsetx1358 = fblinearindextox1358 * fbcolsoffset1358;
				// Obtain Offset Y coordinate from current tile linear index
				float fblinearindextoy1358 = round( fmod( ( fbcurrenttileindex1358 - fblinearindextox1358 ) / _FlipbookColumns, _FlipbookRows ) );
				// Reverse Y to get tiles from Top to Bottom and Reverse Y animation if speed is negative
				fblinearindextoy1358 = (_FlipbookSpeed <  0 ? fblinearindextoy1358 : (int)_FlipbookRows - fblinearindextoy1358);
				// Multiply Offset Y by rowoffset
				float fboffsety1358 = fblinearindextoy1358 * fbrowsoffset1358;
				// UV Offset
				float2 fboffset1358 = float2(fboffsetx1358, fboffsety1358);
				// Flipbook UV
				float2 fbuv1358 = ( ( ( ( appendResult1295 * temp_output_1353_0 ) + float2( 0.5,0.5 ) ) + (_BaseColorMap_ST).zw ) - ( ( ( temp_output_1353_0 / 1.0 ) * _Vector0 ) - _Vector0 ) ) * fbtiling1358 + fboffset1358;
				// *** END Flipbook UV Animation vars ***
				int flipbookFrame1358 = ( ( int )fbcurrenttileindex1358);
				float2 temp_output_1490_0 = ddx( fbuv1358 );
				float2 temp_output_1491_0 = ddy( fbuv1358 );
				float temp_output_410_0 = ( _ParallaxAmplitude * 0.001 );
				float3 ase_bitangentWS = packedInput.ase_texcoord4.xyz;
				float3 tanToWorld0 = float3( packedInput.tangentWS.xyz.x, ase_bitangentWS.x, packedInput.normalWS.x );
				float3 tanToWorld1 = float3( packedInput.tangentWS.xyz.y, ase_bitangentWS.y, packedInput.normalWS.y );
				float3 tanToWorld2 = float3( packedInput.tangentWS.xyz.z, ase_bitangentWS.z, packedInput.normalWS.z );
				float3 ase_viewVectorTS =  tanToWorld0 * ( _WorldSpaceCameraPos.xyz - packedInput.positionWS ).x + tanToWorld1 * ( _WorldSpaceCameraPos.xyz - packedInput.positionWS ).y  + tanToWorld2 * ( _WorldSpaceCameraPos.xyz - packedInput.positionWS ).z;
				float2 Offset1512 = ( ( SAMPLE_TEXTURE2D_GRAD( _ParallaxMap, sampler_ParallaxMap, fbuv1358, temp_output_1490_0, temp_output_1491_0 ).r - 1 ) * ase_viewVectorTS.xy * temp_output_410_0 ) + fbuv1358;
				float2 Offset1554 = ( ( SAMPLE_TEXTURE2D_GRAD( _ParallaxMap, sampler_ParallaxMap, fbuv1358, temp_output_1490_0, temp_output_1491_0 ).r - 1 ) * ase_viewVectorTS.xy * temp_output_410_0 ) + Offset1512;
				float2 Offset1605 = ( ( SAMPLE_TEXTURE2D_GRAD( _ParallaxMap, sampler_ParallaxMap, fbuv1358, temp_output_1490_0, temp_output_1491_0 ).r - 1 ) * ase_viewVectorTS.xy * temp_output_410_0 ) + Offset1554;
				float2 Offset1606 = ( ( SAMPLE_TEXTURE2D_GRAD( _ParallaxMap, sampler_ParallaxMap, fbuv1358, temp_output_1490_0, temp_output_1491_0 ).r - 1 ) * ase_viewVectorTS.xy * temp_output_410_0 ) + Offset1605;
				float2 lerpResult1376 = lerp( fbuv1358 , Offset1606 , _EnableParallax);
				float2 UV1050 = lerpResult1376;
				float2 UV_DDX1265 = temp_output_1490_0;
				float2 UV_DDY1266 = temp_output_1491_0;
				float4 tex2DNode445 = SAMPLE_TEXTURE2D_GRAD( _BaseColorMap, sampler_BaseColorMap, UV1050, UV_DDX1265, UV_DDY1266 );
				float3 BaseColor554 = ( (tex2DNode445).rgb * (_BaseColor).rgb );
				
				float BaseColorMap_Alpha631 = tex2DNode445.a;
				float temp_output_523_0 = ( BaseColorMap_Alpha631 * ( 1.0 - _DecalOpacity ) );
				float3 temp_output_702_0 = ( packedInput.ase_texcoord5.xyz + float3( 0.5,0.5,0.5 ) );
				float temp_output_698_0 = saturate( ( ( _HeightScale * ( temp_output_702_0 * ( 1.0 - temp_output_702_0 ) ).y ) + _HeightOffset ) );
				float smoothstepResult705 = smoothstep( temp_output_698_0 , ( temp_output_698_0 + 0.001 ) , ( SAMPLE_TEXTURE2D_GRAD( _ParallaxMap, sampler_ParallaxMap, UV1050, UV_DDX1265, UV_DDY1266 ).r * SAMPLE_TEXTURE2D_GRAD( _ParallaxMap, sampler_ParallaxMap, UV1050, UV_DDX1265, UV_DDY1266 ).r ));
				float Height746 = smoothstepResult705;
				float lerpResult1383 = lerp( temp_output_523_0 , ( temp_output_523_0 * Height746 ) , _EnableHeight);
				float Alpha635 = lerpResult1383;
				
				float3 unpack444 = UnpackNormalScale( SAMPLE_TEXTURE2D_GRAD( _NormalMap, sampler_NormalMap, UV1050, UV_DDX1265, UV_DDY1266 ), _NormalScale );
				unpack444.z = lerp( 1, unpack444.z, saturate(_NormalScale) );
				float3 Normal556 = unpack444;
				
				float m_switch857 = _NormalOpacityChannel;
				float m_BaseColorMapAlpha857 = temp_output_523_0;
				float4 tex2DNode607 = SAMPLE_TEXTURE2D_GRAD( _MaskMap, sampler_BaseColorMap, UV1050, UV_DDX1265, UV_DDY1266 );
				float Opacity_Mask632 = tex2DNode607.b;
				float m_MaskMapBlue857 = ( _DecalMaskMapBlueScale1 * Opacity_Mask632 );
				float local_SwitchNormalOpacity857 = _SwitchNormalOpacity( m_switch857 , m_BaseColorMapAlpha857 , m_MaskMapBlue857 );
				float lerpResult1382 = lerp( local_SwitchNormalOpacity857 , ( local_SwitchNormalOpacity857 * Height746 ) , _EnableHeight);
				float Alpha_Normal636 = lerpResult1382;
				
				float Metallic624 = ( _MaskmapMetal * tex2DNode607.r );
				
				float Occlusion626 = saturate( ( ( 1.0 - _MaskmapAO ) * tex2DNode607.g ) );
				
				float Smoothness625 = ( _MaskmapSmoothness * tex2DNode607.a );
				
				float m_switch858 = _MaskOpacityChannel;
				float m_BaseColorMapAlpha858 = temp_output_523_0;
				float m_MaskMapBlue858 = ( _DecalMaskMapBlueScale1 * Opacity_Mask632 );
				float local_SwitchMaskOpacity858 = _SwitchMaskOpacity( m_switch858 , m_BaseColorMapAlpha858 , m_MaskMapBlue858 );
				float lerpResult1381 = lerp( local_SwitchMaskOpacity858 , ( local_SwitchMaskOpacity858 * Height746 ) , _EnableHeight);
				float Alpha_MSO637 = lerpResult1381;
				
				float3 color1672 = IsGammaSpace() ? float3( 0, 0, 0 ) : float3( 0, 0, 0 );
				float2 UV_Parallax_Off1456 = fbuv1358;
				float temp_output_2_0_g61768 = _AlbedoAffectEmissive;
				float temp_output_3_0_g61768 = ( 1.0 - temp_output_2_0_g61768 );
				float3 appendResult7_g61768 = (float3(temp_output_3_0_g61768 , temp_output_3_0_g61768 , temp_output_3_0_g61768));
				float3 lerpResult1671 = lerp( color1672 , ( (SAMPLE_TEXTURE2D_GRAD( _EmissiveColorMap, sampler_EmissiveColorMap, UV_Parallax_Off1456, UV_DDX1265, UV_DDY1266 )).rgb * ( ( _EmissiveColor * _EmissiveIntensity ) * ( ( BaseColor554 * temp_output_2_0_g61768 ) + appendResult7_g61768 ) ) ) , _AffectEmission);
				float3 Emissive558 = lerpResult1671;
				

				surfaceDescription.BaseColor = BaseColor554;
				surfaceDescription.Alpha = Alpha635;
				surfaceDescription.NormalTS = Normal556;
				surfaceDescription.NormalAlpha = Alpha_Normal636;

			#if defined( _MATERIAL_AFFECTS_MAOS )
				surfaceDescription.Metallic = Metallic624;
				surfaceDescription.Occlusion = Occlusion626;
				surfaceDescription.Smoothness = Smoothness625;
				surfaceDescription.MAOSAlpha = Alpha_MSO637;
			#endif

			#if defined( _MATERIAL_AFFECTS_EMISSION )
				surfaceDescription.Emission = Emissive558;
			#endif

				GetSurfaceData(surfaceDescription, packedInput.positionCS, surfaceData);

				outEmissive.rgb = surfaceData.emissive * GetCurrentExposureMultiplier();
				outEmissive.a = surfaceData.baseColor.a;

			}
            ENDHLSL
        }

		
        Pass
        {
            
			Name "DecalScreenSpaceMesh"
            Tags { "LightMode"="DecalScreenSpaceMesh" }

			Blend SrcAlpha OneMinusSrcAlpha
			ZTest LEqual
			ZWrite Off

			HLSLPROGRAM

			#define _MATERIAL_AFFECTS_ALBEDO 1
			#define _MATERIAL_AFFECTS_NORMAL 1
			#define _MATERIAL_AFFECTS_NORMAL_BLEND 1
			#define  _MATERIAL_AFFECTS_MAOS 1
			#define _MATERIAL_AFFECTS_EMISSION 1
			#define USE_UNITY_CROSSFADE 1
			#pragma multi_compile_fragment _ LOD_FADE_CROSSFADE
			#define ASE_VERSION 19907
			#define ASE_SRP_VERSION 170300
			#define ASE_USING_SAMPLING_MACROS 1


			#pragma vertex Vert
			#pragma fragment Frag
			#pragma multi_compile_instancing
			#pragma editor_sync_compilation

			#pragma multi_compile _ LIGHTMAP_ON
			#pragma multi_compile _ DYNAMICLIGHTMAP_ON
			#pragma multi_compile _ DIRLIGHTMAP_COMBINED
			#pragma multi_compile _ USE_LEGACY_LIGHTMAPS
			#pragma multi_compile _ LIGHTMAP_BICUBIC_SAMPLING
			#pragma multi_compile _ REFLECTION_PROBE_ROTATION
			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
			#pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
			#pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
            #pragma multi_compile_fragment _ _SHADOWS_SOFT _SHADOWS_SOFT_LOW _SHADOWS_SOFT_MEDIUM _SHADOWS_SOFT_HIGH
			#pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
			#pragma multi_compile _ SHADOWS_SHADOWMASK
			#pragma multi_compile _ _CLUSTER_LIGHT_LOOP
			#pragma multi_compile _DECAL_NORMAL_BLEND_LOW _DECAL_NORMAL_BLEND_MEDIUM _DECAL_NORMAL_BLEND_HIGH
			#pragma multi_compile_fragment _ DEBUG_DISPLAY
			#pragma multi_compile _ _DECAL_LAYERS

            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define ATTRIBUTES_NEED_TEXCOORD2
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_NORMAL_WS
            #define VARYINGS_NEED_VIEWDIRECTION_WS
            #define VARYINGS_NEED_TANGENT_WS
            #define VARYINGS_NEED_TEXCOORD0
            #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
            #define VARYINGS_NEED_SH
            #define VARYINGS_NEED_STATIC_LIGHTMAP_UV
            #define VARYINGS_NEED_DYNAMIC_LIGHTMAP_UV

            #define HAVE_MESH_MODIFICATION

            #define SHADERPASS SHADERPASS_DECAL_SCREEN_SPACE_MESH

			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Fog.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
            #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ProbeVolumeVariants.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DecalInput.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderVariablesDecal.hlsl"

			#if defined(LOD_FADE_CROSSFADE)
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
            #endif

            #if _RENDER_PASS_ENABLED
            #define GBUFFER3 0
            FRAMEBUFFER_INPUT_X_FLOAT(GBUFFER3);
            #define GBUFFER4 1
            FRAMEBUFFER_INPUT_X_UINT(GBUFFER4);
            #endif

			#define ASE_NEEDS_TEXTURE_COORDINATES0
			#define ASE_NEEDS_FRAG_TEXTURE_COORDINATES0
			#define ASE_NEEDS_WORLD_POSITION
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_NEEDS_WORLD_TANGENT
			#define ASE_NEEDS_FRAG_WORLD_TANGENT
			#define ASE_NEEDS_WORLD_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_NORMAL
			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_VERT_TANGENT


            struct SurfaceDescription
			{
				float3 BaseColor;
				float Alpha;
				float3 NormalTS;
				float NormalAlpha;
				float Metallic;
				float Occlusion;
				float Smoothness;
				float MAOSAlpha;
				float3 Emission;
			};

            struct Attributes
			{
				float3 positionOS : POSITION;
				float3 normalOS : NORMAL;
				float4 tangentOS : TANGENT;
				float4 uv0 : TEXCOORD0;
				float4 uv1 : TEXCOORD1;
				float4 uv2 : TEXCOORD2;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct PackedVaryings
			{
				float4 positionCS : SV_POSITION;
				float3 positionWS : TEXCOORD0;
				float3 normalWS : TEXCOORD1;
				float4 tangentWS : TEXCOORD2;
				float4 texCoord0 : TEXCOORD3;
				float3 viewDirectionWS : TEXCOORD4;
				float4 lightmapUVs : TEXCOORD5; // @diogo: packs both static (xy) and dynamic (zw)
				float3 sh : TEXCOORD6;
				float4 fogFactorAndVertexLight : TEXCOORD7;
				#ifdef USE_APV_PROBE_OCCLUSION
					float4 probeOcclusion : TEXCOORD8;
				#endif
				float4 ase_texcoord9 : TEXCOORD9;
				float4 ase_texcoord10 : TEXCOORD10;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

            CBUFFER_START(UnityPerMaterial)
			float4 _BaseColorMap_ST;
			float4 _BaseColor;
			float3 _EmissiveColor;
			float _Rotation;
			half _EmissiveIntensity;
			float _MaskOpacityChannel;
			half _MaskmapSmoothness;
			half _MaskmapAO;
			half _MaskmapMetal;
			float _DecalMaskMapBlueScale1;
			float _NormalOpacityChannel;
			float _NormalScale;
			float _HeightOffset;
			float _AlbedoAffectEmissive;
			float _HeightScale;
			half _DecalOpacity;
			float _EnableParallax;
			float _ParallaxAmplitude;
			half _FlipbookID;
			half _FlipbookSpeed;
			half _FlipbookRows;
			half _FlipbookColumns;
			float _EnableHeight;
			float _AffectEmission;
			float _DrawOrder;
			float _DecalMeshBiasType;
			float _DecalMeshDepthBias;
			float _DecalMeshViewBias;
			#if defined(DECAL_ANGLE_FADE)
			float _DecalAngleFadeSupported;
			#endif
			UNITY_TEXTURE_STREAMING_DEBUG_VARS;
			CBUFFER_END

            #ifdef SCENEPICKINGPASS
				float4 _SelectionID;
            #endif

            #ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
            #endif

			TEXTURE2D(_BaseColorMap);
			TEXTURE2D(_ParallaxMap);
			SAMPLER(sampler_ParallaxMap);
			SAMPLER(sampler_BaseColorMap);
			TEXTURE2D(_NormalMap);
			SAMPLER(sampler_NormalMap);
			TEXTURE2D(_MaskMap);
			TEXTURE2D(_EmissiveColorMap);
			SAMPLER(sampler_EmissiveColorMap);


			float _SwitchNormalOpacity( float m_switch, float m_BaseColorMapAlpha, float m_MaskMapBlue )
			{
				if(m_switch ==0)
					return m_BaseColorMapAlpha;
				else if(m_switch ==1)
					return m_MaskMapBlue;
				else
				return float(0);
			}
			
			float _SwitchMaskOpacity( float m_switch, float m_BaseColorMapAlpha, float m_MaskMapBlue )
			{
				if(m_switch ==0)
					return m_BaseColorMapAlpha;
				else if(m_switch ==1)
					return m_MaskMapBlue;
				else
				return float(0);
			}
			

            void GetSurfaceData(PackedVaryings input, SurfaceDescription surfaceDescription, out DecalSurfaceData surfaceData)
            {
                #if defined(LOD_FADE_CROSSFADE)
					LODFadeCrossFade( input.positionCS );
                #endif

                half fadeFactor = half(1.0);

                ZERO_INITIALIZE(DecalSurfaceData, surfaceData);
                surfaceData.occlusion = half(1.0);
                surfaceData.smoothness = half(0);

                #ifdef _MATERIAL_AFFECTS_NORMAL
                    surfaceData.normalWS.w = half(1.0);
                #else
                    surfaceData.normalWS.w = half(0.0);
                #endif

				#if defined( _MATERIAL_AFFECTS_EMISSION )
					surfaceData.emissive.rgb = half3(surfaceDescription.Emission.rgb * fadeFactor);
				#endif

                surfaceData.baseColor.xyz = half3(surfaceDescription.BaseColor);
                surfaceData.baseColor.w = half(surfaceDescription.Alpha * fadeFactor);

                #if (SHADERPASS == SHADERPASS_DBUFFER_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_PROJECTOR)
                    #if defined(_MATERIAL_AFFECTS_NORMAL)
						surfaceData.normalWS.xyz = normalize(mul((half3x3)normalToWorld, surfaceDescription.NormalTS.xyz));
                    #else
						surfaceData.normalWS.xyz = normalize(normalToWorld[2].xyz);
                    #endif
                #elif (SHADERPASS == SHADERPASS_DBUFFER_MESH) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_MESH) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_MESH)
                    #if defined(_MATERIAL_AFFECTS_NORMAL)
                        float sgn = input.tangentWS.w;
                        float3 bitangent = sgn * cross(input.normalWS.xyz, input.tangentWS.xyz);
                        half3x3 tangentToWorld = half3x3(input.tangentWS.xyz, bitangent.xyz, input.normalWS.xyz);
                        surfaceData.normalWS.xyz = normalize(TransformTangentToWorld(surfaceDescription.NormalTS, tangentToWorld));
                    #else
						surfaceData.normalWS.xyz = normalize(half3(input.normalWS));
                    #endif
                #endif

                surfaceData.normalWS.w = surfaceDescription.NormalAlpha * fadeFactor;

				#if defined( _MATERIAL_AFFECTS_MAOS )
					surfaceData.metallic = half(surfaceDescription.Metallic);
					surfaceData.occlusion = half(surfaceDescription.Occlusion);
					surfaceData.smoothness = half(surfaceDescription.Smoothness);
					surfaceData.MAOSAlpha = half(surfaceDescription.MAOSAlpha * fadeFactor);
				#endif
            }


            #if (SHADERPASS == SHADERPASS_DBUFFER_PROJECTOR) || (SHADERPASS == SHADERPASS_FORWARD_EMISSIVE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_PROJECTOR)
            #define DECAL_PROJECTOR
            #endif

            #if (SHADERPASS == SHADERPASS_DBUFFER_MESH) || (SHADERPASS == SHADERPASS_FORWARD_EMISSIVE_MESH) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_MESH) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_MESH)
            #define DECAL_MESH
            #endif

            #if (SHADERPASS == SHADERPASS_DBUFFER_PROJECTOR) || (SHADERPASS == SHADERPASS_DBUFFER_MESH)
            #define DECAL_DBUFFER
            #endif

            #if (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_MESH)
            #define DECAL_SCREEN_SPACE
            #endif

            #if (SHADERPASS == SHADERPASS_DECAL_GBUFFER_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_MESH)
            #define DECAL_GBUFFER
            #endif

            #if (SHADERPASS == SHADERPASS_FORWARD_EMISSIVE_PROJECTOR) || (SHADERPASS == SHADERPASS_FORWARD_EMISSIVE_MESH)
            #define DECAL_FORWARD_EMISSIVE
            #endif

            #if ((!defined(_MATERIAL_AFFECTS_NORMAL) && defined(_MATERIAL_AFFECTS_ALBEDO)) || (defined(_MATERIAL_AFFECTS_NORMAL) && defined(_MATERIAL_AFFECTS_NORMAL_BLEND))) && (defined(DECAL_SCREEN_SPACE) || defined(DECAL_GBUFFER))
            #define DECAL_RECONSTRUCT_NORMAL
            #elif defined(DECAL_ANGLE_FADE)
            #define DECAL_LOAD_NORMAL
            #endif

            #ifdef _DECAL_LAYERS
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DeclareRenderingLayerTexture.hlsl"
            #endif

            #if defined(DECAL_LOAD_NORMAL)
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DeclareNormalsTexture.hlsl"
            #endif

            #if defined(DECAL_PROJECTOR) || defined(DECAL_RECONSTRUCT_NORMAL)
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DeclareDepthTexture.hlsl"
            #endif

            #ifdef DECAL_MESH
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DecalMeshBiasTypeEnum.cs.hlsl"
            #endif

            #ifdef DECAL_RECONSTRUCT_NORMAL
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/NormalReconstruction.hlsl"
            #endif

			void MeshDecalsPositionZBias(inout PackedVaryings input)
			{
			#if UNITY_REVERSED_Z
				input.positionCS.z -= _DecalMeshDepthBias;
			#else
				input.positionCS.z += _DecalMeshDepthBias;
			#endif
			}

			void InitializeInputData(PackedVaryings input, float3 positionWS, half3 normalWS, half3 viewDirectionWS, out InputData inputData)
			{
				inputData = (InputData)0;

				inputData.positionWS = positionWS;
				inputData.normalWS = normalWS;
				inputData.viewDirectionWS = viewDirectionWS;
				inputData.shadowCoord = float4(0, 0, 0, 0);

				#ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
					inputData.fogCoord = InitializeInputDataFog(float4(positionWS, 1.0), input.fogFactorAndVertexLight.x);
					inputData.vertexLighting = input.fogFactorAndVertexLight.yzw;
				#endif

				#if defined(VARYINGS_NEED_DYNAMIC_LIGHTMAP_UV) && defined(DYNAMICLIGHTMAP_ON)
					inputData.bakedGI = SAMPLE_GI(input.lightmapUVs.xy, input.lightmapUVs.zw, half3(input.sh), normalWS);
					#if defined(VARYINGS_NEED_STATIC_LIGHTMAP_UV)
					inputData.shadowMask = SAMPLE_SHADOWMASK(input.lightmapUVs.xy);
					#endif
				#elif defined(VARYINGS_NEED_STATIC_LIGHTMAP_UV)
				#if !defined(LIGHTMAP_ON) && (defined(PROBE_VOLUMES_L1) || defined(PROBE_VOLUMES_L2))
    				inputData.bakedGI = SAMPLE_GI(input.sh,
					GetAbsolutePositionWS(inputData.positionWS),
					inputData.normalWS,
					inputData.viewDirectionWS,
					input.positionCS.xy,
					input.probeOcclusion,
					inputData.shadowMask);
				#else
					inputData.bakedGI = SAMPLE_GI(input.lightmapUVs.xy, half3(input.sh), normalWS);
					#if defined(VARYINGS_NEED_STATIC_LIGHTMAP_UV)
					inputData.shadowMask = SAMPLE_SHADOWMASK(input.lightmapUVs.xy);
					#endif
				#endif
				#endif

				#if defined(DEBUG_DISPLAY)
					#if defined(VARYINGS_NEED_DYNAMIC_LIGHTMAP_UV) && defined(DYNAMICLIGHTMAP_ON)
						inputData.dynamicLightmapUV = input.lightmapUVs.zw;
					#endif
					#if defined(VARYINGS_NEED_STATIC_LIGHTMAP_UV) && defined(LIGHTMAP_ON)
						inputData.staticLightmapUV = input.lightmapUVs.xy;
					#elif defined(VARYINGS_NEED_SH)
						inputData.vertexSH = input.sh;
					#endif
					#if defined(USE_APV_PROBE_OCCLUSION)
						inputData.probeOcclusion = input.probeOcclusion;
					#endif
				#endif

				inputData.normalizedScreenSpaceUV = GetNormalizedScreenSpaceUV(input.positionCS);
			}

			void GetSurface(DecalSurfaceData decalSurfaceData, inout SurfaceData surfaceData)
			{
				surfaceData.albedo = decalSurfaceData.baseColor.rgb;
				surfaceData.metallic = saturate(decalSurfaceData.metallic);
				surfaceData.specular = 0;
				surfaceData.smoothness = saturate(decalSurfaceData.smoothness);
				surfaceData.occlusion = decalSurfaceData.occlusion;
				surfaceData.emission = decalSurfaceData.emissive;
				surfaceData.alpha = saturate(decalSurfaceData.baseColor.w);
				surfaceData.clearCoatMask = 0;
				surfaceData.clearCoatSmoothness = 1;
			}

			PackedVaryings Vert(Attributes inputMesh  )
			{
				if (_DecalMeshBiasType == DECALMESHDEPTHBIASTYPE_VIEW_BIAS)
				{
					float3 viewDirectionOS = GetObjectSpaceNormalizeViewDir(inputMesh.positionOS);
					inputMesh.positionOS += viewDirectionOS * (_DecalMeshViewBias);
				}

				PackedVaryings packedOutput;
				ZERO_INITIALIZE(PackedVaryings, packedOutput);

				UNITY_SETUP_INSTANCE_ID(inputMesh);
				UNITY_TRANSFER_INSTANCE_ID(inputMesh, packedOutput);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(packedOutput);

				float3 ase_normalWS = TransformObjectToWorldNormal( inputMesh.normalOS );
				float3 ase_tangentWS = TransformObjectToWorldDir( inputMesh.tangentOS.xyz );
				float ase_tangentSign = inputMesh.tangentOS.w * ( unity_WorldTransformParams.w >= 0.0 ? 1.0 : -1.0 );
				float3 ase_bitangentWS = cross( ase_normalWS, ase_tangentWS ) * ase_tangentSign;
				packedOutput.ase_texcoord9.xyz = ase_bitangentWS;
				
				packedOutput.ase_texcoord10 = float4(inputMesh.positionOS,1);
				
				//setting value to unused interpolator channels and avoid initialization warnings
				packedOutput.ase_texcoord9.w = 0;

				VertexPositionInputs vertexInput = GetVertexPositionInputs(inputMesh.positionOS.xyz);
				float3 positionWS = TransformObjectToWorld(inputMesh.positionOS);
				float3 normalWS = TransformObjectToWorldNormal(inputMesh.normalOS);
				float4 tangentWS = float4(TransformObjectToWorldDir(inputMesh.tangentOS.xyz), inputMesh.tangentOS.w);

				packedOutput.positionCS = TransformWorldToHClip(positionWS);

				half fogFactor = 0;
				#if !defined(_FOG_FRAGMENT)
					fogFactor = ComputeFogFactor(packedOutput.positionCS.z);
				#endif

				half3 vertexLight = VertexLighting(positionWS, normalWS);
				packedOutput.fogFactorAndVertexLight = half4(fogFactor, vertexLight);

				if (_DecalMeshBiasType == DECALMESHDEPTHBIASTYPE_DEPTH_BIAS)
				{
					MeshDecalsPositionZBias(packedOutput);
				}

				packedOutput.positionWS.xyz = positionWS;
				packedOutput.normalWS.xyz =  normalWS;
				packedOutput.tangentWS.xyzw =  tangentWS;
				packedOutput.texCoord0.xyzw =  inputMesh.uv0;
				packedOutput.viewDirectionWS.xyz =  GetWorldSpaceViewDir(positionWS);

				#if defined(LIGHTMAP_ON)
					OUTPUT_LIGHTMAP_UV(inputMesh.uv1, unity_LightmapST, packedOutput.lightmapUVs.xy);
				#endif

				#if defined(DYNAMICLIGHTMAP_ON)
					packedOutput.lightmapUVs.zw = inputMesh.uv2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
				#endif

				#if !defined(LIGHTMAP_ON)
					packedOutput.sh = float3(SampleSHVertex(half3(normalWS)));
				#endif

				return packedOutput;
			}

			void Frag(PackedVaryings packedInput,
						out half4 outColor : SV_Target0
						
					)
			{
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(packedInput);
				UNITY_SETUP_INSTANCE_ID(packedInput);

				half angleFadeFactor = 1.0;

            // Only screen space needs flip logic, other passes do not setup needed properties so we skip here
			// To-Do check DecalScreenSpaceMesh pass
            //#if defined(DECAL_SCREEN_SPACE)
				//TransformScreenUV(packedInput.positionCS, _ScreenSize.y);
            //#endif

            #ifdef _DECAL_LAYERS
            #ifdef _RENDER_PASS_ENABLED
				uint surfaceRenderingLayer = LOAD_FRAMEBUFFER_X_INPUT(GBUFFER4, packedInput.positionCS.xy).r;
            #else
				uint surfaceRenderingLayer = LoadSceneRenderingLayer(packedInput.positionCS.xy);
            #endif
				uint projectorRenderingLayer = asuint(UNITY_ACCESS_INSTANCED_PROP(Decal, _DecalLayerMaskFromDecal));
				clip((surfaceRenderingLayer & projectorRenderingLayer) - 0.1);
            #endif

			#if defined(DECAL_PROJECTOR)
			#if UNITY_REVERSED_Z
			#if _RENDER_PASS_ENABLED
				float depth = LOAD_FRAMEBUFFER_X_INPUT(GBUFFER3, packedInput.positionCS.xy).x;
			#else
				float depth = LoadSceneDepth(packedInput.positionCS.xy);
			#endif
			#else
			#if _RENDER_PASS_ENABLED
				float depth = lerp(UNITY_NEAR_CLIP_VALUE, 1, LOAD_FRAMEBUFFER_X_INPUT(GBUFFER3, packedInput.positionCS.xy));
			#else
			    // Adjust z to match NDC for OpenGL
				float depth = lerp(UNITY_NEAR_CLIP_VALUE, 1, LoadSceneDepth(packedInput.positionCS.xy));
			#endif
			#endif
			#endif

			#if defined(DECAL_RECONSTRUCT_NORMAL)
				#if defined(_RENDER_PASS_ENABLED)
					half3 normalWS = half3(ReconstructNormalDerivative(packedInput.positionCS.xy, LOAD_FRAMEBUFFER_X_INPUT(GBUFFER3, packedInput.positionCS.xy).x));
				#elif defined(_DECAL_NORMAL_BLEND_HIGH)
					half3 normalWS = half3(ReconstructNormalTap9(packedInput.positionCS.xy));
				#elif defined(_DECAL_NORMAL_BLEND_MEDIUM)
					half3 normalWS = half3(ReconstructNormalTap5(packedInput.positionCS.xy));
				#else
					half3 normalWS = half3(ReconstructNormalDerivative(packedInput.positionCS.xy));
				#endif
			#elif defined(DECAL_LOAD_NORMAL)
				#if defined(_RENDER_PASS_ENABLED)
				half3 normalWS = normalize(LOAD_FRAMEBUFFER_X_INPUT(GBUFFER2, packedInput.positionCS.xy).rgb);
				#else
				half3 normalWS = normalize(LoadSceneNormals(packedInput.positionCS.xy).rgb);
				#endif
			#endif

				float2 positionSS = FoveatedRemapNonUniformToLinearCS(packedInput.positionCS.xy) * _ScreenSize.zw;

				float3 positionWS = packedInput.positionWS.xyz;
				half3 viewDirectionWS = half3(packedInput.viewDirectionWS);

				DecalSurfaceData surfaceData;
				SurfaceDescription surfaceDescription = (SurfaceDescription)0;

				float temp_output_1307_0 = radians( _Rotation );
				float temp_output_1301_0 = cos( temp_output_1307_0 );
				float2 break1305 = ( packedInput.texCoord0.xy - float2( 0.5,0.5 ) );
				float temp_output_1300_0 = sin( temp_output_1307_0 );
				float2 appendResult1295 = (float2(( ( temp_output_1301_0 * break1305.x ) + ( temp_output_1300_0 * break1305.y ) ) , ( ( temp_output_1301_0 * break1305.y ) - ( temp_output_1300_0 * break1305.x ) )));
				float2 temp_output_1353_0 = (_BaseColorMap_ST).xy;
				float2 _Vector0 = float2(0.5,0.5);
				// *** BEGIN Flipbook UV Animation vars ***
				// Total tiles of Flipbook Texture
				float fbtotaltiles1358 = min( _FlipbookColumns * _FlipbookRows, 9.0 + 1 );
				// Offsets for cols and rows of Flipbook Texture
				float fbcolsoffset1358 = 1.0f / _FlipbookColumns;
				float fbrowsoffset1358 = 1.0f / _FlipbookRows;
				// Speed of animation
				float fbspeed1358 = _Time[ 1 ] * _FlipbookSpeed;
				// UV Tiling (col and row offset)
				float2 fbtiling1358 = float2(fbcolsoffset1358, fbrowsoffset1358);
				// UV Offset - calculate current tile linear index, and convert it to (X * coloffset, Y * rowoffset)
				// Calculate current tile linear index
				float fbcurrenttileindex1358 = floor( fmod( fbspeed1358 + _FlipbookID, fbtotaltiles1358) );
				fbcurrenttileindex1358 += ( fbcurrenttileindex1358 < 0) ? fbtotaltiles1358 : 0;
				// Obtain Offset X coordinate from current tile linear index
				float fblinearindextox1358 = round ( fmod ( fbcurrenttileindex1358, _FlipbookColumns ) );
				// Reverse X animation if speed is negative
				fblinearindextox1358 = (_FlipbookSpeed > 0 ? fblinearindextox1358 : (int)_FlipbookColumns - fblinearindextox1358);
				// Multiply Offset X by coloffset
				float fboffsetx1358 = fblinearindextox1358 * fbcolsoffset1358;
				// Obtain Offset Y coordinate from current tile linear index
				float fblinearindextoy1358 = round( fmod( ( fbcurrenttileindex1358 - fblinearindextox1358 ) / _FlipbookColumns, _FlipbookRows ) );
				// Reverse Y to get tiles from Top to Bottom and Reverse Y animation if speed is negative
				fblinearindextoy1358 = (_FlipbookSpeed <  0 ? fblinearindextoy1358 : (int)_FlipbookRows - fblinearindextoy1358);
				// Multiply Offset Y by rowoffset
				float fboffsety1358 = fblinearindextoy1358 * fbrowsoffset1358;
				// UV Offset
				float2 fboffset1358 = float2(fboffsetx1358, fboffsety1358);
				// Flipbook UV
				float2 fbuv1358 = ( ( ( ( appendResult1295 * temp_output_1353_0 ) + float2( 0.5,0.5 ) ) + (_BaseColorMap_ST).zw ) - ( ( ( temp_output_1353_0 / 1.0 ) * _Vector0 ) - _Vector0 ) ) * fbtiling1358 + fboffset1358;
				// *** END Flipbook UV Animation vars ***
				int flipbookFrame1358 = ( ( int )fbcurrenttileindex1358);
				float2 temp_output_1490_0 = ddx( fbuv1358 );
				float2 temp_output_1491_0 = ddy( fbuv1358 );
				float temp_output_410_0 = ( _ParallaxAmplitude * 0.001 );
				float3 ase_bitangentWS = packedInput.ase_texcoord9.xyz;
				float3 tanToWorld0 = float3( packedInput.tangentWS.xyz.x, ase_bitangentWS.x, packedInput.normalWS.x );
				float3 tanToWorld1 = float3( packedInput.tangentWS.xyz.y, ase_bitangentWS.y, packedInput.normalWS.y );
				float3 tanToWorld2 = float3( packedInput.tangentWS.xyz.z, ase_bitangentWS.z, packedInput.normalWS.z );
				float3 ase_viewVectorTS =  tanToWorld0 * ( _WorldSpaceCameraPos.xyz - packedInput.positionWS ).x + tanToWorld1 * ( _WorldSpaceCameraPos.xyz - packedInput.positionWS ).y  + tanToWorld2 * ( _WorldSpaceCameraPos.xyz - packedInput.positionWS ).z;
				float2 Offset1512 = ( ( SAMPLE_TEXTURE2D_GRAD( _ParallaxMap, sampler_ParallaxMap, fbuv1358, temp_output_1490_0, temp_output_1491_0 ).r - 1 ) * ase_viewVectorTS.xy * temp_output_410_0 ) + fbuv1358;
				float2 Offset1554 = ( ( SAMPLE_TEXTURE2D_GRAD( _ParallaxMap, sampler_ParallaxMap, fbuv1358, temp_output_1490_0, temp_output_1491_0 ).r - 1 ) * ase_viewVectorTS.xy * temp_output_410_0 ) + Offset1512;
				float2 Offset1605 = ( ( SAMPLE_TEXTURE2D_GRAD( _ParallaxMap, sampler_ParallaxMap, fbuv1358, temp_output_1490_0, temp_output_1491_0 ).r - 1 ) * ase_viewVectorTS.xy * temp_output_410_0 ) + Offset1554;
				float2 Offset1606 = ( ( SAMPLE_TEXTURE2D_GRAD( _ParallaxMap, sampler_ParallaxMap, fbuv1358, temp_output_1490_0, temp_output_1491_0 ).r - 1 ) * ase_viewVectorTS.xy * temp_output_410_0 ) + Offset1605;
				float2 lerpResult1376 = lerp( fbuv1358 , Offset1606 , _EnableParallax);
				float2 UV1050 = lerpResult1376;
				float2 UV_DDX1265 = temp_output_1490_0;
				float2 UV_DDY1266 = temp_output_1491_0;
				float4 tex2DNode445 = SAMPLE_TEXTURE2D_GRAD( _BaseColorMap, sampler_BaseColorMap, UV1050, UV_DDX1265, UV_DDY1266 );
				float3 BaseColor554 = ( (tex2DNode445).rgb * (_BaseColor).rgb );
				
				float BaseColorMap_Alpha631 = tex2DNode445.a;
				float temp_output_523_0 = ( BaseColorMap_Alpha631 * ( 1.0 - _DecalOpacity ) );
				float3 temp_output_702_0 = ( packedInput.ase_texcoord10.xyz + float3( 0.5,0.5,0.5 ) );
				float temp_output_698_0 = saturate( ( ( _HeightScale * ( temp_output_702_0 * ( 1.0 - temp_output_702_0 ) ).y ) + _HeightOffset ) );
				float smoothstepResult705 = smoothstep( temp_output_698_0 , ( temp_output_698_0 + 0.001 ) , ( SAMPLE_TEXTURE2D_GRAD( _ParallaxMap, sampler_ParallaxMap, UV1050, UV_DDX1265, UV_DDY1266 ).r * SAMPLE_TEXTURE2D_GRAD( _ParallaxMap, sampler_ParallaxMap, UV1050, UV_DDX1265, UV_DDY1266 ).r ));
				float Height746 = smoothstepResult705;
				float lerpResult1383 = lerp( temp_output_523_0 , ( temp_output_523_0 * Height746 ) , _EnableHeight);
				float Alpha635 = lerpResult1383;
				
				float3 unpack444 = UnpackNormalScale( SAMPLE_TEXTURE2D_GRAD( _NormalMap, sampler_NormalMap, UV1050, UV_DDX1265, UV_DDY1266 ), _NormalScale );
				unpack444.z = lerp( 1, unpack444.z, saturate(_NormalScale) );
				float3 Normal556 = unpack444;
				
				float m_switch857 = _NormalOpacityChannel;
				float m_BaseColorMapAlpha857 = temp_output_523_0;
				float4 tex2DNode607 = SAMPLE_TEXTURE2D_GRAD( _MaskMap, sampler_BaseColorMap, UV1050, UV_DDX1265, UV_DDY1266 );
				float Opacity_Mask632 = tex2DNode607.b;
				float m_MaskMapBlue857 = ( _DecalMaskMapBlueScale1 * Opacity_Mask632 );
				float local_SwitchNormalOpacity857 = _SwitchNormalOpacity( m_switch857 , m_BaseColorMapAlpha857 , m_MaskMapBlue857 );
				float lerpResult1382 = lerp( local_SwitchNormalOpacity857 , ( local_SwitchNormalOpacity857 * Height746 ) , _EnableHeight);
				float Alpha_Normal636 = lerpResult1382;
				
				float Metallic624 = ( _MaskmapMetal * tex2DNode607.r );
				
				float Occlusion626 = saturate( ( ( 1.0 - _MaskmapAO ) * tex2DNode607.g ) );
				
				float Smoothness625 = ( _MaskmapSmoothness * tex2DNode607.a );
				
				float m_switch858 = _MaskOpacityChannel;
				float m_BaseColorMapAlpha858 = temp_output_523_0;
				float m_MaskMapBlue858 = ( _DecalMaskMapBlueScale1 * Opacity_Mask632 );
				float local_SwitchMaskOpacity858 = _SwitchMaskOpacity( m_switch858 , m_BaseColorMapAlpha858 , m_MaskMapBlue858 );
				float lerpResult1381 = lerp( local_SwitchMaskOpacity858 , ( local_SwitchMaskOpacity858 * Height746 ) , _EnableHeight);
				float Alpha_MSO637 = lerpResult1381;
				
				float3 color1672 = IsGammaSpace() ? float3( 0, 0, 0 ) : float3( 0, 0, 0 );
				float2 UV_Parallax_Off1456 = fbuv1358;
				float temp_output_2_0_g61768 = _AlbedoAffectEmissive;
				float temp_output_3_0_g61768 = ( 1.0 - temp_output_2_0_g61768 );
				float3 appendResult7_g61768 = (float3(temp_output_3_0_g61768 , temp_output_3_0_g61768 , temp_output_3_0_g61768));
				float3 lerpResult1671 = lerp( color1672 , ( (SAMPLE_TEXTURE2D_GRAD( _EmissiveColorMap, sampler_EmissiveColorMap, UV_Parallax_Off1456, UV_DDX1265, UV_DDY1266 )).rgb * ( ( _EmissiveColor * _EmissiveIntensity ) * ( ( BaseColor554 * temp_output_2_0_g61768 ) + appendResult7_g61768 ) ) ) , _AffectEmission);
				float3 Emissive558 = lerpResult1671;
				

				surfaceDescription.BaseColor = BaseColor554;
				surfaceDescription.Alpha = Alpha635;
				surfaceDescription.NormalTS = Normal556;
				surfaceDescription.NormalAlpha = Alpha_Normal636;

			#if defined( _MATERIAL_AFFECTS_MAOS )
				surfaceDescription.Metallic = Metallic624;
				surfaceDescription.Occlusion = Occlusion626;
				surfaceDescription.Smoothness = Smoothness625;
				surfaceDescription.MAOSAlpha = Alpha_MSO637;
			#endif

			#if defined( _MATERIAL_AFFECTS_EMISSION )
				surfaceDescription.Emission = Emissive558;
			#endif

				GetSurfaceData(packedInput, surfaceDescription, surfaceData);

				half3 normalToPack = surfaceData.normalWS.xyz;
			#ifdef DECAL_RECONSTRUCT_NORMAL
				surfaceData.normalWS.xyz = normalize(lerp(normalWS.xyz, surfaceData.normalWS.xyz, surfaceData.normalWS.w));
			#endif

				InputData inputData;
				InitializeInputData(packedInput, positionWS, surfaceData.normalWS.xyz, viewDirectionWS, inputData);

				SurfaceData surface = (SurfaceData)0;
				GetSurface(surfaceData, surface);

				half4 color = UniversalFragmentPBR(inputData, surface);
				color.rgb = MixFog(color.rgb, inputData.fogCoord);
				outColor = color;

			}
            ENDHLSL
        }

		
        Pass
        {
            
			Name "DecalGBufferMesh"
            Tags { "LightMode"="DecalGBufferMesh" }

			Blend 0 SrcAlpha OneMinusSrcAlpha
			Blend 1 SrcAlpha OneMinusSrcAlpha
			Blend 2 SrcAlpha OneMinusSrcAlpha
			Blend 3 SrcAlpha OneMinusSrcAlpha
			ZWrite Off
			ColorMask RGB
			ColorMask 0 1
			ColorMask RGB 2
			ColorMask RGB 3

			HLSLPROGRAM

			#define _MATERIAL_AFFECTS_ALBEDO 1
			#define _MATERIAL_AFFECTS_NORMAL 1
			#define _MATERIAL_AFFECTS_NORMAL_BLEND 1
			#define  _MATERIAL_AFFECTS_MAOS 1
			#define _MATERIAL_AFFECTS_EMISSION 1
			#define USE_UNITY_CROSSFADE 1
			#pragma multi_compile_fragment _ LOD_FADE_CROSSFADE
			#define ASE_VERSION 19907
			#define ASE_SRP_VERSION 170300
			#define ASE_USING_SAMPLING_MACROS 1


			#pragma vertex Vert
			#pragma fragment Frag
			#pragma multi_compile_instancing
			#pragma editor_sync_compilation

			#pragma multi_compile _ LIGHTMAP_ON
			#pragma multi_compile _ DYNAMICLIGHTMAP_ON
			#pragma multi_compile _ DIRLIGHTMAP_COMBINED
			#pragma multi_compile _ USE_LEGACY_LIGHTMAPS
			#pragma multi_compile _ LIGHTMAP_BICUBIC_SAMPLING
			#pragma multi_compile _ REFLECTION_PROBE_ROTATION
			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
            #pragma multi_compile_fragment _ _SHADOWS_SOFT _SHADOWS_SOFT_LOW _SHADOWS_SOFT_MEDIUM _SHADOWS_SOFT_HIGH
			#pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
			#pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
			#pragma multi_compile _DECAL_NORMAL_BLEND_LOW _DECAL_NORMAL_BLEND_MEDIUM _DECAL_NORMAL_BLEND_HIGH
			#pragma multi_compile _ _DECAL_LAYERS
			#pragma multi_compile_fragment _ _GBUFFER_NORMALS_OCT
			#pragma multi_compile_fragment _ _RENDER_PASS_ENABLED

            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define ATTRIBUTES_NEED_TEXCOORD2
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_NORMAL_WS
            #define VARYINGS_NEED_VIEWDIRECTION_WS
            #define VARYINGS_NEED_TANGENT_WS
            #define VARYINGS_NEED_TEXCOORD0
            #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
            #define VARYINGS_NEED_SH
            #define VARYINGS_NEED_STATIC_LIGHTMAP_UV
            #define VARYINGS_NEED_DYNAMIC_LIGHTMAP_UV

            #define HAVE_MESH_MODIFICATION

            #define SHADERPASS SHADERPASS_DECAL_GBUFFER_MESH

			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Fog.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
            #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ProbeVolumeVariants.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/GBufferOutput.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DecalInput.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderVariablesDecal.hlsl"

			#if defined(LOD_FADE_CROSSFADE)
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
            #endif

            #if _RENDER_PASS_ENABLED
            #define GBUFFER3 0
            FRAMEBUFFER_INPUT_X_FLOAT(GBUFFER3);
            #define GBUFFER4 1
            FRAMEBUFFER_INPUT_X_UINT(GBUFFER4);
            #endif

			#define ASE_NEEDS_TEXTURE_COORDINATES0
			#define ASE_NEEDS_FRAG_TEXTURE_COORDINATES0
			#define ASE_NEEDS_WORLD_POSITION
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_NEEDS_WORLD_TANGENT
			#define ASE_NEEDS_FRAG_WORLD_TANGENT
			#define ASE_NEEDS_WORLD_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_NORMAL
			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_VERT_TANGENT


			struct SurfaceDescription
			{
				float3 BaseColor;
				float Alpha;
				float3 NormalTS;
				float NormalAlpha;
				float Metallic;
				float Occlusion;
				float Smoothness;
				float MAOSAlpha;
				float3 Emission;
			};

            struct Attributes
			{
				float3 positionOS : POSITION;
				float3 normalOS : NORMAL;
				float4 tangentOS : TANGENT;
				float4 uv0 : TEXCOORD0;
				float4 uv1 : TEXCOORD1;
				float4 uv2 : TEXCOORD2;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct PackedVaryings
			{
				float4 positionCS : SV_POSITION;
				float3 positionWS : TEXCOORD0;
				float3 normalWS : TEXCOORD1;
				float4 tangentWS : TEXCOORD2;
				float4 texCoord0 : TEXCOORD3;
				float3 viewDirectionWS : TEXCOORD4;
				float4 lightmapUVs : TEXCOORD5; // @diogo: packs both static (xy) and dynamic (zw)
				float3 sh : TEXCOORD6;
				float4 fogFactorAndVertexLight : TEXCOORD7;
				#ifdef USE_APV_PROBE_OCCLUSION
					float4 probeOcclusion : TEXCOORD10;
				#endif
				float4 ase_texcoord9 : TEXCOORD9;
				float4 probeOcclusion : TEXCOORD10;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

            CBUFFER_START(UnityPerMaterial)
			float4 _BaseColorMap_ST;
			float4 _BaseColor;
			float3 _EmissiveColor;
			float _Rotation;
			half _EmissiveIntensity;
			float _MaskOpacityChannel;
			half _MaskmapSmoothness;
			half _MaskmapAO;
			half _MaskmapMetal;
			float _DecalMaskMapBlueScale1;
			float _NormalOpacityChannel;
			float _NormalScale;
			float _HeightOffset;
			float _AlbedoAffectEmissive;
			float _HeightScale;
			half _DecalOpacity;
			float _EnableParallax;
			float _ParallaxAmplitude;
			half _FlipbookID;
			half _FlipbookSpeed;
			half _FlipbookRows;
			half _FlipbookColumns;
			float _EnableHeight;
			float _AffectEmission;
			float _DrawOrder;
			float _DecalMeshBiasType;
			float _DecalMeshDepthBias;
			float _DecalMeshViewBias;
			#if defined(DECAL_ANGLE_FADE)
			float _DecalAngleFadeSupported;
			#endif
			UNITY_TEXTURE_STREAMING_DEBUG_VARS;
			CBUFFER_END

            #ifdef SCENEPICKINGPASS
				float4 _SelectionID;
            #endif

            #ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
            #endif

			TEXTURE2D(_BaseColorMap);
			TEXTURE2D(_ParallaxMap);
			SAMPLER(sampler_ParallaxMap);
			SAMPLER(sampler_BaseColorMap);
			TEXTURE2D(_NormalMap);
			SAMPLER(sampler_NormalMap);
			TEXTURE2D(_MaskMap);
			TEXTURE2D(_EmissiveColorMap);
			SAMPLER(sampler_EmissiveColorMap);


			float _SwitchNormalOpacity( float m_switch, float m_BaseColorMapAlpha, float m_MaskMapBlue )
			{
				if(m_switch ==0)
					return m_BaseColorMapAlpha;
				else if(m_switch ==1)
					return m_MaskMapBlue;
				else
				return float(0);
			}
			

            void GetSurfaceData(PackedVaryings input, SurfaceDescription surfaceDescription, out DecalSurfaceData surfaceData)
            {
                #if defined(LOD_FADE_CROSSFADE)
					LODFadeCrossFade( input.positionCS );
                #endif

                half fadeFactor = half(1.0);

                ZERO_INITIALIZE(DecalSurfaceData, surfaceData);
                surfaceData.occlusion = half(1.0);
                surfaceData.smoothness = half(0);

                #ifdef _MATERIAL_AFFECTS_NORMAL
                    surfaceData.normalWS.w = half(1.0);
                #else
                    surfaceData.normalWS.w = half(0.0);
                #endif

				#if defined( _MATERIAL_AFFECTS_EMISSION )
					surfaceData.emissive.rgb = half3(surfaceDescription.Emission.rgb * fadeFactor);
				#endif

                surfaceData.baseColor.xyz = half3(surfaceDescription.BaseColor);
                surfaceData.baseColor.w = half(surfaceDescription.Alpha * fadeFactor);

                #if (SHADERPASS == SHADERPASS_DBUFFER_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_PROJECTOR)
                    #if defined(_MATERIAL_AFFECTS_NORMAL)
						surfaceData.normalWS.xyz = normalize(mul((half3x3)normalToWorld, surfaceDescription.NormalTS.xyz));
                    #else
						surfaceData.normalWS.xyz = normalize(normalToWorld[2].xyz);
                    #endif
                #elif (SHADERPASS == SHADERPASS_DBUFFER_MESH) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_MESH) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_MESH)
                    #if defined(_MATERIAL_AFFECTS_NORMAL)
                        float sgn = input.tangentWS.w;
                        float3 bitangent = sgn * cross(input.normalWS.xyz, input.tangentWS.xyz);
                        half3x3 tangentToWorld = half3x3(input.tangentWS.xyz, bitangent.xyz, input.normalWS.xyz);
                        surfaceData.normalWS.xyz = normalize(TransformTangentToWorld(surfaceDescription.NormalTS, tangentToWorld));
                    #else
						surfaceData.normalWS.xyz = normalize(half3(input.normalWS));
                    #endif
                #endif

                surfaceData.normalWS.w = surfaceDescription.NormalAlpha * fadeFactor;

				#if defined( _MATERIAL_AFFECTS_MAOS )
					surfaceData.metallic = half(surfaceDescription.Metallic);
					surfaceData.occlusion = half(surfaceDescription.Occlusion);
					surfaceData.smoothness = half(surfaceDescription.Smoothness);
					surfaceData.MAOSAlpha = half(surfaceDescription.MAOSAlpha * fadeFactor);
				#endif
            }

            #if (SHADERPASS == SHADERPASS_DBUFFER_PROJECTOR) || (SHADERPASS == SHADERPASS_FORWARD_EMISSIVE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_PROJECTOR)
            #define DECAL_PROJECTOR
            #endif

            #if (SHADERPASS == SHADERPASS_DBUFFER_MESH) || (SHADERPASS == SHADERPASS_FORWARD_EMISSIVE_MESH) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_MESH) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_MESH)
            #define DECAL_MESH
            #endif

            #if (SHADERPASS == SHADERPASS_DBUFFER_PROJECTOR) || (SHADERPASS == SHADERPASS_DBUFFER_MESH)
            #define DECAL_DBUFFER
            #endif

            #if (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_MESH)
            #define DECAL_SCREEN_SPACE
            #endif

            #if (SHADERPASS == SHADERPASS_DECAL_GBUFFER_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_MESH)
            #define DECAL_GBUFFER
            #endif

            #if (SHADERPASS == SHADERPASS_FORWARD_EMISSIVE_PROJECTOR) || (SHADERPASS == SHADERPASS_FORWARD_EMISSIVE_MESH)
            #define DECAL_FORWARD_EMISSIVE
            #endif

            #if ((!defined(_MATERIAL_AFFECTS_NORMAL) && defined(_MATERIAL_AFFECTS_ALBEDO)) || (defined(_MATERIAL_AFFECTS_NORMAL) && defined(_MATERIAL_AFFECTS_NORMAL_BLEND))) && (defined(DECAL_SCREEN_SPACE) || defined(DECAL_GBUFFER))
            #define DECAL_RECONSTRUCT_NORMAL
            #elif defined(DECAL_ANGLE_FADE)
            #define DECAL_LOAD_NORMAL
            #endif

            #ifdef _DECAL_LAYERS
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DeclareRenderingLayerTexture.hlsl"
            #endif

            #if defined(DECAL_LOAD_NORMAL)
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DeclareNormalsTexture.hlsl"
            #endif

            #if defined(DECAL_PROJECTOR) || defined(DECAL_RECONSTRUCT_NORMAL)
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DeclareDepthTexture.hlsl"
            #endif

            #ifdef DECAL_MESH
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DecalMeshBiasTypeEnum.cs.hlsl"
            #endif

            #ifdef DECAL_RECONSTRUCT_NORMAL
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/NormalReconstruction.hlsl"
            #endif

			void MeshDecalsPositionZBias(inout PackedVaryings input)
			{
			#if UNITY_REVERSED_Z
				input.positionCS.z -= _DecalMeshDepthBias;
			#else
				input.positionCS.z += _DecalMeshDepthBias;
			#endif
			}

			void InitializeInputData(PackedVaryings input, float3 positionWS, half3 normalWS, half3 viewDirectionWS, out InputData inputData)
			{
				inputData = (InputData)0;

				inputData.positionWS = positionWS;
				inputData.normalWS = normalWS;
				inputData.viewDirectionWS = viewDirectionWS;
				inputData.shadowCoord = float4(0, 0, 0, 0);

				#ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
					inputData.fogCoord = InitializeInputDataFog(float4(positionWS, 1.0), input.fogFactorAndVertexLight.x);
					inputData.vertexLighting = input.fogFactorAndVertexLight.yzw;
				#endif

				#if defined(VARYINGS_NEED_DYNAMIC_LIGHTMAP_UV) && defined(DYNAMICLIGHTMAP_ON)
					inputData.bakedGI = SAMPLE_GI(input.lightmapUVs.xy, input.lightmapUVs.zw, half3(input.sh), normalWS);
					#if defined(VARYINGS_NEED_STATIC_LIGHTMAP_UV)
					inputData.shadowMask = SAMPLE_SHADOWMASK(input.lightmapUVs.xy);
					#endif
				#elif defined(VARYINGS_NEED_STATIC_LIGHTMAP_UV)
				#if !defined(LIGHTMAP_ON) && (defined(PROBE_VOLUMES_L1) || defined(PROBE_VOLUMES_L2))
    				inputData.bakedGI = SAMPLE_GI(input.sh,
					GetAbsolutePositionWS(inputData.positionWS),
					inputData.normalWS,
					inputData.viewDirectionWS,
					input.positionCS.xy,
					input.probeOcclusion,
					inputData.shadowMask);
				#else
					inputData.bakedGI = SAMPLE_GI(input.lightmapUVs.xy, half3(input.sh), normalWS);
					#if defined(VARYINGS_NEED_STATIC_LIGHTMAP_UV)
					inputData.shadowMask = SAMPLE_SHADOWMASK(input.lightmapUVs.xy);
					#endif
				#endif
				#endif

				#if defined(DEBUG_DISPLAY)
					#if defined(VARYINGS_NEED_DYNAMIC_LIGHTMAP_UV) && defined(DYNAMICLIGHTMAP_ON)
						inputData.dynamicLightmapUV = input.lightmapUVs.zw;
					#endif
					#if defined(VARYINGS_NEED_STATIC_LIGHTMAP_UV) && defined(LIGHTMAP_ON)
						inputData.staticLightmapUV = input.lightmapUVs.xy;
					#elif defined(VARYINGS_NEED_SH)
						inputData.vertexSH = input.sh;
					#endif
					#if defined(USE_APV_PROBE_OCCLUSION)
						inputData.probeOcclusion = input.probeOcclusion;
					#endif
				#endif

				inputData.normalizedScreenSpaceUV = GetNormalizedScreenSpaceUV(input.positionCS);
			}

			void GetSurface(DecalSurfaceData decalSurfaceData, inout SurfaceData surfaceData)
			{
				surfaceData.albedo = decalSurfaceData.baseColor.rgb;
				surfaceData.metallic = saturate(decalSurfaceData.metallic);
				surfaceData.specular = 0;
				surfaceData.smoothness = saturate(decalSurfaceData.smoothness);
				surfaceData.occlusion = decalSurfaceData.occlusion;
				surfaceData.emission = decalSurfaceData.emissive;
				surfaceData.alpha = saturate(decalSurfaceData.baseColor.w);
				surfaceData.clearCoatMask = 0;
				surfaceData.clearCoatSmoothness = 1;
			}

			PackedVaryings Vert(Attributes inputMesh  )
			{
				if (_DecalMeshBiasType == DECALMESHDEPTHBIASTYPE_VIEW_BIAS)
				{
					float3 viewDirectionOS = GetObjectSpaceNormalizeViewDir(inputMesh.positionOS);
					inputMesh.positionOS += viewDirectionOS * (_DecalMeshViewBias);
				}

				PackedVaryings packedOutput;
				ZERO_INITIALIZE(PackedVaryings, packedOutput);

				UNITY_SETUP_INSTANCE_ID(inputMesh);
				UNITY_TRANSFER_INSTANCE_ID(inputMesh, packedOutput);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(packedOutput);

				float3 ase_normalWS = TransformObjectToWorldNormal( inputMesh.normalOS );
				float3 ase_tangentWS = TransformObjectToWorldDir( inputMesh.tangentOS.xyz );
				float ase_tangentSign = inputMesh.tangentOS.w * ( unity_WorldTransformParams.w >= 0.0 ? 1.0 : -1.0 );
				float3 ase_bitangentWS = cross( ase_normalWS, ase_tangentWS ) * ase_tangentSign;
				packedOutput.ase_texcoord9.xyz = ase_bitangentWS;
				
				packedOutput.probeOcclusion = float4(inputMesh.positionOS,1);
				
				//setting value to unused interpolator channels and avoid initialization warnings
				packedOutput.ase_texcoord9.w = 0;

				VertexPositionInputs vertexInput = GetVertexPositionInputs(inputMesh.positionOS.xyz);

				float3 positionWS = TransformObjectToWorld(inputMesh.positionOS);
				float3 normalWS = TransformObjectToWorldNormal(inputMesh.normalOS);
				float4 tangentWS = float4(TransformObjectToWorldDir(inputMesh.tangentOS.xyz), inputMesh.tangentOS.w);

				packedOutput.positionCS = TransformWorldToHClip(positionWS);

				if (_DecalMeshBiasType == DECALMESHDEPTHBIASTYPE_DEPTH_BIAS)
				{
					MeshDecalsPositionZBias(packedOutput);
				}

				packedOutput.positionWS.xyz = positionWS;
				packedOutput.normalWS.xyz =  normalWS;
				packedOutput.tangentWS.xyzw =  tangentWS;
				packedOutput.texCoord0.xyzw =  inputMesh.uv0;
				packedOutput.viewDirectionWS.xyz =  GetWorldSpaceViewDir(positionWS);

				#if defined(LIGHTMAP_ON)
					OUTPUT_LIGHTMAP_UV(inputMesh.uv1, unity_LightmapST, packedOutput.lightmapUVs.xy);
				#endif

				#if defined(DYNAMICLIGHTMAP_ON)
					packedOutput.lightmapUVs.zw = inputMesh.uv2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
				#endif

				#if !defined(LIGHTMAP_ON)
					packedOutput.sh.xyz =  float3(SampleSHVertex(half3(normalWS)));
				#endif

				half fogFactor = 0;
				#if !defined(_FOG_FRAGMENT)
						fogFactor = ComputeFogFactor(packedOutput.positionCS.z);
				#endif

				half3 vertexLight = VertexLighting(positionWS, normalWS);
				packedOutput.fogFactorAndVertexLight = half4(fogFactor, vertexLight);

				return packedOutput;
			}

			void Frag(PackedVaryings packedInput,
				out GBufferFragOutput fragmentOutput
				
			)
			{
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(packedInput);
				UNITY_SETUP_INSTANCE_ID(packedInput);

				half angleFadeFactor = 1.0;

            // Only screen space needs flip logic, other passes do not setup needed properties so we skip here
            #if defined(DECAL_SCREEN_SPACE)
				TransformScreenUV(packedInput.positionCS, _ScreenSize.y);
            #endif

            #ifdef _DECAL_LAYERS
            #ifdef _RENDER_PASS_ENABLED
				uint surfaceRenderingLayer = LOAD_FRAMEBUFFER_X_INPUT(GBUFFER4, packedInput.positionCS.xy).r;
            #else
				uint surfaceRenderingLayer = LoadSceneRenderingLayer(packedInput.positionCS.xy);
            #endif
				uint projectorRenderingLayer = asuint(UNITY_ACCESS_INSTANCED_PROP(Decal, _DecalLayerMaskFromDecal));
				clip((surfaceRenderingLayer & projectorRenderingLayer) - 0.1);
            #endif

			#if defined(DECAL_PROJECTOR)
			#if UNITY_REVERSED_Z
			#if _RENDER_PASS_ENABLED
				float depth = LOAD_FRAMEBUFFER_X_INPUT(GBUFFER3, packedInput.positionCS.xy).x;
			#else
				float depth = LoadSceneDepth(packedInput.positionCS.xy);
			#endif
			#else
			#if _RENDER_PASS_ENABLED
				float depth = lerp(UNITY_NEAR_CLIP_VALUE, 1, LOAD_FRAMEBUFFER_X_INPUT(GBUFFER3, packedInput.positionCS.xy));
			#else
			    // Adjust z to match NDC for OpenGL
				float depth = lerp(UNITY_NEAR_CLIP_VALUE, 1, LoadSceneDepth(packedInput.positionCS.xy));
			#endif
			#endif
			#endif

			#if defined(DECAL_RECONSTRUCT_NORMAL)
				#if defined(_RENDER_PASS_ENABLED)
					half3 normalWS = half3(ReconstructNormalDerivative(packedInput.positionCS.xy, LOAD_FRAMEBUFFER_X_INPUT(GBUFFER3, packedInput.positionCS.xy).x));
				#elif defined(_DECAL_NORMAL_BLEND_HIGH)
					half3 normalWS = half3(ReconstructNormalTap9(packedInput.positionCS.xy));
				#elif defined(_DECAL_NORMAL_BLEND_MEDIUM)
					half3 normalWS = half3(ReconstructNormalTap5(packedInput.positionCS.xy));
				#else
					half3 normalWS = half3(ReconstructNormalDerivative(packedInput.positionCS.xy));
				#endif
			#elif defined(DECAL_LOAD_NORMAL)
				#if defined(_RENDER_PASS_ENABLED)
				half3 normalWS = normalize(LOAD_FRAMEBUFFER_X_INPUT(GBUFFER2, packedInput.positionCS.xy).rgb);
				#else
				half3 normalWS = normalize(LoadSceneNormals(packedInput.positionCS.xy).rgb);
				#endif
			#endif

				float2 positionSS = FoveatedRemapNonUniformToLinearCS(packedInput.positionCS.xy) * _ScreenSize.zw;

				float3 positionWS = packedInput.positionWS.xyz;
				half3 viewDirectionWS = half3(packedInput.viewDirectionWS);

				DecalSurfaceData surfaceData;
				SurfaceDescription surfaceDescription = (SurfaceDescription)0;

				float temp_output_1307_0 = radians( _Rotation );
				float temp_output_1301_0 = cos( temp_output_1307_0 );
				float2 break1305 = ( packedInput.texCoord0.xy - float2( 0.5,0.5 ) );
				float temp_output_1300_0 = sin( temp_output_1307_0 );
				float2 appendResult1295 = (float2(( ( temp_output_1301_0 * break1305.x ) + ( temp_output_1300_0 * break1305.y ) ) , ( ( temp_output_1301_0 * break1305.y ) - ( temp_output_1300_0 * break1305.x ) )));
				float2 temp_output_1353_0 = (_BaseColorMap_ST).xy;
				float2 _Vector0 = float2(0.5,0.5);
				// *** BEGIN Flipbook UV Animation vars ***
				// Total tiles of Flipbook Texture
				float fbtotaltiles1358 = min( _FlipbookColumns * _FlipbookRows, 9.0 + 1 );
				// Offsets for cols and rows of Flipbook Texture
				float fbcolsoffset1358 = 1.0f / _FlipbookColumns;
				float fbrowsoffset1358 = 1.0f / _FlipbookRows;
				// Speed of animation
				float fbspeed1358 = _Time[ 1 ] * _FlipbookSpeed;
				// UV Tiling (col and row offset)
				float2 fbtiling1358 = float2(fbcolsoffset1358, fbrowsoffset1358);
				// UV Offset - calculate current tile linear index, and convert it to (X * coloffset, Y * rowoffset)
				// Calculate current tile linear index
				float fbcurrenttileindex1358 = floor( fmod( fbspeed1358 + _FlipbookID, fbtotaltiles1358) );
				fbcurrenttileindex1358 += ( fbcurrenttileindex1358 < 0) ? fbtotaltiles1358 : 0;
				// Obtain Offset X coordinate from current tile linear index
				float fblinearindextox1358 = round ( fmod ( fbcurrenttileindex1358, _FlipbookColumns ) );
				// Reverse X animation if speed is negative
				fblinearindextox1358 = (_FlipbookSpeed > 0 ? fblinearindextox1358 : (int)_FlipbookColumns - fblinearindextox1358);
				// Multiply Offset X by coloffset
				float fboffsetx1358 = fblinearindextox1358 * fbcolsoffset1358;
				// Obtain Offset Y coordinate from current tile linear index
				float fblinearindextoy1358 = round( fmod( ( fbcurrenttileindex1358 - fblinearindextox1358 ) / _FlipbookColumns, _FlipbookRows ) );
				// Reverse Y to get tiles from Top to Bottom and Reverse Y animation if speed is negative
				fblinearindextoy1358 = (_FlipbookSpeed <  0 ? fblinearindextoy1358 : (int)_FlipbookRows - fblinearindextoy1358);
				// Multiply Offset Y by rowoffset
				float fboffsety1358 = fblinearindextoy1358 * fbrowsoffset1358;
				// UV Offset
				float2 fboffset1358 = float2(fboffsetx1358, fboffsety1358);
				// Flipbook UV
				float2 fbuv1358 = ( ( ( ( appendResult1295 * temp_output_1353_0 ) + float2( 0.5,0.5 ) ) + (_BaseColorMap_ST).zw ) - ( ( ( temp_output_1353_0 / 1.0 ) * _Vector0 ) - _Vector0 ) ) * fbtiling1358 + fboffset1358;
				// *** END Flipbook UV Animation vars ***
				int flipbookFrame1358 = ( ( int )fbcurrenttileindex1358);
				float2 temp_output_1490_0 = ddx( fbuv1358 );
				float2 temp_output_1491_0 = ddy( fbuv1358 );
				float temp_output_410_0 = ( _ParallaxAmplitude * 0.001 );
				float3 ase_bitangentWS = packedInput.ase_texcoord9.xyz;
				float3 tanToWorld0 = float3( packedInput.tangentWS.xyz.x, ase_bitangentWS.x, packedInput.normalWS.x );
				float3 tanToWorld1 = float3( packedInput.tangentWS.xyz.y, ase_bitangentWS.y, packedInput.normalWS.y );
				float3 tanToWorld2 = float3( packedInput.tangentWS.xyz.z, ase_bitangentWS.z, packedInput.normalWS.z );
				float3 ase_viewVectorTS =  tanToWorld0 * ( _WorldSpaceCameraPos.xyz - packedInput.positionWS ).x + tanToWorld1 * ( _WorldSpaceCameraPos.xyz - packedInput.positionWS ).y  + tanToWorld2 * ( _WorldSpaceCameraPos.xyz - packedInput.positionWS ).z;
				float2 Offset1512 = ( ( SAMPLE_TEXTURE2D_GRAD( _ParallaxMap, sampler_ParallaxMap, fbuv1358, temp_output_1490_0, temp_output_1491_0 ).r - 1 ) * ase_viewVectorTS.xy * temp_output_410_0 ) + fbuv1358;
				float2 Offset1554 = ( ( SAMPLE_TEXTURE2D_GRAD( _ParallaxMap, sampler_ParallaxMap, fbuv1358, temp_output_1490_0, temp_output_1491_0 ).r - 1 ) * ase_viewVectorTS.xy * temp_output_410_0 ) + Offset1512;
				float2 Offset1605 = ( ( SAMPLE_TEXTURE2D_GRAD( _ParallaxMap, sampler_ParallaxMap, fbuv1358, temp_output_1490_0, temp_output_1491_0 ).r - 1 ) * ase_viewVectorTS.xy * temp_output_410_0 ) + Offset1554;
				float2 Offset1606 = ( ( SAMPLE_TEXTURE2D_GRAD( _ParallaxMap, sampler_ParallaxMap, fbuv1358, temp_output_1490_0, temp_output_1491_0 ).r - 1 ) * ase_viewVectorTS.xy * temp_output_410_0 ) + Offset1605;
				float2 lerpResult1376 = lerp( fbuv1358 , Offset1606 , _EnableParallax);
				float2 UV1050 = lerpResult1376;
				float2 UV_DDX1265 = temp_output_1490_0;
				float2 UV_DDY1266 = temp_output_1491_0;
				float4 tex2DNode445 = SAMPLE_TEXTURE2D_GRAD( _BaseColorMap, sampler_BaseColorMap, UV1050, UV_DDX1265, UV_DDY1266 );
				float3 BaseColor554 = ( (tex2DNode445).rgb * (_BaseColor).rgb );
				
				float BaseColorMap_Alpha631 = tex2DNode445.a;
				float temp_output_523_0 = ( BaseColorMap_Alpha631 * ( 1.0 - _DecalOpacity ) );
				float3 temp_output_702_0 = ( packedInput.probeOcclusion.xyz + float3( 0.5,0.5,0.5 ) );
				float temp_output_698_0 = saturate( ( ( _HeightScale * ( temp_output_702_0 * ( 1.0 - temp_output_702_0 ) ).y ) + _HeightOffset ) );
				float smoothstepResult705 = smoothstep( temp_output_698_0 , ( temp_output_698_0 + 0.001 ) , ( SAMPLE_TEXTURE2D_GRAD( _ParallaxMap, sampler_ParallaxMap, UV1050, UV_DDX1265, UV_DDY1266 ).r * SAMPLE_TEXTURE2D_GRAD( _ParallaxMap, sampler_ParallaxMap, UV1050, UV_DDX1265, UV_DDY1266 ).r ));
				float Height746 = smoothstepResult705;
				float lerpResult1383 = lerp( temp_output_523_0 , ( temp_output_523_0 * Height746 ) , _EnableHeight);
				float Alpha635 = lerpResult1383;
				
				float3 unpack444 = UnpackNormalScale( SAMPLE_TEXTURE2D_GRAD( _NormalMap, sampler_NormalMap, UV1050, UV_DDX1265, UV_DDY1266 ), _NormalScale );
				unpack444.z = lerp( 1, unpack444.z, saturate(_NormalScale) );
				float3 Normal556 = unpack444;
				
				float m_switch857 = _NormalOpacityChannel;
				float m_BaseColorMapAlpha857 = temp_output_523_0;
				float4 tex2DNode607 = SAMPLE_TEXTURE2D_GRAD( _MaskMap, sampler_BaseColorMap, UV1050, UV_DDX1265, UV_DDY1266 );
				float Opacity_Mask632 = tex2DNode607.b;
				float m_MaskMapBlue857 = ( _DecalMaskMapBlueScale1 * Opacity_Mask632 );
				float local_SwitchNormalOpacity857 = _SwitchNormalOpacity( m_switch857 , m_BaseColorMapAlpha857 , m_MaskMapBlue857 );
				float lerpResult1382 = lerp( local_SwitchNormalOpacity857 , ( local_SwitchNormalOpacity857 * Height746 ) , _EnableHeight);
				float Alpha_Normal636 = lerpResult1382;
				
				float Metallic624 = ( _MaskmapMetal * tex2DNode607.r );
				
				float Occlusion626 = saturate( ( ( 1.0 - _MaskmapAO ) * tex2DNode607.g ) );
				
				float Smoothness625 = ( _MaskmapSmoothness * tex2DNode607.a );
				
				float3 color1672 = IsGammaSpace() ? float3( 0, 0, 0 ) : float3( 0, 0, 0 );
				float2 UV_Parallax_Off1456 = fbuv1358;
				float temp_output_2_0_g61768 = _AlbedoAffectEmissive;
				float temp_output_3_0_g61768 = ( 1.0 - temp_output_2_0_g61768 );
				float3 appendResult7_g61768 = (float3(temp_output_3_0_g61768 , temp_output_3_0_g61768 , temp_output_3_0_g61768));
				float3 lerpResult1671 = lerp( color1672 , ( (SAMPLE_TEXTURE2D_GRAD( _EmissiveColorMap, sampler_EmissiveColorMap, UV_Parallax_Off1456, UV_DDX1265, UV_DDY1266 )).rgb * ( ( _EmissiveColor * _EmissiveIntensity ) * ( ( BaseColor554 * temp_output_2_0_g61768 ) + appendResult7_g61768 ) ) ) , _AffectEmission);
				float3 Emissive558 = lerpResult1671;
				

				surfaceDescription.BaseColor = BaseColor554;
				surfaceDescription.Alpha = Alpha635;
				surfaceDescription.NormalTS = Normal556;
				surfaceDescription.NormalAlpha = Alpha_Normal636;

				#if defined( _MATERIAL_AFFECTS_MAOS )
					surfaceDescription.Metallic = Metallic624;
					surfaceDescription.Occlusion = Occlusion626;
					surfaceDescription.Smoothness = Smoothness625;
					surfaceDescription.MAOSAlpha = 1;
				#endif

				#if defined( _MATERIAL_AFFECTS_EMISSION )
					surfaceDescription.Emission = Emissive558;
				#endif

				GetSurfaceData(packedInput, surfaceDescription, surfaceData);

				half3 normalToPack = surfaceData.normalWS.xyz;
				#ifdef DECAL_RECONSTRUCT_NORMAL
					surfaceData.normalWS.xyz = normalize(lerp(normalWS.xyz, surfaceData.normalWS.xyz, surfaceData.normalWS.w));
				#endif

					InputData inputData;
					InitializeInputData(packedInput, positionWS, surfaceData.normalWS.xyz, viewDirectionWS, inputData);

					SurfaceData surface = (SurfaceData)0;
					GetSurface(surfaceData, surface);

					BRDFData brdfData;
					InitializeBRDFData(surface.albedo, surface.metallic, 0, surface.smoothness, surface.alpha, brdfData);

				#ifdef _MATERIAL_AFFECTS_ALBEDO
					Light mainLight = GetMainLight(inputData.shadowCoord, inputData.positionWS, inputData.shadowMask);
					MixRealtimeAndBakedGI(mainLight, surfaceData.normalWS.xyz, inputData.bakedGI, inputData.shadowMask);
					half3 color = GlobalIllumination(brdfData, inputData.bakedGI, surface.occlusion, surfaceData.normalWS.xyz, inputData.viewDirectionWS);
				#else
					half3 color = 0;
				#endif
	
				// ShaderPassDecal.hlsl
				// We can not use usual GBuffer functions (etc. BRDFDataToGbuffer) as we use alpha for blending
				#pragma warning (disable : 3578) // The output value isn't completely initialized.
				half3 packedNormalWS = PackGBufferNormal(normalToPack);
				fragmentOutput.gBuffer0 = half4(surfaceData.baseColor.rgb, surfaceData.baseColor.a);
				fragmentOutput.gBuffer1 = 0;
				fragmentOutput.gBuffer2 = half4(packedNormalWS, surfaceData.normalWS.a);
				fragmentOutput.color = half4(surfaceData.emissive + color, surfaceData.baseColor.a);

				#if defined(GBUFFER_FEATURE_SHADOWMASK)
					fragmentOutput.shadowMask = inputData.shadowMask;
				#endif

				#pragma warning (default : 3578) // Restore output value isn't completely initialized.

				#if defined(DECAL_FORWARD_EMISSIVE)
				// Emissive need to be pre-exposed
				outEmissive.rgb = surfaceData.emissive * GetCurrentExposureMultiplier();
				outEmissive.a = surfaceData.baseColor.a;
				#endif

			}

            ENDHLSL
        }

		
        Pass
        {
            
			Name "ScenePickingPass"
            Tags { "LightMode"="Picking" }

            Cull Back

			HLSLPROGRAM

			#define _MATERIAL_AFFECTS_ALBEDO 1
			#define _MATERIAL_AFFECTS_NORMAL 1
			#define _MATERIAL_AFFECTS_NORMAL_BLEND 1
			#define  _MATERIAL_AFFECTS_MAOS 1
			#define _MATERIAL_AFFECTS_EMISSION 1
			#define ASE_VERSION 19907
			#define ASE_SRP_VERSION 170300
			#define ASE_USING_SAMPLING_MACROS 1


			#pragma multi_compile_instancing
			#pragma editor_sync_compilation
			#pragma vertex Vert
			#pragma fragment Frag

            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            #define HAVE_MESH_MODIFICATION

            #define SHADERPASS SHADERPASS_DEPTHONLY
			#define SCENEPICKINGPASS 1

            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
            #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DecalInput.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderVariablesDecal.hlsl"

            #if _RENDER_PASS_ENABLED
            #define GBUFFER3 0
            FRAMEBUFFER_INPUT_X_FLOAT(GBUFFER3);
            #define GBUFFER4 1
            FRAMEBUFFER_INPUT_X_UINT(GBUFFER4);
            #endif

			#define ASE_NEEDS_TEXTURE_COORDINATES0
			#define ASE_NEEDS_FRAG_TEXTURE_COORDINATES0
			#define ASE_NEEDS_VERT_TANGENT
			#define ASE_NEEDS_VERT_NORMAL


			struct Attributes
			{
				float3 positionOS : POSITION;
				float3 normalOS : NORMAL;
				float4 tangentOS : TANGENT;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct PackedVaryings
			{
				float4 positionCS : SV_POSITION;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_texcoord4 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

            CBUFFER_START(UnityPerMaterial)
			float4 _BaseColorMap_ST;
			float4 _BaseColor;
			float3 _EmissiveColor;
			float _Rotation;
			half _EmissiveIntensity;
			float _MaskOpacityChannel;
			half _MaskmapSmoothness;
			half _MaskmapAO;
			half _MaskmapMetal;
			float _DecalMaskMapBlueScale1;
			float _NormalOpacityChannel;
			float _NormalScale;
			float _HeightOffset;
			float _AlbedoAffectEmissive;
			float _HeightScale;
			half _DecalOpacity;
			float _EnableParallax;
			float _ParallaxAmplitude;
			half _FlipbookID;
			half _FlipbookSpeed;
			half _FlipbookRows;
			half _FlipbookColumns;
			float _EnableHeight;
			float _AffectEmission;
			float _DrawOrder;
			float _DecalMeshBiasType;
			float _DecalMeshDepthBias;
			float _DecalMeshViewBias;
			#if defined(DECAL_ANGLE_FADE)
			float _DecalAngleFadeSupported;
			#endif
			UNITY_TEXTURE_STREAMING_DEBUG_VARS;
			CBUFFER_END

            #ifdef SCENEPICKINGPASS
				float4 _SelectionID;
            #endif

            #ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
            #endif

			TEXTURE2D(_BaseColorMap);
			TEXTURE2D(_ParallaxMap);
			SAMPLER(sampler_ParallaxMap);
			SAMPLER(sampler_BaseColorMap);


			
            #if (SHADERPASS == SHADERPASS_DBUFFER_PROJECTOR) || (SHADERPASS == SHADERPASS_FORWARD_EMISSIVE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_PROJECTOR)
            #define DECAL_PROJECTOR
            #endif

            #if (SHADERPASS == SHADERPASS_DBUFFER_MESH) || (SHADERPASS == SHADERPASS_FORWARD_EMISSIVE_MESH) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_MESH) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_MESH)
            #define DECAL_MESH
            #endif

            #if (SHADERPASS == SHADERPASS_DBUFFER_PROJECTOR) || (SHADERPASS == SHADERPASS_DBUFFER_MESH)
            #define DECAL_DBUFFER
            #endif

            #if (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_SCREEN_SPACE_MESH)
            #define DECAL_SCREEN_SPACE
            #endif

            #if (SHADERPASS == SHADERPASS_DECAL_GBUFFER_PROJECTOR) || (SHADERPASS == SHADERPASS_DECAL_GBUFFER_MESH)
            #define DECAL_GBUFFER
            #endif

            #if (SHADERPASS == SHADERPASS_FORWARD_EMISSIVE_PROJECTOR) || (SHADERPASS == SHADERPASS_FORWARD_EMISSIVE_MESH)
            #define DECAL_FORWARD_EMISSIVE
            #endif

            #if ((!defined(_MATERIAL_AFFECTS_NORMAL) && defined(_MATERIAL_AFFECTS_ALBEDO)) || (defined(_MATERIAL_AFFECTS_NORMAL) && defined(_MATERIAL_AFFECTS_NORMAL_BLEND))) && (defined(DECAL_SCREEN_SPACE) || defined(DECAL_GBUFFER))
            #define DECAL_RECONSTRUCT_NORMAL
            #elif defined(DECAL_ANGLE_FADE)
            #define DECAL_LOAD_NORMAL
            #endif

            #ifdef _DECAL_LAYERS
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DeclareRenderingLayerTexture.hlsl"
            #endif

            #if defined(DECAL_LOAD_NORMAL)
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DeclareNormalsTexture.hlsl"
            #endif

            #if defined(DECAL_PROJECTOR) || defined(DECAL_RECONSTRUCT_NORMAL)
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DeclareDepthTexture.hlsl"
            #endif

            #ifdef DECAL_MESH
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DecalMeshBiasTypeEnum.cs.hlsl"
            #endif

            #ifdef DECAL_RECONSTRUCT_NORMAL
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/NormalReconstruction.hlsl"
            #endif

			PackedVaryings Vert(Attributes inputMesh  )
			{
				PackedVaryings packedOutput;
				ZERO_INITIALIZE(PackedVaryings, packedOutput);

				UNITY_SETUP_INSTANCE_ID(inputMesh);
				UNITY_TRANSFER_INSTANCE_ID(inputMesh, packedOutput);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(packedOutput);

				inputMesh.tangentOS = float4( 1, 0, 0, -1 );
				inputMesh.normalOS = float3( 0, 1, 0 );

				float3 ase_positionWS = TransformObjectToWorld( ( inputMesh.positionOS ).xyz );
				packedOutput.ase_texcoord1.xyz = ase_positionWS;
				float3 ase_tangentWS = TransformObjectToWorldDir( inputMesh.tangentOS.xyz );
				packedOutput.ase_texcoord2.xyz = ase_tangentWS;
				float3 ase_normalWS = TransformObjectToWorldNormal( inputMesh.normalOS );
				packedOutput.ase_texcoord3.xyz = ase_normalWS;
				float ase_tangentSign = inputMesh.tangentOS.w * ( unity_WorldTransformParams.w >= 0.0 ? 1.0 : -1.0 );
				float3 ase_bitangentWS = cross( ase_normalWS, ase_tangentWS ) * ase_tangentSign;
				packedOutput.ase_texcoord4.xyz = ase_bitangentWS;
				
				packedOutput.ase_texcoord.xy = inputMesh.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				packedOutput.ase_texcoord.zw = 0;
				packedOutput.ase_texcoord1.w = 0;
				packedOutput.ase_texcoord2.w = 0;
				packedOutput.ase_texcoord3.w = 0;
				packedOutput.ase_texcoord4.w = 0;

				float3 positionWS = TransformObjectToWorld(inputMesh.positionOS);
				packedOutput.positionCS = TransformWorldToHClip(positionWS);

				return packedOutput;
			}

			void Frag(PackedVaryings packedInput,
				out float4 outColor : SV_Target0
				
			)
			{
				float temp_output_1307_0 = radians( _Rotation );
				float temp_output_1301_0 = cos( temp_output_1307_0 );
				float2 break1305 = ( packedInput.ase_texcoord.xy - float2( 0.5,0.5 ) );
				float temp_output_1300_0 = sin( temp_output_1307_0 );
				float2 appendResult1295 = (float2(( ( temp_output_1301_0 * break1305.x ) + ( temp_output_1300_0 * break1305.y ) ) , ( ( temp_output_1301_0 * break1305.y ) - ( temp_output_1300_0 * break1305.x ) )));
				float2 temp_output_1353_0 = (_BaseColorMap_ST).xy;
				float2 _Vector0 = float2(0.5,0.5);
				// *** BEGIN Flipbook UV Animation vars ***
				// Total tiles of Flipbook Texture
				float fbtotaltiles1358 = min( _FlipbookColumns * _FlipbookRows, 9.0 + 1 );
				// Offsets for cols and rows of Flipbook Texture
				float fbcolsoffset1358 = 1.0f / _FlipbookColumns;
				float fbrowsoffset1358 = 1.0f / _FlipbookRows;
				// Speed of animation
				float fbspeed1358 = _Time[ 1 ] * _FlipbookSpeed;
				// UV Tiling (col and row offset)
				float2 fbtiling1358 = float2(fbcolsoffset1358, fbrowsoffset1358);
				// UV Offset - calculate current tile linear index, and convert it to (X * coloffset, Y * rowoffset)
				// Calculate current tile linear index
				float fbcurrenttileindex1358 = floor( fmod( fbspeed1358 + _FlipbookID, fbtotaltiles1358) );
				fbcurrenttileindex1358 += ( fbcurrenttileindex1358 < 0) ? fbtotaltiles1358 : 0;
				// Obtain Offset X coordinate from current tile linear index
				float fblinearindextox1358 = round ( fmod ( fbcurrenttileindex1358, _FlipbookColumns ) );
				// Reverse X animation if speed is negative
				fblinearindextox1358 = (_FlipbookSpeed > 0 ? fblinearindextox1358 : (int)_FlipbookColumns - fblinearindextox1358);
				// Multiply Offset X by coloffset
				float fboffsetx1358 = fblinearindextox1358 * fbcolsoffset1358;
				// Obtain Offset Y coordinate from current tile linear index
				float fblinearindextoy1358 = round( fmod( ( fbcurrenttileindex1358 - fblinearindextox1358 ) / _FlipbookColumns, _FlipbookRows ) );
				// Reverse Y to get tiles from Top to Bottom and Reverse Y animation if speed is negative
				fblinearindextoy1358 = (_FlipbookSpeed <  0 ? fblinearindextoy1358 : (int)_FlipbookRows - fblinearindextoy1358);
				// Multiply Offset Y by rowoffset
				float fboffsety1358 = fblinearindextoy1358 * fbrowsoffset1358;
				// UV Offset
				float2 fboffset1358 = float2(fboffsetx1358, fboffsety1358);
				// Flipbook UV
				float2 fbuv1358 = ( ( ( ( appendResult1295 * temp_output_1353_0 ) + float2( 0.5,0.5 ) ) + (_BaseColorMap_ST).zw ) - ( ( ( temp_output_1353_0 / 1.0 ) * _Vector0 ) - _Vector0 ) ) * fbtiling1358 + fboffset1358;
				// *** END Flipbook UV Animation vars ***
				int flipbookFrame1358 = ( ( int )fbcurrenttileindex1358);
				float2 temp_output_1490_0 = ddx( fbuv1358 );
				float2 temp_output_1491_0 = ddy( fbuv1358 );
				float temp_output_410_0 = ( _ParallaxAmplitude * 0.001 );
				float3 ase_positionWS = packedInput.ase_texcoord1.xyz;
				float3 ase_tangentWS = packedInput.ase_texcoord2.xyz;
				float3 ase_normalWS = packedInput.ase_texcoord3.xyz;
				float3 ase_bitangentWS = packedInput.ase_texcoord4.xyz;
				float3 tanToWorld0 = float3( ase_tangentWS.x, ase_bitangentWS.x, ase_normalWS.x );
				float3 tanToWorld1 = float3( ase_tangentWS.y, ase_bitangentWS.y, ase_normalWS.y );
				float3 tanToWorld2 = float3( ase_tangentWS.z, ase_bitangentWS.z, ase_normalWS.z );
				float3 ase_viewVectorTS =  tanToWorld0 * ( _WorldSpaceCameraPos.xyz - ase_positionWS ).x + tanToWorld1 * ( _WorldSpaceCameraPos.xyz - ase_positionWS ).y  + tanToWorld2 * ( _WorldSpaceCameraPos.xyz - ase_positionWS ).z;
				float2 Offset1512 = ( ( SAMPLE_TEXTURE2D_GRAD( _ParallaxMap, sampler_ParallaxMap, fbuv1358, temp_output_1490_0, temp_output_1491_0 ).r - 1 ) * ase_viewVectorTS.xy * temp_output_410_0 ) + fbuv1358;
				float2 Offset1554 = ( ( SAMPLE_TEXTURE2D_GRAD( _ParallaxMap, sampler_ParallaxMap, fbuv1358, temp_output_1490_0, temp_output_1491_0 ).r - 1 ) * ase_viewVectorTS.xy * temp_output_410_0 ) + Offset1512;
				float2 Offset1605 = ( ( SAMPLE_TEXTURE2D_GRAD( _ParallaxMap, sampler_ParallaxMap, fbuv1358, temp_output_1490_0, temp_output_1491_0 ).r - 1 ) * ase_viewVectorTS.xy * temp_output_410_0 ) + Offset1554;
				float2 Offset1606 = ( ( SAMPLE_TEXTURE2D_GRAD( _ParallaxMap, sampler_ParallaxMap, fbuv1358, temp_output_1490_0, temp_output_1491_0 ).r - 1 ) * ase_viewVectorTS.xy * temp_output_410_0 ) + Offset1605;
				float2 lerpResult1376 = lerp( fbuv1358 , Offset1606 , _EnableParallax);
				float2 UV1050 = lerpResult1376;
				float2 UV_DDX1265 = temp_output_1490_0;
				float2 UV_DDY1266 = temp_output_1491_0;
				float4 tex2DNode445 = SAMPLE_TEXTURE2D_GRAD( _BaseColorMap, sampler_BaseColorMap, UV1050, UV_DDX1265, UV_DDY1266 );
				float3 BaseColor554 = ( (tex2DNode445).rgb * (_BaseColor).rgb );
				

				float3 BaseColor = BaseColor554;

				outColor = unity_SelectionID;
			}
			ENDHLSL
        }
    }
	CustomEditor "UnityEditor.Rendering.Universal.DecalShaderGraphGUI"
    FallBack "Hidden/Shader Graph/FallbackError"
	
	Fallback Off
}
/*ASEBEGIN
Version=19907
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;983;-6000,1104;Inherit;False;3240.073;2030.361;UV;46;1328;921;1355;981;1358;1361;1363;1362;1364;1334;1089;1313;1352;1292;1342;1351;1436;1345;1435;1340;1349;1291;1338;1356;1295;1350;1357;1303;1302;1353;1299;1298;1297;1296;1305;1300;1301;436;1304;1307;1369;1324;1327;1323;1330;1326;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1326;-5712,2416;Inherit;False;122.5;139;UV;1;1325;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1330;-5712,2576;Inherit;False;122.5;139;Anchor;1;1331;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1328;-5712,2224;Inherit;False;122.5;139;Rotation;1;1329;;0,0,0,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1323;-5904,2272;Inherit;False;Property;_Rotation;Rotation;6;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1324;-5968,2624;Inherit;False;Constant;_RotationAnchor;Rotation Anchor;9;0;Create;True;0;0;0;False;0;False;0.5,0.5;0.5,0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TexCoordVertexDataNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1327;-5952,2464;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RelayNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1329;-5696,2272;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1325;-5696,2464;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RelayNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1331;-5696,2624;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1369;-5088,2688;Inherit;False;128.741;147.8699;Tiling Offset;1;1368;;0,0,0,1;0;0
Node;AmplifyShaderEditor.RadiansOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1307;-5536,2272;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1304;-5536,2464;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector4Node, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;436;-5296,2736;Inherit;False;Property;_BaseColorMap_ST;Main UVs;7;0;Create;False;0;0;0;False;0;False;1,1,0,0;8,8.58,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1610;-2704,2560;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CosOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1301;-5360,2272;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1300;-5360,2368;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1305;-5360,2464;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RelayNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1368;-5072,2736;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1611;-2704,1456;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1296;-5200,2272;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1297;-5200,2368;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1298;-5200,2464;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1299;-5200,2560;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1353;-4896,2816;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RelayNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1492;-2640,1360;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1461;-2144,1200;Inherit;False;128;128;View Dir;1;1486;;0,0,0,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1302;-5024,2320;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1303;-5024,2432;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1357;-4736,2816;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RelayNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1608;-2496,1360;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ViewVectorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1625;-2336,1248;Inherit;False;Tangent;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;994;-2256,2432;Inherit;False;130.4539;134.5774;Amplitude;1;993;;0,0,0,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1350;-4880,2896;Inherit;False;Constant;_Float3;Float 1;0;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1295;-4880,2416;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1356;-4736,2496;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;411;-2480,2480;Inherit;False;Property;_ParallaxAmplitude;Parallax Amplitude;23;0;Create;True;0;0;0;False;0;False;1;0.15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1609;-2128,1360;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RelayNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1486;-2128,1248;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector2Node, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1338;-4672,2928;Inherit;False;Constant;_Vector0;Vector 0;1;0;Create;True;0;0;0;False;0;False;0.5,0.5;0.5,0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1291;-4688,2416;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1349;-4672,2816;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1566;-2000,1312;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TexturePropertyNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;481;-2608,1024;Inherit;True;Property;_ParallaxMap;Height Map;18;1;[SingleLineTexture];Create;False;0;0;0;False;1;Space(15);False;None;9058b7ce77d448f9a967080425fab9d4;False;white;Auto;Texture2D;False;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.DdxOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1490;-2496,1440;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DdyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1491;-2496,1520;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RelayNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;993;-2240,2480;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1621;-1968,1424;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1340;-4464,2816;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1435;-4544,2496;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1567;-2000,1312;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1480;-2336,1600;Inherit;True;Property;_TextureSample01;Texture Sample 01;21;0;Create;True;1;;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Derivative;Texture2D;False;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1561;-2016,1680;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1622;-1968,1616;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;410;-2096,2480;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.001;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1345;-4288,2912;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1436;-4544,2592;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1564;-2000,1312;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1559;-2016,1872;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1505;-2336,1808;Inherit;True;Property;_TextureSample7;Texture Sample 02;9;0;Create;False;1;;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Derivative;Texture2D;False;8;0;SAMPLER2D;FLOAT2;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ParallaxMappingNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1512;-1920,1632;Inherit;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1351;-4144,2912;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SwizzleNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1342;-4464,2736;Inherit;False;FLOAT2;2;3;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1292;-4496,2592;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1565;-2000,1312;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1557;-2016,2096;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1537;-2336,2016;Inherit;True;Property;_TextureSample9;Texture Sample 03;9;0;Create;False;1;;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Derivative;Texture2D;False;8;0;SAMPLER2D;FLOAT2;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ParallaxMappingNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1554;-1920,1840;Inherit;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1352;-4144,2688;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1313;-4288,2592;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1550;-2000,2272;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1546;-2336,2224;Inherit;True;Property;_TextureSample11;Texture Sample 04;9;0;Create;False;1;;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Derivative;Texture2D;False;8;0;SAMPLER2D;FLOAT2;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ParallaxMappingNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1605;-1920,2048;Inherit;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1089;-3824,2544;Inherit;False;130.7438;132.9371;Raw UV;1;1042;;0,0,0,1;0;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1334;-4080,2592;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ParallaxMappingNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1606;-1920,2256;Inherit;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1364;-3264,2912;Half;False;Property;_FlipbookSpeed;Flipbook Speed;9;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1362;-3296,2672;Half;False;Property;_FlipbookColumns;Flipbook Columns;10;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1363;-3264,2752;Half;False;Property;_FlipbookRows;Flipbook Rows;11;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1361;-3264,2832;Half;False;Property;_FlipbookID;Flipbook ID;8;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1042;-3808,2592;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1623;-1712,2336;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TFHCFlipBookUVAnimation, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1358;-3040,2592;Inherit;True;0;1;7;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;1;False;6;FLOAT;9;False;4;FLOAT2;0;FLOAT;1;FLOAT;2;INT;3
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1624;-1712,2624;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1377;-1872,2672;Inherit;False;Property;_EnableParallax;Enable Parallax;22;1;[Toggle];Create;True;0;0;0;False;1;Space(15);False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1376;-1664,2592;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;878;-928,-1936;Inherit;False;Property;_BaseColor;MainColor;4;0;Create;False;0;0;0;False;1;Space(25);False;1,1,1,0;0.8113207,0.8113207,0.8113207,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1265;-2320,1440;Inherit;False;UV DDX;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1266;-2320,1520;Inherit;False;UV DDY;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1050;-1504,2592;Inherit;False;UV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SwizzleNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;886;-704,-1936;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TexturePropertyNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;438;-1472,-1648;Inherit;True;Property;_BaseColorMap;Base Color Map;5;1;[SingleLineTexture];Create;False;0;0;0;False;0;False;None;9058b7ce77d448f9a967080425fab9d4;False;white;Auto;Texture2D;False;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1049;-1440,-1856;Inherit;False;1050;UV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1048;-1440,-1792;Inherit;False;1265;UV DDX;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1047;-1440,-1728;Inherit;False;1266;UV DDY;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;445;-1152,-1648;Inherit;True;Property;_TextureSample8;Texture Sample 0;22;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Derivative;Texture2D;False;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;887;-560,-1872;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwizzleNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;446;-832,-1648;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;888;-560,-1648;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1658;-7314,1774;Inherit;False;1284;1360.306;Comment;26;1655;1656;1652;1657;1650;1649;1647;1646;1645;1644;1643;1641;1640;1639;1636;1635;1632;1629;1654;1653;1648;1638;1633;1630;1627;1626;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;630;-1788.667,-2944;Inherit;False;2049.698;808.241;Alpha;19;635;636;637;865;866;863;897;857;858;523;566;634;552;553;565;860;561;1387;1389;;0,0,0,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;885;-512,-1648;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1626;-7264,2816;Inherit;False;187.7404;139.1859;Calculate Face Normals;1;1628;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1627;-7264,1824;Inherit;False;246.337;249.3465;Position - World Space;1;1631;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1630;-6976,1824;Inherit;False;129.5;131.5;Position WS;1;1634;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1633;-6784,1824;Inherit;False;196.1649;287.6873;YZ Decal Left/Right;1;1637;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1638;-6784,2112;Inherit;False;204.1237;281.0552;XZ Decal Top/Bottom;1;1642;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1648;-6784,2432;Inherit;False;204.1237;296.9725;XY Decal Front/Back;1;1651;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;981;-4016,1184;Inherit;False;1222.822;701.5736;Decal View Vector World Space;16;982;977;947;1081;1080;930;1077;932;1282;1109;1354;1078;1108;970;968;972;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1387;-622,-2880;Inherit;False;620.757;708.6213;height blending;11;1370;1383;1382;1381;1380;1373;1371;1372;1384;1386;1385;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;561;-1312,-2880;Inherit;False;131.0771;128.3045;Alpha BaseColor;1;560;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;651;-480,592;Inherit;False;138.4912;129.7859;BaseColor;1;650;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;687;16,1008;Inherit;False;162.5;173.5;Squared;1;730;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;688;-288,1472;Inherit;False;137.3674;140.4977;Height Offset;1;708;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;690;-896,1296;Inherit;False;452;196.6667;Decal Dimensions - Zero to One;3;704;703;702;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;691;-448,1152;Inherit;False;126.5;128;Height Scale;1;712;;0,0,0,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;554;-256,-1648;Inherit;False;BaseColor;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;972;-3632,1632;Inherit;False;Normal Face;-1;;61767;f4725843c667a994e8a7e4987db394b2;2,88,0,86,1;0;1;FLOAT3;30
Node;AmplifyShaderEditor.AbsOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;968;-3456,1632;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RoundOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;970;-3344,1632;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1355;-3680,2560;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1108;-3200,1616;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BitangentVertexDataNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1078;-3456,1472;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1354;-3680,1344;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1109;-3200,1440;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1282;-3232,1440;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldSpaceCameraPos, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;932;-3952,1248;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TangentVertexDataNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1077;-3424,1328;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;930;-3632,1248;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.MatrixFromVectors, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1080;-3136,1328;Inherit;False;FLOAT3x3;1;4;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3x3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1081;-2944,1248;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3x3;1,0,0,0,1,0,0,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StickyNoteNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;854;-1664,-560;Inherit;False;374.644;132.024;Mask Map MAOS;;0,0,0,1;• Red: Stores the metallic map.$• Green: Stores the ambient occlusion map.$• Blue: Stores the opacity mask map.$• Alpha: Stores the smoothness map;0;0
Node;AmplifyShaderEditor.StickyNoteNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;860;-1744,-2656;Inherit;False;501.685;115.5942;Scale Mask Map Blue Channel;;0,0,0,1;Use the slider to set the opacity value to use for Mettalic, Ambient Occlusion and Smoothness if Mask Opacity channel is setup to Mask Opacity. A value of 0 means no effect and a value of 1 means full effect.;0;0
Node;AmplifyShaderEditor.StickyNoteNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;877;-1728,-1648;Inherit;False;194.5;100;Base Color Map;;0,0,0,1;_BaseColorMap;0;0
Node;AmplifyShaderEditor.StickyNoteNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;879;-1152,-1936;Inherit;False;194.5;100;MainColor;;0,0,0,1;_BaseColor;0;0
Node;AmplifyShaderEditor.StickyNoteNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;880;-1728,-1200;Inherit;False;194.5;100;Normal Map;;0,0,0,1;_NormalMap;0;0
Node;AmplifyShaderEditor.StickyNoteNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;881;-1728,-752;Inherit;False;194.5;100;Mask Map MAOS;;0,0,0,1;_MaskMap;0;0
Node;AmplifyShaderEditor.StickyNoteNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;882;-1664,176;Inherit;False;194.5;100;Emissive Color Map;;0,0,0,1;_EmissiveColorMap;0;0
Node;AmplifyShaderEditor.StickyNoteNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;883;-2736,912;Inherit;False;194.5;100;Height Map;;0,0,0,1;_ParallaxMap;0;0
Node;AmplifyShaderEditor.StickyNoteNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;884;-848,288;Inherit;False;167.4515;100;Emissive Color;;0,0,0,1;_EmissiveColor;0;0
Node;AmplifyShaderEditor.StickyNoteNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;890;-1136,-112;Inherit;False;222.2261;100;Smoothness;;0,0,0,1;_Smoothness$_MaskmapSmoothness;0;0
Node;AmplifyShaderEditor.StickyNoteNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;891;-1136,-304;Inherit;False;223.0974;100;Ambient Occlusion;;0,0,0,1;_AO$_MaskmapAO;0;0
Node;AmplifyShaderEditor.StickyNoteNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;892;-1136,-496;Inherit;False;223.9687;100;Metallic;;0,0,0,1;_Metallic$_MaskmapMetal;0;0
Node;AmplifyShaderEditor.StickyNoteNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;921;-5504,2736;Inherit;False;173.5332;100;Main UVs;;0,0,0,1;_BaseColorMap_ST;0;0
Node;AmplifyShaderEditor.StickyNoteNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;947;-3632,1712;Inherit;False;411.8994;136.728; Normal Face WS;;0,0,0,1;For regular meshes, we would use a Vertex Normal node here, but decals don't have a Vertex Normal, so we use the Normal Face node to derive the approximate world space normal of the surfaces that the decal intersects.;0;0
Node;AmplifyShaderEditor.StickyNoteNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;977;-3968,1408;Inherit;False;272.8044;132.4425;;;0,0,0,1;You can create the same vector as the View Vector node by subtracting the Position in World Space from the Camera Position. $;0;0
Node;AmplifyShaderEditor.StickyNoteNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;982;-3136,1456;Inherit;False;327.797;165.3965;World Space to Tangent  Transformation;;0,0,0,1;we would normally use vertex normals for this operation however in decal we use the Normal Face node to derive the approximate world space normal of the surfaces that the decal intersects$;0;0
Node;AmplifyShaderEditor.StickyNoteNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;995;-656,-1024;Inherit;False;165.5;100;Normal Strength;;0,0,0,1;_NormalScale;0;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;667;-1248,-1536;Inherit;False;1;0;SAMPLERSTATE;;False;1;SAMPLERSTATE;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;555;384,-1904;Inherit;False;554;BaseColor;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;638;384,-1824;Inherit;False;635;Alpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;557;384,-1744;Inherit;False;556;Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;639;352,-1664;Inherit;False;636;Alpha Normal;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;627;384,-1584;Inherit;False;624;Metallic;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;628;384,-1504;Inherit;False;626;Occlusion;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;640;384,-1344;Inherit;False;637;Alpha MSO;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;629;384,-1424;Inherit;False;625;Smoothness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;440;-1168,-1200;Inherit;True;Property;_TextureSample10;Texture Sample 1;21;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Derivative;Texture2D;False;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;441;-656,-1104;Float;False;Property;_NormalScale;Normal Strength;13;0;Create;False;0;0;0;False;0;False;1;0.498;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1053;-1440,-1408;Inherit;False;1050;UV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;607;-1168,-752;Inherit;True;Property;_TextureSample6;Texture Sample 2;10;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Derivative;Texture2D;False;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;602;-816,-384;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;894;-864,-384;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;893;-864,-624;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;593;-832,-192;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;895;-672,-192;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;623;-672,-608;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;620;-688,-640;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;604;-816,0;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;896;-880,0;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;855;-880,-544;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;597;-624,-192;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;598;-464,-192;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;594;-1168,-192;Half;False;Property;_MaskmapAO;Ambient Occlusion;16;0;Create;False;0;0;0;False;0;False;0;0.858;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;603;-1168,0;Half;False;Property;_MaskmapSmoothness;Smoothness;17;0;Create;False;0;0;0;False;0;False;0;0.246;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;599;-1168,-384;Half;False;Property;_MaskmapMetal;Metallic;15;0;Create;False;0;0;0;False;0;False;0;0.924;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;624;-144,-384;Inherit;False;Metallic;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;626;-144,-192;Inherit;False;Occlusion;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;625;-144,0;Inherit;False;Smoothness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;668;-1248,-704;Inherit;False;1;0;SAMPLERSTATE;;False;1;SAMPLERSTATE;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1056;-1440,-960;Inherit;False;1050;UV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;612;-1488,-752;Inherit;True;Property;_MaskMap;Mask Map MAOS;14;1;[SingleLineTexture];Create;False;0;0;0;False;1;Space(10);False;None;860dd950cbaa4f16b9554bf71f25ae4f;False;white;Auto;Texture2D;False;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.StickyNoteNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1116;-2416,2672;Inherit;False;328.127;160.786;;;0,0,0,1;Amplitude controls the maximum height range of the effect. Values that are too high tend to pull the effect apart and break the illusion.  Values that are too low aren't visible, so finding the right balance is important.;0;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1055;-1440,-896;Inherit;False;1265;UV DDX;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1054;-1440,-832;Inherit;False;1266;UV DDY;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1052;-1440,-1344;Inherit;False;1265;UV DDX;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1051;-1440,-1280;Inherit;False;1266;UV DDY;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;439;-1488,-1200;Inherit;True;Property;_NormalMap;Normal Map;12;2;[Normal];[SingleLineTexture];Create;False;0;0;0;False;1;Space(15);False;None;f59394e2460c4b4e97cf6f678b4a6532;True;bump;Auto;Texture2D;False;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RelayNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;560;-1296,-2832;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;553;-1616,-2736;Half;False;Property;_DecalOpacity;Global Opacity;0;0;Create;False;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;552;-1312,-2736;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;634;-1584,-2832;Inherit;False;631;BaseColorMap Alpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;523;-1104,-2832;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;897;-1296,-2528;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;865;-1072,-2528;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1372;-368,-2368;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1371;-368,-2592;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1373;-368,-2768;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1381;-176,-2432;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1382;-176,-2656;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1383;-176,-2832;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;637;32,-2432;Inherit;False;Alpha MSO;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;636;32,-2656;Inherit;False;Alpha Normal;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;635;32,-2832;Inherit;False;Alpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1386;-544,-2832;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1384;-544,-2656;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1385;-544,-2432;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1370;-592,-2336;Inherit;False;746;Height;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1380;-400,-2256;Inherit;False;Property;_EnableHeight;Enable Height;19;1;[Toggle];Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;556;-96,-1200;Inherit;False;Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.UnpackScaleNormalNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;444;-352,-1200;Inherit;False;Tangent;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;631;-832,-1504;Inherit;False;BaseColorMap Alpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;632;-848,-736;Inherit;False;Opacity Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StickyNoteNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1389;-1456,-2352;Inherit;False;495.4366;162.8521;Mask Opacity Channel;;0,0,0,1; **Base Color Map Alpha**$Uses the alpha channel of the Base Map to control the opacity$$**Mask Map Blue Channel**$Uses the blue channel of the Mask Map to control opacity.$;0;0
Node;AmplifyShaderEditor.CustomExpressionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;857;-912,-2656;Inherit;False;if(m_switch ==0)$	return m_BaseColorMapAlpha@$else if(m_switch ==1)$	return m_MaskMapBlue@$else$return float(0)@;1;Create;3;True;m_switch;FLOAT;0;In;;Inherit;False;True;m_BaseColorMapAlpha;FLOAT;0;In;;Inherit;False;True;m_MaskMapBlue;FLOAT;0;In;;Inherit;False;_SwitchNormalOpacity;False;False;0;;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;858;-912,-2432;Inherit;False;if(m_switch ==0)$	return m_BaseColorMapAlpha@$else if(m_switch ==1)$	return m_MaskMapBlue@$else$return float(0)@;1;Create;3;True;m_switch;FLOAT;0;In;;Inherit;False;True;m_BaseColorMapAlpha;FLOAT;0;In;;Inherit;False;True;m_MaskMapBlue;FLOAT;0;In;;Inherit;False;_SwitchMaskOpacity;False;False;0;;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;566;-1200,-2432;Inherit;False;Property;_MaskOpacityChannel;Mask Opacity Channel;2;1;[Enum];Create;True;0;2;Base Color Map Alpha;0;Mask Map Blue Channel;1;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;565;-1200,-2656;Inherit;False;Property;_NormalOpacityChannel;Normal Opacity Channel;1;1;[Enum];Create;True;0;2;Base Color Map Alpha;0;Mask Map Blue Channel;1;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;863;-1616,-2528;Inherit;False;Property;_DecalMaskMapBlueScale1;Scale Mask Map Blue Channel;3;0;Create;False;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;866;-1552,-2448;Inherit;False;632;Opacity Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;656;-112,416;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;654;-48,288;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;657;-112,608;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;648;-656,432;Half;False;Property;_EmissiveIntensity;Emissive Intensity;28;0;Create;False;1;;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;650;-464,640;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;653;-304,640;Inherit;False;Lerp White To;-1;;61768;047d7c189c36a62438973bad9d37b1c2;0;2;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;652;-560,736;Float;False;Property;_AlbedoAffectEmissive;Albedo Affect Emissive;27;1;[Toggle];Create;False;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;646;-656,288;Float;False;Property;_EmissiveColor;Emissive Color;26;1;[HDR];Create;False;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;False;0;6;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;658;-672,640;Inherit;False;554;BaseColor;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;512;-1152,176;Inherit;True;Property;_TextureSample15;Texture Sample 5;24;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Derivative;Texture2D;False;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;655;128,176;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwizzleNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;514;-768,176;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1454;-1408,448;Inherit;False;1265;UV DDX;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1453;-1408,528;Inherit;False;1266;UV DDY;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1457;-1440,368;Inherit;False;1456;UV Parallax Off;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1456;-2720,2672;Inherit;False;UV Parallax Off;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;702;-880,1328;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0.5,0.5,0.5;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RelayNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;712;-432,1216;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;704;-576,1328;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;703;-736,1392;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;730;32,1072;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;986;-112,1072;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;698;32,1200;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;705;368,1072;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;990;208,1168;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;699;-96,1200;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;700;-272,1200;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;701;-416,1328;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;992;-128,1296;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;708;-256,1520;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;991;-128,1504;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;736;-1152,1024;Inherit;True;Property;_TextureSample0;Texture Sample 0;23;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Derivative;Texture2D;False;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1090;-1264,1088;Inherit;False;1;0;SAMPLERSTATE;;False;1;SAMPLERSTATE;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;706;240,1200;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;738;-480,1520;Inherit;False;Property;_HeightOffset;Height Offset;21;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;737;-640,1216;Inherit;False;Property;_HeightScale;Height Scale;20;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1375;32,1280;Inherit;False;Constant;_Float0;Float 0;21;0;Create;True;0;0;0;False;0;False;0.001;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;746;560,1072;Inherit;False;Height;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1061;-1440,976;Inherit;False;1266;UV DDY;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1062;-1440,896;Inherit;False;1265;UV DDX;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PositionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;809;-1120,1328;Inherit;False;0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1063;-1440,816;Inherit;False;1050;UV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StickyNoteNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1653;-6736,2944;Inherit;False;270.593;130.6887;;;0,0,0,1;The top/bottom, left/right, and front/back coordinates are selected using face normals which are calculated using derivatives.;0;0
Node;AmplifyShaderEditor.StickyNoteNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1654;-7264,2656;Inherit;False;366.5662;140.728; Normal Face WS;;0,0,0,1;For regular meshes, we would use a Vertex Normal node here, but decals don't have a Vertex Normal, so we use the Normal Face node to derive the approximate world space normal of the surfaces that the decal intersects.;0;0
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1628;-7248,2864;Inherit;False;Normal Face;-1;;61769;f4725843c667a994e8a7e4987db394b2;2,88,0,86,1;0;1;FLOAT3;30
Node;AmplifyShaderEditor.AbsOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1629;-7040,2864;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PositionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1631;-7248,1872;Inherit;True;1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RoundOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1632;-6912,2864;Inherit;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RelayNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1634;-6960,1872;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1635;-6832,1952;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwizzleNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1636;-6688,2752;Inherit;False;FLOAT;1;1;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1637;-6752,1872;Inherit;True;FLOAT2;1;2;0;3;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1639;-6832,2160;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1640;-6528,2752;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1641;-6528,1936;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SwizzleNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1642;-6752,2160;Inherit;True;FLOAT2;0;2;0;3;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1643;-6528,2256;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1644;-6528,2128;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1645;-6832,1952;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwizzleNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1646;-6688,2832;Inherit;False;FLOAT;2;1;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1647;-6448,2144;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1649;-6832,2464;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1650;-6496,2832;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1657;-6288,2208;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SwizzleNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1651;-6752,2496;Inherit;True;FLOAT2;0;1;0;3;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1652;-6480,2592;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1656;-6288,2448;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1655;-6208,2464;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;559;384,-1264;Inherit;False;558;Emissive;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1669;-384,288;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1670;144,320;Inherit;False;Property;_AffectEmission;Affect Emission;24;1;[Toggle];Create;True;0;0;0;False;1;Space(15);False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1671;368,160;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1672;128,0;Inherit;False;Constant;_Color0;Color 0;30;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;False;0;6;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;558;576,160;Inherit;False;Emissive;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TexturePropertyNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;513;-1440,176;Inherit;True;Property;_EmissiveColorMap;Emissive Color Map;25;1;[SingleLineTexture];Create;False;0;0;0;False;0;False;None;1566835bc2024388b365b715bfd7e1aa;False;white;Auto;Texture2D;False;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1660;672,-1904;Float;False;False;-1;3;UnityEditor.Rendering.Universal.DecalShaderGraphGUI;0;1;New Amplify Shader;c2a467ab6d5391a4ea692226d82ffefd;True;DBufferProjector;0;0;DBufferProjector;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;5;RenderPipeline=UniversalPipeline;PreviewType=Plane;DisableBatching=LODFading=DisableBatching;ShaderGraphShader=true;ShaderGraphTargetId=UniversalDecalSubTarget;True;3;True;14;all;0;False;True;2;5;False;;10;False;;1;0;False;;10;False;;False;False;True;2;5;False;;10;False;;1;0;False;;10;False;;False;False;True;2;5;False;;10;False;;1;0;False;;10;False;;False;False;False;False;False;False;True;1;False;;False;False;False;True;True;True;True;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;True;2;False;;True;2;False;;False;False;True;1;LightMode=DBufferProjector;False;True;9;d3d11;metal;vulkan;xboxone;xboxseries;playstation;ps4;ps5;switch;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1661;672,-1904;Float;False;False;-1;3;UnityEditor.Rendering.Universal.DecalShaderGraphGUI;0;1;New Amplify Shader;c2a467ab6d5391a4ea692226d82ffefd;True;DecalProjectorForwardEmissive;0;1;DecalProjectorForwardEmissive;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;5;RenderPipeline=UniversalPipeline;PreviewType=Plane;DisableBatching=LODFading=DisableBatching;ShaderGraphShader=true;ShaderGraphTargetId=UniversalDecalSubTarget;True;3;True;14;all;0;False;True;8;5;False;;1;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;True;1;False;;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;True;2;False;;False;False;True;1;LightMode=DecalProjectorForwardEmissive;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1663;672,-1904;Float;False;False;-1;3;UnityEditor.Rendering.Universal.DecalShaderGraphGUI;0;1;New Amplify Shader;c2a467ab6d5391a4ea692226d82ffefd;True;DecalGBufferProjector;0;3;DecalGBufferProjector;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;5;RenderPipeline=UniversalPipeline;PreviewType=Plane;DisableBatching=LODFading=DisableBatching;ShaderGraphShader=true;ShaderGraphTargetId=UniversalDecalSubTarget;True;3;True;14;all;0;False;True;2;5;False;;10;False;;0;1;False;;0;False;;False;False;True;2;5;False;;10;False;;0;1;False;;0;False;;False;False;True;2;5;False;;10;False;;0;1;False;;0;False;;False;False;True;2;5;False;;10;False;;0;1;False;;0;False;;False;False;False;True;1;False;;False;False;False;True;False;False;False;False;0;False;;False;True;True;True;True;False;0;False;;False;True;True;True;True;False;0;False;;False;False;False;True;2;False;;True;2;False;;False;False;True;1;LightMode=DecalGBufferProjector;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1664;672,-1904;Float;False;False;-1;3;UnityEditor.Rendering.Universal.DecalShaderGraphGUI;0;1;New Amplify Shader;c2a467ab6d5391a4ea692226d82ffefd;True;DBufferMesh;0;4;DBufferMesh;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;5;RenderPipeline=UniversalPipeline;PreviewType=Plane;DisableBatching=LODFading=DisableBatching;ShaderGraphShader=true;ShaderGraphTargetId=UniversalDecalSubTarget;True;3;True;14;all;0;False;True;2;5;False;;10;False;;1;0;False;;10;False;;False;False;True;2;5;False;;10;False;;1;0;False;;10;False;;False;False;True;2;5;False;;10;False;;1;0;False;;10;False;;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;True;2;False;;True;3;False;;False;False;True;1;LightMode=DBufferMesh;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1665;672,-1904;Float;False;False;-1;3;UnityEditor.Rendering.Universal.DecalShaderGraphGUI;0;1;New Amplify Shader;c2a467ab6d5391a4ea692226d82ffefd;True;DecalMeshForwardEmissive;0;5;DecalMeshForwardEmissive;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;5;RenderPipeline=UniversalPipeline;PreviewType=Plane;DisableBatching=LODFading=DisableBatching;ShaderGraphShader=true;ShaderGraphTargetId=UniversalDecalSubTarget;True;3;True;14;all;0;False;True;8;5;False;;1;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;True;3;False;;False;False;True;1;LightMode=DecalMeshForwardEmissive;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1666;672,-1904;Float;False;False;-1;3;UnityEditor.Rendering.Universal.DecalShaderGraphGUI;0;1;New Amplify Shader;c2a467ab6d5391a4ea692226d82ffefd;True;DecalScreenSpaceMesh;0;6;DecalScreenSpaceMesh;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;5;RenderPipeline=UniversalPipeline;PreviewType=Plane;DisableBatching=LODFading=DisableBatching;ShaderGraphShader=true;ShaderGraphTargetId=UniversalDecalSubTarget;True;3;True;14;all;0;False;True;2;5;False;;10;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;True;3;False;;False;False;True;1;LightMode=DecalScreenSpaceMesh;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1667;672,-1904;Float;False;False;-1;3;UnityEditor.Rendering.Universal.DecalShaderGraphGUI;0;1;New Amplify Shader;c2a467ab6d5391a4ea692226d82ffefd;True;DecalGBufferMesh;0;7;DecalGBufferMesh;1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;5;RenderPipeline=UniversalPipeline;PreviewType=Plane;DisableBatching=LODFading=DisableBatching;ShaderGraphShader=true;ShaderGraphTargetId=UniversalDecalSubTarget;True;3;True;14;all;0;False;True;2;5;False;;10;False;;0;1;False;;0;False;;False;False;True;2;5;False;;10;False;;0;1;False;;0;False;;False;False;True;2;5;False;;10;False;;0;1;False;;0;False;;False;False;True;2;5;False;;10;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;True;False;False;False;False;0;False;;False;True;True;True;True;False;0;False;;False;True;True;True;True;False;0;False;;False;False;False;True;2;False;;False;False;False;True;1;LightMode=DecalGBufferMesh;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1668;672,-1904;Float;False;False;-1;3;UnityEditor.Rendering.Universal.DecalShaderGraphGUI;0;1;New Amplify Shader;c2a467ab6d5391a4ea692226d82ffefd;True;ScenePickingPass;0;8;ScenePickingPass;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;5;RenderPipeline=UniversalPipeline;PreviewType=Plane;DisableBatching=LODFading=DisableBatching;ShaderGraphShader=true;ShaderGraphTargetId=UniversalDecalSubTarget;True;3;True;14;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Picking;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1662;640,-1904;Float;False;True;-1;3;UnityEditor.Rendering.Universal.DecalShaderGraphGUI;0;22;AmplifyShaderPack/Decal Parallax Mapping Normal;c2a467ab6d5391a4ea692226d82ffefd;True;DecalScreenSpaceProjector;0;2;DecalScreenSpaceProjector;9;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;5;RenderPipeline=UniversalPipeline;PreviewType=Plane;DisableBatching=LODFading=DisableBatching;ShaderGraphShader=true;ShaderGraphTargetId=UniversalDecalSubTarget;True;3;True;14;all;0;False;True;2;5;False;;10;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;True;1;False;;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;True;2;False;;False;False;True;1;LightMode=DecalScreenSpaceProjector;False;False;0;;0;0;Standard;7;Affect BaseColor;1;0;Affect Normal;1;0;  Blend;1;0;Affect MAOS;1;638984222970001186;Affect Emission;1;638984222975961513;Support LOD CrossFade;1;638984222980558257;Angle Fade;1;0;0;9;True;True;True;True;True;True;True;True;True;False;;True;0
WireConnection;1329;0;1323;0
WireConnection;1325;0;1327;0
WireConnection;1331;0;1324;0
WireConnection;1307;0;1329;0
WireConnection;1304;0;1325;0
WireConnection;1304;1;1331;0
WireConnection;1610;0;1358;0
WireConnection;1301;0;1307;0
WireConnection;1300;0;1307;0
WireConnection;1305;0;1304;0
WireConnection;1368;0;436;0
WireConnection;1611;0;1610;0
WireConnection;1296;0;1301;0
WireConnection;1296;1;1305;0
WireConnection;1297;0;1300;0
WireConnection;1297;1;1305;1
WireConnection;1298;0;1301;0
WireConnection;1298;1;1305;1
WireConnection;1299;0;1300;0
WireConnection;1299;1;1305;0
WireConnection;1353;0;1368;0
WireConnection;1492;0;1611;0
WireConnection;1302;0;1296;0
WireConnection;1302;1;1297;0
WireConnection;1303;0;1298;0
WireConnection;1303;1;1299;0
WireConnection;1357;0;1353;0
WireConnection;1608;0;1492;0
WireConnection;1295;0;1302;0
WireConnection;1295;1;1303;0
WireConnection;1356;0;1357;0
WireConnection;1609;0;1608;0
WireConnection;1486;0;1625;0
WireConnection;1291;0;1295;0
WireConnection;1291;1;1356;0
WireConnection;1349;0;1353;0
WireConnection;1349;1;1350;0
WireConnection;1566;0;1486;0
WireConnection;1490;0;1492;0
WireConnection;1491;0;1492;0
WireConnection;993;0;411;0
WireConnection;1621;0;1609;0
WireConnection;1340;0;1349;0
WireConnection;1340;1;1338;0
WireConnection;1435;0;1291;0
WireConnection;1567;0;1486;0
WireConnection;1480;0;481;0
WireConnection;1480;1;1608;0
WireConnection;1480;3;1490;0
WireConnection;1480;4;1491;0
WireConnection;1480;7;481;1
WireConnection;1561;0;1566;0
WireConnection;1622;0;1621;0
WireConnection;410;0;993;0
WireConnection;1345;0;1340;0
WireConnection;1345;1;1338;0
WireConnection;1436;0;1435;0
WireConnection;1564;0;1486;0
WireConnection;1559;0;1567;0
WireConnection;1505;0;481;0
WireConnection;1505;1;1608;0
WireConnection;1505;3;1490;0
WireConnection;1505;4;1491;0
WireConnection;1505;7;481;1
WireConnection;1512;0;1622;0
WireConnection;1512;1;1480;1
WireConnection;1512;2;410;0
WireConnection;1512;3;1561;0
WireConnection;1351;0;1345;0
WireConnection;1342;0;1368;0
WireConnection;1292;0;1436;0
WireConnection;1292;1;1331;0
WireConnection;1565;0;1486;0
WireConnection;1557;0;1564;0
WireConnection;1537;0;481;0
WireConnection;1537;1;1608;0
WireConnection;1537;3;1490;0
WireConnection;1537;4;1491;0
WireConnection;1537;7;481;1
WireConnection;1554;0;1512;0
WireConnection;1554;1;1505;1
WireConnection;1554;2;410;0
WireConnection;1554;3;1559;0
WireConnection;1352;0;1351;0
WireConnection;1313;0;1292;0
WireConnection;1313;1;1342;0
WireConnection;1550;0;1565;0
WireConnection;1546;0;481;0
WireConnection;1546;1;1608;0
WireConnection;1546;3;1490;0
WireConnection;1546;4;1491;0
WireConnection;1546;7;481;1
WireConnection;1605;0;1554;0
WireConnection;1605;1;1537;1
WireConnection;1605;2;410;0
WireConnection;1605;3;1557;0
WireConnection;1334;0;1313;0
WireConnection;1334;1;1352;0
WireConnection;1606;0;1605;0
WireConnection;1606;1;1546;1
WireConnection;1606;2;410;0
WireConnection;1606;3;1550;0
WireConnection;1042;0;1334;0
WireConnection;1623;0;1606;0
WireConnection;1358;0;1042;0
WireConnection;1358;1;1362;0
WireConnection;1358;2;1363;0
WireConnection;1358;3;1364;0
WireConnection;1358;4;1361;0
WireConnection;1624;0;1623;0
WireConnection;1376;0;1358;0
WireConnection;1376;1;1624;0
WireConnection;1376;2;1377;0
WireConnection;1265;0;1490;0
WireConnection;1266;0;1491;0
WireConnection;1050;0;1376;0
WireConnection;886;0;878;0
WireConnection;445;0;438;0
WireConnection;445;1;1049;0
WireConnection;445;3;1048;0
WireConnection;445;4;1047;0
WireConnection;445;7;438;1
WireConnection;887;0;886;0
WireConnection;446;0;445;0
WireConnection;888;0;887;0
WireConnection;885;0;446;0
WireConnection;885;1;888;0
WireConnection;554;0;885;0
WireConnection;968;0;972;30
WireConnection;970;0;968;0
WireConnection;1355;0;1042;0
WireConnection;1108;0;970;0
WireConnection;1354;0;1355;0
WireConnection;1109;0;1108;0
WireConnection;1282;0;1078;0
WireConnection;930;0;932;0
WireConnection;930;1;1354;0
WireConnection;1080;0;1077;0
WireConnection;1080;1;1282;0
WireConnection;1080;2;1109;0
WireConnection;1081;0;930;0
WireConnection;1081;1;1080;0
WireConnection;667;0;438;1
WireConnection;440;0;439;0
WireConnection;440;1;1053;0
WireConnection;440;3;1052;0
WireConnection;440;4;1051;0
WireConnection;440;7;439;1
WireConnection;607;0;612;0
WireConnection;607;1;1056;0
WireConnection;607;3;1055;0
WireConnection;607;4;1054;0
WireConnection;607;7;668;0
WireConnection;602;0;599;0
WireConnection;602;1;894;0
WireConnection;894;0;893;0
WireConnection;893;0;607;1
WireConnection;593;0;594;0
WireConnection;895;0;623;0
WireConnection;623;0;620;0
WireConnection;620;0;607;2
WireConnection;604;0;603;0
WireConnection;604;1;896;0
WireConnection;896;0;855;0
WireConnection;855;0;607;4
WireConnection;597;0;593;0
WireConnection;597;1;895;0
WireConnection;598;0;597;0
WireConnection;624;0;602;0
WireConnection;626;0;598;0
WireConnection;625;0;604;0
WireConnection;668;0;667;0
WireConnection;560;0;634;0
WireConnection;552;0;553;0
WireConnection;523;0;560;0
WireConnection;523;1;552;0
WireConnection;897;0;863;0
WireConnection;897;1;866;0
WireConnection;865;0;897;0
WireConnection;1372;0;1385;0
WireConnection;1372;1;1370;0
WireConnection;1371;0;1384;0
WireConnection;1371;1;1370;0
WireConnection;1373;0;1386;0
WireConnection;1373;1;1370;0
WireConnection;1381;0;1385;0
WireConnection;1381;1;1372;0
WireConnection;1381;2;1380;0
WireConnection;1382;0;1384;0
WireConnection;1382;1;1371;0
WireConnection;1382;2;1380;0
WireConnection;1383;0;1386;0
WireConnection;1383;1;1373;0
WireConnection;1383;2;1380;0
WireConnection;637;0;1381;0
WireConnection;636;0;1382;0
WireConnection;635;0;1383;0
WireConnection;1386;0;523;0
WireConnection;1384;0;857;0
WireConnection;1385;0;858;0
WireConnection;556;0;444;0
WireConnection;444;0;440;0
WireConnection;444;1;441;0
WireConnection;631;0;445;4
WireConnection;632;0;607;3
WireConnection;857;0;565;0
WireConnection;857;1;523;0
WireConnection;857;2;865;0
WireConnection;858;0;566;0
WireConnection;858;1;523;0
WireConnection;858;2;865;0
WireConnection;656;0;657;0
WireConnection;654;0;1669;0
WireConnection;654;1;656;0
WireConnection;657;0;653;0
WireConnection;650;0;658;0
WireConnection;653;1;650;0
WireConnection;653;2;652;0
WireConnection;512;0;513;0
WireConnection;512;1;1457;0
WireConnection;512;3;1454;0
WireConnection;512;4;1453;0
WireConnection;512;7;513;1
WireConnection;655;0;514;0
WireConnection;655;1;654;0
WireConnection;514;0;512;0
WireConnection;1456;0;1358;0
WireConnection;702;0;809;0
WireConnection;712;0;737;0
WireConnection;704;0;702;0
WireConnection;704;1;703;0
WireConnection;703;0;702;0
WireConnection;730;0;986;0
WireConnection;730;1;986;0
WireConnection;986;0;736;1
WireConnection;698;0;699;0
WireConnection;705;0;730;0
WireConnection;705;1;990;0
WireConnection;705;2;706;0
WireConnection;990;0;698;0
WireConnection;699;0;700;0
WireConnection;699;1;992;0
WireConnection;700;0;712;0
WireConnection;700;1;701;1
WireConnection;701;0;704;0
WireConnection;992;0;991;0
WireConnection;708;0;738;0
WireConnection;991;0;708;0
WireConnection;736;0;481;0
WireConnection;736;1;1063;0
WireConnection;736;3;1062;0
WireConnection;736;4;1061;0
WireConnection;736;7;1090;0
WireConnection;1090;0;481;1
WireConnection;706;0;698;0
WireConnection;706;1;1375;0
WireConnection;746;0;705;0
WireConnection;1629;0;1628;30
WireConnection;1632;0;1629;0
WireConnection;1634;0;1631;0
WireConnection;1635;0;1634;0
WireConnection;1636;0;1632;0
WireConnection;1637;0;1634;0
WireConnection;1639;0;1635;0
WireConnection;1640;0;1636;0
WireConnection;1641;0;1637;0
WireConnection;1642;0;1639;0
WireConnection;1643;0;1640;0
WireConnection;1644;0;1641;0
WireConnection;1645;0;1634;0
WireConnection;1646;0;1632;0
WireConnection;1647;0;1644;0
WireConnection;1647;1;1642;0
WireConnection;1647;2;1643;0
WireConnection;1649;0;1645;0
WireConnection;1650;0;1646;0
WireConnection;1657;0;1647;0
WireConnection;1651;0;1649;0
WireConnection;1652;0;1650;0
WireConnection;1656;0;1657;0
WireConnection;1655;0;1656;0
WireConnection;1655;1;1651;0
WireConnection;1655;2;1652;0
WireConnection;1669;0;646;0
WireConnection;1669;1;648;0
WireConnection;1671;0;1672;0
WireConnection;1671;1;655;0
WireConnection;1671;2;1670;0
WireConnection;558;0;1671;0
WireConnection;1662;0;555;0
WireConnection;1662;1;638;0
WireConnection;1662;2;557;0
WireConnection;1662;3;639;0
WireConnection;1662;4;627;0
WireConnection;1662;5;628;0
WireConnection;1662;6;629;0
WireConnection;1662;7;640;0
WireConnection;1662;8;559;0
ASEEND*/
//CHKSM=D15192ABD4ABD01F5E4C3B95ECEFA4C30EFE8B5A