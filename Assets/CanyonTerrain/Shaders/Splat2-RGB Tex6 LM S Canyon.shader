Shader "Serj Shaders/Splat2-RGB Tex6 LM S Canyon" {
Properties {
	_Vert ("Vert Main", 2D) = "white" {}
	_VertDetail ("Vert Detail", 2D) = "white" {}
	_Splat1 ("Layer 1", 2D) = "white" {}
	_Splat2 ("Layer 2", 2D) = "white" {}
	_Splat3 ("Layer 3", 2D) = "white" {}
	_Splat4 ("Layer 4", 2D) = "white" {}
	_Flow ("Flow", 2D) = "white" {}
	_FarDetail ("FarDetail", 2D) = "white" {}
	_LM ("LM", 2D) = "white" {}
	_Control1 ("Control 1 (RGB)", 2D) = "white" {}
	_Control2 ("Control 2 (RGB)", 2D) = "white" {}
	_FogColor ("Fog Color / 2 (Do not edit)", Color ) = ( 1.0,1.0,1.0,1.0 )
	//_Control2 ("Control 2 (RGB)", 2D) = "white" {}
	//_BumpMap ("Used For LM only", 2D) = "bump" {}
	//_Tilings ("Tiling Vertical", Vector ) = ( 10, 0.01, 10, 0.01 )
}
SubShader {

	//LOD 400

	Tags{
	    "Queue"="Geometry-2"
	    "IgnoreProjector"="False"
	    "RenderType"="Opaque"
	    }
	//Offset 0, 0    
    Pass {
    //Fog {Mode Off}
    //Fog { Color ( 0.384,0.433,0.480 ) }
    Fog { Color [_FogColor] }
    Lighting Off
    Tags {"LightMode" = "ForwardBase"}
    
   	Program "vp" {
// Vertex combos: 8
//   d3d9 - ALU: 16 to 16
//   d3d11 - ALU: 9 to 9, TEX: 0 to 0, FLOW: 1 to 1
//   d3d11_9x - ALU: 9 to 9, TEX: 0 to 0, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLSL
#ifdef VERTEX
varying vec2 xlv_TEXCOORD6;
varying vec2 xlv_TEXCOORD5;
varying vec2 xlv_TEXCOORD4;
varying vec2 xlv_TEXCOORD3;
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
  xlv_TEXCOORD3 = (tmpvar_1 * 25.0000);
  xlv_TEXCOORD4 = (tmpvar_2 * 25.0000);
  xlv_TEXCOORD5 = (gl_MultiTexCoord0.xy * 10.0000);
  xlv_TEXCOORD6 = (gl_MultiTexCoord0.xy * 200.000);
}


#endif
#ifdef FRAGMENT
varying vec2 xlv_TEXCOORD6;
varying vec2 xlv_TEXCOORD5;
varying vec2 xlv_TEXCOORD4;
varying vec2 xlv_TEXCOORD3;
varying vec2 xlv_TEXCOORD2;
varying vec2 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _VertDetail;
uniform sampler2D _Vert;
uniform sampler2D _Splat1;
uniform sampler2D _FarDetail;
uniform sampler2D _Control1;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control1, xlv_TEXCOORD0);
  gl_FragData[0] = ((((texture2D (_Vert, xlv_TEXCOORD1) * (texture2D (_VertDetail, xlv_TEXCOORD3) + 0.400000)) * tmpvar_1.x) + ((texture2D (_Vert, xlv_TEXCOORD2) * (texture2D (_VertDetail, xlv_TEXCOORD4) + 0.400000)) * tmpvar_1.y)) + (((texture2D (_FarDetail, xlv_TEXCOORD5) + 0.500000) * texture2D (_Splat1, xlv_TEXCOORD6)) * tmpvar_1.z));
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
; 16 ALU
def c4, 0.00400000, 10.00000000, 25.00000000, 200.00000000
dcl_position0 v0
dcl_texcoord0 v1
mul r1.xy, v1, c4.y
mul r0.w, v0.y, c4.x
mul r0.z, v1.y, c4.y
mov r0.x, r1
mov r0.y, r0.w
mov oT0.xy, v1
mov oT1.xy, r0
mov oT2.xy, r0.zwzw
mul oT3.xy, r0, c4.z
mul oT4.xy, r0.zwzw, c4.z
mov oT5.xy, r1
mul oT6.xy, v1, c4.w
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "UnityPerDraw" 336 // 64 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
BindCB "UnityPerDraw" 0
// 15 instructions, 1 temp regs, 0 temp arrays:
// ALU 9 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedgadoncfkmilhkpnigihajhhmholdnibgabaaaaaaomadaaaaadaaaaaa
cmaaaaaaiaaaaaaagiabaaaaejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklkl
epfdeheooaaaaaaaaiaaaaaaaiaaaaaamiaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaaneaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
neaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaaamadaaaaneaaaaaaacaaaaaa
aaaaaaaaadaaaaaaacaaaaaaadamaaaaneaaaaaaadaaaaaaaaaaaaaaadaaaaaa
acaaaaaaamadaaaaneaaaaaaaeaaaaaaaaaaaaaaadaaaaaaadaaaaaaadamaaaa
neaaaaaaafaaaaaaaaaaaaaaadaaaaaaadaaaaaaamadaaaaneaaaaaaagaaaaaa
aaaaaaaaadaaaaaaaeaaaaaaadamaaaafdfgfpfaepfdejfeejepeoaafeeffied
epepfceeaaklklklfdeieefchmacaaaaeaaaabaajpaaaaaafjaaaaaeegiocaaa
aaaaaaaaaeaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaabaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaad
mccabaaaabaaaaaagfaaaaaddccabaaaacaaaaaagfaaaaadmccabaaaacaaaaaa
gfaaaaaddccabaaaadaaaaaagfaaaaadmccabaaaadaaaaaagfaaaaaddccabaaa
aeaaaaaagiaaaaacabaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiocaaaaaaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaa
aaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaaaaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pccabaaaaaaaaaaaegiocaaaaaaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaa
aaaaaaaadiaaaaakhccabaaaabaaaaaaegbabaaaabaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaacaebaaaaaaaadiaaaaahiccabaaaabaaaaaabkbabaaaaaaaaaaa
abeaaaaagpbciddldgaaaaaffcaabaaaaaaaaaaafgbebaaaabaaaaaadgaaaaaf
kcaabaaaaaaaaaaafgbfbaaaaaaaaaaadiaaaaakmccabaaaacaaaaaakgaobaaa
aaaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaahkedmnmmmmdndiaaaaahbccabaaa
acaaaaaabkbabaaaabaaaaaaabeaaaaaaaaacaebdiaaaaahcccabaaaacaaaaaa
bkbabaaaaaaaaaaaabeaaaaagpbciddldiaaaaakdccabaaaadaaaaaaegaabaaa
aaaaaaaaaceaaaaaaaaahkedmnmmmmdnaaaaaaaaaaaaaaaadiaaaaakmccabaaa
adaaaaaaagbebaaaabaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaacaebaaaacaeb
diaaaaakdccabaaaaeaaaaaaegbabaaaabaaaaaaaceaaaaaaaaaeiedaaaaeied
aaaaaaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD5;
varying highp vec2 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
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
  xlv_TEXCOORD3 = (tmpvar_1 * 25.0000);
  xlv_TEXCOORD4 = (tmpvar_2 * 25.0000);
  xlv_TEXCOORD5 = (_glesMultiTexCoord0.xy * 10.0000);
  xlv_TEXCOORD6 = (_glesMultiTexCoord0.xy * 200.000);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD5;
varying highp vec2 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _VertDetail;
uniform sampler2D _Vert;
uniform sampler2D _Splat1;
uniform sampler2D _FarDetail;
uniform sampler2D _Control1;
void main ()
{
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control1, xlv_TEXCOORD0);
  gl_FragData[0] = ((((texture2D (_Vert, xlv_TEXCOORD1) * (texture2D (_VertDetail, xlv_TEXCOORD3) + 0.400000)) * tmpvar_1.x) + ((texture2D (_Vert, xlv_TEXCOORD2) * (texture2D (_VertDetail, xlv_TEXCOORD4) + 0.400000)) * tmpvar_1.y)) + (((texture2D (_FarDetail, xlv_TEXCOORD5) + 0.500000) * texture2D (_Splat1, xlv_TEXCOORD6)) * tmpvar_1.z));
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

varying highp vec2 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD5;
varying highp vec2 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
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
  xlv_TEXCOORD3 = (tmpvar_1 * 25.0000);
  xlv_TEXCOORD4 = (tmpvar_2 * 25.0000);
  xlv_TEXCOORD5 = (_glesMultiTexCoord0.xy * 10.0000);
  xlv_TEXCOORD6 = (_glesMultiTexCoord0.xy * 200.000);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD5;
varying highp vec2 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _VertDetail;
uniform sampler2D _Vert;
uniform sampler2D _Splat1;
uniform sampler2D _FarDetail;
uniform sampler2D _Control1;
void main ()
{
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control1, xlv_TEXCOORD0);
  gl_FragData[0] = ((((texture2D (_Vert, xlv_TEXCOORD1) * (texture2D (_VertDetail, xlv_TEXCOORD3) + 0.400000)) * tmpvar_1.x) + ((texture2D (_Vert, xlv_TEXCOORD2) * (texture2D (_VertDetail, xlv_TEXCOORD4) + 0.400000)) * tmpvar_1.y)) + (((texture2D (_FarDetail, xlv_TEXCOORD5) + 0.500000) * texture2D (_Splat1, xlv_TEXCOORD6)) * tmpvar_1.z));
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
// 15 instructions, 1 temp regs, 0 temp arrays:
// ALU 9 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_3
eefiecedhcddhmbbnnnkhjdeenbbkligioloncppabaaaaaaiaafaaaaaeaaaaaa
daaaaaaamaabaaaaeeaeaaaajiaeaaaaebgpgodjiiabaaaaiiabaaaaaaacpopp
feabaaaadeaaaaaaabaaceaaaaaadaaaaaaadaaaaaaaceaaabaadaaaaaaaaaaa
aeaaabaaaaaaaaaaaaaaaaaaabacpoppfbaaaaafafaaapkamnmmmmdnaaaahked
aaaaeiedgpbciddlfbaaaaafagaaapkaaaaaiadpaaaacaebaaaaaaaaaaaaaaaa
bpaaaaacafaaaaiaaaaaapjabpaaaaacafaaabiaabaaapjaabaaaaacaaaaajia
abaacfjaabaaaaacaaaaagiaaaaaffjaafaaaaadabaaamoaaaaaoeiaafaaeeka
afaaaaadacaaadoaaaaaoeiaafaaobkaafaaaaadadaaadoaabaaoejaafaakkka
afaaaaadaaaaapiaaaaaffjaacaaoekaaeaaaaaeaaaaapiaabaaoekaaaaaaaja
aaaaoeiaaeaaaaaeaaaaapiaadaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaapia
aeaaoekaaaaappjaaaaaoeiaaeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeia
abaaaaacaaaaammaaaaaoeiaafaaaaadaaaaaloaabaacejaagaagakaafaaaaad
aaaaaeoaaaaaffjaafaappkaafaaaaadabaaaboaabaaffjaagaaffkaafaaaaad
abaaacoaaaaaffjaafaappkaafaaaaadacaaamoaabaabejaagaaffkappppaaaa
fdeieefchmacaaaaeaaaabaajpaaaaaafjaaaaaeegiocaaaaaaaaaaaaeaaaaaa
fpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaabaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadmccabaaaabaaaaaa
gfaaaaaddccabaaaacaaaaaagfaaaaadmccabaaaacaaaaaagfaaaaaddccabaaa
adaaaaaagfaaaaadmccabaaaadaaaaaagfaaaaaddccabaaaaeaaaaaagiaaaaac
abaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaaaaaaaaa
abaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaaaaaaaaaagbabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaa
acaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaa
egiocaaaaaaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaak
hccabaaaabaaaaaaegbabaaaabaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaacaeb
aaaaaaaadiaaaaahiccabaaaabaaaaaabkbabaaaaaaaaaaaabeaaaaagpbciddl
dgaaaaaffcaabaaaaaaaaaaafgbebaaaabaaaaaadgaaaaafkcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaadiaaaaakmccabaaaacaaaaaakgaobaaaaaaaaaaaaceaaaaa
aaaaaaaaaaaaaaaaaaaahkedmnmmmmdndiaaaaahbccabaaaacaaaaaabkbabaaa
abaaaaaaabeaaaaaaaaacaebdiaaaaahcccabaaaacaaaaaabkbabaaaaaaaaaaa
abeaaaaagpbciddldiaaaaakdccabaaaadaaaaaaegaabaaaaaaaaaaaaceaaaaa
aaaahkedmnmmmmdnaaaaaaaaaaaaaaaadiaaaaakmccabaaaadaaaaaaagbebaaa
abaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaacaebaaaacaebdiaaaaakdccabaaa
aeaaaaaaegbabaaaabaaaaaaaceaaaaaaaaaeiedaaaaeiedaaaaaaaaaaaaaaaa
doaaaaabejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
adadaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklklepfdeheooaaaaaaa
aiaaaaaaaiaaaaaamiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaa
neaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaaneaaaaaaabaaaaaa
aaaaaaaaadaaaaaaabaaaaaaamadaaaaneaaaaaaacaaaaaaaaaaaaaaadaaaaaa
acaaaaaaadamaaaaneaaaaaaadaaaaaaaaaaaaaaadaaaaaaacaaaaaaamadaaaa
neaaaaaaaeaaaaaaaaaaaaaaadaaaaaaadaaaaaaadamaaaaneaaaaaaafaaaaaa
aaaaaaaaadaaaaaaadaaaaaaamadaaaaneaaaaaaagaaaaaaaaaaaaaaadaaaaaa
aeaaaaaaadamaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklkl
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLSL
#ifdef VERTEX
varying vec2 xlv_TEXCOORD6;
varying vec2 xlv_TEXCOORD5;
varying vec2 xlv_TEXCOORD4;
varying vec2 xlv_TEXCOORD3;
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
  xlv_TEXCOORD3 = (tmpvar_1 * 25.0000);
  xlv_TEXCOORD4 = (tmpvar_2 * 25.0000);
  xlv_TEXCOORD5 = (gl_MultiTexCoord0.xy * 10.0000);
  xlv_TEXCOORD6 = (gl_MultiTexCoord0.xy * 200.000);
}


#endif
#ifdef FRAGMENT
varying vec2 xlv_TEXCOORD6;
varying vec2 xlv_TEXCOORD5;
varying vec2 xlv_TEXCOORD4;
varying vec2 xlv_TEXCOORD3;
varying vec2 xlv_TEXCOORD2;
varying vec2 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _VertDetail;
uniform sampler2D _Vert;
uniform sampler2D _Splat1;
uniform sampler2D _FarDetail;
uniform sampler2D _Control1;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control1, xlv_TEXCOORD0);
  gl_FragData[0] = ((((texture2D (_Vert, xlv_TEXCOORD1) * (texture2D (_VertDetail, xlv_TEXCOORD3) + 0.400000)) * tmpvar_1.x) + ((texture2D (_Vert, xlv_TEXCOORD2) * (texture2D (_VertDetail, xlv_TEXCOORD4) + 0.400000)) * tmpvar_1.y)) + (((texture2D (_FarDetail, xlv_TEXCOORD5) + 0.500000) * texture2D (_Splat1, xlv_TEXCOORD6)) * tmpvar_1.z));
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
; 16 ALU
def c4, 0.00400000, 10.00000000, 25.00000000, 200.00000000
dcl_position0 v0
dcl_texcoord0 v1
mul r1.xy, v1, c4.y
mul r0.w, v0.y, c4.x
mul r0.z, v1.y, c4.y
mov r0.x, r1
mov r0.y, r0.w
mov oT0.xy, v1
mov oT1.xy, r0
mov oT2.xy, r0.zwzw
mul oT3.xy, r0, c4.z
mul oT4.xy, r0.zwzw, c4.z
mov oT5.xy, r1
mul oT6.xy, v1, c4.w
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "UnityPerDraw" 336 // 64 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
BindCB "UnityPerDraw" 0
// 15 instructions, 1 temp regs, 0 temp arrays:
// ALU 9 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedgadoncfkmilhkpnigihajhhmholdnibgabaaaaaaomadaaaaadaaaaaa
cmaaaaaaiaaaaaaagiabaaaaejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklkl
epfdeheooaaaaaaaaiaaaaaaaiaaaaaamiaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaaneaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
neaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaaamadaaaaneaaaaaaacaaaaaa
aaaaaaaaadaaaaaaacaaaaaaadamaaaaneaaaaaaadaaaaaaaaaaaaaaadaaaaaa
acaaaaaaamadaaaaneaaaaaaaeaaaaaaaaaaaaaaadaaaaaaadaaaaaaadamaaaa
neaaaaaaafaaaaaaaaaaaaaaadaaaaaaadaaaaaaamadaaaaneaaaaaaagaaaaaa
aaaaaaaaadaaaaaaaeaaaaaaadamaaaafdfgfpfaepfdejfeejepeoaafeeffied
epepfceeaaklklklfdeieefchmacaaaaeaaaabaajpaaaaaafjaaaaaeegiocaaa
aaaaaaaaaeaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaabaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaad
mccabaaaabaaaaaagfaaaaaddccabaaaacaaaaaagfaaaaadmccabaaaacaaaaaa
gfaaaaaddccabaaaadaaaaaagfaaaaadmccabaaaadaaaaaagfaaaaaddccabaaa
aeaaaaaagiaaaaacabaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiocaaaaaaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaa
aaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaaaaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pccabaaaaaaaaaaaegiocaaaaaaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaa
aaaaaaaadiaaaaakhccabaaaabaaaaaaegbabaaaabaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaacaebaaaaaaaadiaaaaahiccabaaaabaaaaaabkbabaaaaaaaaaaa
abeaaaaagpbciddldgaaaaaffcaabaaaaaaaaaaafgbebaaaabaaaaaadgaaaaaf
kcaabaaaaaaaaaaafgbfbaaaaaaaaaaadiaaaaakmccabaaaacaaaaaakgaobaaa
aaaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaahkedmnmmmmdndiaaaaahbccabaaa
acaaaaaabkbabaaaabaaaaaaabeaaaaaaaaacaebdiaaaaahcccabaaaacaaaaaa
bkbabaaaaaaaaaaaabeaaaaagpbciddldiaaaaakdccabaaaadaaaaaaegaabaaa
aaaaaaaaaceaaaaaaaaahkedmnmmmmdnaaaaaaaaaaaaaaaadiaaaaakmccabaaa
adaaaaaaagbebaaaabaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaacaebaaaacaeb
diaaaaakdccabaaaaeaaaaaaegbabaaaabaaaaaaaceaaaaaaaaaeiedaaaaeied
aaaaaaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD5;
varying highp vec2 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
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
  xlv_TEXCOORD3 = (tmpvar_1 * 25.0000);
  xlv_TEXCOORD4 = (tmpvar_2 * 25.0000);
  xlv_TEXCOORD5 = (_glesMultiTexCoord0.xy * 10.0000);
  xlv_TEXCOORD6 = (_glesMultiTexCoord0.xy * 200.000);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD5;
varying highp vec2 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _VertDetail;
uniform sampler2D _Vert;
uniform sampler2D _Splat1;
uniform sampler2D _FarDetail;
uniform sampler2D _Control1;
void main ()
{
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control1, xlv_TEXCOORD0);
  gl_FragData[0] = ((((texture2D (_Vert, xlv_TEXCOORD1) * (texture2D (_VertDetail, xlv_TEXCOORD3) + 0.400000)) * tmpvar_1.x) + ((texture2D (_Vert, xlv_TEXCOORD2) * (texture2D (_VertDetail, xlv_TEXCOORD4) + 0.400000)) * tmpvar_1.y)) + (((texture2D (_FarDetail, xlv_TEXCOORD5) + 0.500000) * texture2D (_Splat1, xlv_TEXCOORD6)) * tmpvar_1.z));
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

varying highp vec2 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD5;
varying highp vec2 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
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
  xlv_TEXCOORD3 = (tmpvar_1 * 25.0000);
  xlv_TEXCOORD4 = (tmpvar_2 * 25.0000);
  xlv_TEXCOORD5 = (_glesMultiTexCoord0.xy * 10.0000);
  xlv_TEXCOORD6 = (_glesMultiTexCoord0.xy * 200.000);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD5;
varying highp vec2 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _VertDetail;
uniform sampler2D _Vert;
uniform sampler2D _Splat1;
uniform sampler2D _FarDetail;
uniform sampler2D _Control1;
void main ()
{
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control1, xlv_TEXCOORD0);
  gl_FragData[0] = ((((texture2D (_Vert, xlv_TEXCOORD1) * (texture2D (_VertDetail, xlv_TEXCOORD3) + 0.400000)) * tmpvar_1.x) + ((texture2D (_Vert, xlv_TEXCOORD2) * (texture2D (_VertDetail, xlv_TEXCOORD4) + 0.400000)) * tmpvar_1.y)) + (((texture2D (_FarDetail, xlv_TEXCOORD5) + 0.500000) * texture2D (_Splat1, xlv_TEXCOORD6)) * tmpvar_1.z));
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
// 15 instructions, 1 temp regs, 0 temp arrays:
// ALU 9 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_3
eefiecedhcddhmbbnnnkhjdeenbbkligioloncppabaaaaaaiaafaaaaaeaaaaaa
daaaaaaamaabaaaaeeaeaaaajiaeaaaaebgpgodjiiabaaaaiiabaaaaaaacpopp
feabaaaadeaaaaaaabaaceaaaaaadaaaaaaadaaaaaaaceaaabaadaaaaaaaaaaa
aeaaabaaaaaaaaaaaaaaaaaaabacpoppfbaaaaafafaaapkamnmmmmdnaaaahked
aaaaeiedgpbciddlfbaaaaafagaaapkaaaaaiadpaaaacaebaaaaaaaaaaaaaaaa
bpaaaaacafaaaaiaaaaaapjabpaaaaacafaaabiaabaaapjaabaaaaacaaaaajia
abaacfjaabaaaaacaaaaagiaaaaaffjaafaaaaadabaaamoaaaaaoeiaafaaeeka
afaaaaadacaaadoaaaaaoeiaafaaobkaafaaaaadadaaadoaabaaoejaafaakkka
afaaaaadaaaaapiaaaaaffjaacaaoekaaeaaaaaeaaaaapiaabaaoekaaaaaaaja
aaaaoeiaaeaaaaaeaaaaapiaadaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaapia
aeaaoekaaaaappjaaaaaoeiaaeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeia
abaaaaacaaaaammaaaaaoeiaafaaaaadaaaaaloaabaacejaagaagakaafaaaaad
aaaaaeoaaaaaffjaafaappkaafaaaaadabaaaboaabaaffjaagaaffkaafaaaaad
abaaacoaaaaaffjaafaappkaafaaaaadacaaamoaabaabejaagaaffkappppaaaa
fdeieefchmacaaaaeaaaabaajpaaaaaafjaaaaaeegiocaaaaaaaaaaaaeaaaaaa
fpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaabaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadmccabaaaabaaaaaa
gfaaaaaddccabaaaacaaaaaagfaaaaadmccabaaaacaaaaaagfaaaaaddccabaaa
adaaaaaagfaaaaadmccabaaaadaaaaaagfaaaaaddccabaaaaeaaaaaagiaaaaac
abaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaaaaaaaaa
abaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaaaaaaaaaagbabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaa
acaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaa
egiocaaaaaaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaak
hccabaaaabaaaaaaegbabaaaabaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaacaeb
aaaaaaaadiaaaaahiccabaaaabaaaaaabkbabaaaaaaaaaaaabeaaaaagpbciddl
dgaaaaaffcaabaaaaaaaaaaafgbebaaaabaaaaaadgaaaaafkcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaadiaaaaakmccabaaaacaaaaaakgaobaaaaaaaaaaaaceaaaaa
aaaaaaaaaaaaaaaaaaaahkedmnmmmmdndiaaaaahbccabaaaacaaaaaabkbabaaa
abaaaaaaabeaaaaaaaaacaebdiaaaaahcccabaaaacaaaaaabkbabaaaaaaaaaaa
abeaaaaagpbciddldiaaaaakdccabaaaadaaaaaaegaabaaaaaaaaaaaaceaaaaa
aaaahkedmnmmmmdnaaaaaaaaaaaaaaaadiaaaaakmccabaaaadaaaaaaagbebaaa
abaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaacaebaaaacaebdiaaaaakdccabaaa
aeaaaaaaegbabaaaabaaaaaaaceaaaaaaaaaeiedaaaaeiedaaaaaaaaaaaaaaaa
doaaaaabejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
adadaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklklepfdeheooaaaaaaa
aiaaaaaaaiaaaaaamiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaa
neaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaaneaaaaaaabaaaaaa
aaaaaaaaadaaaaaaabaaaaaaamadaaaaneaaaaaaacaaaaaaaaaaaaaaadaaaaaa
acaaaaaaadamaaaaneaaaaaaadaaaaaaaaaaaaaaadaaaaaaacaaaaaaamadaaaa
neaaaaaaaeaaaaaaaaaaaaaaadaaaaaaadaaaaaaadamaaaaneaaaaaaafaaaaaa
aaaaaaaaadaaaaaaadaaaaaaamadaaaaneaaaaaaagaaaaaaaaaaaaaaadaaaaaa
aeaaaaaaadamaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklkl
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
"!!GLSL
#ifdef VERTEX
varying vec2 xlv_TEXCOORD6;
varying vec2 xlv_TEXCOORD5;
varying vec2 xlv_TEXCOORD4;
varying vec2 xlv_TEXCOORD3;
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
  xlv_TEXCOORD3 = (tmpvar_1 * 25.0000);
  xlv_TEXCOORD4 = (tmpvar_2 * 25.0000);
  xlv_TEXCOORD5 = (gl_MultiTexCoord0.xy * 10.0000);
  xlv_TEXCOORD6 = (gl_MultiTexCoord0.xy * 200.000);
}


#endif
#ifdef FRAGMENT
varying vec2 xlv_TEXCOORD6;
varying vec2 xlv_TEXCOORD5;
varying vec2 xlv_TEXCOORD4;
varying vec2 xlv_TEXCOORD3;
varying vec2 xlv_TEXCOORD2;
varying vec2 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _VertDetail;
uniform sampler2D _Vert;
uniform sampler2D _Splat1;
uniform sampler2D _FarDetail;
uniform sampler2D _Control1;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control1, xlv_TEXCOORD0);
  gl_FragData[0] = ((((texture2D (_Vert, xlv_TEXCOORD1) * (texture2D (_VertDetail, xlv_TEXCOORD3) + 0.400000)) * tmpvar_1.x) + ((texture2D (_Vert, xlv_TEXCOORD2) * (texture2D (_VertDetail, xlv_TEXCOORD4) + 0.400000)) * tmpvar_1.y)) + (((texture2D (_FarDetail, xlv_TEXCOORD5) + 0.500000) * texture2D (_Splat1, xlv_TEXCOORD6)) * tmpvar_1.z));
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
; 16 ALU
def c4, 0.00400000, 10.00000000, 25.00000000, 200.00000000
dcl_position0 v0
dcl_texcoord0 v1
mul r1.xy, v1, c4.y
mul r0.w, v0.y, c4.x
mul r0.z, v1.y, c4.y
mov r0.x, r1
mov r0.y, r0.w
mov oT0.xy, v1
mov oT1.xy, r0
mov oT2.xy, r0.zwzw
mul oT3.xy, r0, c4.z
mul oT4.xy, r0.zwzw, c4.z
mov oT5.xy, r1
mul oT6.xy, v1, c4.w
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "UnityPerDraw" 336 // 64 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
BindCB "UnityPerDraw" 0
// 15 instructions, 1 temp regs, 0 temp arrays:
// ALU 9 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedgadoncfkmilhkpnigihajhhmholdnibgabaaaaaaomadaaaaadaaaaaa
cmaaaaaaiaaaaaaagiabaaaaejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklkl
epfdeheooaaaaaaaaiaaaaaaaiaaaaaamiaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaaneaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
neaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaaamadaaaaneaaaaaaacaaaaaa
aaaaaaaaadaaaaaaacaaaaaaadamaaaaneaaaaaaadaaaaaaaaaaaaaaadaaaaaa
acaaaaaaamadaaaaneaaaaaaaeaaaaaaaaaaaaaaadaaaaaaadaaaaaaadamaaaa
neaaaaaaafaaaaaaaaaaaaaaadaaaaaaadaaaaaaamadaaaaneaaaaaaagaaaaaa
aaaaaaaaadaaaaaaaeaaaaaaadamaaaafdfgfpfaepfdejfeejepeoaafeeffied
epepfceeaaklklklfdeieefchmacaaaaeaaaabaajpaaaaaafjaaaaaeegiocaaa
aaaaaaaaaeaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaabaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaad
mccabaaaabaaaaaagfaaaaaddccabaaaacaaaaaagfaaaaadmccabaaaacaaaaaa
gfaaaaaddccabaaaadaaaaaagfaaaaadmccabaaaadaaaaaagfaaaaaddccabaaa
aeaaaaaagiaaaaacabaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiocaaaaaaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaa
aaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaaaaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pccabaaaaaaaaaaaegiocaaaaaaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaa
aaaaaaaadiaaaaakhccabaaaabaaaaaaegbabaaaabaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaacaebaaaaaaaadiaaaaahiccabaaaabaaaaaabkbabaaaaaaaaaaa
abeaaaaagpbciddldgaaaaaffcaabaaaaaaaaaaafgbebaaaabaaaaaadgaaaaaf
kcaabaaaaaaaaaaafgbfbaaaaaaaaaaadiaaaaakmccabaaaacaaaaaakgaobaaa
aaaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaahkedmnmmmmdndiaaaaahbccabaaa
acaaaaaabkbabaaaabaaaaaaabeaaaaaaaaacaebdiaaaaahcccabaaaacaaaaaa
bkbabaaaaaaaaaaaabeaaaaagpbciddldiaaaaakdccabaaaadaaaaaaegaabaaa
aaaaaaaaaceaaaaaaaaahkedmnmmmmdnaaaaaaaaaaaaaaaadiaaaaakmccabaaa
adaaaaaaagbebaaaabaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaacaebaaaacaeb
diaaaaakdccabaaaaeaaaaaaegbabaaaabaaaaaaaceaaaaaaaaaeiedaaaaeied
aaaaaaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD5;
varying highp vec2 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
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
  xlv_TEXCOORD3 = (tmpvar_1 * 25.0000);
  xlv_TEXCOORD4 = (tmpvar_2 * 25.0000);
  xlv_TEXCOORD5 = (_glesMultiTexCoord0.xy * 10.0000);
  xlv_TEXCOORD6 = (_glesMultiTexCoord0.xy * 200.000);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD5;
varying highp vec2 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _VertDetail;
uniform sampler2D _Vert;
uniform sampler2D _Splat1;
uniform sampler2D _FarDetail;
uniform sampler2D _Control1;
void main ()
{
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control1, xlv_TEXCOORD0);
  gl_FragData[0] = ((((texture2D (_Vert, xlv_TEXCOORD1) * (texture2D (_VertDetail, xlv_TEXCOORD3) + 0.400000)) * tmpvar_1.x) + ((texture2D (_Vert, xlv_TEXCOORD2) * (texture2D (_VertDetail, xlv_TEXCOORD4) + 0.400000)) * tmpvar_1.y)) + (((texture2D (_FarDetail, xlv_TEXCOORD5) + 0.500000) * texture2D (_Splat1, xlv_TEXCOORD6)) * tmpvar_1.z));
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

varying highp vec2 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD5;
varying highp vec2 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
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
  xlv_TEXCOORD3 = (tmpvar_1 * 25.0000);
  xlv_TEXCOORD4 = (tmpvar_2 * 25.0000);
  xlv_TEXCOORD5 = (_glesMultiTexCoord0.xy * 10.0000);
  xlv_TEXCOORD6 = (_glesMultiTexCoord0.xy * 200.000);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD5;
varying highp vec2 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _VertDetail;
uniform sampler2D _Vert;
uniform sampler2D _Splat1;
uniform sampler2D _FarDetail;
uniform sampler2D _Control1;
void main ()
{
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control1, xlv_TEXCOORD0);
  gl_FragData[0] = ((((texture2D (_Vert, xlv_TEXCOORD1) * (texture2D (_VertDetail, xlv_TEXCOORD3) + 0.400000)) * tmpvar_1.x) + ((texture2D (_Vert, xlv_TEXCOORD2) * (texture2D (_VertDetail, xlv_TEXCOORD4) + 0.400000)) * tmpvar_1.y)) + (((texture2D (_FarDetail, xlv_TEXCOORD5) + 0.500000) * texture2D (_Splat1, xlv_TEXCOORD6)) * tmpvar_1.z));
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
// 15 instructions, 1 temp regs, 0 temp arrays:
// ALU 9 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_3
eefiecedhcddhmbbnnnkhjdeenbbkligioloncppabaaaaaaiaafaaaaaeaaaaaa
daaaaaaamaabaaaaeeaeaaaajiaeaaaaebgpgodjiiabaaaaiiabaaaaaaacpopp
feabaaaadeaaaaaaabaaceaaaaaadaaaaaaadaaaaaaaceaaabaadaaaaaaaaaaa
aeaaabaaaaaaaaaaaaaaaaaaabacpoppfbaaaaafafaaapkamnmmmmdnaaaahked
aaaaeiedgpbciddlfbaaaaafagaaapkaaaaaiadpaaaacaebaaaaaaaaaaaaaaaa
bpaaaaacafaaaaiaaaaaapjabpaaaaacafaaabiaabaaapjaabaaaaacaaaaajia
abaacfjaabaaaaacaaaaagiaaaaaffjaafaaaaadabaaamoaaaaaoeiaafaaeeka
afaaaaadacaaadoaaaaaoeiaafaaobkaafaaaaadadaaadoaabaaoejaafaakkka
afaaaaadaaaaapiaaaaaffjaacaaoekaaeaaaaaeaaaaapiaabaaoekaaaaaaaja
aaaaoeiaaeaaaaaeaaaaapiaadaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaapia
aeaaoekaaaaappjaaaaaoeiaaeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeia
abaaaaacaaaaammaaaaaoeiaafaaaaadaaaaaloaabaacejaagaagakaafaaaaad
aaaaaeoaaaaaffjaafaappkaafaaaaadabaaaboaabaaffjaagaaffkaafaaaaad
abaaacoaaaaaffjaafaappkaafaaaaadacaaamoaabaabejaagaaffkappppaaaa
fdeieefchmacaaaaeaaaabaajpaaaaaafjaaaaaeegiocaaaaaaaaaaaaeaaaaaa
fpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaabaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadmccabaaaabaaaaaa
gfaaaaaddccabaaaacaaaaaagfaaaaadmccabaaaacaaaaaagfaaaaaddccabaaa
adaaaaaagfaaaaadmccabaaaadaaaaaagfaaaaaddccabaaaaeaaaaaagiaaaaac
abaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaaaaaaaaa
abaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaaaaaaaaaagbabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaa
acaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaa
egiocaaaaaaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaak
hccabaaaabaaaaaaegbabaaaabaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaacaeb
aaaaaaaadiaaaaahiccabaaaabaaaaaabkbabaaaaaaaaaaaabeaaaaagpbciddl
dgaaaaaffcaabaaaaaaaaaaafgbebaaaabaaaaaadgaaaaafkcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaadiaaaaakmccabaaaacaaaaaakgaobaaaaaaaaaaaaceaaaaa
aaaaaaaaaaaaaaaaaaaahkedmnmmmmdndiaaaaahbccabaaaacaaaaaabkbabaaa
abaaaaaaabeaaaaaaaaacaebdiaaaaahcccabaaaacaaaaaabkbabaaaaaaaaaaa
abeaaaaagpbciddldiaaaaakdccabaaaadaaaaaaegaabaaaaaaaaaaaaceaaaaa
aaaahkedmnmmmmdnaaaaaaaaaaaaaaaadiaaaaakmccabaaaadaaaaaaagbebaaa
abaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaacaebaaaacaebdiaaaaakdccabaaa
aeaaaaaaegbabaaaabaaaaaaaceaaaaaaaaaeiedaaaaeiedaaaaaaaaaaaaaaaa
doaaaaabejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
adadaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklklepfdeheooaaaaaaa
aiaaaaaaaiaaaaaamiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaa
neaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaaneaaaaaaabaaaaaa
aaaaaaaaadaaaaaaabaaaaaaamadaaaaneaaaaaaacaaaaaaaaaaaaaaadaaaaaa
acaaaaaaadamaaaaneaaaaaaadaaaaaaaaaaaaaaadaaaaaaacaaaaaaamadaaaa
neaaaaaaaeaaaaaaaaaaaaaaadaaaaaaadaaaaaaadamaaaaneaaaaaaafaaaaaa
aaaaaaaaadaaaaaaadaaaaaaamadaaaaneaaaaaaagaaaaaaaaaaaaaaadaaaaaa
aeaaaaaaadamaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklkl
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLSL
#ifdef VERTEX
varying vec2 xlv_TEXCOORD6;
varying vec2 xlv_TEXCOORD5;
varying vec2 xlv_TEXCOORD4;
varying vec2 xlv_TEXCOORD3;
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
  xlv_TEXCOORD3 = (tmpvar_1 * 25.0000);
  xlv_TEXCOORD4 = (tmpvar_2 * 25.0000);
  xlv_TEXCOORD5 = (gl_MultiTexCoord0.xy * 10.0000);
  xlv_TEXCOORD6 = (gl_MultiTexCoord0.xy * 200.000);
}


#endif
#ifdef FRAGMENT
varying vec2 xlv_TEXCOORD6;
varying vec2 xlv_TEXCOORD5;
varying vec2 xlv_TEXCOORD4;
varying vec2 xlv_TEXCOORD3;
varying vec2 xlv_TEXCOORD2;
varying vec2 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _VertDetail;
uniform sampler2D _Vert;
uniform sampler2D _Splat1;
uniform sampler2D _FarDetail;
uniform sampler2D _Control1;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control1, xlv_TEXCOORD0);
  gl_FragData[0] = ((((texture2D (_Vert, xlv_TEXCOORD1) * (texture2D (_VertDetail, xlv_TEXCOORD3) + 0.400000)) * tmpvar_1.x) + ((texture2D (_Vert, xlv_TEXCOORD2) * (texture2D (_VertDetail, xlv_TEXCOORD4) + 0.400000)) * tmpvar_1.y)) + (((texture2D (_FarDetail, xlv_TEXCOORD5) + 0.500000) * texture2D (_Splat1, xlv_TEXCOORD6)) * tmpvar_1.z));
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
; 16 ALU
def c4, 0.00400000, 10.00000000, 25.00000000, 200.00000000
dcl_position0 v0
dcl_texcoord0 v1
mul r1.xy, v1, c4.y
mul r0.w, v0.y, c4.x
mul r0.z, v1.y, c4.y
mov r0.x, r1
mov r0.y, r0.w
mov oT0.xy, v1
mov oT1.xy, r0
mov oT2.xy, r0.zwzw
mul oT3.xy, r0, c4.z
mul oT4.xy, r0.zwzw, c4.z
mov oT5.xy, r1
mul oT6.xy, v1, c4.w
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "UnityPerDraw" 336 // 64 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
BindCB "UnityPerDraw" 0
// 15 instructions, 1 temp regs, 0 temp arrays:
// ALU 9 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedgadoncfkmilhkpnigihajhhmholdnibgabaaaaaaomadaaaaadaaaaaa
cmaaaaaaiaaaaaaagiabaaaaejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklkl
epfdeheooaaaaaaaaiaaaaaaaiaaaaaamiaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaaneaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
neaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaaamadaaaaneaaaaaaacaaaaaa
aaaaaaaaadaaaaaaacaaaaaaadamaaaaneaaaaaaadaaaaaaaaaaaaaaadaaaaaa
acaaaaaaamadaaaaneaaaaaaaeaaaaaaaaaaaaaaadaaaaaaadaaaaaaadamaaaa
neaaaaaaafaaaaaaaaaaaaaaadaaaaaaadaaaaaaamadaaaaneaaaaaaagaaaaaa
aaaaaaaaadaaaaaaaeaaaaaaadamaaaafdfgfpfaepfdejfeejepeoaafeeffied
epepfceeaaklklklfdeieefchmacaaaaeaaaabaajpaaaaaafjaaaaaeegiocaaa
aaaaaaaaaeaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaabaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaad
mccabaaaabaaaaaagfaaaaaddccabaaaacaaaaaagfaaaaadmccabaaaacaaaaaa
gfaaaaaddccabaaaadaaaaaagfaaaaadmccabaaaadaaaaaagfaaaaaddccabaaa
aeaaaaaagiaaaaacabaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiocaaaaaaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaa
aaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaaaaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pccabaaaaaaaaaaaegiocaaaaaaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaa
aaaaaaaadiaaaaakhccabaaaabaaaaaaegbabaaaabaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaacaebaaaaaaaadiaaaaahiccabaaaabaaaaaabkbabaaaaaaaaaaa
abeaaaaagpbciddldgaaaaaffcaabaaaaaaaaaaafgbebaaaabaaaaaadgaaaaaf
kcaabaaaaaaaaaaafgbfbaaaaaaaaaaadiaaaaakmccabaaaacaaaaaakgaobaaa
aaaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaahkedmnmmmmdndiaaaaahbccabaaa
acaaaaaabkbabaaaabaaaaaaabeaaaaaaaaacaebdiaaaaahcccabaaaacaaaaaa
bkbabaaaaaaaaaaaabeaaaaagpbciddldiaaaaakdccabaaaadaaaaaaegaabaaa
aaaaaaaaaceaaaaaaaaahkedmnmmmmdnaaaaaaaaaaaaaaaadiaaaaakmccabaaa
adaaaaaaagbebaaaabaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaacaebaaaacaeb
diaaaaakdccabaaaaeaaaaaaegbabaaaabaaaaaaaceaaaaaaaaaeiedaaaaeied
aaaaaaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD5;
varying highp vec2 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
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
  xlv_TEXCOORD3 = (tmpvar_1 * 25.0000);
  xlv_TEXCOORD4 = (tmpvar_2 * 25.0000);
  xlv_TEXCOORD5 = (_glesMultiTexCoord0.xy * 10.0000);
  xlv_TEXCOORD6 = (_glesMultiTexCoord0.xy * 200.000);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD5;
varying highp vec2 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _VertDetail;
uniform sampler2D _Vert;
uniform sampler2D _Splat1;
uniform sampler2D _FarDetail;
uniform sampler2D _Control1;
void main ()
{
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control1, xlv_TEXCOORD0);
  gl_FragData[0] = ((((texture2D (_Vert, xlv_TEXCOORD1) * (texture2D (_VertDetail, xlv_TEXCOORD3) + 0.400000)) * tmpvar_1.x) + ((texture2D (_Vert, xlv_TEXCOORD2) * (texture2D (_VertDetail, xlv_TEXCOORD4) + 0.400000)) * tmpvar_1.y)) + (((texture2D (_FarDetail, xlv_TEXCOORD5) + 0.500000) * texture2D (_Splat1, xlv_TEXCOORD6)) * tmpvar_1.z));
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

varying highp vec2 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD5;
varying highp vec2 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
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
  xlv_TEXCOORD3 = (tmpvar_1 * 25.0000);
  xlv_TEXCOORD4 = (tmpvar_2 * 25.0000);
  xlv_TEXCOORD5 = (_glesMultiTexCoord0.xy * 10.0000);
  xlv_TEXCOORD6 = (_glesMultiTexCoord0.xy * 200.000);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD5;
varying highp vec2 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _VertDetail;
uniform sampler2D _Vert;
uniform sampler2D _Splat1;
uniform sampler2D _FarDetail;
uniform sampler2D _Control1;
void main ()
{
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control1, xlv_TEXCOORD0);
  gl_FragData[0] = ((((texture2D (_Vert, xlv_TEXCOORD1) * (texture2D (_VertDetail, xlv_TEXCOORD3) + 0.400000)) * tmpvar_1.x) + ((texture2D (_Vert, xlv_TEXCOORD2) * (texture2D (_VertDetail, xlv_TEXCOORD4) + 0.400000)) * tmpvar_1.y)) + (((texture2D (_FarDetail, xlv_TEXCOORD5) + 0.500000) * texture2D (_Splat1, xlv_TEXCOORD6)) * tmpvar_1.z));
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLSL
#ifdef VERTEX
varying vec2 xlv_TEXCOORD6;
varying vec2 xlv_TEXCOORD5;
varying vec2 xlv_TEXCOORD4;
varying vec2 xlv_TEXCOORD3;
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
  xlv_TEXCOORD3 = (tmpvar_1 * 25.0000);
  xlv_TEXCOORD4 = (tmpvar_2 * 25.0000);
  xlv_TEXCOORD5 = (gl_MultiTexCoord0.xy * 10.0000);
  xlv_TEXCOORD6 = (gl_MultiTexCoord0.xy * 200.000);
}


#endif
#ifdef FRAGMENT
varying vec2 xlv_TEXCOORD6;
varying vec2 xlv_TEXCOORD5;
varying vec2 xlv_TEXCOORD4;
varying vec2 xlv_TEXCOORD3;
varying vec2 xlv_TEXCOORD2;
varying vec2 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _VertDetail;
uniform sampler2D _Vert;
uniform sampler2D _Splat1;
uniform sampler2D _FarDetail;
uniform sampler2D _Control1;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control1, xlv_TEXCOORD0);
  gl_FragData[0] = ((((texture2D (_Vert, xlv_TEXCOORD1) * (texture2D (_VertDetail, xlv_TEXCOORD3) + 0.400000)) * tmpvar_1.x) + ((texture2D (_Vert, xlv_TEXCOORD2) * (texture2D (_VertDetail, xlv_TEXCOORD4) + 0.400000)) * tmpvar_1.y)) + (((texture2D (_FarDetail, xlv_TEXCOORD5) + 0.500000) * texture2D (_Splat1, xlv_TEXCOORD6)) * tmpvar_1.z));
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
; 16 ALU
def c4, 0.00400000, 10.00000000, 25.00000000, 200.00000000
dcl_position0 v0
dcl_texcoord0 v1
mul r1.xy, v1, c4.y
mul r0.w, v0.y, c4.x
mul r0.z, v1.y, c4.y
mov r0.x, r1
mov r0.y, r0.w
mov oT0.xy, v1
mov oT1.xy, r0
mov oT2.xy, r0.zwzw
mul oT3.xy, r0, c4.z
mul oT4.xy, r0.zwzw, c4.z
mov oT5.xy, r1
mul oT6.xy, v1, c4.w
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "UnityPerDraw" 336 // 64 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
BindCB "UnityPerDraw" 0
// 15 instructions, 1 temp regs, 0 temp arrays:
// ALU 9 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedgadoncfkmilhkpnigihajhhmholdnibgabaaaaaaomadaaaaadaaaaaa
cmaaaaaaiaaaaaaagiabaaaaejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklkl
epfdeheooaaaaaaaaiaaaaaaaiaaaaaamiaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaaneaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
neaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaaamadaaaaneaaaaaaacaaaaaa
aaaaaaaaadaaaaaaacaaaaaaadamaaaaneaaaaaaadaaaaaaaaaaaaaaadaaaaaa
acaaaaaaamadaaaaneaaaaaaaeaaaaaaaaaaaaaaadaaaaaaadaaaaaaadamaaaa
neaaaaaaafaaaaaaaaaaaaaaadaaaaaaadaaaaaaamadaaaaneaaaaaaagaaaaaa
aaaaaaaaadaaaaaaaeaaaaaaadamaaaafdfgfpfaepfdejfeejepeoaafeeffied
epepfceeaaklklklfdeieefchmacaaaaeaaaabaajpaaaaaafjaaaaaeegiocaaa
aaaaaaaaaeaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaabaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaad
mccabaaaabaaaaaagfaaaaaddccabaaaacaaaaaagfaaaaadmccabaaaacaaaaaa
gfaaaaaddccabaaaadaaaaaagfaaaaadmccabaaaadaaaaaagfaaaaaddccabaaa
aeaaaaaagiaaaaacabaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiocaaaaaaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaa
aaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaaaaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pccabaaaaaaaaaaaegiocaaaaaaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaa
aaaaaaaadiaaaaakhccabaaaabaaaaaaegbabaaaabaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaacaebaaaaaaaadiaaaaahiccabaaaabaaaaaabkbabaaaaaaaaaaa
abeaaaaagpbciddldgaaaaaffcaabaaaaaaaaaaafgbebaaaabaaaaaadgaaaaaf
kcaabaaaaaaaaaaafgbfbaaaaaaaaaaadiaaaaakmccabaaaacaaaaaakgaobaaa
aaaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaahkedmnmmmmdndiaaaaahbccabaaa
acaaaaaabkbabaaaabaaaaaaabeaaaaaaaaacaebdiaaaaahcccabaaaacaaaaaa
bkbabaaaaaaaaaaaabeaaaaagpbciddldiaaaaakdccabaaaadaaaaaaegaabaaa
aaaaaaaaaceaaaaaaaaahkedmnmmmmdnaaaaaaaaaaaaaaaadiaaaaakmccabaaa
adaaaaaaagbebaaaabaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaacaebaaaacaeb
diaaaaakdccabaaaaeaaaaaaegbabaaaabaaaaaaaceaaaaaaaaaeiedaaaaeied
aaaaaaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD5;
varying highp vec2 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
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
  xlv_TEXCOORD3 = (tmpvar_1 * 25.0000);
  xlv_TEXCOORD4 = (tmpvar_2 * 25.0000);
  xlv_TEXCOORD5 = (_glesMultiTexCoord0.xy * 10.0000);
  xlv_TEXCOORD6 = (_glesMultiTexCoord0.xy * 200.000);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD5;
varying highp vec2 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _VertDetail;
uniform sampler2D _Vert;
uniform sampler2D _Splat1;
uniform sampler2D _FarDetail;
uniform sampler2D _Control1;
void main ()
{
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control1, xlv_TEXCOORD0);
  gl_FragData[0] = ((((texture2D (_Vert, xlv_TEXCOORD1) * (texture2D (_VertDetail, xlv_TEXCOORD3) + 0.400000)) * tmpvar_1.x) + ((texture2D (_Vert, xlv_TEXCOORD2) * (texture2D (_VertDetail, xlv_TEXCOORD4) + 0.400000)) * tmpvar_1.y)) + (((texture2D (_FarDetail, xlv_TEXCOORD5) + 0.500000) * texture2D (_Splat1, xlv_TEXCOORD6)) * tmpvar_1.z));
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

varying highp vec2 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD5;
varying highp vec2 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
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
  xlv_TEXCOORD3 = (tmpvar_1 * 25.0000);
  xlv_TEXCOORD4 = (tmpvar_2 * 25.0000);
  xlv_TEXCOORD5 = (_glesMultiTexCoord0.xy * 10.0000);
  xlv_TEXCOORD6 = (_glesMultiTexCoord0.xy * 200.000);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD5;
varying highp vec2 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _VertDetail;
uniform sampler2D _Vert;
uniform sampler2D _Splat1;
uniform sampler2D _FarDetail;
uniform sampler2D _Control1;
void main ()
{
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control1, xlv_TEXCOORD0);
  gl_FragData[0] = ((((texture2D (_Vert, xlv_TEXCOORD1) * (texture2D (_VertDetail, xlv_TEXCOORD3) + 0.400000)) * tmpvar_1.x) + ((texture2D (_Vert, xlv_TEXCOORD2) * (texture2D (_VertDetail, xlv_TEXCOORD4) + 0.400000)) * tmpvar_1.y)) + (((texture2D (_FarDetail, xlv_TEXCOORD5) + 0.500000) * texture2D (_Splat1, xlv_TEXCOORD6)) * tmpvar_1.z));
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
"!!GLSL
#ifdef VERTEX
varying vec2 xlv_TEXCOORD6;
varying vec2 xlv_TEXCOORD5;
varying vec2 xlv_TEXCOORD4;
varying vec2 xlv_TEXCOORD3;
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
  xlv_TEXCOORD3 = (tmpvar_1 * 25.0000);
  xlv_TEXCOORD4 = (tmpvar_2 * 25.0000);
  xlv_TEXCOORD5 = (gl_MultiTexCoord0.xy * 10.0000);
  xlv_TEXCOORD6 = (gl_MultiTexCoord0.xy * 200.000);
}


#endif
#ifdef FRAGMENT
varying vec2 xlv_TEXCOORD6;
varying vec2 xlv_TEXCOORD5;
varying vec2 xlv_TEXCOORD4;
varying vec2 xlv_TEXCOORD3;
varying vec2 xlv_TEXCOORD2;
varying vec2 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _VertDetail;
uniform sampler2D _Vert;
uniform sampler2D _Splat1;
uniform sampler2D _FarDetail;
uniform sampler2D _Control1;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control1, xlv_TEXCOORD0);
  gl_FragData[0] = ((((texture2D (_Vert, xlv_TEXCOORD1) * (texture2D (_VertDetail, xlv_TEXCOORD3) + 0.400000)) * tmpvar_1.x) + ((texture2D (_Vert, xlv_TEXCOORD2) * (texture2D (_VertDetail, xlv_TEXCOORD4) + 0.400000)) * tmpvar_1.y)) + (((texture2D (_FarDetail, xlv_TEXCOORD5) + 0.500000) * texture2D (_Splat1, xlv_TEXCOORD6)) * tmpvar_1.z));
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
; 16 ALU
def c4, 0.00400000, 10.00000000, 25.00000000, 200.00000000
dcl_position0 v0
dcl_texcoord0 v1
mul r1.xy, v1, c4.y
mul r0.w, v0.y, c4.x
mul r0.z, v1.y, c4.y
mov r0.x, r1
mov r0.y, r0.w
mov oT0.xy, v1
mov oT1.xy, r0
mov oT2.xy, r0.zwzw
mul oT3.xy, r0, c4.z
mul oT4.xy, r0.zwzw, c4.z
mov oT5.xy, r1
mul oT6.xy, v1, c4.w
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "UnityPerDraw" 336 // 64 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
BindCB "UnityPerDraw" 0
// 15 instructions, 1 temp regs, 0 temp arrays:
// ALU 9 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedgadoncfkmilhkpnigihajhhmholdnibgabaaaaaaomadaaaaadaaaaaa
cmaaaaaaiaaaaaaagiabaaaaejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklkl
epfdeheooaaaaaaaaiaaaaaaaiaaaaaamiaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaaneaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
neaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaaamadaaaaneaaaaaaacaaaaaa
aaaaaaaaadaaaaaaacaaaaaaadamaaaaneaaaaaaadaaaaaaaaaaaaaaadaaaaaa
acaaaaaaamadaaaaneaaaaaaaeaaaaaaaaaaaaaaadaaaaaaadaaaaaaadamaaaa
neaaaaaaafaaaaaaaaaaaaaaadaaaaaaadaaaaaaamadaaaaneaaaaaaagaaaaaa
aaaaaaaaadaaaaaaaeaaaaaaadamaaaafdfgfpfaepfdejfeejepeoaafeeffied
epepfceeaaklklklfdeieefchmacaaaaeaaaabaajpaaaaaafjaaaaaeegiocaaa
aaaaaaaaaeaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaabaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaad
mccabaaaabaaaaaagfaaaaaddccabaaaacaaaaaagfaaaaadmccabaaaacaaaaaa
gfaaaaaddccabaaaadaaaaaagfaaaaadmccabaaaadaaaaaagfaaaaaddccabaaa
aeaaaaaagiaaaaacabaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiocaaaaaaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaa
aaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaaaaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pccabaaaaaaaaaaaegiocaaaaaaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaa
aaaaaaaadiaaaaakhccabaaaabaaaaaaegbabaaaabaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaacaebaaaaaaaadiaaaaahiccabaaaabaaaaaabkbabaaaaaaaaaaa
abeaaaaagpbciddldgaaaaaffcaabaaaaaaaaaaafgbebaaaabaaaaaadgaaaaaf
kcaabaaaaaaaaaaafgbfbaaaaaaaaaaadiaaaaakmccabaaaacaaaaaakgaobaaa
aaaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaahkedmnmmmmdndiaaaaahbccabaaa
acaaaaaabkbabaaaabaaaaaaabeaaaaaaaaacaebdiaaaaahcccabaaaacaaaaaa
bkbabaaaaaaaaaaaabeaaaaagpbciddldiaaaaakdccabaaaadaaaaaaegaabaaa
aaaaaaaaaceaaaaaaaaahkedmnmmmmdnaaaaaaaaaaaaaaaadiaaaaakmccabaaa
adaaaaaaagbebaaaabaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaacaebaaaacaeb
diaaaaakdccabaaaaeaaaaaaegbabaaaabaaaaaaaceaaaaaaaaaeiedaaaaeied
aaaaaaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD5;
varying highp vec2 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
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
  xlv_TEXCOORD3 = (tmpvar_1 * 25.0000);
  xlv_TEXCOORD4 = (tmpvar_2 * 25.0000);
  xlv_TEXCOORD5 = (_glesMultiTexCoord0.xy * 10.0000);
  xlv_TEXCOORD6 = (_glesMultiTexCoord0.xy * 200.000);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD5;
varying highp vec2 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _VertDetail;
uniform sampler2D _Vert;
uniform sampler2D _Splat1;
uniform sampler2D _FarDetail;
uniform sampler2D _Control1;
void main ()
{
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control1, xlv_TEXCOORD0);
  gl_FragData[0] = ((((texture2D (_Vert, xlv_TEXCOORD1) * (texture2D (_VertDetail, xlv_TEXCOORD3) + 0.400000)) * tmpvar_1.x) + ((texture2D (_Vert, xlv_TEXCOORD2) * (texture2D (_VertDetail, xlv_TEXCOORD4) + 0.400000)) * tmpvar_1.y)) + (((texture2D (_FarDetail, xlv_TEXCOORD5) + 0.500000) * texture2D (_Splat1, xlv_TEXCOORD6)) * tmpvar_1.z));
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

varying highp vec2 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD5;
varying highp vec2 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
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
  xlv_TEXCOORD3 = (tmpvar_1 * 25.0000);
  xlv_TEXCOORD4 = (tmpvar_2 * 25.0000);
  xlv_TEXCOORD5 = (_glesMultiTexCoord0.xy * 10.0000);
  xlv_TEXCOORD6 = (_glesMultiTexCoord0.xy * 200.000);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD5;
varying highp vec2 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _VertDetail;
uniform sampler2D _Vert;
uniform sampler2D _Splat1;
uniform sampler2D _FarDetail;
uniform sampler2D _Control1;
void main ()
{
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control1, xlv_TEXCOORD0);
  gl_FragData[0] = ((((texture2D (_Vert, xlv_TEXCOORD1) * (texture2D (_VertDetail, xlv_TEXCOORD3) + 0.400000)) * tmpvar_1.x) + ((texture2D (_Vert, xlv_TEXCOORD2) * (texture2D (_VertDetail, xlv_TEXCOORD4) + 0.400000)) * tmpvar_1.y)) + (((texture2D (_FarDetail, xlv_TEXCOORD5) + 0.500000) * texture2D (_Splat1, xlv_TEXCOORD6)) * tmpvar_1.z));
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
"!!GLSL
#ifdef VERTEX
varying vec2 xlv_TEXCOORD6;
varying vec2 xlv_TEXCOORD5;
varying vec2 xlv_TEXCOORD4;
varying vec2 xlv_TEXCOORD3;
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
  xlv_TEXCOORD3 = (tmpvar_1 * 25.0000);
  xlv_TEXCOORD4 = (tmpvar_2 * 25.0000);
  xlv_TEXCOORD5 = (gl_MultiTexCoord0.xy * 10.0000);
  xlv_TEXCOORD6 = (gl_MultiTexCoord0.xy * 200.000);
}


#endif
#ifdef FRAGMENT
varying vec2 xlv_TEXCOORD6;
varying vec2 xlv_TEXCOORD5;
varying vec2 xlv_TEXCOORD4;
varying vec2 xlv_TEXCOORD3;
varying vec2 xlv_TEXCOORD2;
varying vec2 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _VertDetail;
uniform sampler2D _Vert;
uniform sampler2D _Splat1;
uniform sampler2D _FarDetail;
uniform sampler2D _Control1;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control1, xlv_TEXCOORD0);
  gl_FragData[0] = ((((texture2D (_Vert, xlv_TEXCOORD1) * (texture2D (_VertDetail, xlv_TEXCOORD3) + 0.400000)) * tmpvar_1.x) + ((texture2D (_Vert, xlv_TEXCOORD2) * (texture2D (_VertDetail, xlv_TEXCOORD4) + 0.400000)) * tmpvar_1.y)) + (((texture2D (_FarDetail, xlv_TEXCOORD5) + 0.500000) * texture2D (_Splat1, xlv_TEXCOORD6)) * tmpvar_1.z));
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
; 16 ALU
def c4, 0.00400000, 10.00000000, 25.00000000, 200.00000000
dcl_position0 v0
dcl_texcoord0 v1
mul r1.xy, v1, c4.y
mul r0.w, v0.y, c4.x
mul r0.z, v1.y, c4.y
mov r0.x, r1
mov r0.y, r0.w
mov oT0.xy, v1
mov oT1.xy, r0
mov oT2.xy, r0.zwzw
mul oT3.xy, r0, c4.z
mul oT4.xy, r0.zwzw, c4.z
mov oT5.xy, r1
mul oT6.xy, v1, c4.w
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "UnityPerDraw" 336 // 64 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
BindCB "UnityPerDraw" 0
// 15 instructions, 1 temp regs, 0 temp arrays:
// ALU 9 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedgadoncfkmilhkpnigihajhhmholdnibgabaaaaaaomadaaaaadaaaaaa
cmaaaaaaiaaaaaaagiabaaaaejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklkl
epfdeheooaaaaaaaaiaaaaaaaiaaaaaamiaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaaneaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
neaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaaamadaaaaneaaaaaaacaaaaaa
aaaaaaaaadaaaaaaacaaaaaaadamaaaaneaaaaaaadaaaaaaaaaaaaaaadaaaaaa
acaaaaaaamadaaaaneaaaaaaaeaaaaaaaaaaaaaaadaaaaaaadaaaaaaadamaaaa
neaaaaaaafaaaaaaaaaaaaaaadaaaaaaadaaaaaaamadaaaaneaaaaaaagaaaaaa
aaaaaaaaadaaaaaaaeaaaaaaadamaaaafdfgfpfaepfdejfeejepeoaafeeffied
epepfceeaaklklklfdeieefchmacaaaaeaaaabaajpaaaaaafjaaaaaeegiocaaa
aaaaaaaaaeaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaabaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaad
mccabaaaabaaaaaagfaaaaaddccabaaaacaaaaaagfaaaaadmccabaaaacaaaaaa
gfaaaaaddccabaaaadaaaaaagfaaaaadmccabaaaadaaaaaagfaaaaaddccabaaa
aeaaaaaagiaaaaacabaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiocaaaaaaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaa
aaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaaaaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pccabaaaaaaaaaaaegiocaaaaaaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaa
aaaaaaaadiaaaaakhccabaaaabaaaaaaegbabaaaabaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaacaebaaaaaaaadiaaaaahiccabaaaabaaaaaabkbabaaaaaaaaaaa
abeaaaaagpbciddldgaaaaaffcaabaaaaaaaaaaafgbebaaaabaaaaaadgaaaaaf
kcaabaaaaaaaaaaafgbfbaaaaaaaaaaadiaaaaakmccabaaaacaaaaaakgaobaaa
aaaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaahkedmnmmmmdndiaaaaahbccabaaa
acaaaaaabkbabaaaabaaaaaaabeaaaaaaaaacaebdiaaaaahcccabaaaacaaaaaa
bkbabaaaaaaaaaaaabeaaaaagpbciddldiaaaaakdccabaaaadaaaaaaegaabaaa
aaaaaaaaaceaaaaaaaaahkedmnmmmmdnaaaaaaaaaaaaaaaadiaaaaakmccabaaa
adaaaaaaagbebaaaabaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaacaebaaaacaeb
diaaaaakdccabaaaaeaaaaaaegbabaaaabaaaaaaaceaaaaaaaaaeiedaaaaeied
aaaaaaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD5;
varying highp vec2 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
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
  xlv_TEXCOORD3 = (tmpvar_1 * 25.0000);
  xlv_TEXCOORD4 = (tmpvar_2 * 25.0000);
  xlv_TEXCOORD5 = (_glesMultiTexCoord0.xy * 10.0000);
  xlv_TEXCOORD6 = (_glesMultiTexCoord0.xy * 200.000);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD5;
varying highp vec2 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _VertDetail;
uniform sampler2D _Vert;
uniform sampler2D _Splat1;
uniform sampler2D _FarDetail;
uniform sampler2D _Control1;
void main ()
{
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control1, xlv_TEXCOORD0);
  gl_FragData[0] = ((((texture2D (_Vert, xlv_TEXCOORD1) * (texture2D (_VertDetail, xlv_TEXCOORD3) + 0.400000)) * tmpvar_1.x) + ((texture2D (_Vert, xlv_TEXCOORD2) * (texture2D (_VertDetail, xlv_TEXCOORD4) + 0.400000)) * tmpvar_1.y)) + (((texture2D (_FarDetail, xlv_TEXCOORD5) + 0.500000) * texture2D (_Splat1, xlv_TEXCOORD6)) * tmpvar_1.z));
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

varying highp vec2 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD5;
varying highp vec2 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
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
  xlv_TEXCOORD3 = (tmpvar_1 * 25.0000);
  xlv_TEXCOORD4 = (tmpvar_2 * 25.0000);
  xlv_TEXCOORD5 = (_glesMultiTexCoord0.xy * 10.0000);
  xlv_TEXCOORD6 = (_glesMultiTexCoord0.xy * 200.000);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD5;
varying highp vec2 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _VertDetail;
uniform sampler2D _Vert;
uniform sampler2D _Splat1;
uniform sampler2D _FarDetail;
uniform sampler2D _Control1;
void main ()
{
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control1, xlv_TEXCOORD0);
  gl_FragData[0] = ((((texture2D (_Vert, xlv_TEXCOORD1) * (texture2D (_VertDetail, xlv_TEXCOORD3) + 0.400000)) * tmpvar_1.x) + ((texture2D (_Vert, xlv_TEXCOORD2) * (texture2D (_VertDetail, xlv_TEXCOORD4) + 0.400000)) * tmpvar_1.y)) + (((texture2D (_FarDetail, xlv_TEXCOORD5) + 0.500000) * texture2D (_Splat1, xlv_TEXCOORD6)) * tmpvar_1.z));
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
// 15 instructions, 1 temp regs, 0 temp arrays:
// ALU 9 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_3
eefiecedhcddhmbbnnnkhjdeenbbkligioloncppabaaaaaaiaafaaaaaeaaaaaa
daaaaaaamaabaaaaeeaeaaaajiaeaaaaebgpgodjiiabaaaaiiabaaaaaaacpopp
feabaaaadeaaaaaaabaaceaaaaaadaaaaaaadaaaaaaaceaaabaadaaaaaaaaaaa
aeaaabaaaaaaaaaaaaaaaaaaabacpoppfbaaaaafafaaapkamnmmmmdnaaaahked
aaaaeiedgpbciddlfbaaaaafagaaapkaaaaaiadpaaaacaebaaaaaaaaaaaaaaaa
bpaaaaacafaaaaiaaaaaapjabpaaaaacafaaabiaabaaapjaabaaaaacaaaaajia
abaacfjaabaaaaacaaaaagiaaaaaffjaafaaaaadabaaamoaaaaaoeiaafaaeeka
afaaaaadacaaadoaaaaaoeiaafaaobkaafaaaaadadaaadoaabaaoejaafaakkka
afaaaaadaaaaapiaaaaaffjaacaaoekaaeaaaaaeaaaaapiaabaaoekaaaaaaaja
aaaaoeiaaeaaaaaeaaaaapiaadaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaapia
aeaaoekaaaaappjaaaaaoeiaaeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeia
abaaaaacaaaaammaaaaaoeiaafaaaaadaaaaaloaabaacejaagaagakaafaaaaad
aaaaaeoaaaaaffjaafaappkaafaaaaadabaaaboaabaaffjaagaaffkaafaaaaad
abaaacoaaaaaffjaafaappkaafaaaaadacaaamoaabaabejaagaaffkappppaaaa
fdeieefchmacaaaaeaaaabaajpaaaaaafjaaaaaeegiocaaaaaaaaaaaaeaaaaaa
fpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaabaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadmccabaaaabaaaaaa
gfaaaaaddccabaaaacaaaaaagfaaaaadmccabaaaacaaaaaagfaaaaaddccabaaa
adaaaaaagfaaaaadmccabaaaadaaaaaagfaaaaaddccabaaaaeaaaaaagiaaaaac
abaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaaaaaaaaa
abaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaaaaaaaaaagbabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaa
acaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaa
egiocaaaaaaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaak
hccabaaaabaaaaaaegbabaaaabaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaacaeb
aaaaaaaadiaaaaahiccabaaaabaaaaaabkbabaaaaaaaaaaaabeaaaaagpbciddl
dgaaaaaffcaabaaaaaaaaaaafgbebaaaabaaaaaadgaaaaafkcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaadiaaaaakmccabaaaacaaaaaakgaobaaaaaaaaaaaaceaaaaa
aaaaaaaaaaaaaaaaaaaahkedmnmmmmdndiaaaaahbccabaaaacaaaaaabkbabaaa
abaaaaaaabeaaaaaaaaacaebdiaaaaahcccabaaaacaaaaaabkbabaaaaaaaaaaa
abeaaaaagpbciddldiaaaaakdccabaaaadaaaaaaegaabaaaaaaaaaaaaceaaaaa
aaaahkedmnmmmmdnaaaaaaaaaaaaaaaadiaaaaakmccabaaaadaaaaaaagbebaaa
abaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaacaebaaaacaebdiaaaaakdccabaaa
aeaaaaaaegbabaaaabaaaaaaaceaaaaaaaaaeiedaaaaeiedaaaaaaaaaaaaaaaa
doaaaaabejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
adadaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklklepfdeheooaaaaaaa
aiaaaaaaaiaaaaaamiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaa
neaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaaneaaaaaaabaaaaaa
aaaaaaaaadaaaaaaabaaaaaaamadaaaaneaaaaaaacaaaaaaaaaaaaaaadaaaaaa
acaaaaaaadamaaaaneaaaaaaadaaaaaaaaaaaaaaadaaaaaaacaaaaaaamadaaaa
neaaaaaaaeaaaaaaaaaaaaaaadaaaaaaadaaaaaaadamaaaaneaaaaaaafaaaaaa
aaaaaaaaadaaaaaaadaaaaaaamadaaaaneaaaaaaagaaaaaaaaaaaaaaadaaaaaa
aeaaaaaaadamaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklkl
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
"!!GLSL
#ifdef VERTEX
varying vec2 xlv_TEXCOORD6;
varying vec2 xlv_TEXCOORD5;
varying vec2 xlv_TEXCOORD4;
varying vec2 xlv_TEXCOORD3;
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
  xlv_TEXCOORD3 = (tmpvar_1 * 25.0000);
  xlv_TEXCOORD4 = (tmpvar_2 * 25.0000);
  xlv_TEXCOORD5 = (gl_MultiTexCoord0.xy * 10.0000);
  xlv_TEXCOORD6 = (gl_MultiTexCoord0.xy * 200.000);
}


#endif
#ifdef FRAGMENT
varying vec2 xlv_TEXCOORD6;
varying vec2 xlv_TEXCOORD5;
varying vec2 xlv_TEXCOORD4;
varying vec2 xlv_TEXCOORD3;
varying vec2 xlv_TEXCOORD2;
varying vec2 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _VertDetail;
uniform sampler2D _Vert;
uniform sampler2D _Splat1;
uniform sampler2D _FarDetail;
uniform sampler2D _Control1;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control1, xlv_TEXCOORD0);
  gl_FragData[0] = ((((texture2D (_Vert, xlv_TEXCOORD1) * (texture2D (_VertDetail, xlv_TEXCOORD3) + 0.400000)) * tmpvar_1.x) + ((texture2D (_Vert, xlv_TEXCOORD2) * (texture2D (_VertDetail, xlv_TEXCOORD4) + 0.400000)) * tmpvar_1.y)) + (((texture2D (_FarDetail, xlv_TEXCOORD5) + 0.500000) * texture2D (_Splat1, xlv_TEXCOORD6)) * tmpvar_1.z));
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
; 16 ALU
def c4, 0.00400000, 10.00000000, 25.00000000, 200.00000000
dcl_position0 v0
dcl_texcoord0 v1
mul r1.xy, v1, c4.y
mul r0.w, v0.y, c4.x
mul r0.z, v1.y, c4.y
mov r0.x, r1
mov r0.y, r0.w
mov oT0.xy, v1
mov oT1.xy, r0
mov oT2.xy, r0.zwzw
mul oT3.xy, r0, c4.z
mul oT4.xy, r0.zwzw, c4.z
mov oT5.xy, r1
mul oT6.xy, v1, c4.w
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "UnityPerDraw" 336 // 64 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
BindCB "UnityPerDraw" 0
// 15 instructions, 1 temp regs, 0 temp arrays:
// ALU 9 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedgadoncfkmilhkpnigihajhhmholdnibgabaaaaaaomadaaaaadaaaaaa
cmaaaaaaiaaaaaaagiabaaaaejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklkl
epfdeheooaaaaaaaaiaaaaaaaiaaaaaamiaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaaneaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
neaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaaamadaaaaneaaaaaaacaaaaaa
aaaaaaaaadaaaaaaacaaaaaaadamaaaaneaaaaaaadaaaaaaaaaaaaaaadaaaaaa
acaaaaaaamadaaaaneaaaaaaaeaaaaaaaaaaaaaaadaaaaaaadaaaaaaadamaaaa
neaaaaaaafaaaaaaaaaaaaaaadaaaaaaadaaaaaaamadaaaaneaaaaaaagaaaaaa
aaaaaaaaadaaaaaaaeaaaaaaadamaaaafdfgfpfaepfdejfeejepeoaafeeffied
epepfceeaaklklklfdeieefchmacaaaaeaaaabaajpaaaaaafjaaaaaeegiocaaa
aaaaaaaaaeaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaabaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaad
mccabaaaabaaaaaagfaaaaaddccabaaaacaaaaaagfaaaaadmccabaaaacaaaaaa
gfaaaaaddccabaaaadaaaaaagfaaaaadmccabaaaadaaaaaagfaaaaaddccabaaa
aeaaaaaagiaaaaacabaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiocaaaaaaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaa
aaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaaaaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pccabaaaaaaaaaaaegiocaaaaaaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaa
aaaaaaaadiaaaaakhccabaaaabaaaaaaegbabaaaabaaaaaaaceaaaaaaaaaiadp
aaaaiadpaaaacaebaaaaaaaadiaaaaahiccabaaaabaaaaaabkbabaaaaaaaaaaa
abeaaaaagpbciddldgaaaaaffcaabaaaaaaaaaaafgbebaaaabaaaaaadgaaaaaf
kcaabaaaaaaaaaaafgbfbaaaaaaaaaaadiaaaaakmccabaaaacaaaaaakgaobaaa
aaaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaahkedmnmmmmdndiaaaaahbccabaaa
acaaaaaabkbabaaaabaaaaaaabeaaaaaaaaacaebdiaaaaahcccabaaaacaaaaaa
bkbabaaaaaaaaaaaabeaaaaagpbciddldiaaaaakdccabaaaadaaaaaaegaabaaa
aaaaaaaaaceaaaaaaaaahkedmnmmmmdnaaaaaaaaaaaaaaaadiaaaaakmccabaaa
adaaaaaaagbebaaaabaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaacaebaaaacaeb
diaaaaakdccabaaaaeaaaaaaegbabaaaabaaaaaaaceaaaaaaaaaeiedaaaaeied
aaaaaaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD5;
varying highp vec2 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
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
  xlv_TEXCOORD3 = (tmpvar_1 * 25.0000);
  xlv_TEXCOORD4 = (tmpvar_2 * 25.0000);
  xlv_TEXCOORD5 = (_glesMultiTexCoord0.xy * 10.0000);
  xlv_TEXCOORD6 = (_glesMultiTexCoord0.xy * 200.000);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD5;
varying highp vec2 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _VertDetail;
uniform sampler2D _Vert;
uniform sampler2D _Splat1;
uniform sampler2D _FarDetail;
uniform sampler2D _Control1;
void main ()
{
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control1, xlv_TEXCOORD0);
  gl_FragData[0] = ((((texture2D (_Vert, xlv_TEXCOORD1) * (texture2D (_VertDetail, xlv_TEXCOORD3) + 0.400000)) * tmpvar_1.x) + ((texture2D (_Vert, xlv_TEXCOORD2) * (texture2D (_VertDetail, xlv_TEXCOORD4) + 0.400000)) * tmpvar_1.y)) + (((texture2D (_FarDetail, xlv_TEXCOORD5) + 0.500000) * texture2D (_Splat1, xlv_TEXCOORD6)) * tmpvar_1.z));
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

varying highp vec2 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD5;
varying highp vec2 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
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
  xlv_TEXCOORD3 = (tmpvar_1 * 25.0000);
  xlv_TEXCOORD4 = (tmpvar_2 * 25.0000);
  xlv_TEXCOORD5 = (_glesMultiTexCoord0.xy * 10.0000);
  xlv_TEXCOORD6 = (_glesMultiTexCoord0.xy * 200.000);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD5;
varying highp vec2 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _VertDetail;
uniform sampler2D _Vert;
uniform sampler2D _Splat1;
uniform sampler2D _FarDetail;
uniform sampler2D _Control1;
void main ()
{
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control1, xlv_TEXCOORD0);
  gl_FragData[0] = ((((texture2D (_Vert, xlv_TEXCOORD1) * (texture2D (_VertDetail, xlv_TEXCOORD3) + 0.400000)) * tmpvar_1.x) + ((texture2D (_Vert, xlv_TEXCOORD2) * (texture2D (_VertDetail, xlv_TEXCOORD4) + 0.400000)) * tmpvar_1.y)) + (((texture2D (_FarDetail, xlv_TEXCOORD5) + 0.500000) * texture2D (_Splat1, xlv_TEXCOORD6)) * tmpvar_1.z));
}



#endif"
}

}
Program "fp" {
// Fragment combos: 6
//   d3d9 - ALU: 10 to 10, TEX: 7 to 7
//   d3d11 - ALU: 7 to 7, TEX: 7 to 7, FLOW: 1 to 1
//   d3d11_9x - ALU: 7 to 7, TEX: 7 to 7, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
SetTexture 0 [_Vert] 2D
SetTexture 1 [_VertDetail] 2D
SetTexture 2 [_FarDetail] 2D
SetTexture 3 [_Control1] 2D
SetTexture 4 [_Splat1] 2D
"ps_2_0
; 10 ALU, 7 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
def c0, 0.40000001, 0.50000000, 0, 0
dcl t0.xy
dcl t1.xy
dcl t2.xy
dcl t3.xy
dcl t4.xy
dcl t5.xy
dcl t6.xy
texld r0, t6, s4
texld r1, t5, s2
texld r5, t1, s0
texld r6, t0, s3
texld r3, t3, s1
texld r2, t4, s1
texld r4, t2, s0
add r2, r2, c0.x
mul_pp r2, r4, r2
mul_pp r2, r6.y, r2
add r3, r3, c0.x
mul_pp r3, r5, r3
mad_pp r2, r6.x, r3, r2
add r1, r1, c0.y
mul r0, r1, r0
mad_pp r0, r0, r6.z, r2
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
SetTexture 0 [_Vert] 2D 1
SetTexture 1 [_VertDetail] 2D 2
SetTexture 2 [_FarDetail] 2D 4
SetTexture 3 [_Control1] 2D 0
SetTexture 4 [_Splat1] 2D 3
// 17 instructions, 4 temp regs, 0 temp arrays:
// ALU 7 float, 0 int, 0 uint
// TEX 7 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefieceddnedgkbdhmjfbcafjnicgcmklmdegakoabaaaaaahmaeaaaaadaaaaaa
cmaaaaaabeabaaaaeiabaaaaejfdeheooaaaaaaaaiaaaaaaaiaaaaaamiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaneaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaneaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaaneaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaadadaaaaneaaaaaa
adaaaaaaaaaaaaaaadaaaaaaacaaaaaaamamaaaaneaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaadaaaaaaadadaaaaneaaaaaaafaaaaaaaaaaaaaaadaaaaaaadaaaaaa
amamaaaaneaaaaaaagaaaaaaaaaaaaaaadaaaaaaaeaaaaaaadadaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklklfdeieefccmadaaaaeaaaaaaamlaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaad
aagabaaaadaaaaaafkaaaaadaagabaaaaeaaaaaafibiaaaeaahabaaaaaaaaaaa
ffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaa
ffffaaaafibiaaaeaahabaaaadaaaaaaffffaaaafibiaaaeaahabaaaaeaaaaaa
ffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadmcbabaaaabaaaaaagcbaaaad
dcbabaaaacaaaaaagcbaaaadmcbabaaaacaaaaaagcbaaaaddcbabaaaadaaaaaa
gcbaaaadmcbabaaaadaaaaaagcbaaaaddcbabaaaaeaaaaaagfaaaaadpccabaaa
aaaaaaaagiaaaaacaeaaaaaaefaaaaajpcaabaaaaaaaaaaaogbkbaaaacaaaaaa
eghobaaaabaaaaaaaagabaaaacaaaaaaaaaaaaakpcaabaaaaaaaaaaaegaobaaa
aaaaaaaaaceaaaaamnmmmmdomnmmmmdomnmmmmdomnmmmmdoefaaaaajpcaabaaa
abaaaaaaogbkbaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaadiaaaaah
pcaabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaaabaaaaaaefaaaaajpcaabaaa
abaaaaaaegbabaaaadaaaaaaeghobaaaabaaaaaaaagabaaaacaaaaaaaaaaaaak
pcaabaaaabaaaaaaegaobaaaabaaaaaaaceaaaaamnmmmmdomnmmmmdomnmmmmdo
mnmmmmdoefaaaaajpcaabaaaacaaaaaaegbabaaaacaaaaaaeghobaaaaaaaaaaa
aagabaaaabaaaaaadiaaaaahpcaabaaaabaaaaaaegaobaaaabaaaaaaegaobaaa
acaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaabaaaaaaeghobaaaadaaaaaa
aagabaaaaaaaaaaadiaaaaahpcaabaaaabaaaaaaegaobaaaabaaaaaafgafbaaa
acaaaaaadcaaaaajpcaabaaaaaaaaaaaegaobaaaaaaaaaaaagaabaaaacaaaaaa
egaobaaaabaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaaadaaaaaaeghobaaa
acaaaaaaaagabaaaaeaaaaaaaaaaaaakpcaabaaaabaaaaaaegaobaaaabaaaaaa
aceaaaaaaaaaaadpaaaaaadpaaaaaadpaaaaaadpefaaaaajpcaabaaaadaaaaaa
egbabaaaaeaaaaaaeghobaaaaeaaaaaaaagabaaaadaaaaaadiaaaaahpcaabaaa
abaaaaaaegaobaaaabaaaaaaegaobaaaadaaaaaadcaaaaajpccabaaaaaaaaaaa
egaobaaaabaaaaaakgakbaaaacaaaaaaegaobaaaaaaaaaaadoaaaaab"
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
SetTexture 0 [_Vert] 2D 1
SetTexture 1 [_VertDetail] 2D 2
SetTexture 2 [_FarDetail] 2D 4
SetTexture 3 [_Control1] 2D 0
SetTexture 4 [_Splat1] 2D 3
// 17 instructions, 4 temp regs, 0 temp arrays:
// ALU 7 float, 0 int, 0 uint
// TEX 7 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_3
eefiecedbpdnmleknbogcglehngnpmhlmlachpeaabaaaaaaieagaaaaaeaaaaaa
daaaaaaadeacaaaagiafaaaafaagaaaaebgpgodjpmabaaaapmabaaaaaaacpppp
meabaaaadiaaaaaaaaaadiaaaaaadiaaaaaadiaaafaaceaaaaaadiaaadaaaaaa
aaababaaabacacaaaeadadaaacaeaeaaabacppppfbaaaaafaaaaapkamnmmmmdo
aaaaaadpaaaaaaaaaaaaaaaabpaaaaacaaaaaaiaaaaaaplabpaaaaacaaaaaaia
abaaaplabpaaaaacaaaaaaiaacaaaplabpaaaaacaaaaaaiaadaaadlabpaaaaac
aaaaaajaaaaiapkabpaaaaacaaaaaajaabaiapkabpaaaaacaaaaaajaacaiapka
bpaaaaacaaaaaajaadaiapkabpaaaaacaaaaaajaaeaiapkaabaaaaacaaaaadia
abaaollaabaaaaacabaaadiaaaaaollaecaaaaadaaaaapiaaaaaoeiaacaioeka
ecaaaaadabaacpiaabaaoeiaabaioekaacaaaaadaaaacpiaaaaaoeiaaaaaaaka
afaaaaadaaaacpiaaaaaoeiaabaaoeiaecaaaaadabaacpiaabaaoelaabaioeka
ecaaaaadacaaapiaacaaoelaacaioekaacaaaaadacaacpiaacaaoeiaaaaaaaka
afaaaaadabaacpiaabaaoeiaacaaoeiaabaaaaacacaaadiaacaaollaecaaaaad
adaacpiaaaaaoelaaaaioekaecaaaaadacaaapiaacaaoeiaaeaioekaafaaaaad
abaacpiaabaaoeiaadaaffiaaeaaaaaeaaaacpiaaaaaoeiaadaaaaiaabaaoeia
acaaaaadabaacpiaacaaoeiaaaaaffkaecaaaaadacaaapiaadaaoelaadaioeka
afaaaaadabaacpiaabaaoeiaacaaoeiaaeaaaaaeaaaacpiaabaaoeiaadaakkia
aaaaoeiaabaaaaacaaaicpiaaaaaoeiappppaaaafdeieefccmadaaaaeaaaaaaa
mlaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaad
aagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaafkaaaaadaagabaaaaeaaaaaa
fibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaa
fibiaaaeaahabaaaacaaaaaaffffaaaafibiaaaeaahabaaaadaaaaaaffffaaaa
fibiaaaeaahabaaaaeaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaad
mcbabaaaabaaaaaagcbaaaaddcbabaaaacaaaaaagcbaaaadmcbabaaaacaaaaaa
gcbaaaaddcbabaaaadaaaaaagcbaaaadmcbabaaaadaaaaaagcbaaaaddcbabaaa
aeaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaaefaaaaajpcaabaaa
aaaaaaaaogbkbaaaacaaaaaaeghobaaaabaaaaaaaagabaaaacaaaaaaaaaaaaak
pcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaamnmmmmdomnmmmmdomnmmmmdo
mnmmmmdoefaaaaajpcaabaaaabaaaaaaogbkbaaaabaaaaaaeghobaaaaaaaaaaa
aagabaaaabaaaaaadiaaaaahpcaabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaa
abaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaadaaaaaaeghobaaaabaaaaaa
aagabaaaacaaaaaaaaaaaaakpcaabaaaabaaaaaaegaobaaaabaaaaaaaceaaaaa
mnmmmmdomnmmmmdomnmmmmdomnmmmmdoefaaaaajpcaabaaaacaaaaaaegbabaaa
acaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaadiaaaaahpcaabaaaabaaaaaa
egaobaaaabaaaaaaegaobaaaacaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaa
abaaaaaaeghobaaaadaaaaaaaagabaaaaaaaaaaadiaaaaahpcaabaaaabaaaaaa
egaobaaaabaaaaaafgafbaaaacaaaaaadcaaaaajpcaabaaaaaaaaaaaegaobaaa
aaaaaaaaagaabaaaacaaaaaaegaobaaaabaaaaaaefaaaaajpcaabaaaabaaaaaa
ogbkbaaaadaaaaaaeghobaaaacaaaaaaaagabaaaaeaaaaaaaaaaaaakpcaabaaa
abaaaaaaegaobaaaabaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaadpaaaaaadp
efaaaaajpcaabaaaadaaaaaaegbabaaaaeaaaaaaeghobaaaaeaaaaaaaagabaaa
adaaaaaadiaaaaahpcaabaaaabaaaaaaegaobaaaabaaaaaaegaobaaaadaaaaaa
dcaaaaajpccabaaaaaaaaaaaegaobaaaabaaaaaakgakbaaaacaaaaaaegaobaaa
aaaaaaaadoaaaaabejfdeheooaaaaaaaaiaaaaaaaiaaaaaamiaaaaaaaaaaaaaa
abaaaaaaadaaaaaaaaaaaaaaapaaaaaaneaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
abaaaaaaadadaaaaneaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaaamamaaaa
neaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaadadaaaaneaaaaaaadaaaaaa
aaaaaaaaadaaaaaaacaaaaaaamamaaaaneaaaaaaaeaaaaaaaaaaaaaaadaaaaaa
adaaaaaaadadaaaaneaaaaaaafaaaaaaaaaaaaaaadaaaaaaadaaaaaaamamaaaa
neaaaaaaagaaaaaaaaaaaaaaadaaaaaaaeaaaaaaadadaaaafdfgfpfaepfdejfe
ejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaa
caaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgf
heaaklkl"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
SetTexture 0 [_Vert] 2D
SetTexture 1 [_VertDetail] 2D
SetTexture 2 [_FarDetail] 2D
SetTexture 3 [_Control1] 2D
SetTexture 4 [_Splat1] 2D
"ps_2_0
; 10 ALU, 7 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
def c0, 0.40000001, 0.50000000, 0, 0
dcl t0.xy
dcl t1.xy
dcl t2.xy
dcl t3.xy
dcl t4.xy
dcl t5.xy
dcl t6.xy
texld r0, t6, s4
texld r1, t5, s2
texld r5, t1, s0
texld r6, t0, s3
texld r3, t3, s1
texld r2, t4, s1
texld r4, t2, s0
add r2, r2, c0.x
mul_pp r2, r4, r2
mul_pp r2, r6.y, r2
add r3, r3, c0.x
mul_pp r3, r5, r3
mad_pp r2, r6.x, r3, r2
add r1, r1, c0.y
mul r0, r1, r0
mad_pp r0, r0, r6.z, r2
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
SetTexture 0 [_Vert] 2D 1
SetTexture 1 [_VertDetail] 2D 2
SetTexture 2 [_FarDetail] 2D 4
SetTexture 3 [_Control1] 2D 0
SetTexture 4 [_Splat1] 2D 3
// 17 instructions, 4 temp regs, 0 temp arrays:
// ALU 7 float, 0 int, 0 uint
// TEX 7 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefieceddnedgkbdhmjfbcafjnicgcmklmdegakoabaaaaaahmaeaaaaadaaaaaa
cmaaaaaabeabaaaaeiabaaaaejfdeheooaaaaaaaaiaaaaaaaiaaaaaamiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaneaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaneaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaaneaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaadadaaaaneaaaaaa
adaaaaaaaaaaaaaaadaaaaaaacaaaaaaamamaaaaneaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaadaaaaaaadadaaaaneaaaaaaafaaaaaaaaaaaaaaadaaaaaaadaaaaaa
amamaaaaneaaaaaaagaaaaaaaaaaaaaaadaaaaaaaeaaaaaaadadaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklklfdeieefccmadaaaaeaaaaaaamlaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaad
aagabaaaadaaaaaafkaaaaadaagabaaaaeaaaaaafibiaaaeaahabaaaaaaaaaaa
ffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaa
ffffaaaafibiaaaeaahabaaaadaaaaaaffffaaaafibiaaaeaahabaaaaeaaaaaa
ffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadmcbabaaaabaaaaaagcbaaaad
dcbabaaaacaaaaaagcbaaaadmcbabaaaacaaaaaagcbaaaaddcbabaaaadaaaaaa
gcbaaaadmcbabaaaadaaaaaagcbaaaaddcbabaaaaeaaaaaagfaaaaadpccabaaa
aaaaaaaagiaaaaacaeaaaaaaefaaaaajpcaabaaaaaaaaaaaogbkbaaaacaaaaaa
eghobaaaabaaaaaaaagabaaaacaaaaaaaaaaaaakpcaabaaaaaaaaaaaegaobaaa
aaaaaaaaaceaaaaamnmmmmdomnmmmmdomnmmmmdomnmmmmdoefaaaaajpcaabaaa
abaaaaaaogbkbaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaadiaaaaah
pcaabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaaabaaaaaaefaaaaajpcaabaaa
abaaaaaaegbabaaaadaaaaaaeghobaaaabaaaaaaaagabaaaacaaaaaaaaaaaaak
pcaabaaaabaaaaaaegaobaaaabaaaaaaaceaaaaamnmmmmdomnmmmmdomnmmmmdo
mnmmmmdoefaaaaajpcaabaaaacaaaaaaegbabaaaacaaaaaaeghobaaaaaaaaaaa
aagabaaaabaaaaaadiaaaaahpcaabaaaabaaaaaaegaobaaaabaaaaaaegaobaaa
acaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaabaaaaaaeghobaaaadaaaaaa
aagabaaaaaaaaaaadiaaaaahpcaabaaaabaaaaaaegaobaaaabaaaaaafgafbaaa
acaaaaaadcaaaaajpcaabaaaaaaaaaaaegaobaaaaaaaaaaaagaabaaaacaaaaaa
egaobaaaabaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaaadaaaaaaeghobaaa
acaaaaaaaagabaaaaeaaaaaaaaaaaaakpcaabaaaabaaaaaaegaobaaaabaaaaaa
aceaaaaaaaaaaadpaaaaaadpaaaaaadpaaaaaadpefaaaaajpcaabaaaadaaaaaa
egbabaaaaeaaaaaaeghobaaaaeaaaaaaaagabaaaadaaaaaadiaaaaahpcaabaaa
abaaaaaaegaobaaaabaaaaaaegaobaaaadaaaaaadcaaaaajpccabaaaaaaaaaaa
egaobaaaabaaaaaakgakbaaaacaaaaaaegaobaaaaaaaaaaadoaaaaab"
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
SetTexture 0 [_Vert] 2D 1
SetTexture 1 [_VertDetail] 2D 2
SetTexture 2 [_FarDetail] 2D 4
SetTexture 3 [_Control1] 2D 0
SetTexture 4 [_Splat1] 2D 3
// 17 instructions, 4 temp regs, 0 temp arrays:
// ALU 7 float, 0 int, 0 uint
// TEX 7 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_3
eefiecedbpdnmleknbogcglehngnpmhlmlachpeaabaaaaaaieagaaaaaeaaaaaa
daaaaaaadeacaaaagiafaaaafaagaaaaebgpgodjpmabaaaapmabaaaaaaacpppp
meabaaaadiaaaaaaaaaadiaaaaaadiaaaaaadiaaafaaceaaaaaadiaaadaaaaaa
aaababaaabacacaaaeadadaaacaeaeaaabacppppfbaaaaafaaaaapkamnmmmmdo
aaaaaadpaaaaaaaaaaaaaaaabpaaaaacaaaaaaiaaaaaaplabpaaaaacaaaaaaia
abaaaplabpaaaaacaaaaaaiaacaaaplabpaaaaacaaaaaaiaadaaadlabpaaaaac
aaaaaajaaaaiapkabpaaaaacaaaaaajaabaiapkabpaaaaacaaaaaajaacaiapka
bpaaaaacaaaaaajaadaiapkabpaaaaacaaaaaajaaeaiapkaabaaaaacaaaaadia
abaaollaabaaaaacabaaadiaaaaaollaecaaaaadaaaaapiaaaaaoeiaacaioeka
ecaaaaadabaacpiaabaaoeiaabaioekaacaaaaadaaaacpiaaaaaoeiaaaaaaaka
afaaaaadaaaacpiaaaaaoeiaabaaoeiaecaaaaadabaacpiaabaaoelaabaioeka
ecaaaaadacaaapiaacaaoelaacaioekaacaaaaadacaacpiaacaaoeiaaaaaaaka
afaaaaadabaacpiaabaaoeiaacaaoeiaabaaaaacacaaadiaacaaollaecaaaaad
adaacpiaaaaaoelaaaaioekaecaaaaadacaaapiaacaaoeiaaeaioekaafaaaaad
abaacpiaabaaoeiaadaaffiaaeaaaaaeaaaacpiaaaaaoeiaadaaaaiaabaaoeia
acaaaaadabaacpiaacaaoeiaaaaaffkaecaaaaadacaaapiaadaaoelaadaioeka
afaaaaadabaacpiaabaaoeiaacaaoeiaaeaaaaaeaaaacpiaabaaoeiaadaakkia
aaaaoeiaabaaaaacaaaicpiaaaaaoeiappppaaaafdeieefccmadaaaaeaaaaaaa
mlaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaad
aagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaafkaaaaadaagabaaaaeaaaaaa
fibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaa
fibiaaaeaahabaaaacaaaaaaffffaaaafibiaaaeaahabaaaadaaaaaaffffaaaa
fibiaaaeaahabaaaaeaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaad
mcbabaaaabaaaaaagcbaaaaddcbabaaaacaaaaaagcbaaaadmcbabaaaacaaaaaa
gcbaaaaddcbabaaaadaaaaaagcbaaaadmcbabaaaadaaaaaagcbaaaaddcbabaaa
aeaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaaefaaaaajpcaabaaa
aaaaaaaaogbkbaaaacaaaaaaeghobaaaabaaaaaaaagabaaaacaaaaaaaaaaaaak
pcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaamnmmmmdomnmmmmdomnmmmmdo
mnmmmmdoefaaaaajpcaabaaaabaaaaaaogbkbaaaabaaaaaaeghobaaaaaaaaaaa
aagabaaaabaaaaaadiaaaaahpcaabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaa
abaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaadaaaaaaeghobaaaabaaaaaa
aagabaaaacaaaaaaaaaaaaakpcaabaaaabaaaaaaegaobaaaabaaaaaaaceaaaaa
mnmmmmdomnmmmmdomnmmmmdomnmmmmdoefaaaaajpcaabaaaacaaaaaaegbabaaa
acaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaadiaaaaahpcaabaaaabaaaaaa
egaobaaaabaaaaaaegaobaaaacaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaa
abaaaaaaeghobaaaadaaaaaaaagabaaaaaaaaaaadiaaaaahpcaabaaaabaaaaaa
egaobaaaabaaaaaafgafbaaaacaaaaaadcaaaaajpcaabaaaaaaaaaaaegaobaaa
aaaaaaaaagaabaaaacaaaaaaegaobaaaabaaaaaaefaaaaajpcaabaaaabaaaaaa
ogbkbaaaadaaaaaaeghobaaaacaaaaaaaagabaaaaeaaaaaaaaaaaaakpcaabaaa
abaaaaaaegaobaaaabaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaadpaaaaaadp
efaaaaajpcaabaaaadaaaaaaegbabaaaaeaaaaaaeghobaaaaeaaaaaaaagabaaa
adaaaaaadiaaaaahpcaabaaaabaaaaaaegaobaaaabaaaaaaegaobaaaadaaaaaa
dcaaaaajpccabaaaaaaaaaaaegaobaaaabaaaaaakgakbaaaacaaaaaaegaobaaa
aaaaaaaadoaaaaabejfdeheooaaaaaaaaiaaaaaaaiaaaaaamiaaaaaaaaaaaaaa
abaaaaaaadaaaaaaaaaaaaaaapaaaaaaneaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
abaaaaaaadadaaaaneaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaaamamaaaa
neaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaadadaaaaneaaaaaaadaaaaaa
aaaaaaaaadaaaaaaacaaaaaaamamaaaaneaaaaaaaeaaaaaaaaaaaaaaadaaaaaa
adaaaaaaadadaaaaneaaaaaaafaaaaaaaaaaaaaaadaaaaaaadaaaaaaamamaaaa
neaaaaaaagaaaaaaaaaaaaaaadaaaaaaaeaaaaaaadadaaaafdfgfpfaepfdejfe
ejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaa
caaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgf
heaaklkl"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
SetTexture 0 [_Vert] 2D
SetTexture 1 [_VertDetail] 2D
SetTexture 2 [_FarDetail] 2D
SetTexture 3 [_Control1] 2D
SetTexture 4 [_Splat1] 2D
"ps_2_0
; 10 ALU, 7 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
def c0, 0.40000001, 0.50000000, 0, 0
dcl t0.xy
dcl t1.xy
dcl t2.xy
dcl t3.xy
dcl t4.xy
dcl t5.xy
dcl t6.xy
texld r0, t6, s4
texld r1, t5, s2
texld r5, t1, s0
texld r6, t0, s3
texld r3, t3, s1
texld r2, t4, s1
texld r4, t2, s0
add r2, r2, c0.x
mul_pp r2, r4, r2
mul_pp r2, r6.y, r2
add r3, r3, c0.x
mul_pp r3, r5, r3
mad_pp r2, r6.x, r3, r2
add r1, r1, c0.y
mul r0, r1, r0
mad_pp r0, r0, r6.z, r2
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
SetTexture 0 [_Vert] 2D 1
SetTexture 1 [_VertDetail] 2D 2
SetTexture 2 [_FarDetail] 2D 4
SetTexture 3 [_Control1] 2D 0
SetTexture 4 [_Splat1] 2D 3
// 17 instructions, 4 temp regs, 0 temp arrays:
// ALU 7 float, 0 int, 0 uint
// TEX 7 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefieceddnedgkbdhmjfbcafjnicgcmklmdegakoabaaaaaahmaeaaaaadaaaaaa
cmaaaaaabeabaaaaeiabaaaaejfdeheooaaaaaaaaiaaaaaaaiaaaaaamiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaneaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaneaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaaneaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaadadaaaaneaaaaaa
adaaaaaaaaaaaaaaadaaaaaaacaaaaaaamamaaaaneaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaadaaaaaaadadaaaaneaaaaaaafaaaaaaaaaaaaaaadaaaaaaadaaaaaa
amamaaaaneaaaaaaagaaaaaaaaaaaaaaadaaaaaaaeaaaaaaadadaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklklfdeieefccmadaaaaeaaaaaaamlaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaad
aagabaaaadaaaaaafkaaaaadaagabaaaaeaaaaaafibiaaaeaahabaaaaaaaaaaa
ffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaa
ffffaaaafibiaaaeaahabaaaadaaaaaaffffaaaafibiaaaeaahabaaaaeaaaaaa
ffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadmcbabaaaabaaaaaagcbaaaad
dcbabaaaacaaaaaagcbaaaadmcbabaaaacaaaaaagcbaaaaddcbabaaaadaaaaaa
gcbaaaadmcbabaaaadaaaaaagcbaaaaddcbabaaaaeaaaaaagfaaaaadpccabaaa
aaaaaaaagiaaaaacaeaaaaaaefaaaaajpcaabaaaaaaaaaaaogbkbaaaacaaaaaa
eghobaaaabaaaaaaaagabaaaacaaaaaaaaaaaaakpcaabaaaaaaaaaaaegaobaaa
aaaaaaaaaceaaaaamnmmmmdomnmmmmdomnmmmmdomnmmmmdoefaaaaajpcaabaaa
abaaaaaaogbkbaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaadiaaaaah
pcaabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaaabaaaaaaefaaaaajpcaabaaa
abaaaaaaegbabaaaadaaaaaaeghobaaaabaaaaaaaagabaaaacaaaaaaaaaaaaak
pcaabaaaabaaaaaaegaobaaaabaaaaaaaceaaaaamnmmmmdomnmmmmdomnmmmmdo
mnmmmmdoefaaaaajpcaabaaaacaaaaaaegbabaaaacaaaaaaeghobaaaaaaaaaaa
aagabaaaabaaaaaadiaaaaahpcaabaaaabaaaaaaegaobaaaabaaaaaaegaobaaa
acaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaabaaaaaaeghobaaaadaaaaaa
aagabaaaaaaaaaaadiaaaaahpcaabaaaabaaaaaaegaobaaaabaaaaaafgafbaaa
acaaaaaadcaaaaajpcaabaaaaaaaaaaaegaobaaaaaaaaaaaagaabaaaacaaaaaa
egaobaaaabaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaaadaaaaaaeghobaaa
acaaaaaaaagabaaaaeaaaaaaaaaaaaakpcaabaaaabaaaaaaegaobaaaabaaaaaa
aceaaaaaaaaaaadpaaaaaadpaaaaaadpaaaaaadpefaaaaajpcaabaaaadaaaaaa
egbabaaaaeaaaaaaeghobaaaaeaaaaaaaagabaaaadaaaaaadiaaaaahpcaabaaa
abaaaaaaegaobaaaabaaaaaaegaobaaaadaaaaaadcaaaaajpccabaaaaaaaaaaa
egaobaaaabaaaaaakgakbaaaacaaaaaaegaobaaaaaaaaaaadoaaaaab"
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
SetTexture 0 [_Vert] 2D 1
SetTexture 1 [_VertDetail] 2D 2
SetTexture 2 [_FarDetail] 2D 4
SetTexture 3 [_Control1] 2D 0
SetTexture 4 [_Splat1] 2D 3
// 17 instructions, 4 temp regs, 0 temp arrays:
// ALU 7 float, 0 int, 0 uint
// TEX 7 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_3
eefiecedbpdnmleknbogcglehngnpmhlmlachpeaabaaaaaaieagaaaaaeaaaaaa
daaaaaaadeacaaaagiafaaaafaagaaaaebgpgodjpmabaaaapmabaaaaaaacpppp
meabaaaadiaaaaaaaaaadiaaaaaadiaaaaaadiaaafaaceaaaaaadiaaadaaaaaa
aaababaaabacacaaaeadadaaacaeaeaaabacppppfbaaaaafaaaaapkamnmmmmdo
aaaaaadpaaaaaaaaaaaaaaaabpaaaaacaaaaaaiaaaaaaplabpaaaaacaaaaaaia
abaaaplabpaaaaacaaaaaaiaacaaaplabpaaaaacaaaaaaiaadaaadlabpaaaaac
aaaaaajaaaaiapkabpaaaaacaaaaaajaabaiapkabpaaaaacaaaaaajaacaiapka
bpaaaaacaaaaaajaadaiapkabpaaaaacaaaaaajaaeaiapkaabaaaaacaaaaadia
abaaollaabaaaaacabaaadiaaaaaollaecaaaaadaaaaapiaaaaaoeiaacaioeka
ecaaaaadabaacpiaabaaoeiaabaioekaacaaaaadaaaacpiaaaaaoeiaaaaaaaka
afaaaaadaaaacpiaaaaaoeiaabaaoeiaecaaaaadabaacpiaabaaoelaabaioeka
ecaaaaadacaaapiaacaaoelaacaioekaacaaaaadacaacpiaacaaoeiaaaaaaaka
afaaaaadabaacpiaabaaoeiaacaaoeiaabaaaaacacaaadiaacaaollaecaaaaad
adaacpiaaaaaoelaaaaioekaecaaaaadacaaapiaacaaoeiaaeaioekaafaaaaad
abaacpiaabaaoeiaadaaffiaaeaaaaaeaaaacpiaaaaaoeiaadaaaaiaabaaoeia
acaaaaadabaacpiaacaaoeiaaaaaffkaecaaaaadacaaapiaadaaoelaadaioeka
afaaaaadabaacpiaabaaoeiaacaaoeiaaeaaaaaeaaaacpiaabaaoeiaadaakkia
aaaaoeiaabaaaaacaaaicpiaaaaaoeiappppaaaafdeieefccmadaaaaeaaaaaaa
mlaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaad
aagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaafkaaaaadaagabaaaaeaaaaaa
fibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaa
fibiaaaeaahabaaaacaaaaaaffffaaaafibiaaaeaahabaaaadaaaaaaffffaaaa
fibiaaaeaahabaaaaeaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaad
mcbabaaaabaaaaaagcbaaaaddcbabaaaacaaaaaagcbaaaadmcbabaaaacaaaaaa
gcbaaaaddcbabaaaadaaaaaagcbaaaadmcbabaaaadaaaaaagcbaaaaddcbabaaa
aeaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaaefaaaaajpcaabaaa
aaaaaaaaogbkbaaaacaaaaaaeghobaaaabaaaaaaaagabaaaacaaaaaaaaaaaaak
pcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaamnmmmmdomnmmmmdomnmmmmdo
mnmmmmdoefaaaaajpcaabaaaabaaaaaaogbkbaaaabaaaaaaeghobaaaaaaaaaaa
aagabaaaabaaaaaadiaaaaahpcaabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaa
abaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaadaaaaaaeghobaaaabaaaaaa
aagabaaaacaaaaaaaaaaaaakpcaabaaaabaaaaaaegaobaaaabaaaaaaaceaaaaa
mnmmmmdomnmmmmdomnmmmmdomnmmmmdoefaaaaajpcaabaaaacaaaaaaegbabaaa
acaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaadiaaaaahpcaabaaaabaaaaaa
egaobaaaabaaaaaaegaobaaaacaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaa
abaaaaaaeghobaaaadaaaaaaaagabaaaaaaaaaaadiaaaaahpcaabaaaabaaaaaa
egaobaaaabaaaaaafgafbaaaacaaaaaadcaaaaajpcaabaaaaaaaaaaaegaobaaa
aaaaaaaaagaabaaaacaaaaaaegaobaaaabaaaaaaefaaaaajpcaabaaaabaaaaaa
ogbkbaaaadaaaaaaeghobaaaacaaaaaaaagabaaaaeaaaaaaaaaaaaakpcaabaaa
abaaaaaaegaobaaaabaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaadpaaaaaadp
efaaaaajpcaabaaaadaaaaaaegbabaaaaeaaaaaaeghobaaaaeaaaaaaaagabaaa
adaaaaaadiaaaaahpcaabaaaabaaaaaaegaobaaaabaaaaaaegaobaaaadaaaaaa
dcaaaaajpccabaaaaaaaaaaaegaobaaaabaaaaaakgakbaaaacaaaaaaegaobaaa
aaaaaaaadoaaaaabejfdeheooaaaaaaaaiaaaaaaaiaaaaaamiaaaaaaaaaaaaaa
abaaaaaaadaaaaaaaaaaaaaaapaaaaaaneaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
abaaaaaaadadaaaaneaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaaamamaaaa
neaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaadadaaaaneaaaaaaadaaaaaa
aaaaaaaaadaaaaaaacaaaaaaamamaaaaneaaaaaaaeaaaaaaaaaaaaaaadaaaaaa
adaaaaaaadadaaaaneaaaaaaafaaaaaaaaaaaaaaadaaaaaaadaaaaaaamamaaaa
neaaaaaaagaaaaaaaaaaaaaaadaaaaaaaeaaaaaaadadaaaafdfgfpfaepfdejfe
ejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaa
caaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgf
heaaklkl"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
SetTexture 0 [_Vert] 2D
SetTexture 1 [_VertDetail] 2D
SetTexture 2 [_FarDetail] 2D
SetTexture 3 [_Control1] 2D
SetTexture 4 [_Splat1] 2D
"ps_2_0
; 10 ALU, 7 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
def c0, 0.40000001, 0.50000000, 0, 0
dcl t0.xy
dcl t1.xy
dcl t2.xy
dcl t3.xy
dcl t4.xy
dcl t5.xy
dcl t6.xy
texld r0, t6, s4
texld r1, t5, s2
texld r5, t1, s0
texld r6, t0, s3
texld r3, t3, s1
texld r2, t4, s1
texld r4, t2, s0
add r2, r2, c0.x
mul_pp r2, r4, r2
mul_pp r2, r6.y, r2
add r3, r3, c0.x
mul_pp r3, r5, r3
mad_pp r2, r6.x, r3, r2
add r1, r1, c0.y
mul r0, r1, r0
mad_pp r0, r0, r6.z, r2
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
SetTexture 0 [_Vert] 2D 1
SetTexture 1 [_VertDetail] 2D 2
SetTexture 2 [_FarDetail] 2D 4
SetTexture 3 [_Control1] 2D 0
SetTexture 4 [_Splat1] 2D 3
// 17 instructions, 4 temp regs, 0 temp arrays:
// ALU 7 float, 0 int, 0 uint
// TEX 7 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefieceddnedgkbdhmjfbcafjnicgcmklmdegakoabaaaaaahmaeaaaaadaaaaaa
cmaaaaaabeabaaaaeiabaaaaejfdeheooaaaaaaaaiaaaaaaaiaaaaaamiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaneaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaneaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaaneaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaadadaaaaneaaaaaa
adaaaaaaaaaaaaaaadaaaaaaacaaaaaaamamaaaaneaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaadaaaaaaadadaaaaneaaaaaaafaaaaaaaaaaaaaaadaaaaaaadaaaaaa
amamaaaaneaaaaaaagaaaaaaaaaaaaaaadaaaaaaaeaaaaaaadadaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklklfdeieefccmadaaaaeaaaaaaamlaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaad
aagabaaaadaaaaaafkaaaaadaagabaaaaeaaaaaafibiaaaeaahabaaaaaaaaaaa
ffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaa
ffffaaaafibiaaaeaahabaaaadaaaaaaffffaaaafibiaaaeaahabaaaaeaaaaaa
ffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadmcbabaaaabaaaaaagcbaaaad
dcbabaaaacaaaaaagcbaaaadmcbabaaaacaaaaaagcbaaaaddcbabaaaadaaaaaa
gcbaaaadmcbabaaaadaaaaaagcbaaaaddcbabaaaaeaaaaaagfaaaaadpccabaaa
aaaaaaaagiaaaaacaeaaaaaaefaaaaajpcaabaaaaaaaaaaaogbkbaaaacaaaaaa
eghobaaaabaaaaaaaagabaaaacaaaaaaaaaaaaakpcaabaaaaaaaaaaaegaobaaa
aaaaaaaaaceaaaaamnmmmmdomnmmmmdomnmmmmdomnmmmmdoefaaaaajpcaabaaa
abaaaaaaogbkbaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaadiaaaaah
pcaabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaaabaaaaaaefaaaaajpcaabaaa
abaaaaaaegbabaaaadaaaaaaeghobaaaabaaaaaaaagabaaaacaaaaaaaaaaaaak
pcaabaaaabaaaaaaegaobaaaabaaaaaaaceaaaaamnmmmmdomnmmmmdomnmmmmdo
mnmmmmdoefaaaaajpcaabaaaacaaaaaaegbabaaaacaaaaaaeghobaaaaaaaaaaa
aagabaaaabaaaaaadiaaaaahpcaabaaaabaaaaaaegaobaaaabaaaaaaegaobaaa
acaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaabaaaaaaeghobaaaadaaaaaa
aagabaaaaaaaaaaadiaaaaahpcaabaaaabaaaaaaegaobaaaabaaaaaafgafbaaa
acaaaaaadcaaaaajpcaabaaaaaaaaaaaegaobaaaaaaaaaaaagaabaaaacaaaaaa
egaobaaaabaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaaadaaaaaaeghobaaa
acaaaaaaaagabaaaaeaaaaaaaaaaaaakpcaabaaaabaaaaaaegaobaaaabaaaaaa
aceaaaaaaaaaaadpaaaaaadpaaaaaadpaaaaaadpefaaaaajpcaabaaaadaaaaaa
egbabaaaaeaaaaaaeghobaaaaeaaaaaaaagabaaaadaaaaaadiaaaaahpcaabaaa
abaaaaaaegaobaaaabaaaaaaegaobaaaadaaaaaadcaaaaajpccabaaaaaaaaaaa
egaobaaaabaaaaaakgakbaaaacaaaaaaegaobaaaaaaaaaaadoaaaaab"
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
SetTexture 0 [_Vert] 2D
SetTexture 1 [_VertDetail] 2D
SetTexture 2 [_FarDetail] 2D
SetTexture 3 [_Control1] 2D
SetTexture 4 [_Splat1] 2D
"ps_2_0
; 10 ALU, 7 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
def c0, 0.40000001, 0.50000000, 0, 0
dcl t0.xy
dcl t1.xy
dcl t2.xy
dcl t3.xy
dcl t4.xy
dcl t5.xy
dcl t6.xy
texld r0, t6, s4
texld r1, t5, s2
texld r5, t1, s0
texld r6, t0, s3
texld r3, t3, s1
texld r2, t4, s1
texld r4, t2, s0
add r2, r2, c0.x
mul_pp r2, r4, r2
mul_pp r2, r6.y, r2
add r3, r3, c0.x
mul_pp r3, r5, r3
mad_pp r2, r6.x, r3, r2
add r1, r1, c0.y
mul r0, r1, r0
mad_pp r0, r0, r6.z, r2
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
SetTexture 0 [_Vert] 2D 1
SetTexture 1 [_VertDetail] 2D 2
SetTexture 2 [_FarDetail] 2D 4
SetTexture 3 [_Control1] 2D 0
SetTexture 4 [_Splat1] 2D 3
// 17 instructions, 4 temp regs, 0 temp arrays:
// ALU 7 float, 0 int, 0 uint
// TEX 7 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefieceddnedgkbdhmjfbcafjnicgcmklmdegakoabaaaaaahmaeaaaaadaaaaaa
cmaaaaaabeabaaaaeiabaaaaejfdeheooaaaaaaaaiaaaaaaaiaaaaaamiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaneaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaneaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaaneaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaadadaaaaneaaaaaa
adaaaaaaaaaaaaaaadaaaaaaacaaaaaaamamaaaaneaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaadaaaaaaadadaaaaneaaaaaaafaaaaaaaaaaaaaaadaaaaaaadaaaaaa
amamaaaaneaaaaaaagaaaaaaaaaaaaaaadaaaaaaaeaaaaaaadadaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklklfdeieefccmadaaaaeaaaaaaamlaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaad
aagabaaaadaaaaaafkaaaaadaagabaaaaeaaaaaafibiaaaeaahabaaaaaaaaaaa
ffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaa
ffffaaaafibiaaaeaahabaaaadaaaaaaffffaaaafibiaaaeaahabaaaaeaaaaaa
ffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadmcbabaaaabaaaaaagcbaaaad
dcbabaaaacaaaaaagcbaaaadmcbabaaaacaaaaaagcbaaaaddcbabaaaadaaaaaa
gcbaaaadmcbabaaaadaaaaaagcbaaaaddcbabaaaaeaaaaaagfaaaaadpccabaaa
aaaaaaaagiaaaaacaeaaaaaaefaaaaajpcaabaaaaaaaaaaaogbkbaaaacaaaaaa
eghobaaaabaaaaaaaagabaaaacaaaaaaaaaaaaakpcaabaaaaaaaaaaaegaobaaa
aaaaaaaaaceaaaaamnmmmmdomnmmmmdomnmmmmdomnmmmmdoefaaaaajpcaabaaa
abaaaaaaogbkbaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaadiaaaaah
pcaabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaaabaaaaaaefaaaaajpcaabaaa
abaaaaaaegbabaaaadaaaaaaeghobaaaabaaaaaaaagabaaaacaaaaaaaaaaaaak
pcaabaaaabaaaaaaegaobaaaabaaaaaaaceaaaaamnmmmmdomnmmmmdomnmmmmdo
mnmmmmdoefaaaaajpcaabaaaacaaaaaaegbabaaaacaaaaaaeghobaaaaaaaaaaa
aagabaaaabaaaaaadiaaaaahpcaabaaaabaaaaaaegaobaaaabaaaaaaegaobaaa
acaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaabaaaaaaeghobaaaadaaaaaa
aagabaaaaaaaaaaadiaaaaahpcaabaaaabaaaaaaegaobaaaabaaaaaafgafbaaa
acaaaaaadcaaaaajpcaabaaaaaaaaaaaegaobaaaaaaaaaaaagaabaaaacaaaaaa
egaobaaaabaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaaadaaaaaaeghobaaa
acaaaaaaaagabaaaaeaaaaaaaaaaaaakpcaabaaaabaaaaaaegaobaaaabaaaaaa
aceaaaaaaaaaaadpaaaaaadpaaaaaadpaaaaaadpefaaaaajpcaabaaaadaaaaaa
egbabaaaaeaaaaaaeghobaaaaeaaaaaaaagabaaaadaaaaaadiaaaaahpcaabaaa
abaaaaaaegaobaaaabaaaaaaegaobaaaadaaaaaadcaaaaajpccabaaaaaaaaaaa
egaobaaaabaaaaaakgakbaaaacaaaaaaegaobaaaaaaaaaaadoaaaaab"
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
SetTexture 0 [_Vert] 2D
SetTexture 1 [_VertDetail] 2D
SetTexture 2 [_FarDetail] 2D
SetTexture 3 [_Control1] 2D
SetTexture 4 [_Splat1] 2D
"ps_2_0
; 10 ALU, 7 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
def c0, 0.40000001, 0.50000000, 0, 0
dcl t0.xy
dcl t1.xy
dcl t2.xy
dcl t3.xy
dcl t4.xy
dcl t5.xy
dcl t6.xy
texld r0, t6, s4
texld r1, t5, s2
texld r5, t1, s0
texld r6, t0, s3
texld r3, t3, s1
texld r2, t4, s1
texld r4, t2, s0
add r2, r2, c0.x
mul_pp r2, r4, r2
mul_pp r2, r6.y, r2
add r3, r3, c0.x
mul_pp r3, r5, r3
mad_pp r2, r6.x, r3, r2
add r1, r1, c0.y
mul r0, r1, r0
mad_pp r0, r0, r6.z, r2
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
SetTexture 0 [_Vert] 2D 1
SetTexture 1 [_VertDetail] 2D 2
SetTexture 2 [_FarDetail] 2D 4
SetTexture 3 [_Control1] 2D 0
SetTexture 4 [_Splat1] 2D 3
// 17 instructions, 4 temp regs, 0 temp arrays:
// ALU 7 float, 0 int, 0 uint
// TEX 7 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefieceddnedgkbdhmjfbcafjnicgcmklmdegakoabaaaaaahmaeaaaaadaaaaaa
cmaaaaaabeabaaaaeiabaaaaejfdeheooaaaaaaaaiaaaaaaaiaaaaaamiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaneaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaneaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaaneaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaadadaaaaneaaaaaa
adaaaaaaaaaaaaaaadaaaaaaacaaaaaaamamaaaaneaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaadaaaaaaadadaaaaneaaaaaaafaaaaaaaaaaaaaaadaaaaaaadaaaaaa
amamaaaaneaaaaaaagaaaaaaaaaaaaaaadaaaaaaaeaaaaaaadadaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklklfdeieefccmadaaaaeaaaaaaamlaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaad
aagabaaaadaaaaaafkaaaaadaagabaaaaeaaaaaafibiaaaeaahabaaaaaaaaaaa
ffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaa
ffffaaaafibiaaaeaahabaaaadaaaaaaffffaaaafibiaaaeaahabaaaaeaaaaaa
ffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadmcbabaaaabaaaaaagcbaaaad
dcbabaaaacaaaaaagcbaaaadmcbabaaaacaaaaaagcbaaaaddcbabaaaadaaaaaa
gcbaaaadmcbabaaaadaaaaaagcbaaaaddcbabaaaaeaaaaaagfaaaaadpccabaaa
aaaaaaaagiaaaaacaeaaaaaaefaaaaajpcaabaaaaaaaaaaaogbkbaaaacaaaaaa
eghobaaaabaaaaaaaagabaaaacaaaaaaaaaaaaakpcaabaaaaaaaaaaaegaobaaa
aaaaaaaaaceaaaaamnmmmmdomnmmmmdomnmmmmdomnmmmmdoefaaaaajpcaabaaa
abaaaaaaogbkbaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaadiaaaaah
pcaabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaaabaaaaaaefaaaaajpcaabaaa
abaaaaaaegbabaaaadaaaaaaeghobaaaabaaaaaaaagabaaaacaaaaaaaaaaaaak
pcaabaaaabaaaaaaegaobaaaabaaaaaaaceaaaaamnmmmmdomnmmmmdomnmmmmdo
mnmmmmdoefaaaaajpcaabaaaacaaaaaaegbabaaaacaaaaaaeghobaaaaaaaaaaa
aagabaaaabaaaaaadiaaaaahpcaabaaaabaaaaaaegaobaaaabaaaaaaegaobaaa
acaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaabaaaaaaeghobaaaadaaaaaa
aagabaaaaaaaaaaadiaaaaahpcaabaaaabaaaaaaegaobaaaabaaaaaafgafbaaa
acaaaaaadcaaaaajpcaabaaaaaaaaaaaegaobaaaaaaaaaaaagaabaaaacaaaaaa
egaobaaaabaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaaadaaaaaaeghobaaa
acaaaaaaaagabaaaaeaaaaaaaaaaaaakpcaabaaaabaaaaaaegaobaaaabaaaaaa
aceaaaaaaaaaaadpaaaaaadpaaaaaadpaaaaaadpefaaaaajpcaabaaaadaaaaaa
egbabaaaaeaaaaaaeghobaaaaeaaaaaaaagabaaaadaaaaaadiaaaaahpcaabaaa
abaaaaaaegaobaaaabaaaaaaegaobaaaadaaaaaadcaaaaajpccabaaaaaaaaaaa
egaobaaaabaaaaaakgakbaaaacaaaaaaegaobaaaaaaaaaaadoaaaaab"
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

#LINE 126


    }

// ====================== PASS TWO ======================================

Pass {
    //Fog {Mode Off}
    //Fog { Color ( 0.5,0.45,0.31 ) }
    //Fog { Color ( 0.384,0.433,0.480 ) }
    Fog { Color [_FogColor] }
    Lighting Off
    Tags {"LightMode" = "ForwardBase"}
    Blend One One

	Program "vp" {
// Vertex combos: 8
//   d3d9 - ALU: 8 to 8
//   d3d11 - ALU: 3 to 3, TEX: 0 to 0, FLOW: 1 to 1
//   d3d11_9x - ALU: 3 to 3, TEX: 0 to 0, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLSL
#ifdef VERTEX
varying vec2 xlv_TEXCOORD6;
varying vec2 xlv_TEXCOORD2;
varying vec2 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;

void main ()
{
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = gl_MultiTexCoord0.xy;
  xlv_TEXCOORD1 = (gl_MultiTexCoord0.xy * 350.000);
  xlv_TEXCOORD2 = (gl_MultiTexCoord0.xy * 10.0000);
  xlv_TEXCOORD6 = (gl_MultiTexCoord0.xy * 200.000);
}


#endif
#ifdef FRAGMENT
varying vec2 xlv_TEXCOORD6;
varying vec2 xlv_TEXCOORD2;
varying vec2 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _Splat3;
uniform sampler2D _Flow;
uniform sampler2D _FarDetail;
uniform sampler2D _Control2;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control2, xlv_TEXCOORD0);
  gl_FragData[0] = ((texture2D (_FarDetail, xlv_TEXCOORD2) + 0.500000) * ((texture2D (_Flow, xlv_TEXCOORD1) * tmpvar_1.y) + (texture2D (_Splat3, xlv_TEXCOORD6) * tmpvar_1.x)));
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
; 8 ALU
def c4, 350.00000000, 10.00000000, 200.00000000, 0
dcl_position0 v0
dcl_texcoord0 v1
mov oT0.xy, v1
mul oT1.xy, v1, c4.x
mul oT2.xy, v1, c4.y
mul oT6.xy, v1, c4.z
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "UnityPerDraw" 336 // 64 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
BindCB "UnityPerDraw" 0
// 7 instructions, 1 temp regs, 0 temp arrays:
// ALU 3 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedfdclkondgfiaecjeolgmoomemphppichabaaaaaaimacaaaaadaaaaaa
cmaaaaaaiaaaaaaacaabaaaaejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklkl
epfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
imaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaaamadaaaaimaaaaaaacaaaaaa
aaaaaaaaadaaaaaaacaaaaaaadamaaaaimaaaaaaagaaaaaaaaaaaaaaadaaaaaa
acaaaaaaamadaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklkl
fdeieefcgeabaaaaeaaaabaafjaaaaaafjaaaaaeegiocaaaaaaaaaaaaeaaaaaa
fpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaabaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadmccabaaaabaaaaaa
gfaaaaaddccabaaaacaaaaaagfaaaaadmccabaaaacaaaaaagiaaaaacabaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaaaaaaaaaabaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaaaaaaaaaagbabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaacaaaaaa
kgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaa
aaaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaakpccabaaa
abaaaaaaegbebaaaabaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaakpedaaaakped
diaaaaakpccabaaaacaaaaaaegbebaaaabaaaaaaaceaaaaaaaaacaebaaaacaeb
aaaaeiedaaaaeieddoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;

attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_glesMultiTexCoord0.xy * 350.000);
  xlv_TEXCOORD2 = (_glesMultiTexCoord0.xy * 10.0000);
  xlv_TEXCOORD6 = (_glesMultiTexCoord0.xy * 200.000);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _Splat3;
uniform sampler2D _Flow;
uniform sampler2D _FarDetail;
uniform sampler2D _Control2;
void main ()
{
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control2, xlv_TEXCOORD0);
  gl_FragData[0] = ((texture2D (_FarDetail, xlv_TEXCOORD2) + 0.500000) * ((texture2D (_Flow, xlv_TEXCOORD1) * tmpvar_1.y) + (texture2D (_Splat3, xlv_TEXCOORD6) * tmpvar_1.x)));
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

varying highp vec2 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;

attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_glesMultiTexCoord0.xy * 350.000);
  xlv_TEXCOORD2 = (_glesMultiTexCoord0.xy * 10.0000);
  xlv_TEXCOORD6 = (_glesMultiTexCoord0.xy * 200.000);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _Splat3;
uniform sampler2D _Flow;
uniform sampler2D _FarDetail;
uniform sampler2D _Control2;
void main ()
{
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control2, xlv_TEXCOORD0);
  gl_FragData[0] = ((texture2D (_FarDetail, xlv_TEXCOORD2) + 0.500000) * ((texture2D (_Flow, xlv_TEXCOORD1) * tmpvar_1.y) + (texture2D (_Splat3, xlv_TEXCOORD6) * tmpvar_1.x)));
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
// 7 instructions, 1 temp regs, 0 temp arrays:
// ALU 3 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_3
eefiecedmcncklfebkaahmndcgfdlnpofcehnnocabaaaaaajaadaaaaaeaaaaaa
daaaaaaadaabaaaajmacaaaapaacaaaaebgpgodjpiaaaaaapiaaaaaaaaacpopp
meaaaaaadeaaaaaaabaaceaaaaaadaaaaaaadaaaaaaaceaaabaadaaaaaaaaaaa
aeaaabaaaaaaaaaaaaaaaaaaabacpoppfbaaaaafafaaapkaaaaacaebaaaaeied
aaaaiadpaaaakpedbpaaaaacafaaaaiaaaaaapjabpaaaaacafaaabiaabaaapja
afaaaaadabaaapoaabaabejaafaafakaafaaaaadaaaaapiaaaaaffjaacaaoeka
aeaaaaaeaaaaapiaabaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapiaadaaoeka
aaaakkjaaaaaoeiaaeaaaaaeaaaaapiaaeaaoekaaaaappjaaaaaoeiaaeaaaaae
aaaaadmaaaaappiaaaaaoekaaaaaoeiaabaaaaacaaaaammaaaaaoeiaafaaaaad
aaaaapoaabaabejaafaapkkappppaaaafdeieefcgeabaaaaeaaaabaafjaaaaaa
fjaaaaaeegiocaaaaaaaaaaaaeaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaad
dcbabaaaabaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaa
abaaaaaagfaaaaadmccabaaaabaaaaaagfaaaaaddccabaaaacaaaaaagfaaaaad
mccabaaaacaaaaaagiaaaaacabaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaaaaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
aaaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaaaaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpccabaaaaaaaaaaaegiocaaaaaaaaaaaadaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadiaaaaakpccabaaaabaaaaaaegbebaaaabaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaakpedaaaakpeddiaaaaakpccabaaaacaaaaaaegbebaaa
abaaaaaaaceaaaaaaaaacaebaaaacaebaaaaeiedaaaaeieddoaaaaabejfdeheo
emaaaaaaacaaaaaaaiaaaaaadiaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apapaaaaebaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadadaaaafaepfdej
feejepeoaafeeffiedepepfceeaaklklepfdeheojiaaaaaaafaaaaaaaiaaaaaa
iaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaabaaaaaaadamaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaa
abaaaaaaamadaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaadamaaaa
imaaaaaaagaaaaaaaaaaaaaaadaaaaaaacaaaaaaamadaaaafdfgfpfaepfdejfe
ejepeoaafeeffiedepepfceeaaklklkl"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLSL
#ifdef VERTEX
varying vec2 xlv_TEXCOORD6;
varying vec2 xlv_TEXCOORD2;
varying vec2 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;

void main ()
{
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = gl_MultiTexCoord0.xy;
  xlv_TEXCOORD1 = (gl_MultiTexCoord0.xy * 350.000);
  xlv_TEXCOORD2 = (gl_MultiTexCoord0.xy * 10.0000);
  xlv_TEXCOORD6 = (gl_MultiTexCoord0.xy * 200.000);
}


#endif
#ifdef FRAGMENT
varying vec2 xlv_TEXCOORD6;
varying vec2 xlv_TEXCOORD2;
varying vec2 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _Splat3;
uniform sampler2D _Flow;
uniform sampler2D _FarDetail;
uniform sampler2D _Control2;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control2, xlv_TEXCOORD0);
  gl_FragData[0] = ((texture2D (_FarDetail, xlv_TEXCOORD2) + 0.500000) * ((texture2D (_Flow, xlv_TEXCOORD1) * tmpvar_1.y) + (texture2D (_Splat3, xlv_TEXCOORD6) * tmpvar_1.x)));
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
; 8 ALU
def c4, 350.00000000, 10.00000000, 200.00000000, 0
dcl_position0 v0
dcl_texcoord0 v1
mov oT0.xy, v1
mul oT1.xy, v1, c4.x
mul oT2.xy, v1, c4.y
mul oT6.xy, v1, c4.z
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "UnityPerDraw" 336 // 64 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
BindCB "UnityPerDraw" 0
// 7 instructions, 1 temp regs, 0 temp arrays:
// ALU 3 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedfdclkondgfiaecjeolgmoomemphppichabaaaaaaimacaaaaadaaaaaa
cmaaaaaaiaaaaaaacaabaaaaejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklkl
epfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
imaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaaamadaaaaimaaaaaaacaaaaaa
aaaaaaaaadaaaaaaacaaaaaaadamaaaaimaaaaaaagaaaaaaaaaaaaaaadaaaaaa
acaaaaaaamadaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklkl
fdeieefcgeabaaaaeaaaabaafjaaaaaafjaaaaaeegiocaaaaaaaaaaaaeaaaaaa
fpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaabaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadmccabaaaabaaaaaa
gfaaaaaddccabaaaacaaaaaagfaaaaadmccabaaaacaaaaaagiaaaaacabaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaaaaaaaaaabaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaaaaaaaaaagbabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaacaaaaaa
kgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaa
aaaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaakpccabaaa
abaaaaaaegbebaaaabaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaakpedaaaakped
diaaaaakpccabaaaacaaaaaaegbebaaaabaaaaaaaceaaaaaaaaacaebaaaacaeb
aaaaeiedaaaaeieddoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;

attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_glesMultiTexCoord0.xy * 350.000);
  xlv_TEXCOORD2 = (_glesMultiTexCoord0.xy * 10.0000);
  xlv_TEXCOORD6 = (_glesMultiTexCoord0.xy * 200.000);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _Splat3;
uniform sampler2D _Flow;
uniform sampler2D _FarDetail;
uniform sampler2D _Control2;
void main ()
{
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control2, xlv_TEXCOORD0);
  gl_FragData[0] = ((texture2D (_FarDetail, xlv_TEXCOORD2) + 0.500000) * ((texture2D (_Flow, xlv_TEXCOORD1) * tmpvar_1.y) + (texture2D (_Splat3, xlv_TEXCOORD6) * tmpvar_1.x)));
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

varying highp vec2 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;

attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_glesMultiTexCoord0.xy * 350.000);
  xlv_TEXCOORD2 = (_glesMultiTexCoord0.xy * 10.0000);
  xlv_TEXCOORD6 = (_glesMultiTexCoord0.xy * 200.000);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _Splat3;
uniform sampler2D _Flow;
uniform sampler2D _FarDetail;
uniform sampler2D _Control2;
void main ()
{
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control2, xlv_TEXCOORD0);
  gl_FragData[0] = ((texture2D (_FarDetail, xlv_TEXCOORD2) + 0.500000) * ((texture2D (_Flow, xlv_TEXCOORD1) * tmpvar_1.y) + (texture2D (_Splat3, xlv_TEXCOORD6) * tmpvar_1.x)));
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
// 7 instructions, 1 temp regs, 0 temp arrays:
// ALU 3 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_3
eefiecedmcncklfebkaahmndcgfdlnpofcehnnocabaaaaaajaadaaaaaeaaaaaa
daaaaaaadaabaaaajmacaaaapaacaaaaebgpgodjpiaaaaaapiaaaaaaaaacpopp
meaaaaaadeaaaaaaabaaceaaaaaadaaaaaaadaaaaaaaceaaabaadaaaaaaaaaaa
aeaaabaaaaaaaaaaaaaaaaaaabacpoppfbaaaaafafaaapkaaaaacaebaaaaeied
aaaaiadpaaaakpedbpaaaaacafaaaaiaaaaaapjabpaaaaacafaaabiaabaaapja
afaaaaadabaaapoaabaabejaafaafakaafaaaaadaaaaapiaaaaaffjaacaaoeka
aeaaaaaeaaaaapiaabaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapiaadaaoeka
aaaakkjaaaaaoeiaaeaaaaaeaaaaapiaaeaaoekaaaaappjaaaaaoeiaaeaaaaae
aaaaadmaaaaappiaaaaaoekaaaaaoeiaabaaaaacaaaaammaaaaaoeiaafaaaaad
aaaaapoaabaabejaafaapkkappppaaaafdeieefcgeabaaaaeaaaabaafjaaaaaa
fjaaaaaeegiocaaaaaaaaaaaaeaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaad
dcbabaaaabaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaa
abaaaaaagfaaaaadmccabaaaabaaaaaagfaaaaaddccabaaaacaaaaaagfaaaaad
mccabaaaacaaaaaagiaaaaacabaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaaaaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
aaaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaaaaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpccabaaaaaaaaaaaegiocaaaaaaaaaaaadaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadiaaaaakpccabaaaabaaaaaaegbebaaaabaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaakpedaaaakpeddiaaaaakpccabaaaacaaaaaaegbebaaa
abaaaaaaaceaaaaaaaaacaebaaaacaebaaaaeiedaaaaeieddoaaaaabejfdeheo
emaaaaaaacaaaaaaaiaaaaaadiaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apapaaaaebaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadadaaaafaepfdej
feejepeoaafeeffiedepepfceeaaklklepfdeheojiaaaaaaafaaaaaaaiaaaaaa
iaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaabaaaaaaadamaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaa
abaaaaaaamadaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaadamaaaa
imaaaaaaagaaaaaaaaaaaaaaadaaaaaaacaaaaaaamadaaaafdfgfpfaepfdejfe
ejepeoaafeeffiedepepfceeaaklklkl"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
"!!GLSL
#ifdef VERTEX
varying vec2 xlv_TEXCOORD6;
varying vec2 xlv_TEXCOORD2;
varying vec2 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;

void main ()
{
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = gl_MultiTexCoord0.xy;
  xlv_TEXCOORD1 = (gl_MultiTexCoord0.xy * 350.000);
  xlv_TEXCOORD2 = (gl_MultiTexCoord0.xy * 10.0000);
  xlv_TEXCOORD6 = (gl_MultiTexCoord0.xy * 200.000);
}


#endif
#ifdef FRAGMENT
varying vec2 xlv_TEXCOORD6;
varying vec2 xlv_TEXCOORD2;
varying vec2 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _Splat3;
uniform sampler2D _Flow;
uniform sampler2D _FarDetail;
uniform sampler2D _Control2;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control2, xlv_TEXCOORD0);
  gl_FragData[0] = ((texture2D (_FarDetail, xlv_TEXCOORD2) + 0.500000) * ((texture2D (_Flow, xlv_TEXCOORD1) * tmpvar_1.y) + (texture2D (_Splat3, xlv_TEXCOORD6) * tmpvar_1.x)));
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
; 8 ALU
def c4, 350.00000000, 10.00000000, 200.00000000, 0
dcl_position0 v0
dcl_texcoord0 v1
mov oT0.xy, v1
mul oT1.xy, v1, c4.x
mul oT2.xy, v1, c4.y
mul oT6.xy, v1, c4.z
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "UnityPerDraw" 336 // 64 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
BindCB "UnityPerDraw" 0
// 7 instructions, 1 temp regs, 0 temp arrays:
// ALU 3 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedfdclkondgfiaecjeolgmoomemphppichabaaaaaaimacaaaaadaaaaaa
cmaaaaaaiaaaaaaacaabaaaaejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklkl
epfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
imaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaaamadaaaaimaaaaaaacaaaaaa
aaaaaaaaadaaaaaaacaaaaaaadamaaaaimaaaaaaagaaaaaaaaaaaaaaadaaaaaa
acaaaaaaamadaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklkl
fdeieefcgeabaaaaeaaaabaafjaaaaaafjaaaaaeegiocaaaaaaaaaaaaeaaaaaa
fpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaabaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadmccabaaaabaaaaaa
gfaaaaaddccabaaaacaaaaaagfaaaaadmccabaaaacaaaaaagiaaaaacabaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaaaaaaaaaabaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaaaaaaaaaagbabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaacaaaaaa
kgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaa
aaaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaakpccabaaa
abaaaaaaegbebaaaabaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaakpedaaaakped
diaaaaakpccabaaaacaaaaaaegbebaaaabaaaaaaaceaaaaaaaaacaebaaaacaeb
aaaaeiedaaaaeieddoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;

attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_glesMultiTexCoord0.xy * 350.000);
  xlv_TEXCOORD2 = (_glesMultiTexCoord0.xy * 10.0000);
  xlv_TEXCOORD6 = (_glesMultiTexCoord0.xy * 200.000);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _Splat3;
uniform sampler2D _Flow;
uniform sampler2D _FarDetail;
uniform sampler2D _Control2;
void main ()
{
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control2, xlv_TEXCOORD0);
  gl_FragData[0] = ((texture2D (_FarDetail, xlv_TEXCOORD2) + 0.500000) * ((texture2D (_Flow, xlv_TEXCOORD1) * tmpvar_1.y) + (texture2D (_Splat3, xlv_TEXCOORD6) * tmpvar_1.x)));
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

varying highp vec2 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;

attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_glesMultiTexCoord0.xy * 350.000);
  xlv_TEXCOORD2 = (_glesMultiTexCoord0.xy * 10.0000);
  xlv_TEXCOORD6 = (_glesMultiTexCoord0.xy * 200.000);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _Splat3;
uniform sampler2D _Flow;
uniform sampler2D _FarDetail;
uniform sampler2D _Control2;
void main ()
{
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control2, xlv_TEXCOORD0);
  gl_FragData[0] = ((texture2D (_FarDetail, xlv_TEXCOORD2) + 0.500000) * ((texture2D (_Flow, xlv_TEXCOORD1) * tmpvar_1.y) + (texture2D (_Splat3, xlv_TEXCOORD6) * tmpvar_1.x)));
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
// 7 instructions, 1 temp regs, 0 temp arrays:
// ALU 3 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_3
eefiecedmcncklfebkaahmndcgfdlnpofcehnnocabaaaaaajaadaaaaaeaaaaaa
daaaaaaadaabaaaajmacaaaapaacaaaaebgpgodjpiaaaaaapiaaaaaaaaacpopp
meaaaaaadeaaaaaaabaaceaaaaaadaaaaaaadaaaaaaaceaaabaadaaaaaaaaaaa
aeaaabaaaaaaaaaaaaaaaaaaabacpoppfbaaaaafafaaapkaaaaacaebaaaaeied
aaaaiadpaaaakpedbpaaaaacafaaaaiaaaaaapjabpaaaaacafaaabiaabaaapja
afaaaaadabaaapoaabaabejaafaafakaafaaaaadaaaaapiaaaaaffjaacaaoeka
aeaaaaaeaaaaapiaabaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapiaadaaoeka
aaaakkjaaaaaoeiaaeaaaaaeaaaaapiaaeaaoekaaaaappjaaaaaoeiaaeaaaaae
aaaaadmaaaaappiaaaaaoekaaaaaoeiaabaaaaacaaaaammaaaaaoeiaafaaaaad
aaaaapoaabaabejaafaapkkappppaaaafdeieefcgeabaaaaeaaaabaafjaaaaaa
fjaaaaaeegiocaaaaaaaaaaaaeaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaad
dcbabaaaabaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaa
abaaaaaagfaaaaadmccabaaaabaaaaaagfaaaaaddccabaaaacaaaaaagfaaaaad
mccabaaaacaaaaaagiaaaaacabaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaaaaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
aaaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaaaaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpccabaaaaaaaaaaaegiocaaaaaaaaaaaadaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadiaaaaakpccabaaaabaaaaaaegbebaaaabaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaakpedaaaakpeddiaaaaakpccabaaaacaaaaaaegbebaaa
abaaaaaaaceaaaaaaaaacaebaaaacaebaaaaeiedaaaaeieddoaaaaabejfdeheo
emaaaaaaacaaaaaaaiaaaaaadiaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apapaaaaebaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadadaaaafaepfdej
feejepeoaafeeffiedepepfceeaaklklepfdeheojiaaaaaaafaaaaaaaiaaaaaa
iaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaabaaaaaaadamaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaa
abaaaaaaamadaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaadamaaaa
imaaaaaaagaaaaaaaaaaaaaaadaaaaaaacaaaaaaamadaaaafdfgfpfaepfdejfe
ejepeoaafeeffiedepepfceeaaklklkl"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLSL
#ifdef VERTEX
varying vec2 xlv_TEXCOORD6;
varying vec2 xlv_TEXCOORD2;
varying vec2 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;

void main ()
{
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = gl_MultiTexCoord0.xy;
  xlv_TEXCOORD1 = (gl_MultiTexCoord0.xy * 350.000);
  xlv_TEXCOORD2 = (gl_MultiTexCoord0.xy * 10.0000);
  xlv_TEXCOORD6 = (gl_MultiTexCoord0.xy * 200.000);
}


#endif
#ifdef FRAGMENT
varying vec2 xlv_TEXCOORD6;
varying vec2 xlv_TEXCOORD2;
varying vec2 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _Splat3;
uniform sampler2D _Flow;
uniform sampler2D _FarDetail;
uniform sampler2D _Control2;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control2, xlv_TEXCOORD0);
  gl_FragData[0] = ((texture2D (_FarDetail, xlv_TEXCOORD2) + 0.500000) * ((texture2D (_Flow, xlv_TEXCOORD1) * tmpvar_1.y) + (texture2D (_Splat3, xlv_TEXCOORD6) * tmpvar_1.x)));
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
; 8 ALU
def c4, 350.00000000, 10.00000000, 200.00000000, 0
dcl_position0 v0
dcl_texcoord0 v1
mov oT0.xy, v1
mul oT1.xy, v1, c4.x
mul oT2.xy, v1, c4.y
mul oT6.xy, v1, c4.z
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "UnityPerDraw" 336 // 64 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
BindCB "UnityPerDraw" 0
// 7 instructions, 1 temp regs, 0 temp arrays:
// ALU 3 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedfdclkondgfiaecjeolgmoomemphppichabaaaaaaimacaaaaadaaaaaa
cmaaaaaaiaaaaaaacaabaaaaejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklkl
epfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
imaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaaamadaaaaimaaaaaaacaaaaaa
aaaaaaaaadaaaaaaacaaaaaaadamaaaaimaaaaaaagaaaaaaaaaaaaaaadaaaaaa
acaaaaaaamadaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklkl
fdeieefcgeabaaaaeaaaabaafjaaaaaafjaaaaaeegiocaaaaaaaaaaaaeaaaaaa
fpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaabaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadmccabaaaabaaaaaa
gfaaaaaddccabaaaacaaaaaagfaaaaadmccabaaaacaaaaaagiaaaaacabaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaaaaaaaaaabaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaaaaaaaaaagbabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaacaaaaaa
kgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaa
aaaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaakpccabaaa
abaaaaaaegbebaaaabaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaakpedaaaakped
diaaaaakpccabaaaacaaaaaaegbebaaaabaaaaaaaceaaaaaaaaacaebaaaacaeb
aaaaeiedaaaaeieddoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;

attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_glesMultiTexCoord0.xy * 350.000);
  xlv_TEXCOORD2 = (_glesMultiTexCoord0.xy * 10.0000);
  xlv_TEXCOORD6 = (_glesMultiTexCoord0.xy * 200.000);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _Splat3;
uniform sampler2D _Flow;
uniform sampler2D _FarDetail;
uniform sampler2D _Control2;
void main ()
{
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control2, xlv_TEXCOORD0);
  gl_FragData[0] = ((texture2D (_FarDetail, xlv_TEXCOORD2) + 0.500000) * ((texture2D (_Flow, xlv_TEXCOORD1) * tmpvar_1.y) + (texture2D (_Splat3, xlv_TEXCOORD6) * tmpvar_1.x)));
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

varying highp vec2 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;

attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_glesMultiTexCoord0.xy * 350.000);
  xlv_TEXCOORD2 = (_glesMultiTexCoord0.xy * 10.0000);
  xlv_TEXCOORD6 = (_glesMultiTexCoord0.xy * 200.000);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _Splat3;
uniform sampler2D _Flow;
uniform sampler2D _FarDetail;
uniform sampler2D _Control2;
void main ()
{
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control2, xlv_TEXCOORD0);
  gl_FragData[0] = ((texture2D (_FarDetail, xlv_TEXCOORD2) + 0.500000) * ((texture2D (_Flow, xlv_TEXCOORD1) * tmpvar_1.y) + (texture2D (_Splat3, xlv_TEXCOORD6) * tmpvar_1.x)));
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLSL
#ifdef VERTEX
varying vec2 xlv_TEXCOORD6;
varying vec2 xlv_TEXCOORD2;
varying vec2 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;

void main ()
{
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = gl_MultiTexCoord0.xy;
  xlv_TEXCOORD1 = (gl_MultiTexCoord0.xy * 350.000);
  xlv_TEXCOORD2 = (gl_MultiTexCoord0.xy * 10.0000);
  xlv_TEXCOORD6 = (gl_MultiTexCoord0.xy * 200.000);
}


#endif
#ifdef FRAGMENT
varying vec2 xlv_TEXCOORD6;
varying vec2 xlv_TEXCOORD2;
varying vec2 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _Splat3;
uniform sampler2D _Flow;
uniform sampler2D _FarDetail;
uniform sampler2D _Control2;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control2, xlv_TEXCOORD0);
  gl_FragData[0] = ((texture2D (_FarDetail, xlv_TEXCOORD2) + 0.500000) * ((texture2D (_Flow, xlv_TEXCOORD1) * tmpvar_1.y) + (texture2D (_Splat3, xlv_TEXCOORD6) * tmpvar_1.x)));
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
; 8 ALU
def c4, 350.00000000, 10.00000000, 200.00000000, 0
dcl_position0 v0
dcl_texcoord0 v1
mov oT0.xy, v1
mul oT1.xy, v1, c4.x
mul oT2.xy, v1, c4.y
mul oT6.xy, v1, c4.z
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "UnityPerDraw" 336 // 64 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
BindCB "UnityPerDraw" 0
// 7 instructions, 1 temp regs, 0 temp arrays:
// ALU 3 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedfdclkondgfiaecjeolgmoomemphppichabaaaaaaimacaaaaadaaaaaa
cmaaaaaaiaaaaaaacaabaaaaejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklkl
epfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
imaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaaamadaaaaimaaaaaaacaaaaaa
aaaaaaaaadaaaaaaacaaaaaaadamaaaaimaaaaaaagaaaaaaaaaaaaaaadaaaaaa
acaaaaaaamadaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklkl
fdeieefcgeabaaaaeaaaabaafjaaaaaafjaaaaaeegiocaaaaaaaaaaaaeaaaaaa
fpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaabaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadmccabaaaabaaaaaa
gfaaaaaddccabaaaacaaaaaagfaaaaadmccabaaaacaaaaaagiaaaaacabaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaaaaaaaaaabaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaaaaaaaaaagbabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaacaaaaaa
kgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaa
aaaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaakpccabaaa
abaaaaaaegbebaaaabaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaakpedaaaakped
diaaaaakpccabaaaacaaaaaaegbebaaaabaaaaaaaceaaaaaaaaacaebaaaacaeb
aaaaeiedaaaaeieddoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;

attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_glesMultiTexCoord0.xy * 350.000);
  xlv_TEXCOORD2 = (_glesMultiTexCoord0.xy * 10.0000);
  xlv_TEXCOORD6 = (_glesMultiTexCoord0.xy * 200.000);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _Splat3;
uniform sampler2D _Flow;
uniform sampler2D _FarDetail;
uniform sampler2D _Control2;
void main ()
{
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control2, xlv_TEXCOORD0);
  gl_FragData[0] = ((texture2D (_FarDetail, xlv_TEXCOORD2) + 0.500000) * ((texture2D (_Flow, xlv_TEXCOORD1) * tmpvar_1.y) + (texture2D (_Splat3, xlv_TEXCOORD6) * tmpvar_1.x)));
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

varying highp vec2 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;

attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_glesMultiTexCoord0.xy * 350.000);
  xlv_TEXCOORD2 = (_glesMultiTexCoord0.xy * 10.0000);
  xlv_TEXCOORD6 = (_glesMultiTexCoord0.xy * 200.000);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _Splat3;
uniform sampler2D _Flow;
uniform sampler2D _FarDetail;
uniform sampler2D _Control2;
void main ()
{
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control2, xlv_TEXCOORD0);
  gl_FragData[0] = ((texture2D (_FarDetail, xlv_TEXCOORD2) + 0.500000) * ((texture2D (_Flow, xlv_TEXCOORD1) * tmpvar_1.y) + (texture2D (_Splat3, xlv_TEXCOORD6) * tmpvar_1.x)));
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
"!!GLSL
#ifdef VERTEX
varying vec2 xlv_TEXCOORD6;
varying vec2 xlv_TEXCOORD2;
varying vec2 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;

void main ()
{
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = gl_MultiTexCoord0.xy;
  xlv_TEXCOORD1 = (gl_MultiTexCoord0.xy * 350.000);
  xlv_TEXCOORD2 = (gl_MultiTexCoord0.xy * 10.0000);
  xlv_TEXCOORD6 = (gl_MultiTexCoord0.xy * 200.000);
}


#endif
#ifdef FRAGMENT
varying vec2 xlv_TEXCOORD6;
varying vec2 xlv_TEXCOORD2;
varying vec2 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _Splat3;
uniform sampler2D _Flow;
uniform sampler2D _FarDetail;
uniform sampler2D _Control2;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control2, xlv_TEXCOORD0);
  gl_FragData[0] = ((texture2D (_FarDetail, xlv_TEXCOORD2) + 0.500000) * ((texture2D (_Flow, xlv_TEXCOORD1) * tmpvar_1.y) + (texture2D (_Splat3, xlv_TEXCOORD6) * tmpvar_1.x)));
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
; 8 ALU
def c4, 350.00000000, 10.00000000, 200.00000000, 0
dcl_position0 v0
dcl_texcoord0 v1
mov oT0.xy, v1
mul oT1.xy, v1, c4.x
mul oT2.xy, v1, c4.y
mul oT6.xy, v1, c4.z
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "UnityPerDraw" 336 // 64 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
BindCB "UnityPerDraw" 0
// 7 instructions, 1 temp regs, 0 temp arrays:
// ALU 3 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedfdclkondgfiaecjeolgmoomemphppichabaaaaaaimacaaaaadaaaaaa
cmaaaaaaiaaaaaaacaabaaaaejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklkl
epfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
imaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaaamadaaaaimaaaaaaacaaaaaa
aaaaaaaaadaaaaaaacaaaaaaadamaaaaimaaaaaaagaaaaaaaaaaaaaaadaaaaaa
acaaaaaaamadaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklkl
fdeieefcgeabaaaaeaaaabaafjaaaaaafjaaaaaeegiocaaaaaaaaaaaaeaaaaaa
fpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaabaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadmccabaaaabaaaaaa
gfaaaaaddccabaaaacaaaaaagfaaaaadmccabaaaacaaaaaagiaaaaacabaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaaaaaaaaaabaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaaaaaaaaaagbabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaacaaaaaa
kgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaa
aaaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaakpccabaaa
abaaaaaaegbebaaaabaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaakpedaaaakped
diaaaaakpccabaaaacaaaaaaegbebaaaabaaaaaaaceaaaaaaaaacaebaaaacaeb
aaaaeiedaaaaeieddoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;

attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_glesMultiTexCoord0.xy * 350.000);
  xlv_TEXCOORD2 = (_glesMultiTexCoord0.xy * 10.0000);
  xlv_TEXCOORD6 = (_glesMultiTexCoord0.xy * 200.000);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _Splat3;
uniform sampler2D _Flow;
uniform sampler2D _FarDetail;
uniform sampler2D _Control2;
void main ()
{
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control2, xlv_TEXCOORD0);
  gl_FragData[0] = ((texture2D (_FarDetail, xlv_TEXCOORD2) + 0.500000) * ((texture2D (_Flow, xlv_TEXCOORD1) * tmpvar_1.y) + (texture2D (_Splat3, xlv_TEXCOORD6) * tmpvar_1.x)));
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

varying highp vec2 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;

attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_glesMultiTexCoord0.xy * 350.000);
  xlv_TEXCOORD2 = (_glesMultiTexCoord0.xy * 10.0000);
  xlv_TEXCOORD6 = (_glesMultiTexCoord0.xy * 200.000);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _Splat3;
uniform sampler2D _Flow;
uniform sampler2D _FarDetail;
uniform sampler2D _Control2;
void main ()
{
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control2, xlv_TEXCOORD0);
  gl_FragData[0] = ((texture2D (_FarDetail, xlv_TEXCOORD2) + 0.500000) * ((texture2D (_Flow, xlv_TEXCOORD1) * tmpvar_1.y) + (texture2D (_Splat3, xlv_TEXCOORD6) * tmpvar_1.x)));
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
"!!GLSL
#ifdef VERTEX
varying vec2 xlv_TEXCOORD6;
varying vec2 xlv_TEXCOORD2;
varying vec2 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;

void main ()
{
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = gl_MultiTexCoord0.xy;
  xlv_TEXCOORD1 = (gl_MultiTexCoord0.xy * 350.000);
  xlv_TEXCOORD2 = (gl_MultiTexCoord0.xy * 10.0000);
  xlv_TEXCOORD6 = (gl_MultiTexCoord0.xy * 200.000);
}


#endif
#ifdef FRAGMENT
varying vec2 xlv_TEXCOORD6;
varying vec2 xlv_TEXCOORD2;
varying vec2 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _Splat3;
uniform sampler2D _Flow;
uniform sampler2D _FarDetail;
uniform sampler2D _Control2;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control2, xlv_TEXCOORD0);
  gl_FragData[0] = ((texture2D (_FarDetail, xlv_TEXCOORD2) + 0.500000) * ((texture2D (_Flow, xlv_TEXCOORD1) * tmpvar_1.y) + (texture2D (_Splat3, xlv_TEXCOORD6) * tmpvar_1.x)));
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
; 8 ALU
def c4, 350.00000000, 10.00000000, 200.00000000, 0
dcl_position0 v0
dcl_texcoord0 v1
mov oT0.xy, v1
mul oT1.xy, v1, c4.x
mul oT2.xy, v1, c4.y
mul oT6.xy, v1, c4.z
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "UnityPerDraw" 336 // 64 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
BindCB "UnityPerDraw" 0
// 7 instructions, 1 temp regs, 0 temp arrays:
// ALU 3 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedfdclkondgfiaecjeolgmoomemphppichabaaaaaaimacaaaaadaaaaaa
cmaaaaaaiaaaaaaacaabaaaaejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklkl
epfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
imaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaaamadaaaaimaaaaaaacaaaaaa
aaaaaaaaadaaaaaaacaaaaaaadamaaaaimaaaaaaagaaaaaaaaaaaaaaadaaaaaa
acaaaaaaamadaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklkl
fdeieefcgeabaaaaeaaaabaafjaaaaaafjaaaaaeegiocaaaaaaaaaaaaeaaaaaa
fpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaabaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadmccabaaaabaaaaaa
gfaaaaaddccabaaaacaaaaaagfaaaaadmccabaaaacaaaaaagiaaaaacabaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaaaaaaaaaabaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaaaaaaaaaagbabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaacaaaaaa
kgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaa
aaaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaakpccabaaa
abaaaaaaegbebaaaabaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaakpedaaaakped
diaaaaakpccabaaaacaaaaaaegbebaaaabaaaaaaaceaaaaaaaaacaebaaaacaeb
aaaaeiedaaaaeieddoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;

attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_glesMultiTexCoord0.xy * 350.000);
  xlv_TEXCOORD2 = (_glesMultiTexCoord0.xy * 10.0000);
  xlv_TEXCOORD6 = (_glesMultiTexCoord0.xy * 200.000);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _Splat3;
uniform sampler2D _Flow;
uniform sampler2D _FarDetail;
uniform sampler2D _Control2;
void main ()
{
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control2, xlv_TEXCOORD0);
  gl_FragData[0] = ((texture2D (_FarDetail, xlv_TEXCOORD2) + 0.500000) * ((texture2D (_Flow, xlv_TEXCOORD1) * tmpvar_1.y) + (texture2D (_Splat3, xlv_TEXCOORD6) * tmpvar_1.x)));
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

varying highp vec2 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;

attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_glesMultiTexCoord0.xy * 350.000);
  xlv_TEXCOORD2 = (_glesMultiTexCoord0.xy * 10.0000);
  xlv_TEXCOORD6 = (_glesMultiTexCoord0.xy * 200.000);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _Splat3;
uniform sampler2D _Flow;
uniform sampler2D _FarDetail;
uniform sampler2D _Control2;
void main ()
{
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control2, xlv_TEXCOORD0);
  gl_FragData[0] = ((texture2D (_FarDetail, xlv_TEXCOORD2) + 0.500000) * ((texture2D (_Flow, xlv_TEXCOORD1) * tmpvar_1.y) + (texture2D (_Splat3, xlv_TEXCOORD6) * tmpvar_1.x)));
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
// 7 instructions, 1 temp regs, 0 temp arrays:
// ALU 3 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_3
eefiecedmcncklfebkaahmndcgfdlnpofcehnnocabaaaaaajaadaaaaaeaaaaaa
daaaaaaadaabaaaajmacaaaapaacaaaaebgpgodjpiaaaaaapiaaaaaaaaacpopp
meaaaaaadeaaaaaaabaaceaaaaaadaaaaaaadaaaaaaaceaaabaadaaaaaaaaaaa
aeaaabaaaaaaaaaaaaaaaaaaabacpoppfbaaaaafafaaapkaaaaacaebaaaaeied
aaaaiadpaaaakpedbpaaaaacafaaaaiaaaaaapjabpaaaaacafaaabiaabaaapja
afaaaaadabaaapoaabaabejaafaafakaafaaaaadaaaaapiaaaaaffjaacaaoeka
aeaaaaaeaaaaapiaabaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapiaadaaoeka
aaaakkjaaaaaoeiaaeaaaaaeaaaaapiaaeaaoekaaaaappjaaaaaoeiaaeaaaaae
aaaaadmaaaaappiaaaaaoekaaaaaoeiaabaaaaacaaaaammaaaaaoeiaafaaaaad
aaaaapoaabaabejaafaapkkappppaaaafdeieefcgeabaaaaeaaaabaafjaaaaaa
fjaaaaaeegiocaaaaaaaaaaaaeaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaad
dcbabaaaabaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaa
abaaaaaagfaaaaadmccabaaaabaaaaaagfaaaaaddccabaaaacaaaaaagfaaaaad
mccabaaaacaaaaaagiaaaaacabaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaaaaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
aaaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaaaaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpccabaaaaaaaaaaaegiocaaaaaaaaaaaadaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadiaaaaakpccabaaaabaaaaaaegbebaaaabaaaaaaaceaaaaa
aaaaiadpaaaaiadpaaaakpedaaaakpeddiaaaaakpccabaaaacaaaaaaegbebaaa
abaaaaaaaceaaaaaaaaacaebaaaacaebaaaaeiedaaaaeieddoaaaaabejfdeheo
emaaaaaaacaaaaaaaiaaaaaadiaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apapaaaaebaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadadaaaafaepfdej
feejepeoaafeeffiedepepfceeaaklklepfdeheojiaaaaaaafaaaaaaaiaaaaaa
iaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaabaaaaaaadamaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaa
abaaaaaaamadaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaadamaaaa
imaaaaaaagaaaaaaaaaaaaaaadaaaaaaacaaaaaaamadaaaafdfgfpfaepfdejfe
ejepeoaafeeffiedepepfceeaaklklkl"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
"!!GLSL
#ifdef VERTEX
varying vec2 xlv_TEXCOORD6;
varying vec2 xlv_TEXCOORD2;
varying vec2 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;

void main ()
{
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = gl_MultiTexCoord0.xy;
  xlv_TEXCOORD1 = (gl_MultiTexCoord0.xy * 350.000);
  xlv_TEXCOORD2 = (gl_MultiTexCoord0.xy * 10.0000);
  xlv_TEXCOORD6 = (gl_MultiTexCoord0.xy * 200.000);
}


#endif
#ifdef FRAGMENT
varying vec2 xlv_TEXCOORD6;
varying vec2 xlv_TEXCOORD2;
varying vec2 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _Splat3;
uniform sampler2D _Flow;
uniform sampler2D _FarDetail;
uniform sampler2D _Control2;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control2, xlv_TEXCOORD0);
  gl_FragData[0] = ((texture2D (_FarDetail, xlv_TEXCOORD2) + 0.500000) * ((texture2D (_Flow, xlv_TEXCOORD1) * tmpvar_1.y) + (texture2D (_Splat3, xlv_TEXCOORD6) * tmpvar_1.x)));
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
; 8 ALU
def c4, 350.00000000, 10.00000000, 200.00000000, 0
dcl_position0 v0
dcl_texcoord0 v1
mov oT0.xy, v1
mul oT1.xy, v1, c4.x
mul oT2.xy, v1, c4.y
mul oT6.xy, v1, c4.z
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "UnityPerDraw" 336 // 64 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
BindCB "UnityPerDraw" 0
// 7 instructions, 1 temp regs, 0 temp arrays:
// ALU 3 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedfdclkondgfiaecjeolgmoomemphppichabaaaaaaimacaaaaadaaaaaa
cmaaaaaaiaaaaaaacaabaaaaejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklkl
epfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
imaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaaamadaaaaimaaaaaaacaaaaaa
aaaaaaaaadaaaaaaacaaaaaaadamaaaaimaaaaaaagaaaaaaaaaaaaaaadaaaaaa
acaaaaaaamadaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklkl
fdeieefcgeabaaaaeaaaabaafjaaaaaafjaaaaaeegiocaaaaaaaaaaaaeaaaaaa
fpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaabaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadmccabaaaabaaaaaa
gfaaaaaddccabaaaacaaaaaagfaaaaadmccabaaaacaaaaaagiaaaaacabaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaaaaaaaaaabaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaaaaaaaaaagbabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaacaaaaaa
kgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaa
aaaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaakpccabaaa
abaaaaaaegbebaaaabaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaakpedaaaakped
diaaaaakpccabaaaacaaaaaaegbebaaaabaaaaaaaceaaaaaaaaacaebaaaacaeb
aaaaeiedaaaaeieddoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;

attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_glesMultiTexCoord0.xy * 350.000);
  xlv_TEXCOORD2 = (_glesMultiTexCoord0.xy * 10.0000);
  xlv_TEXCOORD6 = (_glesMultiTexCoord0.xy * 200.000);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _Splat3;
uniform sampler2D _Flow;
uniform sampler2D _FarDetail;
uniform sampler2D _Control2;
void main ()
{
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control2, xlv_TEXCOORD0);
  gl_FragData[0] = ((texture2D (_FarDetail, xlv_TEXCOORD2) + 0.500000) * ((texture2D (_Flow, xlv_TEXCOORD1) * tmpvar_1.y) + (texture2D (_Splat3, xlv_TEXCOORD6) * tmpvar_1.x)));
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

varying highp vec2 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;

attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = (_glesMultiTexCoord0.xy * 350.000);
  xlv_TEXCOORD2 = (_glesMultiTexCoord0.xy * 10.0000);
  xlv_TEXCOORD6 = (_glesMultiTexCoord0.xy * 200.000);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD6;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _Splat3;
uniform sampler2D _Flow;
uniform sampler2D _FarDetail;
uniform sampler2D _Control2;
void main ()
{
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_Control2, xlv_TEXCOORD0);
  gl_FragData[0] = ((texture2D (_FarDetail, xlv_TEXCOORD2) + 0.500000) * ((texture2D (_Flow, xlv_TEXCOORD1) * tmpvar_1.y) + (texture2D (_Splat3, xlv_TEXCOORD6) * tmpvar_1.x)));
}



#endif"
}

}
Program "fp" {
// Fragment combos: 6
//   d3d9 - ALU: 5 to 5, TEX: 4 to 4
//   d3d11 - ALU: 3 to 3, TEX: 4 to 4, FLOW: 1 to 1
//   d3d11_9x - ALU: 3 to 3, TEX: 4 to 4, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
SetTexture 0 [_Flow] 2D
SetTexture 1 [_FarDetail] 2D
SetTexture 2 [_Splat3] 2D
SetTexture 3 [_Control2] 2D
"ps_2_0
; 5 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c0, 0.50000000, 0, 0, 0
dcl t0.xy
dcl t1.xy
dcl t2.xy
dcl t6.xy
texld r0, t0, s3
texld r3, t1, s0
texld r2, t2, s1
texld r1, t6, s2
mul_pp r1, r0.x, r1
mad_pp r0, r3, r0.y, r1
add r1, r2, c0.x
mul_pp r0, r1, r0
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
SetTexture 0 [_Flow] 2D 1
SetTexture 1 [_FarDetail] 2D 2
SetTexture 2 [_Splat3] 2D 3
SetTexture 3 [_Control2] 2D 0
// 9 instructions, 3 temp regs, 0 temp arrays:
// ALU 3 float, 0 int, 0 uint
// TEX 4 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedcglglapmneknpopeafgmendlhaelaaehabaaaaaanmacaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaadadaaaaimaaaaaa
agaaaaaaaaaaaaaaadaaaaaaacaaaaaaamamaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefcneabaaaaeaaaaaaahfaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaa
fibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaa
fibiaaaeaahabaaaacaaaaaaffffaaaafibiaaaeaahabaaaadaaaaaaffffaaaa
gcbaaaaddcbabaaaabaaaaaagcbaaaadmcbabaaaabaaaaaagcbaaaaddcbabaaa
acaaaaaagcbaaaadmcbabaaaacaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaac
adaaaaaaefaaaaajpcaabaaaaaaaaaaaogbkbaaaabaaaaaaeghobaaaaaaaaaaa
aagabaaaabaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaaacaaaaaaeghobaaa
acaaaaaaaagabaaaadaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaabaaaaaa
eghobaaaadaaaaaaaagabaaaaaaaaaaadiaaaaahpcaabaaaabaaaaaaegaobaaa
abaaaaaaagaabaaaacaaaaaadcaaaaajpcaabaaaaaaaaaaaegaobaaaaaaaaaaa
fgafbaaaacaaaaaaegaobaaaabaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaa
acaaaaaaeghobaaaabaaaaaaaagabaaaacaaaaaaaaaaaaakpcaabaaaabaaaaaa
egaobaaaabaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaadpaaaaaadpdiaaaaah
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
SetTexture 0 [_Flow] 2D 1
SetTexture 1 [_FarDetail] 2D 2
SetTexture 2 [_Splat3] 2D 3
SetTexture 3 [_Control2] 2D 0
// 9 instructions, 3 temp regs, 0 temp arrays:
// ALU 3 float, 0 int, 0 uint
// TEX 4 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_3
eefiecedambbkdmgbbdbffmlfhpoefemidjnhkiaabaaaaaacmaeaaaaaeaaaaaa
daaaaaaahmabaaaafiadaaaapiadaaaaebgpgodjeeabaaaaeeabaaaaaaacpppp
baabaaaadeaaaaaaaaaadeaaaaaadeaaaaaadeaaaeaaceaaaaaadeaaadaaaaaa
aaababaaabacacaaacadadaaabacppppfbaaaaafaaaaapkaaaaaaadpaaaaaaaa
aaaaaaaaaaaaaaaabpaaaaacaaaaaaiaaaaaaplabpaaaaacaaaaaaiaabaaapla
bpaaaaacaaaaaajaaaaiapkabpaaaaacaaaaaajaabaiapkabpaaaaacaaaaaaja
acaiapkabpaaaaacaaaaaajaadaiapkaabaaaaacaaaaadiaaaaaollaecaaaaad
abaaapiaabaaoelaacaioekaecaaaaadaaaacpiaaaaaoeiaabaioekaabaaaaac
acaaadiaabaaollaecaaaaadadaacpiaaaaaoelaaaaioekaecaaaaadacaacpia
acaaoeiaadaioekaafaaaaadacaacpiaadaaaaiaacaaoeiaaeaaaaaeaaaacpia
aaaaoeiaadaaffiaacaaoeiaacaaaaadabaacpiaabaaoeiaaaaaaakaafaaaaad
aaaacpiaaaaaoeiaabaaoeiaabaaaaacaaaicpiaaaaaoeiappppaaaafdeieefc
neabaaaaeaaaaaaahfaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaa
abaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaafibiaaae
aahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaae
aahabaaaacaaaaaaffffaaaafibiaaaeaahabaaaadaaaaaaffffaaaagcbaaaad
dcbabaaaabaaaaaagcbaaaadmcbabaaaabaaaaaagcbaaaaddcbabaaaacaaaaaa
gcbaaaadmcbabaaaacaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaa
efaaaaajpcaabaaaaaaaaaaaogbkbaaaabaaaaaaeghobaaaaaaaaaaaaagabaaa
abaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaaacaaaaaaeghobaaaacaaaaaa
aagabaaaadaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaabaaaaaaeghobaaa
adaaaaaaaagabaaaaaaaaaaadiaaaaahpcaabaaaabaaaaaaegaobaaaabaaaaaa
agaabaaaacaaaaaadcaaaaajpcaabaaaaaaaaaaaegaobaaaaaaaaaaafgafbaaa
acaaaaaaegaobaaaabaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaacaaaaaa
eghobaaaabaaaaaaaagabaaaacaaaaaaaaaaaaakpcaabaaaabaaaaaaegaobaaa
abaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaadpaaaaaadpdiaaaaahpccabaaa
aaaaaaaaegaobaaaaaaaaaaaegaobaaaabaaaaaadoaaaaabejfdeheojiaaaaaa
afaaaaaaaiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaa
imaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadadaaaaimaaaaaaabaaaaaa
aaaaaaaaadaaaaaaabaaaaaaamamaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaa
acaaaaaaadadaaaaimaaaaaaagaaaaaaaaaaaaaaadaaaaaaacaaaaaaamamaaaa
fdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaa
abaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaa
fdfgfpfegbhcghgfheaaklkl"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
SetTexture 0 [_Flow] 2D
SetTexture 1 [_FarDetail] 2D
SetTexture 2 [_Splat3] 2D
SetTexture 3 [_Control2] 2D
"ps_2_0
; 5 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c0, 0.50000000, 0, 0, 0
dcl t0.xy
dcl t1.xy
dcl t2.xy
dcl t6.xy
texld r0, t0, s3
texld r3, t1, s0
texld r2, t2, s1
texld r1, t6, s2
mul_pp r1, r0.x, r1
mad_pp r0, r3, r0.y, r1
add r1, r2, c0.x
mul_pp r0, r1, r0
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
SetTexture 0 [_Flow] 2D 1
SetTexture 1 [_FarDetail] 2D 2
SetTexture 2 [_Splat3] 2D 3
SetTexture 3 [_Control2] 2D 0
// 9 instructions, 3 temp regs, 0 temp arrays:
// ALU 3 float, 0 int, 0 uint
// TEX 4 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedcglglapmneknpopeafgmendlhaelaaehabaaaaaanmacaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaadadaaaaimaaaaaa
agaaaaaaaaaaaaaaadaaaaaaacaaaaaaamamaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefcneabaaaaeaaaaaaahfaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaa
fibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaa
fibiaaaeaahabaaaacaaaaaaffffaaaafibiaaaeaahabaaaadaaaaaaffffaaaa
gcbaaaaddcbabaaaabaaaaaagcbaaaadmcbabaaaabaaaaaagcbaaaaddcbabaaa
acaaaaaagcbaaaadmcbabaaaacaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaac
adaaaaaaefaaaaajpcaabaaaaaaaaaaaogbkbaaaabaaaaaaeghobaaaaaaaaaaa
aagabaaaabaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaaacaaaaaaeghobaaa
acaaaaaaaagabaaaadaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaabaaaaaa
eghobaaaadaaaaaaaagabaaaaaaaaaaadiaaaaahpcaabaaaabaaaaaaegaobaaa
abaaaaaaagaabaaaacaaaaaadcaaaaajpcaabaaaaaaaaaaaegaobaaaaaaaaaaa
fgafbaaaacaaaaaaegaobaaaabaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaa
acaaaaaaeghobaaaabaaaaaaaagabaaaacaaaaaaaaaaaaakpcaabaaaabaaaaaa
egaobaaaabaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaadpaaaaaadpdiaaaaah
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
SetTexture 0 [_Flow] 2D 1
SetTexture 1 [_FarDetail] 2D 2
SetTexture 2 [_Splat3] 2D 3
SetTexture 3 [_Control2] 2D 0
// 9 instructions, 3 temp regs, 0 temp arrays:
// ALU 3 float, 0 int, 0 uint
// TEX 4 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_3
eefiecedambbkdmgbbdbffmlfhpoefemidjnhkiaabaaaaaacmaeaaaaaeaaaaaa
daaaaaaahmabaaaafiadaaaapiadaaaaebgpgodjeeabaaaaeeabaaaaaaacpppp
baabaaaadeaaaaaaaaaadeaaaaaadeaaaaaadeaaaeaaceaaaaaadeaaadaaaaaa
aaababaaabacacaaacadadaaabacppppfbaaaaafaaaaapkaaaaaaadpaaaaaaaa
aaaaaaaaaaaaaaaabpaaaaacaaaaaaiaaaaaaplabpaaaaacaaaaaaiaabaaapla
bpaaaaacaaaaaajaaaaiapkabpaaaaacaaaaaajaabaiapkabpaaaaacaaaaaaja
acaiapkabpaaaaacaaaaaajaadaiapkaabaaaaacaaaaadiaaaaaollaecaaaaad
abaaapiaabaaoelaacaioekaecaaaaadaaaacpiaaaaaoeiaabaioekaabaaaaac
acaaadiaabaaollaecaaaaadadaacpiaaaaaoelaaaaioekaecaaaaadacaacpia
acaaoeiaadaioekaafaaaaadacaacpiaadaaaaiaacaaoeiaaeaaaaaeaaaacpia
aaaaoeiaadaaffiaacaaoeiaacaaaaadabaacpiaabaaoeiaaaaaaakaafaaaaad
aaaacpiaaaaaoeiaabaaoeiaabaaaaacaaaicpiaaaaaoeiappppaaaafdeieefc
neabaaaaeaaaaaaahfaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaa
abaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaafibiaaae
aahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaae
aahabaaaacaaaaaaffffaaaafibiaaaeaahabaaaadaaaaaaffffaaaagcbaaaad
dcbabaaaabaaaaaagcbaaaadmcbabaaaabaaaaaagcbaaaaddcbabaaaacaaaaaa
gcbaaaadmcbabaaaacaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaa
efaaaaajpcaabaaaaaaaaaaaogbkbaaaabaaaaaaeghobaaaaaaaaaaaaagabaaa
abaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaaacaaaaaaeghobaaaacaaaaaa
aagabaaaadaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaabaaaaaaeghobaaa
adaaaaaaaagabaaaaaaaaaaadiaaaaahpcaabaaaabaaaaaaegaobaaaabaaaaaa
agaabaaaacaaaaaadcaaaaajpcaabaaaaaaaaaaaegaobaaaaaaaaaaafgafbaaa
acaaaaaaegaobaaaabaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaacaaaaaa
eghobaaaabaaaaaaaagabaaaacaaaaaaaaaaaaakpcaabaaaabaaaaaaegaobaaa
abaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaadpaaaaaadpdiaaaaahpccabaaa
aaaaaaaaegaobaaaaaaaaaaaegaobaaaabaaaaaadoaaaaabejfdeheojiaaaaaa
afaaaaaaaiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaa
imaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadadaaaaimaaaaaaabaaaaaa
aaaaaaaaadaaaaaaabaaaaaaamamaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaa
acaaaaaaadadaaaaimaaaaaaagaaaaaaaaaaaaaaadaaaaaaacaaaaaaamamaaaa
fdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaa
abaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaa
fdfgfpfegbhcghgfheaaklkl"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
SetTexture 0 [_Flow] 2D
SetTexture 1 [_FarDetail] 2D
SetTexture 2 [_Splat3] 2D
SetTexture 3 [_Control2] 2D
"ps_2_0
; 5 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c0, 0.50000000, 0, 0, 0
dcl t0.xy
dcl t1.xy
dcl t2.xy
dcl t6.xy
texld r0, t0, s3
texld r3, t1, s0
texld r2, t2, s1
texld r1, t6, s2
mul_pp r1, r0.x, r1
mad_pp r0, r3, r0.y, r1
add r1, r2, c0.x
mul_pp r0, r1, r0
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
SetTexture 0 [_Flow] 2D 1
SetTexture 1 [_FarDetail] 2D 2
SetTexture 2 [_Splat3] 2D 3
SetTexture 3 [_Control2] 2D 0
// 9 instructions, 3 temp regs, 0 temp arrays:
// ALU 3 float, 0 int, 0 uint
// TEX 4 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedcglglapmneknpopeafgmendlhaelaaehabaaaaaanmacaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaadadaaaaimaaaaaa
agaaaaaaaaaaaaaaadaaaaaaacaaaaaaamamaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefcneabaaaaeaaaaaaahfaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaa
fibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaa
fibiaaaeaahabaaaacaaaaaaffffaaaafibiaaaeaahabaaaadaaaaaaffffaaaa
gcbaaaaddcbabaaaabaaaaaagcbaaaadmcbabaaaabaaaaaagcbaaaaddcbabaaa
acaaaaaagcbaaaadmcbabaaaacaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaac
adaaaaaaefaaaaajpcaabaaaaaaaaaaaogbkbaaaabaaaaaaeghobaaaaaaaaaaa
aagabaaaabaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaaacaaaaaaeghobaaa
acaaaaaaaagabaaaadaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaabaaaaaa
eghobaaaadaaaaaaaagabaaaaaaaaaaadiaaaaahpcaabaaaabaaaaaaegaobaaa
abaaaaaaagaabaaaacaaaaaadcaaaaajpcaabaaaaaaaaaaaegaobaaaaaaaaaaa
fgafbaaaacaaaaaaegaobaaaabaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaa
acaaaaaaeghobaaaabaaaaaaaagabaaaacaaaaaaaaaaaaakpcaabaaaabaaaaaa
egaobaaaabaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaadpaaaaaadpdiaaaaah
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
SetTexture 0 [_Flow] 2D 1
SetTexture 1 [_FarDetail] 2D 2
SetTexture 2 [_Splat3] 2D 3
SetTexture 3 [_Control2] 2D 0
// 9 instructions, 3 temp regs, 0 temp arrays:
// ALU 3 float, 0 int, 0 uint
// TEX 4 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_3
eefiecedambbkdmgbbdbffmlfhpoefemidjnhkiaabaaaaaacmaeaaaaaeaaaaaa
daaaaaaahmabaaaafiadaaaapiadaaaaebgpgodjeeabaaaaeeabaaaaaaacpppp
baabaaaadeaaaaaaaaaadeaaaaaadeaaaaaadeaaaeaaceaaaaaadeaaadaaaaaa
aaababaaabacacaaacadadaaabacppppfbaaaaafaaaaapkaaaaaaadpaaaaaaaa
aaaaaaaaaaaaaaaabpaaaaacaaaaaaiaaaaaaplabpaaaaacaaaaaaiaabaaapla
bpaaaaacaaaaaajaaaaiapkabpaaaaacaaaaaajaabaiapkabpaaaaacaaaaaaja
acaiapkabpaaaaacaaaaaajaadaiapkaabaaaaacaaaaadiaaaaaollaecaaaaad
abaaapiaabaaoelaacaioekaecaaaaadaaaacpiaaaaaoeiaabaioekaabaaaaac
acaaadiaabaaollaecaaaaadadaacpiaaaaaoelaaaaioekaecaaaaadacaacpia
acaaoeiaadaioekaafaaaaadacaacpiaadaaaaiaacaaoeiaaeaaaaaeaaaacpia
aaaaoeiaadaaffiaacaaoeiaacaaaaadabaacpiaabaaoeiaaaaaaakaafaaaaad
aaaacpiaaaaaoeiaabaaoeiaabaaaaacaaaicpiaaaaaoeiappppaaaafdeieefc
neabaaaaeaaaaaaahfaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaa
abaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaafibiaaae
aahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaae
aahabaaaacaaaaaaffffaaaafibiaaaeaahabaaaadaaaaaaffffaaaagcbaaaad
dcbabaaaabaaaaaagcbaaaadmcbabaaaabaaaaaagcbaaaaddcbabaaaacaaaaaa
gcbaaaadmcbabaaaacaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaa
efaaaaajpcaabaaaaaaaaaaaogbkbaaaabaaaaaaeghobaaaaaaaaaaaaagabaaa
abaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaaacaaaaaaeghobaaaacaaaaaa
aagabaaaadaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaabaaaaaaeghobaaa
adaaaaaaaagabaaaaaaaaaaadiaaaaahpcaabaaaabaaaaaaegaobaaaabaaaaaa
agaabaaaacaaaaaadcaaaaajpcaabaaaaaaaaaaaegaobaaaaaaaaaaafgafbaaa
acaaaaaaegaobaaaabaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaacaaaaaa
eghobaaaabaaaaaaaagabaaaacaaaaaaaaaaaaakpcaabaaaabaaaaaaegaobaaa
abaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaadpaaaaaadpdiaaaaahpccabaaa
aaaaaaaaegaobaaaaaaaaaaaegaobaaaabaaaaaadoaaaaabejfdeheojiaaaaaa
afaaaaaaaiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaa
imaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadadaaaaimaaaaaaabaaaaaa
aaaaaaaaadaaaaaaabaaaaaaamamaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaa
acaaaaaaadadaaaaimaaaaaaagaaaaaaaaaaaaaaadaaaaaaacaaaaaaamamaaaa
fdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaa
abaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaa
fdfgfpfegbhcghgfheaaklkl"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
SetTexture 0 [_Flow] 2D
SetTexture 1 [_FarDetail] 2D
SetTexture 2 [_Splat3] 2D
SetTexture 3 [_Control2] 2D
"ps_2_0
; 5 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c0, 0.50000000, 0, 0, 0
dcl t0.xy
dcl t1.xy
dcl t2.xy
dcl t6.xy
texld r0, t0, s3
texld r3, t1, s0
texld r2, t2, s1
texld r1, t6, s2
mul_pp r1, r0.x, r1
mad_pp r0, r3, r0.y, r1
add r1, r2, c0.x
mul_pp r0, r1, r0
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
SetTexture 0 [_Flow] 2D 1
SetTexture 1 [_FarDetail] 2D 2
SetTexture 2 [_Splat3] 2D 3
SetTexture 3 [_Control2] 2D 0
// 9 instructions, 3 temp regs, 0 temp arrays:
// ALU 3 float, 0 int, 0 uint
// TEX 4 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedcglglapmneknpopeafgmendlhaelaaehabaaaaaanmacaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaadadaaaaimaaaaaa
agaaaaaaaaaaaaaaadaaaaaaacaaaaaaamamaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefcneabaaaaeaaaaaaahfaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaa
fibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaa
fibiaaaeaahabaaaacaaaaaaffffaaaafibiaaaeaahabaaaadaaaaaaffffaaaa
gcbaaaaddcbabaaaabaaaaaagcbaaaadmcbabaaaabaaaaaagcbaaaaddcbabaaa
acaaaaaagcbaaaadmcbabaaaacaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaac
adaaaaaaefaaaaajpcaabaaaaaaaaaaaogbkbaaaabaaaaaaeghobaaaaaaaaaaa
aagabaaaabaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaaacaaaaaaeghobaaa
acaaaaaaaagabaaaadaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaabaaaaaa
eghobaaaadaaaaaaaagabaaaaaaaaaaadiaaaaahpcaabaaaabaaaaaaegaobaaa
abaaaaaaagaabaaaacaaaaaadcaaaaajpcaabaaaaaaaaaaaegaobaaaaaaaaaaa
fgafbaaaacaaaaaaegaobaaaabaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaa
acaaaaaaeghobaaaabaaaaaaaagabaaaacaaaaaaaaaaaaakpcaabaaaabaaaaaa
egaobaaaabaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaadpaaaaaadpdiaaaaah
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
SetTexture 0 [_Flow] 2D
SetTexture 1 [_FarDetail] 2D
SetTexture 2 [_Splat3] 2D
SetTexture 3 [_Control2] 2D
"ps_2_0
; 5 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c0, 0.50000000, 0, 0, 0
dcl t0.xy
dcl t1.xy
dcl t2.xy
dcl t6.xy
texld r0, t0, s3
texld r3, t1, s0
texld r2, t2, s1
texld r1, t6, s2
mul_pp r1, r0.x, r1
mad_pp r0, r3, r0.y, r1
add r1, r2, c0.x
mul_pp r0, r1, r0
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
SetTexture 0 [_Flow] 2D 1
SetTexture 1 [_FarDetail] 2D 2
SetTexture 2 [_Splat3] 2D 3
SetTexture 3 [_Control2] 2D 0
// 9 instructions, 3 temp regs, 0 temp arrays:
// ALU 3 float, 0 int, 0 uint
// TEX 4 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedcglglapmneknpopeafgmendlhaelaaehabaaaaaanmacaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaadadaaaaimaaaaaa
agaaaaaaaaaaaaaaadaaaaaaacaaaaaaamamaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefcneabaaaaeaaaaaaahfaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaa
fibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaa
fibiaaaeaahabaaaacaaaaaaffffaaaafibiaaaeaahabaaaadaaaaaaffffaaaa
gcbaaaaddcbabaaaabaaaaaagcbaaaadmcbabaaaabaaaaaagcbaaaaddcbabaaa
acaaaaaagcbaaaadmcbabaaaacaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaac
adaaaaaaefaaaaajpcaabaaaaaaaaaaaogbkbaaaabaaaaaaeghobaaaaaaaaaaa
aagabaaaabaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaaacaaaaaaeghobaaa
acaaaaaaaagabaaaadaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaabaaaaaa
eghobaaaadaaaaaaaagabaaaaaaaaaaadiaaaaahpcaabaaaabaaaaaaegaobaaa
abaaaaaaagaabaaaacaaaaaadcaaaaajpcaabaaaaaaaaaaaegaobaaaaaaaaaaa
fgafbaaaacaaaaaaegaobaaaabaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaa
acaaaaaaeghobaaaabaaaaaaaagabaaaacaaaaaaaaaaaaakpcaabaaaabaaaaaa
egaobaaaabaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaadpaaaaaadpdiaaaaah
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
SetTexture 0 [_Flow] 2D
SetTexture 1 [_FarDetail] 2D
SetTexture 2 [_Splat3] 2D
SetTexture 3 [_Control2] 2D
"ps_2_0
; 5 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c0, 0.50000000, 0, 0, 0
dcl t0.xy
dcl t1.xy
dcl t2.xy
dcl t6.xy
texld r0, t0, s3
texld r3, t1, s0
texld r2, t2, s1
texld r1, t6, s2
mul_pp r1, r0.x, r1
mad_pp r0, r3, r0.y, r1
add r1, r2, c0.x
mul_pp r0, r1, r0
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
SetTexture 0 [_Flow] 2D 1
SetTexture 1 [_FarDetail] 2D 2
SetTexture 2 [_Splat3] 2D 3
SetTexture 3 [_Control2] 2D 0
// 9 instructions, 3 temp regs, 0 temp arrays:
// ALU 3 float, 0 int, 0 uint
// TEX 4 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedcglglapmneknpopeafgmendlhaelaaehabaaaaaanmacaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaa
amamaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaacaaaaaaadadaaaaimaaaaaa
agaaaaaaaaaaaaaaadaaaaaaacaaaaaaamamaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefcneabaaaaeaaaaaaahfaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaa
fibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaa
fibiaaaeaahabaaaacaaaaaaffffaaaafibiaaaeaahabaaaadaaaaaaffffaaaa
gcbaaaaddcbabaaaabaaaaaagcbaaaadmcbabaaaabaaaaaagcbaaaaddcbabaaa
acaaaaaagcbaaaadmcbabaaaacaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaac
adaaaaaaefaaaaajpcaabaaaaaaaaaaaogbkbaaaabaaaaaaeghobaaaaaaaaaaa
aagabaaaabaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaaacaaaaaaeghobaaa
acaaaaaaaagabaaaadaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaabaaaaaa
eghobaaaadaaaaaaaagabaaaaaaaaaaadiaaaaahpcaabaaaabaaaaaaegaobaaa
abaaaaaaagaabaaaacaaaaaadcaaaaajpcaabaaaaaaaaaaaegaobaaaaaaaaaaa
fgafbaaaacaaaaaaegaobaaaabaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaa
acaaaaaaeghobaaaabaaaaaaaagabaaaacaaaaaaaaaaaaakpcaabaaaabaaaaaa
egaobaaaabaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaadpaaaaaadpdiaaaaah
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

#LINE 216


    }
 
// ====================== PASS THREE (LIGHT) ======================================

Pass {
    //Fog {Mode Off}
    Fog { Color ( 1.0,1.0,1.0 ) }
    Lighting On
    Tags {"LightMode" = "ForwardBase"}
    //Blend OneMinusDstAlpha DstAlpha
    Blend Zero SrcColor
    //Blend One One

	Program "vp" {
// Vertex combos: 8
//   d3d9 - ALU: 5 to 10
//   d3d11 - ALU: 1 to 4, TEX: 0 to 0, FLOW: 1 to 1
//   d3d11_9x - ALU: 1 to 1, TEX: 0 to 0, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLSL
#ifdef VERTEX
varying vec2 xlv_TEXCOORD0;

void main ()
{
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = gl_MultiTexCoord0.xy;
}


#endif
#ifdef FRAGMENT
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _LM;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = texture2D (_LM, xlv_TEXCOORD0);
  gl_FragData[0] = min (((8.00000 * tmpvar_1.w) * tmpvar_1), vec4(1.00000, 1.00000, 1.00000, 1.00000));
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
; 5 ALU
dcl_position0 v0
dcl_texcoord0 v1
mov oT0.xy, v1
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "UnityPerDraw" 336 // 64 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
BindCB "UnityPerDraw" 0
// 6 instructions, 1 temp regs, 0 temp arrays:
// ALU 1 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedaffpdldohodkdgpagjklpapmmnbhcfmlabaaaaaaoeabaaaaadaaaaaa
cmaaaaaaiaaaaaaaniaaaaaaejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklkl
epfdeheofaaaaaaaacaaaaaaaiaaaaaadiaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaaeeaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
fdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcaeabaaaa
eaaaabaaebaaaaaafjaaaaaeegiocaaaaaaaaaaaaeaaaaaafpaaaaadpcbabaaa
aaaaaaaafpaaaaaddcbabaaaabaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaaddccabaaaabaaaaaagiaaaaacabaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaaaaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaaaaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaaaaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaaaaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadgaaaaafdccabaaaabaaaaaaegbabaaaabaaaaaa
doaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD0;

attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _LM;
void main ()
{
  lowp vec4 lm2_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = (2.00000 * texture2D (_LM, xlv_TEXCOORD0));
  highp vec4 tmpvar_3;
  tmpvar_3 = min (tmpvar_2, vec4(1.00000, 1.00000, 1.00000, 1.00000));
  lm2_1 = tmpvar_3;
  gl_FragData[0] = lm2_1;
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

varying highp vec2 xlv_TEXCOORD0;

attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _LM;
void main ()
{
  lowp vec4 lm2_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_LM, xlv_TEXCOORD0);
  lowp vec4 tmpvar_3;
  tmpvar_3 = ((8.00000 * tmpvar_2.w) * tmpvar_2);
  highp vec4 tmpvar_4;
  tmpvar_4 = min (tmpvar_3, vec4(1.00000, 1.00000, 1.00000, 1.00000));
  lm2_1 = tmpvar_4;
  gl_FragData[0] = lm2_1;
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
// 6 instructions, 1 temp regs, 0 temp arrays:
// ALU 1 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_3
eefiecedjhpcbfkbkegfmjmicmcgphdflffkdknaabaaaaaalmacaaaaaeaaaaaa
daaaaaaaaeabaaaabaacaaaageacaaaaebgpgodjmmaaaaaammaaaaaaaaacpopp
jiaaaaaadeaaaaaaabaaceaaaaaadaaaaaaadaaaaaaaceaaabaadaaaaaaaaaaa
aeaaabaaaaaaaaaaaaaaaaaaabacpoppbpaaaaacafaaaaiaaaaaapjabpaaaaac
afaaabiaabaaapjaafaaaaadaaaaapiaaaaaffjaacaaoekaaeaaaaaeaaaaapia
abaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapiaadaaoekaaaaakkjaaaaaoeia
aeaaaaaeaaaaapiaaeaaoekaaaaappjaaaaaoeiaaeaaaaaeaaaaadmaaaaappia
aaaaoekaaaaaoeiaabaaaaacaaaaammaaaaaoeiaabaaaaacaaaaadoaabaaoeja
ppppaaaafdeieefcaeabaaaaeaaaabaaebaaaaaafjaaaaaeegiocaaaaaaaaaaa
aeaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaabaaaaaaghaaaaae
pccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagiaaaaacabaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaaaaaaaaaabaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaaaaaaaaaagbabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaacaaaaaa
kgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaa
aaaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafdccabaaa
abaaaaaaegbabaaaabaaaaaadoaaaaabejfdeheoemaaaaaaacaaaaaaaiaaaaaa
diaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfc
eeaaklklepfdeheofaaaaaaaacaaaaaaaiaaaaaadiaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaaeeaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
adamaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklkl"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLSL
#ifdef VERTEX
varying vec2 xlv_TEXCOORD0;

void main ()
{
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = gl_MultiTexCoord0.xy;
}


#endif
#ifdef FRAGMENT
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _LM;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = texture2D (_LM, xlv_TEXCOORD0);
  gl_FragData[0] = min (((8.00000 * tmpvar_1.w) * tmpvar_1), vec4(1.00000, 1.00000, 1.00000, 1.00000));
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
; 5 ALU
dcl_position0 v0
dcl_texcoord0 v1
mov oT0.xy, v1
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "UnityPerDraw" 336 // 64 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
BindCB "UnityPerDraw" 0
// 6 instructions, 1 temp regs, 0 temp arrays:
// ALU 1 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedaffpdldohodkdgpagjklpapmmnbhcfmlabaaaaaaoeabaaaaadaaaaaa
cmaaaaaaiaaaaaaaniaaaaaaejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklkl
epfdeheofaaaaaaaacaaaaaaaiaaaaaadiaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaaeeaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
fdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcaeabaaaa
eaaaabaaebaaaaaafjaaaaaeegiocaaaaaaaaaaaaeaaaaaafpaaaaadpcbabaaa
aaaaaaaafpaaaaaddcbabaaaabaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaaddccabaaaabaaaaaagiaaaaacabaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaaaaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaaaaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaaaaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaaaaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadgaaaaafdccabaaaabaaaaaaegbabaaaabaaaaaa
doaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD0;

attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _LM;
void main ()
{
  lowp vec4 lm2_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = (2.00000 * texture2D (_LM, xlv_TEXCOORD0));
  highp vec4 tmpvar_3;
  tmpvar_3 = min (tmpvar_2, vec4(1.00000, 1.00000, 1.00000, 1.00000));
  lm2_1 = tmpvar_3;
  gl_FragData[0] = lm2_1;
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

varying highp vec2 xlv_TEXCOORD0;

attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _LM;
void main ()
{
  lowp vec4 lm2_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_LM, xlv_TEXCOORD0);
  lowp vec4 tmpvar_3;
  tmpvar_3 = ((8.00000 * tmpvar_2.w) * tmpvar_2);
  highp vec4 tmpvar_4;
  tmpvar_4 = min (tmpvar_3, vec4(1.00000, 1.00000, 1.00000, 1.00000));
  lm2_1 = tmpvar_4;
  gl_FragData[0] = lm2_1;
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
// 6 instructions, 1 temp regs, 0 temp arrays:
// ALU 1 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_3
eefiecedjhpcbfkbkegfmjmicmcgphdflffkdknaabaaaaaalmacaaaaaeaaaaaa
daaaaaaaaeabaaaabaacaaaageacaaaaebgpgodjmmaaaaaammaaaaaaaaacpopp
jiaaaaaadeaaaaaaabaaceaaaaaadaaaaaaadaaaaaaaceaaabaadaaaaaaaaaaa
aeaaabaaaaaaaaaaaaaaaaaaabacpoppbpaaaaacafaaaaiaaaaaapjabpaaaaac
afaaabiaabaaapjaafaaaaadaaaaapiaaaaaffjaacaaoekaaeaaaaaeaaaaapia
abaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapiaadaaoekaaaaakkjaaaaaoeia
aeaaaaaeaaaaapiaaeaaoekaaaaappjaaaaaoeiaaeaaaaaeaaaaadmaaaaappia
aaaaoekaaaaaoeiaabaaaaacaaaaammaaaaaoeiaabaaaaacaaaaadoaabaaoeja
ppppaaaafdeieefcaeabaaaaeaaaabaaebaaaaaafjaaaaaeegiocaaaaaaaaaaa
aeaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaabaaaaaaghaaaaae
pccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagiaaaaacabaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaaaaaaaaaabaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaaaaaaaaaagbabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaacaaaaaa
kgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaa
aaaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafdccabaaa
abaaaaaaegbabaaaabaaaaaadoaaaaabejfdeheoemaaaaaaacaaaaaaaiaaaaaa
diaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfc
eeaaklklepfdeheofaaaaaaaacaaaaaaaiaaaaaadiaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaaeeaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
adamaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklkl"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
"!!GLSL
#ifdef VERTEX
varying vec2 xlv_TEXCOORD0;

void main ()
{
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = gl_MultiTexCoord0.xy;
}


#endif
#ifdef FRAGMENT
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _LM;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = texture2D (_LM, xlv_TEXCOORD0);
  gl_FragData[0] = min (((8.00000 * tmpvar_1.w) * tmpvar_1), vec4(1.00000, 1.00000, 1.00000, 1.00000));
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
; 5 ALU
dcl_position0 v0
dcl_texcoord0 v1
mov oT0.xy, v1
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "UnityPerDraw" 336 // 64 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
BindCB "UnityPerDraw" 0
// 6 instructions, 1 temp regs, 0 temp arrays:
// ALU 1 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedaffpdldohodkdgpagjklpapmmnbhcfmlabaaaaaaoeabaaaaadaaaaaa
cmaaaaaaiaaaaaaaniaaaaaaejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklkl
epfdeheofaaaaaaaacaaaaaaaiaaaaaadiaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaaeeaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
fdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcaeabaaaa
eaaaabaaebaaaaaafjaaaaaeegiocaaaaaaaaaaaaeaaaaaafpaaaaadpcbabaaa
aaaaaaaafpaaaaaddcbabaaaabaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaaddccabaaaabaaaaaagiaaaaacabaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaaaaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaaaaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaaaaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaaaaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadgaaaaafdccabaaaabaaaaaaegbabaaaabaaaaaa
doaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD0;

attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _LM;
void main ()
{
  lowp vec4 lm2_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = (2.00000 * texture2D (_LM, xlv_TEXCOORD0));
  highp vec4 tmpvar_3;
  tmpvar_3 = min (tmpvar_2, vec4(1.00000, 1.00000, 1.00000, 1.00000));
  lm2_1 = tmpvar_3;
  gl_FragData[0] = lm2_1;
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

varying highp vec2 xlv_TEXCOORD0;

attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _LM;
void main ()
{
  lowp vec4 lm2_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_LM, xlv_TEXCOORD0);
  lowp vec4 tmpvar_3;
  tmpvar_3 = ((8.00000 * tmpvar_2.w) * tmpvar_2);
  highp vec4 tmpvar_4;
  tmpvar_4 = min (tmpvar_3, vec4(1.00000, 1.00000, 1.00000, 1.00000));
  lm2_1 = tmpvar_4;
  gl_FragData[0] = lm2_1;
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
// 6 instructions, 1 temp regs, 0 temp arrays:
// ALU 1 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_3
eefiecedjhpcbfkbkegfmjmicmcgphdflffkdknaabaaaaaalmacaaaaaeaaaaaa
daaaaaaaaeabaaaabaacaaaageacaaaaebgpgodjmmaaaaaammaaaaaaaaacpopp
jiaaaaaadeaaaaaaabaaceaaaaaadaaaaaaadaaaaaaaceaaabaadaaaaaaaaaaa
aeaaabaaaaaaaaaaaaaaaaaaabacpoppbpaaaaacafaaaaiaaaaaapjabpaaaaac
afaaabiaabaaapjaafaaaaadaaaaapiaaaaaffjaacaaoekaaeaaaaaeaaaaapia
abaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapiaadaaoekaaaaakkjaaaaaoeia
aeaaaaaeaaaaapiaaeaaoekaaaaappjaaaaaoeiaaeaaaaaeaaaaadmaaaaappia
aaaaoekaaaaaoeiaabaaaaacaaaaammaaaaaoeiaabaaaaacaaaaadoaabaaoeja
ppppaaaafdeieefcaeabaaaaeaaaabaaebaaaaaafjaaaaaeegiocaaaaaaaaaaa
aeaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaabaaaaaaghaaaaae
pccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagiaaaaacabaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaaaaaaaaaabaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaaaaaaaaaagbabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaacaaaaaa
kgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaa
aaaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafdccabaaa
abaaaaaaegbabaaaabaaaaaadoaaaaabejfdeheoemaaaaaaacaaaaaaaiaaaaaa
diaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfc
eeaaklklepfdeheofaaaaaaaacaaaaaaaiaaaaaadiaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaaeeaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
adamaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklkl"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;

uniform vec4 _ProjectionParams;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec4 o_2;
  vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.500000);
  vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = gl_MultiTexCoord0.xy;
  xlv_TEXCOORD1 = o_2;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _LM;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = texture2D (_LM, xlv_TEXCOORD0);
  gl_FragData[0] = min (((8.00000 * tmpvar_1.w) * tmpvar_1), texture2DProj (_ShadowMapTexture, xlv_TEXCOORD1).xxxx);
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 4 [_ProjectionParams]
Vector 5 [_ScreenParams]
"vs_2_0
; 10 ALU
def c6, 0.50000000, 0, 0, 0
dcl_position0 v0
dcl_texcoord0 v1
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c6.x
mul r1.y, r1, c4.x
mad oT1.xy, r1.z, c5.zwzw, r1
mov oPos, r0
mov oT1.zw, r0
mov oT0.xy, v1
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityPerDraw" 336 // 64 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
BindCB "UnityPerCamera" 0
BindCB "UnityPerDraw" 1
// 11 instructions, 2 temp regs, 0 temp arrays:
// ALU 4 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedfckeabedkkgkchofbcgkolmdhmclalnnabaaaaaakeacaaaaadaaaaaa
cmaaaaaaiaaaaaaapaaaaaaaejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklkl
epfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
fmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaapaaaaaafdfgfpfaepfdejfe
ejepeoaafeeffiedepepfceeaaklklklfdeieefckmabaaaaeaaaabaaglaaaaaa
fjaaaaaeegiocaaaaaaaaaaaagaaaaaafjaaaaaeegiocaaaabaaaaaaaeaaaaaa
fpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaabaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaa
giaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
abaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
abaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaabaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
dgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafdccabaaaabaaaaaa
egbabaaaabaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaa
aaaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaa
aaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaaacaaaaaakgaobaaa
aaaaaaaaaaaaaaahdccabaaaacaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaa
doaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp mat4 unity_World2Shadow[4];

uniform highp mat4 _Object2World;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _ShadowMapTexture;
uniform highp vec4 _LightShadowData;
uniform sampler2D _LM;
void main ()
{
  lowp vec4 lm2_1;
  highp float shadow_2;
  lowp float tmpvar_3;
  mediump float lightShadowDataX_4;
  highp float dist_5;
  lowp float tmpvar_6;
  tmpvar_6 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD1).x;
  dist_5 = tmpvar_6;
  highp float tmpvar_7;
  tmpvar_7 = _LightShadowData.x;
  lightShadowDataX_4 = tmpvar_7;
  highp float tmpvar_8;
  tmpvar_8 = max (float((dist_5 > (xlv_TEXCOORD1.z / xlv_TEXCOORD1.w))), lightShadowDataX_4);
  tmpvar_3 = tmpvar_8;
  shadow_2 = tmpvar_3;
  lowp vec4 tmpvar_9;
  tmpvar_9 = (2.00000 * texture2D (_LM, xlv_TEXCOORD0));
  highp vec4 tmpvar_10;
  tmpvar_10 = min (tmpvar_9, vec4(shadow_2));
  lm2_1 = tmpvar_10;
  gl_FragData[0] = lm2_1;
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

varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;

uniform highp vec4 _ProjectionParams;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.500000);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = o_2;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _LM;
void main ()
{
  lowp vec4 lm2_1;
  highp float shadow_2;
  lowp float tmpvar_3;
  tmpvar_3 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD1).x;
  shadow_2 = tmpvar_3;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_LM, xlv_TEXCOORD0);
  lowp vec4 tmpvar_5;
  tmpvar_5 = ((8.00000 * tmpvar_4.w) * tmpvar_4);
  highp vec4 tmpvar_6;
  tmpvar_6 = min (tmpvar_5, vec4(shadow_2));
  lm2_1 = tmpvar_6;
  gl_FragData[0] = lm2_1;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;

uniform vec4 _ProjectionParams;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec4 o_2;
  vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.500000);
  vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = gl_MultiTexCoord0.xy;
  xlv_TEXCOORD1 = o_2;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _LM;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = texture2D (_LM, xlv_TEXCOORD0);
  gl_FragData[0] = min (((8.00000 * tmpvar_1.w) * tmpvar_1), texture2DProj (_ShadowMapTexture, xlv_TEXCOORD1).xxxx);
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 4 [_ProjectionParams]
Vector 5 [_ScreenParams]
"vs_2_0
; 10 ALU
def c6, 0.50000000, 0, 0, 0
dcl_position0 v0
dcl_texcoord0 v1
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c6.x
mul r1.y, r1, c4.x
mad oT1.xy, r1.z, c5.zwzw, r1
mov oPos, r0
mov oT1.zw, r0
mov oT0.xy, v1
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityPerDraw" 336 // 64 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
BindCB "UnityPerCamera" 0
BindCB "UnityPerDraw" 1
// 11 instructions, 2 temp regs, 0 temp arrays:
// ALU 4 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedfckeabedkkgkchofbcgkolmdhmclalnnabaaaaaakeacaaaaadaaaaaa
cmaaaaaaiaaaaaaapaaaaaaaejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklkl
epfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
fmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaapaaaaaafdfgfpfaepfdejfe
ejepeoaafeeffiedepepfceeaaklklklfdeieefckmabaaaaeaaaabaaglaaaaaa
fjaaaaaeegiocaaaaaaaaaaaagaaaaaafjaaaaaeegiocaaaabaaaaaaaeaaaaaa
fpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaabaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaa
giaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
abaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
abaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaabaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
dgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafdccabaaaabaaaaaa
egbabaaaabaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaa
aaaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaa
aaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaaacaaaaaakgaobaaa
aaaaaaaaaaaaaaahdccabaaaacaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaa
doaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp mat4 unity_World2Shadow[4];

uniform highp mat4 _Object2World;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _ShadowMapTexture;
uniform highp vec4 _LightShadowData;
uniform sampler2D _LM;
void main ()
{
  lowp vec4 lm2_1;
  highp float shadow_2;
  lowp float tmpvar_3;
  mediump float lightShadowDataX_4;
  highp float dist_5;
  lowp float tmpvar_6;
  tmpvar_6 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD1).x;
  dist_5 = tmpvar_6;
  highp float tmpvar_7;
  tmpvar_7 = _LightShadowData.x;
  lightShadowDataX_4 = tmpvar_7;
  highp float tmpvar_8;
  tmpvar_8 = max (float((dist_5 > (xlv_TEXCOORD1.z / xlv_TEXCOORD1.w))), lightShadowDataX_4);
  tmpvar_3 = tmpvar_8;
  shadow_2 = tmpvar_3;
  lowp vec4 tmpvar_9;
  tmpvar_9 = (2.00000 * texture2D (_LM, xlv_TEXCOORD0));
  highp vec4 tmpvar_10;
  tmpvar_10 = min (tmpvar_9, vec4(shadow_2));
  lm2_1 = tmpvar_10;
  gl_FragData[0] = lm2_1;
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

varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;

uniform highp vec4 _ProjectionParams;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.500000);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = o_2;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _LM;
void main ()
{
  lowp vec4 lm2_1;
  highp float shadow_2;
  lowp float tmpvar_3;
  tmpvar_3 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD1).x;
  shadow_2 = tmpvar_3;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_LM, xlv_TEXCOORD0);
  lowp vec4 tmpvar_5;
  tmpvar_5 = ((8.00000 * tmpvar_4.w) * tmpvar_4);
  highp vec4 tmpvar_6;
  tmpvar_6 = min (tmpvar_5, vec4(shadow_2));
  lm2_1 = tmpvar_6;
  gl_FragData[0] = lm2_1;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;

uniform vec4 _ProjectionParams;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec4 o_2;
  vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.500000);
  vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = gl_MultiTexCoord0.xy;
  xlv_TEXCOORD1 = o_2;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _LM;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = texture2D (_LM, xlv_TEXCOORD0);
  gl_FragData[0] = min (((8.00000 * tmpvar_1.w) * tmpvar_1), texture2DProj (_ShadowMapTexture, xlv_TEXCOORD1).xxxx);
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 4 [_ProjectionParams]
Vector 5 [_ScreenParams]
"vs_2_0
; 10 ALU
def c6, 0.50000000, 0, 0, 0
dcl_position0 v0
dcl_texcoord0 v1
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c6.x
mul r1.y, r1, c4.x
mad oT1.xy, r1.z, c5.zwzw, r1
mov oPos, r0
mov oT1.zw, r0
mov oT0.xy, v1
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityPerDraw" 336 // 64 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
BindCB "UnityPerCamera" 0
BindCB "UnityPerDraw" 1
// 11 instructions, 2 temp regs, 0 temp arrays:
// ALU 4 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedfckeabedkkgkchofbcgkolmdhmclalnnabaaaaaakeacaaaaadaaaaaa
cmaaaaaaiaaaaaaapaaaaaaaejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklkl
epfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
fmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaapaaaaaafdfgfpfaepfdejfe
ejepeoaafeeffiedepepfceeaaklklklfdeieefckmabaaaaeaaaabaaglaaaaaa
fjaaaaaeegiocaaaaaaaaaaaagaaaaaafjaaaaaeegiocaaaabaaaaaaaeaaaaaa
fpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaabaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaa
giaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
abaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
abaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaabaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
dgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafdccabaaaabaaaaaa
egbabaaaabaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaa
aaaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaa
aaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaaacaaaaaakgaobaaa
aaaaaaaaaaaaaaahdccabaaaacaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaa
doaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp mat4 unity_World2Shadow[4];

uniform highp mat4 _Object2World;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _ShadowMapTexture;
uniform highp vec4 _LightShadowData;
uniform sampler2D _LM;
void main ()
{
  lowp vec4 lm2_1;
  highp float shadow_2;
  lowp float tmpvar_3;
  mediump float lightShadowDataX_4;
  highp float dist_5;
  lowp float tmpvar_6;
  tmpvar_6 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD1).x;
  dist_5 = tmpvar_6;
  highp float tmpvar_7;
  tmpvar_7 = _LightShadowData.x;
  lightShadowDataX_4 = tmpvar_7;
  highp float tmpvar_8;
  tmpvar_8 = max (float((dist_5 > (xlv_TEXCOORD1.z / xlv_TEXCOORD1.w))), lightShadowDataX_4);
  tmpvar_3 = tmpvar_8;
  shadow_2 = tmpvar_3;
  lowp vec4 tmpvar_9;
  tmpvar_9 = (2.00000 * texture2D (_LM, xlv_TEXCOORD0));
  highp vec4 tmpvar_10;
  tmpvar_10 = min (tmpvar_9, vec4(shadow_2));
  lm2_1 = tmpvar_10;
  gl_FragData[0] = lm2_1;
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

varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;

uniform highp vec4 _ProjectionParams;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.500000);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = o_2;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _LM;
void main ()
{
  lowp vec4 lm2_1;
  highp float shadow_2;
  lowp float tmpvar_3;
  tmpvar_3 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD1).x;
  shadow_2 = tmpvar_3;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_LM, xlv_TEXCOORD0);
  lowp vec4 tmpvar_5;
  tmpvar_5 = ((8.00000 * tmpvar_4.w) * tmpvar_4);
  highp vec4 tmpvar_6;
  tmpvar_6 = min (tmpvar_5, vec4(shadow_2));
  lm2_1 = tmpvar_6;
  gl_FragData[0] = lm2_1;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
"!!GLSL
#ifdef VERTEX
varying vec2 xlv_TEXCOORD0;

void main ()
{
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = gl_MultiTexCoord0.xy;
}


#endif
#ifdef FRAGMENT
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _LM;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = texture2D (_LM, xlv_TEXCOORD0);
  gl_FragData[0] = min (((8.00000 * tmpvar_1.w) * tmpvar_1), vec4(1.00000, 1.00000, 1.00000, 1.00000));
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
; 5 ALU
dcl_position0 v0
dcl_texcoord0 v1
mov oT0.xy, v1
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "UnityPerDraw" 336 // 64 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
BindCB "UnityPerDraw" 0
// 6 instructions, 1 temp regs, 0 temp arrays:
// ALU 1 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedaffpdldohodkdgpagjklpapmmnbhcfmlabaaaaaaoeabaaaaadaaaaaa
cmaaaaaaiaaaaaaaniaaaaaaejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklkl
epfdeheofaaaaaaaacaaaaaaaiaaaaaadiaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaaeeaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
fdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcaeabaaaa
eaaaabaaebaaaaaafjaaaaaeegiocaaaaaaaaaaaaeaaaaaafpaaaaadpcbabaaa
aaaaaaaafpaaaaaddcbabaaaabaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaaddccabaaaabaaaaaagiaaaaacabaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaaaaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaaaaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaaaaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaaaaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadgaaaaafdccabaaaabaaaaaaegbabaaaabaaaaaa
doaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD0;

attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _LM;
void main ()
{
  lowp vec4 lm2_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = (2.00000 * texture2D (_LM, xlv_TEXCOORD0));
  highp vec4 tmpvar_3;
  tmpvar_3 = min (tmpvar_2, vec4(1.00000, 1.00000, 1.00000, 1.00000));
  lm2_1 = tmpvar_3;
  gl_FragData[0] = lm2_1;
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

varying highp vec2 xlv_TEXCOORD0;

attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _LM;
void main ()
{
  lowp vec4 lm2_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_LM, xlv_TEXCOORD0);
  lowp vec4 tmpvar_3;
  tmpvar_3 = ((8.00000 * tmpvar_2.w) * tmpvar_2);
  highp vec4 tmpvar_4;
  tmpvar_4 = min (tmpvar_3, vec4(1.00000, 1.00000, 1.00000, 1.00000));
  lm2_1 = tmpvar_4;
  gl_FragData[0] = lm2_1;
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
// 6 instructions, 1 temp regs, 0 temp arrays:
// ALU 1 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_3
eefiecedjhpcbfkbkegfmjmicmcgphdflffkdknaabaaaaaalmacaaaaaeaaaaaa
daaaaaaaaeabaaaabaacaaaageacaaaaebgpgodjmmaaaaaammaaaaaaaaacpopp
jiaaaaaadeaaaaaaabaaceaaaaaadaaaaaaadaaaaaaaceaaabaadaaaaaaaaaaa
aeaaabaaaaaaaaaaaaaaaaaaabacpoppbpaaaaacafaaaaiaaaaaapjabpaaaaac
afaaabiaabaaapjaafaaaaadaaaaapiaaaaaffjaacaaoekaaeaaaaaeaaaaapia
abaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapiaadaaoekaaaaakkjaaaaaoeia
aeaaaaaeaaaaapiaaeaaoekaaaaappjaaaaaoeiaaeaaaaaeaaaaadmaaaaappia
aaaaoekaaaaaoeiaabaaaaacaaaaammaaaaaoeiaabaaaaacaaaaadoaabaaoeja
ppppaaaafdeieefcaeabaaaaeaaaabaaebaaaaaafjaaaaaeegiocaaaaaaaaaaa
aeaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaabaaaaaaghaaaaae
pccabaaaaaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagiaaaaacabaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaaaaaaaaaabaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaaaaaaaaaagbabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaacaaaaaa
kgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaa
aaaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafdccabaaa
abaaaaaaegbabaaaabaaaaaadoaaaaabejfdeheoemaaaaaaacaaaaaaaiaaaaaa
diaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfc
eeaaklklepfdeheofaaaaaaaacaaaaaaaiaaaaaadiaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaaeeaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
adamaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklkl"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;

uniform vec4 _ProjectionParams;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * gl_Vertex);
  vec4 o_2;
  vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.500000);
  vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = gl_MultiTexCoord0.xy;
  xlv_TEXCOORD1 = o_2;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_TEXCOORD1;
varying vec2 xlv_TEXCOORD0;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _LM;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1 = texture2D (_LM, xlv_TEXCOORD0);
  gl_FragData[0] = min (((8.00000 * tmpvar_1.w) * tmpvar_1), texture2DProj (_ShadowMapTexture, xlv_TEXCOORD1).xxxx);
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 4 [_ProjectionParams]
Vector 5 [_ScreenParams]
"vs_2_0
; 10 ALU
def c6, 0.50000000, 0, 0, 0
dcl_position0 v0
dcl_texcoord0 v1
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c6.x
mul r1.y, r1, c4.x
mad oT1.xy, r1.z, c5.zwzw, r1
mov oPos, r0
mov oT1.zw, r0
mov oT0.xy, v1
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityPerDraw" 336 // 64 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
BindCB "UnityPerCamera" 0
BindCB "UnityPerDraw" 1
// 11 instructions, 2 temp regs, 0 temp arrays:
// ALU 4 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedfckeabedkkgkchofbcgkolmdhmclalnnabaaaaaakeacaaaaadaaaaaa
cmaaaaaaiaaaaaaapaaaaaaaejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklkl
epfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
fmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaapaaaaaafdfgfpfaepfdejfe
ejepeoaafeeffiedepepfceeaaklklklfdeieefckmabaaaaeaaaabaaglaaaaaa
fjaaaaaeegiocaaaaaaaaaaaagaaaaaafjaaaaaeegiocaaaabaaaaaaaeaaaaaa
fpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaaabaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaa
giaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
abaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
abaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaabaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
dgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafdccabaaaabaaaaaa
egbabaaaabaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaa
aaaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaa
aaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaaacaaaaaakgaobaaa
aaaaaaaaaaaaaaahdccabaaaacaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaa
doaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp mat4 unity_World2Shadow[4];

uniform highp mat4 _Object2World;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _ShadowMapTexture;
uniform highp vec4 _LightShadowData;
uniform sampler2D _LM;
void main ()
{
  lowp vec4 lm2_1;
  highp float shadow_2;
  lowp float tmpvar_3;
  mediump float lightShadowDataX_4;
  highp float dist_5;
  lowp float tmpvar_6;
  tmpvar_6 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD1).x;
  dist_5 = tmpvar_6;
  highp float tmpvar_7;
  tmpvar_7 = _LightShadowData.x;
  lightShadowDataX_4 = tmpvar_7;
  highp float tmpvar_8;
  tmpvar_8 = max (float((dist_5 > (xlv_TEXCOORD1.z / xlv_TEXCOORD1.w))), lightShadowDataX_4);
  tmpvar_3 = tmpvar_8;
  shadow_2 = tmpvar_3;
  lowp vec4 tmpvar_9;
  tmpvar_9 = (2.00000 * texture2D (_LM, xlv_TEXCOORD0));
  highp vec4 tmpvar_10;
  tmpvar_10 = min (tmpvar_9, vec4(shadow_2));
  lm2_1 = tmpvar_10;
  gl_FragData[0] = lm2_1;
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

varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;

uniform highp vec4 _ProjectionParams;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.500000);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = o_2;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _LM;
void main ()
{
  lowp vec4 lm2_1;
  highp float shadow_2;
  lowp float tmpvar_3;
  tmpvar_3 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD1).x;
  shadow_2 = tmpvar_3;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_LM, xlv_TEXCOORD0);
  lowp vec4 tmpvar_5;
  tmpvar_5 = ((8.00000 * tmpvar_4.w) * tmpvar_4);
  highp vec4 tmpvar_6;
  tmpvar_6 = min (tmpvar_5, vec4(shadow_2));
  lm2_1 = tmpvar_6;
  gl_FragData[0] = lm2_1;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 6
//   d3d9 - ALU: 4 to 4, TEX: 1 to 2
//   d3d11 - ALU: 3 to 4, TEX: 1 to 2, FLOW: 1 to 1
//   d3d11_9x - ALU: 3 to 3, TEX: 1 to 1, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
SetTexture 0 [_LM] 2D
"ps_2_0
; 4 ALU, 1 TEX
dcl_2d s0
def c0, 8.00000000, 1.00000000, 0, 0
dcl t0.xy
texld r0, t0, s0
mul_pp r0, r0.w, r0
mul_pp r0, r0, c0.x
min_pp r0, r0, c0.y
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
SetTexture 0 [_LM] 2D 0
// 5 instructions, 2 temp regs, 0 temp arrays:
// ALU 3 float, 0 int, 0 uint
// TEX 1 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedboekoehmeagpflpcmhbnidaliedonpbaabaaaaaaimabaaaaadaaaaaa
cmaaaaaaieaaaaaaliaaaaaaejfdeheofaaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaeeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcmmaaaaaa
eaaaaaaaddaaaaaafkaaaaadaagabaaaaaaaaaaafibiaaaeaahabaaaaaaaaaaa
ffffaaaagcbaaaaddcbabaaaabaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaac
acaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaa
aagabaaaaaaaaaaadiaaaaahbcaabaaaabaaaaaadkaabaaaaaaaaaaaabeaaaaa
aaaaaaebdiaaaaahpcaabaaaaaaaaaaaegaobaaaaaaaaaaaagaabaaaabaaaaaa
ddaaaaakpccabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaaaaaaiadpaaaaiadp
aaaaiadpaaaaiadpdoaaaaab"
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
SetTexture 0 [_LM] 2D 0
// 5 instructions, 2 temp regs, 0 temp arrays:
// ALU 3 float, 0 int, 0 uint
// TEX 1 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_3
eefiecedophefllgaflnjhjijmcldimodbgbjgflabaaaaaaeeacaaaaaeaaaaaa
daaaaaaaoeaaaaaaliabaaaabaacaaaaebgpgodjkmaaaaaakmaaaaaaaaacpppp
ieaaaaaaciaaaaaaaaaaciaaaaaaciaaaaaaciaaabaaceaaaaaaciaaaaaaaaaa
abacppppfbaaaaafaaaaapkaaaaaaaebaaaaiadpaaaaaaaaaaaaaaaabpaaaaac
aaaaaaiaaaaaadlabpaaaaacaaaaaajaaaaiapkaecaaaaadaaaacpiaaaaaoela
aaaioekaafaaaaadabaaciiaaaaappiaaaaaaakaafaaaaadaaaacpiaaaaaoeia
abaappiaakaaaaadabaacpiaaaaaoeiaaaaaffkaabaaaaacaaaicpiaabaaoeia
ppppaaaafdeieefcmmaaaaaaeaaaaaaaddaaaaaafkaaaaadaagabaaaaaaaaaaa
fibiaaaeaahabaaaaaaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagfaaaaad
pccabaaaaaaaaaaagiaaaaacacaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaa
abaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadiaaaaahbcaabaaaabaaaaaa
dkaabaaaaaaaaaaaabeaaaaaaaaaaaebdiaaaaahpcaabaaaaaaaaaaaegaobaaa
aaaaaaaaagaabaaaabaaaaaaddaaaaakpccabaaaaaaaaaaaegaobaaaaaaaaaaa
aceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpdoaaaaabejfdeheofaaaaaaa
acaaaaaaaiaaaaaadiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaa
eeaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadadaaaafdfgfpfaepfdejfe
ejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaa
caaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgf
heaaklkl"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
SetTexture 0 [_LM] 2D
"ps_2_0
; 4 ALU, 1 TEX
dcl_2d s0
def c0, 8.00000000, 1.00000000, 0, 0
dcl t0.xy
texld r0, t0, s0
mul_pp r0, r0.w, r0
mul_pp r0, r0, c0.x
min_pp r0, r0, c0.y
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
SetTexture 0 [_LM] 2D 0
// 5 instructions, 2 temp regs, 0 temp arrays:
// ALU 3 float, 0 int, 0 uint
// TEX 1 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedboekoehmeagpflpcmhbnidaliedonpbaabaaaaaaimabaaaaadaaaaaa
cmaaaaaaieaaaaaaliaaaaaaejfdeheofaaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaeeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcmmaaaaaa
eaaaaaaaddaaaaaafkaaaaadaagabaaaaaaaaaaafibiaaaeaahabaaaaaaaaaaa
ffffaaaagcbaaaaddcbabaaaabaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaac
acaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaa
aagabaaaaaaaaaaadiaaaaahbcaabaaaabaaaaaadkaabaaaaaaaaaaaabeaaaaa
aaaaaaebdiaaaaahpcaabaaaaaaaaaaaegaobaaaaaaaaaaaagaabaaaabaaaaaa
ddaaaaakpccabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaaaaaaiadpaaaaiadp
aaaaiadpaaaaiadpdoaaaaab"
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
SetTexture 0 [_LM] 2D 0
// 5 instructions, 2 temp regs, 0 temp arrays:
// ALU 3 float, 0 int, 0 uint
// TEX 1 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_3
eefiecedophefllgaflnjhjijmcldimodbgbjgflabaaaaaaeeacaaaaaeaaaaaa
daaaaaaaoeaaaaaaliabaaaabaacaaaaebgpgodjkmaaaaaakmaaaaaaaaacpppp
ieaaaaaaciaaaaaaaaaaciaaaaaaciaaaaaaciaaabaaceaaaaaaciaaaaaaaaaa
abacppppfbaaaaafaaaaapkaaaaaaaebaaaaiadpaaaaaaaaaaaaaaaabpaaaaac
aaaaaaiaaaaaadlabpaaaaacaaaaaajaaaaiapkaecaaaaadaaaacpiaaaaaoela
aaaioekaafaaaaadabaaciiaaaaappiaaaaaaakaafaaaaadaaaacpiaaaaaoeia
abaappiaakaaaaadabaacpiaaaaaoeiaaaaaffkaabaaaaacaaaicpiaabaaoeia
ppppaaaafdeieefcmmaaaaaaeaaaaaaaddaaaaaafkaaaaadaagabaaaaaaaaaaa
fibiaaaeaahabaaaaaaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagfaaaaad
pccabaaaaaaaaaaagiaaaaacacaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaa
abaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadiaaaaahbcaabaaaabaaaaaa
dkaabaaaaaaaaaaaabeaaaaaaaaaaaebdiaaaaahpcaabaaaaaaaaaaaegaobaaa
aaaaaaaaagaabaaaabaaaaaaddaaaaakpccabaaaaaaaaaaaegaobaaaaaaaaaaa
aceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpdoaaaaabejfdeheofaaaaaaa
acaaaaaaaiaaaaaadiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaa
eeaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadadaaaafdfgfpfaepfdejfe
ejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaa
caaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgf
heaaklkl"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
SetTexture 0 [_LM] 2D
"ps_2_0
; 4 ALU, 1 TEX
dcl_2d s0
def c0, 8.00000000, 1.00000000, 0, 0
dcl t0.xy
texld r0, t0, s0
mul_pp r0, r0.w, r0
mul_pp r0, r0, c0.x
min_pp r0, r0, c0.y
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
SetTexture 0 [_LM] 2D 0
// 5 instructions, 2 temp regs, 0 temp arrays:
// ALU 3 float, 0 int, 0 uint
// TEX 1 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedboekoehmeagpflpcmhbnidaliedonpbaabaaaaaaimabaaaaadaaaaaa
cmaaaaaaieaaaaaaliaaaaaaejfdeheofaaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaeeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcmmaaaaaa
eaaaaaaaddaaaaaafkaaaaadaagabaaaaaaaaaaafibiaaaeaahabaaaaaaaaaaa
ffffaaaagcbaaaaddcbabaaaabaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaac
acaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaa
aagabaaaaaaaaaaadiaaaaahbcaabaaaabaaaaaadkaabaaaaaaaaaaaabeaaaaa
aaaaaaebdiaaaaahpcaabaaaaaaaaaaaegaobaaaaaaaaaaaagaabaaaabaaaaaa
ddaaaaakpccabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaaaaaaiadpaaaaiadp
aaaaiadpaaaaiadpdoaaaaab"
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
SetTexture 0 [_LM] 2D 0
// 5 instructions, 2 temp regs, 0 temp arrays:
// ALU 3 float, 0 int, 0 uint
// TEX 1 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_3
eefiecedophefllgaflnjhjijmcldimodbgbjgflabaaaaaaeeacaaaaaeaaaaaa
daaaaaaaoeaaaaaaliabaaaabaacaaaaebgpgodjkmaaaaaakmaaaaaaaaacpppp
ieaaaaaaciaaaaaaaaaaciaaaaaaciaaaaaaciaaabaaceaaaaaaciaaaaaaaaaa
abacppppfbaaaaafaaaaapkaaaaaaaebaaaaiadpaaaaaaaaaaaaaaaabpaaaaac
aaaaaaiaaaaaadlabpaaaaacaaaaaajaaaaiapkaecaaaaadaaaacpiaaaaaoela
aaaioekaafaaaaadabaaciiaaaaappiaaaaaaakaafaaaaadaaaacpiaaaaaoeia
abaappiaakaaaaadabaacpiaaaaaoeiaaaaaffkaabaaaaacaaaicpiaabaaoeia
ppppaaaafdeieefcmmaaaaaaeaaaaaaaddaaaaaafkaaaaadaagabaaaaaaaaaaa
fibiaaaeaahabaaaaaaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagfaaaaad
pccabaaaaaaaaaaagiaaaaacacaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaa
abaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadiaaaaahbcaabaaaabaaaaaa
dkaabaaaaaaaaaaaabeaaaaaaaaaaaebdiaaaaahpcaabaaaaaaaaaaaegaobaaa
aaaaaaaaagaabaaaabaaaaaaddaaaaakpccabaaaaaaaaaaaegaobaaaaaaaaaaa
aceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpdoaaaaabejfdeheofaaaaaaa
acaaaaaaaiaaaaaadiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaa
eeaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadadaaaafdfgfpfaepfdejfe
ejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaa
caaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgf
heaaklkl"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
SetTexture 0 [_ShadowMapTexture] 2D
SetTexture 1 [_LM] 2D
"ps_2_0
; 4 ALU, 2 TEX
dcl_2d s0
dcl_2d s1
def c0, 8.00000000, 0, 0, 0
dcl t0.xy
dcl t1
texld r0, t0, s1
texldp r1, t1, s0
mul_pp r0, r0.w, r0
mul_pp r0, r0, c0.x
min_pp r0, r0, r1.x
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
SetTexture 0 [_ShadowMapTexture] 2D 0
SetTexture 1 [_LM] 2D 1
// 7 instructions, 2 temp regs, 0 temp arrays:
// ALU 4 float, 0 int, 0 uint
// TEX 2 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedojmgcamaaimbmpncagkhhganmienjcdhabaaaaaaaaacaaaaadaaaaaa
cmaaaaaajmaaaaaanaaaaaaaejfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apalaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcciabaaaaeaaaaaaaekaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafibiaaaeaahabaaa
aaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaagcbaaaaddcbabaaa
abaaaaaagcbaaaadlcbabaaaacaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaac
acaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaaabaaaaaa
aagabaaaabaaaaaadiaaaaahbcaabaaaabaaaaaadkaabaaaaaaaaaaaabeaaaaa
aaaaaaebdiaaaaahpcaabaaaaaaaaaaaegaobaaaaaaaaaaaagaabaaaabaaaaaa
aoaaaaahdcaabaaaabaaaaaaegbabaaaacaaaaaapgbpbaaaacaaaaaaefaaaaaj
pcaabaaaabaaaaaaegaabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaa
ddaaaaahpccabaaaaaaaaaaaegaobaaaaaaaaaaaagaabaaaabaaaaaadoaaaaab
"
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
SetTexture 0 [_ShadowMapTexture] 2D
SetTexture 1 [_LM] 2D
"ps_2_0
; 4 ALU, 2 TEX
dcl_2d s0
dcl_2d s1
def c0, 8.00000000, 0, 0, 0
dcl t0.xy
dcl t1
texld r0, t0, s1
texldp r1, t1, s0
mul_pp r0, r0.w, r0
mul_pp r0, r0, c0.x
min_pp r0, r0, r1.x
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
SetTexture 0 [_ShadowMapTexture] 2D 0
SetTexture 1 [_LM] 2D 1
// 7 instructions, 2 temp regs, 0 temp arrays:
// ALU 4 float, 0 int, 0 uint
// TEX 2 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedojmgcamaaimbmpncagkhhganmienjcdhabaaaaaaaaacaaaaadaaaaaa
cmaaaaaajmaaaaaanaaaaaaaejfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apalaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcciabaaaaeaaaaaaaekaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafibiaaaeaahabaaa
aaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaagcbaaaaddcbabaaa
abaaaaaagcbaaaadlcbabaaaacaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaac
acaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaaabaaaaaa
aagabaaaabaaaaaadiaaaaahbcaabaaaabaaaaaadkaabaaaaaaaaaaaabeaaaaa
aaaaaaebdiaaaaahpcaabaaaaaaaaaaaegaobaaaaaaaaaaaagaabaaaabaaaaaa
aoaaaaahdcaabaaaabaaaaaaegbabaaaacaaaaaapgbpbaaaacaaaaaaefaaaaaj
pcaabaaaabaaaaaaegaabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaa
ddaaaaahpccabaaaaaaaaaaaegaobaaaaaaaaaaaagaabaaaabaaaaaadoaaaaab
"
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
SetTexture 0 [_ShadowMapTexture] 2D
SetTexture 1 [_LM] 2D
"ps_2_0
; 4 ALU, 2 TEX
dcl_2d s0
dcl_2d s1
def c0, 8.00000000, 0, 0, 0
dcl t0.xy
dcl t1
texld r0, t0, s1
texldp r1, t1, s0
mul_pp r0, r0.w, r0
mul_pp r0, r0, c0.x
min_pp r0, r0, r1.x
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
SetTexture 0 [_ShadowMapTexture] 2D 0
SetTexture 1 [_LM] 2D 1
// 7 instructions, 2 temp regs, 0 temp arrays:
// ALU 4 float, 0 int, 0 uint
// TEX 2 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedojmgcamaaimbmpncagkhhganmienjcdhabaaaaaaaaacaaaaadaaaaaa
cmaaaaaajmaaaaaanaaaaaaaejfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaafmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apalaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcciabaaaaeaaaaaaaekaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafibiaaaeaahabaaa
aaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaagcbaaaaddcbabaaa
abaaaaaagcbaaaadlcbabaaaacaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaac
acaaaaaaefaaaaajpcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaaabaaaaaa
aagabaaaabaaaaaadiaaaaahbcaabaaaabaaaaaadkaabaaaaaaaaaaaabeaaaaa
aaaaaaebdiaaaaahpcaabaaaaaaaaaaaegaobaaaaaaaaaaaagaabaaaabaaaaaa
aoaaaaahdcaabaaaabaaaaaaegbabaaaacaaaaaapgbpbaaaacaaaaaaefaaaaaj
pcaabaaaabaaaaaaegaabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaa
ddaaaaahpccabaaaaaaaaaaaegaobaaaaaaaaaaaagaabaaaabaaaaaadoaaaaab
"
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

#LINE 314


    }
    
}

Fallback "VertexLit"
} 