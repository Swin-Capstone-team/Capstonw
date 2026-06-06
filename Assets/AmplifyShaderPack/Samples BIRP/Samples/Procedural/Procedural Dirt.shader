// Made with Amplify Shader Editor v1.9.9.7
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AmplifyShaderPack/Procedural Dirt"
{
	Properties
	{
		_ConcreteTint( "Concrete Tint", Color ) = ( 1, 1, 1, 0 )
		_BaseAlbedo( "Base Albedo", 2D ) = "white" {}
		_BaseNormal( "Base Normal", 2D ) = "bump" {}
		_ConcreteNormalIntensity( "Concrete Normal Intensity", Range( 0, 2 ) ) = 0
		_BaseSmoothnessMix( "Base Smoothness Mix", 2D ) = "white" {}
		_ConcreteSmoothnessIntensity( "Concrete Smoothness Intensity", Range( 0, 5 ) ) = 0
		_SmoothnessAOBase( "Smoothness AO Base", 2D ) = "white" {}
		_BaseDisplacement( "Base Displacement", 2D ) = "white" {}
		_ConcreteDisplacement( "Concrete Displacement", Range( 0, 2 ) ) = 0
		_DirtTint( "Dirt Tint", Color ) = ( 0, 0, 0, 0 )
		[SingleLineTexture] _TopAlbedo( "Top Albedo", 2D ) = "white" {}
		[SingleLineTexture] _TopNormal( "Top Normal", 2D ) = "bump" {}
		_DirtNormalIntensity( "Dirt Normal Intensity", Range( 0, 2 ) ) = 1
		[SingleLineTexture] _TopSmoothnessAO( "Top Smoothness AO", 2D ) = "white" {}
		_DirtSmoothnessIntensity( "Dirt Smoothness Intensity", Range( 0, 2 ) ) = 0
		[SingleLineTexture] _TopDisplacement( "Top Displacement", 2D ) = "white" {}
		_DirtDisplacement( "Dirt Displacement", Range( 0, 2 ) ) = 0
		_Rotation( "Rotation", Range( 0, 360 ) ) = 0
		_Tiling( "Tiling", Vector ) = ( 0, 0, 0, 0 )
		_Offset( "Offset", Vector ) = ( 0, 0, 0, 0 )
		_MaskGain( "Mask Gain", Float ) = 0
		_MaskDetailScale( "Mask Detail Scale", Float ) = 20.33
		_MaskShapeScale( "Mask Shape Scale", Float ) = 20.33
		_MaskConstrast( "Mask Constrast", Float ) = 0
		_BlendStrength( "Blend Strength", Float ) = 12.42
		_NoiseTileX( "Noise Tile X", Range( 0, 10 ) ) = 1
		_NoiseTileY( "Noise Tile Y", Range( 0, 10 ) ) = 1
		_NoiseoffsetX( "Noise offset X", Range( 0, 10 ) ) = 1
		_NoiseoffsetY( "Noise offset Y", Range( 0, 10 ) ) = 1
		_MaskTilingX( "Mask Tiling X", Range( 0, 10 ) ) = 0
		_MaskTilingY( "Mask Tiling Y", Range( 0, 10 ) ) = 0
		_MaskPositionX( "Mask Position X", Range( -1, 1 ) ) = -0.5
		_MaskPositionY( "Mask Position Y", Range( -1, 1 ) ) = -0.53
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

		//_InstancedTerrainNormals("Specular Highlights", Float) = 1.0
	}

	SubShader
	{
		

		

		Tags { "RenderType"="Opaque" "Queue"="Geometry" "DisableBatching"="False" }

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
				#define ASE_NEEDS_VERT_TEXTURE_COORDINATES0
				#define ASE_NEEDS_VERT_NORMAL
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

				uniform sampler2D _TopDisplacement;
				uniform float2 _Tiling;
				uniform float2 _Offset;
				uniform float _Rotation;
				uniform float _DirtDisplacement;
				uniform sampler2D _BaseDisplacement;
				uniform float4 _BaseDisplacement_ST;
				uniform float _ConcreteDisplacement;
				uniform float _MaskShapeScale;
				uniform float _NoiseTileX;
				uniform float _NoiseTileY;
				uniform float _NoiseoffsetX;
				uniform float _NoiseoffsetY;
				uniform float _MaskDetailScale;
				uniform float _MaskTilingX;
				uniform float _MaskTilingY;
				uniform float _MaskPositionX;
				uniform float _MaskPositionY;
				uniform float _MaskGain;
				uniform float _MaskConstrast;
				uniform float _BlendStrength;
				uniform float4 _DirtTint;
				uniform sampler2D _TopAlbedo;
				uniform float4 _ConcreteTint;
				uniform sampler2D _BaseAlbedo;
				uniform float4 _BaseAlbedo_ST;
				uniform sampler2D _TopNormal;
				uniform float _DirtNormalIntensity;
				uniform sampler2D _BaseNormal;
				uniform float4 _BaseNormal_ST;
				uniform float _ConcreteNormalIntensity;
				uniform sampler2D _TopSmoothnessAO;
				uniform float _DirtSmoothnessIntensity;
				uniform sampler2D _BaseSmoothnessMix;
				uniform float4 _BaseSmoothnessMix_ST;
				uniform float _ConcreteSmoothnessIntensity;
				uniform sampler2D _SmoothnessAOBase;
				uniform float4 _SmoothnessAOBase_ST;


				inline float noise_randomValue (float2 uv) { return frac(sin(dot(uv, float2(12.9898, 78.233)))*43758.5453); }
				inline float noise_interpolate (float a, float b, float t) { return (1.0-t)*a + (t*b); }
				inline float valueNoise (float2 uv)
				{
					float2 i = floor(uv);
					float2 f = frac( uv );
					f = f* f * (3.0 - 2.0 * f);
					uv = abs( frac(uv) - 0.5);
					float2 c0 = i + float2( 0.0, 0.0 );
					float2 c1 = i + float2( 1.0, 0.0 );
					float2 c2 = i + float2( 0.0, 1.0 );
					float2 c3 = i + float2( 1.0, 1.0 );
					float r0 = noise_randomValue( c0 );
					float r1 = noise_randomValue( c1 );
					float r2 = noise_randomValue( c2 );
					float r3 = noise_randomValue( c3 );
					float bottomOfGrid = noise_interpolate( r0, r1, f.x );
					float topOfGrid = noise_interpolate( r2, r3, f.x );
					float t = noise_interpolate( bottomOfGrid, topOfGrid, f.y );
					return t;
				}
				
				float SimpleNoise(float2 UV)
				{
					float t = 0.0;
					float freq = pow( 2.0, float( 0 ) );
					float amp = pow( 0.5, float( 3 - 0 ) );
					t += valueNoise( UV/freq )*amp;
					freq = pow(2.0, float(1));
					amp = pow(0.5, float(3-1));
					t += valueNoise( UV/freq )*amp;
					freq = pow(2.0, float(2));
					amp = pow(0.5, float(3-2));
					t += valueNoise( UV/freq )*amp;
					return t;
				}
				

				v2f VertexFunction( appdata v  )
				{
					UNITY_SETUP_INSTANCE_ID(v);
					v2f o;
					UNITY_INITIALIZE_OUTPUT(v2f,o);
					UNITY_TRANSFER_INSTANCE_ID(v,o);
					UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

					float2 texCoord16 = v.texcoord.xyzw.xy * _Tiling + _Offset;
					float cos17 = cos( radians( _Rotation ) );
					float sin17 = sin( radians( _Rotation ) );
					float2 rotator17 = mul( texCoord16 - float2( 0.5,0.5 ) , float2x2( cos17 , -sin17 , sin17 , cos17 )) + float2( 0.5,0.5 );
					float2 UVManipulation97 = rotator17;
					float4 temp_cast_0 = (0.16).xxxx;
					float2 uv_BaseDisplacement = v.texcoord.xyzw.xy * _BaseDisplacement_ST.xy + _BaseDisplacement_ST.zw;
					float4 temp_cast_2 = (0.16).xxxx;
					float2 texCoord216 = v.texcoord.xyzw.xy * float2( 1,1 ) + float2( 0,0 );
					float simpleNoise218 = SimpleNoise( texCoord216*_MaskShapeScale );
					float4 appendResult204 = (float4(_NoiseTileX , _NoiseTileY , 0.0 , 0.0));
					float4 appendResult211 = (float4(_NoiseoffsetX , _NoiseoffsetY , 0.0 , 0.0));
					float2 texCoord147 = v.texcoord.xyzw.xy * appendResult204.xy + appendResult211.xy;
					float simpleNoise146 = SimpleNoise( texCoord147*_MaskDetailScale );
					float4 appendResult210 = (float4(_MaskTilingX , _MaskTilingY , 0.0 , 0.0));
					float4 appendResult207 = (float4(_MaskPositionX , _MaskPositionY , 0.0 , 0.0));
					float2 texCoord41 = v.texcoord.xyzw.xy * appendResult210.xy + appendResult207.xy;
					float HeightMask163 = saturate(pow(((abs( ( simpleNoise218 * simpleNoise146 ) )*abs( saturate(  (0.0 + ( abs( length( texCoord41 ) ) - _MaskGain ) * ( 1.0 - 0.0 ) / ( _MaskConstrast - _MaskGain ) ) ) ))*4)+(abs( saturate(  (0.0 + ( abs( length( texCoord41 ) ) - _MaskGain ) * ( 1.0 - 0.0 ) / ( _MaskConstrast - _MaskGain ) ) ) )*2),_BlendStrength));
					float DirtMask94 = saturate( HeightMask163 );
					float4 lerpResult141 = lerp( ( ( tex2Dlod( _TopDisplacement, float4( UVManipulation97, 0, 0.0) ) - temp_cast_0 ) * float4( v.normal , 0.0 ) * _DirtDisplacement ) , ( ( tex2Dlod( _BaseDisplacement, float4( uv_BaseDisplacement, 0, 0.0) ) - temp_cast_2 ) * float4( v.normal , 0.0 ) * _ConcreteDisplacement ) , DirtMask94);
					
					o.ase_texcoord6.xy = v.texcoord.xyzw.xy;
					
					//setting value to unused interpolator channels and avoid initialization warnings
					o.ase_texcoord6.zw = 0;

					#ifdef ASE_ABSOLUTE_VERTEX_POS
						float3 defaultVertexValue = v.vertex.xyz;
					#else
						float3 defaultVertexValue = float3(0, 0, 0);
					#endif
					float3 vertexValue = lerpResult141.rgb;
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

					float2 texCoord16 = IN.ase_texcoord6.xy * _Tiling + _Offset;
					float cos17 = cos( radians( _Rotation ) );
					float sin17 = sin( radians( _Rotation ) );
					float2 rotator17 = mul( texCoord16 - float2( 0.5,0.5 ) , float2x2( cos17 , -sin17 , sin17 , cos17 )) + float2( 0.5,0.5 );
					float2 UVManipulation97 = rotator17;
					float2 uv_BaseAlbedo = IN.ase_texcoord6.xy * _BaseAlbedo_ST.xy + _BaseAlbedo_ST.zw;
					float2 texCoord216 = IN.ase_texcoord6.xy * float2( 1,1 ) + float2( 0,0 );
					float simpleNoise218 = SimpleNoise( texCoord216*_MaskShapeScale );
					float4 appendResult204 = (float4(_NoiseTileX , _NoiseTileY , 0.0 , 0.0));
					float4 appendResult211 = (float4(_NoiseoffsetX , _NoiseoffsetY , 0.0 , 0.0));
					float2 texCoord147 = IN.ase_texcoord6.xy * appendResult204.xy + appendResult211.xy;
					float simpleNoise146 = SimpleNoise( texCoord147*_MaskDetailScale );
					float4 appendResult210 = (float4(_MaskTilingX , _MaskTilingY , 0.0 , 0.0));
					float4 appendResult207 = (float4(_MaskPositionX , _MaskPositionY , 0.0 , 0.0));
					float2 texCoord41 = IN.ase_texcoord6.xy * appendResult210.xy + appendResult207.xy;
					float HeightMask163 = saturate(pow(((abs( ( simpleNoise218 * simpleNoise146 ) )*abs( saturate(  (0.0 + ( abs( length( texCoord41 ) ) - _MaskGain ) * ( 1.0 - 0.0 ) / ( _MaskConstrast - _MaskGain ) ) ) ))*4)+(abs( saturate(  (0.0 + ( abs( length( texCoord41 ) ) - _MaskGain ) * ( 1.0 - 0.0 ) / ( _MaskConstrast - _MaskGain ) ) ) )*2),_BlendStrength));
					float DirtMask94 = saturate( HeightMask163 );
					float4 lerpResult93 = lerp( ( _DirtTint * tex2D( _TopAlbedo, UVManipulation97 ) ) , ( _ConcreteTint * tex2D( _BaseAlbedo, uv_BaseAlbedo ) ) , DirtMask94);
					
					float2 uv_BaseNormal = IN.ase_texcoord6.xy * _BaseNormal_ST.xy + _BaseNormal_ST.zw;
					float3 lerpResult103 = lerp( UnpackScaleNormal( tex2D( _TopNormal, UVManipulation97 ), _DirtNormalIntensity ) , UnpackScaleNormal( tex2D( _BaseNormal, uv_BaseNormal ), _ConcreteNormalIntensity ) , DirtMask94);
					float3 normalizeResult105 = normalize( lerpResult103 );
					
					float4 tex2DNode221 = tex2D( _TopSmoothnessAO, UVManipulation97 );
					float2 uv_BaseSmoothnessMix = IN.ase_texcoord6.xy * _BaseSmoothnessMix_ST.xy + _BaseSmoothnessMix_ST.zw;
					float lerpResult107 = lerp( ( tex2DNode221.r * _DirtSmoothnessIntensity ) , ( tex2D( _BaseSmoothnessMix, uv_BaseSmoothnessMix ).r * _ConcreteSmoothnessIntensity ) , DirtMask94);
					
					float2 uv_SmoothnessAOBase = IN.ase_texcoord6.xy * _SmoothnessAOBase_ST.xy + _SmoothnessAOBase_ST.zw;
					float lerpResult109 = lerp( tex2DNode221.g , tex2D( _SmoothnessAOBase, uv_SmoothnessAOBase ).g , DirtMask94);
					

					o.Albedo = lerpResult93.rgb;
					o.Normal = normalizeResult105;

					half3 Specular = half3( 0, 0, 0 );
					half Metallic = 0;
					half Smoothness = lerpResult107;
					half Occlusion = lerpResult109;

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
					o.Alpha = 1;
					half AlphaClipThreshold = 0.5;
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
				#define ASE_GEOMETRY
				#define ASE_FRAGMENT_NORMAL 0
				#define ASE_RECEIVE_SHADOWS
				#pragma shader_feature_local_fragment _SPECULARHIGHLIGHTS_OFF
				#pragma multi_compile_instancing
				#pragma multi_compile _ LOD_FADE_CROSSFADE
				#pragma multi_compile_fog
				#define ASE_FOG
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
				#define ASE_NEEDS_VERT_TEXTURE_COORDINATES0
				#define ASE_NEEDS_VERT_NORMAL
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

				uniform sampler2D _TopDisplacement;
				uniform float2 _Tiling;
				uniform float2 _Offset;
				uniform float _Rotation;
				uniform float _DirtDisplacement;
				uniform sampler2D _BaseDisplacement;
				uniform float4 _BaseDisplacement_ST;
				uniform float _ConcreteDisplacement;
				uniform float _MaskShapeScale;
				uniform float _NoiseTileX;
				uniform float _NoiseTileY;
				uniform float _NoiseoffsetX;
				uniform float _NoiseoffsetY;
				uniform float _MaskDetailScale;
				uniform float _MaskTilingX;
				uniform float _MaskTilingY;
				uniform float _MaskPositionX;
				uniform float _MaskPositionY;
				uniform float _MaskGain;
				uniform float _MaskConstrast;
				uniform float _BlendStrength;
				uniform float4 _DirtTint;
				uniform sampler2D _TopAlbedo;
				uniform float4 _ConcreteTint;
				uniform sampler2D _BaseAlbedo;
				uniform float4 _BaseAlbedo_ST;
				uniform sampler2D _TopNormal;
				uniform float _DirtNormalIntensity;
				uniform sampler2D _BaseNormal;
				uniform float4 _BaseNormal_ST;
				uniform float _ConcreteNormalIntensity;
				uniform sampler2D _TopSmoothnessAO;
				uniform float _DirtSmoothnessIntensity;
				uniform sampler2D _BaseSmoothnessMix;
				uniform float4 _BaseSmoothnessMix_ST;
				uniform float _ConcreteSmoothnessIntensity;
				uniform sampler2D _SmoothnessAOBase;
				uniform float4 _SmoothnessAOBase_ST;


				inline float noise_randomValue (float2 uv) { return frac(sin(dot(uv, float2(12.9898, 78.233)))*43758.5453); }
				inline float noise_interpolate (float a, float b, float t) { return (1.0-t)*a + (t*b); }
				inline float valueNoise (float2 uv)
				{
					float2 i = floor(uv);
					float2 f = frac( uv );
					f = f* f * (3.0 - 2.0 * f);
					uv = abs( frac(uv) - 0.5);
					float2 c0 = i + float2( 0.0, 0.0 );
					float2 c1 = i + float2( 1.0, 0.0 );
					float2 c2 = i + float2( 0.0, 1.0 );
					float2 c3 = i + float2( 1.0, 1.0 );
					float r0 = noise_randomValue( c0 );
					float r1 = noise_randomValue( c1 );
					float r2 = noise_randomValue( c2 );
					float r3 = noise_randomValue( c3 );
					float bottomOfGrid = noise_interpolate( r0, r1, f.x );
					float topOfGrid = noise_interpolate( r2, r3, f.x );
					float t = noise_interpolate( bottomOfGrid, topOfGrid, f.y );
					return t;
				}
				
				float SimpleNoise(float2 UV)
				{
					float t = 0.0;
					float freq = pow( 2.0, float( 0 ) );
					float amp = pow( 0.5, float( 3 - 0 ) );
					t += valueNoise( UV/freq )*amp;
					freq = pow(2.0, float(1));
					amp = pow(0.5, float(3-1));
					t += valueNoise( UV/freq )*amp;
					freq = pow(2.0, float(2));
					amp = pow(0.5, float(3-2));
					t += valueNoise( UV/freq )*amp;
					return t;
				}
				

				v2f VertexFunction (appdata v  ) {
					UNITY_SETUP_INSTANCE_ID(v);
					v2f o;
					UNITY_INITIALIZE_OUTPUT(v2f,o);
					UNITY_TRANSFER_INSTANCE_ID(v,o);
					UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

					float2 texCoord16 = v.texcoord.xyzw.xy * _Tiling + _Offset;
					float cos17 = cos( radians( _Rotation ) );
					float sin17 = sin( radians( _Rotation ) );
					float2 rotator17 = mul( texCoord16 - float2( 0.5,0.5 ) , float2x2( cos17 , -sin17 , sin17 , cos17 )) + float2( 0.5,0.5 );
					float2 UVManipulation97 = rotator17;
					float4 temp_cast_0 = (0.16).xxxx;
					float2 uv_BaseDisplacement = v.texcoord.xyzw.xy * _BaseDisplacement_ST.xy + _BaseDisplacement_ST.zw;
					float4 temp_cast_2 = (0.16).xxxx;
					float2 texCoord216 = v.texcoord.xyzw.xy * float2( 1,1 ) + float2( 0,0 );
					float simpleNoise218 = SimpleNoise( texCoord216*_MaskShapeScale );
					float4 appendResult204 = (float4(_NoiseTileX , _NoiseTileY , 0.0 , 0.0));
					float4 appendResult211 = (float4(_NoiseoffsetX , _NoiseoffsetY , 0.0 , 0.0));
					float2 texCoord147 = v.texcoord.xyzw.xy * appendResult204.xy + appendResult211.xy;
					float simpleNoise146 = SimpleNoise( texCoord147*_MaskDetailScale );
					float4 appendResult210 = (float4(_MaskTilingX , _MaskTilingY , 0.0 , 0.0));
					float4 appendResult207 = (float4(_MaskPositionX , _MaskPositionY , 0.0 , 0.0));
					float2 texCoord41 = v.texcoord.xyzw.xy * appendResult210.xy + appendResult207.xy;
					float HeightMask163 = saturate(pow(((abs( ( simpleNoise218 * simpleNoise146 ) )*abs( saturate(  (0.0 + ( abs( length( texCoord41 ) ) - _MaskGain ) * ( 1.0 - 0.0 ) / ( _MaskConstrast - _MaskGain ) ) ) ))*4)+(abs( saturate(  (0.0 + ( abs( length( texCoord41 ) ) - _MaskGain ) * ( 1.0 - 0.0 ) / ( _MaskConstrast - _MaskGain ) ) ) )*2),_BlendStrength));
					float DirtMask94 = saturate( HeightMask163 );
					float4 lerpResult141 = lerp( ( ( tex2Dlod( _TopDisplacement, float4( UVManipulation97, 0, 0.0) ) - temp_cast_0 ) * float4( v.normal , 0.0 ) * _DirtDisplacement ) , ( ( tex2Dlod( _BaseDisplacement, float4( uv_BaseDisplacement, 0, 0.0) ) - temp_cast_2 ) * float4( v.normal , 0.0 ) * _ConcreteDisplacement ) , DirtMask94);
					
					o.ase_texcoord5.xy = v.texcoord.xyzw.xy;
					
					//setting value to unused interpolator channels and avoid initialization warnings
					o.ase_texcoord5.zw = 0;

					#ifdef ASE_ABSOLUTE_VERTEX_POS
						float3 defaultVertexValue = v.vertex.xyz;
					#else
						float3 defaultVertexValue = float3(0, 0, 0);
					#endif
					float3 vertexValue = lerpResult141.rgb;
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

					float2 texCoord16 = IN.ase_texcoord5.xy * _Tiling + _Offset;
					float cos17 = cos( radians( _Rotation ) );
					float sin17 = sin( radians( _Rotation ) );
					float2 rotator17 = mul( texCoord16 - float2( 0.5,0.5 ) , float2x2( cos17 , -sin17 , sin17 , cos17 )) + float2( 0.5,0.5 );
					float2 UVManipulation97 = rotator17;
					float2 uv_BaseAlbedo = IN.ase_texcoord5.xy * _BaseAlbedo_ST.xy + _BaseAlbedo_ST.zw;
					float2 texCoord216 = IN.ase_texcoord5.xy * float2( 1,1 ) + float2( 0,0 );
					float simpleNoise218 = SimpleNoise( texCoord216*_MaskShapeScale );
					float4 appendResult204 = (float4(_NoiseTileX , _NoiseTileY , 0.0 , 0.0));
					float4 appendResult211 = (float4(_NoiseoffsetX , _NoiseoffsetY , 0.0 , 0.0));
					float2 texCoord147 = IN.ase_texcoord5.xy * appendResult204.xy + appendResult211.xy;
					float simpleNoise146 = SimpleNoise( texCoord147*_MaskDetailScale );
					float4 appendResult210 = (float4(_MaskTilingX , _MaskTilingY , 0.0 , 0.0));
					float4 appendResult207 = (float4(_MaskPositionX , _MaskPositionY , 0.0 , 0.0));
					float2 texCoord41 = IN.ase_texcoord5.xy * appendResult210.xy + appendResult207.xy;
					float HeightMask163 = saturate(pow(((abs( ( simpleNoise218 * simpleNoise146 ) )*abs( saturate(  (0.0 + ( abs( length( texCoord41 ) ) - _MaskGain ) * ( 1.0 - 0.0 ) / ( _MaskConstrast - _MaskGain ) ) ) ))*4)+(abs( saturate(  (0.0 + ( abs( length( texCoord41 ) ) - _MaskGain ) * ( 1.0 - 0.0 ) / ( _MaskConstrast - _MaskGain ) ) ) )*2),_BlendStrength));
					float DirtMask94 = saturate( HeightMask163 );
					float4 lerpResult93 = lerp( ( _DirtTint * tex2D( _TopAlbedo, UVManipulation97 ) ) , ( _ConcreteTint * tex2D( _BaseAlbedo, uv_BaseAlbedo ) ) , DirtMask94);
					
					float2 uv_BaseNormal = IN.ase_texcoord5.xy * _BaseNormal_ST.xy + _BaseNormal_ST.zw;
					float3 lerpResult103 = lerp( UnpackScaleNormal( tex2D( _TopNormal, UVManipulation97 ), _DirtNormalIntensity ) , UnpackScaleNormal( tex2D( _BaseNormal, uv_BaseNormal ), _ConcreteNormalIntensity ) , DirtMask94);
					float3 normalizeResult105 = normalize( lerpResult103 );
					
					float4 tex2DNode221 = tex2D( _TopSmoothnessAO, UVManipulation97 );
					float2 uv_BaseSmoothnessMix = IN.ase_texcoord5.xy * _BaseSmoothnessMix_ST.xy + _BaseSmoothnessMix_ST.zw;
					float lerpResult107 = lerp( ( tex2DNode221.r * _DirtSmoothnessIntensity ) , ( tex2D( _BaseSmoothnessMix, uv_BaseSmoothnessMix ).r * _ConcreteSmoothnessIntensity ) , DirtMask94);
					
					float2 uv_SmoothnessAOBase = IN.ase_texcoord5.xy * _SmoothnessAOBase_ST.xy + _SmoothnessAOBase_ST.zw;
					float lerpResult109 = lerp( tex2DNode221.g , tex2D( _SmoothnessAOBase, uv_SmoothnessAOBase ).g , DirtMask94);
					

					o.Albedo = lerpResult93.rgb;
					o.Normal = normalizeResult105;

					half3 Specular = half3( 0, 0, 0 );
					half Metallic = 0;
					half Smoothness = lerpResult107;
					half Occlusion = lerpResult109;

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
					o.Alpha = 1;
					half AlphaClipThreshold = 0.5;
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
				#define ASE_GEOMETRY
				#define ASE_FRAGMENT_NORMAL 0
				#define ASE_RECEIVE_SHADOWS
				#pragma shader_feature_local_fragment _SPECULARHIGHLIGHTS_OFF
				#pragma shader_feature_local_fragment _GLOSSYREFLECTIONS_OFF
				#pragma multi_compile_instancing
				#pragma multi_compile _ LOD_FADE_CROSSFADE
				#define ASE_FOG
				#define ASE_VERSION 19907

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
				#define ASE_NEEDS_TEXTURE_COORDINATES0
				#define ASE_NEEDS_VERT_TEXTURE_COORDINATES0
				#define ASE_NEEDS_VERT_NORMAL
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

				uniform sampler2D _TopDisplacement;
				uniform float2 _Tiling;
				uniform float2 _Offset;
				uniform float _Rotation;
				uniform float _DirtDisplacement;
				uniform sampler2D _BaseDisplacement;
				uniform float4 _BaseDisplacement_ST;
				uniform float _ConcreteDisplacement;
				uniform float _MaskShapeScale;
				uniform float _NoiseTileX;
				uniform float _NoiseTileY;
				uniform float _NoiseoffsetX;
				uniform float _NoiseoffsetY;
				uniform float _MaskDetailScale;
				uniform float _MaskTilingX;
				uniform float _MaskTilingY;
				uniform float _MaskPositionX;
				uniform float _MaskPositionY;
				uniform float _MaskGain;
				uniform float _MaskConstrast;
				uniform float _BlendStrength;
				uniform float4 _DirtTint;
				uniform sampler2D _TopAlbedo;
				uniform float4 _ConcreteTint;
				uniform sampler2D _BaseAlbedo;
				uniform float4 _BaseAlbedo_ST;
				uniform sampler2D _TopNormal;
				uniform float _DirtNormalIntensity;
				uniform sampler2D _BaseNormal;
				uniform float4 _BaseNormal_ST;
				uniform float _ConcreteNormalIntensity;
				uniform sampler2D _TopSmoothnessAO;
				uniform float _DirtSmoothnessIntensity;
				uniform sampler2D _BaseSmoothnessMix;
				uniform float4 _BaseSmoothnessMix_ST;
				uniform float _ConcreteSmoothnessIntensity;
				uniform sampler2D _SmoothnessAOBase;
				uniform float4 _SmoothnessAOBase_ST;


				inline float noise_randomValue (float2 uv) { return frac(sin(dot(uv, float2(12.9898, 78.233)))*43758.5453); }
				inline float noise_interpolate (float a, float b, float t) { return (1.0-t)*a + (t*b); }
				inline float valueNoise (float2 uv)
				{
					float2 i = floor(uv);
					float2 f = frac( uv );
					f = f* f * (3.0 - 2.0 * f);
					uv = abs( frac(uv) - 0.5);
					float2 c0 = i + float2( 0.0, 0.0 );
					float2 c1 = i + float2( 1.0, 0.0 );
					float2 c2 = i + float2( 0.0, 1.0 );
					float2 c3 = i + float2( 1.0, 1.0 );
					float r0 = noise_randomValue( c0 );
					float r1 = noise_randomValue( c1 );
					float r2 = noise_randomValue( c2 );
					float r3 = noise_randomValue( c3 );
					float bottomOfGrid = noise_interpolate( r0, r1, f.x );
					float topOfGrid = noise_interpolate( r2, r3, f.x );
					float t = noise_interpolate( bottomOfGrid, topOfGrid, f.y );
					return t;
				}
				
				float SimpleNoise(float2 UV)
				{
					float t = 0.0;
					float freq = pow( 2.0, float( 0 ) );
					float amp = pow( 0.5, float( 3 - 0 ) );
					t += valueNoise( UV/freq )*amp;
					freq = pow(2.0, float(1));
					amp = pow(0.5, float(3-1));
					t += valueNoise( UV/freq )*amp;
					freq = pow(2.0, float(2));
					amp = pow(0.5, float(3-2));
					t += valueNoise( UV/freq )*amp;
					return t;
				}
				

				v2f VertexFunction (appdata v  ) {
					UNITY_SETUP_INSTANCE_ID(v);
					v2f o;
					UNITY_INITIALIZE_OUTPUT(v2f,o);
					UNITY_TRANSFER_INSTANCE_ID(v,o);
					UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

					float2 texCoord16 = v.texcoord.xyzw.xy * _Tiling + _Offset;
					float cos17 = cos( radians( _Rotation ) );
					float sin17 = sin( radians( _Rotation ) );
					float2 rotator17 = mul( texCoord16 - float2( 0.5,0.5 ) , float2x2( cos17 , -sin17 , sin17 , cos17 )) + float2( 0.5,0.5 );
					float2 UVManipulation97 = rotator17;
					float4 temp_cast_0 = (0.16).xxxx;
					float2 uv_BaseDisplacement = v.texcoord.xyzw.xy * _BaseDisplacement_ST.xy + _BaseDisplacement_ST.zw;
					float4 temp_cast_2 = (0.16).xxxx;
					float2 texCoord216 = v.texcoord.xyzw.xy * float2( 1,1 ) + float2( 0,0 );
					float simpleNoise218 = SimpleNoise( texCoord216*_MaskShapeScale );
					float4 appendResult204 = (float4(_NoiseTileX , _NoiseTileY , 0.0 , 0.0));
					float4 appendResult211 = (float4(_NoiseoffsetX , _NoiseoffsetY , 0.0 , 0.0));
					float2 texCoord147 = v.texcoord.xyzw.xy * appendResult204.xy + appendResult211.xy;
					float simpleNoise146 = SimpleNoise( texCoord147*_MaskDetailScale );
					float4 appendResult210 = (float4(_MaskTilingX , _MaskTilingY , 0.0 , 0.0));
					float4 appendResult207 = (float4(_MaskPositionX , _MaskPositionY , 0.0 , 0.0));
					float2 texCoord41 = v.texcoord.xyzw.xy * appendResult210.xy + appendResult207.xy;
					float HeightMask163 = saturate(pow(((abs( ( simpleNoise218 * simpleNoise146 ) )*abs( saturate(  (0.0 + ( abs( length( texCoord41 ) ) - _MaskGain ) * ( 1.0 - 0.0 ) / ( _MaskConstrast - _MaskGain ) ) ) ))*4)+(abs( saturate(  (0.0 + ( abs( length( texCoord41 ) ) - _MaskGain ) * ( 1.0 - 0.0 ) / ( _MaskConstrast - _MaskGain ) ) ) )*2),_BlendStrength));
					float DirtMask94 = saturate( HeightMask163 );
					float4 lerpResult141 = lerp( ( ( tex2Dlod( _TopDisplacement, float4( UVManipulation97, 0, 0.0) ) - temp_cast_0 ) * float4( v.normal , 0.0 ) * _DirtDisplacement ) , ( ( tex2Dlod( _BaseDisplacement, float4( uv_BaseDisplacement, 0, 0.0) ) - temp_cast_2 ) * float4( v.normal , 0.0 ) * _ConcreteDisplacement ) , DirtMask94);
					
					o.ase_texcoord4.xy = v.texcoord.xyzw.xy;
					
					//setting value to unused interpolator channels and avoid initialization warnings
					o.ase_texcoord4.zw = 0;

					#ifdef ASE_ABSOLUTE_VERTEX_POS
						float3 defaultVertexValue = v.vertex.xyz;
					#else
						float3 defaultVertexValue = float3(0, 0, 0);
					#endif
					float3 vertexValue = lerpResult141.rgb;
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

					float2 texCoord16 = IN.ase_texcoord4.xy * _Tiling + _Offset;
					float cos17 = cos( radians( _Rotation ) );
					float sin17 = sin( radians( _Rotation ) );
					float2 rotator17 = mul( texCoord16 - float2( 0.5,0.5 ) , float2x2( cos17 , -sin17 , sin17 , cos17 )) + float2( 0.5,0.5 );
					float2 UVManipulation97 = rotator17;
					float2 uv_BaseAlbedo = IN.ase_texcoord4.xy * _BaseAlbedo_ST.xy + _BaseAlbedo_ST.zw;
					float2 texCoord216 = IN.ase_texcoord4.xy * float2( 1,1 ) + float2( 0,0 );
					float simpleNoise218 = SimpleNoise( texCoord216*_MaskShapeScale );
					float4 appendResult204 = (float4(_NoiseTileX , _NoiseTileY , 0.0 , 0.0));
					float4 appendResult211 = (float4(_NoiseoffsetX , _NoiseoffsetY , 0.0 , 0.0));
					float2 texCoord147 = IN.ase_texcoord4.xy * appendResult204.xy + appendResult211.xy;
					float simpleNoise146 = SimpleNoise( texCoord147*_MaskDetailScale );
					float4 appendResult210 = (float4(_MaskTilingX , _MaskTilingY , 0.0 , 0.0));
					float4 appendResult207 = (float4(_MaskPositionX , _MaskPositionY , 0.0 , 0.0));
					float2 texCoord41 = IN.ase_texcoord4.xy * appendResult210.xy + appendResult207.xy;
					float HeightMask163 = saturate(pow(((abs( ( simpleNoise218 * simpleNoise146 ) )*abs( saturate(  (0.0 + ( abs( length( texCoord41 ) ) - _MaskGain ) * ( 1.0 - 0.0 ) / ( _MaskConstrast - _MaskGain ) ) ) ))*4)+(abs( saturate(  (0.0 + ( abs( length( texCoord41 ) ) - _MaskGain ) * ( 1.0 - 0.0 ) / ( _MaskConstrast - _MaskGain ) ) ) )*2),_BlendStrength));
					float DirtMask94 = saturate( HeightMask163 );
					float4 lerpResult93 = lerp( ( _DirtTint * tex2D( _TopAlbedo, UVManipulation97 ) ) , ( _ConcreteTint * tex2D( _BaseAlbedo, uv_BaseAlbedo ) ) , DirtMask94);
					
					float2 uv_BaseNormal = IN.ase_texcoord4.xy * _BaseNormal_ST.xy + _BaseNormal_ST.zw;
					float3 lerpResult103 = lerp( UnpackScaleNormal( tex2D( _TopNormal, UVManipulation97 ), _DirtNormalIntensity ) , UnpackScaleNormal( tex2D( _BaseNormal, uv_BaseNormal ), _ConcreteNormalIntensity ) , DirtMask94);
					float3 normalizeResult105 = normalize( lerpResult103 );
					
					float4 tex2DNode221 = tex2D( _TopSmoothnessAO, UVManipulation97 );
					float2 uv_BaseSmoothnessMix = IN.ase_texcoord4.xy * _BaseSmoothnessMix_ST.xy + _BaseSmoothnessMix_ST.zw;
					float lerpResult107 = lerp( ( tex2DNode221.r * _DirtSmoothnessIntensity ) , ( tex2D( _BaseSmoothnessMix, uv_BaseSmoothnessMix ).r * _ConcreteSmoothnessIntensity ) , DirtMask94);
					
					float2 uv_SmoothnessAOBase = IN.ase_texcoord4.xy * _SmoothnessAOBase_ST.xy + _SmoothnessAOBase_ST.zw;
					float lerpResult109 = lerp( tex2DNode221.g , tex2D( _SmoothnessAOBase, uv_SmoothnessAOBase ).g , DirtMask94);
					

					o.Albedo = lerpResult93.rgb;
					o.Normal = normalizeResult105;

					half3 Specular = half3( 0, 0, 0 );
					half Metallic = 0;
					half Smoothness = lerpResult107;
					half Occlusion = lerpResult109;

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
					o.Alpha = 1;
					half AlphaClipThreshold = 0.5;
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
				#define ASE_GEOMETRY
				#define ASE_FRAGMENT_NORMAL 0
				#define ASE_RECEIVE_SHADOWS
				#pragma multi_compile_instancing
				#pragma multi_compile _ LOD_FADE_CROSSFADE
				#define ASE_FOG
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
				#define ASE_NEEDS_VERT_TEXTURE_COORDINATES0
				#define ASE_NEEDS_VERT_NORMAL
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

				uniform sampler2D _TopDisplacement;
				uniform float2 _Tiling;
				uniform float2 _Offset;
				uniform float _Rotation;
				uniform float _DirtDisplacement;
				uniform sampler2D _BaseDisplacement;
				uniform float4 _BaseDisplacement_ST;
				uniform float _ConcreteDisplacement;
				uniform float _MaskShapeScale;
				uniform float _NoiseTileX;
				uniform float _NoiseTileY;
				uniform float _NoiseoffsetX;
				uniform float _NoiseoffsetY;
				uniform float _MaskDetailScale;
				uniform float _MaskTilingX;
				uniform float _MaskTilingY;
				uniform float _MaskPositionX;
				uniform float _MaskPositionY;
				uniform float _MaskGain;
				uniform float _MaskConstrast;
				uniform float _BlendStrength;
				uniform float4 _DirtTint;
				uniform sampler2D _TopAlbedo;
				uniform float4 _ConcreteTint;
				uniform sampler2D _BaseAlbedo;
				uniform float4 _BaseAlbedo_ST;


				inline float noise_randomValue (float2 uv) { return frac(sin(dot(uv, float2(12.9898, 78.233)))*43758.5453); }
				inline float noise_interpolate (float a, float b, float t) { return (1.0-t)*a + (t*b); }
				inline float valueNoise (float2 uv)
				{
					float2 i = floor(uv);
					float2 f = frac( uv );
					f = f* f * (3.0 - 2.0 * f);
					uv = abs( frac(uv) - 0.5);
					float2 c0 = i + float2( 0.0, 0.0 );
					float2 c1 = i + float2( 1.0, 0.0 );
					float2 c2 = i + float2( 0.0, 1.0 );
					float2 c3 = i + float2( 1.0, 1.0 );
					float r0 = noise_randomValue( c0 );
					float r1 = noise_randomValue( c1 );
					float r2 = noise_randomValue( c2 );
					float r3 = noise_randomValue( c3 );
					float bottomOfGrid = noise_interpolate( r0, r1, f.x );
					float topOfGrid = noise_interpolate( r2, r3, f.x );
					float t = noise_interpolate( bottomOfGrid, topOfGrid, f.y );
					return t;
				}
				
				float SimpleNoise(float2 UV)
				{
					float t = 0.0;
					float freq = pow( 2.0, float( 0 ) );
					float amp = pow( 0.5, float( 3 - 0 ) );
					t += valueNoise( UV/freq )*amp;
					freq = pow(2.0, float(1));
					amp = pow(0.5, float(3-1));
					t += valueNoise( UV/freq )*amp;
					freq = pow(2.0, float(2));
					amp = pow(0.5, float(3-2));
					t += valueNoise( UV/freq )*amp;
					return t;
				}
				

				v2f VertexFunction( appdata v  )
				{
					UNITY_SETUP_INSTANCE_ID(v);
					v2f o;
					UNITY_INITIALIZE_OUTPUT(v2f,o);
					UNITY_TRANSFER_INSTANCE_ID(v,o);
					UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

					float2 texCoord16 = v.texcoord.xyzw.xy * _Tiling + _Offset;
					float cos17 = cos( radians( _Rotation ) );
					float sin17 = sin( radians( _Rotation ) );
					float2 rotator17 = mul( texCoord16 - float2( 0.5,0.5 ) , float2x2( cos17 , -sin17 , sin17 , cos17 )) + float2( 0.5,0.5 );
					float2 UVManipulation97 = rotator17;
					float4 temp_cast_0 = (0.16).xxxx;
					float2 uv_BaseDisplacement = v.texcoord.xyzw.xy * _BaseDisplacement_ST.xy + _BaseDisplacement_ST.zw;
					float4 temp_cast_2 = (0.16).xxxx;
					float2 texCoord216 = v.texcoord.xyzw.xy * float2( 1,1 ) + float2( 0,0 );
					float simpleNoise218 = SimpleNoise( texCoord216*_MaskShapeScale );
					float4 appendResult204 = (float4(_NoiseTileX , _NoiseTileY , 0.0 , 0.0));
					float4 appendResult211 = (float4(_NoiseoffsetX , _NoiseoffsetY , 0.0 , 0.0));
					float2 texCoord147 = v.texcoord.xyzw.xy * appendResult204.xy + appendResult211.xy;
					float simpleNoise146 = SimpleNoise( texCoord147*_MaskDetailScale );
					float4 appendResult210 = (float4(_MaskTilingX , _MaskTilingY , 0.0 , 0.0));
					float4 appendResult207 = (float4(_MaskPositionX , _MaskPositionY , 0.0 , 0.0));
					float2 texCoord41 = v.texcoord.xyzw.xy * appendResult210.xy + appendResult207.xy;
					float HeightMask163 = saturate(pow(((abs( ( simpleNoise218 * simpleNoise146 ) )*abs( saturate(  (0.0 + ( abs( length( texCoord41 ) ) - _MaskGain ) * ( 1.0 - 0.0 ) / ( _MaskConstrast - _MaskGain ) ) ) ))*4)+(abs( saturate(  (0.0 + ( abs( length( texCoord41 ) ) - _MaskGain ) * ( 1.0 - 0.0 ) / ( _MaskConstrast - _MaskGain ) ) ) )*2),_BlendStrength));
					float DirtMask94 = saturate( HeightMask163 );
					float4 lerpResult141 = lerp( ( ( tex2Dlod( _TopDisplacement, float4( UVManipulation97, 0, 0.0) ) - temp_cast_0 ) * float4( v.normal , 0.0 ) * _DirtDisplacement ) , ( ( tex2Dlod( _BaseDisplacement, float4( uv_BaseDisplacement, 0, 0.0) ) - temp_cast_2 ) * float4( v.normal , 0.0 ) * _ConcreteDisplacement ) , DirtMask94);
					
					o.ase_texcoord2.xy = v.texcoord.xyzw.xy;
					
					//setting value to unused interpolator channels and avoid initialization warnings
					o.ase_texcoord2.zw = 0;

					#ifdef ASE_ABSOLUTE_VERTEX_POS
						float3 defaultVertexValue = v.vertex.xyz;
					#else
						float3 defaultVertexValue = float3(0, 0, 0);
					#endif
					float3 vertexValue = lerpResult141.rgb;
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

					float2 texCoord16 = IN.ase_texcoord2.xy * _Tiling + _Offset;
					float cos17 = cos( radians( _Rotation ) );
					float sin17 = sin( radians( _Rotation ) );
					float2 rotator17 = mul( texCoord16 - float2( 0.5,0.5 ) , float2x2( cos17 , -sin17 , sin17 , cos17 )) + float2( 0.5,0.5 );
					float2 UVManipulation97 = rotator17;
					float2 uv_BaseAlbedo = IN.ase_texcoord2.xy * _BaseAlbedo_ST.xy + _BaseAlbedo_ST.zw;
					float2 texCoord216 = IN.ase_texcoord2.xy * float2( 1,1 ) + float2( 0,0 );
					float simpleNoise218 = SimpleNoise( texCoord216*_MaskShapeScale );
					float4 appendResult204 = (float4(_NoiseTileX , _NoiseTileY , 0.0 , 0.0));
					float4 appendResult211 = (float4(_NoiseoffsetX , _NoiseoffsetY , 0.0 , 0.0));
					float2 texCoord147 = IN.ase_texcoord2.xy * appendResult204.xy + appendResult211.xy;
					float simpleNoise146 = SimpleNoise( texCoord147*_MaskDetailScale );
					float4 appendResult210 = (float4(_MaskTilingX , _MaskTilingY , 0.0 , 0.0));
					float4 appendResult207 = (float4(_MaskPositionX , _MaskPositionY , 0.0 , 0.0));
					float2 texCoord41 = IN.ase_texcoord2.xy * appendResult210.xy + appendResult207.xy;
					float HeightMask163 = saturate(pow(((abs( ( simpleNoise218 * simpleNoise146 ) )*abs( saturate(  (0.0 + ( abs( length( texCoord41 ) ) - _MaskGain ) * ( 1.0 - 0.0 ) / ( _MaskConstrast - _MaskGain ) ) ) ))*4)+(abs( saturate(  (0.0 + ( abs( length( texCoord41 ) ) - _MaskGain ) * ( 1.0 - 0.0 ) / ( _MaskConstrast - _MaskGain ) ) ) )*2),_BlendStrength));
					float DirtMask94 = saturate( HeightMask163 );
					float4 lerpResult93 = lerp( ( _DirtTint * tex2D( _TopAlbedo, UVManipulation97 ) ) , ( _ConcreteTint * tex2D( _BaseAlbedo, uv_BaseAlbedo ) ) , DirtMask94);
					

					o.Albedo = lerpResult93.rgb;
					o.Normal = half3( 0, 0, 1 );
					o.Emission = half3( 0, 0, 0 );
					o.Alpha = 1;
					half AlphaClipThreshold = 0.5;

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
				#define ASE_NEEDS_VERT_NORMAL
				#define ASE_NEEDS_VERT_TEXTURE_COORDINATES0


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

				uniform sampler2D _TopDisplacement;
				uniform float2 _Tiling;
				uniform float2 _Offset;
				uniform float _Rotation;
				uniform float _DirtDisplacement;
				uniform sampler2D _BaseDisplacement;
				uniform float4 _BaseDisplacement_ST;
				uniform float _ConcreteDisplacement;
				uniform float _MaskShapeScale;
				uniform float _NoiseTileX;
				uniform float _NoiseTileY;
				uniform float _NoiseoffsetX;
				uniform float _NoiseoffsetY;
				uniform float _MaskDetailScale;
				uniform float _MaskTilingX;
				uniform float _MaskTilingY;
				uniform float _MaskPositionX;
				uniform float _MaskPositionY;
				uniform float _MaskGain;
				uniform float _MaskConstrast;
				uniform float _BlendStrength;


				inline float noise_randomValue (float2 uv) { return frac(sin(dot(uv, float2(12.9898, 78.233)))*43758.5453); }
				inline float noise_interpolate (float a, float b, float t) { return (1.0-t)*a + (t*b); }
				inline float valueNoise (float2 uv)
				{
					float2 i = floor(uv);
					float2 f = frac( uv );
					f = f* f * (3.0 - 2.0 * f);
					uv = abs( frac(uv) - 0.5);
					float2 c0 = i + float2( 0.0, 0.0 );
					float2 c1 = i + float2( 1.0, 0.0 );
					float2 c2 = i + float2( 0.0, 1.0 );
					float2 c3 = i + float2( 1.0, 1.0 );
					float r0 = noise_randomValue( c0 );
					float r1 = noise_randomValue( c1 );
					float r2 = noise_randomValue( c2 );
					float r3 = noise_randomValue( c3 );
					float bottomOfGrid = noise_interpolate( r0, r1, f.x );
					float topOfGrid = noise_interpolate( r2, r3, f.x );
					float t = noise_interpolate( bottomOfGrid, topOfGrid, f.y );
					return t;
				}
				
				float SimpleNoise(float2 UV)
				{
					float t = 0.0;
					float freq = pow( 2.0, float( 0 ) );
					float amp = pow( 0.5, float( 3 - 0 ) );
					t += valueNoise( UV/freq )*amp;
					freq = pow(2.0, float(1));
					amp = pow(0.5, float(3-1));
					t += valueNoise( UV/freq )*amp;
					freq = pow(2.0, float(2));
					amp = pow(0.5, float(3-2));
					t += valueNoise( UV/freq )*amp;
					return t;
				}
				

				v2f VertexFunction( appdata v  )
				{
					UNITY_SETUP_INSTANCE_ID(v);
					v2f o;
					UNITY_INITIALIZE_OUTPUT(v2f,o);
					UNITY_TRANSFER_INSTANCE_ID(v,o);
					UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

					float2 texCoord16 = v.ase_texcoord.xy * _Tiling + _Offset;
					float cos17 = cos( radians( _Rotation ) );
					float sin17 = sin( radians( _Rotation ) );
					float2 rotator17 = mul( texCoord16 - float2( 0.5,0.5 ) , float2x2( cos17 , -sin17 , sin17 , cos17 )) + float2( 0.5,0.5 );
					float2 UVManipulation97 = rotator17;
					float4 temp_cast_0 = (0.16).xxxx;
					float2 uv_BaseDisplacement = v.ase_texcoord.xy * _BaseDisplacement_ST.xy + _BaseDisplacement_ST.zw;
					float4 temp_cast_2 = (0.16).xxxx;
					float2 texCoord216 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
					float simpleNoise218 = SimpleNoise( texCoord216*_MaskShapeScale );
					float4 appendResult204 = (float4(_NoiseTileX , _NoiseTileY , 0.0 , 0.0));
					float4 appendResult211 = (float4(_NoiseoffsetX , _NoiseoffsetY , 0.0 , 0.0));
					float2 texCoord147 = v.ase_texcoord.xy * appendResult204.xy + appendResult211.xy;
					float simpleNoise146 = SimpleNoise( texCoord147*_MaskDetailScale );
					float4 appendResult210 = (float4(_MaskTilingX , _MaskTilingY , 0.0 , 0.0));
					float4 appendResult207 = (float4(_MaskPositionX , _MaskPositionY , 0.0 , 0.0));
					float2 texCoord41 = v.ase_texcoord.xy * appendResult210.xy + appendResult207.xy;
					float HeightMask163 = saturate(pow(((abs( ( simpleNoise218 * simpleNoise146 ) )*abs( saturate(  (0.0 + ( abs( length( texCoord41 ) ) - _MaskGain ) * ( 1.0 - 0.0 ) / ( _MaskConstrast - _MaskGain ) ) ) ))*4)+(abs( saturate(  (0.0 + ( abs( length( texCoord41 ) ) - _MaskGain ) * ( 1.0 - 0.0 ) / ( _MaskConstrast - _MaskGain ) ) ) )*2),_BlendStrength));
					float DirtMask94 = saturate( HeightMask163 );
					float4 lerpResult141 = lerp( ( ( tex2Dlod( _TopDisplacement, float4( UVManipulation97, 0, 0.0) ) - temp_cast_0 ) * float4( v.normal , 0.0 ) * _DirtDisplacement ) , ( ( tex2Dlod( _BaseDisplacement, float4( uv_BaseDisplacement, 0, 0.0) ) - temp_cast_2 ) * float4( v.normal , 0.0 ) * _ConcreteDisplacement ) , DirtMask94);
					

					#ifdef ASE_ABSOLUTE_VERTEX_POS
						float3 defaultVertexValue = v.vertex.xyz;
					#else
						float3 defaultVertexValue = float3(0, 0, 0);
					#endif
					float3 vertexValue = lerpResult141.rgb;
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

					

					o.Normal = half3( 0, 0, 1 );

					o.Alpha = 1;
					half AlphaClipThreshold = 0.5;
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
				#define ASE_GEOMETRY
				#define ASE_FRAGMENT_NORMAL 0
				#define ASE_RECEIVE_SHADOWS
				#pragma multi_compile_instancing
				#pragma multi_compile _ LOD_FADE_CROSSFADE
				#define ASE_FOG
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
				#define ASE_NEEDS_VERT_NORMAL
				#define ASE_NEEDS_VERT_TEXTURE_COORDINATES0


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

				uniform sampler2D _TopDisplacement;
				uniform float2 _Tiling;
				uniform float2 _Offset;
				uniform float _Rotation;
				uniform float _DirtDisplacement;
				uniform sampler2D _BaseDisplacement;
				uniform float4 _BaseDisplacement_ST;
				uniform float _ConcreteDisplacement;
				uniform float _MaskShapeScale;
				uniform float _NoiseTileX;
				uniform float _NoiseTileY;
				uniform float _NoiseoffsetX;
				uniform float _NoiseoffsetY;
				uniform float _MaskDetailScale;
				uniform float _MaskTilingX;
				uniform float _MaskTilingY;
				uniform float _MaskPositionX;
				uniform float _MaskPositionY;
				uniform float _MaskGain;
				uniform float _MaskConstrast;
				uniform float _BlendStrength;


				inline float noise_randomValue (float2 uv) { return frac(sin(dot(uv, float2(12.9898, 78.233)))*43758.5453); }
				inline float noise_interpolate (float a, float b, float t) { return (1.0-t)*a + (t*b); }
				inline float valueNoise (float2 uv)
				{
					float2 i = floor(uv);
					float2 f = frac( uv );
					f = f* f * (3.0 - 2.0 * f);
					uv = abs( frac(uv) - 0.5);
					float2 c0 = i + float2( 0.0, 0.0 );
					float2 c1 = i + float2( 1.0, 0.0 );
					float2 c2 = i + float2( 0.0, 1.0 );
					float2 c3 = i + float2( 1.0, 1.0 );
					float r0 = noise_randomValue( c0 );
					float r1 = noise_randomValue( c1 );
					float r2 = noise_randomValue( c2 );
					float r3 = noise_randomValue( c3 );
					float bottomOfGrid = noise_interpolate( r0, r1, f.x );
					float topOfGrid = noise_interpolate( r2, r3, f.x );
					float t = noise_interpolate( bottomOfGrid, topOfGrid, f.y );
					return t;
				}
				
				float SimpleNoise(float2 UV)
				{
					float t = 0.0;
					float freq = pow( 2.0, float( 0 ) );
					float amp = pow( 0.5, float( 3 - 0 ) );
					t += valueNoise( UV/freq )*amp;
					freq = pow(2.0, float(1));
					amp = pow(0.5, float(3-1));
					t += valueNoise( UV/freq )*amp;
					freq = pow(2.0, float(2));
					amp = pow(0.5, float(3-2));
					t += valueNoise( UV/freq )*amp;
					return t;
				}
				

				v2f VertexFunction( appdata v  )
				{
					UNITY_SETUP_INSTANCE_ID(v);
					v2f o;
					UNITY_INITIALIZE_OUTPUT(v2f,o);
					UNITY_TRANSFER_INSTANCE_ID(v,o);
					UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

					float2 texCoord16 = v.ase_texcoord.xy * _Tiling + _Offset;
					float cos17 = cos( radians( _Rotation ) );
					float sin17 = sin( radians( _Rotation ) );
					float2 rotator17 = mul( texCoord16 - float2( 0.5,0.5 ) , float2x2( cos17 , -sin17 , sin17 , cos17 )) + float2( 0.5,0.5 );
					float2 UVManipulation97 = rotator17;
					float4 temp_cast_0 = (0.16).xxxx;
					float2 uv_BaseDisplacement = v.ase_texcoord.xy * _BaseDisplacement_ST.xy + _BaseDisplacement_ST.zw;
					float4 temp_cast_2 = (0.16).xxxx;
					float2 texCoord216 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
					float simpleNoise218 = SimpleNoise( texCoord216*_MaskShapeScale );
					float4 appendResult204 = (float4(_NoiseTileX , _NoiseTileY , 0.0 , 0.0));
					float4 appendResult211 = (float4(_NoiseoffsetX , _NoiseoffsetY , 0.0 , 0.0));
					float2 texCoord147 = v.ase_texcoord.xy * appendResult204.xy + appendResult211.xy;
					float simpleNoise146 = SimpleNoise( texCoord147*_MaskDetailScale );
					float4 appendResult210 = (float4(_MaskTilingX , _MaskTilingY , 0.0 , 0.0));
					float4 appendResult207 = (float4(_MaskPositionX , _MaskPositionY , 0.0 , 0.0));
					float2 texCoord41 = v.ase_texcoord.xy * appendResult210.xy + appendResult207.xy;
					float HeightMask163 = saturate(pow(((abs( ( simpleNoise218 * simpleNoise146 ) )*abs( saturate(  (0.0 + ( abs( length( texCoord41 ) ) - _MaskGain ) * ( 1.0 - 0.0 ) / ( _MaskConstrast - _MaskGain ) ) ) ))*4)+(abs( saturate(  (0.0 + ( abs( length( texCoord41 ) ) - _MaskGain ) * ( 1.0 - 0.0 ) / ( _MaskConstrast - _MaskGain ) ) ) )*2),_BlendStrength));
					float DirtMask94 = saturate( HeightMask163 );
					float4 lerpResult141 = lerp( ( ( tex2Dlod( _TopDisplacement, float4( UVManipulation97, 0, 0.0) ) - temp_cast_0 ) * float4( v.normal , 0.0 ) * _DirtDisplacement ) , ( ( tex2Dlod( _BaseDisplacement, float4( uv_BaseDisplacement, 0, 0.0) ) - temp_cast_2 ) * float4( v.normal , 0.0 ) * _ConcreteDisplacement ) , DirtMask94);
					

					#ifdef ASE_ABSOLUTE_VERTEX_POS
						float3 defaultVertexValue = v.vertex.xyz;
					#else
						float3 defaultVertexValue = float3(0, 0, 0);
					#endif
					float3 vertexValue = lerpResult141.rgb;
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

					

					half Alpha = 1;
					half AlphaClipThreshold = 0.5;

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
				#define ASE_NEEDS_VERT_NORMAL
				#define ASE_NEEDS_VERT_TEXTURE_COORDINATES0


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

				uniform sampler2D _TopDisplacement;
				uniform float2 _Tiling;
				uniform float2 _Offset;
				uniform float _Rotation;
				uniform float _DirtDisplacement;
				uniform sampler2D _BaseDisplacement;
				uniform float4 _BaseDisplacement_ST;
				uniform float _ConcreteDisplacement;
				uniform float _MaskShapeScale;
				uniform float _NoiseTileX;
				uniform float _NoiseTileY;
				uniform float _NoiseoffsetX;
				uniform float _NoiseoffsetY;
				uniform float _MaskDetailScale;
				uniform float _MaskTilingX;
				uniform float _MaskTilingY;
				uniform float _MaskPositionX;
				uniform float _MaskPositionY;
				uniform float _MaskGain;
				uniform float _MaskConstrast;
				uniform float _BlendStrength;


				inline float noise_randomValue (float2 uv) { return frac(sin(dot(uv, float2(12.9898, 78.233)))*43758.5453); }
				inline float noise_interpolate (float a, float b, float t) { return (1.0-t)*a + (t*b); }
				inline float valueNoise (float2 uv)
				{
					float2 i = floor(uv);
					float2 f = frac( uv );
					f = f* f * (3.0 - 2.0 * f);
					uv = abs( frac(uv) - 0.5);
					float2 c0 = i + float2( 0.0, 0.0 );
					float2 c1 = i + float2( 1.0, 0.0 );
					float2 c2 = i + float2( 0.0, 1.0 );
					float2 c3 = i + float2( 1.0, 1.0 );
					float r0 = noise_randomValue( c0 );
					float r1 = noise_randomValue( c1 );
					float r2 = noise_randomValue( c2 );
					float r3 = noise_randomValue( c3 );
					float bottomOfGrid = noise_interpolate( r0, r1, f.x );
					float topOfGrid = noise_interpolate( r2, r3, f.x );
					float t = noise_interpolate( bottomOfGrid, topOfGrid, f.y );
					return t;
				}
				
				float SimpleNoise(float2 UV)
				{
					float t = 0.0;
					float freq = pow( 2.0, float( 0 ) );
					float amp = pow( 0.5, float( 3 - 0 ) );
					t += valueNoise( UV/freq )*amp;
					freq = pow(2.0, float(1));
					amp = pow(0.5, float(3-1));
					t += valueNoise( UV/freq )*amp;
					freq = pow(2.0, float(2));
					amp = pow(0.5, float(3-2));
					t += valueNoise( UV/freq )*amp;
					return t;
				}
				

				v2f VertexFunction( appdata v  )
				{
					UNITY_SETUP_INSTANCE_ID(v);
					v2f o;
					UNITY_INITIALIZE_OUTPUT(v2f,o);
					UNITY_TRANSFER_INSTANCE_ID(v,o);
					UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

					float2 texCoord16 = v.ase_texcoord.xy * _Tiling + _Offset;
					float cos17 = cos( radians( _Rotation ) );
					float sin17 = sin( radians( _Rotation ) );
					float2 rotator17 = mul( texCoord16 - float2( 0.5,0.5 ) , float2x2( cos17 , -sin17 , sin17 , cos17 )) + float2( 0.5,0.5 );
					float2 UVManipulation97 = rotator17;
					float4 temp_cast_0 = (0.16).xxxx;
					float2 uv_BaseDisplacement = v.ase_texcoord.xy * _BaseDisplacement_ST.xy + _BaseDisplacement_ST.zw;
					float4 temp_cast_2 = (0.16).xxxx;
					float2 texCoord216 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
					float simpleNoise218 = SimpleNoise( texCoord216*_MaskShapeScale );
					float4 appendResult204 = (float4(_NoiseTileX , _NoiseTileY , 0.0 , 0.0));
					float4 appendResult211 = (float4(_NoiseoffsetX , _NoiseoffsetY , 0.0 , 0.0));
					float2 texCoord147 = v.ase_texcoord.xy * appendResult204.xy + appendResult211.xy;
					float simpleNoise146 = SimpleNoise( texCoord147*_MaskDetailScale );
					float4 appendResult210 = (float4(_MaskTilingX , _MaskTilingY , 0.0 , 0.0));
					float4 appendResult207 = (float4(_MaskPositionX , _MaskPositionY , 0.0 , 0.0));
					float2 texCoord41 = v.ase_texcoord.xy * appendResult210.xy + appendResult207.xy;
					float HeightMask163 = saturate(pow(((abs( ( simpleNoise218 * simpleNoise146 ) )*abs( saturate(  (0.0 + ( abs( length( texCoord41 ) ) - _MaskGain ) * ( 1.0 - 0.0 ) / ( _MaskConstrast - _MaskGain ) ) ) ))*4)+(abs( saturate(  (0.0 + ( abs( length( texCoord41 ) ) - _MaskGain ) * ( 1.0 - 0.0 ) / ( _MaskConstrast - _MaskGain ) ) ) )*2),_BlendStrength));
					float DirtMask94 = saturate( HeightMask163 );
					float4 lerpResult141 = lerp( ( ( tex2Dlod( _TopDisplacement, float4( UVManipulation97, 0, 0.0) ) - temp_cast_0 ) * float4( v.normal , 0.0 ) * _DirtDisplacement ) , ( ( tex2Dlod( _BaseDisplacement, float4( uv_BaseDisplacement, 0, 0.0) ) - temp_cast_2 ) * float4( v.normal , 0.0 ) * _ConcreteDisplacement ) , DirtMask94);
					

					#ifdef ASE_ABSOLUTE_VERTEX_POS
						float3 defaultVertexValue = v.vertex.xyz;
					#else
						float3 defaultVertexValue = float3(0, 0, 0);
					#endif
					float3 vertexValue = lerpResult141.rgb;
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

					

					half Alpha = 1;
					half AlphaClipThreshold = 0.5;

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
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;154;-3296,-1712;Inherit;False;2764.695;1027.431;Mask;34;206;207;205;209;208;210;42;174;173;181;94;199;175;176;215;164;232;163;41;231;214;213;211;212;203;202;204;148;147;146;219;217;218;216;;0,0,0,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;202;-2784,-1520;Inherit;False;Property;_NoiseTileX;Noise Tile X;25;0;Create;True;0;0;0;False;0;False;1;1.59;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;203;-2784,-1440;Inherit;False;Property;_NoiseTileY;Noise Tile Y;26;0;Create;True;0;0;0;False;0;False;1;2.04;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;212;-2784,-1360;Inherit;False;Property;_NoiseoffsetX;Noise offset X;27;0;Create;True;0;0;0;False;0;False;1;0.18;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;213;-2784,-1280;Inherit;False;Property;_NoiseoffsetY;Noise offset Y;28;0;Create;True;0;0;0;False;0;False;1;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;208;-3184,-1200;Inherit;False;Property;_MaskTilingX;Mask Tiling X;29;0;Create;True;0;0;0;False;0;False;0;0.92;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;209;-3184,-1120;Inherit;False;Property;_MaskTilingY;Mask Tiling Y;30;0;Create;True;0;0;0;False;0;False;0;1.58;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;205;-3184,-1040;Inherit;False;Property;_MaskPositionX;Mask Position X;31;0;Create;True;0;0;0;False;0;False;-0.5;-0.478;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;206;-3184,-960;Inherit;False;Property;_MaskPositionY;Mask Position Y;32;0;Create;True;0;0;0;False;0;False;-0.53;-0.865;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;204;-2432,-1520;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;211;-2432,-1360;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;210;-2864,-1200;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;207;-2864,-1040;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TextureCoordinatesNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;216;-2224,-1632;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;217;-2224,-1504;Inherit;False;Property;_MaskShapeScale;Mask Shape Scale;22;0;Create;True;0;0;0;False;0;False;20.33;42.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;147;-2224,-1408;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;148;-2224,-1280;Inherit;False;Property;_MaskDetailScale;Mask Detail Scale;21;0;Create;True;0;0;0;False;0;False;20.33;445.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;41;-2624,-1088;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;155;-3280,-656;Inherit;False;925.3228;422.2813;UVManipulation;8;97;11;15;17;14;13;16;12;;0,0,0,1;0;0
Node;AmplifyShaderEditor.NoiseGeneratorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;218;-1952,-1632;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;146;-1952,-1408;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;42;-2400,-1088;Inherit;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;219;-1648,-1632;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;181;-2208,-1088;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;173;-2192,-864;Inherit;False;Property;_MaskGain;Mask Gain;20;0;Create;True;0;0;0;False;0;False;0;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;174;-2224,-784;Inherit;False;Property;_MaskConstrast;Mask Constrast;23;0;Create;True;0;0;0;False;0;False;0;0.27;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;11;-3248,-336;Inherit;False;Property;_Rotation;Rotation;17;0;Create;True;0;0;0;False;0;False;0;112;0;360;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;12;-3232,-608;Inherit;False;Property;_Tiling;Tiling;18;0;Create;True;0;0;0;False;0;False;0,0;3,3;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;13;-3264,-480;Inherit;False;Property;_Offset;Offset;19;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.AbsOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;214;-1472,-1632;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;175;-1984,-1088;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;16;-3040,-592;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;14;-3008,-464;Inherit;False;Constant;_Vector0;Vector 0;6;0;Create;True;0;0;0;False;0;False;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RadiansOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;15;-2960,-336;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;231;-1360,-1568;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;176;-1712,-1088;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;17;-2784,-592;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;159;-1880.765,1504;Inherit;False;1384.165;850.0402;Displacement;15;102;222;24;133;136;138;137;139;140;142;26;19;25;141;29;;0,0,0,1;0;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;232;-1360,-1104;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;164;-1504,-992;Inherit;False;Property;_BlendStrength;Blend Strength;24;0;Create;True;0;0;0;False;0;False;12.42;40;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;215;-1536,-1088;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;97;-2576,-592;Inherit;False;UVManipulation;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.HeightMapBlendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;163;-1280,-1104;Inherit;True;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;102;-1824,1568;Inherit;False;97;UVManipulation;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;199;-976,-1104;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;19;-1312,1648;Inherit;False;Constant;_Float1;Float 1;14;0;Create;True;0;0;0;False;0;False;0.16;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;136;-1440,2096;Inherit;False;Constant;_Float2;Float 2;14;0;Create;True;0;0;0;False;0;False;0.16;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;133;-1728,2000;Inherit;True;Property;_BaseDisplacement;Base Displacement;7;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;False;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;222;-1600,1568;Inherit;True;Property;_TopDisplacement;Top Displacement;15;1;[SingleLineTexture];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;False;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;94;-784,-1104;Inherit;False;DirtMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;25;-1120,1568;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;26;-1232,1872;Float;False;Property;_DirtDisplacement;Dirt Displacement;16;0;Create;True;0;0;0;False;0;False;0;0.294;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;139;-1184,2000;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.NormalVertexDataNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;137;-1216,2096;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;138;-1312,2240;Float;False;Property;_ConcreteDisplacement;Concrete Displacement;8;0;Create;True;0;0;0;False;0;False;0;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;24;-1168,1712;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;29;-928,1776;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;142;-896,1696;Inherit;False;94;DirtMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;140;-928,2000;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;141;-656,1776;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;158;-1616,688;Inherit;False;1113.315;791.2681;Smoothness AO;11;101;108;86;89;85;107;22;30;221;91;109;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;157;-1616,224;Inherit;False;1099.905;446.4611;Normal;8;105;106;88;92;103;27;100;223;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;156;-1612.753,-643.9425;Inherit;False;1092.912;850.8235;Diffuse;9;96;93;90;84;87;31;99;23;220;;0,0,0,1;0;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;242;-448,1776;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;27;-1600,352;Inherit;False;Property;_DirtNormalIntensity;Dirt Normal Intensity;12;0;Create;True;0;0;0;False;0;False;1;1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;88;-1600,464;Inherit;False;Property;_ConcreteNormalIntensity;Concrete Normal Intensity;3;0;Create;True;0;0;0;False;0;False;0;1.245;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;23;-1280,-576;Inherit;False;Property;_DirtTint;Dirt Tint;9;0;Create;True;0;0;0;False;0;False;0,0,0,0;1,1,1,1;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;87;-1264,-192;Inherit;False;Property;_ConcreteTint;Concrete Tint;0;0;Create;True;0;0;0;False;0;False;1,1,1,0;1,1,1,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;84;-1328,0;Inherit;True;Property;_BaseAlbedo;Base Albedo;1;0;Create;True;0;0;0;False;0;False;-1;None;85e3723e62d44f758723754190c67911;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;False;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;92;-1296,464;Inherit;True;Property;_BaseNormal;Base Normal;2;0;Create;True;0;0;0;False;0;False;-1;None;abfd39fa1d6a42ba9b322e4301333932;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;False;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;106;-1024,512;Inherit;False;94;DirtMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;22;-1312,1120;Inherit;False;Property;_DirtSmoothnessIntensity;Dirt Smoothness Intensity;14;0;Create;True;0;0;0;False;0;False;0;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;85;-1328,1200;Inherit;True;Property;_BaseSmoothnessMix;Base Smoothness Mix;4;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;False;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;86;-1344,1392;Inherit;False;Property;_ConcreteSmoothnessIntensity;Concrete Smoothness Intensity;5;0;Create;True;0;0;0;False;0;False;0;0.32;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;31;-992,-576;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;90;-992,-192;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;96;-992,-464;Inherit;False;94;DirtMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;103;-880,272;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;91;-1328,736;Inherit;True;Property;_SmoothnessAOBase;Smoothness AO Base;6;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;False;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;30;-896,976;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;89;-896,1248;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;108;-912,752;Inherit;False;94;DirtMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;93;-768,-576;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.NormalizeNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;105;-688,272;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;107;-672,976;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;109;-688,784;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;241;-448,976;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;244;-448,368;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;247;-432,-528;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;246;-400,-480;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;243;-432,704;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;245;-400,672;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;101;-1568,928;Inherit;False;97;UVManipulation;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;99;-1568,-384;Inherit;False;97;UVManipulation;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;100;-1536,272;Inherit;False;97;UVManipulation;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;221;-1328,928;Inherit;True;Property;_TopSmoothnessAO;Top Smoothness AO;13;1;[SingleLineTexture];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;False;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;223;-1296,272;Inherit;True;Property;_TopNormal;Top Normal;11;1;[SingleLineTexture];Create;True;0;0;0;False;0;False;-1;None;cf93c237de12a4049a3ef26bbde1a296;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;False;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;220;-1344,-384;Inherit;True;Property;_TopAlbedo;Top Albedo;10;1;[SingleLineTexture];Create;True;0;0;0;False;0;False;-1;None;27c61f066670a3c42b537a02c420e427;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;False;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;233;-208,624;Float;False;False;-1;3;AmplifyShaderEditor.MaterialInspector;0;1;New Amplify Shader;ed95fe726fd7b4644bb42f4d1ddd2bcd;True;ExtraPrePass;0;0;ExtraPrePass;6;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;False;False;True;3;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;DisableBatching=False=DisableBatching;True;3;True;12;all;0;False;True;1;1;False;;0;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;False;True;1;LightMode=ForwardBase;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;235;-208,624;Float;False;False;-1;3;AmplifyShaderEditor.MaterialInspector;0;1;New Amplify Shader;ed95fe726fd7b4644bb42f4d1ddd2bcd;True;ForwardAdd;0;2;ForwardAdd;0;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;False;False;True;3;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;DisableBatching=False=DisableBatching;True;3;True;12;all;0;False;True;4;1;False;;1;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;True;1;LightMode=ForwardAdd;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;236;-208,624;Float;False;False;-1;3;AmplifyShaderEditor.MaterialInspector;0;1;New Amplify Shader;ed95fe726fd7b4644bb42f4d1ddd2bcd;True;Deferred;0;3;Deferred;0;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;False;False;True;3;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;DisableBatching=False=DisableBatching;True;3;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Deferred;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;237;-208,624;Float;False;False;-1;3;AmplifyShaderEditor.MaterialInspector;0;1;New Amplify Shader;ed95fe726fd7b4644bb42f4d1ddd2bcd;True;Meta;0;4;Meta;0;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;False;False;True;3;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;DisableBatching=False=DisableBatching;True;3;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Meta;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;238;-208,624;Float;False;False;-1;3;AmplifyShaderEditor.MaterialInspector;0;1;New Amplify Shader;ed95fe726fd7b4644bb42f4d1ddd2bcd;True;ShadowCaster;0;5;ShadowCaster;0;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;False;False;True;3;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;DisableBatching=False=DisableBatching;True;3;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;False;;True;3;False;;False;False;True;1;LightMode=ShadowCaster;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;239;-208,624;Float;False;False;-1;3;AmplifyShaderEditor.MaterialInspector;0;1;New Amplify Shader;ed95fe726fd7b4644bb42f4d1ddd2bcd;True;SceneSelectionPass;0;6;SceneSelectionPass;0;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;False;False;True;3;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;DisableBatching=False=DisableBatching;True;3;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;False;;False;False;False;True;1;LightMode=SceneSelectionPass;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;240;-208,624;Float;False;False;-1;3;AmplifyShaderEditor.MaterialInspector;0;1;New Amplify Shader;ed95fe726fd7b4644bb42f4d1ddd2bcd;True;ScenePickingPass;0;7;ScenePickingPass;0;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;False;False;True;3;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;DisableBatching=False=DisableBatching;True;3;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;False;;False;False;False;True;1;LightMode=ScenePickingPass;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;234;-352,688;Float;False;True;-1;3;AmplifyShaderEditor.MaterialInspector;0;12;AmplifyShaderPack/Procedural Dirt;ed95fe726fd7b4644bb42f4d1ddd2bcd;True;ForwardBase;0;1;ForwardBase;17;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;False;False;True;3;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;DisableBatching=False=DisableBatching;True;3;True;12;all;0;False;True;1;1;False;;0;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;False;0;;0;0;Standard;44;Category;0;0;  Instanced Terrain Normals;1;0;Workflow;1;0;Surface;0;0;  Blend;0;0;  Dither Shadows;1;0;Two Sided;1;0;Alpha Clipping;0;0;  Use Shadow Threshold;0;0;Deferred Pass;1;0;Normal Space;0;0;Transmission;0;0;  Transmission Shadow;0.5,True,_ASETransmissionShadow;0;Translucency;0;0;  Translucency Strength;1,True,_ASETranslucencyStrength;0;  Normal Distortion;0.5,True,_ASETranslucencyNormalDistortion;0;  Scattering;2,True,_ASETranslucencyScattering;0;  Direct;0.9,True,_ASETranslucencyDirect;0;  Ambient;0.1,True,_ASETranslucencyAmbient;0;  Shadow;0.5,True,_ASETransmissionShadow;0;Cast Shadows;1;0;Receive Shadows;1;0;Receive Specular;2;0;Receive Reflections;2;0;GPU Instancing;1;0;LOD CrossFade;1;0;Built-in Fog;1;0;Ambient Light;1;0;Meta Pass;1;0;Add Pass;1;0;Override Baked GI;0;0;Write Depth;0;0;Extra Pre Pass;0;0;Tessellation;0;0;  Phong;0;0;  Strength;0.5,False,;0;  Type;0;0;  Tess;16,True,_TessellationStrength;0;  Min;10,True,_TessellationDistanceMin;0;  Max;25,True,_TessellationDistanceMax;0;  Edge Length;16,False,;0;  Max Displacement;25,False,;0;Disable Batching;0;0;Vertex Position;1;0;0;8;False;True;True;True;True;True;True;True;False;;False;0
WireConnection;204;0;202;0
WireConnection;204;1;203;0
WireConnection;211;0;212;0
WireConnection;211;1;213;0
WireConnection;210;0;208;0
WireConnection;210;1;209;0
WireConnection;207;0;205;0
WireConnection;207;1;206;0
WireConnection;147;0;204;0
WireConnection;147;1;211;0
WireConnection;41;0;210;0
WireConnection;41;1;207;0
WireConnection;218;0;216;0
WireConnection;218;1;217;0
WireConnection;146;0;147;0
WireConnection;146;1;148;0
WireConnection;42;0;41;0
WireConnection;219;0;218;0
WireConnection;219;1;146;0
WireConnection;181;0;42;0
WireConnection;214;0;219;0
WireConnection;175;0;181;0
WireConnection;175;1;173;0
WireConnection;175;2;174;0
WireConnection;16;0;12;0
WireConnection;16;1;13;0
WireConnection;15;0;11;0
WireConnection;231;0;214;0
WireConnection;176;0;175;0
WireConnection;17;0;16;0
WireConnection;17;1;14;0
WireConnection;17;2;15;0
WireConnection;232;0;231;0
WireConnection;215;0;176;0
WireConnection;97;0;17;0
WireConnection;163;0;232;0
WireConnection;163;1;215;0
WireConnection;163;2;164;0
WireConnection;199;0;163;0
WireConnection;222;1;102;0
WireConnection;94;0;199;0
WireConnection;25;0;222;0
WireConnection;25;1;19;0
WireConnection;139;0;133;0
WireConnection;139;1;136;0
WireConnection;29;0;25;0
WireConnection;29;1;24;0
WireConnection;29;2;26;0
WireConnection;140;0;139;0
WireConnection;140;1;137;0
WireConnection;140;2;138;0
WireConnection;141;0;29;0
WireConnection;141;1;140;0
WireConnection;141;2;142;0
WireConnection;242;0;141;0
WireConnection;92;5;88;0
WireConnection;31;0;23;0
WireConnection;31;1;220;0
WireConnection;90;0;87;0
WireConnection;90;1;84;0
WireConnection;103;0;223;0
WireConnection;103;1;92;0
WireConnection;103;2;106;0
WireConnection;30;0;221;1
WireConnection;30;1;22;0
WireConnection;89;0;85;1
WireConnection;89;1;86;0
WireConnection;93;0;31;0
WireConnection;93;1;90;0
WireConnection;93;2;96;0
WireConnection;105;0;103;0
WireConnection;107;0;30;0
WireConnection;107;1;89;0
WireConnection;107;2;108;0
WireConnection;109;0;221;2
WireConnection;109;1;91;2
WireConnection;109;2;108;0
WireConnection;241;0;242;0
WireConnection;244;0;105;0
WireConnection;247;0;93;0
WireConnection;246;0;247;0
WireConnection;243;0;244;0
WireConnection;245;0;246;0
WireConnection;221;1;101;0
WireConnection;223;1;100;0
WireConnection;223;5;27;0
WireConnection;220;1;99;0
WireConnection;234;0;245;0
WireConnection;234;1;243;0
WireConnection;234;5;107;0
WireConnection;234;6;109;0
WireConnection;234;15;241;0
ASEEND*/
//CHKSM=92A22A2CD9FFBCB0CC381AE5950C83C38D129EBD