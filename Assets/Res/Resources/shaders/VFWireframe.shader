// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/VFWireframe" {
	Properties{
			_Color("Color",Color) = (1.0,1.0,1.0,1.0)
			_EdgeColor("Edge Color",Color) = (1.0,1.0,1.0,1.0)
			_Width("Width",Range(0,1)) = 0.2
	}
		SubShader{
			Tags {
			"Queue" = "Transparent"
			"IgnoreProjector" = "True"
			"RenderType" = "Transparent"
			}
			Blend SrcAlpha OneMinusSrcAlpha
			LOD 200
			Cull Front
			zWrite off
			Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#include "UnityCG.cginc"

			struct a2v {
				half4 uv : TEXCOORD0;
				half4 vertex : POSITION;
			};

			struct v2f {
				half4 pos : SV_POSITION;
				half4 uv : TEXCOORD0;
			};
			fixed4 _Color;
			fixed4 _EdgeColor;
			float _Width;

			v2f vert(a2v v)
			{
				v2f o;
				o.uv = v.uv;
				o.pos = UnityObjectToClipPos(v.vertex);
				return o;
			}


			fixed4 frag(v2f i) : SV_Target
			{
				fixed4 col;
				//step如果x<a，返回0；否则，返回1
				float lx = step(_Width, i.uv.x);//左边
				float ly = step(_Width, i.uv.y);//上边
				float hx = step(i.uv.x, 1.0 - _Width);//右边
				float hy = step(i.uv.y, 1.0 - _Width);//下边
				//只要uv的x和y任意一个值小于_Width或1-_Width，
				//即认为是边缘，再通过插值计算得到边缘线
				col = lerp(_EdgeColor, _Color, lx*ly*hx*hy);
				return col;
			}
			ENDCG
			}
			Blend SrcAlpha OneMinusSrcAlpha
			LOD 200
			Cull Back
			zWrite off
			Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#include "UnityCG.cginc"

			struct a2v {
				half4 uv : TEXCOORD0;
				half4 vertex : POSITION;
			};

			struct v2f {
				half4 pos : SV_POSITION;
				half4 uv : TEXCOORD0;
			};
			fixed4 _Color;
			fixed4 _EdgeColor;
			float _Width;

			v2f vert(a2v v)
			{
				v2f o;
				o.uv = v.uv;
				o.pos = UnityObjectToClipPos(v.vertex);
				return o;
			}


			fixed4 frag(v2f i) : SV_Target
			{
				fixed4 col;
				//step如果x<a，返回0；否则，返回1
				float lx = step(_Width, i.uv.x);//左边
				float ly = step(_Width, i.uv.y);//上边
				float hx = step(i.uv.x, 1.0 - _Width);//右边
				float hy = step(i.uv.y, 1.0 - _Width);//下边
				//只要uv的x和y任意一个值小于_Width或1-_Width，
				//即认为是边缘，再通过插值计算得到边缘线
				col = lerp(_EdgeColor, _Color, lx*ly*hx*hy);
				return col;
			}
			ENDCG
			}
	}
		FallBack "Diffuse"
}

