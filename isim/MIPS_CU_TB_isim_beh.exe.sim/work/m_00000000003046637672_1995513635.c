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
static const char *ng0 = "C:/Users/Sandeep Kooner/Desktop/440 Labs/Final Project/Enhancements/FinalProjectEnhancements/MIPS_CPU_TB.v";
static int ng1[] = {0, 0};
static int ng2[] = {16, 0};
static const char *ng3 = "T = %t  Reg Addr = %0h - Contents = %h || Reg Addr = %0h - Contents = %h";
static int ng4[] = {1, 0};
static const char *ng5 = "T = %t   Program Counter = %h  ||  IR = %h";
static int ng6[] = {9, 0};
static const char *ng7 = "ns";
static const char *ng8 = "iMemEnhanced1.dat";
static const char *ng9 = "dMemEnhanced1.dat";
static unsigned int ng10[] = {0U, 0U};



static int sp_Dump_Registers(char *t1, char *t2)
{
    char t8[8];
    char t17[16];
    char t26[8];
    char t42[8];
    char t47[8];
    char t60[8];
    int t0;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t9;
    unsigned int t10;
    unsigned int t11;
    unsigned int t12;
    unsigned int t13;
    unsigned int t14;
    char *t15;
    char *t16;
    char *t18;
    char *t19;
    char *t20;
    char *t21;
    char *t22;
    char *t23;
    char *t24;
    char *t25;
    char *t27;
    char *t28;
    char *t29;
    char *t30;
    char *t31;
    char *t32;
    char *t33;
    char *t34;
    char *t35;
    char *t36;
    char *t37;
    char *t38;
    char *t39;
    char *t40;
    char *t41;
    char *t43;
    char *t44;
    char *t45;
    char *t46;
    char *t48;
    char *t49;
    char *t50;
    char *t51;
    char *t52;
    char *t53;
    char *t54;
    char *t55;
    char *t56;
    char *t57;
    char *t58;
    char *t59;
    char *t61;

LAB0:    t0 = 1;
    t3 = (t2 + 48U);
    t4 = *((char **)t3);
    if (t4 == 0)
        goto LAB2;

LAB3:    goto *t4;

LAB2:    t4 = (t1 + 848);
    xsi_vlog_subprogram_setdisablestate(t4, &&LAB4);
    xsi_set_current_line(77, ng0);
    xsi_set_current_line(77, ng0);
    t5 = ((char*)((ng1)));
    t6 = (t1 + 4712);
    xsi_vlogvar_assign_value(t6, t5, 0, 0, 32);

LAB5:    t4 = (t1 + 4712);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    t7 = ((char*)((ng2)));
    memset(t8, 0, 8);
    xsi_vlog_signed_less(t8, 32, t6, 32, t7, 32);
    t9 = (t8 + 4);
    t10 = *((unsigned int *)t9);
    t11 = (~(t10));
    t12 = *((unsigned int *)t8);
    t13 = (t12 & t11);
    t14 = (t13 != 0);
    if (t14 > 0)
        goto LAB6;

LAB7:
LAB4:    xsi_vlog_dispose_subprogram_invocation(t2);
    t4 = (t2 + 48U);
    *((char **)t4) = &&LAB2;
    t0 = 0;

LAB1:    return t0;
LAB6:    xsi_set_current_line(78, ng0);

LAB8:    xsi_set_current_line(79, ng0);
    t15 = (t2 + 56U);
    t16 = *((char **)t15);
    xsi_process_wait(t16, 1000LL);
    *((char **)t3) = &&LAB9;
    t0 = 1;
    goto LAB1;

LAB9:    xsi_set_current_line(79, ng0);
    t18 = xsi_vlog_time(t17, 1000.0000000000000, 1000.0000000000000);
    t19 = (t1 + 4712);
    t20 = (t19 + 56U);
    t21 = *((char **)t20);
    t22 = (t1 + 9204);
    t23 = *((char **)t22);
    t24 = ((((char*)(t23))) + 56U);
    t25 = *((char **)t24);
    t27 = (t1 + 9236);
    t28 = *((char **)t27);
    t29 = ((((char*)(t28))) + 72U);
    t30 = *((char **)t29);
    t31 = (t1 + 9268);
    t32 = *((char **)t31);
    t33 = ((((char*)(t32))) + 64U);
    t34 = *((char **)t33);
    t35 = (t1 + 4712);
    t36 = (t35 + 56U);
    t37 = *((char **)t36);
    xsi_vlog_generic_get_array_select_value(t26, 32, t25, t30, t34, 2, 1, t37, 32, 1);
    t38 = (t1 + 4712);
    t39 = (t38 + 56U);
    t40 = *((char **)t39);
    t41 = ((char*)((ng2)));
    memset(t42, 0, 8);
    xsi_vlog_signed_add(t42, 32, t40, 32, t41, 32);
    t43 = (t1 + 9300);
    t44 = *((char **)t43);
    t45 = ((((char*)(t44))) + 56U);
    t46 = *((char **)t45);
    t48 = (t1 + 9332);
    t49 = *((char **)t48);
    t50 = ((((char*)(t49))) + 72U);
    t51 = *((char **)t50);
    t52 = (t1 + 9364);
    t53 = *((char **)t52);
    t54 = ((((char*)(t53))) + 64U);
    t55 = *((char **)t54);
    t56 = (t1 + 4712);
    t57 = (t56 + 56U);
    t58 = *((char **)t57);
    t59 = ((char*)((ng2)));
    memset(t60, 0, 8);
    xsi_vlog_signed_add(t60, 32, t58, 32, t59, 32);
    xsi_vlog_generic_get_array_select_value(t47, 32, t46, t51, t55, 2, 1, t60, 32, 1);
    t61 = (t1 + 848);
    xsi_vlogfile_write(1, 0, 0, ng3, 6, t61, (char)118, t17, 64, (char)119, t21, 32, (char)118, t26, 32, (char)119, t42, 32, (char)118, t47, 32);
    xsi_set_current_line(77, ng0);
    t4 = (t1 + 4712);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    t7 = ((char*)((ng4)));
    memset(t8, 0, 8);
    xsi_vlog_signed_add(t8, 32, t6, 32, t7, 32);
    t9 = (t1 + 4712);
    xsi_vlogvar_assign_value(t9, t8, 0, 0, 32);
    goto LAB5;

}

static int sp_Dump_PC_and_IR(char *t1, char *t2)
{
    char t7[16];
    int t0;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;
    char *t14;
    char *t15;

LAB0:    t0 = 1;
    t3 = (t2 + 48U);
    t4 = *((char **)t3);
    if (t4 == 0)
        goto LAB2;

LAB3:    goto *t4;

LAB2:    t4 = (t1 + 1280);
    xsi_vlog_subprogram_setdisablestate(t4, &&LAB4);
    xsi_set_current_line(88, ng0);
    t5 = (t2 + 56U);
    t6 = *((char **)t5);
    xsi_process_wait(t6, 1000LL);
    *((char **)t3) = &&LAB5;
    t0 = 1;

LAB1:    return t0;
LAB4:    xsi_vlog_dispose_subprogram_invocation(t2);
    t4 = (t2 + 48U);
    *((char **)t4) = &&LAB2;
    t0 = 0;
    goto LAB1;

LAB5:    xsi_set_current_line(88, ng0);
    t8 = xsi_vlog_time(t7, 1000.0000000000000, 1000.0000000000000);
    t9 = (t1 + 9396);
    t10 = *((char **)t9);
    t11 = ((((char*)(t10))) + 40U);
    t12 = *((char **)t11);
    t11 = (t1 + 9428);
    t13 = *((char **)t11);
    t14 = ((((char*)(t13))) + 40U);
    t15 = *((char **)t14);
    t14 = (t1 + 1280);
    xsi_vlogfile_write(1, 0, 0, ng5, 4, t14, (char)118, t7, 64, (char)118, t12, 32, (char)118, t15, 32);
    goto LAB4;

}

static void Always_69_0(char *t0)
{
    char t3[8];
    char *t1;
    char *t2;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    unsigned int t8;
    unsigned int t9;
    unsigned int t10;
    unsigned int t11;
    unsigned int t12;
    char *t13;
    char *t14;
    char *t15;
    unsigned int t16;
    unsigned int t17;
    unsigned int t18;
    unsigned int t19;
    unsigned int t20;
    unsigned int t21;
    unsigned int t22;
    unsigned int t23;
    char *t24;

LAB0:    t1 = (t0 + 5632U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(70, ng0);
    t2 = (t0 + 5440);
    xsi_process_wait(t2, 5000LL);
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(70, ng0);
    t4 = (t0 + 4392);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    memset(t3, 0, 8);
    t7 = (t6 + 4);
    t8 = *((unsigned int *)t7);
    t9 = (~(t8));
    t10 = *((unsigned int *)t6);
    t11 = (t10 & t9);
    t12 = (t11 & 1U);
    if (t12 != 0)
        goto LAB8;

LAB6:    if (*((unsigned int *)t7) == 0)
        goto LAB5;

LAB7:    t13 = (t3 + 4);
    *((unsigned int *)t3) = 1;
    *((unsigned int *)t13) = 1;

LAB8:    t14 = (t3 + 4);
    t15 = (t6 + 4);
    t16 = *((unsigned int *)t6);
    t17 = (~(t16));
    *((unsigned int *)t3) = t17;
    *((unsigned int *)t14) = 0;
    if (*((unsigned int *)t15) != 0)
        goto LAB10;

LAB9:    t22 = *((unsigned int *)t3);
    *((unsigned int *)t3) = (t22 & 1U);
    t23 = *((unsigned int *)t14);
    *((unsigned int *)t14) = (t23 & 1U);
    t24 = (t0 + 4392);
    xsi_vlogvar_assign_value(t24, t3, 0, 0, 1);
    goto LAB2;

LAB5:    *((unsigned int *)t3) = 1;
    goto LAB8;

LAB10:    t18 = *((unsigned int *)t3);
    t19 = *((unsigned int *)t15);
    *((unsigned int *)t3) = (t18 | t19);
    t20 = *((unsigned int *)t14);
    t21 = *((unsigned int *)t15);
    *((unsigned int *)t14) = (t20 | t21);
    goto LAB9;

}

static void Initial_92_1(char *t0)
{
    char t3[8];
    char *t1;
    char *t2;
    char *t4;
    char *t5;
    char *t6;

LAB0:    t1 = (t0 + 5880U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(92, ng0);

LAB4:    xsi_set_current_line(94, ng0);
    t2 = ((char*)((ng6)));
    memset(t3, 0, 8);
    xsi_vlog_signed_unary_minus(t3, 32, t2, 32);
    t4 = ((char*)((ng4)));
    t5 = ((char*)((ng6)));
    xsi_vlog_setTimeFormat(*((unsigned int *)t3), *((unsigned int *)t4), ng7, 0, *((unsigned int *)t5));
    xsi_set_current_line(101, ng0);
    t2 = (t0 + 9460);
    t4 = *((char **)t2);
    xsi_vlogfile_readmemh(ng8, 0, ((char*)(t4)), 0, 0, 0, 0);
    xsi_set_current_line(102, ng0);
    t2 = (t0 + 9484);
    t4 = *((char **)t2);
    xsi_vlogfile_readmemh(ng9, 0, ((char*)(t4)), 0, 0, 0, 0);
    xsi_set_current_line(150, ng0);
    t2 = ((char*)((ng1)));
    t4 = (t0 + 4392);
    xsi_vlogvar_assign_value(t4, t2, 0, 0, 1);
    xsi_set_current_line(151, ng0);
    t2 = ((char*)((ng1)));
    t4 = (t0 + 4552);
    xsi_vlogvar_assign_value(t4, t2, 0, 0, 1);
    xsi_set_current_line(153, ng0);
    t2 = (t0 + 6696);
    *((int *)t2) = 1;
    t4 = (t0 + 5912);
    *((char **)t4) = t2;
    *((char **)t1) = &&LAB5;

LAB1:    return;
LAB5:    xsi_set_current_line(154, ng0);
    t5 = ((char*)((ng4)));
    t6 = (t0 + 4552);
    xsi_vlogvar_assign_value(t6, t5, 0, 0, 1);
    xsi_set_current_line(155, ng0);
    t2 = (t0 + 6712);
    *((int *)t2) = 1;
    t4 = (t0 + 5912);
    *((char **)t4) = t2;
    *((char **)t1) = &&LAB6;
    goto LAB1;

LAB6:    xsi_set_current_line(156, ng0);
    t5 = ((char*)((ng1)));
    t6 = (t0 + 4552);
    xsi_vlogvar_assign_value(t6, t5, 0, 0, 1);
    goto LAB1;

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

LAB0:    t1 = (t0 + 6128U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    t2 = (t0 + 3192U);
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
    t13 = ((char*)((ng10)));
    xsi_vlogtype_concat(t3, 32, 32, 2U, t13, 20, t4, 12);
    t14 = (t0 + 6824);
    t15 = (t14 + 56U);
    t16 = *((char **)t15);
    t17 = (t16 + 56U);
    t18 = *((char **)t17);
    memcpy(t18, t3, 8);
    xsi_driver_vfirst_trans(t14, 0, 31);
    t19 = (t0 + 6728);
    *((int *)t19) = 1;

LAB1:    return;
}

static void implSig2_execute(char *t0)
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

LAB0:    t1 = (t0 + 6376U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    t2 = (t0 + 3192U);
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
    t13 = ((char*)((ng10)));
    xsi_vlogtype_concat(t3, 32, 32, 2U, t13, 20, t4, 12);
    t14 = (t0 + 6888);
    t15 = (t14 + 56U);
    t16 = *((char **)t15);
    t17 = (t16 + 56U);
    t18 = *((char **)t17);
    memcpy(t18, t3, 8);
    xsi_driver_vfirst_trans(t14, 0, 31);
    t19 = (t0 + 6744);
    *((int *)t19) = 1;

LAB1:    return;
}


extern void work_m_00000000003046637672_1995513635_init()
{
	static char *pe[] = {(void *)Always_69_0,(void *)Initial_92_1,(void *)implSig1_execute,(void *)implSig2_execute};
	static char *se[] = {(void *)sp_Dump_Registers,(void *)sp_Dump_PC_and_IR};
	xsi_register_didat("work_m_00000000003046637672_1995513635", "isim/MIPS_CU_TB_isim_beh.exe.sim/work/m_00000000003046637672_1995513635.didat");
	xsi_register_executes(pe);
	xsi_register_subprogram_executes(se);
}
