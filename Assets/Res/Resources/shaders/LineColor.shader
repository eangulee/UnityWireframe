// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/LineColor" {

    Properties{
        _LineColor ("Line Color", Color) = (1.0, 1.0, 1.0, 1.0)
    }

    SubShader {
        Pass {
            Tags { "RenderType"="Opaque"}
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct v2f
            {
                half4 pos : SV_POSITION;
            };

            fixed4 _LineColor;

            v2f vert(appdata_base  v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                return o;
            }

            fixed4 frag(v2f i) : COLOR
            {
                return _LineColor;
            }

            ENDCG
        }
    }
}