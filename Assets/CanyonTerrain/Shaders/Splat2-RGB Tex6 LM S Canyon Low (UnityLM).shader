Shader "Serj Shaders/Splat2-RGB Tex6 LM S Canyon Low (UnityLM)" {
Properties {
	_Baked ("Baked Main", 2D) = "white" {}
	_Vert ("Vert Main", 2D) = "white" {}
	_VertDetail ("Vert Detail", 2D) = "white" {}
	_LM ("LM", 2D) = "white" {}
	_Control1 ("Control 1 (RGB)", 2D) = "white" {}

}
// ================= Simplified Shader ================

SubShader {

	//LOD 200

	Tags{
	    "Queue"="Geometry"
	    "IgnoreProjector"="True"
	    "RenderType"="Opaque"
	    }
	//Offset 0, 0    
    Pass {
    //Fog {Mode Off}
    //Fog { Color ( 0.5,0.45,0.31 ) }
    //Fog { Color ( 0.384,0.433,0.480 ) }
    Lighting Off
    //Tags {"LightMode" = "ForwardBase"}
    
    Program "vp" {
// Vertex combos: 8
//   d3d9 - ALU: 10 to 10
//   d3d11 - ALU: 5 to 5, TEX: 0 to 0, FLOW: 1 to 1
//   d3d11_9x - ALU: 5 to 5, TEX: 0 to 0, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLSL
#ifdef VERTEX
varying vec2 xlv_TEXCOORD2;
varying vec2 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;

void main ()
{
  vec2 tmpvar_1;
  vec2 tmpvar_2;
  tmpvar_1.x = (gl_MultiTexCoord0.x * 10.0000);
  tmpvar_1.y = (gl_Vertex.y * 0.00400000);
  tmpvar_2.x = (gl_MultiTexCoord0.y * 10.0000);
  tmpvar_2.y = (gl_Vertex.y * 0.00400000);
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = gl_MultiTexCoord0.xy;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
}


#endif
#ifdef FRAGMENT
varying vec2 xlv_TEXCOORD2;
varying vec2 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _Vert;
uniform sampler2D _Control1;
uniform sampler2D _Baked;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control1, xlv_TEXCOORD0);
  vec4 tmpvar_2;
  tmpvar_2 = texture2D (unity_Lightmap, xlv_TEXCOORD0);
  gl_FragData[0] = (((((texture2D (_Vert, xlv_TEXCOORD1) - vec4(0.000000, 0.0400000, 0.0300000, 0.000000)) * tmpvar_1.x) + ((texture2D (_Vert, xlv_TEXCOORD2) - vec4(0.000000, 0.0400000, 0.0300000, 0.000000)) * tmpvar_1.y)) + (((1.25000 * texture2D (_Baked, xlv_TEXCOORD0)) + vec4(0.000000, 0.0400000, 0.0400000, 0.000000)) * ((1.00000 - tmpvar_1.x) - tmpvar_1.y))) * ((8.00000 * tmpvar_2.w) * tmpvar_2));
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
"vs_2_0
; 10 ALU
def c4, 0.00400000, 10.00000000, 0, 0
dcl_position0 v0
dcl_texcoord0 v1
mul r0.y, v0, c4.x
mul r0.x, v1.y, c4.y
mov oT0.xy, v1
mov oT2.xy, r0
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
mov oT1.y, r0
mul oT1.x, v1, c4.y
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "UnityPerDraw" 336 // 64 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
BindCB "UnityPerDraw" 0
// 9 instructions, 1 temp regs, 0 temp arrays:
// ALU 5 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedcpijkondljefbdlglhfoananiakipljgabaaaaaajeacaaaaadaaaaaa
cmaaaaaaiaaaaaaaaiabaaaaejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklkl
epfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
heaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaaamadaaaaheaaaaaaacaaaaaa
aaaaaaaaadaaaaaaacaaaaaaadamaaaafdfgfpfaepfdejfeejepeoaafeeffied
epepfceeaaklklklfdeieefcieabaaaaeaaaabaagbaaaaaafjaaaaaeegiocaaa
aaaaaaaaaeaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaabaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaad
mccabaaaabaaaaaagfaaaaaddccabaaaacaaaaaagiaaaaacabaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaaaaaaaaaabaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaaaaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaacaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaaaaaaaaa
adaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaakhccabaaaabaaaaaa
egbabaaaabaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaacaebaaaaaaaadiaaaaah
iccabaaaabaaaaaabkbabaaaaaaaaaaaabeaaaaagpbciddldiaaaaahbccabaaa
acaaaaaabkbabaaaabaaaaaaabeaaaaaaaaacaebdiaaaaahcccabaaaacaaaaaa
bkbabaaaaaaaaaaaabeaaaaagpbciddldoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;

attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec2 tmpvar_1;
  highp vec2 tmpvar_2;
  tmpvar_1.x = (_glesMultiTexCoord0.x * 10.0000);
  tmpvar_1.y = (_glesVertex.y * 0.00400000);
  tmpvar_2.x = (_glesMultiTexCoord0.y * 10.0000);
  tmpvar_2.y = (_glesVertex.y * 0.00400000);
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _Vert;
uniform sampler2D _Control1;
uniform sampler2D _Baked;
void main ()
{
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control1, xlv_TEXCOORD0);
  gl_FragData[0] = (((((texture2D (_Vert, xlv_TEXCOORD1) - vec4(0.000000, 0.0400000, 0.0300000, 0.000000)) * tmpvar_1.x) + ((texture2D (_Vert, xlv_TEXCOORD2) - vec4(0.000000, 0.0400000, 0.0300000, 0.000000)) * tmpvar_1.y)) + (((1.25000 * texture2D (_Baked, xlv_TEXCOORD0)) + vec4(0.000000, 0.0400000, 0.0400000, 0.000000)) * ((1.00000 - tmpvar_1.x) - tmpvar_1.y))) * (2.00000 * texture2D (unity_Lightmap, xlv_TEXCOORD0)));
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;

attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec2 tmpvar_1;
  highp vec2 tmpvar_2;
  tmpvar_1.x = (_glesMultiTexCoord0.x * 10.0000);
  tmpvar_1.y = (_glesVertex.y * 0.00400000);
  tmpvar_2.x = (_glesMultiTexCoord0.y * 10.0000);
  tmpvar_2.y = (_glesVertex.y * 0.00400000);
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _Vert;
uniform sampler2D _Control1;
uniform sampler2D _Baked;
void main ()
{
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control1, xlv_TEXCOORD0);
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (unity_Lightmap, xlv_TEXCOORD0);
  gl_FragData[0] = (((((texture2D (_Vert, xlv_TEXCOORD1) - vec4(0.000000, 0.0400000, 0.0300000, 0.000000)) * tmpvar_1.x) + ((texture2D (_Vert, xlv_TEXCOORD2) - vec4(0.000000, 0.0400000, 0.0300000, 0.000000)) * tmpvar_1.y)) + (((1.25000 * texture2D (_Baked, xlv_TEXCOORD0)) + vec4(0.000000, 0.0400000, 0.0400000, 0.000000)) * ((1.00000 - tmpvar_1.x) - tmpvar_1.y))) * ((8.00000 * tmpvar_2.w) * tmpvar_2));
}



#endif"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "UnityPerDraw" 336 // 64 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
BindCB "UnityPerDraw" 0
// 9 instructions, 1 temp regs, 0 temp arrays:
// ALU 5 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_3
eefiecedcojhmgnfeghijickggojedchndjhhjhfabaaaaaaliadaaaaaeaaaaaa
daaaaaaafaabaaaanmacaaaadaadaaaaebgpgodjbiabaaaabiabaaaaaaacpopp
oeaaaaaadeaaaaaaabaaceaaaaaadaaaaaaadaaaaaaaceaaabaadaaaaaaaaaaa
aeaaabaaaaaaaaaaaaaaaaaaabacpoppfbaaaaafafaaapkaaaaaiadpaaaacaeb
gpbciddlaaaaaaaabpaaaaacafaaaaiaaaaaapjabpaaaaacafaaabiaabaaapja
afaaaaadaaaaapiaaaaaffjaacaaoekaaeaaaaaeaaaaapiaabaaoekaaaaaaaja
aaaaoeiaaeaaaaaeaaaaapiaadaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaapia
aeaaoekaaaaappjaaaaaoeiaaeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeia
abaaaaacaaaaammaaaaaoeiaafaaaaadaaaaaloaabaacejaafaagakaafaaaaad
aaaaaeoaaaaaffjaafaakkkaafaaaaadabaaaboaabaaffjaafaaffkaafaaaaad
abaaacoaaaaaffjaafaakkkappppaaaafdeieefcieabaaaaeaaaabaagbaaaaaa
fjaaaaaeegiocaaaaaaaaaaaaeaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaad
dcbabaaaabaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaa
abaaaaaagfaaaaadmccabaaaabaaaaaagfaaaaaddccabaaaacaaaaaagiaaaaac
abaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaaaaaaaaa
abaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaaaaaaaaaagbabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaa
acaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaa
egiocaaaaaaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaak
hccabaaaabaaaaaaegbabaaaabaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaacaeb
aaaaaaaadiaaaaahiccabaaaabaaaaaabkbabaaaaaaaaaaaabeaaaaagpbciddl
diaaaaahbccabaaaacaaaaaabkbabaaaabaaaaaaabeaaaaaaaaacaebdiaaaaah
cccabaaaacaaaaaabkbabaaaaaaaaaaaabeaaaaagpbciddldoaaaaabejfdeheo
emaaaaaaacaaaaaaaiaaaaaadiaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apapaaaaebaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadadaaaafaepfdej
feejepeoaafeeffiedepepfceeaaklklepfdeheoiaaaaaaaaeaaaaaaaiaaaaaa
giaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaabaaaaaaadamaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaa
abaaaaaaamadaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaadamaaaa
fdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklkl"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLSL
#ifdef VERTEX
varying vec2 xlv_TEXCOORD2;
varying vec2 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;

void main ()
{
  vec2 tmpvar_1;
  vec2 tmpvar_2;
  tmpvar_1.x = (gl_MultiTexCoord0.x * 10.0000);
  tmpvar_1.y = (gl_Vertex.y * 0.00400000);
  tmpvar_2.x = (gl_MultiTexCoord0.y * 10.0000);
  tmpvar_2.y = (gl_Vertex.y * 0.00400000);
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = gl_MultiTexCoord0.xy;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
}


#endif
#ifdef FRAGMENT
varying vec2 xlv_TEXCOORD2;
varying vec2 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _Vert;
uniform sampler2D _Control1;
uniform sampler2D _Baked;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control1, xlv_TEXCOORD0);
  vec4 tmpvar_2;
  tmpvar_2 = texture2D (unity_Lightmap, xlv_TEXCOORD0);
  gl_FragData[0] = (((((texture2D (_Vert, xlv_TEXCOORD1) - vec4(0.000000, 0.0400000, 0.0300000, 0.000000)) * tmpvar_1.x) + ((texture2D (_Vert, xlv_TEXCOORD2) - vec4(0.000000, 0.0400000, 0.0300000, 0.000000)) * tmpvar_1.y)) + (((1.25000 * texture2D (_Baked, xlv_TEXCOORD0)) + vec4(0.000000, 0.0400000, 0.0400000, 0.000000)) * ((1.00000 - tmpvar_1.x) - tmpvar_1.y))) * ((8.00000 * tmpvar_2.w) * tmpvar_2));
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
"vs_2_0
; 10 ALU
def c4, 0.00400000, 10.00000000, 0, 0
dcl_position0 v0
dcl_texcoord0 v1
mul r0.y, v0, c4.x
mul r0.x, v1.y, c4.y
mov oT0.xy, v1
mov oT2.xy, r0
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
mov oT1.y, r0
mul oT1.x, v1, c4.y
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "UnityPerDraw" 336 // 64 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
BindCB "UnityPerDraw" 0
// 9 instructions, 1 temp regs, 0 temp arrays:
// ALU 5 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedcpijkondljefbdlglhfoananiakipljgabaaaaaajeacaaaaadaaaaaa
cmaaaaaaiaaaaaaaaiabaaaaejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklkl
epfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
heaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaaamadaaaaheaaaaaaacaaaaaa
aaaaaaaaadaaaaaaacaaaaaaadamaaaafdfgfpfaepfdejfeejepeoaafeeffied
epepfceeaaklklklfdeieefcieabaaaaeaaaabaagbaaaaaafjaaaaaeegiocaaa
aaaaaaaaaeaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaabaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaad
mccabaaaabaaaaaagfaaaaaddccabaaaacaaaaaagiaaaaacabaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaaaaaaaaaabaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaaaaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaacaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaaaaaaaaa
adaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaakhccabaaaabaaaaaa
egbabaaaabaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaacaebaaaaaaaadiaaaaah
iccabaaaabaaaaaabkbabaaaaaaaaaaaabeaaaaagpbciddldiaaaaahbccabaaa
acaaaaaabkbabaaaabaaaaaaabeaaaaaaaaacaebdiaaaaahcccabaaaacaaaaaa
bkbabaaaaaaaaaaaabeaaaaagpbciddldoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;

attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec2 tmpvar_1;
  highp vec2 tmpvar_2;
  tmpvar_1.x = (_glesMultiTexCoord0.x * 10.0000);
  tmpvar_1.y = (_glesVertex.y * 0.00400000);
  tmpvar_2.x = (_glesMultiTexCoord0.y * 10.0000);
  tmpvar_2.y = (_glesVertex.y * 0.00400000);
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _Vert;
uniform sampler2D _Control1;
uniform sampler2D _Baked;
void main ()
{
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control1, xlv_TEXCOORD0);
  gl_FragData[0] = (((((texture2D (_Vert, xlv_TEXCOORD1) - vec4(0.000000, 0.0400000, 0.0300000, 0.000000)) * tmpvar_1.x) + ((texture2D (_Vert, xlv_TEXCOORD2) - vec4(0.000000, 0.0400000, 0.0300000, 0.000000)) * tmpvar_1.y)) + (((1.25000 * texture2D (_Baked, xlv_TEXCOORD0)) + vec4(0.000000, 0.0400000, 0.0400000, 0.000000)) * ((1.00000 - tmpvar_1.x) - tmpvar_1.y))) * (2.00000 * texture2D (unity_Lightmap, xlv_TEXCOORD0)));
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;

attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec2 tmpvar_1;
  highp vec2 tmpvar_2;
  tmpvar_1.x = (_glesMultiTexCoord0.x * 10.0000);
  tmpvar_1.y = (_glesVertex.y * 0.00400000);
  tmpvar_2.x = (_glesMultiTexCoord0.y * 10.0000);
  tmpvar_2.y = (_glesVertex.y * 0.00400000);
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _Vert;
uniform sampler2D _Control1;
uniform sampler2D _Baked;
void main ()
{
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control1, xlv_TEXCOORD0);
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (unity_Lightmap, xlv_TEXCOORD0);
  gl_FragData[0] = (((((texture2D (_Vert, xlv_TEXCOORD1) - vec4(0.000000, 0.0400000, 0.0300000, 0.000000)) * tmpvar_1.x) + ((texture2D (_Vert, xlv_TEXCOORD2) - vec4(0.000000, 0.0400000, 0.0300000, 0.000000)) * tmpvar_1.y)) + (((1.25000 * texture2D (_Baked, xlv_TEXCOORD0)) + vec4(0.000000, 0.0400000, 0.0400000, 0.000000)) * ((1.00000 - tmpvar_1.x) - tmpvar_1.y))) * ((8.00000 * tmpvar_2.w) * tmpvar_2));
}



#endif"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "UnityPerDraw" 336 // 64 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
BindCB "UnityPerDraw" 0
// 9 instructions, 1 temp regs, 0 temp arrays:
// ALU 5 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_3
eefiecedcojhmgnfeghijickggojedchndjhhjhfabaaaaaaliadaaaaaeaaaaaa
daaaaaaafaabaaaanmacaaaadaadaaaaebgpgodjbiabaaaabiabaaaaaaacpopp
oeaaaaaadeaaaaaaabaaceaaaaaadaaaaaaadaaaaaaaceaaabaadaaaaaaaaaaa
aeaaabaaaaaaaaaaaaaaaaaaabacpoppfbaaaaafafaaapkaaaaaiadpaaaacaeb
gpbciddlaaaaaaaabpaaaaacafaaaaiaaaaaapjabpaaaaacafaaabiaabaaapja
afaaaaadaaaaapiaaaaaffjaacaaoekaaeaaaaaeaaaaapiaabaaoekaaaaaaaja
aaaaoeiaaeaaaaaeaaaaapiaadaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaapia
aeaaoekaaaaappjaaaaaoeiaaeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeia
abaaaaacaaaaammaaaaaoeiaafaaaaadaaaaaloaabaacejaafaagakaafaaaaad
aaaaaeoaaaaaffjaafaakkkaafaaaaadabaaaboaabaaffjaafaaffkaafaaaaad
abaaacoaaaaaffjaafaakkkappppaaaafdeieefcieabaaaaeaaaabaagbaaaaaa
fjaaaaaeegiocaaaaaaaaaaaaeaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaad
dcbabaaaabaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaa
abaaaaaagfaaaaadmccabaaaabaaaaaagfaaaaaddccabaaaacaaaaaagiaaaaac
abaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaaaaaaaaa
abaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaaaaaaaaaagbabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaa
acaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaa
egiocaaaaaaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaak
hccabaaaabaaaaaaegbabaaaabaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaacaeb
aaaaaaaadiaaaaahiccabaaaabaaaaaabkbabaaaaaaaaaaaabeaaaaagpbciddl
diaaaaahbccabaaaacaaaaaabkbabaaaabaaaaaaabeaaaaaaaaacaebdiaaaaah
cccabaaaacaaaaaabkbabaaaaaaaaaaaabeaaaaagpbciddldoaaaaabejfdeheo
emaaaaaaacaaaaaaaiaaaaaadiaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apapaaaaebaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadadaaaafaepfdej
feejepeoaafeeffiedepepfceeaaklklepfdeheoiaaaaaaaaeaaaaaaaiaaaaaa
giaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaabaaaaaaadamaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaa
abaaaaaaamadaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaadamaaaa
fdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklkl"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
"!!GLSL
#ifdef VERTEX
varying vec2 xlv_TEXCOORD2;
varying vec2 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;

void main ()
{
  vec2 tmpvar_1;
  vec2 tmpvar_2;
  tmpvar_1.x = (gl_MultiTexCoord0.x * 10.0000);
  tmpvar_1.y = (gl_Vertex.y * 0.00400000);
  tmpvar_2.x = (gl_MultiTexCoord0.y * 10.0000);
  tmpvar_2.y = (gl_Vertex.y * 0.00400000);
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = gl_MultiTexCoord0.xy;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
}


#endif
#ifdef FRAGMENT
varying vec2 xlv_TEXCOORD2;
varying vec2 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _Vert;
uniform sampler2D _Control1;
uniform sampler2D _Baked;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control1, xlv_TEXCOORD0);
  vec4 tmpvar_2;
  tmpvar_2 = texture2D (unity_Lightmap, xlv_TEXCOORD0);
  gl_FragData[0] = (((((texture2D (_Vert, xlv_TEXCOORD1) - vec4(0.000000, 0.0400000, 0.0300000, 0.000000)) * tmpvar_1.x) + ((texture2D (_Vert, xlv_TEXCOORD2) - vec4(0.000000, 0.0400000, 0.0300000, 0.000000)) * tmpvar_1.y)) + (((1.25000 * texture2D (_Baked, xlv_TEXCOORD0)) + vec4(0.000000, 0.0400000, 0.0400000, 0.000000)) * ((1.00000 - tmpvar_1.x) - tmpvar_1.y))) * ((8.00000 * tmpvar_2.w) * tmpvar_2));
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
"vs_2_0
; 10 ALU
def c4, 0.00400000, 10.00000000, 0, 0
dcl_position0 v0
dcl_texcoord0 v1
mul r0.y, v0, c4.x
mul r0.x, v1.y, c4.y
mov oT0.xy, v1
mov oT2.xy, r0
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
mov oT1.y, r0
mul oT1.x, v1, c4.y
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "UnityPerDraw" 336 // 64 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
BindCB "UnityPerDraw" 0
// 9 instructions, 1 temp regs, 0 temp arrays:
// ALU 5 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedcpijkondljefbdlglhfoananiakipljgabaaaaaajeacaaaaadaaaaaa
cmaaaaaaiaaaaaaaaiabaaaaejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklkl
epfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
heaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaaamadaaaaheaaaaaaacaaaaaa
aaaaaaaaadaaaaaaacaaaaaaadamaaaafdfgfpfaepfdejfeejepeoaafeeffied
epepfceeaaklklklfdeieefcieabaaaaeaaaabaagbaaaaaafjaaaaaeegiocaaa
aaaaaaaaaeaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaabaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaad
mccabaaaabaaaaaagfaaaaaddccabaaaacaaaaaagiaaaaacabaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaaaaaaaaaabaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaaaaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaacaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaaaaaaaaa
adaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaakhccabaaaabaaaaaa
egbabaaaabaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaacaebaaaaaaaadiaaaaah
iccabaaaabaaaaaabkbabaaaaaaaaaaaabeaaaaagpbciddldiaaaaahbccabaaa
acaaaaaabkbabaaaabaaaaaaabeaaaaaaaaacaebdiaaaaahcccabaaaacaaaaaa
bkbabaaaaaaaaaaaabeaaaaagpbciddldoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;

attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec2 tmpvar_1;
  highp vec2 tmpvar_2;
  tmpvar_1.x = (_glesMultiTexCoord0.x * 10.0000);
  tmpvar_1.y = (_glesVertex.y * 0.00400000);
  tmpvar_2.x = (_glesMultiTexCoord0.y * 10.0000);
  tmpvar_2.y = (_glesVertex.y * 0.00400000);
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _Vert;
uniform sampler2D _Control1;
uniform sampler2D _Baked;
void main ()
{
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control1, xlv_TEXCOORD0);
  gl_FragData[0] = (((((texture2D (_Vert, xlv_TEXCOORD1) - vec4(0.000000, 0.0400000, 0.0300000, 0.000000)) * tmpvar_1.x) + ((texture2D (_Vert, xlv_TEXCOORD2) - vec4(0.000000, 0.0400000, 0.0300000, 0.000000)) * tmpvar_1.y)) + (((1.25000 * texture2D (_Baked, xlv_TEXCOORD0)) + vec4(0.000000, 0.0400000, 0.0400000, 0.000000)) * ((1.00000 - tmpvar_1.x) - tmpvar_1.y))) * (2.00000 * texture2D (unity_Lightmap, xlv_TEXCOORD0)));
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;

attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec2 tmpvar_1;
  highp vec2 tmpvar_2;
  tmpvar_1.x = (_glesMultiTexCoord0.x * 10.0000);
  tmpvar_1.y = (_glesVertex.y * 0.00400000);
  tmpvar_2.x = (_glesMultiTexCoord0.y * 10.0000);
  tmpvar_2.y = (_glesVertex.y * 0.00400000);
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _Vert;
uniform sampler2D _Control1;
uniform sampler2D _Baked;
void main ()
{
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control1, xlv_TEXCOORD0);
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (unity_Lightmap, xlv_TEXCOORD0);
  gl_FragData[0] = (((((texture2D (_Vert, xlv_TEXCOORD1) - vec4(0.000000, 0.0400000, 0.0300000, 0.000000)) * tmpvar_1.x) + ((texture2D (_Vert, xlv_TEXCOORD2) - vec4(0.000000, 0.0400000, 0.0300000, 0.000000)) * tmpvar_1.y)) + (((1.25000 * texture2D (_Baked, xlv_TEXCOORD0)) + vec4(0.000000, 0.0400000, 0.0400000, 0.000000)) * ((1.00000 - tmpvar_1.x) - tmpvar_1.y))) * ((8.00000 * tmpvar_2.w) * tmpvar_2));
}



#endif"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "UnityPerDraw" 336 // 64 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
BindCB "UnityPerDraw" 0
// 9 instructions, 1 temp regs, 0 temp arrays:
// ALU 5 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_3
eefiecedcojhmgnfeghijickggojedchndjhhjhfabaaaaaaliadaaaaaeaaaaaa
daaaaaaafaabaaaanmacaaaadaadaaaaebgpgodjbiabaaaabiabaaaaaaacpopp
oeaaaaaadeaaaaaaabaaceaaaaaadaaaaaaadaaaaaaaceaaabaadaaaaaaaaaaa
aeaaabaaaaaaaaaaaaaaaaaaabacpoppfbaaaaafafaaapkaaaaaiadpaaaacaeb
gpbciddlaaaaaaaabpaaaaacafaaaaiaaaaaapjabpaaaaacafaaabiaabaaapja
afaaaaadaaaaapiaaaaaffjaacaaoekaaeaaaaaeaaaaapiaabaaoekaaaaaaaja
aaaaoeiaaeaaaaaeaaaaapiaadaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaapia
aeaaoekaaaaappjaaaaaoeiaaeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeia
abaaaaacaaaaammaaaaaoeiaafaaaaadaaaaaloaabaacejaafaagakaafaaaaad
aaaaaeoaaaaaffjaafaakkkaafaaaaadabaaaboaabaaffjaafaaffkaafaaaaad
abaaacoaaaaaffjaafaakkkappppaaaafdeieefcieabaaaaeaaaabaagbaaaaaa
fjaaaaaeegiocaaaaaaaaaaaaeaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaad
dcbabaaaabaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaa
abaaaaaagfaaaaadmccabaaaabaaaaaagfaaaaaddccabaaaacaaaaaagiaaaaac
abaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaaaaaaaaa
abaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaaaaaaaaaagbabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaa
acaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaa
egiocaaaaaaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaak
hccabaaaabaaaaaaegbabaaaabaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaacaeb
aaaaaaaadiaaaaahiccabaaaabaaaaaabkbabaaaaaaaaaaaabeaaaaagpbciddl
diaaaaahbccabaaaacaaaaaabkbabaaaabaaaaaaabeaaaaaaaaacaebdiaaaaah
cccabaaaacaaaaaabkbabaaaaaaaaaaaabeaaaaagpbciddldoaaaaabejfdeheo
emaaaaaaacaaaaaaaiaaaaaadiaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apapaaaaebaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadadaaaafaepfdej
feejepeoaafeeffiedepepfceeaaklklepfdeheoiaaaaaaaaeaaaaaaaiaaaaaa
giaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaabaaaaaaadamaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaa
abaaaaaaamadaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaadamaaaa
fdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklkl"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLSL
#ifdef VERTEX
varying vec2 xlv_TEXCOORD2;
varying vec2 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;

void main ()
{
  vec2 tmpvar_1;
  vec2 tmpvar_2;
  tmpvar_1.x = (gl_MultiTexCoord0.x * 10.0000);
  tmpvar_1.y = (gl_Vertex.y * 0.00400000);
  tmpvar_2.x = (gl_MultiTexCoord0.y * 10.0000);
  tmpvar_2.y = (gl_Vertex.y * 0.00400000);
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = gl_MultiTexCoord0.xy;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
}


#endif
#ifdef FRAGMENT
varying vec2 xlv_TEXCOORD2;
varying vec2 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _Vert;
uniform sampler2D _Control1;
uniform sampler2D _Baked;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control1, xlv_TEXCOORD0);
  vec4 tmpvar_2;
  tmpvar_2 = texture2D (unity_Lightmap, xlv_TEXCOORD0);
  gl_FragData[0] = (((((texture2D (_Vert, xlv_TEXCOORD1) - vec4(0.000000, 0.0400000, 0.0300000, 0.000000)) * tmpvar_1.x) + ((texture2D (_Vert, xlv_TEXCOORD2) - vec4(0.000000, 0.0400000, 0.0300000, 0.000000)) * tmpvar_1.y)) + (((1.25000 * texture2D (_Baked, xlv_TEXCOORD0)) + vec4(0.000000, 0.0400000, 0.0400000, 0.000000)) * ((1.00000 - tmpvar_1.x) - tmpvar_1.y))) * ((8.00000 * tmpvar_2.w) * tmpvar_2));
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
"vs_2_0
; 10 ALU
def c4, 0.00400000, 10.00000000, 0, 0
dcl_position0 v0
dcl_texcoord0 v1
mul r0.y, v0, c4.x
mul r0.x, v1.y, c4.y
mov oT0.xy, v1
mov oT2.xy, r0
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
mov oT1.y, r0
mul oT1.x, v1, c4.y
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "UnityPerDraw" 336 // 64 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
BindCB "UnityPerDraw" 0
// 9 instructions, 1 temp regs, 0 temp arrays:
// ALU 5 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedcpijkondljefbdlglhfoananiakipljgabaaaaaajeacaaaaadaaaaaa
cmaaaaaaiaaaaaaaaiabaaaaejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklkl
epfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
heaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaaamadaaaaheaaaaaaacaaaaaa
aaaaaaaaadaaaaaaacaaaaaaadamaaaafdfgfpfaepfdejfeejepeoaafeeffied
epepfceeaaklklklfdeieefcieabaaaaeaaaabaagbaaaaaafjaaaaaeegiocaaa
aaaaaaaaaeaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaabaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaad
mccabaaaabaaaaaagfaaaaaddccabaaaacaaaaaagiaaaaacabaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaaaaaaaaaabaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaaaaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaacaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaaaaaaaaa
adaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaakhccabaaaabaaaaaa
egbabaaaabaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaacaebaaaaaaaadiaaaaah
iccabaaaabaaaaaabkbabaaaaaaaaaaaabeaaaaagpbciddldiaaaaahbccabaaa
acaaaaaabkbabaaaabaaaaaaabeaaaaaaaaacaebdiaaaaahcccabaaaacaaaaaa
bkbabaaaaaaaaaaaabeaaaaagpbciddldoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;

attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec2 tmpvar_1;
  highp vec2 tmpvar_2;
  tmpvar_1.x = (_glesMultiTexCoord0.x * 10.0000);
  tmpvar_1.y = (_glesVertex.y * 0.00400000);
  tmpvar_2.x = (_glesMultiTexCoord0.y * 10.0000);
  tmpvar_2.y = (_glesVertex.y * 0.00400000);
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _Vert;
uniform sampler2D _Control1;
uniform sampler2D _Baked;
void main ()
{
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control1, xlv_TEXCOORD0);
  gl_FragData[0] = (((((texture2D (_Vert, xlv_TEXCOORD1) - vec4(0.000000, 0.0400000, 0.0300000, 0.000000)) * tmpvar_1.x) + ((texture2D (_Vert, xlv_TEXCOORD2) - vec4(0.000000, 0.0400000, 0.0300000, 0.000000)) * tmpvar_1.y)) + (((1.25000 * texture2D (_Baked, xlv_TEXCOORD0)) + vec4(0.000000, 0.0400000, 0.0400000, 0.000000)) * ((1.00000 - tmpvar_1.x) - tmpvar_1.y))) * (2.00000 * texture2D (unity_Lightmap, xlv_TEXCOORD0)));
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;

attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec2 tmpvar_1;
  highp vec2 tmpvar_2;
  tmpvar_1.x = (_glesMultiTexCoord0.x * 10.0000);
  tmpvar_1.y = (_glesVertex.y * 0.00400000);
  tmpvar_2.x = (_glesMultiTexCoord0.y * 10.0000);
  tmpvar_2.y = (_glesVertex.y * 0.00400000);
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _Vert;
uniform sampler2D _Control1;
uniform sampler2D _Baked;
void main ()
{
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control1, xlv_TEXCOORD0);
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (unity_Lightmap, xlv_TEXCOORD0);
  gl_FragData[0] = (((((texture2D (_Vert, xlv_TEXCOORD1) - vec4(0.000000, 0.0400000, 0.0300000, 0.000000)) * tmpvar_1.x) + ((texture2D (_Vert, xlv_TEXCOORD2) - vec4(0.000000, 0.0400000, 0.0300000, 0.000000)) * tmpvar_1.y)) + (((1.25000 * texture2D (_Baked, xlv_TEXCOORD0)) + vec4(0.000000, 0.0400000, 0.0400000, 0.000000)) * ((1.00000 - tmpvar_1.x) - tmpvar_1.y))) * ((8.00000 * tmpvar_2.w) * tmpvar_2));
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLSL
#ifdef VERTEX
varying vec2 xlv_TEXCOORD2;
varying vec2 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;

void main ()
{
  vec2 tmpvar_1;
  vec2 tmpvar_2;
  tmpvar_1.x = (gl_MultiTexCoord0.x * 10.0000);
  tmpvar_1.y = (gl_Vertex.y * 0.00400000);
  tmpvar_2.x = (gl_MultiTexCoord0.y * 10.0000);
  tmpvar_2.y = (gl_Vertex.y * 0.00400000);
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = gl_MultiTexCoord0.xy;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
}


#endif
#ifdef FRAGMENT
varying vec2 xlv_TEXCOORD2;
varying vec2 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _Vert;
uniform sampler2D _Control1;
uniform sampler2D _Baked;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control1, xlv_TEXCOORD0);
  vec4 tmpvar_2;
  tmpvar_2 = texture2D (unity_Lightmap, xlv_TEXCOORD0);
  gl_FragData[0] = (((((texture2D (_Vert, xlv_TEXCOORD1) - vec4(0.000000, 0.0400000, 0.0300000, 0.000000)) * tmpvar_1.x) + ((texture2D (_Vert, xlv_TEXCOORD2) - vec4(0.000000, 0.0400000, 0.0300000, 0.000000)) * tmpvar_1.y)) + (((1.25000 * texture2D (_Baked, xlv_TEXCOORD0)) + vec4(0.000000, 0.0400000, 0.0400000, 0.000000)) * ((1.00000 - tmpvar_1.x) - tmpvar_1.y))) * ((8.00000 * tmpvar_2.w) * tmpvar_2));
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
"vs_2_0
; 10 ALU
def c4, 0.00400000, 10.00000000, 0, 0
dcl_position0 v0
dcl_texcoord0 v1
mul r0.y, v0, c4.x
mul r0.x, v1.y, c4.y
mov oT0.xy, v1
mov oT2.xy, r0
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
mov oT1.y, r0
mul oT1.x, v1, c4.y
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "UnityPerDraw" 336 // 64 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
BindCB "UnityPerDraw" 0
// 9 instructions, 1 temp regs, 0 temp arrays:
// ALU 5 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedcpijkondljefbdlglhfoananiakipljgabaaaaaajeacaaaaadaaaaaa
cmaaaaaaiaaaaaaaaiabaaaaejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklkl
epfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
heaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaaamadaaaaheaaaaaaacaaaaaa
aaaaaaaaadaaaaaaacaaaaaaadamaaaafdfgfpfaepfdejfeejepeoaafeeffied
epepfceeaaklklklfdeieefcieabaaaaeaaaabaagbaaaaaafjaaaaaeegiocaaa
aaaaaaaaaeaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaabaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaad
mccabaaaabaaaaaagfaaaaaddccabaaaacaaaaaagiaaaaacabaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaaaaaaaaaabaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaaaaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaacaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaaaaaaaaa
adaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaakhccabaaaabaaaaaa
egbabaaaabaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaacaebaaaaaaaadiaaaaah
iccabaaaabaaaaaabkbabaaaaaaaaaaaabeaaaaagpbciddldiaaaaahbccabaaa
acaaaaaabkbabaaaabaaaaaaabeaaaaaaaaacaebdiaaaaahcccabaaaacaaaaaa
bkbabaaaaaaaaaaaabeaaaaagpbciddldoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;

attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec2 tmpvar_1;
  highp vec2 tmpvar_2;
  tmpvar_1.x = (_glesMultiTexCoord0.x * 10.0000);
  tmpvar_1.y = (_glesVertex.y * 0.00400000);
  tmpvar_2.x = (_glesMultiTexCoord0.y * 10.0000);
  tmpvar_2.y = (_glesVertex.y * 0.00400000);
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _Vert;
uniform sampler2D _Control1;
uniform sampler2D _Baked;
void main ()
{
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control1, xlv_TEXCOORD0);
  gl_FragData[0] = (((((texture2D (_Vert, xlv_TEXCOORD1) - vec4(0.000000, 0.0400000, 0.0300000, 0.000000)) * tmpvar_1.x) + ((texture2D (_Vert, xlv_TEXCOORD2) - vec4(0.000000, 0.0400000, 0.0300000, 0.000000)) * tmpvar_1.y)) + (((1.25000 * texture2D (_Baked, xlv_TEXCOORD0)) + vec4(0.000000, 0.0400000, 0.0400000, 0.000000)) * ((1.00000 - tmpvar_1.x) - tmpvar_1.y))) * (2.00000 * texture2D (unity_Lightmap, xlv_TEXCOORD0)));
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;

attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec2 tmpvar_1;
  highp vec2 tmpvar_2;
  tmpvar_1.x = (_glesMultiTexCoord0.x * 10.0000);
  tmpvar_1.y = (_glesVertex.y * 0.00400000);
  tmpvar_2.x = (_glesMultiTexCoord0.y * 10.0000);
  tmpvar_2.y = (_glesVertex.y * 0.00400000);
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _Vert;
uniform sampler2D _Control1;
uniform sampler2D _Baked;
void main ()
{
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control1, xlv_TEXCOORD0);
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (unity_Lightmap, xlv_TEXCOORD0);
  gl_FragData[0] = (((((texture2D (_Vert, xlv_TEXCOORD1) - vec4(0.000000, 0.0400000, 0.0300000, 0.000000)) * tmpvar_1.x) + ((texture2D (_Vert, xlv_TEXCOORD2) - vec4(0.000000, 0.0400000, 0.0300000, 0.000000)) * tmpvar_1.y)) + (((1.25000 * texture2D (_Baked, xlv_TEXCOORD0)) + vec4(0.000000, 0.0400000, 0.0400000, 0.000000)) * ((1.00000 - tmpvar_1.x) - tmpvar_1.y))) * ((8.00000 * tmpvar_2.w) * tmpvar_2));
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
"!!GLSL
#ifdef VERTEX
varying vec2 xlv_TEXCOORD2;
varying vec2 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;

void main ()
{
  vec2 tmpvar_1;
  vec2 tmpvar_2;
  tmpvar_1.x = (gl_MultiTexCoord0.x * 10.0000);
  tmpvar_1.y = (gl_Vertex.y * 0.00400000);
  tmpvar_2.x = (gl_MultiTexCoord0.y * 10.0000);
  tmpvar_2.y = (gl_Vertex.y * 0.00400000);
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = gl_MultiTexCoord0.xy;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
}


#endif
#ifdef FRAGMENT
varying vec2 xlv_TEXCOORD2;
varying vec2 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _Vert;
uniform sampler2D _Control1;
uniform sampler2D _Baked;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control1, xlv_TEXCOORD0);
  vec4 tmpvar_2;
  tmpvar_2 = texture2D (unity_Lightmap, xlv_TEXCOORD0);
  gl_FragData[0] = (((((texture2D (_Vert, xlv_TEXCOORD1) - vec4(0.000000, 0.0400000, 0.0300000, 0.000000)) * tmpvar_1.x) + ((texture2D (_Vert, xlv_TEXCOORD2) - vec4(0.000000, 0.0400000, 0.0300000, 0.000000)) * tmpvar_1.y)) + (((1.25000 * texture2D (_Baked, xlv_TEXCOORD0)) + vec4(0.000000, 0.0400000, 0.0400000, 0.000000)) * ((1.00000 - tmpvar_1.x) - tmpvar_1.y))) * ((8.00000 * tmpvar_2.w) * tmpvar_2));
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
"vs_2_0
; 10 ALU
def c4, 0.00400000, 10.00000000, 0, 0
dcl_position0 v0
dcl_texcoord0 v1
mul r0.y, v0, c4.x
mul r0.x, v1.y, c4.y
mov oT0.xy, v1
mov oT2.xy, r0
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
mov oT1.y, r0
mul oT1.x, v1, c4.y
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "UnityPerDraw" 336 // 64 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
BindCB "UnityPerDraw" 0
// 9 instructions, 1 temp regs, 0 temp arrays:
// ALU 5 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedcpijkondljefbdlglhfoananiakipljgabaaaaaajeacaaaaadaaaaaa
cmaaaaaaiaaaaaaaaiabaaaaejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklkl
epfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
heaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaaamadaaaaheaaaaaaacaaaaaa
aaaaaaaaadaaaaaaacaaaaaaadamaaaafdfgfpfaepfdejfeejepeoaafeeffied
epepfceeaaklklklfdeieefcieabaaaaeaaaabaagbaaaaaafjaaaaaeegiocaaa
aaaaaaaaaeaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaabaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaad
mccabaaaabaaaaaagfaaaaaddccabaaaacaaaaaagiaaaaacabaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaaaaaaaaaabaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaaaaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaacaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaaaaaaaaa
adaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaakhccabaaaabaaaaaa
egbabaaaabaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaacaebaaaaaaaadiaaaaah
iccabaaaabaaaaaabkbabaaaaaaaaaaaabeaaaaagpbciddldiaaaaahbccabaaa
acaaaaaabkbabaaaabaaaaaaabeaaaaaaaaacaebdiaaaaahcccabaaaacaaaaaa
bkbabaaaaaaaaaaaabeaaaaagpbciddldoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;

attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec2 tmpvar_1;
  highp vec2 tmpvar_2;
  tmpvar_1.x = (_glesMultiTexCoord0.x * 10.0000);
  tmpvar_1.y = (_glesVertex.y * 0.00400000);
  tmpvar_2.x = (_glesMultiTexCoord0.y * 10.0000);
  tmpvar_2.y = (_glesVertex.y * 0.00400000);
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _Vert;
uniform sampler2D _Control1;
uniform sampler2D _Baked;
void main ()
{
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control1, xlv_TEXCOORD0);
  gl_FragData[0] = (((((texture2D (_Vert, xlv_TEXCOORD1) - vec4(0.000000, 0.0400000, 0.0300000, 0.000000)) * tmpvar_1.x) + ((texture2D (_Vert, xlv_TEXCOORD2) - vec4(0.000000, 0.0400000, 0.0300000, 0.000000)) * tmpvar_1.y)) + (((1.25000 * texture2D (_Baked, xlv_TEXCOORD0)) + vec4(0.000000, 0.0400000, 0.0400000, 0.000000)) * ((1.00000 - tmpvar_1.x) - tmpvar_1.y))) * (2.00000 * texture2D (unity_Lightmap, xlv_TEXCOORD0)));
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;

attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec2 tmpvar_1;
  highp vec2 tmpvar_2;
  tmpvar_1.x = (_glesMultiTexCoord0.x * 10.0000);
  tmpvar_1.y = (_glesVertex.y * 0.00400000);
  tmpvar_2.x = (_glesMultiTexCoord0.y * 10.0000);
  tmpvar_2.y = (_glesVertex.y * 0.00400000);
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _Vert;
uniform sampler2D _Control1;
uniform sampler2D _Baked;
void main ()
{
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control1, xlv_TEXCOORD0);
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (unity_Lightmap, xlv_TEXCOORD0);
  gl_FragData[0] = (((((texture2D (_Vert, xlv_TEXCOORD1) - vec4(0.000000, 0.0400000, 0.0300000, 0.000000)) * tmpvar_1.x) + ((texture2D (_Vert, xlv_TEXCOORD2) - vec4(0.000000, 0.0400000, 0.0300000, 0.000000)) * tmpvar_1.y)) + (((1.25000 * texture2D (_Baked, xlv_TEXCOORD0)) + vec4(0.000000, 0.0400000, 0.0400000, 0.000000)) * ((1.00000 - tmpvar_1.x) - tmpvar_1.y))) * ((8.00000 * tmpvar_2.w) * tmpvar_2));
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
"!!GLSL
#ifdef VERTEX
varying vec2 xlv_TEXCOORD2;
varying vec2 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;

void main ()
{
  vec2 tmpvar_1;
  vec2 tmpvar_2;
  tmpvar_1.x = (gl_MultiTexCoord0.x * 10.0000);
  tmpvar_1.y = (gl_Vertex.y * 0.00400000);
  tmpvar_2.x = (gl_MultiTexCoord0.y * 10.0000);
  tmpvar_2.y = (gl_Vertex.y * 0.00400000);
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = gl_MultiTexCoord0.xy;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
}


#endif
#ifdef FRAGMENT
varying vec2 xlv_TEXCOORD2;
varying vec2 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _Vert;
uniform sampler2D _Control1;
uniform sampler2D _Baked;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control1, xlv_TEXCOORD0);
  vec4 tmpvar_2;
  tmpvar_2 = texture2D (unity_Lightmap, xlv_TEXCOORD0);
  gl_FragData[0] = (((((texture2D (_Vert, xlv_TEXCOORD1) - vec4(0.000000, 0.0400000, 0.0300000, 0.000000)) * tmpvar_1.x) + ((texture2D (_Vert, xlv_TEXCOORD2) - vec4(0.000000, 0.0400000, 0.0300000, 0.000000)) * tmpvar_1.y)) + (((1.25000 * texture2D (_Baked, xlv_TEXCOORD0)) + vec4(0.000000, 0.0400000, 0.0400000, 0.000000)) * ((1.00000 - tmpvar_1.x) - tmpvar_1.y))) * ((8.00000 * tmpvar_2.w) * tmpvar_2));
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
"vs_2_0
; 10 ALU
def c4, 0.00400000, 10.00000000, 0, 0
dcl_position0 v0
dcl_texcoord0 v1
mul r0.y, v0, c4.x
mul r0.x, v1.y, c4.y
mov oT0.xy, v1
mov oT2.xy, r0
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
mov oT1.y, r0
mul oT1.x, v1, c4.y
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "UnityPerDraw" 336 // 64 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
BindCB "UnityPerDraw" 0
// 9 instructions, 1 temp regs, 0 temp arrays:
// ALU 5 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedcpijkondljefbdlglhfoananiakipljgabaaaaaajeacaaaaadaaaaaa
cmaaaaaaiaaaaaaaaiabaaaaejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklkl
epfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
heaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaaamadaaaaheaaaaaaacaaaaaa
aaaaaaaaadaaaaaaacaaaaaaadamaaaafdfgfpfaepfdejfeejepeoaafeeffied
epepfceeaaklklklfdeieefcieabaaaaeaaaabaagbaaaaaafjaaaaaeegiocaaa
aaaaaaaaaeaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaabaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaad
mccabaaaabaaaaaagfaaaaaddccabaaaacaaaaaagiaaaaacabaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaaaaaaaaaabaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaaaaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaacaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaaaaaaaaa
adaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaakhccabaaaabaaaaaa
egbabaaaabaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaacaebaaaaaaaadiaaaaah
iccabaaaabaaaaaabkbabaaaaaaaaaaaabeaaaaagpbciddldiaaaaahbccabaaa
acaaaaaabkbabaaaabaaaaaaabeaaaaaaaaacaebdiaaaaahcccabaaaacaaaaaa
bkbabaaaaaaaaaaaabeaaaaagpbciddldoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;

attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec2 tmpvar_1;
  highp vec2 tmpvar_2;
  tmpvar_1.x = (_glesMultiTexCoord0.x * 10.0000);
  tmpvar_1.y = (_glesVertex.y * 0.00400000);
  tmpvar_2.x = (_glesMultiTexCoord0.y * 10.0000);
  tmpvar_2.y = (_glesVertex.y * 0.00400000);
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _Vert;
uniform sampler2D _Control1;
uniform sampler2D _Baked;
void main ()
{
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control1, xlv_TEXCOORD0);
  gl_FragData[0] = (((((texture2D (_Vert, xlv_TEXCOORD1) - vec4(0.000000, 0.0400000, 0.0300000, 0.000000)) * tmpvar_1.x) + ((texture2D (_Vert, xlv_TEXCOORD2) - vec4(0.000000, 0.0400000, 0.0300000, 0.000000)) * tmpvar_1.y)) + (((1.25000 * texture2D (_Baked, xlv_TEXCOORD0)) + vec4(0.000000, 0.0400000, 0.0400000, 0.000000)) * ((1.00000 - tmpvar_1.x) - tmpvar_1.y))) * (2.00000 * texture2D (unity_Lightmap, xlv_TEXCOORD0)));
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;

attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec2 tmpvar_1;
  highp vec2 tmpvar_2;
  tmpvar_1.x = (_glesMultiTexCoord0.x * 10.0000);
  tmpvar_1.y = (_glesVertex.y * 0.00400000);
  tmpvar_2.x = (_glesMultiTexCoord0.y * 10.0000);
  tmpvar_2.y = (_glesVertex.y * 0.00400000);
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _Vert;
uniform sampler2D _Control1;
uniform sampler2D _Baked;
void main ()
{
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control1, xlv_TEXCOORD0);
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (unity_Lightmap, xlv_TEXCOORD0);
  gl_FragData[0] = (((((texture2D (_Vert, xlv_TEXCOORD1) - vec4(0.000000, 0.0400000, 0.0300000, 0.000000)) * tmpvar_1.x) + ((texture2D (_Vert, xlv_TEXCOORD2) - vec4(0.000000, 0.0400000, 0.0300000, 0.000000)) * tmpvar_1.y)) + (((1.25000 * texture2D (_Baked, xlv_TEXCOORD0)) + vec4(0.000000, 0.0400000, 0.0400000, 0.000000)) * ((1.00000 - tmpvar_1.x) - tmpvar_1.y))) * ((8.00000 * tmpvar_2.w) * tmpvar_2));
}



#endif"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "UnityPerDraw" 336 // 64 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
BindCB "UnityPerDraw" 0
// 9 instructions, 1 temp regs, 0 temp arrays:
// ALU 5 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_3
eefiecedcojhmgnfeghijickggojedchndjhhjhfabaaaaaaliadaaaaaeaaaaaa
daaaaaaafaabaaaanmacaaaadaadaaaaebgpgodjbiabaaaabiabaaaaaaacpopp
oeaaaaaadeaaaaaaabaaceaaaaaadaaaaaaadaaaaaaaceaaabaadaaaaaaaaaaa
aeaaabaaaaaaaaaaaaaaaaaaabacpoppfbaaaaafafaaapkaaaaaiadpaaaacaeb
gpbciddlaaaaaaaabpaaaaacafaaaaiaaaaaapjabpaaaaacafaaabiaabaaapja
afaaaaadaaaaapiaaaaaffjaacaaoekaaeaaaaaeaaaaapiaabaaoekaaaaaaaja
aaaaoeiaaeaaaaaeaaaaapiaadaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaapia
aeaaoekaaaaappjaaaaaoeiaaeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeia
abaaaaacaaaaammaaaaaoeiaafaaaaadaaaaaloaabaacejaafaagakaafaaaaad
aaaaaeoaaaaaffjaafaakkkaafaaaaadabaaaboaabaaffjaafaaffkaafaaaaad
abaaacoaaaaaffjaafaakkkappppaaaafdeieefcieabaaaaeaaaabaagbaaaaaa
fjaaaaaeegiocaaaaaaaaaaaaeaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaad
dcbabaaaabaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaa
abaaaaaagfaaaaadmccabaaaabaaaaaagfaaaaaddccabaaaacaaaaaagiaaaaac
abaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaaaaaaaaa
abaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaaaaaaaaaagbabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaa
acaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaa
egiocaaaaaaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaak
hccabaaaabaaaaaaegbabaaaabaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaacaeb
aaaaaaaadiaaaaahiccabaaaabaaaaaabkbabaaaaaaaaaaaabeaaaaagpbciddl
diaaaaahbccabaaaacaaaaaabkbabaaaabaaaaaaabeaaaaaaaaacaebdiaaaaah
cccabaaaacaaaaaabkbabaaaaaaaaaaaabeaaaaagpbciddldoaaaaabejfdeheo
emaaaaaaacaaaaaaaiaaaaaadiaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apapaaaaebaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadadaaaafaepfdej
feejepeoaafeeffiedepepfceeaaklklepfdeheoiaaaaaaaaeaaaaaaaiaaaaaa
giaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaabaaaaaaadamaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaa
abaaaaaaamadaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaadamaaaa
fdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklkl"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
"!!GLSL
#ifdef VERTEX
varying vec2 xlv_TEXCOORD2;
varying vec2 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;

void main ()
{
  vec2 tmpvar_1;
  vec2 tmpvar_2;
  tmpvar_1.x = (gl_MultiTexCoord0.x * 10.0000);
  tmpvar_1.y = (gl_Vertex.y * 0.00400000);
  tmpvar_2.x = (gl_MultiTexCoord0.y * 10.0000);
  tmpvar_2.y = (gl_Vertex.y * 0.00400000);
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = gl_MultiTexCoord0.xy;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
}


#endif
#ifdef FRAGMENT
varying vec2 xlv_TEXCOORD2;
varying vec2 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _Vert;
uniform sampler2D _Control1;
uniform sampler2D _Baked;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control1, xlv_TEXCOORD0);
  vec4 tmpvar_2;
  tmpvar_2 = texture2D (unity_Lightmap, xlv_TEXCOORD0);
  gl_FragData[0] = (((((texture2D (_Vert, xlv_TEXCOORD1) - vec4(0.000000, 0.0400000, 0.0300000, 0.000000)) * tmpvar_1.x) + ((texture2D (_Vert, xlv_TEXCOORD2) - vec4(0.000000, 0.0400000, 0.0300000, 0.000000)) * tmpvar_1.y)) + (((1.25000 * texture2D (_Baked, xlv_TEXCOORD0)) + vec4(0.000000, 0.0400000, 0.0400000, 0.000000)) * ((1.00000 - tmpvar_1.x) - tmpvar_1.y))) * ((8.00000 * tmpvar_2.w) * tmpvar_2));
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
"vs_2_0
; 10 ALU
def c4, 0.00400000, 10.00000000, 0, 0
dcl_position0 v0
dcl_texcoord0 v1
mul r0.y, v0, c4.x
mul r0.x, v1.y, c4.y
mov oT0.xy, v1
mov oT2.xy, r0
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
mov oT1.y, r0
mul oT1.x, v1, c4.y
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "UnityPerDraw" 336 // 64 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
BindCB "UnityPerDraw" 0
// 9 instructions, 1 temp regs, 0 temp arrays:
// ALU 5 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedcpijkondljefbdlglhfoananiakipljgabaaaaaajeacaaaaadaaaaaa
cmaaaaaaiaaaaaaaaiabaaaaejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklkl
epfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
heaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaaamadaaaaheaaaaaaacaaaaaa
aaaaaaaaadaaaaaaacaaaaaaadamaaaafdfgfpfaepfdejfeejepeoaafeeffied
epepfceeaaklklklfdeieefcieabaaaaeaaaabaagbaaaaaafjaaaaaeegiocaaa
aaaaaaaaaeaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaabaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaad
mccabaaaabaaaaaagfaaaaaddccabaaaacaaaaaagiaaaaacabaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaaaaaaaaaabaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaaaaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaacaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaaaaaaaaa
adaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaakhccabaaaabaaaaaa
egbabaaaabaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaacaebaaaaaaaadiaaaaah
iccabaaaabaaaaaabkbabaaaaaaaaaaaabeaaaaagpbciddldiaaaaahbccabaaa
acaaaaaabkbabaaaabaaaaaaabeaaaaaaaaacaebdiaaaaahcccabaaaacaaaaaa
bkbabaaaaaaaaaaaabeaaaaagpbciddldoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;

attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec2 tmpvar_1;
  highp vec2 tmpvar_2;
  tmpvar_1.x = (_glesMultiTexCoord0.x * 10.0000);
  tmpvar_1.y = (_glesVertex.y * 0.00400000);
  tmpvar_2.x = (_glesMultiTexCoord0.y * 10.0000);
  tmpvar_2.y = (_glesVertex.y * 0.00400000);
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _Vert;
uniform sampler2D _Control1;
uniform sampler2D _Baked;
void main ()
{
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control1, xlv_TEXCOORD0);
  gl_FragData[0] = (((((texture2D (_Vert, xlv_TEXCOORD1) - vec4(0.000000, 0.0400000, 0.0300000, 0.000000)) * tmpvar_1.x) + ((texture2D (_Vert, xlv_TEXCOORD2) - vec4(0.000000, 0.0400000, 0.0300000, 0.000000)) * tmpvar_1.y)) + (((1.25000 * texture2D (_Baked, xlv_TEXCOORD0)) + vec4(0.000000, 0.0400000, 0.0400000, 0.000000)) * ((1.00000 - tmpvar_1.x) - tmpvar_1.y))) * (2.00000 * texture2D (unity_Lightmap, xlv_TEXCOORD0)));
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;

attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec2 tmpvar_1;
  highp vec2 tmpvar_2;
  tmpvar_1.x = (_glesMultiTexCoord0.x * 10.0000);
  tmpvar_1.y = (_glesVertex.y * 0.00400000);
  tmpvar_2.x = (_glesMultiTexCoord0.y * 10.0000);
  tmpvar_2.y = (_glesVertex.y * 0.00400000);
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD2 = tmpvar_2;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _Vert;
uniform sampler2D _Control1;
uniform sampler2D _Baked;
void main ()
{
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control1, xlv_TEXCOORD0);
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (unity_Lightmap, xlv_TEXCOORD0);
  gl_FragData[0] = (((((texture2D (_Vert, xlv_TEXCOORD1) - vec4(0.000000, 0.0400000, 0.0300000, 0.000000)) * tmpvar_1.x) + ((texture2D (_Vert, xlv_TEXCOORD2) - vec4(0.000000, 0.0400000, 0.0300000, 0.000000)) * tmpvar_1.y)) + (((1.25000 * texture2D (_Baked, xlv_TEXCOORD0)) + vec4(0.000000, 0.0400000, 0.0400000, 0.000000)) * ((1.00000 - tmpvar_1.x) - tmpvar_1.y))) * ((8.00000 * tmpvar_2.w) * tmpvar_2));
}



#endif"
}

}
Program "fp" {
// Fragment combos: 6
//   d3d9 - ALU: 18 to 18, TEX: 5 to 5
//   d3d11 - ALU: 8 to 8, TEX: 5 to 5, FLOW: 1 to 1
//   d3d11_9x - ALU: 8 to 8, TEX: 5 to 5, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
SetTexture 0 [_Control1] 2D
SetTexture 1 [_Vert] 2D
SetTexture 2 [unity_Lightmap] 2D
SetTexture 3 [_Baked] 2D
"ps_2_0
; 18 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c0, -0.00000000, -0.04000854, -0.02999878, 1.00000000
def c1, 1.25000000, 0.00000000, 0.04000854, 8.00000000
dcl t0.xy
dcl t1.xy
dcl t2.xy
texld r1, t0, s2
texld r0, t0, s3
texld r4, t1, s1
texld r3, t2, s1
texld r5, t0, s0
mov r2.w, c0.x
mov r2.xyz, c0
add r2, r3, r2
mul_pp r3, r5.y, r2
mov r2.w, c0.x
mov r2.xyz, c0
add r2, r4, r2
mad_pp r3, r5.x, r2, r3
add_pp r2.x, -r5, c0.w
mov r4.yz, c1.z
mov r4.xw, c1.y
mad r4, r0, c1.x, r4
add_pp r0.x, r2, -r5.y
mad_pp r0, r4, r0.x, r3
mul_pp r1, r1.w, r1
mul_pp r0, r1, r0
mul_pp r0, r0, c1.w
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
SetTexture 0 [_Control1] 2D 0
SetTexture 1 [_Vert] 2D 2
SetTexture 2 [unity_Lightmap] 2D 3
SetTexture 3 [_Baked] 2D 1
// 17 instructions, 4 temp regs, 0 temp arrays:
// ALU 8 float, 0 int, 0 uint
// TEX 5 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedmjbbmfogdenkfaacnigipibageacchdfabaaaaaanmadaaaaadaaaaaa
cmaaaaaaleaaaaaaoiaaaaaaejfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaadadaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklklfdeieefcomacaaaaeaaaaaaallaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaad
aagabaaaadaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaa
abaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafibiaaaeaahabaaa
adaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadmcbabaaaabaaaaaa
gcbaaaaddcbabaaaacaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaa
efaaaaajpcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaaadaaaaaaaagabaaa
abaaaaaadcaaaaappcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaaaaaakadp
aaaakadpaaaakadpaaaakadpaceaaaaaaaaaaaaaaknhcddnaknhcddnaaaaaaaa
efaaaaajpcaabaaaabaaaaaaogbkbaaaabaaaaaaeghobaaaabaaaaaaaagabaaa
acaaaaaaaaaaaaakpcaabaaaabaaaaaaegaobaaaabaaaaaaaceaaaaaaaaaaaia
aknhcdlnipmcpflmaaaaaaiaefaaaaajpcaabaaaacaaaaaaegbabaaaacaaaaaa
eghobaaaabaaaaaaaagabaaaacaaaaaaaaaaaaakpcaabaaaacaaaaaaegaobaaa
acaaaaaaaceaaaaaaaaaaaiaaknhcdlnipmcpflmaaaaaaiaefaaaaajpcaabaaa
adaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadiaaaaah
pcaabaaaacaaaaaaegaobaaaacaaaaaafgafbaaaadaaaaaadcaaaaajpcaabaaa
abaaaaaaegaobaaaabaaaaaaagaabaaaadaaaaaaegaobaaaacaaaaaaaaaaaaai
bcaabaaaacaaaaaaakaabaiaebaaaaaaadaaaaaaabeaaaaaaaaaiadpaaaaaaai
bcaabaaaacaaaaaabkaabaiaebaaaaaaadaaaaaaakaabaaaacaaaaaadcaaaaaj
pcaabaaaaaaaaaaaegaobaaaaaaaaaaaagaabaaaacaaaaaaegaobaaaabaaaaaa
efaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaacaaaaaaaagabaaa
adaaaaaadiaaaaahbcaabaaaacaaaaaadkaabaaaabaaaaaaabeaaaaaaaaaaaeb
diaaaaahpcaabaaaabaaaaaaegaobaaaabaaaaaaagaabaaaacaaaaaadiaaaaah
pccabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
SetTexture 0 [_Control1] 2D 0
SetTexture 1 [_Vert] 2D 2
SetTexture 2 [unity_Lightmap] 2D 3
SetTexture 3 [_Baked] 2D 1
// 17 instructions, 4 temp regs, 0 temp arrays:
// ALU 8 float, 0 int, 0 uint
// TEX 5 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_3
eefiecedllcllpfabedojcaofbhahmadbkjgmdjbabaaaaaamaafaaaaaeaaaaaa
daaaaaaabaacaaaaaeafaaaaimafaaaaebgpgodjniabaaaaniabaaaaaaacpppp
keabaaaadeaaaaaaaaaadeaaaaaadeaaaaaadeaaaeaaceaaaaaadeaaaaaaaaaa
adababaaabacacaaacadadaaabacppppfbaaaaafaaaaapkaaaaaaaiaaknhcdln
ipmcpflmaaaaaaebfbaaaaafabaaapkaaaaakadpaaaaaaaaaknhcddnaaaaiadp
bpaaaaacaaaaaaiaaaaaaplabpaaaaacaaaaaaiaabaaadlabpaaaaacaaaaaaja
aaaiapkabpaaaaacaaaaaajaabaiapkabpaaaaacaaaaaajaacaiapkabpaaaaac
aaaaaajaadaiapkaabaaaaacaaaaadiaaaaaollaecaaaaadabaaapiaaaaaoela
abaioekaecaaaaadaaaaapiaaaaaoeiaacaioekaaeaaaaaeabaacpiaabaaoeia
abaaaakaabaagjkaacaaaaadaaaacpiaaaaaoeiaaaaacekaecaaaaadacaacpia
aaaaoelaaaaioekaecaaaaadadaaapiaabaaoelaacaioekaacaaaaadadaacpia
adaaoeiaaaaacekaafaaaaadadaacpiaacaaffiaadaaoeiaaeaaaaaeaaaacpia
aaaaoeiaacaaaaiaadaaoeiaacaaaaadacaacbiaacaaaaibabaappkaacaaaaad
acaacbiaacaaffibacaaaaiaaeaaaaaeaaaacpiaabaaoeiaacaaaaiaaaaaoeia
ecaaaaadabaacpiaaaaaoelaadaioekaafaaaaadacaacbiaabaappiaaaaappka
afaaaaadabaacpiaabaaoeiaacaaaaiaafaaaaadaaaacpiaaaaaoeiaabaaoeia
abaaaaacaaaicpiaaaaaoeiappppaaaafdeieefcomacaaaaeaaaaaaallaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaa
acaaaaaafkaaaaadaagabaaaadaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaa
fibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaa
fibiaaaeaahabaaaadaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaad
mcbabaaaabaaaaaagcbaaaaddcbabaaaacaaaaaagfaaaaadpccabaaaaaaaaaaa
giaaaaacaeaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaa
adaaaaaaaagabaaaabaaaaaadcaaaaappcaabaaaaaaaaaaaegaobaaaaaaaaaaa
aceaaaaaaaaakadpaaaakadpaaaakadpaaaakadpaceaaaaaaaaaaaaaaknhcddn
aknhcddnaaaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaaabaaaaaaeghobaaa
abaaaaaaaagabaaaacaaaaaaaaaaaaakpcaabaaaabaaaaaaegaobaaaabaaaaaa
aceaaaaaaaaaaaiaaknhcdlnipmcpflmaaaaaaiaefaaaaajpcaabaaaacaaaaaa
egbabaaaacaaaaaaeghobaaaabaaaaaaaagabaaaacaaaaaaaaaaaaakpcaabaaa
acaaaaaaegaobaaaacaaaaaaaceaaaaaaaaaaaiaaknhcdlnipmcpflmaaaaaaia
efaaaaajpcaabaaaadaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaa
aaaaaaaadiaaaaahpcaabaaaacaaaaaaegaobaaaacaaaaaafgafbaaaadaaaaaa
dcaaaaajpcaabaaaabaaaaaaegaobaaaabaaaaaaagaabaaaadaaaaaaegaobaaa
acaaaaaaaaaaaaaibcaabaaaacaaaaaaakaabaiaebaaaaaaadaaaaaaabeaaaaa
aaaaiadpaaaaaaaibcaabaaaacaaaaaabkaabaiaebaaaaaaadaaaaaaakaabaaa
acaaaaaadcaaaaajpcaabaaaaaaaaaaaegaobaaaaaaaaaaaagaabaaaacaaaaaa
egaobaaaabaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaa
acaaaaaaaagabaaaadaaaaaadiaaaaahbcaabaaaacaaaaaadkaabaaaabaaaaaa
abeaaaaaaaaaaaebdiaaaaahpcaabaaaabaaaaaaegaobaaaabaaaaaaagaabaaa
acaaaaaadiaaaaahpccabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaaabaaaaaa
doaaaaabejfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
adadaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaaamamaaaaheaaaaaa
acaaaaaaaaaaaaaaadaaaaaaacaaaaaaadadaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
SetTexture 0 [_Control1] 2D
SetTexture 1 [_Vert] 2D
SetTexture 2 [unity_Lightmap] 2D
SetTexture 3 [_Baked] 2D
"ps_2_0
; 18 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c0, -0.00000000, -0.04000854, -0.02999878, 1.00000000
def c1, 1.25000000, 0.00000000, 0.04000854, 8.00000000
dcl t0.xy
dcl t1.xy
dcl t2.xy
texld r1, t0, s2
texld r0, t0, s3
texld r4, t1, s1
texld r3, t2, s1
texld r5, t0, s0
mov r2.w, c0.x
mov r2.xyz, c0
add r2, r3, r2
mul_pp r3, r5.y, r2
mov r2.w, c0.x
mov r2.xyz, c0
add r2, r4, r2
mad_pp r3, r5.x, r2, r3
add_pp r2.x, -r5, c0.w
mov r4.yz, c1.z
mov r4.xw, c1.y
mad r4, r0, c1.x, r4
add_pp r0.x, r2, -r5.y
mad_pp r0, r4, r0.x, r3
mul_pp r1, r1.w, r1
mul_pp r0, r1, r0
mul_pp r0, r0, c1.w
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
SetTexture 0 [_Control1] 2D 0
SetTexture 1 [_Vert] 2D 2
SetTexture 2 [unity_Lightmap] 2D 3
SetTexture 3 [_Baked] 2D 1
// 17 instructions, 4 temp regs, 0 temp arrays:
// ALU 8 float, 0 int, 0 uint
// TEX 5 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedmjbbmfogdenkfaacnigipibageacchdfabaaaaaanmadaaaaadaaaaaa
cmaaaaaaleaaaaaaoiaaaaaaejfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaadadaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklklfdeieefcomacaaaaeaaaaaaallaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaad
aagabaaaadaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaa
abaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafibiaaaeaahabaaa
adaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadmcbabaaaabaaaaaa
gcbaaaaddcbabaaaacaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaa
efaaaaajpcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaaadaaaaaaaagabaaa
abaaaaaadcaaaaappcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaaaaaakadp
aaaakadpaaaakadpaaaakadpaceaaaaaaaaaaaaaaknhcddnaknhcddnaaaaaaaa
efaaaaajpcaabaaaabaaaaaaogbkbaaaabaaaaaaeghobaaaabaaaaaaaagabaaa
acaaaaaaaaaaaaakpcaabaaaabaaaaaaegaobaaaabaaaaaaaceaaaaaaaaaaaia
aknhcdlnipmcpflmaaaaaaiaefaaaaajpcaabaaaacaaaaaaegbabaaaacaaaaaa
eghobaaaabaaaaaaaagabaaaacaaaaaaaaaaaaakpcaabaaaacaaaaaaegaobaaa
acaaaaaaaceaaaaaaaaaaaiaaknhcdlnipmcpflmaaaaaaiaefaaaaajpcaabaaa
adaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadiaaaaah
pcaabaaaacaaaaaaegaobaaaacaaaaaafgafbaaaadaaaaaadcaaaaajpcaabaaa
abaaaaaaegaobaaaabaaaaaaagaabaaaadaaaaaaegaobaaaacaaaaaaaaaaaaai
bcaabaaaacaaaaaaakaabaiaebaaaaaaadaaaaaaabeaaaaaaaaaiadpaaaaaaai
bcaabaaaacaaaaaabkaabaiaebaaaaaaadaaaaaaakaabaaaacaaaaaadcaaaaaj
pcaabaaaaaaaaaaaegaobaaaaaaaaaaaagaabaaaacaaaaaaegaobaaaabaaaaaa
efaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaacaaaaaaaagabaaa
adaaaaaadiaaaaahbcaabaaaacaaaaaadkaabaaaabaaaaaaabeaaaaaaaaaaaeb
diaaaaahpcaabaaaabaaaaaaegaobaaaabaaaaaaagaabaaaacaaaaaadiaaaaah
pccabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
SetTexture 0 [_Control1] 2D 0
SetTexture 1 [_Vert] 2D 2
SetTexture 2 [unity_Lightmap] 2D 3
SetTexture 3 [_Baked] 2D 1
// 17 instructions, 4 temp regs, 0 temp arrays:
// ALU 8 float, 0 int, 0 uint
// TEX 5 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_3
eefiecedllcllpfabedojcaofbhahmadbkjgmdjbabaaaaaamaafaaaaaeaaaaaa
daaaaaaabaacaaaaaeafaaaaimafaaaaebgpgodjniabaaaaniabaaaaaaacpppp
keabaaaadeaaaaaaaaaadeaaaaaadeaaaaaadeaaaeaaceaaaaaadeaaaaaaaaaa
adababaaabacacaaacadadaaabacppppfbaaaaafaaaaapkaaaaaaaiaaknhcdln
ipmcpflmaaaaaaebfbaaaaafabaaapkaaaaakadpaaaaaaaaaknhcddnaaaaiadp
bpaaaaacaaaaaaiaaaaaaplabpaaaaacaaaaaaiaabaaadlabpaaaaacaaaaaaja
aaaiapkabpaaaaacaaaaaajaabaiapkabpaaaaacaaaaaajaacaiapkabpaaaaac
aaaaaajaadaiapkaabaaaaacaaaaadiaaaaaollaecaaaaadabaaapiaaaaaoela
abaioekaecaaaaadaaaaapiaaaaaoeiaacaioekaaeaaaaaeabaacpiaabaaoeia
abaaaakaabaagjkaacaaaaadaaaacpiaaaaaoeiaaaaacekaecaaaaadacaacpia
aaaaoelaaaaioekaecaaaaadadaaapiaabaaoelaacaioekaacaaaaadadaacpia
adaaoeiaaaaacekaafaaaaadadaacpiaacaaffiaadaaoeiaaeaaaaaeaaaacpia
aaaaoeiaacaaaaiaadaaoeiaacaaaaadacaacbiaacaaaaibabaappkaacaaaaad
acaacbiaacaaffibacaaaaiaaeaaaaaeaaaacpiaabaaoeiaacaaaaiaaaaaoeia
ecaaaaadabaacpiaaaaaoelaadaioekaafaaaaadacaacbiaabaappiaaaaappka
afaaaaadabaacpiaabaaoeiaacaaaaiaafaaaaadaaaacpiaaaaaoeiaabaaoeia
abaaaaacaaaicpiaaaaaoeiappppaaaafdeieefcomacaaaaeaaaaaaallaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaa
acaaaaaafkaaaaadaagabaaaadaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaa
fibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaa
fibiaaaeaahabaaaadaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaad
mcbabaaaabaaaaaagcbaaaaddcbabaaaacaaaaaagfaaaaadpccabaaaaaaaaaaa
giaaaaacaeaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaa
adaaaaaaaagabaaaabaaaaaadcaaaaappcaabaaaaaaaaaaaegaobaaaaaaaaaaa
aceaaaaaaaaakadpaaaakadpaaaakadpaaaakadpaceaaaaaaaaaaaaaaknhcddn
aknhcddnaaaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaaabaaaaaaeghobaaa
abaaaaaaaagabaaaacaaaaaaaaaaaaakpcaabaaaabaaaaaaegaobaaaabaaaaaa
aceaaaaaaaaaaaiaaknhcdlnipmcpflmaaaaaaiaefaaaaajpcaabaaaacaaaaaa
egbabaaaacaaaaaaeghobaaaabaaaaaaaagabaaaacaaaaaaaaaaaaakpcaabaaa
acaaaaaaegaobaaaacaaaaaaaceaaaaaaaaaaaiaaknhcdlnipmcpflmaaaaaaia
efaaaaajpcaabaaaadaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaa
aaaaaaaadiaaaaahpcaabaaaacaaaaaaegaobaaaacaaaaaafgafbaaaadaaaaaa
dcaaaaajpcaabaaaabaaaaaaegaobaaaabaaaaaaagaabaaaadaaaaaaegaobaaa
acaaaaaaaaaaaaaibcaabaaaacaaaaaaakaabaiaebaaaaaaadaaaaaaabeaaaaa
aaaaiadpaaaaaaaibcaabaaaacaaaaaabkaabaiaebaaaaaaadaaaaaaakaabaaa
acaaaaaadcaaaaajpcaabaaaaaaaaaaaegaobaaaaaaaaaaaagaabaaaacaaaaaa
egaobaaaabaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaa
acaaaaaaaagabaaaadaaaaaadiaaaaahbcaabaaaacaaaaaadkaabaaaabaaaaaa
abeaaaaaaaaaaaebdiaaaaahpcaabaaaabaaaaaaegaobaaaabaaaaaaagaabaaa
acaaaaaadiaaaaahpccabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaaabaaaaaa
doaaaaabejfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
adadaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaaamamaaaaheaaaaaa
acaaaaaaaaaaaaaaadaaaaaaacaaaaaaadadaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
SetTexture 0 [_Control1] 2D
SetTexture 1 [_Vert] 2D
SetTexture 2 [unity_Lightmap] 2D
SetTexture 3 [_Baked] 2D
"ps_2_0
; 18 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c0, -0.00000000, -0.04000854, -0.02999878, 1.00000000
def c1, 1.25000000, 0.00000000, 0.04000854, 8.00000000
dcl t0.xy
dcl t1.xy
dcl t2.xy
texld r1, t0, s2
texld r0, t0, s3
texld r4, t1, s1
texld r3, t2, s1
texld r5, t0, s0
mov r2.w, c0.x
mov r2.xyz, c0
add r2, r3, r2
mul_pp r3, r5.y, r2
mov r2.w, c0.x
mov r2.xyz, c0
add r2, r4, r2
mad_pp r3, r5.x, r2, r3
add_pp r2.x, -r5, c0.w
mov r4.yz, c1.z
mov r4.xw, c1.y
mad r4, r0, c1.x, r4
add_pp r0.x, r2, -r5.y
mad_pp r0, r4, r0.x, r3
mul_pp r1, r1.w, r1
mul_pp r0, r1, r0
mul_pp r0, r0, c1.w
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
SetTexture 0 [_Control1] 2D 0
SetTexture 1 [_Vert] 2D 2
SetTexture 2 [unity_Lightmap] 2D 3
SetTexture 3 [_Baked] 2D 1
// 17 instructions, 4 temp regs, 0 temp arrays:
// ALU 8 float, 0 int, 0 uint
// TEX 5 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedmjbbmfogdenkfaacnigipibageacchdfabaaaaaanmadaaaaadaaaaaa
cmaaaaaaleaaaaaaoiaaaaaaejfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaadadaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklklfdeieefcomacaaaaeaaaaaaallaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaad
aagabaaaadaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaa
abaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafibiaaaeaahabaaa
adaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadmcbabaaaabaaaaaa
gcbaaaaddcbabaaaacaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaa
efaaaaajpcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaaadaaaaaaaagabaaa
abaaaaaadcaaaaappcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaaaaaakadp
aaaakadpaaaakadpaaaakadpaceaaaaaaaaaaaaaaknhcddnaknhcddnaaaaaaaa
efaaaaajpcaabaaaabaaaaaaogbkbaaaabaaaaaaeghobaaaabaaaaaaaagabaaa
acaaaaaaaaaaaaakpcaabaaaabaaaaaaegaobaaaabaaaaaaaceaaaaaaaaaaaia
aknhcdlnipmcpflmaaaaaaiaefaaaaajpcaabaaaacaaaaaaegbabaaaacaaaaaa
eghobaaaabaaaaaaaagabaaaacaaaaaaaaaaaaakpcaabaaaacaaaaaaegaobaaa
acaaaaaaaceaaaaaaaaaaaiaaknhcdlnipmcpflmaaaaaaiaefaaaaajpcaabaaa
adaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadiaaaaah
pcaabaaaacaaaaaaegaobaaaacaaaaaafgafbaaaadaaaaaadcaaaaajpcaabaaa
abaaaaaaegaobaaaabaaaaaaagaabaaaadaaaaaaegaobaaaacaaaaaaaaaaaaai
bcaabaaaacaaaaaaakaabaiaebaaaaaaadaaaaaaabeaaaaaaaaaiadpaaaaaaai
bcaabaaaacaaaaaabkaabaiaebaaaaaaadaaaaaaakaabaaaacaaaaaadcaaaaaj
pcaabaaaaaaaaaaaegaobaaaaaaaaaaaagaabaaaacaaaaaaegaobaaaabaaaaaa
efaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaacaaaaaaaagabaaa
adaaaaaadiaaaaahbcaabaaaacaaaaaadkaabaaaabaaaaaaabeaaaaaaaaaaaeb
diaaaaahpcaabaaaabaaaaaaegaobaaaabaaaaaaagaabaaaacaaaaaadiaaaaah
pccabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
SetTexture 0 [_Control1] 2D 0
SetTexture 1 [_Vert] 2D 2
SetTexture 2 [unity_Lightmap] 2D 3
SetTexture 3 [_Baked] 2D 1
// 17 instructions, 4 temp regs, 0 temp arrays:
// ALU 8 float, 0 int, 0 uint
// TEX 5 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_3
eefiecedllcllpfabedojcaofbhahmadbkjgmdjbabaaaaaamaafaaaaaeaaaaaa
daaaaaaabaacaaaaaeafaaaaimafaaaaebgpgodjniabaaaaniabaaaaaaacpppp
keabaaaadeaaaaaaaaaadeaaaaaadeaaaaaadeaaaeaaceaaaaaadeaaaaaaaaaa
adababaaabacacaaacadadaaabacppppfbaaaaafaaaaapkaaaaaaaiaaknhcdln
ipmcpflmaaaaaaebfbaaaaafabaaapkaaaaakadpaaaaaaaaaknhcddnaaaaiadp
bpaaaaacaaaaaaiaaaaaaplabpaaaaacaaaaaaiaabaaadlabpaaaaacaaaaaaja
aaaiapkabpaaaaacaaaaaajaabaiapkabpaaaaacaaaaaajaacaiapkabpaaaaac
aaaaaajaadaiapkaabaaaaacaaaaadiaaaaaollaecaaaaadabaaapiaaaaaoela
abaioekaecaaaaadaaaaapiaaaaaoeiaacaioekaaeaaaaaeabaacpiaabaaoeia
abaaaakaabaagjkaacaaaaadaaaacpiaaaaaoeiaaaaacekaecaaaaadacaacpia
aaaaoelaaaaioekaecaaaaadadaaapiaabaaoelaacaioekaacaaaaadadaacpia
adaaoeiaaaaacekaafaaaaadadaacpiaacaaffiaadaaoeiaaeaaaaaeaaaacpia
aaaaoeiaacaaaaiaadaaoeiaacaaaaadacaacbiaacaaaaibabaappkaacaaaaad
acaacbiaacaaffibacaaaaiaaeaaaaaeaaaacpiaabaaoeiaacaaaaiaaaaaoeia
ecaaaaadabaacpiaaaaaoelaadaioekaafaaaaadacaacbiaabaappiaaaaappka
afaaaaadabaacpiaabaaoeiaacaaaaiaafaaaaadaaaacpiaaaaaoeiaabaaoeia
abaaaaacaaaicpiaaaaaoeiappppaaaafdeieefcomacaaaaeaaaaaaallaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaa
acaaaaaafkaaaaadaagabaaaadaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaa
fibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaa
fibiaaaeaahabaaaadaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaad
mcbabaaaabaaaaaagcbaaaaddcbabaaaacaaaaaagfaaaaadpccabaaaaaaaaaaa
giaaaaacaeaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaa
adaaaaaaaagabaaaabaaaaaadcaaaaappcaabaaaaaaaaaaaegaobaaaaaaaaaaa
aceaaaaaaaaakadpaaaakadpaaaakadpaaaakadpaceaaaaaaaaaaaaaaknhcddn
aknhcddnaaaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaaabaaaaaaeghobaaa
abaaaaaaaagabaaaacaaaaaaaaaaaaakpcaabaaaabaaaaaaegaobaaaabaaaaaa
aceaaaaaaaaaaaiaaknhcdlnipmcpflmaaaaaaiaefaaaaajpcaabaaaacaaaaaa
egbabaaaacaaaaaaeghobaaaabaaaaaaaagabaaaacaaaaaaaaaaaaakpcaabaaa
acaaaaaaegaobaaaacaaaaaaaceaaaaaaaaaaaiaaknhcdlnipmcpflmaaaaaaia
efaaaaajpcaabaaaadaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaa
aaaaaaaadiaaaaahpcaabaaaacaaaaaaegaobaaaacaaaaaafgafbaaaadaaaaaa
dcaaaaajpcaabaaaabaaaaaaegaobaaaabaaaaaaagaabaaaadaaaaaaegaobaaa
acaaaaaaaaaaaaaibcaabaaaacaaaaaaakaabaiaebaaaaaaadaaaaaaabeaaaaa
aaaaiadpaaaaaaaibcaabaaaacaaaaaabkaabaiaebaaaaaaadaaaaaaakaabaaa
acaaaaaadcaaaaajpcaabaaaaaaaaaaaegaobaaaaaaaaaaaagaabaaaacaaaaaa
egaobaaaabaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaa
acaaaaaaaagabaaaadaaaaaadiaaaaahbcaabaaaacaaaaaadkaabaaaabaaaaaa
abeaaaaaaaaaaaebdiaaaaahpcaabaaaabaaaaaaegaobaaaabaaaaaaagaabaaa
acaaaaaadiaaaaahpccabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaaabaaaaaa
doaaaaabejfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
adadaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaaamamaaaaheaaaaaa
acaaaaaaaaaaaaaaadaaaaaaacaaaaaaadadaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
SetTexture 0 [_Control1] 2D
SetTexture 1 [_Vert] 2D
SetTexture 2 [unity_Lightmap] 2D
SetTexture 3 [_Baked] 2D
"ps_2_0
; 18 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c0, -0.00000000, -0.04000854, -0.02999878, 1.00000000
def c1, 1.25000000, 0.00000000, 0.04000854, 8.00000000
dcl t0.xy
dcl t1.xy
dcl t2.xy
texld r1, t0, s2
texld r0, t0, s3
texld r4, t1, s1
texld r3, t2, s1
texld r5, t0, s0
mov r2.w, c0.x
mov r2.xyz, c0
add r2, r3, r2
mul_pp r3, r5.y, r2
mov r2.w, c0.x
mov r2.xyz, c0
add r2, r4, r2
mad_pp r3, r5.x, r2, r3
add_pp r2.x, -r5, c0.w
mov r4.yz, c1.z
mov r4.xw, c1.y
mad r4, r0, c1.x, r4
add_pp r0.x, r2, -r5.y
mad_pp r0, r4, r0.x, r3
mul_pp r1, r1.w, r1
mul_pp r0, r1, r0
mul_pp r0, r0, c1.w
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
SetTexture 0 [_Control1] 2D 0
SetTexture 1 [_Vert] 2D 2
SetTexture 2 [unity_Lightmap] 2D 3
SetTexture 3 [_Baked] 2D 1
// 17 instructions, 4 temp regs, 0 temp arrays:
// ALU 8 float, 0 int, 0 uint
// TEX 5 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedmjbbmfogdenkfaacnigipibageacchdfabaaaaaanmadaaaaadaaaaaa
cmaaaaaaleaaaaaaoiaaaaaaejfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaadadaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklklfdeieefcomacaaaaeaaaaaaallaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaad
aagabaaaadaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaa
abaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafibiaaaeaahabaaa
adaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadmcbabaaaabaaaaaa
gcbaaaaddcbabaaaacaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaa
efaaaaajpcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaaadaaaaaaaagabaaa
abaaaaaadcaaaaappcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaaaaaakadp
aaaakadpaaaakadpaaaakadpaceaaaaaaaaaaaaaaknhcddnaknhcddnaaaaaaaa
efaaaaajpcaabaaaabaaaaaaogbkbaaaabaaaaaaeghobaaaabaaaaaaaagabaaa
acaaaaaaaaaaaaakpcaabaaaabaaaaaaegaobaaaabaaaaaaaceaaaaaaaaaaaia
aknhcdlnipmcpflmaaaaaaiaefaaaaajpcaabaaaacaaaaaaegbabaaaacaaaaaa
eghobaaaabaaaaaaaagabaaaacaaaaaaaaaaaaakpcaabaaaacaaaaaaegaobaaa
acaaaaaaaceaaaaaaaaaaaiaaknhcdlnipmcpflmaaaaaaiaefaaaaajpcaabaaa
adaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadiaaaaah
pcaabaaaacaaaaaaegaobaaaacaaaaaafgafbaaaadaaaaaadcaaaaajpcaabaaa
abaaaaaaegaobaaaabaaaaaaagaabaaaadaaaaaaegaobaaaacaaaaaaaaaaaaai
bcaabaaaacaaaaaaakaabaiaebaaaaaaadaaaaaaabeaaaaaaaaaiadpaaaaaaai
bcaabaaaacaaaaaabkaabaiaebaaaaaaadaaaaaaakaabaaaacaaaaaadcaaaaaj
pcaabaaaaaaaaaaaegaobaaaaaaaaaaaagaabaaaacaaaaaaegaobaaaabaaaaaa
efaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaacaaaaaaaagabaaa
adaaaaaadiaaaaahbcaabaaaacaaaaaadkaabaaaabaaaaaaabeaaaaaaaaaaaeb
diaaaaahpcaabaaaabaaaaaaegaobaaaabaaaaaaagaabaaaacaaaaaadiaaaaah
pccabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
SetTexture 0 [_Control1] 2D
SetTexture 1 [_Vert] 2D
SetTexture 2 [unity_Lightmap] 2D
SetTexture 3 [_Baked] 2D
"ps_2_0
; 18 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c0, -0.00000000, -0.04000854, -0.02999878, 1.00000000
def c1, 1.25000000, 0.00000000, 0.04000854, 8.00000000
dcl t0.xy
dcl t1.xy
dcl t2.xy
texld r1, t0, s2
texld r0, t0, s3
texld r4, t1, s1
texld r3, t2, s1
texld r5, t0, s0
mov r2.w, c0.x
mov r2.xyz, c0
add r2, r3, r2
mul_pp r3, r5.y, r2
mov r2.w, c0.x
mov r2.xyz, c0
add r2, r4, r2
mad_pp r3, r5.x, r2, r3
add_pp r2.x, -r5, c0.w
mov r4.yz, c1.z
mov r4.xw, c1.y
mad r4, r0, c1.x, r4
add_pp r0.x, r2, -r5.y
mad_pp r0, r4, r0.x, r3
mul_pp r1, r1.w, r1
mul_pp r0, r1, r0
mul_pp r0, r0, c1.w
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
SetTexture 0 [_Control1] 2D 0
SetTexture 1 [_Vert] 2D 2
SetTexture 2 [unity_Lightmap] 2D 3
SetTexture 3 [_Baked] 2D 1
// 17 instructions, 4 temp regs, 0 temp arrays:
// ALU 8 float, 0 int, 0 uint
// TEX 5 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedmjbbmfogdenkfaacnigipibageacchdfabaaaaaanmadaaaaadaaaaaa
cmaaaaaaleaaaaaaoiaaaaaaejfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaadadaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklklfdeieefcomacaaaaeaaaaaaallaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaad
aagabaaaadaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaa
abaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafibiaaaeaahabaaa
adaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadmcbabaaaabaaaaaa
gcbaaaaddcbabaaaacaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaa
efaaaaajpcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaaadaaaaaaaagabaaa
abaaaaaadcaaaaappcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaaaaaakadp
aaaakadpaaaakadpaaaakadpaceaaaaaaaaaaaaaaknhcddnaknhcddnaaaaaaaa
efaaaaajpcaabaaaabaaaaaaogbkbaaaabaaaaaaeghobaaaabaaaaaaaagabaaa
acaaaaaaaaaaaaakpcaabaaaabaaaaaaegaobaaaabaaaaaaaceaaaaaaaaaaaia
aknhcdlnipmcpflmaaaaaaiaefaaaaajpcaabaaaacaaaaaaegbabaaaacaaaaaa
eghobaaaabaaaaaaaagabaaaacaaaaaaaaaaaaakpcaabaaaacaaaaaaegaobaaa
acaaaaaaaceaaaaaaaaaaaiaaknhcdlnipmcpflmaaaaaaiaefaaaaajpcaabaaa
adaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadiaaaaah
pcaabaaaacaaaaaaegaobaaaacaaaaaafgafbaaaadaaaaaadcaaaaajpcaabaaa
abaaaaaaegaobaaaabaaaaaaagaabaaaadaaaaaaegaobaaaacaaaaaaaaaaaaai
bcaabaaaacaaaaaaakaabaiaebaaaaaaadaaaaaaabeaaaaaaaaaiadpaaaaaaai
bcaabaaaacaaaaaabkaabaiaebaaaaaaadaaaaaaakaabaaaacaaaaaadcaaaaaj
pcaabaaaaaaaaaaaegaobaaaaaaaaaaaagaabaaaacaaaaaaegaobaaaabaaaaaa
efaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaacaaaaaaaagabaaa
adaaaaaadiaaaaahbcaabaaaacaaaaaadkaabaaaabaaaaaaabeaaaaaaaaaaaeb
diaaaaahpcaabaaaabaaaaaaegaobaaaabaaaaaaagaabaaaacaaaaaadiaaaaah
pccabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
SetTexture 0 [_Control1] 2D
SetTexture 1 [_Vert] 2D
SetTexture 2 [unity_Lightmap] 2D
SetTexture 3 [_Baked] 2D
"ps_2_0
; 18 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c0, -0.00000000, -0.04000854, -0.02999878, 1.00000000
def c1, 1.25000000, 0.00000000, 0.04000854, 8.00000000
dcl t0.xy
dcl t1.xy
dcl t2.xy
texld r1, t0, s2
texld r0, t0, s3
texld r4, t1, s1
texld r3, t2, s1
texld r5, t0, s0
mov r2.w, c0.x
mov r2.xyz, c0
add r2, r3, r2
mul_pp r3, r5.y, r2
mov r2.w, c0.x
mov r2.xyz, c0
add r2, r4, r2
mad_pp r3, r5.x, r2, r3
add_pp r2.x, -r5, c0.w
mov r4.yz, c1.z
mov r4.xw, c1.y
mad r4, r0, c1.x, r4
add_pp r0.x, r2, -r5.y
mad_pp r0, r4, r0.x, r3
mul_pp r1, r1.w, r1
mul_pp r0, r1, r0
mul_pp r0, r0, c1.w
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
SetTexture 0 [_Control1] 2D 0
SetTexture 1 [_Vert] 2D 2
SetTexture 2 [unity_Lightmap] 2D 3
SetTexture 3 [_Baked] 2D 1
// 17 instructions, 4 temp regs, 0 temp arrays:
// ALU 8 float, 0 int, 0 uint
// TEX 5 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedmjbbmfogdenkfaacnigipibageacchdfabaaaaaanmadaaaaadaaaaaa
cmaaaaaaleaaaaaaoiaaaaaaejfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaadadaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklklfdeieefcomacaaaaeaaaaaaallaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaad
aagabaaaadaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaa
abaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafibiaaaeaahabaaa
adaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadmcbabaaaabaaaaaa
gcbaaaaddcbabaaaacaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaa
efaaaaajpcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaaadaaaaaaaagabaaa
abaaaaaadcaaaaappcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaaaaaakadp
aaaakadpaaaakadpaaaakadpaceaaaaaaaaaaaaaaknhcddnaknhcddnaaaaaaaa
efaaaaajpcaabaaaabaaaaaaogbkbaaaabaaaaaaeghobaaaabaaaaaaaagabaaa
acaaaaaaaaaaaaakpcaabaaaabaaaaaaegaobaaaabaaaaaaaceaaaaaaaaaaaia
aknhcdlnipmcpflmaaaaaaiaefaaaaajpcaabaaaacaaaaaaegbabaaaacaaaaaa
eghobaaaabaaaaaaaagabaaaacaaaaaaaaaaaaakpcaabaaaacaaaaaaegaobaaa
acaaaaaaaceaaaaaaaaaaaiaaknhcdlnipmcpflmaaaaaaiaefaaaaajpcaabaaa
adaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadiaaaaah
pcaabaaaacaaaaaaegaobaaaacaaaaaafgafbaaaadaaaaaadcaaaaajpcaabaaa
abaaaaaaegaobaaaabaaaaaaagaabaaaadaaaaaaegaobaaaacaaaaaaaaaaaaai
bcaabaaaacaaaaaaakaabaiaebaaaaaaadaaaaaaabeaaaaaaaaaiadpaaaaaaai
bcaabaaaacaaaaaabkaabaiaebaaaaaaadaaaaaaakaabaaaacaaaaaadcaaaaaj
pcaabaaaaaaaaaaaegaobaaaaaaaaaaaagaabaaaacaaaaaaegaobaaaabaaaaaa
efaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaacaaaaaaaagabaaa
adaaaaaadiaaaaahbcaabaaaacaaaaaadkaabaaaabaaaaaaabeaaaaaaaaaaaeb
diaaaaahpcaabaaaabaaaaaaegaobaaaabaaaaaaagaabaaaacaaaaaadiaaaaah
pccabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
"!!GLES"
}

}

#LINE 121

    
    }
}
Fallback "VertexLit"
} 