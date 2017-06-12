//------------------------------------------------------------------------------
// M0S - Tiny 1024 bytes RTOS for Cortex M0 devices (and other Ms)
// Author: Dumitru Stama
// Date: 2016-11-30
// License: Public Domain
//------------------------------------------------------------------------------
.thumb
.syntax unified
//.include "stm32f072.inc"
.text

//------------------- usefull macros --------------------
.macro ret
    bx lr
.endm

.macro call address
    bl \address
.endm

//-----------------------------------------------------------------------------
// This is the vector table. I didn't include all the upper vectors since
// this is a 1KB contest and I don't intend to use peripheral interrupts
//-----------------------------------------------------------------------------
Vector_Table:    
    .word  0x000003FC                   // Top of stack (same as kernel stack)
    .word  _start+1                     // Start address 
    .word  0
    .word  0
    .word  0
    .word  0
    .word  0
    .word  0
    .word  0
    .word  0
    .word  0
    .word  0
    .word  0
    .word  0
    .word  0
    .word  0
    .word  0
    .word  0
    .word  0
    .word  0
    .word  0
    .word  0
    .word  0
    .word  0
    .word  0
    .word  0
    .word  0
    .word  0
    .word  0
    .word  0
    .word  0
    .word  0
//==============================================================================
// This is the main entry point as mentioned in the second interrupt vector
// This code inits memory and stacks and systick and calls "init()" which
// should be present in the C code
//==============================================================================
_start:
	b main

//---------------------------------------- END OF CODE ------------------------
// The assembler should put the literal constants in this section after .pool
.pool

//-----------------------------------------------------------------------------
// This string is here to fill in the remaining space till 1024 bytes
// Comes after the .pool section so it's the last available thing in .bin
// Update: string doesn't fit anymore, I updated the mutexes to work better
//.ascii "M0S-1K HaD Challenge"

//------------------------------------------------------------------------------
// I define this here as weak because most likely I will define it again in the C code
.weak init

//------------------------------------------------------------------------------
// Here are the exported functions
.global _start

