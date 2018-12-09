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

#include "xsi.h"

struct XSI_INFO xsi_info;



int main(int argc, char **argv)
{
    xsi_init_design(argc, argv);
    xsi_register_info(&xsi_info);

    xsi_register_min_prec_unit(-12);
    work_m_00000000002846929992_3125877111_init();
    work_m_00000000001728002236_1733832700_init();
    work_m_00000000003397768597_1789540044_init();
    work_m_00000000003257146986_0273213086_init();
    work_m_00000000002260521982_3785169421_init();
    work_m_00000000003200532131_3979545863_init();
    work_m_00000000003740575489_1557921908_init();
    work_m_00000000003870218890_1926972201_init();
    work_m_00000000001911040497_2966759537_init();
    work_m_00000000001617930022_2722733084_init();
    work_m_00000000003783875418_1317972029_init();
    work_m_00000000001938157562_3867763903_init();
    work_m_00000000000536996559_3508565487_init();
    work_m_00000000003537417255_2970747688_init();
    work_m_00000000003046637672_1995513635_init();
    work_m_00000000004134447467_2073120511_init();


    xsi_register_tops("work_m_00000000003046637672_1995513635");
    xsi_register_tops("work_m_00000000004134447467_2073120511");


    return xsi_run_simulation(argc, argv);

}