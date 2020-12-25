/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                         */
/*  \   \        Copyright (c) 2003-2013 Xilinx, Inc.                 */
/*  /   /        All Right Reserved.                                  */
/* /---/   /\                                                         */
/* \   \  /  \                                                        */
/*  \___\/\___\                                                       */
/**********************************************************************/

#if defined(_WIN32)
 #include "stdio.h"
#endif
#include "iki.h"
#include <string.h>
#include <math.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                         */
/*  \   \        Copyright (c) 2003-2013 Xilinx, Inc.                 */
/*  /   /        All Right Reserved.                                  */
/* /---/   /\                                                         */
/* \   \  /  \                                                        */
/*  \___\/\___\                                                       */
/**********************************************************************/

#if defined(_WIN32)
 #include "stdio.h"
#endif
#include "iki.h"
#include <string.h>
#include <math.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
typedef void (*funcp)(char *, char *);
extern int main(int, char**);
extern void execute_114(char*, char *);
extern void execute_115(char*, char *);
extern void execute_116(char*, char *);
extern void execute_117(char*, char *);
extern void execute_609(char*, char *);
extern void execute_610(char*, char *);
extern void execute_611(char*, char *);
extern void execute_612(char*, char *);
extern void execute_613(char*, char *);
extern void execute_614(char*, char *);
extern void execute_600(char*, char *);
extern void execute_601(char*, char *);
extern void execute_602(char*, char *);
extern void execute_603(char*, char *);
extern void execute_604(char*, char *);
extern void execute_605(char*, char *);
extern void execute_606(char*, char *);
extern void execute_607(char*, char *);
extern void execute_608(char*, char *);
extern void execute_4(char*, char *);
extern void execute_5(char*, char *);
extern void vlog_simple_process_execute_0_fast_no_reg_no_agg(char*, char*, char*);
extern void execute_124(char*, char *);
extern void execute_125(char*, char *);
extern void vlog_const_rhs_process_execute_0_fast_no_reg_no_agg(char*, char*, char*);
extern void execute_507(char*, char *);
extern void execute_508(char*, char *);
extern void execute_509(char*, char *);
extern void execute_510(char*, char *);
extern void execute_511(char*, char *);
extern void execute_512(char*, char *);
extern void execute_523(char*, char *);
extern void execute_524(char*, char *);
extern void execute_525(char*, char *);
extern void execute_526(char*, char *);
extern void execute_528(char*, char *);
extern void execute_529(char*, char *);
extern void execute_530(char*, char *);
extern void execute_531(char*, char *);
extern void execute_535(char*, char *);
extern void execute_536(char*, char *);
extern void execute_544(char*, char *);
extern void execute_548(char*, char *);
extern void execute_549(char*, char *);
extern void execute_550(char*, char *);
extern void execute_551(char*, char *);
extern void execute_553(char*, char *);
extern void execute_554(char*, char *);
extern void execute_555(char*, char *);
extern void execute_556(char*, char *);
extern void execute_562(char*, char *);
extern void execute_563(char*, char *);
extern void execute_568(char*, char *);
extern void execute_574(char*, char *);
extern void execute_578(char*, char *);
extern void execute_579(char*, char *);
extern void execute_582(char*, char *);
extern void execute_583(char*, char *);
extern void execute_586(char*, char *);
extern void execute_587(char*, char *);
extern void execute_590(char*, char *);
extern void execute_591(char*, char *);
extern void execute_594(char*, char *);
extern void execute_595(char*, char *);
extern void execute_598(char*, char *);
extern void execute_599(char*, char *);
extern void execute_135(char*, char *);
extern void execute_110(char*, char *);
extern void vlog_simple_process_execute_1_fast_no_reg_no_agg(char*, char*, char*);
extern void execute_488(char*, char *);
extern void execute_491(char*, char *);
extern void execute_492(char*, char *);
extern void execute_493(char*, char *);
extern void execute_496(char*, char *);
extern void execute_497(char*, char *);
extern void execute_498(char*, char *);
extern void execute_499(char*, char *);
extern void execute_500(char*, char *);
extern void execute_11(char*, char *);
extern void execute_12(char*, char *);
extern void execute_13(char*, char *);
extern void execute_14(char*, char *);
extern void execute_15(char*, char *);
extern void execute_16(char*, char *);
extern void execute_17(char*, char *);
extern void execute_18(char*, char *);
extern void execute_19(char*, char *);
extern void execute_20(char*, char *);
extern void execute_21(char*, char *);
extern void execute_22(char*, char *);
extern void execute_23(char*, char *);
extern void execute_24(char*, char *);
extern void execute_25(char*, char *);
extern void execute_26(char*, char *);
extern void execute_98(char*, char *);
extern void execute_99(char*, char *);
extern void execute_100(char*, char *);
extern void execute_101(char*, char *);
extern void execute_103(char*, char *);
extern void execute_104(char*, char *);
extern void execute_105(char*, char *);
extern void execute_106(char*, char *);
extern void execute_107(char*, char *);
extern void execute_108(char*, char *);
extern void execute_109(char*, char *);
extern void execute_367(char*, char *);
extern void execute_368(char*, char *);
extern void execute_371(char*, char *);
extern void execute_456(char*, char *);
extern void execute_457(char*, char *);
extern void execute_458(char*, char *);
extern void execute_465(char*, char *);
extern void execute_466(char*, char *);
extern void execute_467(char*, char *);
extern void execute_468(char*, char *);
extern void execute_469(char*, char *);
extern void execute_470(char*, char *);
extern void execute_471(char*, char *);
extern void execute_472(char*, char *);
extern void execute_473(char*, char *);
extern void execute_474(char*, char *);
extern void execute_475(char*, char *);
extern void execute_476(char*, char *);
extern void execute_477(char*, char *);
extern void execute_478(char*, char *);
extern void execute_479(char*, char *);
extern void execute_480(char*, char *);
extern void execute_481(char*, char *);
extern void execute_482(char*, char *);
extern void execute_483(char*, char *);
extern void execute_484(char*, char *);
extern void execute_485(char*, char *);
extern void execute_28(char*, char *);
extern void execute_29(char*, char *);
extern void execute_30(char*, char *);
extern void execute_31(char*, char *);
extern void execute_32(char*, char *);
extern void execute_33(char*, char *);
extern void execute_34(char*, char *);
extern void execute_38(char*, char *);
extern void execute_39(char*, char *);
extern void execute_40(char*, char *);
extern void execute_41(char*, char *);
extern void execute_42(char*, char *);
extern void execute_43(char*, char *);
extern void execute_62(char*, char *);
extern void execute_63(char*, char *);
extern void execute_65(char*, char *);
extern void execute_67(char*, char *);
extern void execute_68(char*, char *);
extern void execute_70(char*, char *);
extern void execute_72(char*, char *);
extern void execute_74(char*, char *);
extern void execute_76(char*, char *);
extern void execute_372(char*, char *);
extern void execute_373(char*, char *);
extern void execute_374(char*, char *);
extern void execute_375(char*, char *);
extern void execute_376(char*, char *);
extern void execute_377(char*, char *);
extern void execute_378(char*, char *);
extern void execute_379(char*, char *);
extern void execute_380(char*, char *);
extern void execute_381(char*, char *);
extern void execute_382(char*, char *);
extern void execute_383(char*, char *);
extern void execute_386(char*, char *);
extern void execute_390(char*, char *);
extern void execute_391(char*, char *);
extern void execute_392(char*, char *);
extern void execute_393(char*, char *);
extern void execute_394(char*, char *);
extern void execute_395(char*, char *);
extern void execute_396(char*, char *);
extern void execute_397(char*, char *);
extern void execute_398(char*, char *);
extern void execute_399(char*, char *);
extern void execute_400(char*, char *);
extern void execute_403(char*, char *);
extern void execute_404(char*, char *);
extern void execute_405(char*, char *);
extern void execute_406(char*, char *);
extern void execute_407(char*, char *);
extern void execute_408(char*, char *);
extern void execute_409(char*, char *);
extern void execute_410(char*, char *);
extern void execute_45(char*, char *);
extern void execute_46(char*, char *);
extern void execute_79(char*, char *);
extern void execute_80(char*, char *);
extern void execute_81(char*, char *);
extern void execute_82(char*, char *);
extern void execute_83(char*, char *);
extern void execute_84(char*, char *);
extern void execute_85(char*, char *);
extern void execute_86(char*, char *);
extern void execute_87(char*, char *);
extern void execute_88(char*, char *);
extern void execute_89(char*, char *);
extern void execute_90(char*, char *);
extern void execute_91(char*, char *);
extern void execute_92(char*, char *);
extern void execute_93(char*, char *);
extern void execute_95(char*, char *);
extern void execute_96(char*, char *);
extern void execute_97(char*, char *);
extern void execute_419(char*, char *);
extern void execute_420(char*, char *);
extern void execute_422(char*, char *);
extern void execute_430(char*, char *);
extern void execute_112(char*, char *);
extern void execute_113(char*, char *);
extern void execute_119(char*, char *);
extern void execute_120(char*, char *);
extern void execute_121(char*, char *);
extern void execute_615(char*, char *);
extern void execute_616(char*, char *);
extern void execute_617(char*, char *);
extern void execute_618(char*, char *);
extern void execute_619(char*, char *);
extern void vlog_transfunc_eventcallback(char*, char*, unsigned, unsigned, unsigned, char *);
funcp funcTab[221] = {(funcp)execute_114, (funcp)execute_115, (funcp)execute_116, (funcp)execute_117, (funcp)execute_609, (funcp)execute_610, (funcp)execute_611, (funcp)execute_612, (funcp)execute_613, (funcp)execute_614, (funcp)execute_600, (funcp)execute_601, (funcp)execute_602, (funcp)execute_603, (funcp)execute_604, (funcp)execute_605, (funcp)execute_606, (funcp)execute_607, (funcp)execute_608, (funcp)execute_4, (funcp)execute_5, (funcp)vlog_simple_process_execute_0_fast_no_reg_no_agg, (funcp)execute_124, (funcp)execute_125, (funcp)vlog_const_rhs_process_execute_0_fast_no_reg_no_agg, (funcp)execute_507, (funcp)execute_508, (funcp)execute_509, (funcp)execute_510, (funcp)execute_511, (funcp)execute_512, (funcp)execute_523, (funcp)execute_524, (funcp)execute_525, (funcp)execute_526, (funcp)execute_528, (funcp)execute_529, (funcp)execute_530, (funcp)execute_531, (funcp)execute_535, (funcp)execute_536, (funcp)execute_544, (funcp)execute_548, (funcp)execute_549, (funcp)execute_550, (funcp)execute_551, (funcp)execute_553, (funcp)execute_554, (funcp)execute_555, (funcp)execute_556, (funcp)execute_562, (funcp)execute_563, (funcp)execute_568, (funcp)execute_574, (funcp)execute_578, (funcp)execute_579, (funcp)execute_582, (funcp)execute_583, (funcp)execute_586, (funcp)execute_587, (funcp)execute_590, (funcp)execute_591, (funcp)execute_594, (funcp)execute_595, (funcp)execute_598, (funcp)execute_599, (funcp)execute_135, (funcp)execute_110, (funcp)vlog_simple_process_execute_1_fast_no_reg_no_agg, (funcp)execute_488, (funcp)execute_491, (funcp)execute_492, (funcp)execute_493, (funcp)execute_496, (funcp)execute_497, (funcp)execute_498, (funcp)execute_499, (funcp)execute_500, (funcp)execute_11, (funcp)execute_12, (funcp)execute_13, (funcp)execute_14, (funcp)execute_15, (funcp)execute_16, (funcp)execute_17, (funcp)execute_18, (funcp)execute_19, (funcp)execute_20, (funcp)execute_21, (funcp)execute_22, (funcp)execute_23, (funcp)execute_24, (funcp)execute_25, (funcp)execute_26, (funcp)execute_98, (funcp)execute_99, (funcp)execute_100, (funcp)execute_101, (funcp)execute_103, (funcp)execute_104, (funcp)execute_105, (funcp)execute_106, (funcp)execute_107, (funcp)execute_108, (funcp)execute_109, (funcp)execute_367, (funcp)execute_368, (funcp)execute_371, (funcp)execute_456, (funcp)execute_457, (funcp)execute_458, (funcp)execute_465, (funcp)execute_466, (funcp)execute_467, (funcp)execute_468, (funcp)execute_469, (funcp)execute_470, (funcp)execute_471, (funcp)execute_472, (funcp)execute_473, (funcp)execute_474, (funcp)execute_475, (funcp)execute_476, (funcp)execute_477, (funcp)execute_478, (funcp)execute_479, (funcp)execute_480, (funcp)execute_481, (funcp)execute_482, (funcp)execute_483, (funcp)execute_484, (funcp)execute_485, (funcp)execute_28, (funcp)execute_29, (funcp)execute_30, (funcp)execute_31, (funcp)execute_32, (funcp)execute_33, (funcp)execute_34, (funcp)execute_38, (funcp)execute_39, (funcp)execute_40, (funcp)execute_41, (funcp)execute_42, (funcp)execute_43, (funcp)execute_62, (funcp)execute_63, (funcp)execute_65, (funcp)execute_67, (funcp)execute_68, (funcp)execute_70, (funcp)execute_72, (funcp)execute_74, (funcp)execute_76, (funcp)execute_372, (funcp)execute_373, (funcp)execute_374, (funcp)execute_375, (funcp)execute_376, (funcp)execute_377, (funcp)execute_378, (funcp)execute_379, (funcp)execute_380, (funcp)execute_381, (funcp)execute_382, (funcp)execute_383, (funcp)execute_386, (funcp)execute_390, (funcp)execute_391, (funcp)execute_392, (funcp)execute_393, (funcp)execute_394, (funcp)execute_395, (funcp)execute_396, (funcp)execute_397, (funcp)execute_398, (funcp)execute_399, (funcp)execute_400, (funcp)execute_403, (funcp)execute_404, (funcp)execute_405, (funcp)execute_406, (funcp)execute_407, (funcp)execute_408, (funcp)execute_409, (funcp)execute_410, (funcp)execute_45, (funcp)execute_46, (funcp)execute_79, (funcp)execute_80, (funcp)execute_81, (funcp)execute_82, (funcp)execute_83, (funcp)execute_84, (funcp)execute_85, (funcp)execute_86, (funcp)execute_87, (funcp)execute_88, (funcp)execute_89, (funcp)execute_90, (funcp)execute_91, (funcp)execute_92, (funcp)execute_93, (funcp)execute_95, (funcp)execute_96, (funcp)execute_97, (funcp)execute_419, (funcp)execute_420, (funcp)execute_422, (funcp)execute_430, (funcp)execute_112, (funcp)execute_113, (funcp)execute_119, (funcp)execute_120, (funcp)execute_121, (funcp)execute_615, (funcp)execute_616, (funcp)execute_617, (funcp)execute_618, (funcp)execute_619, (funcp)vlog_transfunc_eventcallback};
const int NumRelocateId= 221;

void relocate(char *dp)
{
	iki_relocate(dp, "xsim.dir/top_tb_behav/xsim.reloc",  (void **)funcTab, 221);

	/*Populate the transaction function pointer field in the whole net structure */
}

void sensitize(char *dp)
{
	iki_sensitize(dp, "xsim.dir/top_tb_behav/xsim.reloc");
}

	// Initialize Verilog nets in mixed simulation, for the cases when the value at time 0 should be propagated from the mixed language Vhdl net

void wrapper_func_0(char *dp)

{

}

void simulate(char *dp)
{
		iki_schedule_processes_at_time_zero(dp, "xsim.dir/top_tb_behav/xsim.reloc");
	wrapper_func_0(dp);

	iki_execute_processes();

	// Schedule resolution functions for the multiply driven Verilog nets that have strength
	// Schedule transaction functions for the singly driven Verilog nets that have strength

}
#include "iki_bridge.h"
void relocate(char *);

void sensitize(char *);

void simulate(char *);

extern SYSTEMCLIB_IMP_DLLSPEC void local_register_implicit_channel(int, char*);
extern void implicit_HDL_SCinstantiate();

extern void implicit_HDL_SCcleanup();

extern SYSTEMCLIB_IMP_DLLSPEC int xsim_argc_copy ;
extern SYSTEMCLIB_IMP_DLLSPEC char** xsim_argv_copy ;

int main(int argc, char **argv)
{
    iki_heap_initialize("ms", "isimmm", 0, 2147483648) ;
    iki_set_sv_type_file_path_name("xsim.dir/top_tb_behav/xsim.svtype");
    iki_set_crvs_dump_file_path_name("xsim.dir/top_tb_behav/xsim.crvsdump");
    void* design_handle = iki_create_design("xsim.dir/top_tb_behav/xsim.mem", (void *)relocate, (void *)sensitize, (void *)simulate, 0, isimBridge_getWdbWriter(), 0, argc, argv);
     iki_set_rc_trial_count(100);
    (void) design_handle;
    return iki_simulate_design();
}
