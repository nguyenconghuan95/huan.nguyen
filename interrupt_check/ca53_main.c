#include "tsprintf.h"
#include "cx_generic.h"
#include "romsim_common.h"
#include "BURST_base_addr.h"
#include "ca53_interrupt_handler.h"

void extint_int_handler(void);
void tim_int_handler(void);

int main ()
{

        // RAMA ECC disable ( Don't Modify )
        CPU_WRW(SYS_base_addr+0x110,0);
        CPU_WRW(RAMA_base_addr+0x00,0x4620);
        CPU_WRW(RAMA_base_addr+0x40,0x4620);
        CPU_WRW(RAMA_base_addr+0x80,0x4620);
        CPU_WRW(RAMA_base_addr+0xC0,0x4620);

        // check start
        sim_milestone(1);
        tsprintf("%s(%d):Scenario start.\n",__FILE__,__LINE__);

        //====================================================
        // IRQ Setting
        //====================================================
        irqInitialize();

        irqSetting(100,0,0,0,&extint_int_handler);
        irqSetting(101,0,0,0,&extint_int_handler);
        irqSetting(102,0,0,0,&extint_int_handler);
        irqSetting(139,0,0,0,&tim_int_handler);

        //====================================================
        // Scenario
        //====================================================
                // TIM0 CLK & Reset setting
                CPU_WRW((CPG_base_addr+0x420),0x00110011);
                CPU_WRW((CPG_base_addr+0x614),0x00010001);

                // TIM0 Timer set
                uint32_t ch=0;
                CPU_WRW((TIM0_base_addr+0x80*ch+0x4),0x30);
                CPU_WRW((TIM0_base_addr+0x80*ch+0x8),0x7);

                // EXTINT and TIM0 interrupt wait
                while(1){
                        if(g_int_count>=4){
                                tsprintf("%s(%d):Scenario finish.\n",__FILE__,__LINE__);
                                sim_finish(0);  // 0:Normal finish  1:Error finish
                        }
                        sim_milestone(g_int_count+2);
                        __asm volatile("wfi");
                }
}

void extint_int_handler(void){
        uint32_t id = g_int_id - 100;
        switch(id){
                case    0 :
                        CPU_WRW( RAMA_RAM_base_addr , 0xdeadbeaf );
                        break;
                case    1 :
                        CPU_WRW( RAMA_RAM_base_addr , 0x01234567 );
                        break;
                case    2 :
                        CPU_WRW( RAMA_RAM_base_addr , 0x89abcdef );
                        break;
        }
}

void tim_int_handler(){
        uint32_t ch = g_int_id - 139;
        CPU_WRW((TIM0_base_addr+0x80*ch+0xC),0x1);
}
