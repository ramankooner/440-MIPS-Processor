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
static const char *ng0 = "C:/Users/Sandeep Kooner/Desktop/440 Labs/Final Project/Enhancements/FinalProjectEnhancements/regfile32.v";
static unsigned int ng1[] = {0U, 0U};
static int ng2[] = {0, 0};



static void Always_32_0(char *t0)
{
    char t13[8];
    char t14[8];
    char t50[8];
    char t51[8];
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    unsigned int t6;
    unsigned int t7;
    unsigned int t8;
    unsigned int t9;
    unsigned int t10;
    char *t11;
    char *t12;
    char *t15;
    char *t16;
    char *t17;
    char *t18;
    char *t19;
    char *t20;
    char *t21;
    char *t22;
    unsigned int t23;
    int t24;
    char *t25;
    unsigned int t26;
    int t27;
    int t28;
    unsigned int t29;
    unsigned int t30;
    int t31;
    int t32;
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
    unsigned int t43;
    unsigned int t44;
    unsigned int t45;
    char *t46;
    char *t47;
    char *t48;
    char *t49;
    char *t52;
    char *t53;
    char *t54;
    char *t55;
    char *t56;
    char *t57;
    char *t58;
    char *t59;
    unsigned int t60;
    char *t61;
    unsigned int t62;
    unsigned int t63;
    unsigned int t64;

LAB0:    t1 = (t0 + 3648U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(32, ng0);
    t2 = (t0 + 4464);
    *((int *)t2) = 1;
    t3 = (t0 + 3680);
    *((char **)t3) = t2;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(35, ng0);
    t4 = (t0 + 1208U);
    t5 = *((char **)t4);
    t4 = (t5 + 4);
    t6 = *((unsigned int *)t4);
    t7 = (~(t6));
    t8 = *((unsigned int *)t5);
    t9 = (t8 & t7);
    t10 = (t9 != 0);
    if (t10 > 0)
        goto LAB5;

LAB6:    xsi_set_current_line(40, ng0);
    t2 = (t0 + 1368U);
    t3 = *((char **)t2);
    t2 = (t3 + 4);
    t6 = *((unsigned int *)t2);
    t7 = (~(t6));
    t8 = *((unsigned int *)t3);
    t9 = (t8 & t7);
    t10 = (t9 != 0);
    if (t10 > 0)
        goto LAB10;

LAB11:    xsi_set_current_line(47, ng0);
    t2 = (t0 + 2728);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t0 + 2728);
    t11 = (t5 + 72U);
    t12 = *((char **)t11);
    t15 = (t0 + 2728);
    t16 = (t15 + 64U);
    t17 = *((char **)t16);
    t18 = (t0 + 1528U);
    t19 = *((char **)t18);
    xsi_vlog_generic_get_array_select_value(t13, 32, t4, t12, t17, 2, 1, t19, 5, 2);
    t18 = (t0 + 2728);
    t20 = (t0 + 2728);
    t21 = (t20 + 72U);
    t22 = *((char **)t21);
    t25 = (t0 + 2728);
    t46 = (t25 + 64U);
    t47 = *((char **)t46);
    t48 = (t0 + 1528U);
    t49 = *((char **)t48);
    xsi_vlog_generic_convert_array_indices(t14, t50, t22, t47, 2, 1, t49, 5, 2);
    t48 = (t14 + 4);
    t6 = *((unsigned int *)t48);
    t24 = (!(t6));
    t52 = (t50 + 4);
    t7 = *((unsigned int *)t52);
    t27 = (!(t7));
    t28 = (t24 && t27);
    if (t28 == 1)
        goto LAB24;

LAB25:
LAB12:
LAB7:    goto LAB2;

LAB5:    xsi_set_current_line(36, ng0);
    t11 = ((char*)((ng1)));
    t12 = (t0 + 2728);
    t15 = (t0 + 2728);
    t16 = (t15 + 72U);
    t17 = *((char **)t16);
    t18 = (t0 + 2728);
    t19 = (t18 + 64U);
    t20 = *((char **)t19);
    t21 = ((char*)((ng2)));
    xsi_vlog_generic_convert_array_indices(t13, t14, t17, t20, 2, 1, t21, 32, 1);
    t22 = (t13 + 4);
    t23 = *((unsigned int *)t22);
    t24 = (!(t23));
    t25 = (t14 + 4);
    t26 = *((unsigned int *)t25);
    t27 = (!(t26));
    t28 = (t24 && t27);
    if (t28 == 1)
        goto LAB8;

LAB9:    goto LAB7;

LAB8:    t29 = *((unsigned int *)t13);
    t30 = *((unsigned int *)t14);
    t31 = (t29 - t30);
    t32 = (t31 + 1);
    xsi_vlogvar_wait_assign_value(t12, t11, 0, *((unsigned int *)t14), t32, 0LL);
    goto LAB9;

LAB10:    xsi_set_current_line(41, ng0);
    t4 = (t0 + 1528U);
    t5 = *((char **)t4);
    t4 = ((char*)((ng2)));
    memset(t13, 0, 8);
    t11 = (t5 + 4);
    t12 = (t4 + 4);
    t23 = *((unsigned int *)t5);
    t26 = *((unsigned int *)t4);
    t29 = (t23 ^ t26);
    t30 = *((unsigned int *)t11);
    t33 = *((unsigned int *)t12);
    t34 = (t30 ^ t33);
    t35 = (t29 | t34);
    t36 = *((unsigned int *)t11);
    t37 = *((unsigned int *)t12);
    t38 = (t36 | t37);
    t39 = (~(t38));
    t40 = (t35 & t39);
    if (t40 != 0)
        goto LAB16;

LAB13:    if (t38 != 0)
        goto LAB15;

LAB14:    *((unsigned int *)t13) = 1;

LAB16:    t16 = (t13 + 4);
    t41 = *((unsigned int *)t16);
    t42 = (~(t41));
    t43 = *((unsigned int *)t13);
    t44 = (t43 & t42);
    t45 = (t44 != 0);
    if (t45 > 0)
        goto LAB17;

LAB18:    xsi_set_current_line(44, ng0);
    t2 = (t0 + 2008U);
    t3 = *((char **)t2);
    t2 = (t0 + 2728);
    t4 = (t0 + 2728);
    t5 = (t4 + 72U);
    t11 = *((char **)t5);
    t12 = (t0 + 2728);
    t15 = (t12 + 64U);
    t16 = *((char **)t15);
    t17 = (t0 + 1528U);
    t18 = *((char **)t17);
    xsi_vlog_generic_convert_array_indices(t13, t14, t11, t16, 2, 1, t18, 5, 2);
    t17 = (t13 + 4);
    t6 = *((unsigned int *)t17);
    t24 = (!(t6));
    t19 = (t14 + 4);
    t7 = *((unsigned int *)t19);
    t27 = (!(t7));
    t28 = (t24 && t27);
    if (t28 == 1)
        goto LAB22;

LAB23:
LAB19:    goto LAB12;

LAB15:    t15 = (t13 + 4);
    *((unsigned int *)t13) = 1;
    *((unsigned int *)t15) = 1;
    goto LAB16;

LAB17:    xsi_set_current_line(42, ng0);
    t17 = (t0 + 2728);
    t18 = (t17 + 56U);
    t19 = *((char **)t18);
    t20 = (t0 + 2728);
    t21 = (t20 + 72U);
    t22 = *((char **)t21);
    t25 = (t0 + 2728);
    t46 = (t25 + 64U);
    t47 = *((char **)t46);
    t48 = (t0 + 1528U);
    t49 = *((char **)t48);
    xsi_vlog_generic_get_array_select_value(t14, 32, t19, t22, t47, 2, 1, t49, 5, 2);
    t48 = (t0 + 2728);
    t52 = (t0 + 2728);
    t53 = (t52 + 72U);
    t54 = *((char **)t53);
    t55 = (t0 + 2728);
    t56 = (t55 + 64U);
    t57 = *((char **)t56);
    t58 = (t0 + 1528U);
    t59 = *((char **)t58);
    xsi_vlog_generic_convert_array_indices(t50, t51, t54, t57, 2, 1, t59, 5, 2);
    t58 = (t50 + 4);
    t60 = *((unsigned int *)t58);
    t24 = (!(t60));
    t61 = (t51 + 4);
    t62 = *((unsigned int *)t61);
    t27 = (!(t62));
    t28 = (t24 && t27);
    if (t28 == 1)
        goto LAB20;

LAB21:    goto LAB19;

LAB20:    t63 = *((unsigned int *)t50);
    t64 = *((unsigned int *)t51);
    t31 = (t63 - t64);
    t32 = (t31 + 1);
    xsi_vlogvar_wait_assign_value(t48, t14, 0, *((unsigned int *)t51), t32, 0LL);
    goto LAB21;

LAB22:    t8 = *((unsigned int *)t13);
    t9 = *((unsigned int *)t14);
    t31 = (t8 - t9);
    t32 = (t31 + 1);
    xsi_vlogvar_wait_assign_value(t2, t3, 0, *((unsigned int *)t14), t32, 0LL);
    goto LAB23;

LAB24:    t8 = *((unsigned int *)t14);
    t9 = *((unsigned int *)t50);
    t31 = (t8 - t9);
    t32 = (t31 + 1);
    xsi_vlogvar_wait_assign_value(t18, t13, 0, *((unsigned int *)t50), t32, 0LL);
    goto LAB25;

}

static void Cont_49_1(char *t0)
{
    char t5[8];
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;
    char *t14;
    char *t15;
    char *t16;
    char *t17;
    char *t18;

LAB0:    t1 = (t0 + 3896U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(49, ng0);
    t2 = (t0 + 2728);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t6 = (t0 + 2728);
    t7 = (t6 + 72U);
    t8 = *((char **)t7);
    t9 = (t0 + 2728);
    t10 = (t9 + 64U);
    t11 = *((char **)t10);
    t12 = (t0 + 1688U);
    t13 = *((char **)t12);
    xsi_vlog_generic_get_array_select_value(t5, 32, t4, t8, t11, 2, 1, t13, 5, 2);
    t12 = (t0 + 4576);
    t14 = (t12 + 56U);
    t15 = *((char **)t14);
    t16 = (t15 + 56U);
    t17 = *((char **)t16);
    memcpy(t17, t5, 8);
    xsi_driver_vfirst_trans(t12, 0, 31);
    t18 = (t0 + 4480);
    *((int *)t18) = 1;

LAB1:    return;
}

static void Cont_50_2(char *t0)
{
    char t5[8];
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;
    char *t14;
    char *t15;
    char *t16;
    char *t17;
    char *t18;

LAB0:    t1 = (t0 + 4144U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(50, ng0);
    t2 = (t0 + 2728);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t6 = (t0 + 2728);
    t7 = (t6 + 72U);
    t8 = *((char **)t7);
    t9 = (t0 + 2728);
    t10 = (t9 + 64U);
    t11 = *((char **)t10);
    t12 = (t0 + 1848U);
    t13 = *((char **)t12);
    xsi_vlog_generic_get_array_select_value(t5, 32, t4, t8, t11, 2, 1, t13, 5, 2);
    t12 = (t0 + 4640);
    t14 = (t12 + 56U);
    t15 = *((char **)t14);
    t16 = (t15 + 56U);
    t17 = *((char **)t16);
    memcpy(t17, t5, 8);
    xsi_driver_vfirst_trans(t12, 0, 31);
    t18 = (t0 + 4496);
    *((int *)t18) = 1;

LAB1:    return;
}


extern void work_m_00000000003200532131_3979545863_init()
{
	static char *pe[] = {(void *)Always_32_0,(void *)Cont_49_1,(void *)Cont_50_2};
	xsi_register_didat("work_m_00000000003200532131_3979545863", "isim/MIPS_CU_TB_isim_beh.exe.sim/work/m_00000000003200532131_3979545863.didat");
	xsi_register_executes(pe);
}
