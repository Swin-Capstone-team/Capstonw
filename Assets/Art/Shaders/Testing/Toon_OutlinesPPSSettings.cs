// Amplify Shader Editor - Visual Shader Editing Tool
// Copyright (c) Amplify Creations, Lda <info@amplify.pt>
#if UNITY_POST_PROCESSING_STACK_V2
using System;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

[Serializable]
[PostProcess( typeof( Toon_OutlinesPPSRenderer ), PostProcessEvent.AfterStack, "Toon_Outlines", true )]
public sealed class Toon_OutlinesPPSSettings : PostProcessEffectSettings
{
	[Tooltip( "Transmission Shadow" )]
	public FloatParameter _TransmissionShadow = new FloatParameter { value = 0.5f };
	[Tooltip( "Strength" )]
	public FloatParameter _TransStrength = new FloatParameter { value = 1f };
	[Tooltip( "Normal Distortion" )]
	public FloatParameter _TransNormal = new FloatParameter { value = 0.5f };
	[Tooltip( "Scattering" )]
	public FloatParameter _TransScattering = new FloatParameter { value = 2f };
	[Tooltip( "Direct" )]
	public FloatParameter _TransDirect = new FloatParameter { value = 0.9f };
	[Tooltip( "Ambient" )]
	public FloatParameter _TransAmbient = new FloatParameter { value = 0.1f };
	[Tooltip( "Shadow" )]
	public FloatParameter _TransShadow = new FloatParameter { value = 0.5f };
	[Tooltip( "Phong Tess Strength" )]
	public FloatParameter _TessPhongStrength = new FloatParameter { value = 0.5f };
	[Tooltip( "Max Tessellation" )]
	public FloatParameter _TessValue = new FloatParameter { value = 16f };
	[Tooltip( "Tess Min Distance" )]
	public FloatParameter _TessMin = new FloatParameter { value = 10f };
	[Tooltip( "Tess Max Distance" )]
	public FloatParameter _TessMax = new FloatParameter { value = 25f };
	[Tooltip( "Edge length" )]
	public FloatParameter _TessEdgeLength = new FloatParameter { value = 16f };
	[Tooltip( "Max Displacement" )]
	public FloatParameter _TessMaxDisp = new FloatParameter { value = 25f };
	[Tooltip( "Specular Highlights" )]
	public FloatParameter _SpecularHighlights = new FloatParameter { value = 1f };
	[Tooltip( "Reflections" )]
	public FloatParameter _GlossyReflections = new FloatParameter { value = 1f };
}

public sealed class Toon_OutlinesPPSRenderer : PostProcessEffectRenderer<Toon_OutlinesPPSSettings>
{
	public override void Render( PostProcessRenderContext context )
	{
		var sheet = context.propertySheets.Get( Shader.Find( "Toon_Outlines" ) );
		sheet.properties.SetFloat( "_TransmissionShadow", settings._TransmissionShadow );
		sheet.properties.SetFloat( "_TransStrength", settings._TransStrength );
		sheet.properties.SetFloat( "_TransNormal", settings._TransNormal );
		sheet.properties.SetFloat( "_TransScattering", settings._TransScattering );
		sheet.properties.SetFloat( "_TransDirect", settings._TransDirect );
		sheet.properties.SetFloat( "_TransAmbient", settings._TransAmbient );
		sheet.properties.SetFloat( "_TransShadow", settings._TransShadow );
		sheet.properties.SetFloat( "_TessPhongStrength", settings._TessPhongStrength );
		sheet.properties.SetFloat( "_TessValue", settings._TessValue );
		sheet.properties.SetFloat( "_TessMin", settings._TessMin );
		sheet.properties.SetFloat( "_TessMax", settings._TessMax );
		sheet.properties.SetFloat( "_TessEdgeLength", settings._TessEdgeLength );
		sheet.properties.SetFloat( "_TessMaxDisp", settings._TessMaxDisp );
		sheet.properties.SetFloat( "_SpecularHighlights", settings._SpecularHighlights );
		sheet.properties.SetFloat( "_GlossyReflections", settings._GlossyReflections );
		context.command.BlitFullscreenTriangle( context.source, context.destination, sheet, 0 );
	}
}
#endif
