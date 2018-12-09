/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

/* This file is designed for use with ISim build 0x7708f090 */

#define XSI_HIDE_SYMBOL_SPEC true
#include "xsi.h"
#include <memory.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
static const char *ng0 = "C:/Users/Sandeep Kooner/Desktop/440 Labs/Final Project/Enhancements/FinalProjectEnhancements/Instruction_Unit.v";
static int ng1[] = {16, 0};
static unsigned int ng2[] = {3U, 0U};
static unsigned int ng3[] = {0U, 0U};
static unsigned int ng4[] = {2U, 0U};
static unsigned int ng5[] = {1U, 0U};



static void Cont_53_0(char *t0)
{
    char t3[8];
    char t4[8];
    char t16[8];
    char t17[8];
    char t27[8];
    char t31[8];
    char t43[8];
    char t44[8];
    char t54[8];
    char t58[8];
    char *t1;
    char *t2;
    char *t5;
    unsigned int t6;
    unsigned int t7;
    unsigned int t8;
    unsigned int t9;
    unsigned int t10;
    char *t11;
    char *t12;
    unsigned int t13;
    unsigned int t14;
    unsigned int t15;
    char *t18;
    char *t19;
    char *t20;
    unsigned int t21;
    unsigned int t22;
    unsigned int t23;
    unsigned int t24;
    unsigned int t25;
    unsigned int t26;
    char *t28;
    char *t29;
    char *t30;
    char *t32;
    unsigned int t33;
    unsigned int t34;
    unsigned int t35;
    unsigned int t36;
    unsigned int t37;
    unsigned int t38;
    unsigned int t39;
    unsigned int t40;
    unsigned int t41;
    unsigned int t42;
    char *t45;
    char *t46;
    char *t47;
    unsigned int t48;
    unsigned int t49;
    unsigned int t50;
    unsigned int t51;
    unsigned int t52;
    unsigned int t53;
    char *t55;
    char *t56;
    char *t57;
    char *t59;
    unsigned int t60;
    unsigned int t61;
    unsigned int t62;
    unsigned int t63;
    unsigned int t64;
    unsigned int t65;
    char *t66;
    char *t67;
    char *t68;
    char *t69;
    char *t70;
    char *t71;

LAB0:    t1 = (t0 + 4928U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(53, ng0);
    t2 = (t0 + 1368U);
    t5 = *((char **)t2);
    memset(t4, 0, 8);
    t2 = (t5 + 4);
    t6 = *((unsigned int *)t2);
    t7 = (~(t6));
    t8 = *((unsigned int *)t5);
    t9 = (t8 & t7);
    t10 = (t9 & 1U);
    if (t10 != 0)
        goto LAB4;

LAB5:    if (*((unsigned int *)t2) != 0)
        goto LAB6;

LAB7:    t12 = (t4 + 4);
    t13 = *((unsigned int *)t4);
    t14 = *((unsigned int *)t12);
    t15 = (t13 || t14);
    if (t15 > 0)
        goto LAB8;

LAB9:    t39 = *((unsigned int *)t4);
    t40 = (~(t39));
    t41 = *((unsigned int *)t12);
    t42 = (t40 || t41);
    if (t42 > 0)
        goto LAB10;

LAB11:    if (*((unsigned int *)t12) > 0)
        goto LAB12;

LAB13:    if (*((unsigned int *)t4) > 0)
        goto LAB14;

LAB15:    memcpy(t3, t43, 8);

LAB16:    t66 = (t0 + 6104);
    t67 = (t66 + 56U);
    t68 = *((char **)t67);
    t69 = (t68 + 56U);
    t70 = *((char **)t69);
    memcpy(t70, t3, 8);
    xsi_driver_vfirst_trans(t66, 0, 31);
    t71 = (t0 + 5992);
    *((int *)t71) = 1;

LAB1:    return;
LAB4:    *((unsigned int *)t4) = 1;
    goto LAB7;

LAB6:    t11 = (t4 + 4);
    *((unsigned int *)t4) = 1;
    *((unsigned int *)t11) = 1;
    goto LAB7;

LAB8:    t18 = (t0 + 2968U);
    t19 = *((char **)t18);
    memset(t17, 0, 8);
    t18 = (t17 + 4);
    t20 = (t19 + 4);
    t21 = *((unsigned int *)t19);
    t22 = (t21 >> 5);
    *((unsigned int *)t17) = t22;
    t23 = *((unsigned int *)t20);
    t24 = (t23 >> 5);
    *((unsigned int *)t18) = t24;
    t25 = *((unsigned int *)t17);
    *((unsigned int *)t17) = (t25 & 65535U);
    t26 = *((unsigned int *)t18);
    *((unsigned int *)t18) = (t26 & 65535U);
    t28 = ((char*)((ng1)));
    t29 = (t0 + 2968U);
    t30 = *((char **)t29);
    memset(t31, 0, 8);
    t29 = (t31 + 4);
    t32 = (t30 + 4);
    t33 = *((unsigned int *)t30);
    t34 = (t33 >> 20);
    t35 = (t34 & 1);
    *((unsigned int *)t31) = t35;
    t36 = *((unsigned int *)t32);
    t37 = (t36 >> 20);
    t38 = (t37 & 1);
    *((unsigned int *)t29) = t38;
    xsi_vlog_mul_concat(t27, 16, 1, t28, 1U, t31, 1);
    xsi_vlogtype_concat(t16, 32, 32, 2U, t27, 16, t17, 16);
    goto LAB9;

LAB10:    t45 = (t0 + 2968U);
    t46 = *((char **)t45);
    memset(t44, 0, 8);
    t45 = (t44 + 4);
    t47 = (t46 + 4);
    t48 = *((unsigned int *)t46);
    t49 = (t48 >> 0);
    *((unsigned int *)t44) = t49;
    t50 = *((unsigned int *)t47);
    t51 = (t50 >> 0);
    *((unsigned int *)t45) = t51;
    t52 = *((unsigned int *)t44);
    *((unsigned int *)t44) = (t52 & 65535U);
    t53 = *((unsigned int *)t45);
    *((unsigned int *)t45) = (t53 & 65535U);
    t55 = ((char*)((ng1)));
    t56 = (t0 + 2968U);
    t57 = *((char **)t56);
    memset(t58, 0, 8);
    t56 = (t58 + 4);
    t59 = (t57 + 4);
    t60 = *((unsigned int *)t57);
    t61 = (t60 >> 15);
    t62 = (t61 & 1);
    *((unsigned int *)t58) = t62;
    t63 = *((unsigned int *)t59);
    t64 = (t63 >> 15);
    t65 = (t64 & 1);
    *((unsigned int *)t56) = t65;
    xsi_vlog_mul_concat(t54, 16, 1, t55, 1U, t58, 1);
    xsi_vlogtype_concat(t43, 32, 32, 2U, t54, 16, t44, 16);
    goto LAB11;

LAB12:    xsi_vlog_unsigned_bit_combine(t3, 32, t16, 32, t43, 32);
    goto LAB16;

LAB14:    memcpy(t3, t16, 8);
    goto LAB16;

}

static void Cont_56_1(char *t0)
{
    char t3[8];
    char t4[8];
    char t6[8];
    char t33[8];
    char t35[8];
    char t45[8];
    char t59[8];
    char t60[8];
    char t63[8];
    char t96[8];
    char t97[8];
    char t99[8];
    char t126[8];
    char t128[8];
    char t138[8];
    char t152[8];
    char t153[8];
    char t156[8];
    char t185[8];
    char t186[8];
    char t196[8];
    char *t1;
    char *t2;
    char *t5;
    char *t7;
    char *t8;
    unsigned int t9;
    unsigned int t10;
    unsigned int t11;
    unsigned int t12;
    unsigned int t13;
    unsigned int t14;
    unsigned int t15;
    unsigned int t16;
    unsigned int t17;
    unsigned int t18;
    unsigned int t19;
    unsigned int t20;
    char *t21;
    char *t22;
    unsigned int t23;
    unsigned int t24;
    unsigned int t25;
    unsigned int t26;
    unsigned int t27;
    char *t28;
    char *t29;
    unsigned int t30;
    unsigned int t31;
    unsigned int t32;
    char *t34;
    char *t36;
    char *t37;
    char *t38;
    unsigned int t39;
    unsigned int t40;
    unsigned int t41;
    unsigned int t42;
    unsigned int t43;
    unsigned int t44;
    char *t46;
    char *t47;
    char *t48;
    unsigned int t49;
    unsigned int t50;
    unsigned int t51;
    unsigned int t52;
    unsigned int t53;
    unsigned int t54;
    unsigned int t55;
    unsigned int t56;
    unsigned int t57;
    unsigned int t58;
    char *t61;
    char *t62;
    char *t64;
    char *t65;
    unsigned int t66;
    unsigned int t67;
    unsigned int t68;
    unsigned int t69;
    unsigned int t70;
    unsigned int t71;
    unsigned int t72;
    unsigned int t73;
    unsigned int t74;
    unsigned int t75;
    unsigned int t76;
    unsigned int t77;
    char *t78;
    char *t79;
    unsigned int t80;
    unsigned int t81;
    unsigned int t82;
    unsigned int t83;
    unsigned int t84;
    char *t85;
    char *t86;
    unsigned int t87;
    unsigned int t88;
    unsigned int t89;
    char *t90;
    char *t91;
    unsigned int t92;
    unsigned int t93;
    unsigned int t94;
    unsigned int t95;
    char *t98;
    char *t100;
    char *t101;
    unsigned int t102;
    unsigned int t103;
    unsigned int t104;
    unsigned int t105;
    unsigned int t106;
    unsigned int t107;
    unsigned int t108;
    unsigned int t109;
    unsigned int t110;
    unsigned int t111;
    unsigned int t112;
    unsigned int t113;
    char *t114;
    char *t115;
    unsigned int t116;
    unsigned int t117;
    unsigned int t118;
    unsigned int t119;
    unsigned int t120;
    char *t121;
    char *t122;
    unsigned int t123;
    unsigned int t124;
    unsigned int t125;
    char *t127;
    char *t129;
    char *t130;
    char *t131;
    unsigned int t132;
    unsigned int t133;
    unsigned int t134;
    unsigned int t135;
    unsigned int t136;
    unsigned int t137;
    char *t139;
    char *t140;
    char *t141;
    unsigned int t142;
    unsigned int t143;
    unsigned int t144;
    unsigned int t145;
    unsigned int t146;
    unsigned int t147;
    unsigned int t148;
    unsigned int t149;
    unsigned int t150;
    unsigned int t151;
    char *t154;
    char *t155;
    char *t157;
    char *t158;
    unsigned int t159;
    unsigned int t160;
    unsigned int t161;
    unsigned int t162;
    unsigned int t163;
    unsigned int t164;
    unsigned int t165;
    unsigned int t166;
    unsigned int t167;
    unsigned int t168;
    unsigned int t169;
    unsigned int t170;
    char *t171;
    char *t172;
    unsigned int t173;
    unsigned int t174;
    unsigned int t175;
    unsigned int t176;
    unsigned int t177;
    char *t178;
    char *t179;
    unsigned int t180;
    unsigned int t181;
    unsigned int t182;
    char *t183;
    char *t184;
    char *t187;
    char *t188;
    char *t189;
    unsigned int t190;
    unsigned int t191;
    unsigned int t192;
    unsigned int t193;
    unsigned int t194;
    unsigned int t195;
    unsigned int t197;
    unsigned int t198;
    unsigned int t199;
    unsigned int t200;
    char *t201;
    char *t202;
    char *t203;
    char *t204;
    char *t205;
    char *t206;
    char *t207;

LAB0:    t1 = (t0 + 5176U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(56, ng0);
    t2 = (t0 + 2488U);
    t5 = *((char **)t2);
    t2 = ((char*)((ng2)));
    memset(t6, 0, 8);
    t7 = (t5 + 4);
    t8 = (t2 + 4);
    t9 = *((unsigned int *)t5);
    t10 = *((unsigned int *)t2);
    t11 = (t9 ^ t10);
    t12 = *((unsigned int *)t7);
    t13 = *((unsigned int *)t8);
    t14 = (t12 ^ t13);
    t15 = (t11 | t14);
    t16 = *((unsigned int *)t7);
    t17 = *((unsigned int *)t8);
    t18 = (t16 | t17);
    t19 = (~(t18));
    t20 = (t15 & t19);
    if (t20 != 0)
        goto LAB7;

LAB4:    if (t18 != 0)
        goto LAB6;

LAB5:    *((unsigned int *)t6) = 1;

LAB7:    memset(t4, 0, 8);
    t22 = (t6 + 4);
    t23 = *((unsigned int *)t22);
    t24 = (~(t23));
    t25 = *((unsigned int *)t6);
    t26 = (t25 & t24);
    t27 = (t26 & 1U);
    if (t27 != 0)
        goto LAB8;

LAB9:    if (*((unsigned int *)t22) != 0)
        goto LAB10;

LAB11:    t29 = (t4 + 4);
    t30 = *((unsigned int *)t4);
    t31 = *((unsigned int *)t29);
    t32 = (t30 || t31);
    if (t32 > 0)
        goto LAB12;

LAB13:    t55 = *((unsigned int *)t4);
    t56 = (~(t55));
    t57 = *((unsigned int *)t29);
    t58 = (t56 || t57);
    if (t58 > 0)
        goto LAB14;

LAB15:    if (*((unsigned int *)t29) > 0)
        goto LAB16;

LAB17:    if (*((unsigned int *)t4) > 0)
        goto LAB18;

LAB19:    memcpy(t3, t59, 8);

LAB20:    t201 = (t0 + 6168);
    t203 = (t201 + 56U);
    t204 = *((char **)t203);
    t205 = (t204 + 56U);
    t206 = *((char **)t205);
    memcpy(t206, t3, 8);
    xsi_driver_vfirst_trans(t201, 0, 31);
    t207 = (t0 + 6008);
    *((int *)t207) = 1;

LAB1:    return;
LAB6:    t21 = (t6 + 4);
    *((unsigned int *)t6) = 1;
    *((unsigned int *)t21) = 1;
    goto LAB7;

LAB8:    *((unsigned int *)t4) = 1;
    goto LAB11;

LAB10:    t28 = (t4 + 4);
    *((unsigned int *)t4) = 1;
    *((unsigned int *)t28) = 1;
    goto LAB11;

LAB12:    t34 = ((char*)((ng3)));
    t36 = (t0 + 2968U);
    t37 = *((char **)t36);
    memset(t35, 0, 8);
    t36 = (t35 + 4);
    t38 = (t37 + 4);
    t39 = *((unsigned int *)t37);
    t40 = (t39 >> 6);
    *((unsigned int *)t35) = t40;
    t41 = *((unsigned int *)t38);
    t42 = (t41 >> 6);
    *((unsigned int *)t36) = t42;
    t43 = *((unsigned int *)t35);
    *((unsigned int *)t35) = (t43 & 1048575U);
    t44 = *((unsigned int *)t36);
    *((unsigned int *)t36) = (t44 & 1048575U);
    t46 = (t0 + 2808U);
    t47 = *((char **)t46);
    memset(t45, 0, 8);
    t46 = (t45 + 4);
    t48 = (t47 + 4);
    t49 = *((unsigned int *)t47);
    t50 = (t49 >> 28);
    *((unsigned int *)t45) = t50;
    t51 = *((unsigned int *)t48);
    t52 = (t51 >> 28);
    *((unsigned int *)t46) = t52;
    t53 = *((unsigned int *)t45);
    *((unsigned int *)t45) = (t53 & 15U);
    t54 = *((unsigned int *)t46);
    *((unsigned int *)t46) = (t54 & 15U);
    xsi_vlogtype_concat(t33, 32, 32, 3U, t45, 4, t35, 20, t34, 8);
    goto LAB13;

LAB14:    t61 = (t0 + 2488U);
    t62 = *((char **)t61);
    t61 = ((char*)((ng4)));
    memset(t63, 0, 8);
    t64 = (t62 + 4);
    t65 = (t61 + 4);
    t66 = *((unsigned int *)t62);
    t67 = *((unsigned int *)t61);
    t68 = (t66 ^ t67);
    t69 = *((unsigned int *)t64);
    t70 = *((unsigned int *)t65);
    t71 = (t69 ^ t70);
    t72 = (t68 | t71);
    t73 = *((unsigned int *)t64);
    t74 = *((unsigned int *)t65);
    t75 = (t73 | t74);
    t76 = (~(t75));
    t77 = (t72 & t76);
    if (t77 != 0)
        goto LAB24;

LAB21:    if (t75 != 0)
        goto LAB23;

LAB22:    *((unsigned int *)t63) = 1;

LAB24:    memset(t60, 0, 8);
    t79 = (t63 + 4);
    t80 = *((unsigned int *)t79);
    t81 = (~(t80));
    t82 = *((unsigned int *)t63);
    t83 = (t82 & t81);
    t84 = (t83 & 1U);
    if (t84 != 0)
        goto LAB25;

LAB26:    if (*((unsigned int *)t79) != 0)
        goto LAB27;

LAB28:    t86 = (t60 + 4);
    t87 = *((unsigned int *)t60);
    t88 = *((unsigned int *)t86);
    t89 = (t87 || t88);
    if (t89 > 0)
        goto LAB29;

LAB30:    t92 = *((unsigned int *)t60);
    t93 = (~(t92));
    t94 = *((unsigned int *)t86);
    t95 = (t93 || t94);
    if (t95 > 0)
        goto LAB31;

LAB32:    if (*((unsigned int *)t86) > 0)
        goto LAB33;

LAB34:    if (*((unsigned int *)t60) > 0)
        goto LAB35;

LAB36:    memcpy(t59, t96, 8);

LAB37:    goto LAB15;

LAB16:    xsi_vlog_unsigned_bit_combine(t3, 32, t33, 32, t59, 32);
    goto LAB20;

LAB18:    memcpy(t3, t33, 8);
    goto LAB20;

LAB23:    t78 = (t63 + 4);
    *((unsigned int *)t63) = 1;
    *((unsigned int *)t78) = 1;
    goto LAB24;

LAB25:    *((unsigned int *)t60) = 1;
    goto LAB28;

LAB27:    t85 = (t60 + 4);
    *((unsigned int *)t60) = 1;
    *((unsigned int *)t85) = 1;
    goto LAB28;

LAB29:    t90 = (t0 + 2648U);
    t91 = *((char **)t90);
    goto LAB30;

LAB31:    t90 = (t0 + 2488U);
    t98 = *((char **)t90);
    t90 = ((char*)((ng5)));
    memset(t99, 0, 8);
    t100 = (t98 + 4);
    t101 = (t90 + 4);
    t102 = *((unsigned int *)t98);
    t103 = *((unsigned int *)t90);
    t104 = (t102 ^ t103);
    t105 = *((unsigned int *)t100);
    t106 = *((unsigned int *)t101);
    t107 = (t105 ^ t106);
    t108 = (t104 | t107);
    t109 = *((unsigned int *)t100);
    t110 = *((unsigned int *)t101);
    t111 = (t109 | t110);
    t112 = (~(t111));
    t113 = (t108 & t112);
    if (t113 != 0)
        goto LAB41;

LAB38:    if (t111 != 0)
        goto LAB40;

LAB39:    *((unsigned int *)t99) = 1;

LAB41:    memset(t97, 0, 8);
    t115 = (t99 + 4);
    t116 = *((unsigned int *)t115);
    t117 = (~(t116));
    t118 = *((unsigned int *)t99);
    t119 = (t118 & t117);
    t120 = (t119 & 1U);
    if (t120 != 0)
        goto LAB42;

LAB43:    if (*((unsigned int *)t115) != 0)
        goto LAB44;

LAB45:    t122 = (t97 + 4);
    t123 = *((unsigned int *)t97);
    t124 = *((unsigned int *)t122);
    t125 = (t123 || t124);
    if (t125 > 0)
        goto LAB46;

LAB47:    t148 = *((unsigned int *)t97);
    t149 = (~(t148));
    t150 = *((unsigned int *)t122);
    t151 = (t149 || t150);
    if (t151 > 0)
        goto LAB48;

LAB49:    if (*((unsigned int *)t122) > 0)
        goto LAB50;

LAB51:    if (*((unsigned int *)t97) > 0)
        goto LAB52;

LAB53:    memcpy(t96, t152, 8);

LAB54:    goto LAB32;

LAB33:    xsi_vlog_unsigned_bit_combine(t59, 32, t91, 32, t96, 32);
    goto LAB37;

LAB35:    memcpy(t59, t91, 8);
    goto LAB37;

LAB40:    t114 = (t99 + 4);
    *((unsigned int *)t99) = 1;
    *((unsigned int *)t114) = 1;
    goto LAB41;

LAB42:    *((unsigned int *)t97) = 1;
    goto LAB45;

LAB44:    t121 = (t97 + 4);
    *((unsigned int *)t97) = 1;
    *((unsigned int *)t121) = 1;
    goto LAB45;

LAB46:    t127 = ((char*)((ng3)));
    t129 = (t0 + 2968U);
    t130 = *((char **)t129);
    memset(t128, 0, 8);
    t129 = (t128 + 4);
    t131 = (t130 + 4);
    t132 = *((unsigned int *)t130);
    t133 = (t132 >> 0);
    *((unsigned int *)t128) = t133;
    t134 = *((unsigned int *)t131);
    t135 = (t134 >> 0);
    *((unsigned int *)t129) = t135;
    t136 = *((unsigned int *)t128);
    *((unsigned int *)t128) = (t136 & 67108863U);
    t137 = *((unsigned int *)t129);
    *((unsigned int *)t129) = (t137 & 67108863U);
    t139 = (t0 + 2808U);
    t140 = *((char **)t139);
    memset(t138, 0, 8);
    t139 = (t138 + 4);
    t141 = (t140 + 4);
    t142 = *((unsigned int *)t140);
    t143 = (t142 >> 28);
    *((unsigned int *)t138) = t143;
    t144 = *((unsigned int *)t141);
    t145 = (t144 >> 28);
    *((unsigned int *)t139) = t145;
    t146 = *((unsigned int *)t138);
    *((unsigned int *)t138) = (t146 & 15U);
    t147 = *((unsigned int *)t139);
    *((unsigned int *)t139) = (t147 & 15U);
    xsi_vlogtype_concat(t126, 32, 32, 3U, t138, 4, t128, 26, t127, 2);
    goto LAB47;

LAB48:    t154 = (t0 + 2488U);
    t155 = *((char **)t154);
    t154 = ((char*)((ng3)));
    memset(t156, 0, 8);
    t157 = (t155 + 4);
    t158 = (t154 + 4);
    t159 = *((unsigned int *)t155);
    t160 = *((unsigned int *)t154);
    t161 = (t159 ^ t160);
    t162 = *((unsigned int *)t157);
    t163 = *((unsigned int *)t158);
    t164 = (t162 ^ t163);
    t165 = (t161 | t164);
    t166 = *((unsigned int *)t157);
    t167 = *((unsigned int *)t158);
    t168 = (t166 | t167);
    t169 = (~(t168));
    t170 = (t165 & t169);
    if (t170 != 0)
        goto LAB58;

LAB55:    if (t168 != 0)
        goto LAB57;

LAB56:    *((unsigned int *)t156) = 1;

LAB58:    memset(t153, 0, 8);
    t172 = (t156 + 4);
    t173 = *((unsigned int *)t172);
    t174 = (~(t173));
    t175 = *((unsigned int *)t156);
    t176 = (t175 & t174);
    t177 = (t176 & 1U);
    if (t177 != 0)
        goto LAB59;

LAB60:    if (*((unsigned int *)t172) != 0)
        goto LAB61;

LAB62:    t179 = (t153 + 4);
    t180 = *((unsigned int *)t153);
    t181 = *((unsigned int *)t179);
    t182 = (t180 || t181);
    if (t182 > 0)
        goto LAB63;

LAB64:    t197 = *((unsigned int *)t153);
    t198 = (~(t197));
    t199 = *((unsigned int *)t179);
    t200 = (t198 || t199);
    if (t200 > 0)
        goto LAB65;

LAB66:    if (*((unsigned int *)t179) > 0)
        goto LAB67;

LAB68:    if (*((unsigned int *)t153) > 0)
        goto LAB69;

LAB70:    memcpy(t152, t202, 8);

LAB71:    goto LAB49;

LAB50:    xsi_vlog_unsigned_bit_combine(t96, 32, t126, 32, t152, 32);
    goto LAB54;

LAB52:    memcpy(t96, t126, 8);
    goto LAB54;

LAB57:    t171 = (t156 + 4);
    *((unsigned int *)t156) = 1;
    *((unsigned int *)t171) = 1;
    goto LAB58;

LAB59:    *((unsigned int *)t153) = 1;
    goto LAB62;

LAB61:    t178 = (t153 + 4);
    *((unsigned int *)t153) = 1;
    *((unsigned int *)t178) = 1;
    goto LAB62;

LAB63:    t183 = (t0 + 2808U);
    t184 = *((char **)t183);
    t183 = ((char*)((ng3)));
    t187 = (t0 + 3128U);
    t188 = *((char **)t187);
    memset(t186, 0, 8);
    t187 = (t186 + 4);
    t189 = (t188 + 4);
    t190 = *((unsigned int *)t188);
    t191 = (t190 >> 0);
    *((unsigned int *)t186) = t191;
    t192 = *((unsigned int *)t189);
    t193 = (t192 >> 0);
    *((unsigned int *)t187) = t193;
    t194 = *((unsigned int *)t186);
    *((unsigned int *)t186) = (t194 & 1073741823U);
    t195 = *((unsigned int *)t187);
    *((unsigned int *)t187) = (t195 & 1073741823U);
    xsi_vlogtype_concat(t185, 32, 32, 2U, t186, 30, t183, 2);
    memset(t196, 0, 8);
    xsi_vlog_unsigned_add(t196, 32, t184, 32, t185, 32);
    goto LAB64;

LAB65:    t201 = (t0 + 2648U);
    t202 = *((char **)t201);
    goto LAB66;

LAB67:    xsi_vlog_unsigned_bit_combine(t152, 32, t196, 32, t202, 32);
    goto LAB71;

LAB69:    memcpy(t152, t196, 8);
    goto LAB71;

}

static void implSig1_execute(char *t0)
{
    char t3[8];
    char t4[8];
    char *t1;
    char *t2;
    char *t5;
    char *t6;
    unsigned int t7;
    unsigned int t8;
    unsigned int t9;
    unsigned int t10;
    unsigned int t11;
    unsigned int t12;
    char *t13;
    char *t14;
    char *t15;
    char *t16;
    char *t17;
    char *t18;
    char *t19;

LAB0:    t1 = (t0 + 5424U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    t2 = (t0 + 2808U);
    t5 = *((char **)t2);
    memset(t4, 0, 8);
    t2 = (t4 + 4);
    t6 = (t5 + 4);
    t7 = *((unsigned int *)t5);
    t8 = (t7 >> 0);
    *((unsigned int *)t4) = t8;
    t9 = *((unsigned int *)t6);
    t10 = (t9 >> 0);
    *((unsigned int *)t2) = t10;
    t11 = *((unsigned int *)t4);
    *((unsigned int *)t4) = (t11 & 4095U);
    t12 = *((unsigned int *)t2);
    *((unsigned int *)t2) = (t12 & 4095U);
    t13 = ((char*)((ng3)));
    xsi_vlogtype_concat(t3, 32, 32, 2U, t13, 20, t4, 12);
    t14 = (t0 + 6232);
    t15 = (t14 + 56U);
    t16 = *((char **)t15);
    t17 = (t16 + 56U);
    t18 = *((char **)t17);
    memcpy(t18, t3, 8);
    xsi_driver_vfirst_trans(t14, 0, 31);
    t19 = (t0 + 6024);
    *((int *)t19) = 1;

LAB1:    return;
}

static void implSig2_execute(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;

LAB0:    t1 = (t0 + 5672U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    t2 = ((char*)((ng3)));
    t3 = (t0 + 6296);
    t4 = (t3 + 56U);
    t5 = *((char **)t4);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    memcpy(t7, t2, 8);
    xsi_driver_vfirst_trans(t3, 0, 31);

LAB1:    return;
}


extern void work_m_00000000002260521982_3785169421_init()
{
	static char *pe[] = {(void *)Cont_53_0,(void *)Cont_56_1,(void *)implSig1_execute,(void *)implSig2_execute};
	xsi_register_didat("work_m_00000000002260521982_3785169421", "isim/MIPS_CU_TB_isim_beh.exe.sim/work/m_00000000002260521982_3785169421.didat");
	xsi_register_executes(pe);
}
