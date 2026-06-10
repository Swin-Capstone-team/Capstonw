// Made with Amplify Shader Editor v1.9.9.7
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AmplifyShaderPack/Terrain/SinglePass Snow"
{
	Properties
	{
		[HideInInspector] _EmissionColor("Emission Color", Color) = (1,1,1,1)
		[HideInInspector] _Control( "Control", 2D ) = "red" {}
		[HideInInspector] _Control1( "Control1", 2D ) = "black" {}
		[HideInInspector][NoScaleOffset] _TerrainHolesTexture( "_TerrainHolesTexture", 2D ) = "white" {}
		[HideInInspector] _Splat0( "Splat0", 2D ) = "gray" {}
		[HideInInspector] _DiffuseRemapScale0( "_DiffuseRemapScale0", Vector ) = ( 1, 1, 1, 1 )
		_Splat0Brightness( "Brightness0", Range( 0, 2 ) ) = 1
		[HideInInspector] _Normal0( "Normal0", 2D ) = "bump" {}
		[HideInInspector] _NormalScale0( "NormalScale0", Float ) = 1
		[HideInInspector] _Mask0( "Mask0", 2D ) = "gray" {}
		[HideInInspector][Gamma] _Metallic0( "Metallic0", Range( 0, 1 ) ) = 0
		[HideInInspector] _Specular0( "_Specular0", Vector ) = ( 0, 0, 0, 0 )
		[HideInInspector][Toggle] _OpacityAsDensity0( "_OpacityAsDensity0", Float ) = 0
		[HideInInspector] _Smoothness0( "Smoothness0", Range( 0, 1 ) ) = 0
		[HideInInspector] _LayerHasMask0( "_LayerHasMask0", Float ) = 0
		[HideInInspector] _MaskMapRemapScale0( "_MaskMapRemapScale0", Vector ) = ( 0, 0, 0, 0 )
		[HideInInspector] _MaskMapRemapOffset0( "_MaskMapRemapOffset0", Vector ) = ( 0, 0, 0, 0 )
		[HideInInspector] _Splat1( "Splat1", 2D ) = "gray" {}
		[HideInInspector] _DiffuseRemapScale1( "_DiffuseRemapScale1", Vector ) = ( 1, 1, 1, 1 )
		_Splat1Brightness( "Brightness1", Range( 0, 2 ) ) = 1
		[HideInInspector] _Normal1( "Normal1", 2D ) = "bump" {}
		[HideInInspector] _NormalScale1( "NormalScale1", Float ) = 1
		[HideInInspector] _Mask1( "Mask1", 2D ) = "gray" {}
		[HideInInspector][Gamma] _Metallic1( "Metallic1", Range( 0, 1 ) ) = 0
		[HideInInspector] _Specular1( "_Specular1", Vector ) = ( 0, 0, 0, 0 )
		[HideInInspector][Toggle] _OpacityAsDensity1( "_OpacityAsDensity1", Float ) = 0
		[HideInInspector] _Smoothness1( "Smoothness1", Range( 0, 1 ) ) = 0
		[HideInInspector] _LayerHasMask1( "_LayerHasMask1", Float ) = 0
		[HideInInspector] _MaskMapRemapScale1( "_MaskMapRemapScale1", Vector ) = ( 0, 0, 0, 0 )
		[HideInInspector] _MaskMapRemapOffset1( "_MaskMapRemapOffset1", Vector ) = ( 0, 0, 0, 0 )
		[HideInInspector] _Splat2( "Splat2", 2D ) = "gray" {}
		[HideInInspector] _DiffuseRemapScale2( "_DiffuseRemapScale2", Vector ) = ( 1, 1, 1, 1 )
		_Splat2Brightness( "Brightness2", Range( 0, 2 ) ) = 1
		[HideInInspector] _Normal2( "Normal2", 2D ) = "bump" {}
		[HideInInspector] _NormalScale2( "NormalScale2", Float ) = 1
		[HideInInspector] _Mask2( "Mask2", 2D ) = "gray" {}
		[HideInInspector][Gamma] _Metallic2( "Metallic2", Range( 0, 1 ) ) = 0.5363968
		[HideInInspector] _Specular2( "_Specular2", Vector ) = ( 0, 0, 0, 0 )
		[HideInInspector][Toggle] _OpacityAsDensity2( "_OpacityAsDensity2", Float ) = 0
		[HideInInspector] _Smoothness2( "Smoothness2", Range( 0, 1 ) ) = 0
		[HideInInspector] _LayerHasMask2( "_LayerHasMask2", Float ) = 0
		[HideInInspector] _MaskMapRemapScale2( "_MaskMapRemapScale2", Vector ) = ( 0, 0, 0, 0 )
		[HideInInspector] _MaskMapRemapOffset2( "_MaskMapRemapOffset2", Vector ) = ( 0, 0, 0, 0 )
		[HideInInspector] _Splat3( "Splat3", 2D ) = "gray" {}
		[HideInInspector] _DiffuseRemapScale3( "_DiffuseRemapScale3", Vector ) = ( 1, 1, 1, 1 )
		_Splat3Brightness( "Brightness3", Range( 0, 2 ) ) = 1
		[HideInInspector] _Normal3( "Normal3", 2D ) = "bump" {}
		[HideInInspector] _NormalScale3( "_NormalScale3", Float ) = 1
		[HideInInspector] _Mask3( "Mask3", 2D ) = "gray" {}
		[HideInInspector][Gamma] _Metallic3( "Metallic3", Range( 0, 1 ) ) = 1
		[HideInInspector] _Specular3( "_Specular3", Vector ) = ( 0, 0, 0, 0 )
		[HideInInspector][Toggle] _OpacityAsDensity3( "_OpacityAsDensity3", Float ) = 0
		[HideInInspector] _Smoothness3( "Smoothness3", Range( 0, 1 ) ) = 0
		[HideInInspector] _LayerHasMask3( "_LayerHasMask3", Float ) = 0
		[HideInInspector] _MaskMapRemapScale3( "_MaskMapRemapScale3", Vector ) = ( 0, 0, 0, 0 )
		[HideInInspector] _MaskMapRemapOffset3( "_MaskMapRemapOffset3", Vector ) = ( 0, 0, 0, 0 )
		[HideInInspector] _Splat4( "Splat4", 2D ) = "gray" {}
		[HideInInspector] _DiffuseRemapScale4( "_DiffuseRemapScale4", Vector ) = ( 1, 1, 1, 1 )
		_Splat4Brightness( "Brightness4", Range( 0, 2 ) ) = 1
		[HideInInspector] _Normal4( "Normal4", 2D ) = "bump" {}
		[HideInInspector] _NormalScale4( "NormalScale4", Float ) = 1
		[HideInInspector] _Mask4( "Mask4", 2D ) = "gray" {}
		[HideInInspector][Gamma] _Metallic4( "Metallic4", Range( 0, 1 ) ) = 0
		[HideInInspector] _Specular4( "_Specular4", Vector ) = ( 0, 0, 0, 0 )
		[HideInInspector][Toggle] _OpacityAsDensity4( "_OpacityAsDensity4", Float ) = 0
		[HideInInspector] _Smoothness4( "Smoothness4", Range( 0, 1 ) ) = 0
		[HideInInspector] _LayerHasMask4( "_LayerHasMask4", Float ) = 0
		[HideInInspector] _MaskMapRemapScale4( "_MaskMapRemapScale4", Vector ) = ( 0, 0, 0, 0 )
		[HideInInspector] _MaskMapRemapOffset4( "_MaskMapRemapOffset4", Vector ) = ( 0, 0, 0, 0 )
		[HideInInspector] _Splat5( "Splat5", 2D ) = "gray" {}
		[HideInInspector] _DiffuseRemapScale5( "_DiffuseRemapScale5", Vector ) = ( 1, 1, 1, 1 )
		_Splat5Brightness( "Brightness5", Range( 0, 2 ) ) = 1
		[HideInInspector] _Normal5( "Normal5", 2D ) = "bump" {}
		[HideInInspector] _NormalScale5( "NormalScale5", Float ) = 1
		[HideInInspector] _Mask5( "Mask5", 2D ) = "gray" {}
		[HideInInspector][Gamma] _Metallic5( "Metallic5", Range( 0, 1 ) ) = 1
		[HideInInspector] _Specular5( "_Specular5", Vector ) = ( 0, 0, 0, 0 )
		[HideInInspector][Toggle] _OpacityAsDensity5( "_OpacityAsDensity5", Float ) = 0
		[HideInInspector] _Smoothness5( "Smoothness5", Range( 0, 1 ) ) = 0
		[HideInInspector] _LayerHasMask5( "_LayerHasMask5", Float ) = 0
		[HideInInspector] _MaskMapRemapScale5( "_MaskMapRemapScale5", Vector ) = ( 0, 0, 0, 0 )
		[HideInInspector] _MaskMapRemapOffset5( "_MaskMapRemapOffset5", Vector ) = ( 0, 0, 0, 0 )
		[HideInInspector] _Splat6( "Splat6", 2D ) = "gray" {}
		[HideInInspector] _DiffuseRemapScale6( "_DiffuseRemapScale6", Vector ) = ( 1, 1, 1, 1 )
		_Splat6Brightness( "Brightness6", Range( 0, 2 ) ) = 1
		[HideInInspector] _Normal6( "Normal6", 2D ) = "bump" {}
		[HideInInspector] _NormalScale6( "NormalScale6", Float ) = 1
		[HideInInspector] _Mask6( "Mask6", 2D ) = "gray" {}
		[HideInInspector][Gamma] _Metallic6( "Metallic6", Range( 0, 1 ) ) = 0
		[HideInInspector] _Specular6( "_Specular6", Vector ) = ( 0, 0, 0, 0 )
		[HideInInspector][Toggle] _OpacityAsDensity6( "_OpacityAsDensity6", Float ) = 0
		[HideInInspector] _Smoothness6( "Smoothness6", Range( 0, 1 ) ) = 0
		[HideInInspector] _LayerHasMask6( "_LayerHasMask6", Float ) = 0
		[HideInInspector] _MaskMapRemapScale6( "_MaskMapRemapScale6", Vector ) = ( 0, 0, 0, 0 )
		[HideInInspector] _MaskMapRemapOffset6( "_MaskMapRemapOffset6", Vector ) = ( 0, 0, 0, 0 )
		[HideInInspector] _Splat7( "Splat7", 2D ) = "gray" {}
		[HideInInspector] _DiffuseRemapScale7( "_DiffuseRemapScale7", Vector ) = ( 1, 1, 1, 1 )
		_Splat7Brightness( "Brightness7", Range( 0, 2 ) ) = 1
		[HideInInspector] _Normal7( "Normal7", 2D ) = "bump" {}
		[HideInInspector] _NormalScale7( "_NormalScale7", Float ) = 1
		[HideInInspector] _Mask7( "Mask7", 2D ) = "gray" {}
		[HideInInspector][Gamma] _Metallic7( "Metallic7", Range( 0, 1 ) ) = 0
		[HideInInspector] _Specular7( "_Specular7", Vector ) = ( 0, 0, 0, 0 )
		[HideInInspector][Toggle] _OpacityAsDensity7( "_OpacityAsDensity7", Float ) = 0
		[HideInInspector] _Smoothness7( "Smoothness7", Range( 0, 1 ) ) = 0
		[HideInInspector] _LayerHasMask7( "_LayerHasMask7", Float ) = 0
		[HideInInspector] _MaskMapRemapScale7( "_MaskMapRemapScale7", Vector ) = ( 0, 0, 0, 0 )
		[HideInInspector] _MaskMapRemapOffset7( "_MaskMapRemapOffset7", Vector ) = ( 0, 0, 0, 0 )
		[Header(SNOW)][ToggleUI] _SnowEnable( "ENABLE", Float ) = 0
		_SnowColor( "Tint", Color ) = ( 1, 1, 1, 0 )
		_SnowBrightness( "Brightness", Range( 0, 1 ) ) = 1
		[Space(5)] _SnowSaturation( "Saturation", Range( 0, 1 ) ) = 0
		[SingleLineTexture] _SnowMapBaseColor( "BaseColor", 2D ) = "white" {}
		_SnowMainUVs( "Main UVs", Vector ) = ( 0.002, 0.002, 0, 0 )
		[SingleLineTexture] _SnowMapSplat( "Splat Mask", 2D ) = "white" {}
		[Normal][SingleLineTexture] _SnowMapNormal( "Normal Map", 2D ) = "bump" {}
		_SnowNormalStrength( "Normal Strength", Float ) = 2
		[ToggleUI][Space(10)] _SnowSplatREnable( "ENABLE CHANNEL RED", Float ) = 0
		_SnowSplatRSplatBias( "Splat Bias", Float ) = 1
		_SnowSplatRMin( "Min", Float ) = -0.5
		_SnowSplatRMax( "Max", Float ) = 1
		_SnowSplatRBlendStrength( "Blend Strength", Range( 0, 5 ) ) = 0
		_SnowSplatRBlendFalloff( "Blend Falloff", Range( 0, 10 ) ) = 0
		_SnowSplatRBlendFactor( "Blend Factor", Range( 0, 10 ) ) = 0
		[ToggleUI][Space(10)] _SnowSplatGEnable( "ENABLE CHANNEL GREEN", Float ) = 0
		_SnowSplatGSplatBias( "Splat Bias", Float ) = 1
		_SnowSplatGMin( "Min", Float ) = -0.5
		_SnowSplatGMax( "Max", Float ) = 1
		_SnowSplatGBlendStrength( "Blend Strength", Range( 0, 5 ) ) = 3.370154
		_SnowSplatGBlendFalloff( "Blend Falloff", Range( 0, 10 ) ) = 0
		_SnowSplatGBlendFactor( "Blend Factor", Range( 0, 10 ) ) = 0
		[ToggleUI][Space(10)] _SnowSplatBEnable( "ENABLE CHANNEL BLUE", Float ) = 0
		_SnowSplatBSplatBias( "Splat Bias", Float ) = 1
		_SnowSplatBMin( "Min", Float ) = -0.5
		_SnowSplatBMax( "Max", Float ) = 1
		_SnowSplatBBlendStrength( "Blend Strength", Range( 0, 5 ) ) = 0
		_SnowSplatBBlendFalloff( "Blend Falloff", Range( 0, 10 ) ) = 0
		_SnowSplatBBlendFactor( "Blend Factor", Range( 0, 10 ) ) = 0
		[ToggleUI][Space(10)] _SnowSplatAEnable( "ENABLE CHANNEL ALPHA", Float ) = 0
		_SnowSplatASplatBias( "Splat Bias", Float ) = 1
		_SnowSplatAMin( "Min", Float ) = -0.5
		_SnowSplatAMax( "Max", Float ) = 1
		_SnowSplatABlendStrength( "Blend Strength", Range( 0, 5 ) ) = 0
		_SnowSplatABlendFalloff( "Blend Falloff", Range( 0, 10 ) ) = 0
		_SnowSplatABlendFactor( "Blend Factor", Range( 0, 10 ) ) = 0
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

		[KeywordEnum(Vertex, Pixel)] _InstancedTerrainNormals("Instanced Terrain Normals", Float) = 1.0

		[ToggleOff(_SPECULARHIGHLIGHTS_OFF)] _SpecularHighlights("Specular Highlights", Float) = 1.0
		[ToggleOff] _EnvironmentReflections("Environment Reflections", Float) = 1.0
		[HideInInspector][ToggleUI] _ReceiveShadows("Receive Shadows", Float) = 1.0

		[HideInInspector] _QueueOffset("_QueueOffset", Float) = 0
        [HideInInspector] _QueueControl("_QueueControl", Float) = -1

        [HideInInspector][NoScaleOffset] unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset] unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset] unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}

		//[HideInInspector][ToggleUI] _AddPrecomputedVelocity("Add Precomputed Velocity", Float) = 1

		//[HideInInspector] _XRMotionVectorsPass("_XRMotionVectorsPass", Float) = 1

		[HideInInspector] _AlphaClip("__clip", Float) = 0.0
	}

	SubShader
	{
		LOD 0

		

		

		Tags { "RenderPipeline"="UniversalPipeline" "RenderType"="Opaque" "Queue"="Geometry-100" "UniversalMaterialType"="Lit" "DisableBatching"="False" "TerrainCompatible"="True" "IgnoreProjector"="True" "SplatCount"="8" "MaskMapR"="Metallic" "MaskMapG"="AO" "MaskMapB"="Height" "MaskMapA"="Smoothness" "AlwaysRenderMotionVectors"="false" }

		Cull Back
		ZWrite On
		ZTest LEqual
		Offset 0 , 0
		AlphaToMask Off

		

		HLSLINCLUDE
		#pragma target 4.5
		#pragma prefer_hlslcc gles
		// ensure rendering platforms toggle list is visible

		#if ( SHADER_TARGET > 35 ) && defined( SHADER_API_GLES3 )
			#error For WebGL2/GLES3, please set your shader target to 3.5 via SubShader options. URP shaders in ASE use target 4.5 by default.
		#endif

		#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
		#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Filtering.hlsl"

		#ifndef ASE_TESS_FUNCS
		#define ASE_TESS_FUNCS
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
		#endif //ASE_TESS_FUNCS
		ENDHLSL

		
		Pass
		{
			
			Name "Forward"
			Tags { "LightMode"="UniversalForward" "TerrainCompatible"="True" "IgnoreProjector"="True" "SplatCount"="8" "MaskMapR"="Metallic" "MaskMapG"="AO" "MaskMapB"="Height" "MaskMapA"="Smoothness" "DisableBatching"="False" "AlwaysRenderMotionVectors"="false" }

			Blend One Zero, One Zero
			ZWrite On
			ZTest LEqual
			Offset 0 , 0
			ColorMask RGBA

			

			HLSLPROGRAM

			#define _ALPHATEST_ON
			#define _NORMAL_DROPOFF_TS 1
			#pragma shader_feature_local_fragment _RECEIVE_SHADOWS_OFF
			#pragma shader_feature_local_fragment _SPECULARHIGHLIGHTS_OFF
			#pragma shader_feature_local_fragment _ENVIRONMENTREFLECTIONS_OFF
			#pragma multi_compile_fragment _ _SCREEN_SPACE_OCCLUSION
			#define ASE_FOG 1
			#pragma multi_compile_fragment _ DEBUG_DISPLAY
			#define ASE_TERRAIN
			#pragma shader_feature _INSTANCEDTERRAINNORMALS_PIXEL
			#define _SPECULAR_SETUP 1
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#define _NORMALMAP 1
			#define ASE_VERSION 19907
			#define ASE_SRP_VERSION 170300
			#define ASE_USING_SAMPLING_MACROS 1


			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
			#pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
            #pragma multi_compile _ EVALUATE_SH_MIXED EVALUATE_SH_VERTEX
			#pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
			#pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
			#pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
			#pragma multi_compile_fragment _ _REFLECTION_PROBE_ATLAS
			#pragma multi_compile_fragment _ _SHADOWS_SOFT _SHADOWS_SOFT_LOW _SHADOWS_SOFT_MEDIUM _SHADOWS_SOFT_HIGH
			#pragma multi_compile_fragment _ _SCREEN_SPACE_IRRADIANCE
			#pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
			#pragma multi_compile _ _LIGHT_LAYERS
			#pragma multi_compile_fragment _ _LIGHT_COOKIES
			#pragma multi_compile _ _CLUSTER_LIGHT_LOOP

			#pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
			#pragma multi_compile _ SHADOWS_SHADOWMASK
			#pragma multi_compile _ DIRLIGHTMAP_COMBINED
			#pragma multi_compile _ LIGHTMAP_ON
			#pragma multi_compile_fragment _ LIGHTMAP_BICUBIC_SAMPLING
			#pragma multi_compile_fragment _ REFLECTION_PROBE_ROTATION
			#pragma multi_compile _ DYNAMICLIGHTMAP_ON
			#pragma multi_compile _ USE_LEGACY_LIGHTMAPS

			#pragma vertex vert
			#pragma fragment frag

			#if defined( _SPECULAR_SETUP ) && defined( ASE_LIGHTING_SIMPLE )
				#if defined( _SPECULARHIGHLIGHTS_OFF )
					#undef _SPECULAR_COLOR
				#else
					#define _SPECULAR_COLOR
				#endif
			#endif

			#define SHADERPASS SHADERPASS_FORWARD

			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Fog.hlsl"
			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ProbeVolumeVariants.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#if defined(LOD_FADE_CROSSFADE)
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
            #endif

			#if defined( UNITY_INSTANCING_ENABLED ) && defined( ASE_INSTANCED_TERRAIN ) && ( defined(_TERRAIN_INSTANCED_PERPIXEL_NORMAL) || defined(_INSTANCEDTERRAINNORMALS_PIXEL) )
				#define ENABLE_TERRAIN_PERPIXEL_NORMAL
			#endif

			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_TEXTURE_COORDINATES0
			#define ASE_NEEDS_VERT_TEXTURE_COORDINATES0
			#define ASE_NEEDS_FRAG_TEXTURE_COORDINATES0
			#define ASE_NEEDS_WORLD_POSITION
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_INSTANCED_TERRAIN
			#define ASE_NEEDS_VERT_POSITION
			#pragma multi_compile_instancing
			#pragma instancing_options assumeuniformscaling nomatrices nolightprobe nolightmap
			#define TERRAIN_SPLAT_FIRSTPASS 1
			#define _LAYER_COUNT 8
			#pragma shader_feature_local _TERRAIN_8_LAYERS
			#pragma editor_sync_compilation
			#pragma shader_feature_local _NORMALMAP
			#pragma shader_feature_local _MASKMAP


			#if defined(ASE_EARLY_Z_DEPTH_OPTIMIZE) && (SHADER_TARGET >= 45)
				#define ASE_SV_DEPTH SV_DepthLessEqual
				#define ASE_SV_POSITION_QUALIFIERS linear noperspective centroid
			#else
				#define ASE_SV_DEPTH SV_Depth
				#define ASE_SV_POSITION_QUALIFIERS
			#endif

			struct Attributes
			{
				float4 positionOS : POSITION;
				half3 normalOS : NORMAL;
				half4 tangentOS : TANGENT;
				float4 texcoord : TEXCOORD0;
				#if defined(LIGHTMAP_ON) || defined(ASE_NEEDS_TEXTURE_COORDINATES1)
					float4 texcoord1 : TEXCOORD1;
				#endif
				#if defined(DYNAMICLIGHTMAP_ON) || defined(ASE_NEEDS_TEXTURE_COORDINATES2)
					float4 texcoord2 : TEXCOORD2;
				#endif
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct PackedVaryings
			{
				ASE_SV_POSITION_QUALIFIERS float4 positionCS : SV_POSITION;
				float3 positionWS : TEXCOORD0;
				half3 normalWS : TEXCOORD1;
				float4 tangentWS : TEXCOORD2; // holds terrainUV ifdef ENABLE_TERRAIN_PERPIXEL_NORMAL
				float4 lightmapUVOrVertexSH : TEXCOORD3;
				#if defined(ASE_FOG) || defined(_ADDITIONAL_LIGHTS_VERTEX)
					half4 fogFactorAndVertexLight : TEXCOORD4;
				#endif
				#if defined(DYNAMICLIGHTMAP_ON)
					float2 dynamicLightmapUV : TEXCOORD5;
				#endif
				#if defined(USE_APV_PROBE_OCCLUSION)
					float4 probeOcclusion : TEXCOORD6;
				#endif
				float4 ase_texcoord7 : TEXCOORD7;
				float4 ase_texcoord8 : TEXCOORD8;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _Control_ST;
			float4 _MaskMapRemapScale4;
			float4 _MaskMapRemapOffset4;
			float4 _MaskMapRemapScale3;
			half4 _SnowColor;
			float4 _SnowMainUVs;
			float4 _MaskMapRemapOffset3;
			float4 _MaskMapRemapOffset2;
			float4 _MaskMapRemapScale1;
			float4 _MaskMapRemapOffset1;
			float4 _SnowMapSplat_ST;
			float4 _MaskMapRemapScale0;
			float4 _Specular7;
			float4 _Specular6;
			float4 _Specular5;
			float4 _MaskMapRemapScale7;
			float4 _Specular4;
			float4 _Specular3;
			float4 _Specular2;
			float4 _Specular1;
			float4 _Specular0;
			float4 _MaskMapRemapOffset0;
			float4 _Splat7_ST;
			float4 _MaskMapRemapScale2;
			float4 _MaskMapRemapOffset5;
			float4 _DiffuseRemapScale7;
			float4 _MaskMapRemapScale6;
			float4 _Splat2_ST;
			float4 _DiffuseRemapScale2;
			float4 _DiffuseRemapScale3;
			float4 _Splat3_ST;
			float4 _Splat1_ST;
			float4 _MaskMapRemapOffset6;
			float4 _DiffuseRemapScale1;
			float4 _DiffuseRemapScale4;
			float4 _Control1_ST;
			float4 _Splat0_ST;
			float4 _Splat6_ST;
			float4 _DiffuseRemapScale6;
			float4 _MaskMapRemapOffset7;
			float4 _Splat5_ST;
			float4 _MaskMapRemapScale5;
			float4 _DiffuseRemapScale0;
			float4 _Splat4_ST;
			float4 _DiffuseRemapScale5;
			half _SnowNormalStrength;
			float _LayerHasMask6;
			float _OpacityAsDensity1;
			half _NormalScale7;
			float _Smoothness0;
			float _OpacityAsDensity0;
			float _Smoothness1;
			float _Smoothness2;
			float _OpacityAsDensity5;
			float _Smoothness3;
			float _LayerHasMask4;
			float _LayerHasMask3;
			float _LayerHasMask5;
			float _LayerHasMask2;
			half _NormalScale6;
			float _LayerHasMask1;
			float _LayerHasMask0;
			float _OpacityAsDensity7;
			float _Smoothness7;
			float _OpacityAsDensity6;
			float _Smoothness6;
			float _Smoothness5;
			float _OpacityAsDensity4;
			float _Smoothness4;
			float _OpacityAsDensity3;
			float _OpacityAsDensity2;
			half _NormalScale5;
			float _Metallic2;
			half _NormalScale3;
			half _SnowSplatGBlendFalloff;
			half _SnowSplatGBlendFactor;
			half _SnowSplatREnable;
			half _SnowSplatRMax;
			half _SnowSplatRMin;
			half _SnowSplatRBlendStrength;
			half _SnowSplatRBlendFalloff;
			half _SnowSplatRBlendFactor;
			half _SnowBrightness;
			half _SnowSaturation;
			half _SnowSplatGBlendStrength;
			half _SnowSplatASplatBias;
			half _SnowSplatGSplatBias;
			half _SnowSplatRSplatBias;
			half _Splat7Brightness;
			half _Splat6Brightness;
			half _Splat5Brightness;
			half _Splat4Brightness;
			half _Splat3Brightness;
			half _Splat2Brightness;
			half _Splat1Brightness;
			half _Splat0Brightness;
			half _SnowSplatBSplatBias;
			half _SnowSplatGMin;
			half _SnowSplatGMax;
			half _SnowSplatGEnable;
			half _NormalScale2;
			half _NormalScale1;
			half _NormalScale0;
			float _Metallic7;
			float _Metallic6;
			float _Metallic5;
			float _Metallic4;
			float _Metallic3;
			float _Metallic1;
			float _Metallic0;
			half _SnowEnable;
			half _SnowSplatAEnable;
			half _SnowSplatAMax;
			half _SnowSplatAMin;
			half _SnowSplatABlendStrength;
			half _SnowSplatABlendFalloff;
			half _SnowSplatABlendFactor;
			half _SnowSplatBEnable;
			half _SnowSplatBMax;
			half _SnowSplatBMin;
			half _SnowSplatBBlendStrength;
			half _SnowSplatBBlendFalloff;
			half _SnowSplatBBlendFactor;
			half _NormalScale4;
			float _LayerHasMask7;
			float _AlphaClip;
			float _Cutoff;
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
			CBUFFER_END

			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			TEXTURE2D(_Control);
			SAMPLER(sampler_Control);
			TEXTURE2D(_Splat0);
			SAMPLER(sampler_Splat0);
			TEXTURE2D(_Splat1);
			TEXTURE2D(_Splat2);
			TEXTURE2D(_Splat3);
			TEXTURE2D(_Control1);
			SAMPLER(sampler_Control1);
			TEXTURE2D(_Splat4);
			TEXTURE2D(_Splat5);
			TEXTURE2D(_Splat6);
			TEXTURE2D(_Splat7);
			TEXTURE2D(_TerrainHolesTexture);
			SAMPLER(sampler_TerrainHolesTexture);
			TEXTURE2D(_SnowMapSplat);
			SAMPLER(sampler_SnowMapSplat);
			TEXTURE2D(_SnowMapBaseColor);
			SAMPLER(sampler_SnowMapBaseColor);
			TEXTURE2D(_Mask0);
			SAMPLER(sampler_Mask0);
			TEXTURE2D(_Mask1);
			TEXTURE2D(_Mask2);
			TEXTURE2D(_Mask3);
			TEXTURE2D(_Mask4);
			TEXTURE2D(_Mask5);
			TEXTURE2D(_Mask6);
			TEXTURE2D(_Mask7);
			TEXTURE2D(_Normal0);
			SAMPLER(sampler_Normal0);
			TEXTURE2D(_Normal1);
			TEXTURE2D(_Normal2);
			TEXTURE2D(_Normal3);
			TEXTURE2D(_Normal4);
			TEXTURE2D(_Normal5);
			TEXTURE2D(_Normal6);
			TEXTURE2D(_Normal7);
			TEXTURE2D(_SnowMapNormal);
			SAMPLER(sampler_SnowMapNormal);
			#ifdef UNITY_INSTANCING_ENABLED//ASE Terrain Instancing
				TEXTURE2D(_TerrainHeightmapTexture);//ASE Terrain Instancing
				TEXTURE2D( _TerrainNormalmapTexture);//ASE Terrain Instancing
				SAMPLER(sampler_TerrainNormalmapTexture);//ASE Terrain Instancing
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
				float2 sampleCoords = ( patchVertex.xy + instanceData.xy ) * instanceData.z;
				float height = UnpackHeightmap( _TerrainHeightmapTexture.Load( int3( sampleCoords, 0 ) ) );
				position.xz = sampleCoords* _TerrainHeightmapScale.xz;
				position.y = height* _TerrainHeightmapScale.y;
				#ifdef ENABLE_TERRAIN_PERPIXEL_NORMAL
					normal = float3(0, 1, 0);
				#else
					normal = _TerrainNormalmapTexture.Load(int3(sampleCoords, 0)).rgb* 2 - 1;
				#endif
				texcoord.xy = sampleCoords* _TerrainHeightmapRecipSize.zw;
			#endif
			}
			

			PackedVaryings VertexFunction( Attributes input  )
			{
				PackedVaryings output = (PackedVaryings)0;
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_TRANSFER_INSTANCE_ID(input, output);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(output);

				#if defined( ASE_INSTANCED_TERRAIN ) && !defined( ASE_TESSELLATION )
					TerrainApplyMeshModification( input.positionOS.xyz, input.normalOS, input.texcoord );
				#endif
				
				float4 appendResult993_g83 = (float4(cross( input.normalOS , float3( 0, 0, 1 ) ) , -1.0));
				
				float2 TecCoord01294_g83 = input.texcoord.xy;
				float2 break291_g83 = _Control_ST.zw;
				float2 appendResult293_g83 = (float2(( break291_g83.x + 0.001 ) , ( break291_g83.y + 0.0001 )));
				float2 vertexToFrag286_g83 = ( ( TecCoord01294_g83 * _Control_ST.xy ) + appendResult293_g83 );
				output.ase_texcoord7.xy = vertexToFrag286_g83;
				float2 break1393_g83 = _Control1_ST.zw;
				float2 appendResult1382_g83 = (float2(( break1393_g83.x + 0.001 ) , ( break1393_g83.y + 0.0001 )));
				float2 vertexToFrag1395_g83 = ( ( TecCoord01294_g83 * _Control1_ST.xy ) + appendResult1382_g83 );
				output.ase_texcoord8.xy = vertexToFrag1395_g83;
				float2 vertexToFrag1085_g83 = ( ( TecCoord01294_g83 * (_SnowMainUVs).xy ) + (_SnowMainUVs).zw );
				output.ase_texcoord8.zw = vertexToFrag1085_g83;
				
				output.ase_texcoord7.zw = input.texcoord.xy;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = input.positionOS.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = defaultVertexValue;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					input.positionOS.xyz = vertexValue;
				#else
					input.positionOS.xyz += vertexValue;
				#endif
				input.normalOS = input.normalOS;
				input.tangentOS = appendResult993_g83;

				VertexPositionInputs vertexInput = GetVertexPositionInputs( input.positionOS.xyz );
				VertexNormalInputs normalInput = GetVertexNormalInputs( input.normalOS, input.tangentOS );

				OUTPUT_LIGHTMAP_UV(input.texcoord1, unity_LightmapST, output.lightmapUVOrVertexSH.xy);
				#if defined(DYNAMICLIGHTMAP_ON)
					output.dynamicLightmapUV.xy = input.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
				#endif
				OUTPUT_SH4(vertexInput.positionWS, normalInput.normalWS.xyz, GetWorldSpaceNormalizeViewDir(vertexInput.positionWS), output.lightmapUVOrVertexSH.xyz, output.probeOcclusion);

				#if defined(ASE_FOG) || defined(_ADDITIONAL_LIGHTS_VERTEX)
					output.fogFactorAndVertexLight = 0;
					#if defined(ASE_FOG) && !defined(_FOG_FRAGMENT)
						output.fogFactorAndVertexLight.x = ComputeFogFactor(vertexInput.positionCS.z);
					#endif
					#ifdef _ADDITIONAL_LIGHTS_VERTEX
						half3 vertexLight = VertexLighting( vertexInput.positionWS, normalInput.normalWS );
						output.fogFactorAndVertexLight.yzw = vertexLight;
					#endif
				#endif

				output.positionCS = vertexInput.positionCS;
				output.positionWS = vertexInput.positionWS;
				output.normalWS = normalInput.normalWS;
				output.tangentWS = float4( normalInput.tangentWS, ( input.tangentOS.w > 0.0 ? 1.0 : -1.0 ) * GetOddNegativeScale() );

				#if defined( ENABLE_TERRAIN_PERPIXEL_NORMAL )
					output.tangentWS.zw = input.texcoord.xy;
					output.tangentWS.xy = input.texcoord.xy * unity_LightmapST.xy + unity_LightmapST.zw;
				#endif
				return output;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 positionOS : INTERNALTESSPOS;
				half3 normalOS : NORMAL;
				half4 tangentOS : TANGENT;
				float4 texcoord : TEXCOORD0;
				#if defined(LIGHTMAP_ON) || defined(ASE_NEEDS_TEXTURE_COORDINATES1)
					float4 texcoord1 : TEXCOORD1;
				#endif
				#if defined(DYNAMICLIGHTMAP_ON) || defined(ASE_NEEDS_TEXTURE_COORDINATES2)
					float4 texcoord2 : TEXCOORD2;
				#endif
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( Attributes input )
			{
				VertexControl output;
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_TRANSFER_INSTANCE_ID(input, output);
				output.positionOS = input.positionOS;
				output.normalOS = input.normalOS;
				output.tangentOS = input.tangentOS;
				output.texcoord = input.texcoord;
				#if defined(LIGHTMAP_ON) || defined(ASE_NEEDS_TEXTURE_COORDINATES1)
					output.texcoord1 = input.texcoord1;
				#endif
				#if defined(DYNAMICLIGHTMAP_ON) || defined(ASE_NEEDS_TEXTURE_COORDINATES2)
					output.texcoord2 = input.texcoord2;
				#endif
				#if defined( ASE_INSTANCED_TERRAIN )
					TerrainApplyMeshModification( output.positionOS.xyz, output.normalOS, output.texcoord );
				#endif
				
				return output;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> input)
			{
				TessellationFactors output;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(input[0].positionOS, input[1].positionOS, input[2].positionOS, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(input[0].positionOS, input[1].positionOS, input[2].positionOS, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(input[0].positionOS, input[1].positionOS, input[2].positionOS, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				output.edge[0] = tf.x; output.edge[1] = tf.y; output.edge[2] = tf.z; output.inside = tf.w;
				return output;
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
			PackedVaryings DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				Attributes output = (Attributes) 0;
				output.positionOS = patch[0].positionOS * bary.x + patch[1].positionOS * bary.y + patch[2].positionOS * bary.z;
				output.normalOS = patch[0].normalOS * bary.x + patch[1].normalOS * bary.y + patch[2].normalOS * bary.z;
				output.tangentOS = patch[0].tangentOS * bary.x + patch[1].tangentOS * bary.y + patch[2].tangentOS * bary.z;
				output.texcoord = patch[0].texcoord * bary.x + patch[1].texcoord * bary.y + patch[2].texcoord * bary.z;
				#if defined(LIGHTMAP_ON) || defined(ASE_NEEDS_TEXTURE_COORDINATES1)
					output.texcoord1 = patch[0].texcoord1 * bary.x + patch[1].texcoord1 * bary.y + patch[2].texcoord1 * bary.z;
				#endif
				#if defined(DYNAMICLIGHTMAP_ON) || defined(ASE_NEEDS_TEXTURE_COORDINATES2)
					output.texcoord2 = patch[0].texcoord2 * bary.x + patch[1].texcoord2 * bary.y + patch[2].texcoord2 * bary.z;
				#endif
				
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = output.positionOS.xyz - patch[i].normalOS * (dot(output.positionOS.xyz, patch[i].normalOS) - dot(patch[i].positionOS.xyz, patch[i].normalOS));
				float phongStrength = _TessPhongStrength;
				output.positionOS.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * output.positionOS.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], output);
				return VertexFunction(output);
			}
			#else
			PackedVaryings vert ( Attributes input )
			{
				return VertexFunction( input );
			}
			#endif

			half4 frag ( PackedVaryings input
						#if defined( ASE_DEPTH_WRITE_ON )
						,out float outputDepth : ASE_SV_DEPTH
						#endif
						#ifdef _WRITE_RENDERING_LAYERS
						, out uint outRenderingLayers : SV_Target1
						#endif
						 ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input);

				#if defined( _SURFACE_TYPE_TRANSPARENT )
					const bool isTransparent = true;
				#else
					const bool isTransparent = false;
				#endif

				#if defined(LOD_FADE_CROSSFADE)
					LODFadeCrossFade( input.positionCS );
				#endif

				#if defined(MAIN_LIGHT_CALCULATE_SHADOWS)
					float4 shadowCoord = TransformWorldToShadowCoord( input.positionWS );
				#else
					float4 shadowCoord = float4(0, 0, 0, 0);
				#endif

				// @diogo: mikktspace compliant
				float renormFactor = 1.0 / max( FLT_MIN, length( input.normalWS ) );

				float3 PositionWS = input.positionWS;
				float3 PositionRWS = GetCameraRelativePositionWS( PositionWS );
				float3 ViewDirWS = GetWorldSpaceNormalizeViewDir( PositionWS );
				float4 ShadowCoord = shadowCoord;
				float4 ScreenPosNorm = float4( GetNormalizedScreenSpaceUV( input.positionCS ), input.positionCS.zw );
				float4 ClipPos = ComputeClipSpacePosition( ScreenPosNorm.xy, input.positionCS.z ) * input.positionCS.w;
				float4 ScreenPos = ComputeScreenPos( ClipPos );
				float3 TangentWS = input.tangentWS.xyz * renormFactor;
				float3 BitangentWS = cross( input.normalWS, input.tangentWS.xyz ) * input.tangentWS.w * renormFactor;
				float3 NormalWS = input.normalWS * renormFactor;

				#if defined( ENABLE_TERRAIN_PERPIXEL_NORMAL )
					float2 sampleCoords = (input.tangentWS.zw / _TerrainHeightmapRecipSize.zw + 0.5f) * _TerrainHeightmapRecipSize.xy;
					NormalWS = TransformObjectToWorldNormal(normalize(SAMPLE_TEXTURE2D(_TerrainNormalmapTexture, sampler_TerrainNormalmapTexture, sampleCoords).rgb * 2 - 1));
					TangentWS = -cross(GetObjectToWorldMatrix()._13_23_33, NormalWS);
					BitangentWS = cross(NormalWS, -TangentWS);
				#endif

				float2 vertexToFrag286_g83 = input.ase_texcoord7.xy;
				float4 Control26_g83 = SAMPLE_TEXTURE2D( _Control, sampler_Control, vertexToFrag286_g83 );
				float2 TecCoord01294_g83 = input.ase_texcoord7.zw;
				float3 Splat0342_g83 = (SAMPLE_TEXTURE2D( _Splat0, sampler_Splat0, ( ( TecCoord01294_g83 * _Splat0_ST.xy ) + _Splat0_ST.zw ) )).rgb;
				float3 temp_output_35_0_g83 = ( (_DiffuseRemapScale0).xyz * Splat0342_g83 * _Splat0Brightness );
				float3 Splat1379_g83 = (SAMPLE_TEXTURE2D( _Splat1, sampler_Splat0, ( ( TecCoord01294_g83 * _Splat1_ST.xy ) + _Splat1_ST.zw ) )).rgb;
				float3 temp_output_38_0_g83 = ( (_DiffuseRemapScale1).xyz * Splat1379_g83 * _Splat1Brightness );
				float3 Splat2357_g83 = (SAMPLE_TEXTURE2D( _Splat2, sampler_Splat0, ( ( TecCoord01294_g83 * _Splat2_ST.xy ) + _Splat2_ST.zw ) )).rgb;
				float3 temp_output_41_0_g83 = ( (_DiffuseRemapScale2).xyz * Splat2357_g83 * _Splat2Brightness );
				float3 Splat3390_g83 = (SAMPLE_TEXTURE2D( _Splat3, sampler_Splat0, ( ( TecCoord01294_g83 * _Splat3_ST.xy ) + _Splat3_ST.zw ) )).rgb;
				float3 temp_output_44_0_g83 = ( (_DiffuseRemapScale3).xyz * Splat3390_g83 * _Splat3Brightness );
				float4 weightedBlendVar9_g83 = Control26_g83;
				float3 weightedBlend9_g83 = ( weightedBlendVar9_g83.x*temp_output_35_0_g83 + weightedBlendVar9_g83.y*temp_output_38_0_g83 + weightedBlendVar9_g83.z*temp_output_41_0_g83 + weightedBlendVar9_g83.w*temp_output_44_0_g83 );
				float2 vertexToFrag1395_g83 = input.ase_texcoord8.xy;
				float4 Control1922_g83 = SAMPLE_TEXTURE2D( _Control1, sampler_Control1, vertexToFrag1395_g83 );
				float3 Splat4752_g83 = (SAMPLE_TEXTURE2D( _Splat4, sampler_Splat0, ( ( TecCoord01294_g83 * _Splat4_ST.xy ) + _Splat4_ST.zw ) )).rgb;
				float3 temp_output_900_0_g83 = ( (_DiffuseRemapScale4).xyz * Splat4752_g83 * _Splat4Brightness );
				float3 Splat5743_g83 = (SAMPLE_TEXTURE2D( _Splat5, sampler_Splat0, ( ( TecCoord01294_g83 * _Splat5_ST.xy ) + _Splat5_ST.zw ) )).rgb;
				float3 temp_output_901_0_g83 = ( (_DiffuseRemapScale5).xyz * Splat5743_g83 * _Splat5Brightness );
				float3 Splat6759_g83 = (SAMPLE_TEXTURE2D( _Splat6, sampler_Splat0, ( ( TecCoord01294_g83 * _Splat6_ST.xy ) + _Splat6_ST.zw ) )).rgb;
				float3 temp_output_919_0_g83 = ( (_DiffuseRemapScale6).xyz * Splat6759_g83 * _Splat6Brightness );
				float3 Splat7762_g83 = (SAMPLE_TEXTURE2D( _Splat7, sampler_Splat0, ( ( TecCoord01294_g83 * _Splat7_ST.xy ) + _Splat7_ST.zw ) )).rgb;
				float3 temp_output_921_0_g83 = ( (_DiffuseRemapScale7).xyz * Splat7762_g83 * _Splat7Brightness );
				float4 weightedBlendVar912_g83 = Control1922_g83;
				float3 weightedBlend912_g83 = ( weightedBlendVar912_g83.x*temp_output_900_0_g83 + weightedBlendVar912_g83.y*temp_output_901_0_g83 + weightedBlendVar912_g83.z*temp_output_919_0_g83 + weightedBlendVar912_g83.w*temp_output_921_0_g83 );
				float3 localClipHoles453_g83 = ( ( weightedBlend9_g83 + weightedBlend912_g83 ) );
				float2 uv_TerrainHolesTexture451_g83 = input.ase_texcoord7.zw;
				float Hole453_g83 = SAMPLE_TEXTURE2D( _TerrainHolesTexture, sampler_TerrainHolesTexture, uv_TerrainHolesTexture451_g83 ).r;
				{
				#ifdef _ALPHATEST_ON
				clip(Hole453_g83 == 0.0005f? -1 : 1);
				#endif
				}
				float2 uv_SnowMapSplat = input.ase_texcoord7.zw * _SnowMapSplat_ST.xy + _SnowMapSplat_ST.zw;
				float4 tex2DNode1080_g83 = SAMPLE_TEXTURE2D( _SnowMapSplat, sampler_SnowMapSplat, uv_SnowMapSplat );
				float4 appendResult1076_g83 = (float4(( tex2DNode1080_g83.r * _SnowSplatRSplatBias ) , ( tex2DNode1080_g83.g * _SnowSplatGSplatBias ) , ( tex2DNode1080_g83.b * _SnowSplatBSplatBias ) , ( tex2DNode1080_g83.a * _SnowSplatASplatBias )));
				float4 SnowSplatRGBA1117_g83 = appendResult1076_g83;
				float2 vertexToFrag1085_g83 = input.ase_texcoord8.zw;
				float2 temp_output_1083_0_g83 = ( vertexToFrag1085_g83 * 100.0 );
				float3 temp_output_12_0_g84 = (SAMPLE_TEXTURE2D( _SnowMapBaseColor, sampler_SnowMapBaseColor, temp_output_1083_0_g83 )).rgb;
				float dotResult28_g84 = dot( float3( 0.2126729, 0.7151522, 0.072175 ) , temp_output_12_0_g84 );
				float3 temp_cast_0 = (dotResult28_g84).xxx;
				float temp_output_21_0_g84 = ( 1.0 - _SnowSaturation );
				float3 lerpResult31_g84 = lerp( temp_cast_0 , temp_output_12_0_g84 , temp_output_21_0_g84);
				float3 SnowBaseColor1112_g83 = ( (_SnowColor).rgb * lerpResult31_g84 * _SnowBrightness );
				float4 break1118_g83 = appendResult1076_g83;
				float SnowSplatR1119_g83 = break1118_g83.x;
				float saferPower1027_g83 = abs( max( ( SnowSplatR1119_g83 * ( 1.0 + _SnowSplatRBlendFactor ) ), 0.0 ) );
				float lerpResult1029_g83 = lerp( 0.0 , pow( saferPower1027_g83 , ( 1.0 - _SnowSplatRBlendFalloff ) ) ,  (-1.0 + ( _SnowSplatRBlendStrength - 0.0 ) * ( 0.0 - -1.0 ) / ( 1.0 - 0.0 ) ));
				float3 WorldPosition1123_g83 = PositionWS;
				float smoothstepResult1053_g83 = smoothstep( _SnowSplatRMin , _SnowSplatRMax , WorldPosition1123_g83.y);
				float lerpResult1124_g83 = lerp( 0.0 , saturate( lerpResult1029_g83 ) , smoothstepResult1053_g83);
				float SnowSplatRMask1071_g83 = lerpResult1124_g83;
				float3 lerpResult1159_g83 = lerp( localClipHoles453_g83 , SnowBaseColor1112_g83 , SnowSplatRMask1071_g83);
				float3 lerpResult1133_g83 = lerp( localClipHoles453_g83 , lerpResult1159_g83 , _SnowSplatREnable);
				float SnowSplatG1081_g83 = break1118_g83.y;
				float saferPower1021_g83 = abs( max( ( SnowSplatG1081_g83 * ( 1.0 + _SnowSplatGBlendFactor ) ), 0.0 ) );
				float lerpResult1022_g83 = lerp( 0.0 , pow( saferPower1021_g83 , ( 1.0 - _SnowSplatGBlendFalloff ) ) ,  (-1.0 + ( _SnowSplatGBlendStrength - 0.0 ) * ( 0.0 - -1.0 ) / ( 1.0 - 0.0 ) ));
				float smoothstepResult1060_g83 = smoothstep( _SnowSplatGMin , _SnowSplatGMax , WorldPosition1123_g83.y);
				float lerpResult1036_g83 = lerp( 0.0 , saturate( lerpResult1022_g83 ) , smoothstepResult1060_g83);
				float SnowSplatGMask1072_g83 = lerpResult1036_g83;
				float3 lerpResult1158_g83 = lerp( localClipHoles453_g83 , SnowBaseColor1112_g83 , SnowSplatGMask1072_g83);
				float3 lerpResult1134_g83 = lerp( localClipHoles453_g83 , lerpResult1158_g83 , _SnowSplatGEnable);
				float SnowSplatB1120_g83 = break1118_g83.z;
				float saferPower1065_g83 = abs( max( ( SnowSplatB1120_g83 * ( 1.0 + _SnowSplatBBlendFactor ) ), 0.0 ) );
				float lerpResult1064_g83 = lerp( 0.0 , pow( saferPower1065_g83 , ( 1.0 - _SnowSplatBBlendFalloff ) ) ,  (-1.0 + ( _SnowSplatBBlendStrength - 0.0 ) * ( 0.0 - -1.0 ) / ( 1.0 - 0.0 ) ));
				float smoothstepResult1037_g83 = smoothstep( _SnowSplatBMin , _SnowSplatBMax , WorldPosition1123_g83.y);
				float lerpResult1038_g83 = lerp( 0.0 , saturate( lerpResult1064_g83 ) , smoothstepResult1037_g83);
				float SnowSplatBMask1073_g83 = lerpResult1038_g83;
				float3 lerpResult1160_g83 = lerp( localClipHoles453_g83 , SnowBaseColor1112_g83 , SnowSplatBMask1073_g83);
				float3 lerpResult1163_g83 = lerp( localClipHoles453_g83 , lerpResult1160_g83 , _SnowSplatBEnable);
				float SnowSplatA1121_g83 = break1118_g83.w;
				float saferPower1007_g83 = abs( max( ( SnowSplatA1121_g83 * ( 1.0 + _SnowSplatABlendFactor ) ), 0.0 ) );
				float lerpResult1008_g83 = lerp( 0.0 , pow( saferPower1007_g83 , ( 1.0 - _SnowSplatABlendFalloff ) ) ,  (-1.0 + ( _SnowSplatABlendStrength - 0.0 ) * ( 0.0 - -1.0 ) / ( 1.0 - 0.0 ) ));
				float smoothstepResult1043_g83 = smoothstep( _SnowSplatAMin , _SnowSplatAMax , WorldPosition1123_g83.y);
				float lerpResult1126_g83 = lerp( 0.0 , saturate( lerpResult1008_g83 ) , smoothstepResult1043_g83);
				float SnowSplatAMask1074_g83 = lerpResult1126_g83;
				float3 lerpResult1161_g83 = lerp( localClipHoles453_g83 , SnowBaseColor1112_g83 , SnowSplatAMask1074_g83);
				float3 lerpResult1162_g83 = lerp( localClipHoles453_g83 , lerpResult1161_g83 , _SnowSplatAEnable);
				float4 weightedBlendVar1136_g83 = SnowSplatRGBA1117_g83;
				float3 weightedBlend1136_g83 = ( weightedBlendVar1136_g83.x*lerpResult1133_g83 + weightedBlendVar1136_g83.y*lerpResult1134_g83 + weightedBlendVar1136_g83.z*lerpResult1163_g83 + weightedBlendVar1136_g83.w*lerpResult1162_g83 );
				float3 lerpResult1142_g83 = lerp( localClipHoles453_g83 , weightedBlend1136_g83 , _SnowEnable);
				float4 break2097_g83 = SAMPLE_TEXTURE2D( _Mask0, sampler_Mask0, ( ( TecCoord01294_g83 * _Splat0_ST.xy ) + _Splat0_ST.zw ) );
				float Mask0R334_g83 = break2097_g83.r;
				float4 break2193_g83 = SAMPLE_TEXTURE2D( _Mask1, sampler_Mask0, ( ( TecCoord01294_g83 * _Splat1_ST.xy ) + _Splat1_ST.zw ) );
				float Mask1R370_g83 = break2193_g83.r;
				float4 break2262_g83 = SAMPLE_TEXTURE2D( _Mask2, sampler_Mask0, ( ( TecCoord01294_g83 * _Splat2_ST.xy ) + _Splat2_ST.zw ) );
				float Mask2R359_g83 = break2262_g83.r;
				float4 break2342_g83 = SAMPLE_TEXTURE2D( _Mask3, sampler_Mask0, ( ( TecCoord01294_g83 * _Splat3_ST.xy ) + _Splat3_ST.zw ) );
				float Mask3R388_g83 = break2342_g83.r;
				float4 weightedBlendVar536_g83 = Control26_g83;
				float weightedBlend536_g83 = ( weightedBlendVar536_g83.x*( _Metallic0 * Mask0R334_g83 ) + weightedBlendVar536_g83.y*( _Metallic1 * Mask1R370_g83 ) + weightedBlendVar536_g83.z*( _Metallic2 * Mask2R359_g83 ) + weightedBlendVar536_g83.w*( _Metallic3 * Mask3R388_g83 ) );
				float4 break2413_g83 = SAMPLE_TEXTURE2D( _Mask4, sampler_Mask0, ( ( TecCoord01294_g83 * _Splat4_ST.xy ) + _Splat4_ST.zw ) );
				float Mask4R747_g83 = break2413_g83.r;
				float4 break2472_g83 = SAMPLE_TEXTURE2D( _Mask5, sampler_Mask0, ( ( TecCoord01294_g83 * _Splat5_ST.xy ) + _Splat5_ST.zw ) );
				float Mask5R741_g83 = break2472_g83.r;
				float4 break2531_g83 = SAMPLE_TEXTURE2D( _Mask6, sampler_Mask0, ( ( TecCoord01294_g83 * _Splat6_ST.xy ) + _Splat6_ST.zw ) );
				float Mask6R755_g83 = break2531_g83.r;
				float4 break2590_g83 = SAMPLE_TEXTURE2D( _Mask7, sampler_Mask0, ( ( TecCoord01294_g83 * _Splat7_ST.xy ) + _Splat7_ST.zw ) );
				float Mask7R765_g83 = break2590_g83.r;
				float4 weightedBlendVar834_g83 = Control1922_g83;
				float weightedBlend834_g83 = ( weightedBlendVar834_g83.x*( _Metallic4 * Mask4R747_g83 ) + weightedBlendVar834_g83.y*( _Metallic5 * Mask5R741_g83 ) + weightedBlendVar834_g83.z*( _Metallic6 * Mask6R755_g83 ) + weightedBlendVar834_g83.w*( _Metallic7 * Mask7R765_g83 ) );
				float3 specularColor1792_g83 = (0).xxx;
				float oneMinusReflectivity1792_g83 = 0;
				float3 diffuseColor1792_g83 = ASEComputeDiffuseAndFresnel0( lerpResult1142_g83, ( weightedBlend536_g83 + weightedBlend834_g83 ), specularColor1792_g83, oneMinusReflectivity1792_g83 );
				
				float4 Normal0341_g83 = SAMPLE_TEXTURE2D( _Normal0, sampler_Normal0, ( ( TecCoord01294_g83 * _Splat0_ST.xy ) + _Splat0_ST.zw ) );
				float3 unpack490_g83 = UnpackNormalScale( Normal0341_g83, _NormalScale0 );
				unpack490_g83.z = lerp( 1, unpack490_g83.z, saturate(_NormalScale0) );
				float4 Normal1378_g83 = SAMPLE_TEXTURE2D( _Normal1, sampler_Normal0, ( ( TecCoord01294_g83 * _Splat1_ST.xy ) + _Splat1_ST.zw ) );
				float3 unpack496_g83 = UnpackNormalScale( Normal1378_g83, _NormalScale1 );
				unpack496_g83.z = lerp( 1, unpack496_g83.z, saturate(_NormalScale1) );
				float4 Normal2356_g83 = SAMPLE_TEXTURE2D( _Normal2, sampler_Normal0, ( ( TecCoord01294_g83 * _Splat2_ST.xy ) + _Splat2_ST.zw ) );
				float3 unpack494_g83 = UnpackNormalScale( Normal2356_g83, _NormalScale2 );
				unpack494_g83.z = lerp( 1, unpack494_g83.z, saturate(_NormalScale2) );
				float4 Normal3398_g83 = SAMPLE_TEXTURE2D( _Normal3, sampler_Normal0, ( ( TecCoord01294_g83 * _Splat3_ST.xy ) + _Splat3_ST.zw ) );
				float3 unpack491_g83 = UnpackNormalScale( Normal3398_g83, _NormalScale3 );
				unpack491_g83.z = lerp( 1, unpack491_g83.z, saturate(_NormalScale3) );
				float4 weightedBlendVar473_g83 = Control26_g83;
				float3 weightedBlend473_g83 = ( weightedBlendVar473_g83.x*unpack490_g83 + weightedBlendVar473_g83.y*unpack496_g83 + weightedBlendVar473_g83.z*unpack494_g83 + weightedBlendVar473_g83.w*unpack491_g83 );
				float4 Normal4746_g83 = SAMPLE_TEXTURE2D( _Normal4, sampler_Normal0, ( ( TecCoord01294_g83 * _Splat4_ST.xy ) + _Splat4_ST.zw ) );
				float3 unpack856_g83 = UnpackNormalScale( Normal4746_g83, _NormalScale4 );
				unpack856_g83.z = lerp( 1, unpack856_g83.z, saturate(_NormalScale4) );
				float4 Normal5740_g83 = SAMPLE_TEXTURE2D( _Normal5, sampler_Normal0, ( ( TecCoord01294_g83 * _Splat5_ST.xy ) + _Splat5_ST.zw ) );
				float3 unpack857_g83 = UnpackNormalScale( Normal5740_g83, _NormalScale5 );
				unpack857_g83.z = lerp( 1, unpack857_g83.z, saturate(_NormalScale5) );
				float4 Normal6754_g83 = SAMPLE_TEXTURE2D( _Normal6, sampler_Normal0, ( ( TecCoord01294_g83 * _Splat6_ST.xy ) + _Splat6_ST.zw ) );
				float3 unpack858_g83 = UnpackNormalScale( Normal6754_g83, _NormalScale6 );
				unpack858_g83.z = lerp( 1, unpack858_g83.z, saturate(_NormalScale6) );
				float4 Normal7764_g83 = SAMPLE_TEXTURE2D( _Normal7, sampler_Normal0, ( ( TecCoord01294_g83 * _Splat7_ST.xy ) + _Splat7_ST.zw ) );
				float3 unpack854_g83 = UnpackNormalScale( Normal7764_g83, _NormalScale7 );
				unpack854_g83.z = lerp( 1, unpack854_g83.z, saturate(_NormalScale7) );
				float4 weightedBlendVar860_g83 = Control1922_g83;
				float3 weightedBlend860_g83 = ( weightedBlendVar860_g83.x*unpack856_g83 + weightedBlendVar860_g83.y*unpack857_g83 + weightedBlendVar860_g83.z*unpack858_g83 + weightedBlendVar860_g83.w*unpack854_g83 );
				float3 break513_g83 = ( weightedBlend473_g83 + weightedBlend860_g83 );
				float3 appendResult514_g83 = (float3(break513_g83.x , break513_g83.y , ( break513_g83.z + 0.001 )));
				float3 unpack1127_g83 = UnpackNormalScale( SAMPLE_TEXTURE2D( _SnowMapNormal, sampler_SnowMapNormal, temp_output_1083_0_g83 ), _SnowNormalStrength );
				unpack1127_g83.z = lerp( 1, unpack1127_g83.z, saturate(_SnowNormalStrength) );
				float3 SnowNormal1090_g83 = unpack1127_g83;
				float SnowEnableRChannel1174_g83 = _SnowSplatREnable;
				float3 lerpResult1221_g83 = lerp( appendResult514_g83 , SnowNormal1090_g83 , SnowEnableRChannel1174_g83);
				float SnowEnableGChannel1175_g83 = _SnowSplatGEnable;
				float3 lerpResult1214_g83 = lerp( appendResult514_g83 , SnowNormal1090_g83 , SnowEnableGChannel1175_g83);
				float SnowEnableBChannel1176_g83 = _SnowSplatBEnable;
				float3 lerpResult1215_g83 = lerp( appendResult514_g83 , SnowNormal1090_g83 , SnowEnableBChannel1176_g83);
				float SnowEnableAChannel1177_g83 = _SnowSplatAEnable;
				float3 lerpResult1216_g83 = lerp( appendResult514_g83 , SnowNormal1090_g83 , SnowEnableAChannel1177_g83);
				float4 weightedBlendVar1220_g83 = SnowSplatRGBA1117_g83;
				float3 weightedBlend1220_g83 = ( weightedBlendVar1220_g83.x*lerpResult1221_g83 + weightedBlendVar1220_g83.y*lerpResult1214_g83 + weightedBlendVar1220_g83.z*lerpResult1215_g83 + weightedBlendVar1220_g83.w*lerpResult1216_g83 );
				float SnowEnable1173_g83 = _SnowEnable;
				float3 lerpResult1222_g83 = lerp( appendResult514_g83 , weightedBlend1220_g83 , SnowEnable1173_g83);
				
				float4 weightedBlendVar1777_g83 = Control26_g83;
				float4 weightedBlend1777_g83 = ( weightedBlendVar1777_g83.x*_Specular0 + weightedBlendVar1777_g83.y*_Specular1 + weightedBlendVar1777_g83.z*_Specular2 + weightedBlendVar1777_g83.w*_Specular3 );
				float4 weightedBlendVar1773_g83 = Control1922_g83;
				float4 weightedBlend1773_g83 = ( weightedBlendVar1773_g83.x*_Specular4 + weightedBlendVar1773_g83.y*_Specular5 + weightedBlendVar1773_g83.z*_Specular6 + weightedBlendVar1773_g83.w*_Specular7 );
				
				float Mask0A335_g83 = break2097_g83.a;
				float Splat0A435_g83 = (SAMPLE_TEXTURE2D( _Splat0, sampler_Splat0, ( ( TecCoord01294_g83 * _Splat0_ST.xy ) + _Splat0_ST.zw ) )).a;
				float lerpResult1509_g83 = lerp( Mask0A335_g83 , Splat0A435_g83 , _OpacityAsDensity0);
				float Mask1A369_g83 = break2193_g83.a;
				float Splat1A436_g83 = (SAMPLE_TEXTURE2D( _Splat1, sampler_Splat0, ( ( TecCoord01294_g83 * _Splat1_ST.xy ) + _Splat1_ST.zw ) )).a;
				float lerpResult1510_g83 = lerp( Mask1A369_g83 , Splat1A436_g83 , _OpacityAsDensity1);
				float Mask2A360_g83 = break2262_g83.a;
				float Splat2A438_g83 = (SAMPLE_TEXTURE2D( _Splat2, sampler_Splat0, ( ( TecCoord01294_g83 * _Splat2_ST.xy ) + _Splat2_ST.zw ) )).a;
				float lerpResult1511_g83 = lerp( Mask2A360_g83 , Splat2A438_g83 , _OpacityAsDensity2);
				float Mask3A391_g83 = break2342_g83.a;
				float Splat3A440_g83 = (SAMPLE_TEXTURE2D( _Splat3, sampler_Splat0, ( ( TecCoord01294_g83 * _Splat3_ST.xy ) + _Splat3_ST.zw ) )).a;
				float lerpResult1512_g83 = lerp( Mask3A391_g83 , Splat3A440_g83 , _OpacityAsDensity3);
				float4 weightedBlendVar547_g83 = Control26_g83;
				float weightedBlend547_g83 = ( weightedBlendVar547_g83.x*( _Smoothness0 * lerpResult1509_g83 ) + weightedBlendVar547_g83.y*( _Smoothness1 * lerpResult1510_g83 ) + weightedBlendVar547_g83.z*( _Smoothness2 * lerpResult1511_g83 ) + weightedBlendVar547_g83.w*( _Smoothness3 * lerpResult1512_g83 ) );
				float Mask4A750_g83 = break2413_g83.a;
				float Splat4A753_g83 = (SAMPLE_TEXTURE2D( _Splat4, sampler_Splat0, ( ( TecCoord01294_g83 * _Splat4_ST.xy ) + _Splat4_ST.zw ) )).a;
				float lerpResult1513_g83 = lerp( Mask4A750_g83 , Splat4A753_g83 , _OpacityAsDensity4);
				float Mask5A745_g83 = break2472_g83.a;
				float Splat5A739_g83 = (SAMPLE_TEXTURE2D( _Splat5, sampler_Splat0, ( ( TecCoord01294_g83 * _Splat5_ST.xy ) + _Splat5_ST.zw ) )).a;
				float lerpResult1514_g83 = lerp( Mask5A745_g83 , Splat5A739_g83 , _OpacityAsDensity5);
				float Mask6A758_g83 = break2531_g83.a;
				float Splat6A760_g83 = (SAMPLE_TEXTURE2D( _Splat6, sampler_Splat0, ( ( TecCoord01294_g83 * _Splat6_ST.xy ) + _Splat6_ST.zw ) )).a;
				float lerpResult1515_g83 = lerp( Mask6A758_g83 , Splat6A760_g83 , _OpacityAsDensity6);
				float Mask7A768_g83 = break2590_g83.a;
				float Splat7A763_g83 = (SAMPLE_TEXTURE2D( _Splat7, sampler_Splat0, ( ( TecCoord01294_g83 * _Splat7_ST.xy ) + _Splat7_ST.zw ) )).a;
				float lerpResult1516_g83 = lerp( Mask7A768_g83 , Splat7A763_g83 , _OpacityAsDensity7);
				float4 weightedBlendVar826_g83 = Control1922_g83;
				float weightedBlend826_g83 = ( weightedBlendVar826_g83.x*( _Smoothness4 * lerpResult1513_g83 ) + weightedBlendVar826_g83.y*( _Smoothness5 * lerpResult1514_g83 ) + weightedBlendVar826_g83.z*( _Smoothness6 * lerpResult1515_g83 ) + weightedBlendVar826_g83.w*( _Smoothness7 * lerpResult1516_g83 ) );
				
				float Mask0G409_g83 = break2097_g83.g;
				float lerpResult1655_g83 = lerp( ( _MaskMapRemapOffset0.y + _MaskMapRemapScale0.y ) , Mask0G409_g83 , _LayerHasMask0);
				float Mask1G371_g83 = break2193_g83.g;
				float lerpResult1660_g83 = lerp( ( _MaskMapRemapOffset1.y + _MaskMapRemapScale1.y ) , Mask1G371_g83 , _LayerHasMask1);
				float Mask2G358_g83 = break2262_g83.g;
				float lerpResult1663_g83 = lerp( ( _MaskMapRemapOffset2.y + _MaskMapRemapScale2.y ) , Mask2G358_g83 , _LayerHasMask2);
				float Mask3G389_g83 = break2342_g83.g;
				float lerpResult1666_g83 = lerp( ( _MaskMapRemapOffset3.y + _MaskMapRemapScale3.y ) , Mask3G389_g83 , _LayerHasMask3);
				float4 weightedBlendVar602_g83 = Control26_g83;
				float weightedBlend602_g83 = ( weightedBlendVar602_g83.x*saturate( lerpResult1655_g83 ) + weightedBlendVar602_g83.y*saturate( lerpResult1660_g83 ) + weightedBlendVar602_g83.z*saturate( lerpResult1663_g83 ) + weightedBlendVar602_g83.w*saturate( lerpResult1666_g83 ) );
				float Mask4G748_g83 = break2413_g83.g;
				float lerpResult1669_g83 = lerp( ( _MaskMapRemapOffset4.y + _MaskMapRemapScale4.x ) , Mask4G748_g83 , _LayerHasMask4);
				float Mask5G742_g83 = break2472_g83.g;
				float lerpResult1672_g83 = lerp( ( _MaskMapRemapOffset5.y + _MaskMapRemapScale5.y ) , Mask5G742_g83 , _LayerHasMask5);
				float Mask6G756_g83 = break2531_g83.g;
				float lerpResult1675_g83 = lerp( ( _MaskMapRemapOffset6.y + _MaskMapRemapScale6.y ) , Mask6G756_g83 , _LayerHasMask6);
				float Mask7G766_g83 = break2590_g83.g;
				float lerpResult1678_g83 = lerp( ( _MaskMapRemapOffset7.y + _MaskMapRemapScale7.y ) , Mask7G766_g83 , _LayerHasMask7);
				float4 weightedBlendVar799_g83 = Control1922_g83;
				float weightedBlend799_g83 = ( weightedBlendVar799_g83.x*saturate( lerpResult1669_g83 ) + weightedBlendVar799_g83.y*saturate( lerpResult1672_g83 ) + weightedBlendVar799_g83.z*saturate( lerpResult1675_g83 ) + weightedBlendVar799_g83.w*saturate( lerpResult1678_g83 ) );
				float Occlusion1868_g83 = saturate( ( weightedBlend602_g83 + weightedBlend799_g83 ) );
				
				float4 tex2DNode451_g83 = SAMPLE_TEXTURE2D( _TerrainHolesTexture, sampler_TerrainHolesTexture, uv_TerrainHolesTexture451_g83 );
				

				float3 BaseColor = diffuseColor1792_g83;
				float3 Normal = lerpResult1222_g83;
				float3 Specular = ( specularColor1792_g83 + (( weightedBlend1777_g83 + weightedBlend1773_g83 )).xyz );
				float Metallic = 0;
				float Smoothness = ( weightedBlend547_g83 + weightedBlend826_g83 );
				float Occlusion = Occlusion1868_g83;
				float3 Emission = 0;
				float Alpha = ( 0.5 + 1E-37 );
				#if defined( _ALPHATEST_ON )
					float AlphaClipThreshold = ( 1.0 - tex2DNode451_g83 ).r;
					float AlphaClipThresholdShadow = 0.5;
				#endif
				float3 BakedGI = 0;
				float3 RefractionColor = 1;
				float RefractionIndex = 1;
				float3 Transmission = 1;
				float3 Translucency = 1;

				#if defined( ASE_DEPTH_WRITE_ON )
					input.positionCS.z = input.positionCS.z;
				#endif

				#ifdef _CLEARCOAT
					float CoatMask = 0;
					float CoatSmoothness = 0;
				#endif

				#if defined( _ALPHATEST_ON )
					AlphaDiscard( Alpha, AlphaClipThreshold );
				#endif

				#if defined(MAIN_LIGHT_CALCULATE_SHADOWS) && defined(ASE_CHANGES_WORLD_POS)
					ShadowCoord = TransformWorldToShadowCoord( PositionWS );
				#endif

				InputData inputData = (InputData)0;
				inputData.positionWS = PositionWS;
				inputData.positionCS = input.positionCS;
				inputData.normalizedScreenSpaceUV = ScreenPosNorm.xy;
				inputData.viewDirectionWS = ViewDirWS;
				inputData.shadowCoord = ShadowCoord;

				#ifdef _NORMALMAP
						#if _NORMAL_DROPOFF_TS
							inputData.normalWS = TransformTangentToWorld(Normal, half3x3(TangentWS, BitangentWS, NormalWS));
						#elif _NORMAL_DROPOFF_OS
							inputData.normalWS = TransformObjectToWorldNormal(Normal);
						#elif _NORMAL_DROPOFF_WS
							inputData.normalWS = Normal;
						#endif
					inputData.normalWS = NormalizeNormalPerPixel(inputData.normalWS);
				#else
					inputData.normalWS = NormalWS;
				#endif

				#ifdef ASE_FOG
					inputData.fogCoord = InitializeInputDataFog(float4(inputData.positionWS, 1.0), input.fogFactorAndVertexLight.x);
				#endif
				#ifdef _ADDITIONAL_LIGHTS_VERTEX
					inputData.vertexLighting = input.fogFactorAndVertexLight.yzw;
				#endif

				#if defined( ENABLE_TERRAIN_PERPIXEL_NORMAL )
					float3 SH = SampleSH(inputData.normalWS.xyz);
				#else
					float3 SH = input.lightmapUVOrVertexSH.xyz;
				#endif

				#if defined(_SCREEN_SPACE_IRRADIANCE)
					inputData.bakedGI = SAMPLE_GI(_ScreenSpaceIrradiance, input.positionCS.xy);
				#elif defined(DYNAMICLIGHTMAP_ON)
					inputData.bakedGI = SAMPLE_GI(input.lightmapUVOrVertexSH.xy, input.dynamicLightmapUV.xy, SH, inputData.normalWS);
					inputData.shadowMask = SAMPLE_SHADOWMASK(input.lightmapUVOrVertexSH.xy);
				#elif !defined(LIGHTMAP_ON) && (defined(PROBE_VOLUMES_L1) || defined(PROBE_VOLUMES_L2))
					inputData.bakedGI = SAMPLE_GI( SH, GetAbsolutePositionWS(inputData.positionWS),
						inputData.normalWS,
						inputData.viewDirectionWS,
						input.positionCS.xy,
						input.probeOcclusion,
						inputData.shadowMask );
				#else
					inputData.bakedGI = SAMPLE_GI(input.lightmapUVOrVertexSH.xy, SH, inputData.normalWS);
					inputData.shadowMask = SAMPLE_SHADOWMASK(input.lightmapUVOrVertexSH.xy);
				#endif

				#ifdef ASE_BAKEDGI
					inputData.bakedGI = BakedGI;
				#endif

				#if defined(DEBUG_DISPLAY)
					#if defined(DYNAMICLIGHTMAP_ON)
						inputData.dynamicLightmapUV = input.dynamicLightmapUV.xy;
					#endif
					#if defined(LIGHTMAP_ON)
						inputData.staticLightmapUV = input.lightmapUVOrVertexSH.xy;
					#else
						inputData.vertexSH = SH;
					#endif
					#if defined(USE_APV_PROBE_OCCLUSION)
						inputData.probeOcclusion = input.probeOcclusion;
					#endif
				#endif

				SurfaceData surfaceData;
				surfaceData.albedo              = BaseColor;
				surfaceData.metallic            = saturate(Metallic);
				surfaceData.specular            = Specular;
				surfaceData.smoothness          = saturate(Smoothness),
				surfaceData.occlusion           = Occlusion,
				surfaceData.emission            = Emission,
				surfaceData.alpha               = saturate(Alpha);
				surfaceData.normalTS            = Normal;
				surfaceData.clearCoatMask       = 0;
				surfaceData.clearCoatSmoothness = 1;

				#ifdef _CLEARCOAT
					surfaceData.clearCoatMask       = saturate(CoatMask);
					surfaceData.clearCoatSmoothness = saturate(CoatSmoothness);
				#endif

				#if defined(_DBUFFER)
					ApplyDecalToSurfaceData(input.positionCS, surfaceData, inputData);
				#endif

				#ifdef ASE_LIGHTING_SIMPLE
					half4 color = UniversalFragmentBlinnPhong( inputData, surfaceData);
				#else
					half4 color = UniversalFragmentPBR( inputData, surfaceData);
				#endif

				#ifdef ASE_TRANSMISSION
				{
					float shadow = _TransmissionShadow;

					#define SUM_LIGHT_TRANSMISSION(Light)\
						float3 atten = Light.color * Light.distanceAttenuation;\
						atten = lerp( atten, atten * Light.shadowAttenuation, shadow );\
						half3 transmission = max( 0, -dot( inputData.normalWS, Light.direction ) ) * atten * Transmission;\
						color.rgb += BaseColor * transmission;

					SUM_LIGHT_TRANSMISSION( GetMainLight( inputData.shadowCoord ) );

					#if defined(_ADDITIONAL_LIGHTS)
						uint meshRenderingLayers = GetMeshRenderingLayer();
						uint pixelLightCount = GetAdditionalLightsCount();
						#if USE_CLUSTER_LIGHT_LOOP
							[loop] for (uint lightIndex = 0; lightIndex < min(URP_FP_DIRECTIONAL_LIGHTS_COUNT, MAX_VISIBLE_LIGHTS); lightIndex++)
							{
								CLUSTER_LIGHT_LOOP_SUBTRACTIVE_LIGHT_CHECK

								Light light = GetAdditionalLight(lightIndex, inputData.positionWS, inputData.shadowMask);
								#ifdef _LIGHT_LAYERS
								if (IsMatchingLightLayer(light.layerMask, meshRenderingLayers))
								#endif
								{
									SUM_LIGHT_TRANSMISSION( light );
								}
							}
						#endif
						LIGHT_LOOP_BEGIN( pixelLightCount )
							Light light = GetAdditionalLight(lightIndex, inputData.positionWS, inputData.shadowMask);
							#ifdef _LIGHT_LAYERS
							if (IsMatchingLightLayer(light.layerMask, meshRenderingLayers))
							#endif
							{
								SUM_LIGHT_TRANSMISSION( light );
							}
						LIGHT_LOOP_END
					#endif
				}
				#endif

				#ifdef ASE_TRANSLUCENCY
				{
					float shadow = _TransShadow;
					float normal = _TransNormal;
					float scattering = _TransScattering;
					float direct = _TransDirect;
					float ambient = _TransAmbient;
					float strength = _TransStrength;

					#define SUM_LIGHT_TRANSLUCENCY(Light)\
						float3 atten = Light.color * Light.distanceAttenuation;\
						atten = lerp( atten, atten * Light.shadowAttenuation, shadow );\
						half3 lightDir = Light.direction + inputData.normalWS * normal;\
						half VdotL = pow( saturate( dot( inputData.viewDirectionWS, -lightDir ) ), scattering );\
						half3 translucency = atten * ( VdotL * direct + inputData.bakedGI * ambient ) * Translucency;\
						color.rgb += BaseColor * translucency * strength;

					SUM_LIGHT_TRANSLUCENCY( GetMainLight( inputData.shadowCoord ) );

					#if defined(_ADDITIONAL_LIGHTS)
						uint meshRenderingLayers = GetMeshRenderingLayer();
						uint pixelLightCount = GetAdditionalLightsCount();
						#if USE_CLUSTER_LIGHT_LOOP
							[loop] for (uint lightIndex = 0; lightIndex < min(URP_FP_DIRECTIONAL_LIGHTS_COUNT, MAX_VISIBLE_LIGHTS); lightIndex++)
							{
								CLUSTER_LIGHT_LOOP_SUBTRACTIVE_LIGHT_CHECK

								Light light = GetAdditionalLight(lightIndex, inputData.positionWS, inputData.shadowMask);
								#ifdef _LIGHT_LAYERS
								if (IsMatchingLightLayer(light.layerMask, meshRenderingLayers))
								#endif
								{
									SUM_LIGHT_TRANSLUCENCY( light );
								}
							}
						#endif
						LIGHT_LOOP_BEGIN( pixelLightCount )
							Light light = GetAdditionalLight(lightIndex, inputData.positionWS, inputData.shadowMask);
							#ifdef _LIGHT_LAYERS
							if (IsMatchingLightLayer(light.layerMask, meshRenderingLayers))
							#endif
							{
								SUM_LIGHT_TRANSLUCENCY( light );
							}
						LIGHT_LOOP_END
					#endif
				}
				#endif

				#ifdef ASE_REFRACTION
					float4 projScreenPos = ScreenPos / ScreenPos.w;
					float3 refractionOffset = ( RefractionIndex - 1.0 ) * mul( UNITY_MATRIX_V, float4( NormalWS,0 ) ).xyz * ( 1.0 - dot( NormalWS, ViewDirWS ) );
					projScreenPos.xy += refractionOffset.xy;
					float3 refraction = SHADERGRAPH_SAMPLE_SCENE_COLOR( projScreenPos.xy ) * RefractionColor;
					color.rgb = lerp( refraction, color.rgb, color.a );
					color.a = 1;
				#endif

				#ifdef ASE_FINAL_COLOR_ALPHA_MULTIPLY
					color.rgb *= color.a;
				#endif

				#ifdef ASE_FOG
					#ifdef TERRAIN_SPLAT_ADDPASS
						color.rgb = MixFogColor(color.rgb, half3(0,0,0), inputData.fogCoord);
					#else
						color.rgb = MixFog(color.rgb, inputData.fogCoord);
					#endif
				#endif

				#if defined( ASE_DEPTH_WRITE_ON )
					outputDepth = input.positionCS.z;
				#endif

				#ifdef _WRITE_RENDERING_LAYERS
					outRenderingLayers = EncodeMeshRenderingLayer();
				#endif

				#if defined( ASE_OPAQUE_KEEP_ALPHA )
					return half4( color.rgb, color.a );
				#else
					return half4( color.rgb, OutputAlpha( color.a, isTransparent ) );
				#endif
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "ShadowCaster"
			Tags { "LightMode"="ShadowCaster" }

			ZWrite On
			ZTest LEqual
			AlphaToMask Off
			ColorMask 0

			HLSLPROGRAM

			#define _ALPHATEST_ON
			#define _NORMAL_DROPOFF_TS 1
			#define ASE_FOG 1
			#pragma multi_compile_fragment _ DEBUG_DISPLAY
			#define ASE_TERRAIN
			#define _SPECULAR_SETUP 1
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#define _NORMALMAP 1
			#define ASE_VERSION 19907
			#define ASE_SRP_VERSION 170300
			#define ASE_USING_SAMPLING_MACROS 1


			#pragma multi_compile_vertex _ _CASTING_PUNCTUAL_LIGHT_SHADOW

			#pragma vertex vert
			#pragma fragment frag

			#if defined( _SPECULAR_SETUP ) && defined( ASE_LIGHTING_SIMPLE )
				#if defined( _SPECULARHIGHLIGHTS_OFF )
					#undef _SPECULAR_COLOR
				#else
					#define _SPECULAR_COLOR
				#endif
			#endif

			#define SHADERPASS SHADERPASS_SHADOWCASTER

			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#if defined(LOD_FADE_CROSSFADE)
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
            #endif

			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_TEXTURE_COORDINATES0
			#define ASE_INSTANCED_TERRAIN
			#define ASE_NEEDS_VERT_POSITION
			#pragma multi_compile_instancing
			#pragma instancing_options assumeuniformscaling nomatrices nolightprobe nolightmap
			#define TERRAIN_SPLAT_FIRSTPASS 1
			#define _LAYER_COUNT 8
			#pragma shader_feature_local _TERRAIN_8_LAYERS
			#pragma editor_sync_compilation
			#pragma shader_feature_local _NORMALMAP
			#pragma shader_feature_local _MASKMAP


			#if defined(ASE_EARLY_Z_DEPTH_OPTIMIZE) && (SHADER_TARGET >= 45)
				#define ASE_SV_DEPTH SV_DepthLessEqual
				#define ASE_SV_POSITION_QUALIFIERS linear noperspective centroid
			#else
				#define ASE_SV_DEPTH SV_Depth
				#define ASE_SV_POSITION_QUALIFIERS
			#endif

			struct Attributes
			{
				float4 positionOS : POSITION;
				half3 normalOS : NORMAL;
				half4 tangentOS : TANGENT;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct PackedVaryings
			{
				ASE_SV_POSITION_QUALIFIERS float4 positionCS : SV_POSITION;
				float3 positionWS : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _Control_ST;
			float4 _MaskMapRemapScale4;
			float4 _MaskMapRemapOffset4;
			float4 _MaskMapRemapScale3;
			half4 _SnowColor;
			float4 _SnowMainUVs;
			float4 _MaskMapRemapOffset3;
			float4 _MaskMapRemapOffset2;
			float4 _MaskMapRemapScale1;
			float4 _MaskMapRemapOffset1;
			float4 _SnowMapSplat_ST;
			float4 _MaskMapRemapScale0;
			float4 _Specular7;
			float4 _Specular6;
			float4 _Specular5;
			float4 _MaskMapRemapScale7;
			float4 _Specular4;
			float4 _Specular3;
			float4 _Specular2;
			float4 _Specular1;
			float4 _Specular0;
			float4 _MaskMapRemapOffset0;
			float4 _Splat7_ST;
			float4 _MaskMapRemapScale2;
			float4 _MaskMapRemapOffset5;
			float4 _DiffuseRemapScale7;
			float4 _MaskMapRemapScale6;
			float4 _Splat2_ST;
			float4 _DiffuseRemapScale2;
			float4 _DiffuseRemapScale3;
			float4 _Splat3_ST;
			float4 _Splat1_ST;
			float4 _MaskMapRemapOffset6;
			float4 _DiffuseRemapScale1;
			float4 _DiffuseRemapScale4;
			float4 _Control1_ST;
			float4 _Splat0_ST;
			float4 _Splat6_ST;
			float4 _DiffuseRemapScale6;
			float4 _MaskMapRemapOffset7;
			float4 _Splat5_ST;
			float4 _MaskMapRemapScale5;
			float4 _DiffuseRemapScale0;
			float4 _Splat4_ST;
			float4 _DiffuseRemapScale5;
			half _SnowNormalStrength;
			float _LayerHasMask6;
			float _OpacityAsDensity1;
			half _NormalScale7;
			float _Smoothness0;
			float _OpacityAsDensity0;
			float _Smoothness1;
			float _Smoothness2;
			float _OpacityAsDensity5;
			float _Smoothness3;
			float _LayerHasMask4;
			float _LayerHasMask3;
			float _LayerHasMask5;
			float _LayerHasMask2;
			half _NormalScale6;
			float _LayerHasMask1;
			float _LayerHasMask0;
			float _OpacityAsDensity7;
			float _Smoothness7;
			float _OpacityAsDensity6;
			float _Smoothness6;
			float _Smoothness5;
			float _OpacityAsDensity4;
			float _Smoothness4;
			float _OpacityAsDensity3;
			float _OpacityAsDensity2;
			half _NormalScale5;
			float _Metallic2;
			half _NormalScale3;
			half _SnowSplatGBlendFalloff;
			half _SnowSplatGBlendFactor;
			half _SnowSplatREnable;
			half _SnowSplatRMax;
			half _SnowSplatRMin;
			half _SnowSplatRBlendStrength;
			half _SnowSplatRBlendFalloff;
			half _SnowSplatRBlendFactor;
			half _SnowBrightness;
			half _SnowSaturation;
			half _SnowSplatGBlendStrength;
			half _SnowSplatASplatBias;
			half _SnowSplatGSplatBias;
			half _SnowSplatRSplatBias;
			half _Splat7Brightness;
			half _Splat6Brightness;
			half _Splat5Brightness;
			half _Splat4Brightness;
			half _Splat3Brightness;
			half _Splat2Brightness;
			half _Splat1Brightness;
			half _Splat0Brightness;
			half _SnowSplatBSplatBias;
			half _SnowSplatGMin;
			half _SnowSplatGMax;
			half _SnowSplatGEnable;
			half _NormalScale2;
			half _NormalScale1;
			half _NormalScale0;
			float _Metallic7;
			float _Metallic6;
			float _Metallic5;
			float _Metallic4;
			float _Metallic3;
			float _Metallic1;
			float _Metallic0;
			half _SnowEnable;
			half _SnowSplatAEnable;
			half _SnowSplatAMax;
			half _SnowSplatAMin;
			half _SnowSplatABlendStrength;
			half _SnowSplatABlendFalloff;
			half _SnowSplatABlendFactor;
			half _SnowSplatBEnable;
			half _SnowSplatBMax;
			half _SnowSplatBMin;
			half _SnowSplatBBlendStrength;
			half _SnowSplatBBlendFalloff;
			half _SnowSplatBBlendFactor;
			half _NormalScale4;
			float _LayerHasMask7;
			float _AlphaClip;
			float _Cutoff;
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
			CBUFFER_END

			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			TEXTURE2D(_TerrainHolesTexture);
			SAMPLER(sampler_TerrainHolesTexture);
			#ifdef UNITY_INSTANCING_ENABLED//ASE Terrain Instancing
				TEXTURE2D(_TerrainHeightmapTexture);//ASE Terrain Instancing
				TEXTURE2D( _TerrainNormalmapTexture);//ASE Terrain Instancing
				SAMPLER(sampler_TerrainNormalmapTexture);//ASE Terrain Instancing
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


			float3 _LightDirection;
			float3 _LightPosition;

			void TerrainApplyMeshModification( inout float3 position, inout half3 normal, inout float4 texcoord )
			{
			#ifdef UNITY_INSTANCING_ENABLED
				float2 patchVertex = position.xy;
				float4 instanceData = UNITY_ACCESS_INSTANCED_PROP( Terrain, _TerrainPatchInstanceData );
				float2 sampleCoords = ( patchVertex.xy + instanceData.xy ) * instanceData.z;
				float height = UnpackHeightmap( _TerrainHeightmapTexture.Load( int3( sampleCoords, 0 ) ) );
				position.xz = sampleCoords* _TerrainHeightmapScale.xz;
				position.y = height* _TerrainHeightmapScale.y;
				#ifdef ENABLE_TERRAIN_PERPIXEL_NORMAL
					normal = float3(0, 1, 0);
				#else
					normal = _TerrainNormalmapTexture.Load(int3(sampleCoords, 0)).rgb* 2 - 1;
				#endif
				texcoord.xy = sampleCoords* _TerrainHeightmapRecipSize.zw;
			#endif
			}
			

			PackedVaryings VertexFunction( Attributes input )
			{
				PackedVaryings output;
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_TRANSFER_INSTANCE_ID(input, output);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( output );

				#if defined( ASE_INSTANCED_TERRAIN ) && !defined( ASE_TESSELLATION )
					TerrainApplyMeshModification( input.positionOS.xyz, input.normalOS, input.ase_texcoord );
				#endif
				
				float4 appendResult993_g83 = (float4(cross( input.normalOS , float3( 0, 0, 1 ) ) , -1.0));
				
				output.ase_texcoord1.xy = input.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				output.ase_texcoord1.zw = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = input.positionOS.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					input.positionOS.xyz = vertexValue;
				#else
					input.positionOS.xyz += vertexValue;
				#endif

				input.normalOS = input.normalOS;
				input.tangentOS = appendResult993_g83;

				float3 positionWS = TransformObjectToWorld( input.positionOS.xyz );
				float3 normalWS = TransformObjectToWorldDir(input.normalOS);

				#if _CASTING_PUNCTUAL_LIGHT_SHADOW
					float3 lightDirectionWS = normalize(_LightPosition - positionWS);
				#else
					float3 lightDirectionWS = _LightDirection;
				#endif

				float4 positionCS = TransformWorldToHClip(ApplyShadowBias(positionWS, normalWS, lightDirectionWS));

				//code for UNITY_REVERSED_Z is moved into Shadows.hlsl from 6000.0.22 and or higher
				positionCS = ApplyShadowClamping(positionCS);

				output.positionCS = positionCS;
				output.positionWS = positionWS;
				return output;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 positionOS : INTERNALTESSPOS;
				half3 normalOS : NORMAL;
				half4 tangentOS : TANGENT;
				float4 ase_texcoord : TEXCOORD0;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( Attributes input )
			{
				VertexControl output;
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_TRANSFER_INSTANCE_ID(input, output);
				output.positionOS = input.positionOS;
				output.normalOS = input.normalOS;
				output.tangentOS = input.tangentOS;
				output.ase_texcoord = input.ase_texcoord;
				#if defined( ASE_INSTANCED_TERRAIN )
					TerrainApplyMeshModification( output.positionOS.xyz, output.normalOS, output.ase_texcoord );
				#endif
				
				return output;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> input)
			{
				TessellationFactors output;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(input[0].positionOS, input[1].positionOS, input[2].positionOS, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(input[0].positionOS, input[1].positionOS, input[2].positionOS, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(input[0].positionOS, input[1].positionOS, input[2].positionOS, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				output.edge[0] = tf.x; output.edge[1] = tf.y; output.edge[2] = tf.z; output.inside = tf.w;
				return output;
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
			PackedVaryings DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				Attributes output = (Attributes) 0;
				output.positionOS = patch[0].positionOS * bary.x + patch[1].positionOS * bary.y + patch[2].positionOS * bary.z;
				output.normalOS = patch[0].normalOS * bary.x + patch[1].normalOS * bary.y + patch[2].normalOS * bary.z;
				output.tangentOS = patch[0].tangentOS * bary.x + patch[1].tangentOS * bary.y + patch[2].tangentOS * bary.z;
				output.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = output.positionOS.xyz - patch[i].normalOS * (dot(output.positionOS.xyz, patch[i].normalOS) - dot(patch[i].positionOS.xyz, patch[i].normalOS));
				float phongStrength = _TessPhongStrength;
				output.positionOS.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * output.positionOS.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], output);
				return VertexFunction(output);
			}
			#else
			PackedVaryings vert ( Attributes input )
			{
				return VertexFunction( input );
			}
			#endif

			half4 frag(	PackedVaryings input
						#if defined( ASE_DEPTH_WRITE_ON )
						,out float outputDepth : ASE_SV_DEPTH
						#endif
						 ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( input );
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( input );

				#if defined(MAIN_LIGHT_CALCULATE_SHADOWS) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					float4 shadowCoord = TransformWorldToShadowCoord(input.positionWS);
				#else
					float4 shadowCoord = float4(0, 0, 0, 0);
				#endif

				float3 PositionWS = input.positionWS;
				float3 PositionRWS = GetCameraRelativePositionWS( input.positionWS );
				float4 ShadowCoord = shadowCoord;
				float4 ScreenPosNorm = float4( GetNormalizedScreenSpaceUV( input.positionCS ), input.positionCS.zw );
				float4 ClipPos = ComputeClipSpacePosition( ScreenPosNorm.xy, input.positionCS.z ) * input.positionCS.w;
				float4 ScreenPos = ComputeScreenPos( ClipPos );

				float2 uv_TerrainHolesTexture451_g83 = input.ase_texcoord1.xy;
				float4 tex2DNode451_g83 = SAMPLE_TEXTURE2D( _TerrainHolesTexture, sampler_TerrainHolesTexture, uv_TerrainHolesTexture451_g83 );
				

				float Alpha = ( 0.5 + 1E-37 );
				#if defined( _ALPHATEST_ON )
					float AlphaClipThreshold = ( 1.0 - tex2DNode451_g83 ).r;
					float AlphaClipThresholdShadow = 0.5;
				#endif

				#if defined( ASE_DEPTH_WRITE_ON )
					input.positionCS.z = input.positionCS.z;
				#endif

				#if defined( _ALPHATEST_ON )
					#if defined( _ALPHATEST_SHADOW_ON )
						AlphaDiscard( Alpha, AlphaClipThresholdShadow );
					#else
						AlphaDiscard( Alpha, AlphaClipThreshold );
					#endif
				#endif

				#if defined(LOD_FADE_CROSSFADE)
					LODFadeCrossFade( input.positionCS );
				#endif

				#if defined( ASE_DEPTH_WRITE_ON )
					outputDepth = input.positionCS.z;
				#endif

				return 0;
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "DepthOnly"
			Tags { "LightMode"="DepthOnly" }

			ZWrite On
			ColorMask R
			AlphaToMask Off

			HLSLPROGRAM

			#define _ALPHATEST_ON
			#define _NORMAL_DROPOFF_TS 1
			#define ASE_FOG 1
			#pragma multi_compile_fragment _ DEBUG_DISPLAY
			#define ASE_TERRAIN
			#define _SPECULAR_SETUP 1
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#define _NORMALMAP 1
			#define ASE_VERSION 19907
			#define ASE_SRP_VERSION 170300
			#define ASE_USING_SAMPLING_MACROS 1


			#pragma vertex vert
			#pragma fragment frag

			#if defined( _SPECULAR_SETUP ) && defined( ASE_LIGHTING_SIMPLE )
				#if defined( _SPECULARHIGHLIGHTS_OFF )
					#undef _SPECULAR_COLOR
				#else
					#define _SPECULAR_COLOR
				#endif
			#endif

			#define SHADERPASS SHADERPASS_DEPTHONLY

			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#if defined(LOD_FADE_CROSSFADE)
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
            #endif

			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_TEXTURE_COORDINATES0
			#define ASE_INSTANCED_TERRAIN
			#define ASE_NEEDS_VERT_POSITION
			#pragma multi_compile_instancing
			#pragma instancing_options assumeuniformscaling nomatrices nolightprobe nolightmap
			#define TERRAIN_SPLAT_FIRSTPASS 1
			#define _LAYER_COUNT 8
			#pragma shader_feature_local _TERRAIN_8_LAYERS
			#pragma editor_sync_compilation
			#pragma shader_feature_local _NORMALMAP
			#pragma shader_feature_local _MASKMAP


			#if defined(ASE_EARLY_Z_DEPTH_OPTIMIZE) && (SHADER_TARGET >= 45)
				#define ASE_SV_DEPTH SV_DepthLessEqual
				#define ASE_SV_POSITION_QUALIFIERS linear noperspective centroid
			#else
				#define ASE_SV_DEPTH SV_Depth
				#define ASE_SV_POSITION_QUALIFIERS
			#endif

			struct Attributes
			{
				float4 positionOS : POSITION;
				half3 normalOS : NORMAL;
				half4 tangentOS : TANGENT;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct PackedVaryings
			{
				ASE_SV_POSITION_QUALIFIERS float4 positionCS : SV_POSITION;
				float3 positionWS : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _Control_ST;
			float4 _MaskMapRemapScale4;
			float4 _MaskMapRemapOffset4;
			float4 _MaskMapRemapScale3;
			half4 _SnowColor;
			float4 _SnowMainUVs;
			float4 _MaskMapRemapOffset3;
			float4 _MaskMapRemapOffset2;
			float4 _MaskMapRemapScale1;
			float4 _MaskMapRemapOffset1;
			float4 _SnowMapSplat_ST;
			float4 _MaskMapRemapScale0;
			float4 _Specular7;
			float4 _Specular6;
			float4 _Specular5;
			float4 _MaskMapRemapScale7;
			float4 _Specular4;
			float4 _Specular3;
			float4 _Specular2;
			float4 _Specular1;
			float4 _Specular0;
			float4 _MaskMapRemapOffset0;
			float4 _Splat7_ST;
			float4 _MaskMapRemapScale2;
			float4 _MaskMapRemapOffset5;
			float4 _DiffuseRemapScale7;
			float4 _MaskMapRemapScale6;
			float4 _Splat2_ST;
			float4 _DiffuseRemapScale2;
			float4 _DiffuseRemapScale3;
			float4 _Splat3_ST;
			float4 _Splat1_ST;
			float4 _MaskMapRemapOffset6;
			float4 _DiffuseRemapScale1;
			float4 _DiffuseRemapScale4;
			float4 _Control1_ST;
			float4 _Splat0_ST;
			float4 _Splat6_ST;
			float4 _DiffuseRemapScale6;
			float4 _MaskMapRemapOffset7;
			float4 _Splat5_ST;
			float4 _MaskMapRemapScale5;
			float4 _DiffuseRemapScale0;
			float4 _Splat4_ST;
			float4 _DiffuseRemapScale5;
			half _SnowNormalStrength;
			float _LayerHasMask6;
			float _OpacityAsDensity1;
			half _NormalScale7;
			float _Smoothness0;
			float _OpacityAsDensity0;
			float _Smoothness1;
			float _Smoothness2;
			float _OpacityAsDensity5;
			float _Smoothness3;
			float _LayerHasMask4;
			float _LayerHasMask3;
			float _LayerHasMask5;
			float _LayerHasMask2;
			half _NormalScale6;
			float _LayerHasMask1;
			float _LayerHasMask0;
			float _OpacityAsDensity7;
			float _Smoothness7;
			float _OpacityAsDensity6;
			float _Smoothness6;
			float _Smoothness5;
			float _OpacityAsDensity4;
			float _Smoothness4;
			float _OpacityAsDensity3;
			float _OpacityAsDensity2;
			half _NormalScale5;
			float _Metallic2;
			half _NormalScale3;
			half _SnowSplatGBlendFalloff;
			half _SnowSplatGBlendFactor;
			half _SnowSplatREnable;
			half _SnowSplatRMax;
			half _SnowSplatRMin;
			half _SnowSplatRBlendStrength;
			half _SnowSplatRBlendFalloff;
			half _SnowSplatRBlendFactor;
			half _SnowBrightness;
			half _SnowSaturation;
			half _SnowSplatGBlendStrength;
			half _SnowSplatASplatBias;
			half _SnowSplatGSplatBias;
			half _SnowSplatRSplatBias;
			half _Splat7Brightness;
			half _Splat6Brightness;
			half _Splat5Brightness;
			half _Splat4Brightness;
			half _Splat3Brightness;
			half _Splat2Brightness;
			half _Splat1Brightness;
			half _Splat0Brightness;
			half _SnowSplatBSplatBias;
			half _SnowSplatGMin;
			half _SnowSplatGMax;
			half _SnowSplatGEnable;
			half _NormalScale2;
			half _NormalScale1;
			half _NormalScale0;
			float _Metallic7;
			float _Metallic6;
			float _Metallic5;
			float _Metallic4;
			float _Metallic3;
			float _Metallic1;
			float _Metallic0;
			half _SnowEnable;
			half _SnowSplatAEnable;
			half _SnowSplatAMax;
			half _SnowSplatAMin;
			half _SnowSplatABlendStrength;
			half _SnowSplatABlendFalloff;
			half _SnowSplatABlendFactor;
			half _SnowSplatBEnable;
			half _SnowSplatBMax;
			half _SnowSplatBMin;
			half _SnowSplatBBlendStrength;
			half _SnowSplatBBlendFalloff;
			half _SnowSplatBBlendFactor;
			half _NormalScale4;
			float _LayerHasMask7;
			float _AlphaClip;
			float _Cutoff;
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
			CBUFFER_END

			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			TEXTURE2D(_TerrainHolesTexture);
			SAMPLER(sampler_TerrainHolesTexture);
			#ifdef UNITY_INSTANCING_ENABLED//ASE Terrain Instancing
				TEXTURE2D(_TerrainHeightmapTexture);//ASE Terrain Instancing
				TEXTURE2D( _TerrainNormalmapTexture);//ASE Terrain Instancing
				SAMPLER(sampler_TerrainNormalmapTexture);//ASE Terrain Instancing
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
				float2 sampleCoords = ( patchVertex.xy + instanceData.xy ) * instanceData.z;
				float height = UnpackHeightmap( _TerrainHeightmapTexture.Load( int3( sampleCoords, 0 ) ) );
				position.xz = sampleCoords* _TerrainHeightmapScale.xz;
				position.y = height* _TerrainHeightmapScale.y;
				#ifdef ENABLE_TERRAIN_PERPIXEL_NORMAL
					normal = float3(0, 1, 0);
				#else
					normal = _TerrainNormalmapTexture.Load(int3(sampleCoords, 0)).rgb* 2 - 1;
				#endif
				texcoord.xy = sampleCoords* _TerrainHeightmapRecipSize.zw;
			#endif
			}
			

			PackedVaryings VertexFunction( Attributes input  )
			{
				PackedVaryings output = (PackedVaryings)0;
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_TRANSFER_INSTANCE_ID(input, output);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(output);

				#if defined( ASE_INSTANCED_TERRAIN ) && !defined( ASE_TESSELLATION )
					TerrainApplyMeshModification( input.positionOS.xyz, input.normalOS, input.ase_texcoord );
				#endif
				
				float4 appendResult993_g83 = (float4(cross( input.normalOS , float3( 0, 0, 1 ) ) , -1.0));
				
				output.ase_texcoord1.xy = input.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				output.ase_texcoord1.zw = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = input.positionOS.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = defaultVertexValue;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					input.positionOS.xyz = vertexValue;
				#else
					input.positionOS.xyz += vertexValue;
				#endif

				input.normalOS = input.normalOS;
				input.tangentOS = appendResult993_g83;

				VertexPositionInputs vertexInput = GetVertexPositionInputs( input.positionOS.xyz );

				output.positionCS = vertexInput.positionCS;
				output.positionWS = vertexInput.positionWS;
				return output;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 positionOS : INTERNALTESSPOS;
				half3 normalOS : NORMAL;
				half4 tangentOS : TANGENT;
				float4 ase_texcoord : TEXCOORD0;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( Attributes input )
			{
				VertexControl output;
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_TRANSFER_INSTANCE_ID(input, output);
				output.positionOS = input.positionOS;
				output.normalOS = input.normalOS;
				output.tangentOS = input.tangentOS;
				output.ase_texcoord = input.ase_texcoord;
				#if defined( ASE_INSTANCED_TERRAIN )
					TerrainApplyMeshModification( output.positionOS.xyz, output.normalOS, output.ase_texcoord );
				#endif
				
				return output;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> input)
			{
				TessellationFactors output;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(input[0].positionOS, input[1].positionOS, input[2].positionOS, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(input[0].positionOS, input[1].positionOS, input[2].positionOS, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(input[0].positionOS, input[1].positionOS, input[2].positionOS, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				output.edge[0] = tf.x; output.edge[1] = tf.y; output.edge[2] = tf.z; output.inside = tf.w;
				return output;
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
			PackedVaryings DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				Attributes output = (Attributes) 0;
				output.positionOS = patch[0].positionOS * bary.x + patch[1].positionOS * bary.y + patch[2].positionOS * bary.z;
				output.normalOS = patch[0].normalOS * bary.x + patch[1].normalOS * bary.y + patch[2].normalOS * bary.z;
				output.tangentOS = patch[0].tangentOS * bary.x + patch[1].tangentOS * bary.y + patch[2].tangentOS * bary.z;
				output.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = output.positionOS.xyz - patch[i].normalOS * (dot(output.positionOS.xyz, patch[i].normalOS) - dot(patch[i].positionOS.xyz, patch[i].normalOS));
				float phongStrength = _TessPhongStrength;
				output.positionOS.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * output.positionOS.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], output);
				return VertexFunction(output);
			}
			#else
			PackedVaryings vert ( Attributes input )
			{
				return VertexFunction( input );
			}
			#endif

			half4 frag(	PackedVaryings input
						#if defined( ASE_DEPTH_WRITE_ON )
						,out float outputDepth : ASE_SV_DEPTH
						#endif
						 ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( input );

				#if defined(MAIN_LIGHT_CALCULATE_SHADOWS) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					float4 shadowCoord = TransformWorldToShadowCoord(input.positionWS);
				#else
					float4 shadowCoord = float4(0, 0, 0, 0);
				#endif

				float3 PositionWS = input.positionWS;
				float3 PositionRWS = GetCameraRelativePositionWS( input.positionWS );
				float4 ShadowCoord = shadowCoord;
				float4 ScreenPosNorm = float4( GetNormalizedScreenSpaceUV( input.positionCS ), input.positionCS.zw );
				float4 ClipPos = ComputeClipSpacePosition( ScreenPosNorm.xy, input.positionCS.z ) * input.positionCS.w;
				float4 ScreenPos = ComputeScreenPos( ClipPos );

				float2 uv_TerrainHolesTexture451_g83 = input.ase_texcoord1.xy;
				float4 tex2DNode451_g83 = SAMPLE_TEXTURE2D( _TerrainHolesTexture, sampler_TerrainHolesTexture, uv_TerrainHolesTexture451_g83 );
				

				float Alpha = ( 0.5 + 1E-37 );
				float AlphaClipThreshold = ( 1.0 - tex2DNode451_g83 ).r;

				#if defined( ASE_DEPTH_WRITE_ON )
					input.positionCS.z = input.positionCS.z;
				#endif

				#if defined( _ALPHATEST_ON )
					AlphaDiscard( Alpha, AlphaClipThreshold );
				#endif

				#if defined(LOD_FADE_CROSSFADE)
					LODFadeCrossFade( input.positionCS );
				#endif

				#if defined( ASE_DEPTH_WRITE_ON )
					outputDepth = input.positionCS.z;
				#endif

				return 0;
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "Meta"
			Tags { "LightMode"="Meta" }

			Cull Off

			HLSLPROGRAM
			#define _ALPHATEST_ON
			#define _NORMAL_DROPOFF_TS 1
			#define ASE_FOG 1
			#pragma multi_compile_fragment _ DEBUG_DISPLAY
			#define ASE_TERRAIN
			#define _SPECULAR_SETUP 1
			#define _NORMALMAP 1
			#define ASE_VERSION 19907
			#define ASE_SRP_VERSION 170300
			#define ASE_USING_SAMPLING_MACROS 1

			#pragma shader_feature EDITOR_VISUALIZATION

			#pragma vertex vert
			#pragma fragment frag

			#if defined( _SPECULAR_SETUP ) && defined( ASE_LIGHTING_SIMPLE )
				#if defined( _SPECULARHIGHLIGHTS_OFF )
					#undef _SPECULAR_COLOR
				#else
					#define _SPECULAR_COLOR
				#endif
			#endif

			#define SHADERPASS SHADERPASS_META

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_TEXTURE_COORDINATES0
			#define ASE_NEEDS_VERT_TEXTURE_COORDINATES0
			#define ASE_NEEDS_FRAG_TEXTURE_COORDINATES0
			#define ASE_NEEDS_WORLD_POSITION
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_INSTANCED_TERRAIN
			#define ASE_NEEDS_VERT_POSITION
			#pragma multi_compile_instancing
			#pragma instancing_options assumeuniformscaling nomatrices nolightprobe nolightmap
			#define TERRAIN_SPLAT_FIRSTPASS 1
			#define _LAYER_COUNT 8
			#pragma shader_feature_local _TERRAIN_8_LAYERS
			#pragma editor_sync_compilation
			#pragma shader_feature_local _NORMALMAP
			#pragma shader_feature_local _MASKMAP


			struct Attributes
			{
				float4 positionOS : POSITION;
				half3 normalOS : NORMAL;
				half4 tangentOS : TANGENT;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct PackedVaryings
			{
				float4 positionCS : SV_POSITION;
				float3 positionWS : TEXCOORD0;
				#ifdef EDITOR_VISUALIZATION
					float4 VizUV : TEXCOORD1;
					float4 LightCoord : TEXCOORD2;
				#endif
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_texcoord4 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _Control_ST;
			float4 _MaskMapRemapScale4;
			float4 _MaskMapRemapOffset4;
			float4 _MaskMapRemapScale3;
			half4 _SnowColor;
			float4 _SnowMainUVs;
			float4 _MaskMapRemapOffset3;
			float4 _MaskMapRemapOffset2;
			float4 _MaskMapRemapScale1;
			float4 _MaskMapRemapOffset1;
			float4 _SnowMapSplat_ST;
			float4 _MaskMapRemapScale0;
			float4 _Specular7;
			float4 _Specular6;
			float4 _Specular5;
			float4 _MaskMapRemapScale7;
			float4 _Specular4;
			float4 _Specular3;
			float4 _Specular2;
			float4 _Specular1;
			float4 _Specular0;
			float4 _MaskMapRemapOffset0;
			float4 _Splat7_ST;
			float4 _MaskMapRemapScale2;
			float4 _MaskMapRemapOffset5;
			float4 _DiffuseRemapScale7;
			float4 _MaskMapRemapScale6;
			float4 _Splat2_ST;
			float4 _DiffuseRemapScale2;
			float4 _DiffuseRemapScale3;
			float4 _Splat3_ST;
			float4 _Splat1_ST;
			float4 _MaskMapRemapOffset6;
			float4 _DiffuseRemapScale1;
			float4 _DiffuseRemapScale4;
			float4 _Control1_ST;
			float4 _Splat0_ST;
			float4 _Splat6_ST;
			float4 _DiffuseRemapScale6;
			float4 _MaskMapRemapOffset7;
			float4 _Splat5_ST;
			float4 _MaskMapRemapScale5;
			float4 _DiffuseRemapScale0;
			float4 _Splat4_ST;
			float4 _DiffuseRemapScale5;
			half _SnowNormalStrength;
			float _LayerHasMask6;
			float _OpacityAsDensity1;
			half _NormalScale7;
			float _Smoothness0;
			float _OpacityAsDensity0;
			float _Smoothness1;
			float _Smoothness2;
			float _OpacityAsDensity5;
			float _Smoothness3;
			float _LayerHasMask4;
			float _LayerHasMask3;
			float _LayerHasMask5;
			float _LayerHasMask2;
			half _NormalScale6;
			float _LayerHasMask1;
			float _LayerHasMask0;
			float _OpacityAsDensity7;
			float _Smoothness7;
			float _OpacityAsDensity6;
			float _Smoothness6;
			float _Smoothness5;
			float _OpacityAsDensity4;
			float _Smoothness4;
			float _OpacityAsDensity3;
			float _OpacityAsDensity2;
			half _NormalScale5;
			float _Metallic2;
			half _NormalScale3;
			half _SnowSplatGBlendFalloff;
			half _SnowSplatGBlendFactor;
			half _SnowSplatREnable;
			half _SnowSplatRMax;
			half _SnowSplatRMin;
			half _SnowSplatRBlendStrength;
			half _SnowSplatRBlendFalloff;
			half _SnowSplatRBlendFactor;
			half _SnowBrightness;
			half _SnowSaturation;
			half _SnowSplatGBlendStrength;
			half _SnowSplatASplatBias;
			half _SnowSplatGSplatBias;
			half _SnowSplatRSplatBias;
			half _Splat7Brightness;
			half _Splat6Brightness;
			half _Splat5Brightness;
			half _Splat4Brightness;
			half _Splat3Brightness;
			half _Splat2Brightness;
			half _Splat1Brightness;
			half _Splat0Brightness;
			half _SnowSplatBSplatBias;
			half _SnowSplatGMin;
			half _SnowSplatGMax;
			half _SnowSplatGEnable;
			half _NormalScale2;
			half _NormalScale1;
			half _NormalScale0;
			float _Metallic7;
			float _Metallic6;
			float _Metallic5;
			float _Metallic4;
			float _Metallic3;
			float _Metallic1;
			float _Metallic0;
			half _SnowEnable;
			half _SnowSplatAEnable;
			half _SnowSplatAMax;
			half _SnowSplatAMin;
			half _SnowSplatABlendStrength;
			half _SnowSplatABlendFalloff;
			half _SnowSplatABlendFactor;
			half _SnowSplatBEnable;
			half _SnowSplatBMax;
			half _SnowSplatBMin;
			half _SnowSplatBBlendStrength;
			half _SnowSplatBBlendFalloff;
			half _SnowSplatBBlendFactor;
			half _NormalScale4;
			float _LayerHasMask7;
			float _AlphaClip;
			float _Cutoff;
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
			CBUFFER_END

			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			TEXTURE2D(_Control);
			SAMPLER(sampler_Control);
			TEXTURE2D(_Splat0);
			SAMPLER(sampler_Splat0);
			TEXTURE2D(_Splat1);
			TEXTURE2D(_Splat2);
			TEXTURE2D(_Splat3);
			TEXTURE2D(_Control1);
			SAMPLER(sampler_Control1);
			TEXTURE2D(_Splat4);
			TEXTURE2D(_Splat5);
			TEXTURE2D(_Splat6);
			TEXTURE2D(_Splat7);
			TEXTURE2D(_TerrainHolesTexture);
			SAMPLER(sampler_TerrainHolesTexture);
			TEXTURE2D(_SnowMapSplat);
			SAMPLER(sampler_SnowMapSplat);
			TEXTURE2D(_SnowMapBaseColor);
			SAMPLER(sampler_SnowMapBaseColor);
			TEXTURE2D(_Mask0);
			SAMPLER(sampler_Mask0);
			TEXTURE2D(_Mask1);
			TEXTURE2D(_Mask2);
			TEXTURE2D(_Mask3);
			TEXTURE2D(_Mask4);
			TEXTURE2D(_Mask5);
			TEXTURE2D(_Mask6);
			TEXTURE2D(_Mask7);
			#ifdef UNITY_INSTANCING_ENABLED//ASE Terrain Instancing
				TEXTURE2D(_TerrainHeightmapTexture);//ASE Terrain Instancing
				TEXTURE2D( _TerrainNormalmapTexture);//ASE Terrain Instancing
				SAMPLER(sampler_TerrainNormalmapTexture);//ASE Terrain Instancing
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
				float2 sampleCoords = ( patchVertex.xy + instanceData.xy ) * instanceData.z;
				float height = UnpackHeightmap( _TerrainHeightmapTexture.Load( int3( sampleCoords, 0 ) ) );
				position.xz = sampleCoords* _TerrainHeightmapScale.xz;
				position.y = height* _TerrainHeightmapScale.y;
				#ifdef ENABLE_TERRAIN_PERPIXEL_NORMAL
					normal = float3(0, 1, 0);
				#else
					normal = _TerrainNormalmapTexture.Load(int3(sampleCoords, 0)).rgb* 2 - 1;
				#endif
				texcoord.xy = sampleCoords* _TerrainHeightmapRecipSize.zw;
			#endif
			}
			

			PackedVaryings VertexFunction( Attributes input  )
			{
				PackedVaryings output = (PackedVaryings)0;
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_TRANSFER_INSTANCE_ID(input, output);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(output);

				#if defined( ASE_INSTANCED_TERRAIN ) && !defined( ASE_TESSELLATION )
					TerrainApplyMeshModification( input.positionOS.xyz, input.normalOS, input.texcoord );
				#endif
				
				float4 appendResult993_g83 = (float4(cross( input.normalOS , float3( 0, 0, 1 ) ) , -1.0));
				
				float2 TecCoord01294_g83 = input.texcoord.xy;
				float2 break291_g83 = _Control_ST.zw;
				float2 appendResult293_g83 = (float2(( break291_g83.x + 0.001 ) , ( break291_g83.y + 0.0001 )));
				float2 vertexToFrag286_g83 = ( ( TecCoord01294_g83 * _Control_ST.xy ) + appendResult293_g83 );
				output.ase_texcoord3.xy = vertexToFrag286_g83;
				float2 break1393_g83 = _Control1_ST.zw;
				float2 appendResult1382_g83 = (float2(( break1393_g83.x + 0.001 ) , ( break1393_g83.y + 0.0001 )));
				float2 vertexToFrag1395_g83 = ( ( TecCoord01294_g83 * _Control1_ST.xy ) + appendResult1382_g83 );
				output.ase_texcoord4.xy = vertexToFrag1395_g83;
				float2 vertexToFrag1085_g83 = ( ( TecCoord01294_g83 * (_SnowMainUVs).xy ) + (_SnowMainUVs).zw );
				output.ase_texcoord4.zw = vertexToFrag1085_g83;
				
				output.ase_texcoord3.zw = input.texcoord.xy;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = input.positionOS.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = defaultVertexValue;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					input.positionOS.xyz = vertexValue;
				#else
					input.positionOS.xyz += vertexValue;
				#endif

				input.normalOS = input.normalOS;
				input.tangentOS = appendResult993_g83;

				#ifdef EDITOR_VISUALIZATION
					float2 VizUV = 0;
					float4 LightCoord = 0;
					UnityEditorVizData(input.positionOS.xyz, input.texcoord.xy, input.texcoord1.xy, input.texcoord2.xy, VizUV, LightCoord);
					output.VizUV = float4(VizUV, 0, 0);
					output.LightCoord = LightCoord;
				#endif

				output.positionCS = MetaVertexPosition( input.positionOS, input.texcoord1.xy, input.texcoord1.xy, unity_LightmapST, unity_DynamicLightmapST );
				output.positionWS = TransformObjectToWorld( input.positionOS.xyz );
				return output;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 positionOS : INTERNALTESSPOS;
				half3 normalOS : NORMAL;
				half4 tangentOS : TANGENT;
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

			VertexControl vert ( Attributes input )
			{
				VertexControl output;
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_TRANSFER_INSTANCE_ID(input, output);
				output.positionOS = input.positionOS;
				output.normalOS = input.normalOS;
				output.tangentOS = input.tangentOS;
				output.texcoord = input.texcoord;
				output.texcoord1 = input.texcoord1;
				output.texcoord2 = input.texcoord2;
				#if defined( ASE_INSTANCED_TERRAIN )
					TerrainApplyMeshModification( output.positionOS.xyz, output.normalOS, output.texcoord );
				#endif
				
				return output;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> input)
			{
				TessellationFactors output;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(input[0].positionOS, input[1].positionOS, input[2].positionOS, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(input[0].positionOS, input[1].positionOS, input[2].positionOS, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(input[0].positionOS, input[1].positionOS, input[2].positionOS, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				output.edge[0] = tf.x; output.edge[1] = tf.y; output.edge[2] = tf.z; output.inside = tf.w;
				return output;
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
			PackedVaryings DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				Attributes output = (Attributes) 0;
				output.positionOS = patch[0].positionOS * bary.x + patch[1].positionOS * bary.y + patch[2].positionOS * bary.z;
				output.normalOS = patch[0].normalOS * bary.x + patch[1].normalOS * bary.y + patch[2].normalOS * bary.z;
				output.tangentOS = patch[0].tangentOS * bary.x + patch[1].tangentOS * bary.y + patch[2].tangentOS * bary.z;
				output.texcoord = patch[0].texcoord * bary.x + patch[1].texcoord * bary.y + patch[2].texcoord * bary.z;
				output.texcoord1 = patch[0].texcoord1 * bary.x + patch[1].texcoord1 * bary.y + patch[2].texcoord1 * bary.z;
				output.texcoord2 = patch[0].texcoord2 * bary.x + patch[1].texcoord2 * bary.y + patch[2].texcoord2 * bary.z;
				
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = output.positionOS.xyz - patch[i].normalOS * (dot(output.positionOS.xyz, patch[i].normalOS) - dot(patch[i].positionOS.xyz, patch[i].normalOS));
				float phongStrength = _TessPhongStrength;
				output.positionOS.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * output.positionOS.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], output);
				return VertexFunction(output);
			}
			#else
			PackedVaryings vert ( Attributes input )
			{
				return VertexFunction( input );
			}
			#endif

			half4 frag(PackedVaryings input  ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( input );

				#if defined(MAIN_LIGHT_CALCULATE_SHADOWS) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					float4 shadowCoord = TransformWorldToShadowCoord(input.positionWS);
				#else
					float4 shadowCoord = float4(0, 0, 0, 0);
				#endif

				float3 PositionWS = input.positionWS;
				float3 PositionRWS = GetCameraRelativePositionWS( input.positionWS );
				float4 ShadowCoord = shadowCoord;

				float2 vertexToFrag286_g83 = input.ase_texcoord3.xy;
				float4 Control26_g83 = SAMPLE_TEXTURE2D( _Control, sampler_Control, vertexToFrag286_g83 );
				float2 TecCoord01294_g83 = input.ase_texcoord3.zw;
				float3 Splat0342_g83 = (SAMPLE_TEXTURE2D( _Splat0, sampler_Splat0, ( ( TecCoord01294_g83 * _Splat0_ST.xy ) + _Splat0_ST.zw ) )).rgb;
				float3 temp_output_35_0_g83 = ( (_DiffuseRemapScale0).xyz * Splat0342_g83 * _Splat0Brightness );
				float3 Splat1379_g83 = (SAMPLE_TEXTURE2D( _Splat1, sampler_Splat0, ( ( TecCoord01294_g83 * _Splat1_ST.xy ) + _Splat1_ST.zw ) )).rgb;
				float3 temp_output_38_0_g83 = ( (_DiffuseRemapScale1).xyz * Splat1379_g83 * _Splat1Brightness );
				float3 Splat2357_g83 = (SAMPLE_TEXTURE2D( _Splat2, sampler_Splat0, ( ( TecCoord01294_g83 * _Splat2_ST.xy ) + _Splat2_ST.zw ) )).rgb;
				float3 temp_output_41_0_g83 = ( (_DiffuseRemapScale2).xyz * Splat2357_g83 * _Splat2Brightness );
				float3 Splat3390_g83 = (SAMPLE_TEXTURE2D( _Splat3, sampler_Splat0, ( ( TecCoord01294_g83 * _Splat3_ST.xy ) + _Splat3_ST.zw ) )).rgb;
				float3 temp_output_44_0_g83 = ( (_DiffuseRemapScale3).xyz * Splat3390_g83 * _Splat3Brightness );
				float4 weightedBlendVar9_g83 = Control26_g83;
				float3 weightedBlend9_g83 = ( weightedBlendVar9_g83.x*temp_output_35_0_g83 + weightedBlendVar9_g83.y*temp_output_38_0_g83 + weightedBlendVar9_g83.z*temp_output_41_0_g83 + weightedBlendVar9_g83.w*temp_output_44_0_g83 );
				float2 vertexToFrag1395_g83 = input.ase_texcoord4.xy;
				float4 Control1922_g83 = SAMPLE_TEXTURE2D( _Control1, sampler_Control1, vertexToFrag1395_g83 );
				float3 Splat4752_g83 = (SAMPLE_TEXTURE2D( _Splat4, sampler_Splat0, ( ( TecCoord01294_g83 * _Splat4_ST.xy ) + _Splat4_ST.zw ) )).rgb;
				float3 temp_output_900_0_g83 = ( (_DiffuseRemapScale4).xyz * Splat4752_g83 * _Splat4Brightness );
				float3 Splat5743_g83 = (SAMPLE_TEXTURE2D( _Splat5, sampler_Splat0, ( ( TecCoord01294_g83 * _Splat5_ST.xy ) + _Splat5_ST.zw ) )).rgb;
				float3 temp_output_901_0_g83 = ( (_DiffuseRemapScale5).xyz * Splat5743_g83 * _Splat5Brightness );
				float3 Splat6759_g83 = (SAMPLE_TEXTURE2D( _Splat6, sampler_Splat0, ( ( TecCoord01294_g83 * _Splat6_ST.xy ) + _Splat6_ST.zw ) )).rgb;
				float3 temp_output_919_0_g83 = ( (_DiffuseRemapScale6).xyz * Splat6759_g83 * _Splat6Brightness );
				float3 Splat7762_g83 = (SAMPLE_TEXTURE2D( _Splat7, sampler_Splat0, ( ( TecCoord01294_g83 * _Splat7_ST.xy ) + _Splat7_ST.zw ) )).rgb;
				float3 temp_output_921_0_g83 = ( (_DiffuseRemapScale7).xyz * Splat7762_g83 * _Splat7Brightness );
				float4 weightedBlendVar912_g83 = Control1922_g83;
				float3 weightedBlend912_g83 = ( weightedBlendVar912_g83.x*temp_output_900_0_g83 + weightedBlendVar912_g83.y*temp_output_901_0_g83 + weightedBlendVar912_g83.z*temp_output_919_0_g83 + weightedBlendVar912_g83.w*temp_output_921_0_g83 );
				float3 localClipHoles453_g83 = ( ( weightedBlend9_g83 + weightedBlend912_g83 ) );
				float2 uv_TerrainHolesTexture451_g83 = input.ase_texcoord3.zw;
				float Hole453_g83 = SAMPLE_TEXTURE2D( _TerrainHolesTexture, sampler_TerrainHolesTexture, uv_TerrainHolesTexture451_g83 ).r;
				{
				#ifdef _ALPHATEST_ON
				clip(Hole453_g83 == 0.0005f? -1 : 1);
				#endif
				}
				float2 uv_SnowMapSplat = input.ase_texcoord3.zw * _SnowMapSplat_ST.xy + _SnowMapSplat_ST.zw;
				float4 tex2DNode1080_g83 = SAMPLE_TEXTURE2D( _SnowMapSplat, sampler_SnowMapSplat, uv_SnowMapSplat );
				float4 appendResult1076_g83 = (float4(( tex2DNode1080_g83.r * _SnowSplatRSplatBias ) , ( tex2DNode1080_g83.g * _SnowSplatGSplatBias ) , ( tex2DNode1080_g83.b * _SnowSplatBSplatBias ) , ( tex2DNode1080_g83.a * _SnowSplatASplatBias )));
				float4 SnowSplatRGBA1117_g83 = appendResult1076_g83;
				float2 vertexToFrag1085_g83 = input.ase_texcoord4.zw;
				float2 temp_output_1083_0_g83 = ( vertexToFrag1085_g83 * 100.0 );
				float3 temp_output_12_0_g84 = (SAMPLE_TEXTURE2D( _SnowMapBaseColor, sampler_SnowMapBaseColor, temp_output_1083_0_g83 )).rgb;
				float dotResult28_g84 = dot( float3( 0.2126729, 0.7151522, 0.072175 ) , temp_output_12_0_g84 );
				float3 temp_cast_0 = (dotResult28_g84).xxx;
				float temp_output_21_0_g84 = ( 1.0 - _SnowSaturation );
				float3 lerpResult31_g84 = lerp( temp_cast_0 , temp_output_12_0_g84 , temp_output_21_0_g84);
				float3 SnowBaseColor1112_g83 = ( (_SnowColor).rgb * lerpResult31_g84 * _SnowBrightness );
				float4 break1118_g83 = appendResult1076_g83;
				float SnowSplatR1119_g83 = break1118_g83.x;
				float saferPower1027_g83 = abs( max( ( SnowSplatR1119_g83 * ( 1.0 + _SnowSplatRBlendFactor ) ), 0.0 ) );
				float lerpResult1029_g83 = lerp( 0.0 , pow( saferPower1027_g83 , ( 1.0 - _SnowSplatRBlendFalloff ) ) ,  (-1.0 + ( _SnowSplatRBlendStrength - 0.0 ) * ( 0.0 - -1.0 ) / ( 1.0 - 0.0 ) ));
				float3 WorldPosition1123_g83 = PositionWS;
				float smoothstepResult1053_g83 = smoothstep( _SnowSplatRMin , _SnowSplatRMax , WorldPosition1123_g83.y);
				float lerpResult1124_g83 = lerp( 0.0 , saturate( lerpResult1029_g83 ) , smoothstepResult1053_g83);
				float SnowSplatRMask1071_g83 = lerpResult1124_g83;
				float3 lerpResult1159_g83 = lerp( localClipHoles453_g83 , SnowBaseColor1112_g83 , SnowSplatRMask1071_g83);
				float3 lerpResult1133_g83 = lerp( localClipHoles453_g83 , lerpResult1159_g83 , _SnowSplatREnable);
				float SnowSplatG1081_g83 = break1118_g83.y;
				float saferPower1021_g83 = abs( max( ( SnowSplatG1081_g83 * ( 1.0 + _SnowSplatGBlendFactor ) ), 0.0 ) );
				float lerpResult1022_g83 = lerp( 0.0 , pow( saferPower1021_g83 , ( 1.0 - _SnowSplatGBlendFalloff ) ) ,  (-1.0 + ( _SnowSplatGBlendStrength - 0.0 ) * ( 0.0 - -1.0 ) / ( 1.0 - 0.0 ) ));
				float smoothstepResult1060_g83 = smoothstep( _SnowSplatGMin , _SnowSplatGMax , WorldPosition1123_g83.y);
				float lerpResult1036_g83 = lerp( 0.0 , saturate( lerpResult1022_g83 ) , smoothstepResult1060_g83);
				float SnowSplatGMask1072_g83 = lerpResult1036_g83;
				float3 lerpResult1158_g83 = lerp( localClipHoles453_g83 , SnowBaseColor1112_g83 , SnowSplatGMask1072_g83);
				float3 lerpResult1134_g83 = lerp( localClipHoles453_g83 , lerpResult1158_g83 , _SnowSplatGEnable);
				float SnowSplatB1120_g83 = break1118_g83.z;
				float saferPower1065_g83 = abs( max( ( SnowSplatB1120_g83 * ( 1.0 + _SnowSplatBBlendFactor ) ), 0.0 ) );
				float lerpResult1064_g83 = lerp( 0.0 , pow( saferPower1065_g83 , ( 1.0 - _SnowSplatBBlendFalloff ) ) ,  (-1.0 + ( _SnowSplatBBlendStrength - 0.0 ) * ( 0.0 - -1.0 ) / ( 1.0 - 0.0 ) ));
				float smoothstepResult1037_g83 = smoothstep( _SnowSplatBMin , _SnowSplatBMax , WorldPosition1123_g83.y);
				float lerpResult1038_g83 = lerp( 0.0 , saturate( lerpResult1064_g83 ) , smoothstepResult1037_g83);
				float SnowSplatBMask1073_g83 = lerpResult1038_g83;
				float3 lerpResult1160_g83 = lerp( localClipHoles453_g83 , SnowBaseColor1112_g83 , SnowSplatBMask1073_g83);
				float3 lerpResult1163_g83 = lerp( localClipHoles453_g83 , lerpResult1160_g83 , _SnowSplatBEnable);
				float SnowSplatA1121_g83 = break1118_g83.w;
				float saferPower1007_g83 = abs( max( ( SnowSplatA1121_g83 * ( 1.0 + _SnowSplatABlendFactor ) ), 0.0 ) );
				float lerpResult1008_g83 = lerp( 0.0 , pow( saferPower1007_g83 , ( 1.0 - _SnowSplatABlendFalloff ) ) ,  (-1.0 + ( _SnowSplatABlendStrength - 0.0 ) * ( 0.0 - -1.0 ) / ( 1.0 - 0.0 ) ));
				float smoothstepResult1043_g83 = smoothstep( _SnowSplatAMin , _SnowSplatAMax , WorldPosition1123_g83.y);
				float lerpResult1126_g83 = lerp( 0.0 , saturate( lerpResult1008_g83 ) , smoothstepResult1043_g83);
				float SnowSplatAMask1074_g83 = lerpResult1126_g83;
				float3 lerpResult1161_g83 = lerp( localClipHoles453_g83 , SnowBaseColor1112_g83 , SnowSplatAMask1074_g83);
				float3 lerpResult1162_g83 = lerp( localClipHoles453_g83 , lerpResult1161_g83 , _SnowSplatAEnable);
				float4 weightedBlendVar1136_g83 = SnowSplatRGBA1117_g83;
				float3 weightedBlend1136_g83 = ( weightedBlendVar1136_g83.x*lerpResult1133_g83 + weightedBlendVar1136_g83.y*lerpResult1134_g83 + weightedBlendVar1136_g83.z*lerpResult1163_g83 + weightedBlendVar1136_g83.w*lerpResult1162_g83 );
				float3 lerpResult1142_g83 = lerp( localClipHoles453_g83 , weightedBlend1136_g83 , _SnowEnable);
				float4 break2097_g83 = SAMPLE_TEXTURE2D( _Mask0, sampler_Mask0, ( ( TecCoord01294_g83 * _Splat0_ST.xy ) + _Splat0_ST.zw ) );
				float Mask0R334_g83 = break2097_g83.r;
				float4 break2193_g83 = SAMPLE_TEXTURE2D( _Mask1, sampler_Mask0, ( ( TecCoord01294_g83 * _Splat1_ST.xy ) + _Splat1_ST.zw ) );
				float Mask1R370_g83 = break2193_g83.r;
				float4 break2262_g83 = SAMPLE_TEXTURE2D( _Mask2, sampler_Mask0, ( ( TecCoord01294_g83 * _Splat2_ST.xy ) + _Splat2_ST.zw ) );
				float Mask2R359_g83 = break2262_g83.r;
				float4 break2342_g83 = SAMPLE_TEXTURE2D( _Mask3, sampler_Mask0, ( ( TecCoord01294_g83 * _Splat3_ST.xy ) + _Splat3_ST.zw ) );
				float Mask3R388_g83 = break2342_g83.r;
				float4 weightedBlendVar536_g83 = Control26_g83;
				float weightedBlend536_g83 = ( weightedBlendVar536_g83.x*( _Metallic0 * Mask0R334_g83 ) + weightedBlendVar536_g83.y*( _Metallic1 * Mask1R370_g83 ) + weightedBlendVar536_g83.z*( _Metallic2 * Mask2R359_g83 ) + weightedBlendVar536_g83.w*( _Metallic3 * Mask3R388_g83 ) );
				float4 break2413_g83 = SAMPLE_TEXTURE2D( _Mask4, sampler_Mask0, ( ( TecCoord01294_g83 * _Splat4_ST.xy ) + _Splat4_ST.zw ) );
				float Mask4R747_g83 = break2413_g83.r;
				float4 break2472_g83 = SAMPLE_TEXTURE2D( _Mask5, sampler_Mask0, ( ( TecCoord01294_g83 * _Splat5_ST.xy ) + _Splat5_ST.zw ) );
				float Mask5R741_g83 = break2472_g83.r;
				float4 break2531_g83 = SAMPLE_TEXTURE2D( _Mask6, sampler_Mask0, ( ( TecCoord01294_g83 * _Splat6_ST.xy ) + _Splat6_ST.zw ) );
				float Mask6R755_g83 = break2531_g83.r;
				float4 break2590_g83 = SAMPLE_TEXTURE2D( _Mask7, sampler_Mask0, ( ( TecCoord01294_g83 * _Splat7_ST.xy ) + _Splat7_ST.zw ) );
				float Mask7R765_g83 = break2590_g83.r;
				float4 weightedBlendVar834_g83 = Control1922_g83;
				float weightedBlend834_g83 = ( weightedBlendVar834_g83.x*( _Metallic4 * Mask4R747_g83 ) + weightedBlendVar834_g83.y*( _Metallic5 * Mask5R741_g83 ) + weightedBlendVar834_g83.z*( _Metallic6 * Mask6R755_g83 ) + weightedBlendVar834_g83.w*( _Metallic7 * Mask7R765_g83 ) );
				float3 specularColor1792_g83 = (0).xxx;
				float oneMinusReflectivity1792_g83 = 0;
				float3 diffuseColor1792_g83 = ASEComputeDiffuseAndFresnel0( lerpResult1142_g83, ( weightedBlend536_g83 + weightedBlend834_g83 ), specularColor1792_g83, oneMinusReflectivity1792_g83 );
				
				float4 tex2DNode451_g83 = SAMPLE_TEXTURE2D( _TerrainHolesTexture, sampler_TerrainHolesTexture, uv_TerrainHolesTexture451_g83 );
				

				float3 BaseColor = diffuseColor1792_g83;
				float3 Emission = 0;
				float Alpha = ( 0.5 + 1E-37 );
				#if defined( _ALPHATEST_ON )
					float AlphaClipThreshold = ( 1.0 - tex2DNode451_g83 ).r;
				#endif

				#if defined( _ALPHATEST_ON )
					AlphaDiscard( Alpha, AlphaClipThreshold );
				#endif

				MetaInput metaInput = (MetaInput)0;
				metaInput.Albedo = BaseColor;
				metaInput.Emission = Emission;
				#ifdef EDITOR_VISUALIZATION
					metaInput.VizUV = input.VizUV.xy;
					metaInput.LightCoord = input.LightCoord;
				#endif

				return UnityMetaFragment(metaInput);
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "Universal2D"
			Tags { "LightMode"="Universal2D" }

			Blend One Zero, One Zero
			ZWrite On
			ZTest LEqual
			Offset 0 , 0
			ColorMask RGBA

			HLSLPROGRAM

			#define _ALPHATEST_ON
			#define _NORMAL_DROPOFF_TS 1
			#define ASE_FOG 1
			#pragma multi_compile_fragment _ DEBUG_DISPLAY
			#define ASE_TERRAIN
			#define _SPECULAR_SETUP 1
			#define _NORMALMAP 1
			#define ASE_VERSION 19907
			#define ASE_SRP_VERSION 170300
			#define ASE_USING_SAMPLING_MACROS 1


			#pragma vertex vert
			#pragma fragment frag

			#if defined( _SPECULAR_SETUP ) && defined( ASE_LIGHTING_SIMPLE )
				#if defined( _SPECULARHIGHLIGHTS_OFF )
					#undef _SPECULAR_COLOR
				#else
					#define _SPECULAR_COLOR
				#endif
			#endif

			#define SHADERPASS SHADERPASS_2D

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_TEXTURE_COORDINATES0
			#define ASE_NEEDS_VERT_TEXTURE_COORDINATES0
			#define ASE_NEEDS_FRAG_TEXTURE_COORDINATES0
			#define ASE_NEEDS_WORLD_POSITION
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_INSTANCED_TERRAIN
			#define ASE_NEEDS_VERT_POSITION
			#pragma multi_compile_instancing
			#pragma instancing_options assumeuniformscaling nomatrices nolightprobe nolightmap
			#define TERRAIN_SPLAT_FIRSTPASS 1
			#define _LAYER_COUNT 8
			#pragma shader_feature_local _TERRAIN_8_LAYERS
			#pragma editor_sync_compilation
			#pragma shader_feature_local _NORMALMAP
			#pragma shader_feature_local _MASKMAP


			struct Attributes
			{
				float4 positionOS : POSITION;
				half3 normalOS : NORMAL;
				half4 tangentOS : TANGENT;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct PackedVaryings
			{
				float4 positionCS : SV_POSITION;
				float3 positionWS : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_texcoord2 : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _Control_ST;
			float4 _MaskMapRemapScale4;
			float4 _MaskMapRemapOffset4;
			float4 _MaskMapRemapScale3;
			half4 _SnowColor;
			float4 _SnowMainUVs;
			float4 _MaskMapRemapOffset3;
			float4 _MaskMapRemapOffset2;
			float4 _MaskMapRemapScale1;
			float4 _MaskMapRemapOffset1;
			float4 _SnowMapSplat_ST;
			float4 _MaskMapRemapScale0;
			float4 _Specular7;
			float4 _Specular6;
			float4 _Specular5;
			float4 _MaskMapRemapScale7;
			float4 _Specular4;
			float4 _Specular3;
			float4 _Specular2;
			float4 _Specular1;
			float4 _Specular0;
			float4 _MaskMapRemapOffset0;
			float4 _Splat7_ST;
			float4 _MaskMapRemapScale2;
			float4 _MaskMapRemapOffset5;
			float4 _DiffuseRemapScale7;
			float4 _MaskMapRemapScale6;
			float4 _Splat2_ST;
			float4 _DiffuseRemapScale2;
			float4 _DiffuseRemapScale3;
			float4 _Splat3_ST;
			float4 _Splat1_ST;
			float4 _MaskMapRemapOffset6;
			float4 _DiffuseRemapScale1;
			float4 _DiffuseRemapScale4;
			float4 _Control1_ST;
			float4 _Splat0_ST;
			float4 _Splat6_ST;
			float4 _DiffuseRemapScale6;
			float4 _MaskMapRemapOffset7;
			float4 _Splat5_ST;
			float4 _MaskMapRemapScale5;
			float4 _DiffuseRemapScale0;
			float4 _Splat4_ST;
			float4 _DiffuseRemapScale5;
			half _SnowNormalStrength;
			float _LayerHasMask6;
			float _OpacityAsDensity1;
			half _NormalScale7;
			float _Smoothness0;
			float _OpacityAsDensity0;
			float _Smoothness1;
			float _Smoothness2;
			float _OpacityAsDensity5;
			float _Smoothness3;
			float _LayerHasMask4;
			float _LayerHasMask3;
			float _LayerHasMask5;
			float _LayerHasMask2;
			half _NormalScale6;
			float _LayerHasMask1;
			float _LayerHasMask0;
			float _OpacityAsDensity7;
			float _Smoothness7;
			float _OpacityAsDensity6;
			float _Smoothness6;
			float _Smoothness5;
			float _OpacityAsDensity4;
			float _Smoothness4;
			float _OpacityAsDensity3;
			float _OpacityAsDensity2;
			half _NormalScale5;
			float _Metallic2;
			half _NormalScale3;
			half _SnowSplatGBlendFalloff;
			half _SnowSplatGBlendFactor;
			half _SnowSplatREnable;
			half _SnowSplatRMax;
			half _SnowSplatRMin;
			half _SnowSplatRBlendStrength;
			half _SnowSplatRBlendFalloff;
			half _SnowSplatRBlendFactor;
			half _SnowBrightness;
			half _SnowSaturation;
			half _SnowSplatGBlendStrength;
			half _SnowSplatASplatBias;
			half _SnowSplatGSplatBias;
			half _SnowSplatRSplatBias;
			half _Splat7Brightness;
			half _Splat6Brightness;
			half _Splat5Brightness;
			half _Splat4Brightness;
			half _Splat3Brightness;
			half _Splat2Brightness;
			half _Splat1Brightness;
			half _Splat0Brightness;
			half _SnowSplatBSplatBias;
			half _SnowSplatGMin;
			half _SnowSplatGMax;
			half _SnowSplatGEnable;
			half _NormalScale2;
			half _NormalScale1;
			half _NormalScale0;
			float _Metallic7;
			float _Metallic6;
			float _Metallic5;
			float _Metallic4;
			float _Metallic3;
			float _Metallic1;
			float _Metallic0;
			half _SnowEnable;
			half _SnowSplatAEnable;
			half _SnowSplatAMax;
			half _SnowSplatAMin;
			half _SnowSplatABlendStrength;
			half _SnowSplatABlendFalloff;
			half _SnowSplatABlendFactor;
			half _SnowSplatBEnable;
			half _SnowSplatBMax;
			half _SnowSplatBMin;
			half _SnowSplatBBlendStrength;
			half _SnowSplatBBlendFalloff;
			half _SnowSplatBBlendFactor;
			half _NormalScale4;
			float _LayerHasMask7;
			float _AlphaClip;
			float _Cutoff;
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
			CBUFFER_END

			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			TEXTURE2D(_Control);
			SAMPLER(sampler_Control);
			TEXTURE2D(_Splat0);
			SAMPLER(sampler_Splat0);
			TEXTURE2D(_Splat1);
			TEXTURE2D(_Splat2);
			TEXTURE2D(_Splat3);
			TEXTURE2D(_Control1);
			SAMPLER(sampler_Control1);
			TEXTURE2D(_Splat4);
			TEXTURE2D(_Splat5);
			TEXTURE2D(_Splat6);
			TEXTURE2D(_Splat7);
			TEXTURE2D(_TerrainHolesTexture);
			SAMPLER(sampler_TerrainHolesTexture);
			TEXTURE2D(_SnowMapSplat);
			SAMPLER(sampler_SnowMapSplat);
			TEXTURE2D(_SnowMapBaseColor);
			SAMPLER(sampler_SnowMapBaseColor);
			TEXTURE2D(_Mask0);
			SAMPLER(sampler_Mask0);
			TEXTURE2D(_Mask1);
			TEXTURE2D(_Mask2);
			TEXTURE2D(_Mask3);
			TEXTURE2D(_Mask4);
			TEXTURE2D(_Mask5);
			TEXTURE2D(_Mask6);
			TEXTURE2D(_Mask7);
			#ifdef UNITY_INSTANCING_ENABLED//ASE Terrain Instancing
				TEXTURE2D(_TerrainHeightmapTexture);//ASE Terrain Instancing
				TEXTURE2D( _TerrainNormalmapTexture);//ASE Terrain Instancing
				SAMPLER(sampler_TerrainNormalmapTexture);//ASE Terrain Instancing
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
				float2 sampleCoords = ( patchVertex.xy + instanceData.xy ) * instanceData.z;
				float height = UnpackHeightmap( _TerrainHeightmapTexture.Load( int3( sampleCoords, 0 ) ) );
				position.xz = sampleCoords* _TerrainHeightmapScale.xz;
				position.y = height* _TerrainHeightmapScale.y;
				#ifdef ENABLE_TERRAIN_PERPIXEL_NORMAL
					normal = float3(0, 1, 0);
				#else
					normal = _TerrainNormalmapTexture.Load(int3(sampleCoords, 0)).rgb* 2 - 1;
				#endif
				texcoord.xy = sampleCoords* _TerrainHeightmapRecipSize.zw;
			#endif
			}
			

			PackedVaryings VertexFunction( Attributes input  )
			{
				PackedVaryings output = (PackedVaryings)0;
				UNITY_SETUP_INSTANCE_ID( input );
				UNITY_TRANSFER_INSTANCE_ID( input, output );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( output );

				#if defined( ASE_INSTANCED_TERRAIN ) && !defined( ASE_TESSELLATION )
					TerrainApplyMeshModification( input.positionOS.xyz, input.normalOS, input.ase_texcoord );
				#endif
				
				float4 appendResult993_g83 = (float4(cross( input.normalOS , float3( 0, 0, 1 ) ) , -1.0));
				
				float2 TecCoord01294_g83 = input.ase_texcoord.xy;
				float2 break291_g83 = _Control_ST.zw;
				float2 appendResult293_g83 = (float2(( break291_g83.x + 0.001 ) , ( break291_g83.y + 0.0001 )));
				float2 vertexToFrag286_g83 = ( ( TecCoord01294_g83 * _Control_ST.xy ) + appendResult293_g83 );
				output.ase_texcoord1.xy = vertexToFrag286_g83;
				float2 break1393_g83 = _Control1_ST.zw;
				float2 appendResult1382_g83 = (float2(( break1393_g83.x + 0.001 ) , ( break1393_g83.y + 0.0001 )));
				float2 vertexToFrag1395_g83 = ( ( TecCoord01294_g83 * _Control1_ST.xy ) + appendResult1382_g83 );
				output.ase_texcoord2.xy = vertexToFrag1395_g83;
				float2 vertexToFrag1085_g83 = ( ( TecCoord01294_g83 * (_SnowMainUVs).xy ) + (_SnowMainUVs).zw );
				output.ase_texcoord2.zw = vertexToFrag1085_g83;
				
				output.ase_texcoord1.zw = input.ase_texcoord.xy;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = input.positionOS.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = defaultVertexValue;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					input.positionOS.xyz = vertexValue;
				#else
					input.positionOS.xyz += vertexValue;
				#endif

				input.normalOS = input.normalOS;
				input.tangentOS = appendResult993_g83;

				VertexPositionInputs vertexInput = GetVertexPositionInputs( input.positionOS.xyz );

				output.positionCS = vertexInput.positionCS;
				output.positionWS = vertexInput.positionWS;
				return output;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 positionOS : INTERNALTESSPOS;
				half3 normalOS : NORMAL;
				half4 tangentOS : TANGENT;
				float4 ase_texcoord : TEXCOORD0;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( Attributes input )
			{
				VertexControl output;
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_TRANSFER_INSTANCE_ID(input, output);
				output.positionOS = input.positionOS;
				output.normalOS = input.normalOS;
				output.tangentOS = input.tangentOS;
				output.ase_texcoord = input.ase_texcoord;
				#if defined( ASE_INSTANCED_TERRAIN )
					TerrainApplyMeshModification( output.positionOS.xyz, output.normalOS, output.ase_texcoord );
				#endif
				
				return output;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> input)
			{
				TessellationFactors output;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(input[0].positionOS, input[1].positionOS, input[2].positionOS, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(input[0].positionOS, input[1].positionOS, input[2].positionOS, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(input[0].positionOS, input[1].positionOS, input[2].positionOS, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				output.edge[0] = tf.x; output.edge[1] = tf.y; output.edge[2] = tf.z; output.inside = tf.w;
				return output;
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
			PackedVaryings DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				Attributes output = (Attributes) 0;
				output.positionOS = patch[0].positionOS * bary.x + patch[1].positionOS * bary.y + patch[2].positionOS * bary.z;
				output.normalOS = patch[0].normalOS * bary.x + patch[1].normalOS * bary.y + patch[2].normalOS * bary.z;
				output.tangentOS = patch[0].tangentOS * bary.x + patch[1].tangentOS * bary.y + patch[2].tangentOS * bary.z;
				output.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = output.positionOS.xyz - patch[i].normalOS * (dot(output.positionOS.xyz, patch[i].normalOS) - dot(patch[i].positionOS.xyz, patch[i].normalOS));
				float phongStrength = _TessPhongStrength;
				output.positionOS.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * output.positionOS.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], output);
				return VertexFunction(output);
			}
			#else
			PackedVaryings vert ( Attributes input )
			{
				return VertexFunction( input );
			}
			#endif

			half4 frag(PackedVaryings input  ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( input );
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( input );

				#if defined(MAIN_LIGHT_CALCULATE_SHADOWS) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					float4 shadowCoord = TransformWorldToShadowCoord(input.positionWS);
				#else
					float4 shadowCoord = float4(0, 0, 0, 0);
				#endif

				float3 PositionWS = input.positionWS;
				float3 PositionRWS = GetCameraRelativePositionWS( input.positionWS );
				float4 ShadowCoord = shadowCoord;

				float2 vertexToFrag286_g83 = input.ase_texcoord1.xy;
				float4 Control26_g83 = SAMPLE_TEXTURE2D( _Control, sampler_Control, vertexToFrag286_g83 );
				float2 TecCoord01294_g83 = input.ase_texcoord1.zw;
				float3 Splat0342_g83 = (SAMPLE_TEXTURE2D( _Splat0, sampler_Splat0, ( ( TecCoord01294_g83 * _Splat0_ST.xy ) + _Splat0_ST.zw ) )).rgb;
				float3 temp_output_35_0_g83 = ( (_DiffuseRemapScale0).xyz * Splat0342_g83 * _Splat0Brightness );
				float3 Splat1379_g83 = (SAMPLE_TEXTURE2D( _Splat1, sampler_Splat0, ( ( TecCoord01294_g83 * _Splat1_ST.xy ) + _Splat1_ST.zw ) )).rgb;
				float3 temp_output_38_0_g83 = ( (_DiffuseRemapScale1).xyz * Splat1379_g83 * _Splat1Brightness );
				float3 Splat2357_g83 = (SAMPLE_TEXTURE2D( _Splat2, sampler_Splat0, ( ( TecCoord01294_g83 * _Splat2_ST.xy ) + _Splat2_ST.zw ) )).rgb;
				float3 temp_output_41_0_g83 = ( (_DiffuseRemapScale2).xyz * Splat2357_g83 * _Splat2Brightness );
				float3 Splat3390_g83 = (SAMPLE_TEXTURE2D( _Splat3, sampler_Splat0, ( ( TecCoord01294_g83 * _Splat3_ST.xy ) + _Splat3_ST.zw ) )).rgb;
				float3 temp_output_44_0_g83 = ( (_DiffuseRemapScale3).xyz * Splat3390_g83 * _Splat3Brightness );
				float4 weightedBlendVar9_g83 = Control26_g83;
				float3 weightedBlend9_g83 = ( weightedBlendVar9_g83.x*temp_output_35_0_g83 + weightedBlendVar9_g83.y*temp_output_38_0_g83 + weightedBlendVar9_g83.z*temp_output_41_0_g83 + weightedBlendVar9_g83.w*temp_output_44_0_g83 );
				float2 vertexToFrag1395_g83 = input.ase_texcoord2.xy;
				float4 Control1922_g83 = SAMPLE_TEXTURE2D( _Control1, sampler_Control1, vertexToFrag1395_g83 );
				float3 Splat4752_g83 = (SAMPLE_TEXTURE2D( _Splat4, sampler_Splat0, ( ( TecCoord01294_g83 * _Splat4_ST.xy ) + _Splat4_ST.zw ) )).rgb;
				float3 temp_output_900_0_g83 = ( (_DiffuseRemapScale4).xyz * Splat4752_g83 * _Splat4Brightness );
				float3 Splat5743_g83 = (SAMPLE_TEXTURE2D( _Splat5, sampler_Splat0, ( ( TecCoord01294_g83 * _Splat5_ST.xy ) + _Splat5_ST.zw ) )).rgb;
				float3 temp_output_901_0_g83 = ( (_DiffuseRemapScale5).xyz * Splat5743_g83 * _Splat5Brightness );
				float3 Splat6759_g83 = (SAMPLE_TEXTURE2D( _Splat6, sampler_Splat0, ( ( TecCoord01294_g83 * _Splat6_ST.xy ) + _Splat6_ST.zw ) )).rgb;
				float3 temp_output_919_0_g83 = ( (_DiffuseRemapScale6).xyz * Splat6759_g83 * _Splat6Brightness );
				float3 Splat7762_g83 = (SAMPLE_TEXTURE2D( _Splat7, sampler_Splat0, ( ( TecCoord01294_g83 * _Splat7_ST.xy ) + _Splat7_ST.zw ) )).rgb;
				float3 temp_output_921_0_g83 = ( (_DiffuseRemapScale7).xyz * Splat7762_g83 * _Splat7Brightness );
				float4 weightedBlendVar912_g83 = Control1922_g83;
				float3 weightedBlend912_g83 = ( weightedBlendVar912_g83.x*temp_output_900_0_g83 + weightedBlendVar912_g83.y*temp_output_901_0_g83 + weightedBlendVar912_g83.z*temp_output_919_0_g83 + weightedBlendVar912_g83.w*temp_output_921_0_g83 );
				float3 localClipHoles453_g83 = ( ( weightedBlend9_g83 + weightedBlend912_g83 ) );
				float2 uv_TerrainHolesTexture451_g83 = input.ase_texcoord1.zw;
				float Hole453_g83 = SAMPLE_TEXTURE2D( _TerrainHolesTexture, sampler_TerrainHolesTexture, uv_TerrainHolesTexture451_g83 ).r;
				{
				#ifdef _ALPHATEST_ON
				clip(Hole453_g83 == 0.0005f? -1 : 1);
				#endif
				}
				float2 uv_SnowMapSplat = input.ase_texcoord1.zw * _SnowMapSplat_ST.xy + _SnowMapSplat_ST.zw;
				float4 tex2DNode1080_g83 = SAMPLE_TEXTURE2D( _SnowMapSplat, sampler_SnowMapSplat, uv_SnowMapSplat );
				float4 appendResult1076_g83 = (float4(( tex2DNode1080_g83.r * _SnowSplatRSplatBias ) , ( tex2DNode1080_g83.g * _SnowSplatGSplatBias ) , ( tex2DNode1080_g83.b * _SnowSplatBSplatBias ) , ( tex2DNode1080_g83.a * _SnowSplatASplatBias )));
				float4 SnowSplatRGBA1117_g83 = appendResult1076_g83;
				float2 vertexToFrag1085_g83 = input.ase_texcoord2.zw;
				float2 temp_output_1083_0_g83 = ( vertexToFrag1085_g83 * 100.0 );
				float3 temp_output_12_0_g84 = (SAMPLE_TEXTURE2D( _SnowMapBaseColor, sampler_SnowMapBaseColor, temp_output_1083_0_g83 )).rgb;
				float dotResult28_g84 = dot( float3( 0.2126729, 0.7151522, 0.072175 ) , temp_output_12_0_g84 );
				float3 temp_cast_0 = (dotResult28_g84).xxx;
				float temp_output_21_0_g84 = ( 1.0 - _SnowSaturation );
				float3 lerpResult31_g84 = lerp( temp_cast_0 , temp_output_12_0_g84 , temp_output_21_0_g84);
				float3 SnowBaseColor1112_g83 = ( (_SnowColor).rgb * lerpResult31_g84 * _SnowBrightness );
				float4 break1118_g83 = appendResult1076_g83;
				float SnowSplatR1119_g83 = break1118_g83.x;
				float saferPower1027_g83 = abs( max( ( SnowSplatR1119_g83 * ( 1.0 + _SnowSplatRBlendFactor ) ), 0.0 ) );
				float lerpResult1029_g83 = lerp( 0.0 , pow( saferPower1027_g83 , ( 1.0 - _SnowSplatRBlendFalloff ) ) ,  (-1.0 + ( _SnowSplatRBlendStrength - 0.0 ) * ( 0.0 - -1.0 ) / ( 1.0 - 0.0 ) ));
				float3 WorldPosition1123_g83 = PositionWS;
				float smoothstepResult1053_g83 = smoothstep( _SnowSplatRMin , _SnowSplatRMax , WorldPosition1123_g83.y);
				float lerpResult1124_g83 = lerp( 0.0 , saturate( lerpResult1029_g83 ) , smoothstepResult1053_g83);
				float SnowSplatRMask1071_g83 = lerpResult1124_g83;
				float3 lerpResult1159_g83 = lerp( localClipHoles453_g83 , SnowBaseColor1112_g83 , SnowSplatRMask1071_g83);
				float3 lerpResult1133_g83 = lerp( localClipHoles453_g83 , lerpResult1159_g83 , _SnowSplatREnable);
				float SnowSplatG1081_g83 = break1118_g83.y;
				float saferPower1021_g83 = abs( max( ( SnowSplatG1081_g83 * ( 1.0 + _SnowSplatGBlendFactor ) ), 0.0 ) );
				float lerpResult1022_g83 = lerp( 0.0 , pow( saferPower1021_g83 , ( 1.0 - _SnowSplatGBlendFalloff ) ) ,  (-1.0 + ( _SnowSplatGBlendStrength - 0.0 ) * ( 0.0 - -1.0 ) / ( 1.0 - 0.0 ) ));
				float smoothstepResult1060_g83 = smoothstep( _SnowSplatGMin , _SnowSplatGMax , WorldPosition1123_g83.y);
				float lerpResult1036_g83 = lerp( 0.0 , saturate( lerpResult1022_g83 ) , smoothstepResult1060_g83);
				float SnowSplatGMask1072_g83 = lerpResult1036_g83;
				float3 lerpResult1158_g83 = lerp( localClipHoles453_g83 , SnowBaseColor1112_g83 , SnowSplatGMask1072_g83);
				float3 lerpResult1134_g83 = lerp( localClipHoles453_g83 , lerpResult1158_g83 , _SnowSplatGEnable);
				float SnowSplatB1120_g83 = break1118_g83.z;
				float saferPower1065_g83 = abs( max( ( SnowSplatB1120_g83 * ( 1.0 + _SnowSplatBBlendFactor ) ), 0.0 ) );
				float lerpResult1064_g83 = lerp( 0.0 , pow( saferPower1065_g83 , ( 1.0 - _SnowSplatBBlendFalloff ) ) ,  (-1.0 + ( _SnowSplatBBlendStrength - 0.0 ) * ( 0.0 - -1.0 ) / ( 1.0 - 0.0 ) ));
				float smoothstepResult1037_g83 = smoothstep( _SnowSplatBMin , _SnowSplatBMax , WorldPosition1123_g83.y);
				float lerpResult1038_g83 = lerp( 0.0 , saturate( lerpResult1064_g83 ) , smoothstepResult1037_g83);
				float SnowSplatBMask1073_g83 = lerpResult1038_g83;
				float3 lerpResult1160_g83 = lerp( localClipHoles453_g83 , SnowBaseColor1112_g83 , SnowSplatBMask1073_g83);
				float3 lerpResult1163_g83 = lerp( localClipHoles453_g83 , lerpResult1160_g83 , _SnowSplatBEnable);
				float SnowSplatA1121_g83 = break1118_g83.w;
				float saferPower1007_g83 = abs( max( ( SnowSplatA1121_g83 * ( 1.0 + _SnowSplatABlendFactor ) ), 0.0 ) );
				float lerpResult1008_g83 = lerp( 0.0 , pow( saferPower1007_g83 , ( 1.0 - _SnowSplatABlendFalloff ) ) ,  (-1.0 + ( _SnowSplatABlendStrength - 0.0 ) * ( 0.0 - -1.0 ) / ( 1.0 - 0.0 ) ));
				float smoothstepResult1043_g83 = smoothstep( _SnowSplatAMin , _SnowSplatAMax , WorldPosition1123_g83.y);
				float lerpResult1126_g83 = lerp( 0.0 , saturate( lerpResult1008_g83 ) , smoothstepResult1043_g83);
				float SnowSplatAMask1074_g83 = lerpResult1126_g83;
				float3 lerpResult1161_g83 = lerp( localClipHoles453_g83 , SnowBaseColor1112_g83 , SnowSplatAMask1074_g83);
				float3 lerpResult1162_g83 = lerp( localClipHoles453_g83 , lerpResult1161_g83 , _SnowSplatAEnable);
				float4 weightedBlendVar1136_g83 = SnowSplatRGBA1117_g83;
				float3 weightedBlend1136_g83 = ( weightedBlendVar1136_g83.x*lerpResult1133_g83 + weightedBlendVar1136_g83.y*lerpResult1134_g83 + weightedBlendVar1136_g83.z*lerpResult1163_g83 + weightedBlendVar1136_g83.w*lerpResult1162_g83 );
				float3 lerpResult1142_g83 = lerp( localClipHoles453_g83 , weightedBlend1136_g83 , _SnowEnable);
				float4 break2097_g83 = SAMPLE_TEXTURE2D( _Mask0, sampler_Mask0, ( ( TecCoord01294_g83 * _Splat0_ST.xy ) + _Splat0_ST.zw ) );
				float Mask0R334_g83 = break2097_g83.r;
				float4 break2193_g83 = SAMPLE_TEXTURE2D( _Mask1, sampler_Mask0, ( ( TecCoord01294_g83 * _Splat1_ST.xy ) + _Splat1_ST.zw ) );
				float Mask1R370_g83 = break2193_g83.r;
				float4 break2262_g83 = SAMPLE_TEXTURE2D( _Mask2, sampler_Mask0, ( ( TecCoord01294_g83 * _Splat2_ST.xy ) + _Splat2_ST.zw ) );
				float Mask2R359_g83 = break2262_g83.r;
				float4 break2342_g83 = SAMPLE_TEXTURE2D( _Mask3, sampler_Mask0, ( ( TecCoord01294_g83 * _Splat3_ST.xy ) + _Splat3_ST.zw ) );
				float Mask3R388_g83 = break2342_g83.r;
				float4 weightedBlendVar536_g83 = Control26_g83;
				float weightedBlend536_g83 = ( weightedBlendVar536_g83.x*( _Metallic0 * Mask0R334_g83 ) + weightedBlendVar536_g83.y*( _Metallic1 * Mask1R370_g83 ) + weightedBlendVar536_g83.z*( _Metallic2 * Mask2R359_g83 ) + weightedBlendVar536_g83.w*( _Metallic3 * Mask3R388_g83 ) );
				float4 break2413_g83 = SAMPLE_TEXTURE2D( _Mask4, sampler_Mask0, ( ( TecCoord01294_g83 * _Splat4_ST.xy ) + _Splat4_ST.zw ) );
				float Mask4R747_g83 = break2413_g83.r;
				float4 break2472_g83 = SAMPLE_TEXTURE2D( _Mask5, sampler_Mask0, ( ( TecCoord01294_g83 * _Splat5_ST.xy ) + _Splat5_ST.zw ) );
				float Mask5R741_g83 = break2472_g83.r;
				float4 break2531_g83 = SAMPLE_TEXTURE2D( _Mask6, sampler_Mask0, ( ( TecCoord01294_g83 * _Splat6_ST.xy ) + _Splat6_ST.zw ) );
				float Mask6R755_g83 = break2531_g83.r;
				float4 break2590_g83 = SAMPLE_TEXTURE2D( _Mask7, sampler_Mask0, ( ( TecCoord01294_g83 * _Splat7_ST.xy ) + _Splat7_ST.zw ) );
				float Mask7R765_g83 = break2590_g83.r;
				float4 weightedBlendVar834_g83 = Control1922_g83;
				float weightedBlend834_g83 = ( weightedBlendVar834_g83.x*( _Metallic4 * Mask4R747_g83 ) + weightedBlendVar834_g83.y*( _Metallic5 * Mask5R741_g83 ) + weightedBlendVar834_g83.z*( _Metallic6 * Mask6R755_g83 ) + weightedBlendVar834_g83.w*( _Metallic7 * Mask7R765_g83 ) );
				float3 specularColor1792_g83 = (0).xxx;
				float oneMinusReflectivity1792_g83 = 0;
				float3 diffuseColor1792_g83 = ASEComputeDiffuseAndFresnel0( lerpResult1142_g83, ( weightedBlend536_g83 + weightedBlend834_g83 ), specularColor1792_g83, oneMinusReflectivity1792_g83 );
				
				float4 tex2DNode451_g83 = SAMPLE_TEXTURE2D( _TerrainHolesTexture, sampler_TerrainHolesTexture, uv_TerrainHolesTexture451_g83 );
				

				float3 BaseColor = diffuseColor1792_g83;
				float Alpha = ( 0.5 + 1E-37 );
				#if defined( _ALPHATEST_ON )
					float AlphaClipThreshold = ( 1.0 - tex2DNode451_g83 ).r;
				#endif

				half4 color = half4(BaseColor, Alpha );

				#if defined( _ALPHATEST_ON )
					AlphaDiscard( Alpha, AlphaClipThreshold );
				#endif

				return color;
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "DepthNormals"
			Tags { "LightMode"="DepthNormals" }

			ZWrite On
			Blend One Zero
			ZTest LEqual
			ZWrite On

			HLSLPROGRAM

			#define _ALPHATEST_ON
			#define _NORMAL_DROPOFF_TS 1
			#define ASE_FOG 1
			#pragma multi_compile_fragment _ DEBUG_DISPLAY
			#define ASE_TERRAIN
			#pragma shader_feature _INSTANCEDTERRAINNORMALS_PIXEL
			#define _SPECULAR_SETUP 1
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#define _NORMALMAP 1
			#define ASE_VERSION 19907
			#define ASE_SRP_VERSION 170300
			#define ASE_USING_SAMPLING_MACROS 1


			#pragma vertex vert
			#pragma fragment frag

			#if defined( _SPECULAR_SETUP ) && defined( ASE_LIGHTING_SIMPLE )
				#if defined( _SPECULARHIGHLIGHTS_OFF )
					#undef _SPECULAR_COLOR
				#else
					#define _SPECULAR_COLOR
				#endif
			#endif

			#define SHADERPASS SHADERPASS_DEPTHNORMALSONLY
			//#define SHADERPASS SHADERPASS_DEPTHNORMALS

			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#if defined(LOD_FADE_CROSSFADE)
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
            #endif

			#if defined( UNITY_INSTANCING_ENABLED ) && defined( ASE_INSTANCED_TERRAIN ) && ( defined(_TERRAIN_INSTANCED_PERPIXEL_NORMAL) || defined(_INSTANCEDTERRAINNORMALS_PIXEL) )
				#define ENABLE_TERRAIN_PERPIXEL_NORMAL
			#endif

			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_TEXTURE_COORDINATES0
			#define ASE_NEEDS_VERT_TEXTURE_COORDINATES0
			#define ASE_NEEDS_FRAG_TEXTURE_COORDINATES0
			#define ASE_INSTANCED_TERRAIN
			#define ASE_NEEDS_VERT_POSITION
			#pragma multi_compile_instancing
			#pragma instancing_options assumeuniformscaling nomatrices nolightprobe nolightmap
			#define TERRAIN_SPLAT_FIRSTPASS 1
			#define _LAYER_COUNT 8
			#pragma shader_feature_local _TERRAIN_8_LAYERS
			#pragma editor_sync_compilation
			#pragma shader_feature_local _NORMALMAP
			#pragma shader_feature_local _MASKMAP


			#if defined(ASE_EARLY_Z_DEPTH_OPTIMIZE) && (SHADER_TARGET >= 45)
				#define ASE_SV_DEPTH SV_DepthLessEqual
				#define ASE_SV_POSITION_QUALIFIERS linear noperspective centroid
			#else
				#define ASE_SV_DEPTH SV_Depth
				#define ASE_SV_POSITION_QUALIFIERS
			#endif

			struct Attributes
			{
				float4 positionOS : POSITION;
				half3 normalOS : NORMAL;
				half4 tangentOS : TANGENT;
				half4 texcoord : TEXCOORD0;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct PackedVaryings
			{
				ASE_SV_POSITION_QUALIFIERS float4 positionCS : SV_POSITION;
				float3 positionWS : TEXCOORD0;
				half3 normalWS : TEXCOORD1;
				float4 tangentWS : TEXCOORD2; // holds terrainUV ifdef ENABLE_TERRAIN_PERPIXEL_NORMAL
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_texcoord4 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _Control_ST;
			float4 _MaskMapRemapScale4;
			float4 _MaskMapRemapOffset4;
			float4 _MaskMapRemapScale3;
			half4 _SnowColor;
			float4 _SnowMainUVs;
			float4 _MaskMapRemapOffset3;
			float4 _MaskMapRemapOffset2;
			float4 _MaskMapRemapScale1;
			float4 _MaskMapRemapOffset1;
			float4 _SnowMapSplat_ST;
			float4 _MaskMapRemapScale0;
			float4 _Specular7;
			float4 _Specular6;
			float4 _Specular5;
			float4 _MaskMapRemapScale7;
			float4 _Specular4;
			float4 _Specular3;
			float4 _Specular2;
			float4 _Specular1;
			float4 _Specular0;
			float4 _MaskMapRemapOffset0;
			float4 _Splat7_ST;
			float4 _MaskMapRemapScale2;
			float4 _MaskMapRemapOffset5;
			float4 _DiffuseRemapScale7;
			float4 _MaskMapRemapScale6;
			float4 _Splat2_ST;
			float4 _DiffuseRemapScale2;
			float4 _DiffuseRemapScale3;
			float4 _Splat3_ST;
			float4 _Splat1_ST;
			float4 _MaskMapRemapOffset6;
			float4 _DiffuseRemapScale1;
			float4 _DiffuseRemapScale4;
			float4 _Control1_ST;
			float4 _Splat0_ST;
			float4 _Splat6_ST;
			float4 _DiffuseRemapScale6;
			float4 _MaskMapRemapOffset7;
			float4 _Splat5_ST;
			float4 _MaskMapRemapScale5;
			float4 _DiffuseRemapScale0;
			float4 _Splat4_ST;
			float4 _DiffuseRemapScale5;
			half _SnowNormalStrength;
			float _LayerHasMask6;
			float _OpacityAsDensity1;
			half _NormalScale7;
			float _Smoothness0;
			float _OpacityAsDensity0;
			float _Smoothness1;
			float _Smoothness2;
			float _OpacityAsDensity5;
			float _Smoothness3;
			float _LayerHasMask4;
			float _LayerHasMask3;
			float _LayerHasMask5;
			float _LayerHasMask2;
			half _NormalScale6;
			float _LayerHasMask1;
			float _LayerHasMask0;
			float _OpacityAsDensity7;
			float _Smoothness7;
			float _OpacityAsDensity6;
			float _Smoothness6;
			float _Smoothness5;
			float _OpacityAsDensity4;
			float _Smoothness4;
			float _OpacityAsDensity3;
			float _OpacityAsDensity2;
			half _NormalScale5;
			float _Metallic2;
			half _NormalScale3;
			half _SnowSplatGBlendFalloff;
			half _SnowSplatGBlendFactor;
			half _SnowSplatREnable;
			half _SnowSplatRMax;
			half _SnowSplatRMin;
			half _SnowSplatRBlendStrength;
			half _SnowSplatRBlendFalloff;
			half _SnowSplatRBlendFactor;
			half _SnowBrightness;
			half _SnowSaturation;
			half _SnowSplatGBlendStrength;
			half _SnowSplatASplatBias;
			half _SnowSplatGSplatBias;
			half _SnowSplatRSplatBias;
			half _Splat7Brightness;
			half _Splat6Brightness;
			half _Splat5Brightness;
			half _Splat4Brightness;
			half _Splat3Brightness;
			half _Splat2Brightness;
			half _Splat1Brightness;
			half _Splat0Brightness;
			half _SnowSplatBSplatBias;
			half _SnowSplatGMin;
			half _SnowSplatGMax;
			half _SnowSplatGEnable;
			half _NormalScale2;
			half _NormalScale1;
			half _NormalScale0;
			float _Metallic7;
			float _Metallic6;
			float _Metallic5;
			float _Metallic4;
			float _Metallic3;
			float _Metallic1;
			float _Metallic0;
			half _SnowEnable;
			half _SnowSplatAEnable;
			half _SnowSplatAMax;
			half _SnowSplatAMin;
			half _SnowSplatABlendStrength;
			half _SnowSplatABlendFalloff;
			half _SnowSplatABlendFactor;
			half _SnowSplatBEnable;
			half _SnowSplatBMax;
			half _SnowSplatBMin;
			half _SnowSplatBBlendStrength;
			half _SnowSplatBBlendFalloff;
			half _SnowSplatBBlendFactor;
			half _NormalScale4;
			float _LayerHasMask7;
			float _AlphaClip;
			float _Cutoff;
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
			CBUFFER_END

			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			TEXTURE2D(_Control);
			SAMPLER(sampler_Control);
			TEXTURE2D(_Normal0);
			TEXTURE2D(_Splat0);
			SAMPLER(sampler_Normal0);
			TEXTURE2D(_Normal1);
			TEXTURE2D(_Splat1);
			TEXTURE2D(_Normal2);
			TEXTURE2D(_Splat2);
			TEXTURE2D(_Normal3);
			TEXTURE2D(_Splat3);
			TEXTURE2D(_Control1);
			SAMPLER(sampler_Control1);
			TEXTURE2D(_Normal4);
			TEXTURE2D(_Splat4);
			TEXTURE2D(_Normal5);
			TEXTURE2D(_Splat5);
			TEXTURE2D(_Normal6);
			TEXTURE2D(_Splat6);
			TEXTURE2D(_Normal7);
			TEXTURE2D(_Splat7);
			TEXTURE2D(_SnowMapSplat);
			SAMPLER(sampler_SnowMapSplat);
			TEXTURE2D(_SnowMapNormal);
			SAMPLER(sampler_SnowMapNormal);
			TEXTURE2D(_TerrainHolesTexture);
			SAMPLER(sampler_TerrainHolesTexture);
			#ifdef UNITY_INSTANCING_ENABLED//ASE Terrain Instancing
				TEXTURE2D(_TerrainHeightmapTexture);//ASE Terrain Instancing
				TEXTURE2D( _TerrainNormalmapTexture);//ASE Terrain Instancing
				SAMPLER(sampler_TerrainNormalmapTexture);//ASE Terrain Instancing
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
				float2 sampleCoords = ( patchVertex.xy + instanceData.xy ) * instanceData.z;
				float height = UnpackHeightmap( _TerrainHeightmapTexture.Load( int3( sampleCoords, 0 ) ) );
				position.xz = sampleCoords* _TerrainHeightmapScale.xz;
				position.y = height* _TerrainHeightmapScale.y;
				#ifdef ENABLE_TERRAIN_PERPIXEL_NORMAL
					normal = float3(0, 1, 0);
				#else
					normal = _TerrainNormalmapTexture.Load(int3(sampleCoords, 0)).rgb* 2 - 1;
				#endif
				texcoord.xy = sampleCoords* _TerrainHeightmapRecipSize.zw;
			#endif
			}
			

			PackedVaryings VertexFunction( Attributes input  )
			{
				PackedVaryings output = (PackedVaryings)0;
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_TRANSFER_INSTANCE_ID(input, output);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(output);

				#if defined( ASE_INSTANCED_TERRAIN ) && !defined( ASE_TESSELLATION )
					TerrainApplyMeshModification( input.positionOS.xyz, input.normalOS, input.texcoord );
				#endif
				
				float4 appendResult993_g83 = (float4(cross( input.normalOS , float3( 0, 0, 1 ) ) , -1.0));
				
				float2 TecCoord01294_g83 = input.texcoord.xy;
				float2 break291_g83 = _Control_ST.zw;
				float2 appendResult293_g83 = (float2(( break291_g83.x + 0.001 ) , ( break291_g83.y + 0.0001 )));
				float2 vertexToFrag286_g83 = ( ( TecCoord01294_g83 * _Control_ST.xy ) + appendResult293_g83 );
				output.ase_texcoord3.xy = vertexToFrag286_g83;
				float2 break1393_g83 = _Control1_ST.zw;
				float2 appendResult1382_g83 = (float2(( break1393_g83.x + 0.001 ) , ( break1393_g83.y + 0.0001 )));
				float2 vertexToFrag1395_g83 = ( ( TecCoord01294_g83 * _Control1_ST.xy ) + appendResult1382_g83 );
				output.ase_texcoord4.xy = vertexToFrag1395_g83;
				float2 vertexToFrag1085_g83 = ( ( TecCoord01294_g83 * (_SnowMainUVs).xy ) + (_SnowMainUVs).zw );
				output.ase_texcoord4.zw = vertexToFrag1085_g83;
				
				output.ase_texcoord3.zw = input.texcoord.xy;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = input.positionOS.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = defaultVertexValue;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					input.positionOS.xyz = vertexValue;
				#else
					input.positionOS.xyz += vertexValue;
				#endif

				input.normalOS = input.normalOS;
				input.tangentOS = appendResult993_g83;

				VertexPositionInputs vertexInput = GetVertexPositionInputs( input.positionOS.xyz );
				VertexNormalInputs normalInput = GetVertexNormalInputs( input.normalOS, input.tangentOS );

				output.positionCS = vertexInput.positionCS;
				output.positionWS = vertexInput.positionWS;
				output.normalWS = normalInput.normalWS;
				output.tangentWS = float4( normalInput.tangentWS, ( input.tangentOS.w > 0.0 ? 1.0 : -1.0 ) * GetOddNegativeScale() );

				#if defined( ENABLE_TERRAIN_PERPIXEL_NORMAL )
					output.tangentWS.zw = input.texcoord.xy;
					output.tangentWS.xy = input.texcoord.xy * unity_LightmapST.xy + unity_LightmapST.zw;
				#endif
				return output;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 positionOS : INTERNALTESSPOS;
				half3 normalOS : NORMAL;
				half4 tangentOS : TANGENT;
				float4 texcoord : TEXCOORD0;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( Attributes input )
			{
				VertexControl output;
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_TRANSFER_INSTANCE_ID(input, output);
				output.positionOS = input.positionOS;
				output.normalOS = input.normalOS;
				output.tangentOS = input.tangentOS;
				output.texcoord = input.texcoord;
				#if defined( ASE_INSTANCED_TERRAIN )
					TerrainApplyMeshModification( output.positionOS.xyz, output.normalOS, output.texcoord );
				#endif
				
				return output;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> input)
			{
				TessellationFactors output;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(input[0].positionOS, input[1].positionOS, input[2].positionOS, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(input[0].positionOS, input[1].positionOS, input[2].positionOS, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(input[0].positionOS, input[1].positionOS, input[2].positionOS, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				output.edge[0] = tf.x; output.edge[1] = tf.y; output.edge[2] = tf.z; output.inside = tf.w;
				return output;
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
			PackedVaryings DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				Attributes output = (Attributes) 0;
				output.positionOS = patch[0].positionOS * bary.x + patch[1].positionOS * bary.y + patch[2].positionOS * bary.z;
				output.normalOS = patch[0].normalOS * bary.x + patch[1].normalOS * bary.y + patch[2].normalOS * bary.z;
				output.tangentOS = patch[0].tangentOS * bary.x + patch[1].tangentOS * bary.y + patch[2].tangentOS * bary.z;
				output.texcoord = patch[0].texcoord * bary.x + patch[1].texcoord * bary.y + patch[2].texcoord * bary.z;
				
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = output.positionOS.xyz - patch[i].normalOS * (dot(output.positionOS.xyz, patch[i].normalOS) - dot(patch[i].positionOS.xyz, patch[i].normalOS));
				float phongStrength = _TessPhongStrength;
				output.positionOS.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * output.positionOS.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], output);
				return VertexFunction(output);
			}
			#else
			PackedVaryings vert ( Attributes input )
			{
				return VertexFunction( input );
			}
			#endif

			void frag(	PackedVaryings input
						, out half4 outNormalWS : SV_Target0
						#if defined( ASE_DEPTH_WRITE_ON )
						,out float outputDepth : ASE_SV_DEPTH
						#endif
						#ifdef _WRITE_RENDERING_LAYERS
						, out uint outRenderingLayers : SV_Target1
						#endif
						 )
			{
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( input );

				#if defined(MAIN_LIGHT_CALCULATE_SHADOWS) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					float4 shadowCoord = TransformWorldToShadowCoord(input.positionWS);
				#else
					float4 shadowCoord = float4(0, 0, 0, 0);
				#endif

				// @diogo: mikktspace compliant
				float renormFactor = 1.0 / max( FLT_MIN, length( input.normalWS ) );

				float3 PositionWS = input.positionWS;
				float3 PositionRWS = GetCameraRelativePositionWS( input.positionWS );
				float4 ShadowCoord = shadowCoord;
				float4 ScreenPosNorm = float4( GetNormalizedScreenSpaceUV( input.positionCS ), input.positionCS.zw );
				float4 ClipPos = ComputeClipSpacePosition( ScreenPosNorm.xy, input.positionCS.z ) * input.positionCS.w;
				float4 ScreenPos = ComputeScreenPos( ClipPos );
				float3 TangentWS = input.tangentWS.xyz * renormFactor;
				float3 BitangentWS = cross( input.normalWS, input.tangentWS.xyz ) * input.tangentWS.w * renormFactor;
				float3 NormalWS = input.normalWS * renormFactor;

				#if defined( ENABLE_TERRAIN_PERPIXEL_NORMAL )
					float2 sampleCoords = (input.tangentWS.zw / _TerrainHeightmapRecipSize.zw + 0.5f) * _TerrainHeightmapRecipSize.xy;
					NormalWS = TransformObjectToWorldNormal(normalize(SAMPLE_TEXTURE2D(_TerrainNormalmapTexture, sampler_TerrainNormalmapTexture, sampleCoords).rgb * 2 - 1));
					TangentWS = -cross(GetObjectToWorldMatrix()._13_23_33, NormalWS);
					BitangentWS = cross(NormalWS, -TangentWS);
				#endif

				float2 vertexToFrag286_g83 = input.ase_texcoord3.xy;
				float4 Control26_g83 = SAMPLE_TEXTURE2D( _Control, sampler_Control, vertexToFrag286_g83 );
				float2 TecCoord01294_g83 = input.ase_texcoord3.zw;
				float4 Normal0341_g83 = SAMPLE_TEXTURE2D( _Normal0, sampler_Normal0, ( ( TecCoord01294_g83 * _Splat0_ST.xy ) + _Splat0_ST.zw ) );
				float3 unpack490_g83 = UnpackNormalScale( Normal0341_g83, _NormalScale0 );
				unpack490_g83.z = lerp( 1, unpack490_g83.z, saturate(_NormalScale0) );
				float4 Normal1378_g83 = SAMPLE_TEXTURE2D( _Normal1, sampler_Normal0, ( ( TecCoord01294_g83 * _Splat1_ST.xy ) + _Splat1_ST.zw ) );
				float3 unpack496_g83 = UnpackNormalScale( Normal1378_g83, _NormalScale1 );
				unpack496_g83.z = lerp( 1, unpack496_g83.z, saturate(_NormalScale1) );
				float4 Normal2356_g83 = SAMPLE_TEXTURE2D( _Normal2, sampler_Normal0, ( ( TecCoord01294_g83 * _Splat2_ST.xy ) + _Splat2_ST.zw ) );
				float3 unpack494_g83 = UnpackNormalScale( Normal2356_g83, _NormalScale2 );
				unpack494_g83.z = lerp( 1, unpack494_g83.z, saturate(_NormalScale2) );
				float4 Normal3398_g83 = SAMPLE_TEXTURE2D( _Normal3, sampler_Normal0, ( ( TecCoord01294_g83 * _Splat3_ST.xy ) + _Splat3_ST.zw ) );
				float3 unpack491_g83 = UnpackNormalScale( Normal3398_g83, _NormalScale3 );
				unpack491_g83.z = lerp( 1, unpack491_g83.z, saturate(_NormalScale3) );
				float4 weightedBlendVar473_g83 = Control26_g83;
				float3 weightedBlend473_g83 = ( weightedBlendVar473_g83.x*unpack490_g83 + weightedBlendVar473_g83.y*unpack496_g83 + weightedBlendVar473_g83.z*unpack494_g83 + weightedBlendVar473_g83.w*unpack491_g83 );
				float2 vertexToFrag1395_g83 = input.ase_texcoord4.xy;
				float4 Control1922_g83 = SAMPLE_TEXTURE2D( _Control1, sampler_Control1, vertexToFrag1395_g83 );
				float4 Normal4746_g83 = SAMPLE_TEXTURE2D( _Normal4, sampler_Normal0, ( ( TecCoord01294_g83 * _Splat4_ST.xy ) + _Splat4_ST.zw ) );
				float3 unpack856_g83 = UnpackNormalScale( Normal4746_g83, _NormalScale4 );
				unpack856_g83.z = lerp( 1, unpack856_g83.z, saturate(_NormalScale4) );
				float4 Normal5740_g83 = SAMPLE_TEXTURE2D( _Normal5, sampler_Normal0, ( ( TecCoord01294_g83 * _Splat5_ST.xy ) + _Splat5_ST.zw ) );
				float3 unpack857_g83 = UnpackNormalScale( Normal5740_g83, _NormalScale5 );
				unpack857_g83.z = lerp( 1, unpack857_g83.z, saturate(_NormalScale5) );
				float4 Normal6754_g83 = SAMPLE_TEXTURE2D( _Normal6, sampler_Normal0, ( ( TecCoord01294_g83 * _Splat6_ST.xy ) + _Splat6_ST.zw ) );
				float3 unpack858_g83 = UnpackNormalScale( Normal6754_g83, _NormalScale6 );
				unpack858_g83.z = lerp( 1, unpack858_g83.z, saturate(_NormalScale6) );
				float4 Normal7764_g83 = SAMPLE_TEXTURE2D( _Normal7, sampler_Normal0, ( ( TecCoord01294_g83 * _Splat7_ST.xy ) + _Splat7_ST.zw ) );
				float3 unpack854_g83 = UnpackNormalScale( Normal7764_g83, _NormalScale7 );
				unpack854_g83.z = lerp( 1, unpack854_g83.z, saturate(_NormalScale7) );
				float4 weightedBlendVar860_g83 = Control1922_g83;
				float3 weightedBlend860_g83 = ( weightedBlendVar860_g83.x*unpack856_g83 + weightedBlendVar860_g83.y*unpack857_g83 + weightedBlendVar860_g83.z*unpack858_g83 + weightedBlendVar860_g83.w*unpack854_g83 );
				float3 break513_g83 = ( weightedBlend473_g83 + weightedBlend860_g83 );
				float3 appendResult514_g83 = (float3(break513_g83.x , break513_g83.y , ( break513_g83.z + 0.001 )));
				float2 uv_SnowMapSplat = input.ase_texcoord3.zw * _SnowMapSplat_ST.xy + _SnowMapSplat_ST.zw;
				float4 tex2DNode1080_g83 = SAMPLE_TEXTURE2D( _SnowMapSplat, sampler_SnowMapSplat, uv_SnowMapSplat );
				float4 appendResult1076_g83 = (float4(( tex2DNode1080_g83.r * _SnowSplatRSplatBias ) , ( tex2DNode1080_g83.g * _SnowSplatGSplatBias ) , ( tex2DNode1080_g83.b * _SnowSplatBSplatBias ) , ( tex2DNode1080_g83.a * _SnowSplatASplatBias )));
				float4 SnowSplatRGBA1117_g83 = appendResult1076_g83;
				float2 vertexToFrag1085_g83 = input.ase_texcoord4.zw;
				float2 temp_output_1083_0_g83 = ( vertexToFrag1085_g83 * 100.0 );
				float3 unpack1127_g83 = UnpackNormalScale( SAMPLE_TEXTURE2D( _SnowMapNormal, sampler_SnowMapNormal, temp_output_1083_0_g83 ), _SnowNormalStrength );
				unpack1127_g83.z = lerp( 1, unpack1127_g83.z, saturate(_SnowNormalStrength) );
				float3 SnowNormal1090_g83 = unpack1127_g83;
				float SnowEnableRChannel1174_g83 = _SnowSplatREnable;
				float3 lerpResult1221_g83 = lerp( appendResult514_g83 , SnowNormal1090_g83 , SnowEnableRChannel1174_g83);
				float SnowEnableGChannel1175_g83 = _SnowSplatGEnable;
				float3 lerpResult1214_g83 = lerp( appendResult514_g83 , SnowNormal1090_g83 , SnowEnableGChannel1175_g83);
				float SnowEnableBChannel1176_g83 = _SnowSplatBEnable;
				float3 lerpResult1215_g83 = lerp( appendResult514_g83 , SnowNormal1090_g83 , SnowEnableBChannel1176_g83);
				float SnowEnableAChannel1177_g83 = _SnowSplatAEnable;
				float3 lerpResult1216_g83 = lerp( appendResult514_g83 , SnowNormal1090_g83 , SnowEnableAChannel1177_g83);
				float4 weightedBlendVar1220_g83 = SnowSplatRGBA1117_g83;
				float3 weightedBlend1220_g83 = ( weightedBlendVar1220_g83.x*lerpResult1221_g83 + weightedBlendVar1220_g83.y*lerpResult1214_g83 + weightedBlendVar1220_g83.z*lerpResult1215_g83 + weightedBlendVar1220_g83.w*lerpResult1216_g83 );
				float SnowEnable1173_g83 = _SnowEnable;
				float3 lerpResult1222_g83 = lerp( appendResult514_g83 , weightedBlend1220_g83 , SnowEnable1173_g83);
				
				float2 uv_TerrainHolesTexture451_g83 = input.ase_texcoord3.zw;
				float4 tex2DNode451_g83 = SAMPLE_TEXTURE2D( _TerrainHolesTexture, sampler_TerrainHolesTexture, uv_TerrainHolesTexture451_g83 );
				

				float3 Normal = lerpResult1222_g83;
				float Alpha = ( 0.5 + 1E-37 );
				#if defined( _ALPHATEST_ON )
					float AlphaClipThreshold = ( 1.0 - tex2DNode451_g83 ).r;
				#endif

				#if defined( ASE_DEPTH_WRITE_ON )
					input.positionCS.z = input.positionCS.z;
				#endif

				#if defined( _ALPHATEST_ON )
					AlphaDiscard( Alpha, AlphaClipThreshold );
				#endif

				#if defined(LOD_FADE_CROSSFADE)
					LODFadeCrossFade( input.positionCS );
				#endif

				#if defined( ASE_DEPTH_WRITE_ON )
					outputDepth = input.positionCS.z;
				#endif

				#if defined(_GBUFFER_NORMALS_OCT)
					float2 octNormalWS = PackNormalOctQuadEncode(NormalWS);
					float2 remappedOctNormalWS = saturate(octNormalWS * 0.5 + 0.5);
					half3 packedNormalWS = PackFloat2To888(remappedOctNormalWS);
					outNormalWS = half4(packedNormalWS, 0.0);
				#else
					#if defined(_NORMALMAP)
						#if _NORMAL_DROPOFF_TS
							float3 normalWS = TransformTangentToWorld(Normal, half3x3(TangentWS, BitangentWS, NormalWS));
						#elif _NORMAL_DROPOFF_OS
							float3 normalWS = TransformObjectToWorldNormal(Normal);
						#elif _NORMAL_DROPOFF_WS
							float3 normalWS = Normal;
						#endif
					#else
						float3 normalWS = NormalWS;
					#endif
					outNormalWS = half4(NormalizeNormalPerPixel(normalWS), 0.0);
				#endif

				#ifdef _WRITE_RENDERING_LAYERS
					outRenderingLayers = EncodeMeshRenderingLayer();
				#endif
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "GBuffer"
			Tags { "LightMode"="UniversalGBuffer" }

			Blend One Zero, One Zero
			ZWrite On
			ZTest LEqual
			Offset 0 , 0
			ColorMask RGBA
			

			HLSLPROGRAM

			#define _ALPHATEST_ON
			#define _NORMAL_DROPOFF_TS 1
			#pragma shader_feature_local_fragment _RECEIVE_SHADOWS_OFF
			#pragma shader_feature_local_fragment _SPECULARHIGHLIGHTS_OFF
			#pragma shader_feature_local_fragment _ENVIRONMENTREFLECTIONS_OFF
			#define ASE_FOG 1
			#pragma multi_compile_fragment _ DEBUG_DISPLAY
			#define ASE_TERRAIN
			#pragma shader_feature _INSTANCEDTERRAINNORMALS_PIXEL
			#define _SPECULAR_SETUP 1
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#define _NORMALMAP 1
			#define ASE_VERSION 19907
			#define ASE_SRP_VERSION 170300
			#define ASE_USING_SAMPLING_MACROS 1


			// Deferred Rendering Path does not support the OpenGL-based graphics API:
			// Desktop OpenGL, OpenGL ES 3.0, WebGL 2.0.
			#pragma exclude_renderers glcore gles3 switch2 webgpu 

			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
			#pragma multi_compile _ EVALUATE_SH_MIXED EVALUATE_SH_VERTEX
			#pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
			#pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
			#pragma multi_compile_fragment _ _SHADOWS_SOFT _SHADOWS_SOFT_LOW _SHADOWS_SOFT_MEDIUM _SHADOWS_SOFT_HIGH
			#pragma multi_compile_fragment _ _SCREEN_SPACE_IRRADIANCE
			#pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
			#pragma multi_compile_fragment _ _GBUFFER_NORMALS_OCT
			#pragma multi_compile_fragment _ _RENDER_PASS_ENABLED
			#pragma multi_compile _ _CLUSTER_LIGHT_LOOP

			#pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
			#pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
			#pragma multi_compile _ SHADOWS_SHADOWMASK
			#pragma multi_compile _ DIRLIGHTMAP_COMBINED
			#pragma multi_compile _ USE_LEGACY_LIGHTMAPS
			#pragma multi_compile _ LIGHTMAP_ON
			#pragma multi_compile_fragment _ LIGHTMAP_BICUBIC_SAMPLING
			#pragma multi_compile_fragment _ REFLECTION_PROBE_ROTATION
			#pragma multi_compile _ DYNAMICLIGHTMAP_ON

			#pragma vertex vert
			#pragma fragment frag

			#if defined( _SPECULAR_SETUP ) && defined( ASE_LIGHTING_SIMPLE )
				#if defined( _SPECULARHIGHLIGHTS_OFF )
					#undef _SPECULAR_COLOR
				#else
					#define _SPECULAR_COLOR
				#endif
			#endif

			#define SHADERPASS SHADERPASS_GBUFFER

			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
			#include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ProbeVolumeVariants.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#if defined(LOD_FADE_CROSSFADE)
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
            #endif

			#if defined( UNITY_INSTANCING_ENABLED ) && defined( ASE_INSTANCED_TERRAIN ) && ( defined(_TERRAIN_INSTANCED_PERPIXEL_NORMAL) || defined(_INSTANCEDTERRAINNORMALS_PIXEL) )
				#define ENABLE_TERRAIN_PERPIXEL_NORMAL
			#endif

			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_TEXTURE_COORDINATES0
			#define ASE_NEEDS_VERT_TEXTURE_COORDINATES0
			#define ASE_NEEDS_FRAG_TEXTURE_COORDINATES0
			#define ASE_NEEDS_WORLD_POSITION
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_INSTANCED_TERRAIN
			#define ASE_NEEDS_VERT_POSITION
			#pragma multi_compile_instancing
			#pragma instancing_options assumeuniformscaling nomatrices nolightprobe nolightmap
			#define TERRAIN_SPLAT_FIRSTPASS 1
			#define _LAYER_COUNT 8
			#pragma shader_feature_local _TERRAIN_8_LAYERS
			#pragma editor_sync_compilation
			#pragma shader_feature_local _NORMALMAP
			#pragma shader_feature_local _MASKMAP


			#if defined(ASE_EARLY_Z_DEPTH_OPTIMIZE) && (SHADER_TARGET >= 45)
				#define ASE_SV_DEPTH SV_DepthLessEqual
				#define ASE_SV_POSITION_QUALIFIERS linear noperspective centroid
			#else
				#define ASE_SV_DEPTH SV_Depth
				#define ASE_SV_POSITION_QUALIFIERS
			#endif

			struct Attributes
			{
				float4 positionOS : POSITION;
				half3 normalOS : NORMAL;
				half4 tangentOS : TANGENT;
				float4 texcoord : TEXCOORD0;
				#if defined(LIGHTMAP_ON) || defined(ASE_NEEDS_TEXTURE_COORDINATES1)
					float4 texcoord1 : TEXCOORD1;
				#endif
				#if defined(DYNAMICLIGHTMAP_ON) || defined(ASE_NEEDS_TEXTURE_COORDINATES2)
					float4 texcoord2 : TEXCOORD2;
				#endif
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct PackedVaryings
			{
				ASE_SV_POSITION_QUALIFIERS float4 positionCS : SV_POSITION;
				float3 positionWS : TEXCOORD0;
				half3 normalWS : TEXCOORD1;
				float4 tangentWS : TEXCOORD2; // holds terrainUV ifdef ENABLE_TERRAIN_PERPIXEL_NORMAL
				float4 lightmapUVOrVertexSH : TEXCOORD3;
				#if defined(ASE_FOG) || defined(_ADDITIONAL_LIGHTS_VERTEX)
					half4 fogFactorAndVertexLight : TEXCOORD4;
				#endif
				#if defined(DYNAMICLIGHTMAP_ON)
					float2 dynamicLightmapUV : TEXCOORD5;
				#endif
				#if defined(USE_APV_PROBE_OCCLUSION)
					float4 probeOcclusion : TEXCOORD6;
				#endif
				float4 ase_texcoord7 : TEXCOORD7;
				float4 ase_texcoord8 : TEXCOORD8;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _Control_ST;
			float4 _MaskMapRemapScale4;
			float4 _MaskMapRemapOffset4;
			float4 _MaskMapRemapScale3;
			half4 _SnowColor;
			float4 _SnowMainUVs;
			float4 _MaskMapRemapOffset3;
			float4 _MaskMapRemapOffset2;
			float4 _MaskMapRemapScale1;
			float4 _MaskMapRemapOffset1;
			float4 _SnowMapSplat_ST;
			float4 _MaskMapRemapScale0;
			float4 _Specular7;
			float4 _Specular6;
			float4 _Specular5;
			float4 _MaskMapRemapScale7;
			float4 _Specular4;
			float4 _Specular3;
			float4 _Specular2;
			float4 _Specular1;
			float4 _Specular0;
			float4 _MaskMapRemapOffset0;
			float4 _Splat7_ST;
			float4 _MaskMapRemapScale2;
			float4 _MaskMapRemapOffset5;
			float4 _DiffuseRemapScale7;
			float4 _MaskMapRemapScale6;
			float4 _Splat2_ST;
			float4 _DiffuseRemapScale2;
			float4 _DiffuseRemapScale3;
			float4 _Splat3_ST;
			float4 _Splat1_ST;
			float4 _MaskMapRemapOffset6;
			float4 _DiffuseRemapScale1;
			float4 _DiffuseRemapScale4;
			float4 _Control1_ST;
			float4 _Splat0_ST;
			float4 _Splat6_ST;
			float4 _DiffuseRemapScale6;
			float4 _MaskMapRemapOffset7;
			float4 _Splat5_ST;
			float4 _MaskMapRemapScale5;
			float4 _DiffuseRemapScale0;
			float4 _Splat4_ST;
			float4 _DiffuseRemapScale5;
			half _SnowNormalStrength;
			float _LayerHasMask6;
			float _OpacityAsDensity1;
			half _NormalScale7;
			float _Smoothness0;
			float _OpacityAsDensity0;
			float _Smoothness1;
			float _Smoothness2;
			float _OpacityAsDensity5;
			float _Smoothness3;
			float _LayerHasMask4;
			float _LayerHasMask3;
			float _LayerHasMask5;
			float _LayerHasMask2;
			half _NormalScale6;
			float _LayerHasMask1;
			float _LayerHasMask0;
			float _OpacityAsDensity7;
			float _Smoothness7;
			float _OpacityAsDensity6;
			float _Smoothness6;
			float _Smoothness5;
			float _OpacityAsDensity4;
			float _Smoothness4;
			float _OpacityAsDensity3;
			float _OpacityAsDensity2;
			half _NormalScale5;
			float _Metallic2;
			half _NormalScale3;
			half _SnowSplatGBlendFalloff;
			half _SnowSplatGBlendFactor;
			half _SnowSplatREnable;
			half _SnowSplatRMax;
			half _SnowSplatRMin;
			half _SnowSplatRBlendStrength;
			half _SnowSplatRBlendFalloff;
			half _SnowSplatRBlendFactor;
			half _SnowBrightness;
			half _SnowSaturation;
			half _SnowSplatGBlendStrength;
			half _SnowSplatASplatBias;
			half _SnowSplatGSplatBias;
			half _SnowSplatRSplatBias;
			half _Splat7Brightness;
			half _Splat6Brightness;
			half _Splat5Brightness;
			half _Splat4Brightness;
			half _Splat3Brightness;
			half _Splat2Brightness;
			half _Splat1Brightness;
			half _Splat0Brightness;
			half _SnowSplatBSplatBias;
			half _SnowSplatGMin;
			half _SnowSplatGMax;
			half _SnowSplatGEnable;
			half _NormalScale2;
			half _NormalScale1;
			half _NormalScale0;
			float _Metallic7;
			float _Metallic6;
			float _Metallic5;
			float _Metallic4;
			float _Metallic3;
			float _Metallic1;
			float _Metallic0;
			half _SnowEnable;
			half _SnowSplatAEnable;
			half _SnowSplatAMax;
			half _SnowSplatAMin;
			half _SnowSplatABlendStrength;
			half _SnowSplatABlendFalloff;
			half _SnowSplatABlendFactor;
			half _SnowSplatBEnable;
			half _SnowSplatBMax;
			half _SnowSplatBMin;
			half _SnowSplatBBlendStrength;
			half _SnowSplatBBlendFalloff;
			half _SnowSplatBBlendFactor;
			half _NormalScale4;
			float _LayerHasMask7;
			float _AlphaClip;
			float _Cutoff;
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
			CBUFFER_END

			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			TEXTURE2D(_Control);
			SAMPLER(sampler_Control);
			TEXTURE2D(_Splat0);
			SAMPLER(sampler_Splat0);
			TEXTURE2D(_Splat1);
			TEXTURE2D(_Splat2);
			TEXTURE2D(_Splat3);
			TEXTURE2D(_Control1);
			SAMPLER(sampler_Control1);
			TEXTURE2D(_Splat4);
			TEXTURE2D(_Splat5);
			TEXTURE2D(_Splat6);
			TEXTURE2D(_Splat7);
			TEXTURE2D(_TerrainHolesTexture);
			SAMPLER(sampler_TerrainHolesTexture);
			TEXTURE2D(_SnowMapSplat);
			SAMPLER(sampler_SnowMapSplat);
			TEXTURE2D(_SnowMapBaseColor);
			SAMPLER(sampler_SnowMapBaseColor);
			TEXTURE2D(_Mask0);
			SAMPLER(sampler_Mask0);
			TEXTURE2D(_Mask1);
			TEXTURE2D(_Mask2);
			TEXTURE2D(_Mask3);
			TEXTURE2D(_Mask4);
			TEXTURE2D(_Mask5);
			TEXTURE2D(_Mask6);
			TEXTURE2D(_Mask7);
			TEXTURE2D(_Normal0);
			SAMPLER(sampler_Normal0);
			TEXTURE2D(_Normal1);
			TEXTURE2D(_Normal2);
			TEXTURE2D(_Normal3);
			TEXTURE2D(_Normal4);
			TEXTURE2D(_Normal5);
			TEXTURE2D(_Normal6);
			TEXTURE2D(_Normal7);
			TEXTURE2D(_SnowMapNormal);
			SAMPLER(sampler_SnowMapNormal);
			#ifdef UNITY_INSTANCING_ENABLED//ASE Terrain Instancing
				TEXTURE2D(_TerrainHeightmapTexture);//ASE Terrain Instancing
				TEXTURE2D( _TerrainNormalmapTexture);//ASE Terrain Instancing
				SAMPLER(sampler_TerrainNormalmapTexture);//ASE Terrain Instancing
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


			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/GBufferOutput.hlsl"

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
				float2 sampleCoords = ( patchVertex.xy + instanceData.xy ) * instanceData.z;
				float height = UnpackHeightmap( _TerrainHeightmapTexture.Load( int3( sampleCoords, 0 ) ) );
				position.xz = sampleCoords* _TerrainHeightmapScale.xz;
				position.y = height* _TerrainHeightmapScale.y;
				#ifdef ENABLE_TERRAIN_PERPIXEL_NORMAL
					normal = float3(0, 1, 0);
				#else
					normal = _TerrainNormalmapTexture.Load(int3(sampleCoords, 0)).rgb* 2 - 1;
				#endif
				texcoord.xy = sampleCoords* _TerrainHeightmapRecipSize.zw;
			#endif
			}
			

			PackedVaryings VertexFunction( Attributes input  )
			{
				PackedVaryings output = (PackedVaryings)0;
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_TRANSFER_INSTANCE_ID(input, output);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(output);

				#if defined( ASE_INSTANCED_TERRAIN ) && !defined( ASE_TESSELLATION )
					TerrainApplyMeshModification( input.positionOS.xyz, input.normalOS, input.texcoord );
				#endif
				
				float4 appendResult993_g83 = (float4(cross( input.normalOS , float3( 0, 0, 1 ) ) , -1.0));
				
				float2 TecCoord01294_g83 = input.texcoord.xy;
				float2 break291_g83 = _Control_ST.zw;
				float2 appendResult293_g83 = (float2(( break291_g83.x + 0.001 ) , ( break291_g83.y + 0.0001 )));
				float2 vertexToFrag286_g83 = ( ( TecCoord01294_g83 * _Control_ST.xy ) + appendResult293_g83 );
				output.ase_texcoord7.xy = vertexToFrag286_g83;
				float2 break1393_g83 = _Control1_ST.zw;
				float2 appendResult1382_g83 = (float2(( break1393_g83.x + 0.001 ) , ( break1393_g83.y + 0.0001 )));
				float2 vertexToFrag1395_g83 = ( ( TecCoord01294_g83 * _Control1_ST.xy ) + appendResult1382_g83 );
				output.ase_texcoord8.xy = vertexToFrag1395_g83;
				float2 vertexToFrag1085_g83 = ( ( TecCoord01294_g83 * (_SnowMainUVs).xy ) + (_SnowMainUVs).zw );
				output.ase_texcoord8.zw = vertexToFrag1085_g83;
				
				output.ase_texcoord7.zw = input.texcoord.xy;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = input.positionOS.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = defaultVertexValue;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					input.positionOS.xyz = vertexValue;
				#else
					input.positionOS.xyz += vertexValue;
				#endif

				input.normalOS = input.normalOS;
				input.tangentOS = appendResult993_g83;

				VertexPositionInputs vertexInput = GetVertexPositionInputs( input.positionOS.xyz );
				VertexNormalInputs normalInput = GetVertexNormalInputs( input.normalOS, input.tangentOS );

				OUTPUT_LIGHTMAP_UV(input.texcoord1, unity_LightmapST, output.lightmapUVOrVertexSH.xy);
				#if defined(DYNAMICLIGHTMAP_ON)
					output.dynamicLightmapUV.xy = input.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
				#endif
				OUTPUT_SH4(vertexInput.positionWS, normalInput.normalWS.xyz, GetWorldSpaceNormalizeViewDir(vertexInput.positionWS), output.lightmapUVOrVertexSH.xyz, output.probeOcclusion);

				#if defined(ASE_FOG) || defined(_ADDITIONAL_LIGHTS_VERTEX)
					output.fogFactorAndVertexLight = 0;
					#if defined(ASE_FOG) && !defined(_FOG_FRAGMENT)
						// @diogo: no fog applied in GBuffer
					#endif
					#ifdef _ADDITIONAL_LIGHTS_VERTEX
						half3 vertexLight = VertexLighting( vertexInput.positionWS, normalInput.normalWS );
						output.fogFactorAndVertexLight.yzw = vertexLight;
					#endif
				#endif

				output.positionCS = vertexInput.positionCS;
				output.positionWS = vertexInput.positionWS;
				output.normalWS = normalInput.normalWS;
				output.tangentWS = float4( normalInput.tangentWS, ( input.tangentOS.w > 0.0 ? 1.0 : -1.0 ) * GetOddNegativeScale() );

				#if defined( ENABLE_TERRAIN_PERPIXEL_NORMAL )
					output.tangentWS.zw = input.texcoord.xy;
					output.tangentWS.xy = input.texcoord.xy * unity_LightmapST.xy + unity_LightmapST.zw;
				#endif
				return output;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 positionOS : INTERNALTESSPOS;
				half3 normalOS : NORMAL;
				half4 tangentOS : TANGENT;
				float4 texcoord : TEXCOORD0;
				#if defined(LIGHTMAP_ON) || defined(ASE_NEEDS_TEXTURE_COORDINATES1)
					float4 texcoord1 : TEXCOORD1;
				#endif
				#if defined(DYNAMICLIGHTMAP_ON) || defined(ASE_NEEDS_TEXTURE_COORDINATES2)
					float4 texcoord2 : TEXCOORD2;
				#endif
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( Attributes input )
			{
				VertexControl output;
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_TRANSFER_INSTANCE_ID(input, output);
				output.positionOS = input.positionOS;
				output.normalOS = input.normalOS;
				output.tangentOS = input.tangentOS;
				output.texcoord = input.texcoord;
				#if defined(LIGHTMAP_ON) || defined(ASE_NEEDS_TEXTURE_COORDINATES1)
					output.texcoord1 = input.texcoord1;
				#endif
				#if defined(DYNAMICLIGHTMAP_ON) || defined(ASE_NEEDS_TEXTURE_COORDINATES2)
					output.texcoord2 = input.texcoord2;
				#endif
				#if defined( ASE_INSTANCED_TERRAIN )
					TerrainApplyMeshModification( output.positionOS.xyz, output.normalOS, output.texcoord );
				#endif
				
				return output;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> input)
			{
				TessellationFactors output;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(input[0].positionOS, input[1].positionOS, input[2].positionOS, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(input[0].positionOS, input[1].positionOS, input[2].positionOS, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(input[0].positionOS, input[1].positionOS, input[2].positionOS, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				output.edge[0] = tf.x; output.edge[1] = tf.y; output.edge[2] = tf.z; output.inside = tf.w;
				return output;
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
			PackedVaryings DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				Attributes output = (Attributes) 0;
				output.positionOS = patch[0].positionOS * bary.x + patch[1].positionOS * bary.y + patch[2].positionOS * bary.z;
				output.normalOS = patch[0].normalOS * bary.x + patch[1].normalOS * bary.y + patch[2].normalOS * bary.z;
				output.tangentOS = patch[0].tangentOS * bary.x + patch[1].tangentOS * bary.y + patch[2].tangentOS * bary.z;
				output.texcoord = patch[0].texcoord * bary.x + patch[1].texcoord * bary.y + patch[2].texcoord * bary.z;
				#if defined(LIGHTMAP_ON) || defined(ASE_NEEDS_TEXTURE_COORDINATES1)
					output.texcoord1 = patch[0].texcoord1 * bary.x + patch[1].texcoord1 * bary.y + patch[2].texcoord1 * bary.z;
				#endif
				#if defined(DYNAMICLIGHTMAP_ON) || defined(ASE_NEEDS_TEXTURE_COORDINATES2)
					output.texcoord2 = patch[0].texcoord2 * bary.x + patch[1].texcoord2 * bary.y + patch[2].texcoord2 * bary.z;
				#endif
				
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = output.positionOS.xyz - patch[i].normalOS * (dot(output.positionOS.xyz, patch[i].normalOS) - dot(patch[i].positionOS.xyz, patch[i].normalOS));
				float phongStrength = _TessPhongStrength;
				output.positionOS.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * output.positionOS.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], output);
				return VertexFunction(output);
			}
			#else
			PackedVaryings vert ( Attributes input )
			{
				return VertexFunction( input );
			}
			#endif

			GBufferFragOutput frag ( PackedVaryings input
								#if defined( ASE_DEPTH_WRITE_ON )
								,out float outputDepth : ASE_SV_DEPTH
								#endif
								 )
			{
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input);

				#if defined(LOD_FADE_CROSSFADE)
					LODFadeCrossFade( input.positionCS );
				#endif

				#if defined(MAIN_LIGHT_CALCULATE_SHADOWS)
					float4 shadowCoord = TransformWorldToShadowCoord( input.positionWS );
				#else
					float4 shadowCoord = float4(0, 0, 0, 0);
				#endif

				// @diogo: mikktspace compliant
				float renormFactor = 1.0 / max( FLT_MIN, length( input.normalWS ) );

				float3 PositionWS = input.positionWS;
				float3 PositionRWS = GetCameraRelativePositionWS( PositionWS );
				float3 ViewDirWS = GetWorldSpaceNormalizeViewDir( PositionWS );
				float4 ShadowCoord = shadowCoord;
				float4 ScreenPosNorm = float4( GetNormalizedScreenSpaceUV( input.positionCS ), input.positionCS.zw );
				float4 ClipPos = ComputeClipSpacePosition( ScreenPosNorm.xy, input.positionCS.z ) * input.positionCS.w;
				float4 ScreenPos = ComputeScreenPos( ClipPos );
				float3 TangentWS = input.tangentWS.xyz * renormFactor;
				float3 BitangentWS = cross( input.normalWS, input.tangentWS.xyz ) * input.tangentWS.w * renormFactor;
				float3 NormalWS = input.normalWS * renormFactor;

				#if defined( ENABLE_TERRAIN_PERPIXEL_NORMAL )
					float2 sampleCoords = (input.tangentWS.zw / _TerrainHeightmapRecipSize.zw + 0.5f) * _TerrainHeightmapRecipSize.xy;
					NormalWS = TransformObjectToWorldNormal(normalize(SAMPLE_TEXTURE2D(_TerrainNormalmapTexture, sampler_TerrainNormalmapTexture, sampleCoords).rgb * 2 - 1));
					TangentWS = -cross(GetObjectToWorldMatrix()._13_23_33, NormalWS);
					BitangentWS = cross(NormalWS, -TangentWS);
				#endif

				float2 vertexToFrag286_g83 = input.ase_texcoord7.xy;
				float4 Control26_g83 = SAMPLE_TEXTURE2D( _Control, sampler_Control, vertexToFrag286_g83 );
				float2 TecCoord01294_g83 = input.ase_texcoord7.zw;
				float3 Splat0342_g83 = (SAMPLE_TEXTURE2D( _Splat0, sampler_Splat0, ( ( TecCoord01294_g83 * _Splat0_ST.xy ) + _Splat0_ST.zw ) )).rgb;
				float3 temp_output_35_0_g83 = ( (_DiffuseRemapScale0).xyz * Splat0342_g83 * _Splat0Brightness );
				float3 Splat1379_g83 = (SAMPLE_TEXTURE2D( _Splat1, sampler_Splat0, ( ( TecCoord01294_g83 * _Splat1_ST.xy ) + _Splat1_ST.zw ) )).rgb;
				float3 temp_output_38_0_g83 = ( (_DiffuseRemapScale1).xyz * Splat1379_g83 * _Splat1Brightness );
				float3 Splat2357_g83 = (SAMPLE_TEXTURE2D( _Splat2, sampler_Splat0, ( ( TecCoord01294_g83 * _Splat2_ST.xy ) + _Splat2_ST.zw ) )).rgb;
				float3 temp_output_41_0_g83 = ( (_DiffuseRemapScale2).xyz * Splat2357_g83 * _Splat2Brightness );
				float3 Splat3390_g83 = (SAMPLE_TEXTURE2D( _Splat3, sampler_Splat0, ( ( TecCoord01294_g83 * _Splat3_ST.xy ) + _Splat3_ST.zw ) )).rgb;
				float3 temp_output_44_0_g83 = ( (_DiffuseRemapScale3).xyz * Splat3390_g83 * _Splat3Brightness );
				float4 weightedBlendVar9_g83 = Control26_g83;
				float3 weightedBlend9_g83 = ( weightedBlendVar9_g83.x*temp_output_35_0_g83 + weightedBlendVar9_g83.y*temp_output_38_0_g83 + weightedBlendVar9_g83.z*temp_output_41_0_g83 + weightedBlendVar9_g83.w*temp_output_44_0_g83 );
				float2 vertexToFrag1395_g83 = input.ase_texcoord8.xy;
				float4 Control1922_g83 = SAMPLE_TEXTURE2D( _Control1, sampler_Control1, vertexToFrag1395_g83 );
				float3 Splat4752_g83 = (SAMPLE_TEXTURE2D( _Splat4, sampler_Splat0, ( ( TecCoord01294_g83 * _Splat4_ST.xy ) + _Splat4_ST.zw ) )).rgb;
				float3 temp_output_900_0_g83 = ( (_DiffuseRemapScale4).xyz * Splat4752_g83 * _Splat4Brightness );
				float3 Splat5743_g83 = (SAMPLE_TEXTURE2D( _Splat5, sampler_Splat0, ( ( TecCoord01294_g83 * _Splat5_ST.xy ) + _Splat5_ST.zw ) )).rgb;
				float3 temp_output_901_0_g83 = ( (_DiffuseRemapScale5).xyz * Splat5743_g83 * _Splat5Brightness );
				float3 Splat6759_g83 = (SAMPLE_TEXTURE2D( _Splat6, sampler_Splat0, ( ( TecCoord01294_g83 * _Splat6_ST.xy ) + _Splat6_ST.zw ) )).rgb;
				float3 temp_output_919_0_g83 = ( (_DiffuseRemapScale6).xyz * Splat6759_g83 * _Splat6Brightness );
				float3 Splat7762_g83 = (SAMPLE_TEXTURE2D( _Splat7, sampler_Splat0, ( ( TecCoord01294_g83 * _Splat7_ST.xy ) + _Splat7_ST.zw ) )).rgb;
				float3 temp_output_921_0_g83 = ( (_DiffuseRemapScale7).xyz * Splat7762_g83 * _Splat7Brightness );
				float4 weightedBlendVar912_g83 = Control1922_g83;
				float3 weightedBlend912_g83 = ( weightedBlendVar912_g83.x*temp_output_900_0_g83 + weightedBlendVar912_g83.y*temp_output_901_0_g83 + weightedBlendVar912_g83.z*temp_output_919_0_g83 + weightedBlendVar912_g83.w*temp_output_921_0_g83 );
				float3 localClipHoles453_g83 = ( ( weightedBlend9_g83 + weightedBlend912_g83 ) );
				float2 uv_TerrainHolesTexture451_g83 = input.ase_texcoord7.zw;
				float Hole453_g83 = SAMPLE_TEXTURE2D( _TerrainHolesTexture, sampler_TerrainHolesTexture, uv_TerrainHolesTexture451_g83 ).r;
				{
				#ifdef _ALPHATEST_ON
				clip(Hole453_g83 == 0.0005f? -1 : 1);
				#endif
				}
				float2 uv_SnowMapSplat = input.ase_texcoord7.zw * _SnowMapSplat_ST.xy + _SnowMapSplat_ST.zw;
				float4 tex2DNode1080_g83 = SAMPLE_TEXTURE2D( _SnowMapSplat, sampler_SnowMapSplat, uv_SnowMapSplat );
				float4 appendResult1076_g83 = (float4(( tex2DNode1080_g83.r * _SnowSplatRSplatBias ) , ( tex2DNode1080_g83.g * _SnowSplatGSplatBias ) , ( tex2DNode1080_g83.b * _SnowSplatBSplatBias ) , ( tex2DNode1080_g83.a * _SnowSplatASplatBias )));
				float4 SnowSplatRGBA1117_g83 = appendResult1076_g83;
				float2 vertexToFrag1085_g83 = input.ase_texcoord8.zw;
				float2 temp_output_1083_0_g83 = ( vertexToFrag1085_g83 * 100.0 );
				float3 temp_output_12_0_g84 = (SAMPLE_TEXTURE2D( _SnowMapBaseColor, sampler_SnowMapBaseColor, temp_output_1083_0_g83 )).rgb;
				float dotResult28_g84 = dot( float3( 0.2126729, 0.7151522, 0.072175 ) , temp_output_12_0_g84 );
				float3 temp_cast_0 = (dotResult28_g84).xxx;
				float temp_output_21_0_g84 = ( 1.0 - _SnowSaturation );
				float3 lerpResult31_g84 = lerp( temp_cast_0 , temp_output_12_0_g84 , temp_output_21_0_g84);
				float3 SnowBaseColor1112_g83 = ( (_SnowColor).rgb * lerpResult31_g84 * _SnowBrightness );
				float4 break1118_g83 = appendResult1076_g83;
				float SnowSplatR1119_g83 = break1118_g83.x;
				float saferPower1027_g83 = abs( max( ( SnowSplatR1119_g83 * ( 1.0 + _SnowSplatRBlendFactor ) ), 0.0 ) );
				float lerpResult1029_g83 = lerp( 0.0 , pow( saferPower1027_g83 , ( 1.0 - _SnowSplatRBlendFalloff ) ) ,  (-1.0 + ( _SnowSplatRBlendStrength - 0.0 ) * ( 0.0 - -1.0 ) / ( 1.0 - 0.0 ) ));
				float3 WorldPosition1123_g83 = PositionWS;
				float smoothstepResult1053_g83 = smoothstep( _SnowSplatRMin , _SnowSplatRMax , WorldPosition1123_g83.y);
				float lerpResult1124_g83 = lerp( 0.0 , saturate( lerpResult1029_g83 ) , smoothstepResult1053_g83);
				float SnowSplatRMask1071_g83 = lerpResult1124_g83;
				float3 lerpResult1159_g83 = lerp( localClipHoles453_g83 , SnowBaseColor1112_g83 , SnowSplatRMask1071_g83);
				float3 lerpResult1133_g83 = lerp( localClipHoles453_g83 , lerpResult1159_g83 , _SnowSplatREnable);
				float SnowSplatG1081_g83 = break1118_g83.y;
				float saferPower1021_g83 = abs( max( ( SnowSplatG1081_g83 * ( 1.0 + _SnowSplatGBlendFactor ) ), 0.0 ) );
				float lerpResult1022_g83 = lerp( 0.0 , pow( saferPower1021_g83 , ( 1.0 - _SnowSplatGBlendFalloff ) ) ,  (-1.0 + ( _SnowSplatGBlendStrength - 0.0 ) * ( 0.0 - -1.0 ) / ( 1.0 - 0.0 ) ));
				float smoothstepResult1060_g83 = smoothstep( _SnowSplatGMin , _SnowSplatGMax , WorldPosition1123_g83.y);
				float lerpResult1036_g83 = lerp( 0.0 , saturate( lerpResult1022_g83 ) , smoothstepResult1060_g83);
				float SnowSplatGMask1072_g83 = lerpResult1036_g83;
				float3 lerpResult1158_g83 = lerp( localClipHoles453_g83 , SnowBaseColor1112_g83 , SnowSplatGMask1072_g83);
				float3 lerpResult1134_g83 = lerp( localClipHoles453_g83 , lerpResult1158_g83 , _SnowSplatGEnable);
				float SnowSplatB1120_g83 = break1118_g83.z;
				float saferPower1065_g83 = abs( max( ( SnowSplatB1120_g83 * ( 1.0 + _SnowSplatBBlendFactor ) ), 0.0 ) );
				float lerpResult1064_g83 = lerp( 0.0 , pow( saferPower1065_g83 , ( 1.0 - _SnowSplatBBlendFalloff ) ) ,  (-1.0 + ( _SnowSplatBBlendStrength - 0.0 ) * ( 0.0 - -1.0 ) / ( 1.0 - 0.0 ) ));
				float smoothstepResult1037_g83 = smoothstep( _SnowSplatBMin , _SnowSplatBMax , WorldPosition1123_g83.y);
				float lerpResult1038_g83 = lerp( 0.0 , saturate( lerpResult1064_g83 ) , smoothstepResult1037_g83);
				float SnowSplatBMask1073_g83 = lerpResult1038_g83;
				float3 lerpResult1160_g83 = lerp( localClipHoles453_g83 , SnowBaseColor1112_g83 , SnowSplatBMask1073_g83);
				float3 lerpResult1163_g83 = lerp( localClipHoles453_g83 , lerpResult1160_g83 , _SnowSplatBEnable);
				float SnowSplatA1121_g83 = break1118_g83.w;
				float saferPower1007_g83 = abs( max( ( SnowSplatA1121_g83 * ( 1.0 + _SnowSplatABlendFactor ) ), 0.0 ) );
				float lerpResult1008_g83 = lerp( 0.0 , pow( saferPower1007_g83 , ( 1.0 - _SnowSplatABlendFalloff ) ) ,  (-1.0 + ( _SnowSplatABlendStrength - 0.0 ) * ( 0.0 - -1.0 ) / ( 1.0 - 0.0 ) ));
				float smoothstepResult1043_g83 = smoothstep( _SnowSplatAMin , _SnowSplatAMax , WorldPosition1123_g83.y);
				float lerpResult1126_g83 = lerp( 0.0 , saturate( lerpResult1008_g83 ) , smoothstepResult1043_g83);
				float SnowSplatAMask1074_g83 = lerpResult1126_g83;
				float3 lerpResult1161_g83 = lerp( localClipHoles453_g83 , SnowBaseColor1112_g83 , SnowSplatAMask1074_g83);
				float3 lerpResult1162_g83 = lerp( localClipHoles453_g83 , lerpResult1161_g83 , _SnowSplatAEnable);
				float4 weightedBlendVar1136_g83 = SnowSplatRGBA1117_g83;
				float3 weightedBlend1136_g83 = ( weightedBlendVar1136_g83.x*lerpResult1133_g83 + weightedBlendVar1136_g83.y*lerpResult1134_g83 + weightedBlendVar1136_g83.z*lerpResult1163_g83 + weightedBlendVar1136_g83.w*lerpResult1162_g83 );
				float3 lerpResult1142_g83 = lerp( localClipHoles453_g83 , weightedBlend1136_g83 , _SnowEnable);
				float4 break2097_g83 = SAMPLE_TEXTURE2D( _Mask0, sampler_Mask0, ( ( TecCoord01294_g83 * _Splat0_ST.xy ) + _Splat0_ST.zw ) );
				float Mask0R334_g83 = break2097_g83.r;
				float4 break2193_g83 = SAMPLE_TEXTURE2D( _Mask1, sampler_Mask0, ( ( TecCoord01294_g83 * _Splat1_ST.xy ) + _Splat1_ST.zw ) );
				float Mask1R370_g83 = break2193_g83.r;
				float4 break2262_g83 = SAMPLE_TEXTURE2D( _Mask2, sampler_Mask0, ( ( TecCoord01294_g83 * _Splat2_ST.xy ) + _Splat2_ST.zw ) );
				float Mask2R359_g83 = break2262_g83.r;
				float4 break2342_g83 = SAMPLE_TEXTURE2D( _Mask3, sampler_Mask0, ( ( TecCoord01294_g83 * _Splat3_ST.xy ) + _Splat3_ST.zw ) );
				float Mask3R388_g83 = break2342_g83.r;
				float4 weightedBlendVar536_g83 = Control26_g83;
				float weightedBlend536_g83 = ( weightedBlendVar536_g83.x*( _Metallic0 * Mask0R334_g83 ) + weightedBlendVar536_g83.y*( _Metallic1 * Mask1R370_g83 ) + weightedBlendVar536_g83.z*( _Metallic2 * Mask2R359_g83 ) + weightedBlendVar536_g83.w*( _Metallic3 * Mask3R388_g83 ) );
				float4 break2413_g83 = SAMPLE_TEXTURE2D( _Mask4, sampler_Mask0, ( ( TecCoord01294_g83 * _Splat4_ST.xy ) + _Splat4_ST.zw ) );
				float Mask4R747_g83 = break2413_g83.r;
				float4 break2472_g83 = SAMPLE_TEXTURE2D( _Mask5, sampler_Mask0, ( ( TecCoord01294_g83 * _Splat5_ST.xy ) + _Splat5_ST.zw ) );
				float Mask5R741_g83 = break2472_g83.r;
				float4 break2531_g83 = SAMPLE_TEXTURE2D( _Mask6, sampler_Mask0, ( ( TecCoord01294_g83 * _Splat6_ST.xy ) + _Splat6_ST.zw ) );
				float Mask6R755_g83 = break2531_g83.r;
				float4 break2590_g83 = SAMPLE_TEXTURE2D( _Mask7, sampler_Mask0, ( ( TecCoord01294_g83 * _Splat7_ST.xy ) + _Splat7_ST.zw ) );
				float Mask7R765_g83 = break2590_g83.r;
				float4 weightedBlendVar834_g83 = Control1922_g83;
				float weightedBlend834_g83 = ( weightedBlendVar834_g83.x*( _Metallic4 * Mask4R747_g83 ) + weightedBlendVar834_g83.y*( _Metallic5 * Mask5R741_g83 ) + weightedBlendVar834_g83.z*( _Metallic6 * Mask6R755_g83 ) + weightedBlendVar834_g83.w*( _Metallic7 * Mask7R765_g83 ) );
				float3 specularColor1792_g83 = (0).xxx;
				float oneMinusReflectivity1792_g83 = 0;
				float3 diffuseColor1792_g83 = ASEComputeDiffuseAndFresnel0( lerpResult1142_g83, ( weightedBlend536_g83 + weightedBlend834_g83 ), specularColor1792_g83, oneMinusReflectivity1792_g83 );
				
				float4 Normal0341_g83 = SAMPLE_TEXTURE2D( _Normal0, sampler_Normal0, ( ( TecCoord01294_g83 * _Splat0_ST.xy ) + _Splat0_ST.zw ) );
				float3 unpack490_g83 = UnpackNormalScale( Normal0341_g83, _NormalScale0 );
				unpack490_g83.z = lerp( 1, unpack490_g83.z, saturate(_NormalScale0) );
				float4 Normal1378_g83 = SAMPLE_TEXTURE2D( _Normal1, sampler_Normal0, ( ( TecCoord01294_g83 * _Splat1_ST.xy ) + _Splat1_ST.zw ) );
				float3 unpack496_g83 = UnpackNormalScale( Normal1378_g83, _NormalScale1 );
				unpack496_g83.z = lerp( 1, unpack496_g83.z, saturate(_NormalScale1) );
				float4 Normal2356_g83 = SAMPLE_TEXTURE2D( _Normal2, sampler_Normal0, ( ( TecCoord01294_g83 * _Splat2_ST.xy ) + _Splat2_ST.zw ) );
				float3 unpack494_g83 = UnpackNormalScale( Normal2356_g83, _NormalScale2 );
				unpack494_g83.z = lerp( 1, unpack494_g83.z, saturate(_NormalScale2) );
				float4 Normal3398_g83 = SAMPLE_TEXTURE2D( _Normal3, sampler_Normal0, ( ( TecCoord01294_g83 * _Splat3_ST.xy ) + _Splat3_ST.zw ) );
				float3 unpack491_g83 = UnpackNormalScale( Normal3398_g83, _NormalScale3 );
				unpack491_g83.z = lerp( 1, unpack491_g83.z, saturate(_NormalScale3) );
				float4 weightedBlendVar473_g83 = Control26_g83;
				float3 weightedBlend473_g83 = ( weightedBlendVar473_g83.x*unpack490_g83 + weightedBlendVar473_g83.y*unpack496_g83 + weightedBlendVar473_g83.z*unpack494_g83 + weightedBlendVar473_g83.w*unpack491_g83 );
				float4 Normal4746_g83 = SAMPLE_TEXTURE2D( _Normal4, sampler_Normal0, ( ( TecCoord01294_g83 * _Splat4_ST.xy ) + _Splat4_ST.zw ) );
				float3 unpack856_g83 = UnpackNormalScale( Normal4746_g83, _NormalScale4 );
				unpack856_g83.z = lerp( 1, unpack856_g83.z, saturate(_NormalScale4) );
				float4 Normal5740_g83 = SAMPLE_TEXTURE2D( _Normal5, sampler_Normal0, ( ( TecCoord01294_g83 * _Splat5_ST.xy ) + _Splat5_ST.zw ) );
				float3 unpack857_g83 = UnpackNormalScale( Normal5740_g83, _NormalScale5 );
				unpack857_g83.z = lerp( 1, unpack857_g83.z, saturate(_NormalScale5) );
				float4 Normal6754_g83 = SAMPLE_TEXTURE2D( _Normal6, sampler_Normal0, ( ( TecCoord01294_g83 * _Splat6_ST.xy ) + _Splat6_ST.zw ) );
				float3 unpack858_g83 = UnpackNormalScale( Normal6754_g83, _NormalScale6 );
				unpack858_g83.z = lerp( 1, unpack858_g83.z, saturate(_NormalScale6) );
				float4 Normal7764_g83 = SAMPLE_TEXTURE2D( _Normal7, sampler_Normal0, ( ( TecCoord01294_g83 * _Splat7_ST.xy ) + _Splat7_ST.zw ) );
				float3 unpack854_g83 = UnpackNormalScale( Normal7764_g83, _NormalScale7 );
				unpack854_g83.z = lerp( 1, unpack854_g83.z, saturate(_NormalScale7) );
				float4 weightedBlendVar860_g83 = Control1922_g83;
				float3 weightedBlend860_g83 = ( weightedBlendVar860_g83.x*unpack856_g83 + weightedBlendVar860_g83.y*unpack857_g83 + weightedBlendVar860_g83.z*unpack858_g83 + weightedBlendVar860_g83.w*unpack854_g83 );
				float3 break513_g83 = ( weightedBlend473_g83 + weightedBlend860_g83 );
				float3 appendResult514_g83 = (float3(break513_g83.x , break513_g83.y , ( break513_g83.z + 0.001 )));
				float3 unpack1127_g83 = UnpackNormalScale( SAMPLE_TEXTURE2D( _SnowMapNormal, sampler_SnowMapNormal, temp_output_1083_0_g83 ), _SnowNormalStrength );
				unpack1127_g83.z = lerp( 1, unpack1127_g83.z, saturate(_SnowNormalStrength) );
				float3 SnowNormal1090_g83 = unpack1127_g83;
				float SnowEnableRChannel1174_g83 = _SnowSplatREnable;
				float3 lerpResult1221_g83 = lerp( appendResult514_g83 , SnowNormal1090_g83 , SnowEnableRChannel1174_g83);
				float SnowEnableGChannel1175_g83 = _SnowSplatGEnable;
				float3 lerpResult1214_g83 = lerp( appendResult514_g83 , SnowNormal1090_g83 , SnowEnableGChannel1175_g83);
				float SnowEnableBChannel1176_g83 = _SnowSplatBEnable;
				float3 lerpResult1215_g83 = lerp( appendResult514_g83 , SnowNormal1090_g83 , SnowEnableBChannel1176_g83);
				float SnowEnableAChannel1177_g83 = _SnowSplatAEnable;
				float3 lerpResult1216_g83 = lerp( appendResult514_g83 , SnowNormal1090_g83 , SnowEnableAChannel1177_g83);
				float4 weightedBlendVar1220_g83 = SnowSplatRGBA1117_g83;
				float3 weightedBlend1220_g83 = ( weightedBlendVar1220_g83.x*lerpResult1221_g83 + weightedBlendVar1220_g83.y*lerpResult1214_g83 + weightedBlendVar1220_g83.z*lerpResult1215_g83 + weightedBlendVar1220_g83.w*lerpResult1216_g83 );
				float SnowEnable1173_g83 = _SnowEnable;
				float3 lerpResult1222_g83 = lerp( appendResult514_g83 , weightedBlend1220_g83 , SnowEnable1173_g83);
				
				float4 weightedBlendVar1777_g83 = Control26_g83;
				float4 weightedBlend1777_g83 = ( weightedBlendVar1777_g83.x*_Specular0 + weightedBlendVar1777_g83.y*_Specular1 + weightedBlendVar1777_g83.z*_Specular2 + weightedBlendVar1777_g83.w*_Specular3 );
				float4 weightedBlendVar1773_g83 = Control1922_g83;
				float4 weightedBlend1773_g83 = ( weightedBlendVar1773_g83.x*_Specular4 + weightedBlendVar1773_g83.y*_Specular5 + weightedBlendVar1773_g83.z*_Specular6 + weightedBlendVar1773_g83.w*_Specular7 );
				
				float Mask0A335_g83 = break2097_g83.a;
				float Splat0A435_g83 = (SAMPLE_TEXTURE2D( _Splat0, sampler_Splat0, ( ( TecCoord01294_g83 * _Splat0_ST.xy ) + _Splat0_ST.zw ) )).a;
				float lerpResult1509_g83 = lerp( Mask0A335_g83 , Splat0A435_g83 , _OpacityAsDensity0);
				float Mask1A369_g83 = break2193_g83.a;
				float Splat1A436_g83 = (SAMPLE_TEXTURE2D( _Splat1, sampler_Splat0, ( ( TecCoord01294_g83 * _Splat1_ST.xy ) + _Splat1_ST.zw ) )).a;
				float lerpResult1510_g83 = lerp( Mask1A369_g83 , Splat1A436_g83 , _OpacityAsDensity1);
				float Mask2A360_g83 = break2262_g83.a;
				float Splat2A438_g83 = (SAMPLE_TEXTURE2D( _Splat2, sampler_Splat0, ( ( TecCoord01294_g83 * _Splat2_ST.xy ) + _Splat2_ST.zw ) )).a;
				float lerpResult1511_g83 = lerp( Mask2A360_g83 , Splat2A438_g83 , _OpacityAsDensity2);
				float Mask3A391_g83 = break2342_g83.a;
				float Splat3A440_g83 = (SAMPLE_TEXTURE2D( _Splat3, sampler_Splat0, ( ( TecCoord01294_g83 * _Splat3_ST.xy ) + _Splat3_ST.zw ) )).a;
				float lerpResult1512_g83 = lerp( Mask3A391_g83 , Splat3A440_g83 , _OpacityAsDensity3);
				float4 weightedBlendVar547_g83 = Control26_g83;
				float weightedBlend547_g83 = ( weightedBlendVar547_g83.x*( _Smoothness0 * lerpResult1509_g83 ) + weightedBlendVar547_g83.y*( _Smoothness1 * lerpResult1510_g83 ) + weightedBlendVar547_g83.z*( _Smoothness2 * lerpResult1511_g83 ) + weightedBlendVar547_g83.w*( _Smoothness3 * lerpResult1512_g83 ) );
				float Mask4A750_g83 = break2413_g83.a;
				float Splat4A753_g83 = (SAMPLE_TEXTURE2D( _Splat4, sampler_Splat0, ( ( TecCoord01294_g83 * _Splat4_ST.xy ) + _Splat4_ST.zw ) )).a;
				float lerpResult1513_g83 = lerp( Mask4A750_g83 , Splat4A753_g83 , _OpacityAsDensity4);
				float Mask5A745_g83 = break2472_g83.a;
				float Splat5A739_g83 = (SAMPLE_TEXTURE2D( _Splat5, sampler_Splat0, ( ( TecCoord01294_g83 * _Splat5_ST.xy ) + _Splat5_ST.zw ) )).a;
				float lerpResult1514_g83 = lerp( Mask5A745_g83 , Splat5A739_g83 , _OpacityAsDensity5);
				float Mask6A758_g83 = break2531_g83.a;
				float Splat6A760_g83 = (SAMPLE_TEXTURE2D( _Splat6, sampler_Splat0, ( ( TecCoord01294_g83 * _Splat6_ST.xy ) + _Splat6_ST.zw ) )).a;
				float lerpResult1515_g83 = lerp( Mask6A758_g83 , Splat6A760_g83 , _OpacityAsDensity6);
				float Mask7A768_g83 = break2590_g83.a;
				float Splat7A763_g83 = (SAMPLE_TEXTURE2D( _Splat7, sampler_Splat0, ( ( TecCoord01294_g83 * _Splat7_ST.xy ) + _Splat7_ST.zw ) )).a;
				float lerpResult1516_g83 = lerp( Mask7A768_g83 , Splat7A763_g83 , _OpacityAsDensity7);
				float4 weightedBlendVar826_g83 = Control1922_g83;
				float weightedBlend826_g83 = ( weightedBlendVar826_g83.x*( _Smoothness4 * lerpResult1513_g83 ) + weightedBlendVar826_g83.y*( _Smoothness5 * lerpResult1514_g83 ) + weightedBlendVar826_g83.z*( _Smoothness6 * lerpResult1515_g83 ) + weightedBlendVar826_g83.w*( _Smoothness7 * lerpResult1516_g83 ) );
				
				float Mask0G409_g83 = break2097_g83.g;
				float lerpResult1655_g83 = lerp( ( _MaskMapRemapOffset0.y + _MaskMapRemapScale0.y ) , Mask0G409_g83 , _LayerHasMask0);
				float Mask1G371_g83 = break2193_g83.g;
				float lerpResult1660_g83 = lerp( ( _MaskMapRemapOffset1.y + _MaskMapRemapScale1.y ) , Mask1G371_g83 , _LayerHasMask1);
				float Mask2G358_g83 = break2262_g83.g;
				float lerpResult1663_g83 = lerp( ( _MaskMapRemapOffset2.y + _MaskMapRemapScale2.y ) , Mask2G358_g83 , _LayerHasMask2);
				float Mask3G389_g83 = break2342_g83.g;
				float lerpResult1666_g83 = lerp( ( _MaskMapRemapOffset3.y + _MaskMapRemapScale3.y ) , Mask3G389_g83 , _LayerHasMask3);
				float4 weightedBlendVar602_g83 = Control26_g83;
				float weightedBlend602_g83 = ( weightedBlendVar602_g83.x*saturate( lerpResult1655_g83 ) + weightedBlendVar602_g83.y*saturate( lerpResult1660_g83 ) + weightedBlendVar602_g83.z*saturate( lerpResult1663_g83 ) + weightedBlendVar602_g83.w*saturate( lerpResult1666_g83 ) );
				float Mask4G748_g83 = break2413_g83.g;
				float lerpResult1669_g83 = lerp( ( _MaskMapRemapOffset4.y + _MaskMapRemapScale4.x ) , Mask4G748_g83 , _LayerHasMask4);
				float Mask5G742_g83 = break2472_g83.g;
				float lerpResult1672_g83 = lerp( ( _MaskMapRemapOffset5.y + _MaskMapRemapScale5.y ) , Mask5G742_g83 , _LayerHasMask5);
				float Mask6G756_g83 = break2531_g83.g;
				float lerpResult1675_g83 = lerp( ( _MaskMapRemapOffset6.y + _MaskMapRemapScale6.y ) , Mask6G756_g83 , _LayerHasMask6);
				float Mask7G766_g83 = break2590_g83.g;
				float lerpResult1678_g83 = lerp( ( _MaskMapRemapOffset7.y + _MaskMapRemapScale7.y ) , Mask7G766_g83 , _LayerHasMask7);
				float4 weightedBlendVar799_g83 = Control1922_g83;
				float weightedBlend799_g83 = ( weightedBlendVar799_g83.x*saturate( lerpResult1669_g83 ) + weightedBlendVar799_g83.y*saturate( lerpResult1672_g83 ) + weightedBlendVar799_g83.z*saturate( lerpResult1675_g83 ) + weightedBlendVar799_g83.w*saturate( lerpResult1678_g83 ) );
				float Occlusion1868_g83 = saturate( ( weightedBlend602_g83 + weightedBlend799_g83 ) );
				
				float4 tex2DNode451_g83 = SAMPLE_TEXTURE2D( _TerrainHolesTexture, sampler_TerrainHolesTexture, uv_TerrainHolesTexture451_g83 );
				

				float3 BaseColor = diffuseColor1792_g83;
				float3 Normal = lerpResult1222_g83;
				float3 Specular = ( specularColor1792_g83 + (( weightedBlend1777_g83 + weightedBlend1773_g83 )).xyz );
				float Metallic = 0;
				float Smoothness = ( weightedBlend547_g83 + weightedBlend826_g83 );
				float Occlusion = Occlusion1868_g83;
				float3 Emission = 0;
				float Alpha = ( 0.5 + 1E-37 );
				#if defined( _ALPHATEST_ON )
					float AlphaClipThreshold = ( 1.0 - tex2DNode451_g83 ).r;
					float AlphaClipThresholdShadow = 0.5;
				#endif
				float3 BakedGI = 0;
				float3 RefractionColor = 1;
				float RefractionIndex = 1;
				float3 Transmission = 1;
				float3 Translucency = 1;

				#if defined( ASE_DEPTH_WRITE_ON )
					input.positionCS.z = input.positionCS.z;
				#endif

				#if defined( _ALPHATEST_ON )
					AlphaDiscard( Alpha, AlphaClipThreshold );
				#endif

				#if defined(MAIN_LIGHT_CALCULATE_SHADOWS) && defined(ASE_CHANGES_WORLD_POS)
					ShadowCoord = TransformWorldToShadowCoord( PositionWS );
				#endif

				InputData inputData = (InputData)0;
				inputData.positionWS = PositionWS;
				inputData.positionCS = input.positionCS;
				inputData.normalizedScreenSpaceUV = ScreenPosNorm.xy;
				inputData.shadowCoord = ShadowCoord;

				#ifdef _NORMALMAP
					#if _NORMAL_DROPOFF_TS
						inputData.normalWS = TransformTangentToWorld(Normal, half3x3( TangentWS, BitangentWS, NormalWS ));
					#elif _NORMAL_DROPOFF_OS
						inputData.normalWS = TransformObjectToWorldNormal(Normal);
					#elif _NORMAL_DROPOFF_WS
						inputData.normalWS = Normal;
					#endif
				#else
					inputData.normalWS = NormalWS;
				#endif

				inputData.normalWS = NormalizeNormalPerPixel(inputData.normalWS);
				inputData.viewDirectionWS = SafeNormalize( ViewDirWS );

				#ifdef ASE_FOG
					// @diogo: no fog applied in GBuffer
				#endif
				#ifdef _ADDITIONAL_LIGHTS_VERTEX
					inputData.vertexLighting = input.fogFactorAndVertexLight.yzw;
				#endif

				#if defined( ENABLE_TERRAIN_PERPIXEL_NORMAL )
					float3 SH = SampleSH(inputData.normalWS.xyz);
				#else
					float3 SH = input.lightmapUVOrVertexSH.xyz;
				#endif

				#if defined(_SCREEN_SPACE_IRRADIANCE)
					inputData.bakedGI = SAMPLE_GI(_ScreenSpaceIrradiance, input.positionCS.xy);
				#elif defined(DYNAMICLIGHTMAP_ON)
					inputData.bakedGI = SAMPLE_GI(input.lightmapUVOrVertexSH.xy, input.dynamicLightmapUV.xy, SH, inputData.normalWS);
					inputData.shadowMask = SAMPLE_SHADOWMASK(input.lightmapUVOrVertexSH.xy);
				#elif !defined(LIGHTMAP_ON) && (defined(PROBE_VOLUMES_L1) || defined(PROBE_VOLUMES_L2))
					inputData.bakedGI = SAMPLE_GI(SH,
						GetAbsolutePositionWS(inputData.positionWS),
						inputData.normalWS,
						inputData.viewDirectionWS,
						input.positionCS.xy,
						input.probeOcclusion,
						inputData.shadowMask);
				#else
					inputData.bakedGI = SAMPLE_GI(input.lightmapUVOrVertexSH.xy, SH, inputData.normalWS);
					inputData.shadowMask = SAMPLE_SHADOWMASK(input.lightmapUVOrVertexSH.xy);
				#endif

				#ifdef ASE_BAKEDGI
					inputData.bakedGI = BakedGI;
				#endif

				#if defined(DEBUG_DISPLAY)
					#if defined(DYNAMICLIGHTMAP_ON)
						inputData.dynamicLightmapUV = input.dynamicLightmapUV.xy;
						#endif
					#if defined(LIGHTMAP_ON)
						inputData.staticLightmapUV = input.lightmapUVOrVertexSH.xy;
					#else
						inputData.vertexSH = SH;
					#endif
					#if defined(USE_APV_PROBE_OCCLUSION)
						inputData.probeOcclusion = input.probeOcclusion;
					#endif
				#endif

				#ifdef _DBUFFER
					ApplyDecal(input.positionCS,
						BaseColor,
						Specular,
						inputData.normalWS,
						Metallic,
						Occlusion,
						Smoothness);
				#endif

				BRDFData brdfData;
				InitializeBRDFData(BaseColor, Metallic, Specular, Smoothness, Alpha, brdfData);

				Light mainLight = GetMainLight(inputData.shadowCoord, inputData.positionWS, inputData.shadowMask);
				half4 color;
				MixRealtimeAndBakedGI(mainLight, inputData.normalWS, inputData.bakedGI, inputData.shadowMask);

				color.rgb = GlobalIllumination(brdfData, (BRDFData)0, 0,
                              inputData.bakedGI, Occlusion, inputData.positionWS,
                              inputData.normalWS, inputData.viewDirectionWS, inputData.normalizedScreenSpaceUV);

				color.a = Alpha;

				#ifdef ASE_FINAL_COLOR_ALPHA_MULTIPLY
					color.rgb *= color.a;
				#endif

				#if defined( ASE_DEPTH_WRITE_ON )
					outputDepth = input.positionCS.z;
				#endif

				return PackGBuffersBRDFData(brdfData, inputData, Smoothness, Emission + color.rgb, Occlusion);
			}

			ENDHLSL
		}

		
		Pass
		{
			
			Name "SceneSelectionPass"
			Tags { "LightMode"="SceneSelectionPass" }

			Cull Off
			AlphaToMask Off

			HLSLPROGRAM

			#define _ALPHATEST_ON
			#define _NORMAL_DROPOFF_TS 1
			#define ASE_FOG 1
			#pragma multi_compile_fragment _ DEBUG_DISPLAY
			#define ASE_TERRAIN
			#define _SPECULAR_SETUP 1
			#define _NORMALMAP 1
			#define ASE_VERSION 19907
			#define ASE_SRP_VERSION 170300
			#define ASE_USING_SAMPLING_MACROS 1


			#pragma vertex vert
			#pragma fragment frag

			#if defined( _SPECULAR_SETUP ) && defined( ASE_LIGHTING_SIMPLE )
				#if defined( _SPECULARHIGHLIGHTS_OFF )
					#undef _SPECULAR_COLOR
				#else
					#define _SPECULAR_COLOR
				#endif
			#endif

			#define SCENESELECTIONPASS 1

			#define ATTRIBUTES_NEED_NORMAL
			#define ATTRIBUTES_NEED_TANGENT
			#define SHADERPASS SHADERPASS_DEPTHONLY

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_TEXTURE_COORDINATES0
			#define ASE_INSTANCED_TERRAIN
			#define ASE_NEEDS_VERT_POSITION
			#pragma multi_compile_instancing
			#pragma instancing_options assumeuniformscaling nomatrices nolightprobe nolightmap
			#define TERRAIN_SPLAT_FIRSTPASS 1
			#define _LAYER_COUNT 8
			#pragma shader_feature_local _TERRAIN_8_LAYERS
			#pragma editor_sync_compilation
			#pragma shader_feature_local _NORMALMAP
			#pragma shader_feature_local _MASKMAP


			#if defined(ASE_EARLY_Z_DEPTH_OPTIMIZE) && (SHADER_TARGET >= 45)
				#define ASE_SV_DEPTH SV_DepthLessEqual
				#define ASE_SV_POSITION_QUALIFIERS linear noperspective centroid
			#else
				#define ASE_SV_DEPTH SV_Depth
				#define ASE_SV_POSITION_QUALIFIERS
			#endif

			struct Attributes
			{
				float4 positionOS : POSITION;
				half3 normalOS : NORMAL;
				half4 tangentOS : TANGENT;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct PackedVaryings
			{
				ASE_SV_POSITION_QUALIFIERS float4 positionCS : SV_POSITION;
				float3 positionWS : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _Control_ST;
			float4 _MaskMapRemapScale4;
			float4 _MaskMapRemapOffset4;
			float4 _MaskMapRemapScale3;
			half4 _SnowColor;
			float4 _SnowMainUVs;
			float4 _MaskMapRemapOffset3;
			float4 _MaskMapRemapOffset2;
			float4 _MaskMapRemapScale1;
			float4 _MaskMapRemapOffset1;
			float4 _SnowMapSplat_ST;
			float4 _MaskMapRemapScale0;
			float4 _Specular7;
			float4 _Specular6;
			float4 _Specular5;
			float4 _MaskMapRemapScale7;
			float4 _Specular4;
			float4 _Specular3;
			float4 _Specular2;
			float4 _Specular1;
			float4 _Specular0;
			float4 _MaskMapRemapOffset0;
			float4 _Splat7_ST;
			float4 _MaskMapRemapScale2;
			float4 _MaskMapRemapOffset5;
			float4 _DiffuseRemapScale7;
			float4 _MaskMapRemapScale6;
			float4 _Splat2_ST;
			float4 _DiffuseRemapScale2;
			float4 _DiffuseRemapScale3;
			float4 _Splat3_ST;
			float4 _Splat1_ST;
			float4 _MaskMapRemapOffset6;
			float4 _DiffuseRemapScale1;
			float4 _DiffuseRemapScale4;
			float4 _Control1_ST;
			float4 _Splat0_ST;
			float4 _Splat6_ST;
			float4 _DiffuseRemapScale6;
			float4 _MaskMapRemapOffset7;
			float4 _Splat5_ST;
			float4 _MaskMapRemapScale5;
			float4 _DiffuseRemapScale0;
			float4 _Splat4_ST;
			float4 _DiffuseRemapScale5;
			half _SnowNormalStrength;
			float _LayerHasMask6;
			float _OpacityAsDensity1;
			half _NormalScale7;
			float _Smoothness0;
			float _OpacityAsDensity0;
			float _Smoothness1;
			float _Smoothness2;
			float _OpacityAsDensity5;
			float _Smoothness3;
			float _LayerHasMask4;
			float _LayerHasMask3;
			float _LayerHasMask5;
			float _LayerHasMask2;
			half _NormalScale6;
			float _LayerHasMask1;
			float _LayerHasMask0;
			float _OpacityAsDensity7;
			float _Smoothness7;
			float _OpacityAsDensity6;
			float _Smoothness6;
			float _Smoothness5;
			float _OpacityAsDensity4;
			float _Smoothness4;
			float _OpacityAsDensity3;
			float _OpacityAsDensity2;
			half _NormalScale5;
			float _Metallic2;
			half _NormalScale3;
			half _SnowSplatGBlendFalloff;
			half _SnowSplatGBlendFactor;
			half _SnowSplatREnable;
			half _SnowSplatRMax;
			half _SnowSplatRMin;
			half _SnowSplatRBlendStrength;
			half _SnowSplatRBlendFalloff;
			half _SnowSplatRBlendFactor;
			half _SnowBrightness;
			half _SnowSaturation;
			half _SnowSplatGBlendStrength;
			half _SnowSplatASplatBias;
			half _SnowSplatGSplatBias;
			half _SnowSplatRSplatBias;
			half _Splat7Brightness;
			half _Splat6Brightness;
			half _Splat5Brightness;
			half _Splat4Brightness;
			half _Splat3Brightness;
			half _Splat2Brightness;
			half _Splat1Brightness;
			half _Splat0Brightness;
			half _SnowSplatBSplatBias;
			half _SnowSplatGMin;
			half _SnowSplatGMax;
			half _SnowSplatGEnable;
			half _NormalScale2;
			half _NormalScale1;
			half _NormalScale0;
			float _Metallic7;
			float _Metallic6;
			float _Metallic5;
			float _Metallic4;
			float _Metallic3;
			float _Metallic1;
			float _Metallic0;
			half _SnowEnable;
			half _SnowSplatAEnable;
			half _SnowSplatAMax;
			half _SnowSplatAMin;
			half _SnowSplatABlendStrength;
			half _SnowSplatABlendFalloff;
			half _SnowSplatABlendFactor;
			half _SnowSplatBEnable;
			half _SnowSplatBMax;
			half _SnowSplatBMin;
			half _SnowSplatBBlendStrength;
			half _SnowSplatBBlendFalloff;
			half _SnowSplatBBlendFactor;
			half _NormalScale4;
			float _LayerHasMask7;
			float _AlphaClip;
			float _Cutoff;
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
			CBUFFER_END

			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			TEXTURE2D(_TerrainHolesTexture);
			SAMPLER(sampler_TerrainHolesTexture);
			#ifdef UNITY_INSTANCING_ENABLED//ASE Terrain Instancing
				TEXTURE2D(_TerrainHeightmapTexture);//ASE Terrain Instancing
				TEXTURE2D( _TerrainNormalmapTexture);//ASE Terrain Instancing
				SAMPLER(sampler_TerrainNormalmapTexture);//ASE Terrain Instancing
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
				float2 sampleCoords = ( patchVertex.xy + instanceData.xy ) * instanceData.z;
				float height = UnpackHeightmap( _TerrainHeightmapTexture.Load( int3( sampleCoords, 0 ) ) );
				position.xz = sampleCoords* _TerrainHeightmapScale.xz;
				position.y = height* _TerrainHeightmapScale.y;
				#ifdef ENABLE_TERRAIN_PERPIXEL_NORMAL
					normal = float3(0, 1, 0);
				#else
					normal = _TerrainNormalmapTexture.Load(int3(sampleCoords, 0)).rgb* 2 - 1;
				#endif
				texcoord.xy = sampleCoords* _TerrainHeightmapRecipSize.zw;
			#endif
			}
			

			struct SurfaceDescription
			{
				float Alpha;
				float AlphaClipThreshold;
			};

			PackedVaryings VertexFunction(Attributes input  )
			{
				PackedVaryings output;
				ZERO_INITIALIZE(PackedVaryings, output);

				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_TRANSFER_INSTANCE_ID(input, output);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(output);

				#if defined( ASE_INSTANCED_TERRAIN ) && !defined( ASE_TESSELLATION )
					TerrainApplyMeshModification( input.positionOS.xyz, input.normalOS, input.ase_texcoord );
				#endif
				
				output.ase_texcoord1.xy = input.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				output.ase_texcoord1.zw = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = input.positionOS.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = defaultVertexValue;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					input.positionOS.xyz = vertexValue;
				#else
					input.positionOS.xyz += vertexValue;
				#endif

				input.normalOS = input.normalOS;

				VertexPositionInputs vertexInput = GetVertexPositionInputs( input.positionOS.xyz );

				output.positionCS = vertexInput.positionCS;
				output.positionWS = vertexInput.positionWS;
				return output;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 positionOS : INTERNALTESSPOS;
				half3 normalOS : NORMAL;
				half4 tangentOS : TANGENT;
				float4 ase_texcoord : TEXCOORD0;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( Attributes input )
			{
				VertexControl output;
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_TRANSFER_INSTANCE_ID(input, output);
				output.positionOS = input.positionOS;
				output.normalOS = input.normalOS;
				output.tangentOS = input.tangentOS;
				output.ase_texcoord = input.ase_texcoord;
				#if defined( ASE_INSTANCED_TERRAIN )
					TerrainApplyMeshModification( output.positionOS.xyz, output.normalOS, output.ase_texcoord );
				#endif
				
				return output;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> input)
			{
				TessellationFactors output;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(input[0].positionOS, input[1].positionOS, input[2].positionOS, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(input[0].positionOS, input[1].positionOS, input[2].positionOS, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(input[0].positionOS, input[1].positionOS, input[2].positionOS, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				output.edge[0] = tf.x; output.edge[1] = tf.y; output.edge[2] = tf.z; output.inside = tf.w;
				return output;
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
			PackedVaryings DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				Attributes output = (Attributes) 0;
				output.positionOS = patch[0].positionOS * bary.x + patch[1].positionOS * bary.y + patch[2].positionOS * bary.z;
				output.normalOS = patch[0].normalOS * bary.x + patch[1].normalOS * bary.y + patch[2].normalOS * bary.z;
				output.tangentOS = patch[0].tangentOS * bary.x + patch[1].tangentOS * bary.y + patch[2].tangentOS * bary.z;
				output.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = output.positionOS.xyz - patch[i].normalOS * (dot(output.positionOS.xyz, patch[i].normalOS) - dot(patch[i].positionOS.xyz, patch[i].normalOS));
				float phongStrength = _TessPhongStrength;
				output.positionOS.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * output.positionOS.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], output);
				return VertexFunction(output);
			}
			#else
			PackedVaryings vert ( Attributes input )
			{
				return VertexFunction( input );
			}
			#endif

			half4 frag( PackedVaryings input
				#if defined( ASE_DEPTH_WRITE_ON )
				,out float outputDepth : ASE_SV_DEPTH
				#endif
				 ) : SV_Target
			{
				SurfaceDescription surfaceDescription = (SurfaceDescription)0;

				float3 PositionWS = input.positionWS;
				float3 PositionRWS = GetCameraRelativePositionWS( PositionWS );
				float4 ScreenPosNorm = float4( GetNormalizedScreenSpaceUV( input.positionCS ), input.positionCS.zw );
				float4 ClipPos = ComputeClipSpacePosition( ScreenPosNorm.xy, input.positionCS.z ) * input.positionCS.w;

				float2 uv_TerrainHolesTexture451_g83 = input.ase_texcoord1.xy;
				float4 tex2DNode451_g83 = SAMPLE_TEXTURE2D( _TerrainHolesTexture, sampler_TerrainHolesTexture, uv_TerrainHolesTexture451_g83 );
				

				surfaceDescription.Alpha = ( 0.5 + 1E-37 );
				#if defined( _ALPHATEST_ON )
					surfaceDescription.AlphaClipThreshold = ( 1.0 - tex2DNode451_g83 ).r;
				#endif

				#if defined( ASE_DEPTH_WRITE_ON )
					input.positionCS.z = input.positionCS.z;
				#endif

				#ifdef _ALPHATEST_ON
					clip(surfaceDescription.Alpha - surfaceDescription.AlphaClipThreshold);
				#endif

				#if defined( ASE_DEPTH_WRITE_ON )
					outputDepth = input.positionCS.z;
				#endif

				return half4( _ObjectId, _PassValue, 1.0, 1.0 );
			}

			ENDHLSL
		}

		
		Pass
		{
			
			Name "ScenePickingPass"
			Tags { "LightMode"="Picking" }

			AlphaToMask Off

			HLSLPROGRAM

			#define _ALPHATEST_ON
			#define _NORMAL_DROPOFF_TS 1
			#define ASE_FOG 1
			#pragma multi_compile_fragment _ DEBUG_DISPLAY
			#define ASE_TERRAIN
			#define _SPECULAR_SETUP 1
			#define _NORMALMAP 1
			#define ASE_VERSION 19907
			#define ASE_SRP_VERSION 170300
			#define ASE_USING_SAMPLING_MACROS 1


			#pragma vertex vert
			#pragma fragment frag

			#if defined( _SPECULAR_SETUP ) && defined( ASE_LIGHTING_SIMPLE )
				#if defined( _SPECULARHIGHLIGHTS_OFF )
					#undef _SPECULAR_COLOR
				#else
					#define _SPECULAR_COLOR
				#endif
			#endif

		    #define SCENEPICKINGPASS 1

			#define ATTRIBUTES_NEED_NORMAL
			#define ATTRIBUTES_NEED_TANGENT
			#define SHADERPASS SHADERPASS_DEPTHONLY

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_TEXTURE_COORDINATES0
			#define ASE_INSTANCED_TERRAIN
			#define ASE_NEEDS_VERT_POSITION
			#pragma multi_compile_instancing
			#pragma instancing_options assumeuniformscaling nomatrices nolightprobe nolightmap
			#define TERRAIN_SPLAT_FIRSTPASS 1
			#define _LAYER_COUNT 8
			#pragma shader_feature_local _TERRAIN_8_LAYERS
			#pragma editor_sync_compilation
			#pragma shader_feature_local _NORMALMAP
			#pragma shader_feature_local _MASKMAP


			#if defined(ASE_EARLY_Z_DEPTH_OPTIMIZE) && (SHADER_TARGET >= 45)
				#define ASE_SV_DEPTH SV_DepthLessEqual
				#define ASE_SV_POSITION_QUALIFIERS linear noperspective centroid
			#else
				#define ASE_SV_DEPTH SV_Depth
				#define ASE_SV_POSITION_QUALIFIERS
			#endif

			struct Attributes
			{
				float4 positionOS : POSITION;
				half3 normalOS : NORMAL;
				half4 tangentOS : TANGENT;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct PackedVaryings
			{
				ASE_SV_POSITION_QUALIFIERS float4 positionCS : SV_POSITION;
				float3 positionWS : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _Control_ST;
			float4 _MaskMapRemapScale4;
			float4 _MaskMapRemapOffset4;
			float4 _MaskMapRemapScale3;
			half4 _SnowColor;
			float4 _SnowMainUVs;
			float4 _MaskMapRemapOffset3;
			float4 _MaskMapRemapOffset2;
			float4 _MaskMapRemapScale1;
			float4 _MaskMapRemapOffset1;
			float4 _SnowMapSplat_ST;
			float4 _MaskMapRemapScale0;
			float4 _Specular7;
			float4 _Specular6;
			float4 _Specular5;
			float4 _MaskMapRemapScale7;
			float4 _Specular4;
			float4 _Specular3;
			float4 _Specular2;
			float4 _Specular1;
			float4 _Specular0;
			float4 _MaskMapRemapOffset0;
			float4 _Splat7_ST;
			float4 _MaskMapRemapScale2;
			float4 _MaskMapRemapOffset5;
			float4 _DiffuseRemapScale7;
			float4 _MaskMapRemapScale6;
			float4 _Splat2_ST;
			float4 _DiffuseRemapScale2;
			float4 _DiffuseRemapScale3;
			float4 _Splat3_ST;
			float4 _Splat1_ST;
			float4 _MaskMapRemapOffset6;
			float4 _DiffuseRemapScale1;
			float4 _DiffuseRemapScale4;
			float4 _Control1_ST;
			float4 _Splat0_ST;
			float4 _Splat6_ST;
			float4 _DiffuseRemapScale6;
			float4 _MaskMapRemapOffset7;
			float4 _Splat5_ST;
			float4 _MaskMapRemapScale5;
			float4 _DiffuseRemapScale0;
			float4 _Splat4_ST;
			float4 _DiffuseRemapScale5;
			half _SnowNormalStrength;
			float _LayerHasMask6;
			float _OpacityAsDensity1;
			half _NormalScale7;
			float _Smoothness0;
			float _OpacityAsDensity0;
			float _Smoothness1;
			float _Smoothness2;
			float _OpacityAsDensity5;
			float _Smoothness3;
			float _LayerHasMask4;
			float _LayerHasMask3;
			float _LayerHasMask5;
			float _LayerHasMask2;
			half _NormalScale6;
			float _LayerHasMask1;
			float _LayerHasMask0;
			float _OpacityAsDensity7;
			float _Smoothness7;
			float _OpacityAsDensity6;
			float _Smoothness6;
			float _Smoothness5;
			float _OpacityAsDensity4;
			float _Smoothness4;
			float _OpacityAsDensity3;
			float _OpacityAsDensity2;
			half _NormalScale5;
			float _Metallic2;
			half _NormalScale3;
			half _SnowSplatGBlendFalloff;
			half _SnowSplatGBlendFactor;
			half _SnowSplatREnable;
			half _SnowSplatRMax;
			half _SnowSplatRMin;
			half _SnowSplatRBlendStrength;
			half _SnowSplatRBlendFalloff;
			half _SnowSplatRBlendFactor;
			half _SnowBrightness;
			half _SnowSaturation;
			half _SnowSplatGBlendStrength;
			half _SnowSplatASplatBias;
			half _SnowSplatGSplatBias;
			half _SnowSplatRSplatBias;
			half _Splat7Brightness;
			half _Splat6Brightness;
			half _Splat5Brightness;
			half _Splat4Brightness;
			half _Splat3Brightness;
			half _Splat2Brightness;
			half _Splat1Brightness;
			half _Splat0Brightness;
			half _SnowSplatBSplatBias;
			half _SnowSplatGMin;
			half _SnowSplatGMax;
			half _SnowSplatGEnable;
			half _NormalScale2;
			half _NormalScale1;
			half _NormalScale0;
			float _Metallic7;
			float _Metallic6;
			float _Metallic5;
			float _Metallic4;
			float _Metallic3;
			float _Metallic1;
			float _Metallic0;
			half _SnowEnable;
			half _SnowSplatAEnable;
			half _SnowSplatAMax;
			half _SnowSplatAMin;
			half _SnowSplatABlendStrength;
			half _SnowSplatABlendFalloff;
			half _SnowSplatABlendFactor;
			half _SnowSplatBEnable;
			half _SnowSplatBMax;
			half _SnowSplatBMin;
			half _SnowSplatBBlendStrength;
			half _SnowSplatBBlendFalloff;
			half _SnowSplatBBlendFactor;
			half _NormalScale4;
			float _LayerHasMask7;
			float _AlphaClip;
			float _Cutoff;
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
			CBUFFER_END

			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			TEXTURE2D(_TerrainHolesTexture);
			SAMPLER(sampler_TerrainHolesTexture);
			#ifdef UNITY_INSTANCING_ENABLED//ASE Terrain Instancing
				TEXTURE2D(_TerrainHeightmapTexture);//ASE Terrain Instancing
				TEXTURE2D( _TerrainNormalmapTexture);//ASE Terrain Instancing
				SAMPLER(sampler_TerrainNormalmapTexture);//ASE Terrain Instancing
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
				float2 sampleCoords = ( patchVertex.xy + instanceData.xy ) * instanceData.z;
				float height = UnpackHeightmap( _TerrainHeightmapTexture.Load( int3( sampleCoords, 0 ) ) );
				position.xz = sampleCoords* _TerrainHeightmapScale.xz;
				position.y = height* _TerrainHeightmapScale.y;
				#ifdef ENABLE_TERRAIN_PERPIXEL_NORMAL
					normal = float3(0, 1, 0);
				#else
					normal = _TerrainNormalmapTexture.Load(int3(sampleCoords, 0)).rgb* 2 - 1;
				#endif
				texcoord.xy = sampleCoords* _TerrainHeightmapRecipSize.zw;
			#endif
			}
			

			struct SurfaceDescription
			{
				float Alpha;
				float AlphaClipThreshold;
			};

			PackedVaryings VertexFunction( Attributes input  )
			{
				PackedVaryings output;
				ZERO_INITIALIZE(PackedVaryings, output);

				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_TRANSFER_INSTANCE_ID(input, output);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(output);

				#if defined( ASE_INSTANCED_TERRAIN ) && !defined( ASE_TESSELLATION )
					TerrainApplyMeshModification( input.positionOS.xyz, input.normalOS, input.ase_texcoord );
				#endif
				
				output.ase_texcoord1.xy = input.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				output.ase_texcoord1.zw = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = input.positionOS.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = defaultVertexValue;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					input.positionOS.xyz = vertexValue;
				#else
					input.positionOS.xyz += vertexValue;
				#endif

				input.normalOS = input.normalOS;

				VertexPositionInputs vertexInput = GetVertexPositionInputs( input.positionOS.xyz );

				output.positionCS = vertexInput.positionCS;
				output.positionWS = vertexInput.positionWS;
				return output;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 positionOS : INTERNALTESSPOS;
				half3 normalOS : NORMAL;
				half4 tangentOS : TANGENT;
				float4 ase_texcoord : TEXCOORD0;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( Attributes input )
			{
				VertexControl output;
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_TRANSFER_INSTANCE_ID(input, output);
				output.positionOS = input.positionOS;
				output.normalOS = input.normalOS;
				output.tangentOS = input.tangentOS;
				output.ase_texcoord = input.ase_texcoord;
				#if defined( ASE_INSTANCED_TERRAIN )
					TerrainApplyMeshModification( output.positionOS.xyz, output.normalOS, output.ase_texcoord );
				#endif
				
				return output;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> input)
			{
				TessellationFactors output;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(input[0].positionOS, input[1].positionOS, input[2].positionOS, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(input[0].positionOS, input[1].positionOS, input[2].positionOS, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(input[0].positionOS, input[1].positionOS, input[2].positionOS, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				output.edge[0] = tf.x; output.edge[1] = tf.y; output.edge[2] = tf.z; output.inside = tf.w;
				return output;
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
			PackedVaryings DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				Attributes output = (Attributes) 0;
				output.positionOS = patch[0].positionOS * bary.x + patch[1].positionOS * bary.y + patch[2].positionOS * bary.z;
				output.normalOS = patch[0].normalOS * bary.x + patch[1].normalOS * bary.y + patch[2].normalOS * bary.z;
				output.tangentOS = patch[0].tangentOS * bary.x + patch[1].tangentOS * bary.y + patch[2].tangentOS * bary.z;
				output.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = output.positionOS.xyz - patch[i].normalOS * (dot(output.positionOS.xyz, patch[i].normalOS) - dot(patch[i].positionOS.xyz, patch[i].normalOS));
				float phongStrength = _TessPhongStrength;
				output.positionOS.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * output.positionOS.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], output);
				return VertexFunction(output);
			}
			#else
			PackedVaryings vert ( Attributes input )
			{
				return VertexFunction( input );
			}
			#endif

			half4 frag( PackedVaryings input
				#if defined( ASE_DEPTH_WRITE_ON )
				,out float outputDepth : ASE_SV_DEPTH
				#endif
				 ) : SV_Target
			{
				SurfaceDescription surfaceDescription = (SurfaceDescription)0;

				float3 PositionWS = input.positionWS;
				float3 PositionRWS = GetCameraRelativePositionWS( PositionWS );
				float4 ScreenPosNorm = float4( GetNormalizedScreenSpaceUV( input.positionCS ), input.positionCS.zw );
				float4 ClipPos = ComputeClipSpacePosition( ScreenPosNorm.xy, input.positionCS.z ) * input.positionCS.w;

				float2 uv_TerrainHolesTexture451_g83 = input.ase_texcoord1.xy;
				float4 tex2DNode451_g83 = SAMPLE_TEXTURE2D( _TerrainHolesTexture, sampler_TerrainHolesTexture, uv_TerrainHolesTexture451_g83 );
				

				surfaceDescription.Alpha = ( 0.5 + 1E-37 );
				#if defined( _ALPHATEST_ON )
					surfaceDescription.AlphaClipThreshold = ( 1.0 - tex2DNode451_g83 ).r;
				#endif

				#if defined( ASE_DEPTH_WRITE_ON )
					input.positionCS.z = input.positionCS.z;
				#endif

				#ifdef _ALPHATEST_ON
					clip(surfaceDescription.Alpha - surfaceDescription.AlphaClipThreshold);
				#endif

				#if defined( ASE_DEPTH_WRITE_ON )
					outputDepth = input.positionCS.z;
				#endif

				return unity_SelectionID;
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "MotionVectors"
			Tags { "LightMode"="MotionVectors" }

			ColorMask RG

			HLSLPROGRAM

			#define _ALPHATEST_ON
			#define _NORMAL_DROPOFF_TS 1
			#define ASE_FOG 1
			#pragma multi_compile_fragment _ DEBUG_DISPLAY
			#define ASE_TERRAIN
			#define _SPECULAR_SETUP 1
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#define _NORMALMAP 1
			#define ASE_VERSION 19907
			#define ASE_SRP_VERSION 170300
			#define ASE_USING_SAMPLING_MACROS 1


			#pragma vertex vert
			#pragma fragment frag

			#if defined( _SPECULAR_SETUP ) && defined( ASE_LIGHTING_SIMPLE )
				#if defined( _SPECULARHIGHLIGHTS_OFF )
					#undef _SPECULAR_COLOR
				#else
					#define _SPECULAR_COLOR
				#endif
			#endif

            #define SHADERPASS SHADERPASS_MOTION_VECTORS

            #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
			#include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
		    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
		    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
		    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
		    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
		    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
		    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
		    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
		    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#if defined(LOD_FADE_CROSSFADE)
				#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
			#endif

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MotionVectorsCommon.hlsl"

			#define ASE_NEEDS_TEXTURE_COORDINATES0
			#define ASE_INSTANCED_TERRAIN
			#define ASE_NEEDS_VERT_POSITION
			#define ASE_NEEDS_VERT_NORMAL
			#pragma multi_compile_instancing
			#pragma instancing_options assumeuniformscaling nomatrices nolightprobe nolightmap
			#define TERRAIN_SPLAT_FIRSTPASS 1
			#define _LAYER_COUNT 8
			#pragma shader_feature_local _TERRAIN_8_LAYERS
			#pragma editor_sync_compilation
			#pragma shader_feature_local _NORMALMAP
			#pragma shader_feature_local _MASKMAP


			#if defined(ASE_EARLY_Z_DEPTH_OPTIMIZE) && (SHADER_TARGET >= 45)
				#define ASE_SV_DEPTH SV_DepthLessEqual
				#define ASE_SV_POSITION_QUALIFIERS linear noperspective centroid
			#else
				#define ASE_SV_DEPTH SV_Depth
				#define ASE_SV_POSITION_QUALIFIERS
			#endif

			struct Attributes
			{
				float4 positionOS : POSITION;
				float3 positionOld : TEXCOORD4;
				#if _ADD_PRECOMPUTED_VELOCITY
					float3 alembicMotionVector : TEXCOORD5;
				#endif
				half3 normalOS : NORMAL;
				half4 tangentOS : TANGENT;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct PackedVaryings
			{
				float4 positionCS : SV_POSITION;
				float4 positionCSNoJitter : TEXCOORD0;
				float4 previousPositionCSNoJitter : TEXCOORD1;
				float3 positionWS : TEXCOORD2;
				float4 ase_texcoord3 : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _Control_ST;
			float4 _MaskMapRemapScale4;
			float4 _MaskMapRemapOffset4;
			float4 _MaskMapRemapScale3;
			half4 _SnowColor;
			float4 _SnowMainUVs;
			float4 _MaskMapRemapOffset3;
			float4 _MaskMapRemapOffset2;
			float4 _MaskMapRemapScale1;
			float4 _MaskMapRemapOffset1;
			float4 _SnowMapSplat_ST;
			float4 _MaskMapRemapScale0;
			float4 _Specular7;
			float4 _Specular6;
			float4 _Specular5;
			float4 _MaskMapRemapScale7;
			float4 _Specular4;
			float4 _Specular3;
			float4 _Specular2;
			float4 _Specular1;
			float4 _Specular0;
			float4 _MaskMapRemapOffset0;
			float4 _Splat7_ST;
			float4 _MaskMapRemapScale2;
			float4 _MaskMapRemapOffset5;
			float4 _DiffuseRemapScale7;
			float4 _MaskMapRemapScale6;
			float4 _Splat2_ST;
			float4 _DiffuseRemapScale2;
			float4 _DiffuseRemapScale3;
			float4 _Splat3_ST;
			float4 _Splat1_ST;
			float4 _MaskMapRemapOffset6;
			float4 _DiffuseRemapScale1;
			float4 _DiffuseRemapScale4;
			float4 _Control1_ST;
			float4 _Splat0_ST;
			float4 _Splat6_ST;
			float4 _DiffuseRemapScale6;
			float4 _MaskMapRemapOffset7;
			float4 _Splat5_ST;
			float4 _MaskMapRemapScale5;
			float4 _DiffuseRemapScale0;
			float4 _Splat4_ST;
			float4 _DiffuseRemapScale5;
			half _SnowNormalStrength;
			float _LayerHasMask6;
			float _OpacityAsDensity1;
			half _NormalScale7;
			float _Smoothness0;
			float _OpacityAsDensity0;
			float _Smoothness1;
			float _Smoothness2;
			float _OpacityAsDensity5;
			float _Smoothness3;
			float _LayerHasMask4;
			float _LayerHasMask3;
			float _LayerHasMask5;
			float _LayerHasMask2;
			half _NormalScale6;
			float _LayerHasMask1;
			float _LayerHasMask0;
			float _OpacityAsDensity7;
			float _Smoothness7;
			float _OpacityAsDensity6;
			float _Smoothness6;
			float _Smoothness5;
			float _OpacityAsDensity4;
			float _Smoothness4;
			float _OpacityAsDensity3;
			float _OpacityAsDensity2;
			half _NormalScale5;
			float _Metallic2;
			half _NormalScale3;
			half _SnowSplatGBlendFalloff;
			half _SnowSplatGBlendFactor;
			half _SnowSplatREnable;
			half _SnowSplatRMax;
			half _SnowSplatRMin;
			half _SnowSplatRBlendStrength;
			half _SnowSplatRBlendFalloff;
			half _SnowSplatRBlendFactor;
			half _SnowBrightness;
			half _SnowSaturation;
			half _SnowSplatGBlendStrength;
			half _SnowSplatASplatBias;
			half _SnowSplatGSplatBias;
			half _SnowSplatRSplatBias;
			half _Splat7Brightness;
			half _Splat6Brightness;
			half _Splat5Brightness;
			half _Splat4Brightness;
			half _Splat3Brightness;
			half _Splat2Brightness;
			half _Splat1Brightness;
			half _Splat0Brightness;
			half _SnowSplatBSplatBias;
			half _SnowSplatGMin;
			half _SnowSplatGMax;
			half _SnowSplatGEnable;
			half _NormalScale2;
			half _NormalScale1;
			half _NormalScale0;
			float _Metallic7;
			float _Metallic6;
			float _Metallic5;
			float _Metallic4;
			float _Metallic3;
			float _Metallic1;
			float _Metallic0;
			half _SnowEnable;
			half _SnowSplatAEnable;
			half _SnowSplatAMax;
			half _SnowSplatAMin;
			half _SnowSplatABlendStrength;
			half _SnowSplatABlendFalloff;
			half _SnowSplatABlendFactor;
			half _SnowSplatBEnable;
			half _SnowSplatBMax;
			half _SnowSplatBMin;
			half _SnowSplatBBlendStrength;
			half _SnowSplatBBlendFalloff;
			half _SnowSplatBBlendFactor;
			half _NormalScale4;
			float _LayerHasMask7;
			float _AlphaClip;
			float _Cutoff;
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
			CBUFFER_END

			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			TEXTURE2D(_TerrainHolesTexture);
			SAMPLER(sampler_TerrainHolesTexture);
			#ifdef UNITY_INSTANCING_ENABLED//ASE Terrain Instancing
				TEXTURE2D(_TerrainHeightmapTexture);//ASE Terrain Instancing
				TEXTURE2D( _TerrainNormalmapTexture);//ASE Terrain Instancing
				SAMPLER(sampler_TerrainNormalmapTexture);//ASE Terrain Instancing
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
				float2 sampleCoords = ( patchVertex.xy + instanceData.xy ) * instanceData.z;
				float height = UnpackHeightmap( _TerrainHeightmapTexture.Load( int3( sampleCoords, 0 ) ) );
				position.xz = sampleCoords* _TerrainHeightmapScale.xz;
				position.y = height* _TerrainHeightmapScale.y;
				#ifdef ENABLE_TERRAIN_PERPIXEL_NORMAL
					normal = float3(0, 1, 0);
				#else
					normal = _TerrainNormalmapTexture.Load(int3(sampleCoords, 0)).rgb* 2 - 1;
				#endif
				texcoord.xy = sampleCoords* _TerrainHeightmapRecipSize.zw;
			#endif
			}
			

			PackedVaryings VertexFunction( Attributes input  )
			{
				PackedVaryings output = (PackedVaryings)0;
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_TRANSFER_INSTANCE_ID(input, output);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(output);

				#if defined( ASE_INSTANCED_TERRAIN ) && !defined( ASE_TESSELLATION )
					TerrainApplyMeshModification( input.positionOS.xyz, input.normalOS, input.ase_texcoord );
				#endif
				
				output.ase_texcoord3.xy = input.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				output.ase_texcoord3.zw = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = input.positionOS.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = defaultVertexValue;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					input.positionOS.xyz = vertexValue;
				#else
					input.positionOS.xyz += vertexValue;
				#endif

				VertexPositionInputs vertexInput = GetVertexPositionInputs( input.positionOS.xyz );

				#if defined(APPLICATION_SPACE_WARP_MOTION)
					output.positionCSNoJitter = mul(_NonJitteredViewProjMatrix, mul(UNITY_MATRIX_M, input.positionOS));
					output.positionCS = output.positionCSNoJitter;
				#else
					output.positionCS = vertexInput.positionCS;
					output.positionCSNoJitter = mul(_NonJitteredViewProjMatrix, mul(UNITY_MATRIX_M, input.positionOS));
				#endif

				float4 prevPos = ( unity_MotionVectorsParams.x == 1 ) ? float4( input.positionOld, 1 ) : input.positionOS;

				#if _ADD_PRECOMPUTED_VELOCITY
					prevPos = prevPos - float4(input.alembicMotionVector, 0);
				#endif

				output.previousPositionCSNoJitter = mul( _PrevViewProjMatrix, mul( UNITY_PREV_MATRIX_M, prevPos ) );

				output.positionWS = vertexInput.positionWS;

				// removed in ObjectMotionVectors.hlsl found in unity 6000.0.23 and higher
				//ApplyMotionVectorZBias( output.positionCS );
				return output;
			}

			PackedVaryings vert ( Attributes input )
			{
				return VertexFunction( input );
			}

			half4 frag(	PackedVaryings input
				#if defined( ASE_DEPTH_WRITE_ON )
				,out float outputDepth : ASE_SV_DEPTH
				#endif
				 ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( input );

				float3 PositionWS = input.positionWS;
				float3 PositionRWS = GetCameraRelativePositionWS( PositionWS );
				float4 ScreenPosNorm = float4( GetNormalizedScreenSpaceUV( input.positionCS ), input.positionCS.zw );
				float4 ClipPos = ComputeClipSpacePosition( ScreenPosNorm.xy, input.positionCS.z ) * input.positionCS.w;

				float2 uv_TerrainHolesTexture451_g83 = input.ase_texcoord3.xy;
				float4 tex2DNode451_g83 = SAMPLE_TEXTURE2D( _TerrainHolesTexture, sampler_TerrainHolesTexture, uv_TerrainHolesTexture451_g83 );
				

				float Alpha = ( 0.5 + 1E-37 );
				#if defined( _ALPHATEST_ON )
					float AlphaClipThreshold = ( 1.0 - tex2DNode451_g83 ).r;
				#endif

				#if defined( ASE_DEPTH_WRITE_ON )
					input.positionCS.z = input.positionCS.z;
				#endif

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				#if defined(ASE_CHANGES_WORLD_POS)
					float3 positionOS = mul( GetWorldToObjectMatrix(),  float4( PositionWS, 1.0 ) ).xyz;
					float3 previousPositionWS = mul( GetPrevObjectToWorldMatrix(),  float4( positionOS, 1.0 ) ).xyz;
					input.positionCSNoJitter = mul( _NonJitteredViewProjMatrix, float4( PositionWS, 1.0 ) );
					input.previousPositionCSNoJitter = mul( _PrevViewProjMatrix, float4( previousPositionWS, 1.0 ) );
				#endif

				#if defined(LOD_FADE_CROSSFADE)
					LODFadeCrossFade( input.positionCS );
				#endif

				#if defined( ASE_DEPTH_WRITE_ON )
					outputDepth = input.positionCS.z;
				#endif

				#if defined(APPLICATION_SPACE_WARP_MOTION)
					return float4( CalcAswNdcMotionVectorFromCsPositions( input.positionCSNoJitter, input.previousPositionCSNoJitter ), 1 );
				#else
					return float4( CalcNdcMotionVectorFromCsPositions( input.positionCSNoJitter, input.previousPositionCSNoJitter ), 0, 0 );
				#endif
			}
			ENDHLSL
		}

	
	}
	
	CustomEditor "UnityEditor.ShaderGraphLitGUI"
	FallBack "Hidden/Shader Graph/FallbackError"
	
	Dependency "BaseMapShader"="Hidden/Universal Render Pipeline/Terrain/Lit (Base Pass)"
	Dependency "BaseMapGenShader"="Hidden/Universal Render Pipeline/Terrain/Lit (Basemap Gen)"

	Fallback "Hidden/Universal Render Pipeline/FallbackError"
}

/*ASEBEGIN
Version=19907
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;144;320,0;Inherit;False;Terrain 8 Layer;0;;83;08d11189af276e64bad87e6cdb726c83;71,2092,0,2085,0,2093,0,2094,0,2095,0,2096,0,2086,0,2200,0,2198,0,2196,0,2202,0,2222,0,2213,0,2194,0,2278,0,2283,0,2267,0,2266,0,2264,0,2265,0,2263,0,2363,0,2358,0,2347,0,2343,0,2344,0,2345,0,2346,0,2417,0,2416,0,2429,0,2414,0,2418,0,2434,0,2415,0,2476,0,2475,0,2474,0,2473,0,2477,0,2488,0,2493,0,2552,0,2547,0,2536,0,2534,0,2533,0,2535,0,2532,0,2592,0,2611,0,2606,0,2593,0,2594,0,2595,0,2591,0,102,1,976,1,978,1,2671,0,2666,0,669,1,668,1,2718,0,2731,0,2717,0,2716,0,2683,0,2691,0,2689,0,2675,0;0;10;FLOAT3;0;FLOAT3;14;FLOAT3;1815;FLOAT;45;FLOAT;200;FLOAT;975;COLOR;979;FLOAT;1862;FLOAT3;998;FLOAT4;999
Node;AmplifyShaderEditor.StickyNoteNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;145;896,0;Inherit;False;383.6152;387.7935;URP;;0,0,0,1;***Additional Directives***$#define TERRAIN_SPLAT_FIRSTPASS 1$#define _LAYER_COUNT 8$#pragma shader_feature_local _TERRAIN_8_LAYERS$#pragma editor_sync_compilation$#pragma shader_feature_local _NORMALMAP$#pragma shader_feature_local _MASKMAP$$*** Custom SubShader Tags ***$DisableBatching = False$IgnoreProjector = True$TerrainCompatible = True$SplatCount = 8$$MaskMapR = Metallic$MaskMapG = AO$MaskMapB = Height$MaskMapA = Smoothness$$AlwaysRenderMotionVectors = false$$$;0;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;124;640,32;Float;False;False;-1;3;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;ExtraPrePass;0;0;ExtraPrePass;6;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;False;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;5;True;14;all;0;False;True;1;1;False;;0;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;False;True;0;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;126;640,32;Float;False;False;-1;3;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;ShadowCaster;0;2;ShadowCaster;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;False;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;5;True;14;all;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;False;False;True;False;False;False;False;0;False;;False;False;False;False;False;False;False;False;False;True;1;False;;True;3;False;;False;False;True;1;LightMode=ShadowCaster;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;127;640,32;Float;False;False;-1;3;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;DepthOnly;0;3;DepthOnly;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;False;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;5;True;14;all;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;False;False;True;True;False;False;False;0;False;;False;False;False;False;False;False;False;False;False;True;1;False;;False;False;False;True;1;LightMode=DepthOnly;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;128;640,32;Float;False;False;-1;3;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;Meta;0;4;Meta;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;False;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;5;True;14;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Meta;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;129;640,32;Float;False;False;-1;3;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;Universal2D;0;5;Universal2D;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;False;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;5;True;14;all;0;False;True;1;1;False;;0;False;;1;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;False;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;False;True;1;LightMode=Universal2D;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;130;640,32;Float;False;False;-1;3;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;DepthNormals;0;6;DepthNormals;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;False;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;5;True;14;all;0;False;True;1;1;False;;0;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;False;;True;3;False;;False;False;True;1;LightMode=DepthNormals;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;131;640,32;Float;False;False;-1;3;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;GBuffer;0;7;GBuffer;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;False;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;5;True;14;all;0;False;True;1;1;False;;0;False;;1;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;False;True;1;LightMode=UniversalGBuffer;False;True;10;d3d11;gles;metal;vulkan;xboxone;xboxseries;playstation;ps4;ps5;switch;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;132;640,32;Float;False;False;-1;3;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;SceneSelectionPass;0;8;SceneSelectionPass;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;False;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;5;True;14;all;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=SceneSelectionPass;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;133;640,32;Float;False;False;-1;3;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;ScenePickingPass;0;9;ScenePickingPass;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;False;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;5;True;14;all;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Picking;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;125;640,0;Float;False;True;-1;3;UnityEditor.ShaderGraphLitGUI;0;2;AmplifyShaderPack/Terrain/SinglePass Snow;94348b07e5e8bab40bd6c8a1e3df54cd;True;Forward;0;1;Forward;21;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;False;True;13;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=-100;UniversalMaterialType=Lit;DisableBatching=False=DisableBatching;TerrainCompatible=True;IgnoreProjector=True;SplatCount=8;MaskMapR=Metallic;MaskMapG=AO;MaskMapB=Height;MaskMapA=Smoothness;AlwaysRenderMotionVectors=false;True;5;True;14;all;0;False;True;1;1;False;;0;False;;1;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;False;True;10;LightMode=UniversalForward;TerrainCompatible=True;IgnoreProjector=True;SplatCount=8;MaskMapR=Metallic;MaskMapG=AO;MaskMapB=Height;MaskMapA=Smoothness;DisableBatching=False=DisableBatching;AlwaysRenderMotionVectors=false;False;False;7;Include;;False;;Native;False;0;0;;Define;TERRAIN_SPLAT_FIRSTPASS 1;False;;Custom;False;0;0;;Define;_LAYER_COUNT 8;False;;Custom;False;0;0;;Pragma;shader_feature_local _TERRAIN_8_LAYERS;False;;Custom;False;0;0;;Pragma;editor_sync_compilation;False;;Custom;False;0;0;;Pragma;shader_feature_local _NORMALMAP;False;;Custom;False;0;0;;Pragma;shader_feature_local _MASKMAP;False;;Custom;False;0;0;;Hidden/Universal Render Pipeline/FallbackError;2;BaseMapShader=Hidden/Universal Render Pipeline/Terrain/Lit (Base Pass);BaseMapGenShader=Hidden/Universal Render Pipeline/Terrain/Lit (Basemap Gen);0;Standard;51;Category;1;638920756225654303;  Instanced Terrain Normals;2;638920781037188107;Lighting Model;0;0;Workflow;0;638922786668500592;Surface;0;0;  Keep Alpha;0;0;  Refraction Model;0;0;  Blend;0;0;Two Sided;1;0;Alpha Clipping;1;0;  Use Shadow Threshold;0;0;Fragment Normal Space;0;0;Forward Only;0;0;Transmission;0;0;  Transmission Shadow;0.5,True,_ASETransmissionShadow;0;Translucency;0;0;  Translucency Strength;1,True,_ASETranslucencyStrength;0;  Normal Distortion;0.5,True,_ASETranslucencyNormalDistortion;0;  Scattering;2,True,_ASETranslucencyScattering;0;  Direct;0.9,True,_ASETranslucencyDirect;0;  Ambient;0.1,True,_ASETranslucencyAmbient;0;  Shadow;0.5,True,_ASETranslucencyShadow;0;Cast Shadows;1;0;Receive Shadows;2;0;Specular Highlights;2;0;Environment Reflections;2;0;Receive SSAO;1;0;Motion Vectors;1;0;  Add Precomputed Velocity;0;0;  XR Motion Vectors;0;0;GPU Instancing;0;638924313130822742;LOD CrossFade;1;638925405908337748;Built-in Fog;1;0;_FinalColorxAlpha;0;0;Meta Pass;1;0;Override Baked GI;0;0;Extra Pre Pass;0;0;Tessellation;0;0;  Phong;0;0;  Strength;0.5,True,_TessellationPhong;0;  Type;0;0;  Tess;16,True,_TessellationStrength;0;  Min;10,True,_TessellationDistanceMin;0;  Max;25,True,_TessellationDistanceMax;0;  Edge Length;16,False,;0;  Max Displacement;25,False,;0;Write Depth;0;0;  Early Z;0;0;Vertex Position;1;0;Debug Display;1;0;Clear Coat;0;0;0;12;False;True;True;True;True;True;True;True;True;True;True;False;True;;True;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;146;640,100;Float;False;False;-1;3;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;MotionVectors;0;10;MotionVectors;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;False;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;5;True;14;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;False;False;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=MotionVectors;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;147;640,100;Float;False;False;-1;3;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;XRMotionVectors;0;11;XRMotionVectors;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;False;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;5;True;14;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;True;1;False;;255;False;;1;False;;7;False;;3;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;False;False;False;False;True;1;LightMode=XRMotionVectors;False;False;0;;0;0;Standard;0;False;0
WireConnection;125;0;144;0
WireConnection;125;1;144;14
WireConnection;125;9;144;1815
WireConnection;125;4;144;45
WireConnection;125;5;144;200
WireConnection;125;6;144;975
WireConnection;125;7;144;979
WireConnection;125;10;144;998
WireConnection;125;30;144;999
ASEEND*/
//CHKSM=5D9A8A1FB258FB73424442346D313DF5006072CB