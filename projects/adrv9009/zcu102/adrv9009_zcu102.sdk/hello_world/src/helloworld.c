/******************************************************************************
*
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/

/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"

#define VERBOSE 1
#define TX_BRAM_START 	0x80010000
#define RX_BRAM_START 	0x80020000
#define SYS_CNTRL_START 0x80000000
#define BRAM_SIZE  		0x10000


int main()
{
    init_platform();

    printf("\r\n\r\n Hello World\r\n");

    uint32_t status = *(uint32_t *) (SYS_CNTRL_START + 0x10);
    printf("%x\n\r", status);
    if(status == 0x707)
    	printf("Transceiver power and resets are good\r\n");
    else
    	printf("Transceiver power and resets are wrong\r\n!");


    print("Filling TX bram with squarewave\r\n");
    print("Running Squarewave\r\n");

    uint32_t *pt_addr = (uint32_t *) TX_BRAM_START;

    //pt_addr incrementing 1 corresponds to getting the next 4 bytes.
    //Since size(tx_bram) = 0x10000, set imax to 0x10000/4 here
    for(int i=0; i<BRAM_SIZE/4; i++)
    {
    	if(i<1000)
    	{
    		if((i % 2) == 0)
    			*pt_addr = 0xF0F0F0F0;
    		else
    			*pt_addr = 0xF0;
    	}
    	else
    		*pt_addr = 0;
#if VERBOSE
    	printf("Value: 0x%x Address: 0x%p \r\n", *pt_addr, (uint32_t *) pt_addr);
#endif
    	pt_addr = pt_addr + 1;
    }

    status = *(uint32_t *) (SYS_CNTRL_START + 0x10);
    printf("%x\n\r", status);

    uint32_t *pt_addr1 = (uint32_t *) SYS_CNTRL_START;

    /*
    printf("Reset Asserted\n\r");
    *pt_addr1 = 0x5;
    *pt_addr1 */

    status = *(uint32_t *) (SYS_CNTRL_START + 0x10);
    printf("%x\n\r", status);

    printf("Reset Deasserted\n\r");
    *pt_addr1 = 0x4;

    status = *(uint32_t *) (SYS_CNTRL_START + 0x10);
    printf("%x\n\r", status);

    printf("Enable TX/RX BRAM\n\r");
    *pt_addr1 = 0x34;

    status = *(uint32_t *) (SYS_CNTRL_START + 0x10);
    printf("%x\n\r", status);

    //Read the status and poll for done
	printf("Poll status until TX/RX done assert\r\n");
	uint16_t bit_status;

	/*
	status = *(uint32_t *) (SYS_CNTRL_START + 0x10);
	bit_status = ((status >> 4) & 0x0F);
	printf("status 0x%x 0x%x\r\n", status, bit_status);


	while(bit_status != 3)
	{
		status = *(uint32_t *) 0x80000010;
		bit_status = ((status >> 4) & 0x0F);
		printf("status 0x%x 0x%x\r\n", status, bit_status);
	}

	status = *(uint32_t *) (SYS_CNTRL_START + 0x10);
	bit_status = ((status >> 4) & 0x0F);
	printf("status 0x%x 0x%x\r\n", status, bit_status);
	*/
	status = *(uint32_t *) (SYS_CNTRL_START + 0x10);

	while(status != 0x727)
	{
		status = *(uint32_t *) 0x80000010;
		bit_status = ((status >> 4) & 0x0F);
		printf("status 0x%x 0x%x\r\n", status, bit_status);
	}


    pt_addr = (uint32_t *) RX_BRAM_START;

    //pt_addr incrementing 1 corresponds to getting the next 4 bytes.
    //Since size(tx_bram) = 0x10000, set imax to 0x10000/4 here


    for(int i=0; i<100; i++)
    {
    	printf("Value: 0x%x Address: 0x%p \r\n", *pt_addr, (uint32_t *) pt_addr);
    	pt_addr = pt_addr + 1;
    }


    cleanup_platform();
    return 0;
}
