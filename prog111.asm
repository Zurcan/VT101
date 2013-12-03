;CodeVisionAVR C Compiler V1.24.5 Standard
;(C) Copyright 1998-2005 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;e-mail:office@hpinfotech.com

;Chip type              : ATmega16
;Program type           : Application
;Clock frequency        : 16,000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External SRAM size     : 0
;Data Stack size        : 300 byte(s)
;Heap size              : 0 byte(s)
;Promote char to int    : No
;char is unsigned       : Yes
;8 bit enums            : Yes
;Word align FLASH struct: No
;Enhanced core instructions    : On
;Automatic register allocation : On

	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_adc_noise_red=0x10
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __CLRD1S
	LDI  R30,0
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+@1)
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+@1)
	LDI  R31,HIGH(@0+@1)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+@1)
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+@2)
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+@3)
	LDI  R@1,HIGH(@2+@3)
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+@1
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	LDS  R22,@0+@1+2
	LDS  R23,@0+@1+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@2,@0+@1
	.ENDM

	.MACRO __GETWRMN
	LDS  R@2,@0+@1
	LDS  R@3,@0+@1+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+@1
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+@1
	LDS  R27,@0+@1+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+@1
	LDS  R27,@0+@1+1
	LDS  R24,@0+@1+2
	LDS  R25,@0+@1+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+@1,R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+@1,R30
	STS  @0+@1+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+@1,R30
	STS  @0+@1+1,R31
	STS  @0+@1+2,R22
	STS  @0+@1+3,R23
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+@1,R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+@1,R@2
	STS  @0+@1+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	ICALL
	.ENDM


	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	CALL __GETW1PF
	ICALL
	.ENDM


	.MACRO __CALL2EN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	CALL __EEPROMRDW
	ICALL
	.ENDM


	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CLR  R0
	ST   Z+,R0
	ST   Z,R0
	.ENDM

	.MACRO __CLRD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CLR  R0
	ST   Z+,R0
	ST   Z+,R0
	ST   Z+,R0
	ST   Z,R0
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R@1
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOV  R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOV  R30,R0
	.ENDM

	.CSEG
	.ORG 0

	.INCLUDE "prog1.vec"
	.INCLUDE "prog1.inc"

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,13
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(0x400)
	LDI  R25,HIGH(0x400)
	LDI  R26,0x60
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;STACK POINTER INITIALIZATION
	LDI  R30,LOW(0x45F)
	OUT  SPL,R30
	LDI  R30,HIGH(0x45F)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(0x18C)
	LDI  R29,HIGH(0x18C)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x18C
;       1 /*****************************************************
;       2 Project : Для ВИБРО-Т 
;       3 Version : V3.03.02
;       4 Date    : 03.04.2007
;       5 Author  : Метелкин Евгений          
;       6 Company : ООО ЭЛЬТЭРА           
;       7 Comments: V1.24.5 Standard
;       8 
;       9 Chip type           : ATmega16
;      10 Program type        : Application
;      11 Clock frequency     : 16,000000 MHz
;      12 *****************************************************/
;      13 #include <def.h>

	.CSEG
;      14 //--------------------------------------//
;      15 //	USART Receiver buffer
;      16 //--------------------------------------//
;      17 #define RX_BUFFER_SIZE 24
;      18 char rx_buffer[RX_BUFFER_SIZE];

	.DSEG
_rx_buffer:
	.BYTE 0x18
;      19 unsigned char rx_counter,mod_time,mod_time_s,rx_wr_index;
;      20 bit rx_c,ti_en,rx_m;
;      21 interrupt [USART_RXC] void usart_rx_isr(void)
;      22         {

	.CSEG
_usart_rx_isr:
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
;      23 
;      24 	char status,d;
;      25 	status=UCSRA;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R16
;	d -> R17
	IN   R16,11
;      26 	d=UDR;
	IN   R17,12
;      27 	if (((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)&&((ti_en==0)&&(rx_c==0)))
	MOV  R30,R16
	ANDI R30,LOW(0x1C)
	BRNE _0x4
	SBRC R2,1
	RJMP _0x5
	SBRS R2,0
	RJMP _0x6
_0x5:
	RJMP _0x4
_0x6:
	RJMP _0x7
_0x4:
	RJMP _0x3
_0x7:
;      28 		{
;      29 		if (mod_time==0){DDRD.5=0;rx_m=1;rx_wr_index=0;}
	TST  R7
	BRNE _0x8
	CBI  0x11,5
	SET
	BLD  R2,2
	CLR  R9
;      30 		mod_time=mod_time_s;
_0x8:
	MOV  R7,R8
;      31 		rx_buffer[rx_wr_index]=d;
	MOV  R26,R9
	LDI  R27,0
	SUBI R26,LOW(-_rx_buffer)
	SBCI R27,HIGH(-_rx_buffer)
	ST   X,R17
;      32 		if (++rx_wr_index >= RX_BUFFER_SIZE)  rx_wr_index=0;
	INC  R9
	LDI  R30,LOW(24)
	CP   R9,R30
	BRLO _0x9
	CLR  R9
;      33 		if (++rx_counter >= RX_BUFFER_SIZE){rx_counter=0;}
_0x9:
	INC  R6
	LDI  R30,LOW(24)
	CP   R6,R30
	BRLO _0xA
	CLR  R6
;      34 		}
_0xA:
;      35 	
;      36 // 	char status,d;
;      37 // 	status=UCSRA;
;      38 // 	d=UDR;
;      39 // 	if (((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)&&((ti_en==0)&&(rx_c==0)))
;      40 // 		{
;      41 // 		if (mod_time==0){rx_m=1;rx_counter=0;}
;      42 // 		mod_time=mod_time_s;
;      43 // 		rx_buffer[rx_counter]=d;
;      44 // 		if (++rx_counter >= RX_BUFFER_SIZE)rx_counter=0;
;      45 // 		}
;      46 	}
_0x3:
	LD   R16,Y+
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
;      47 //--------------------------------------//
;      48 // USART Transmitter buffer
;      49 //--------------------------------------//
;      50 #define TX_BUFFER_SIZE 64
;      51 char tx_buffer[TX_BUFFER_SIZE];

	.DSEG
_tx_buffer:
	.BYTE 0x40
;      52 unsigned char tx_buffer_begin,tx_buffer_end;
;      53 interrupt [USART_TXC] void usart_tx_isr(void)
;      54         {

	.CSEG
_usart_tx_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
;      55         if (ti_en==1)
	SBRS R2,1
	RJMP _0xB
;      56 	        {
;      57         	if (++tx_buffer_begin>=TX_BUFFER_SIZE) tx_buffer_begin=0;
	INC  R10
	LDI  R30,LOW(64)
	CP   R10,R30
	BRLO _0xC
	CLR  R10
;      58 	        if (tx_buffer_begin!=tx_buffer_end) {UDR=tx_buffer[tx_buffer_begin];}
_0xC:
	CP   R11,R10
	BREQ _0xD
	CALL SUBOPT_0x0
;      59         	else {ti_en=0;rx_c=0;rx_m=0;rx_tx=0;}
	RJMP _0xE
_0xD:
	CLT
	BLD  R2,1
	BLD  R2,0
	BLD  R2,2
	CBI  0x12,2
_0xE:
;      60 	        }
;      61         }
_0xB:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;      62 //-------------------------------------------------------------------//
;      63 bit buzer_en,buzer,pik_en,buzer_buzer_en;
;      64 char pik_count;
;      65 interrupt [TIM0_OVF] void timer0_ovf_isr(void)
;      66         {//прерывание для бузера
_timer0_ovf_isr:
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
;      67         TCNT0=TCNT0_reload;
	LDI  R30,LOW(220)
	OUT  0x32,R30
;      68         #asm("wdr");
	wdr
;      69         if ((buzer_en==1)&&(buzer_buzer_en==1)){if (buzer==1) {buzerp=1;buzer=0;}else {buzerp=0;buzer=1;}}
	SBRS R2,3
	RJMP _0x10
	SBRC R2,6
	RJMP _0x11
_0x10:
	RJMP _0xF
_0x11:
	SBRS R2,4
	RJMP _0x12
	SBI  0x12,5
	CLT
	BLD  R2,4
	RJMP _0x13
_0x12:
	CBI  0x12,5
	SET
	BLD  R2,4
_0x13:
;      70         else if (pik_en==1){if (++pik_count>200) {pik_en=0;pik_count=0;}if (buzer==1) {buzerp=1;buzer=0;}else {buzerp=0;buzer=1;}}
	RJMP _0x14
_0xF:
	SBRS R2,5
	RJMP _0x15
	CALL SUBOPT_0x1
	BRSH _0x16
	CLT
	BLD  R2,5
	CLR  R12
_0x16:
	SBRS R2,4
	RJMP _0x17
	SBI  0x12,5
	CLT
	BLD  R2,4
	RJMP _0x18
_0x17:
	CBI  0x12,5
	SET
	BLD  R2,4
_0x18:
;      71         else buzerp=0;
	RJMP _0x19
_0x15:
	CBI  0x12,5
;      72         if (pik_en==1){if (++pik_count>200) {pik_en=0;pik_count=0;}}
_0x19:
_0x14:
	SBRS R2,5
	RJMP _0x1A
	CALL SUBOPT_0x1
	BRSH _0x1B
	CLT
	BLD  R2,5
	CLR  R12
_0x1B:
;      73         }
_0x1A:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	RETI
;      74 char led_byte[5,2];

	.DSEG
_led_byte:
	.BYTE 0xA
;      75 interrupt [TIM0_COMP] void timer0_comp_isr(void){}

	.CSEG
_timer0_comp_isr:
	RETI
;      76 interrupt [TIM1_OVF] void timer1_ovf_isr(void){TCNT1H=0x05;TCNT1L=0x01;}
_timer1_ovf_isr:
	ST   -Y,R30
	LDI  R30,LOW(5)
	OUT  0x2D,R30
	LDI  R30,LOW(1)
	OUT  0x2C,R30
	LD   R30,Y+
	RETI
;      77 interrupt [TIM1_CAPT] void timer1_capt_isr(void){}
_timer1_capt_isr:
	RETI
;      78 interrupt [TIM1_COMPA] void timer1_compa_isr(void){}
_timer1_compa_isr:
	RETI
;      79 interrupt [TIM1_COMPB] void timer1_compb_isr(void){}
_timer1_compb_isr:
	RETI
;      80 //-------------------------------------------------------------------//
;      81 // прерывание каждые 500 мкс
;      82 //-------------------------------------------------------------------//
;      83 long sys_time,whait_time;

	.DSEG
_sys_time:
	.BYTE 0x4
_whait_time:
	.BYTE 0x4
;      84 bit key_mode,key_plus,key_mines,key_enter,key_mode_press,key_plus_press,key_mines_press,key_enter_press,key_mode_press_switch;
;      85 bit key_plus_press_switch,key_minus_press_switch,key_enter_press_switch;
;      86 char count_led,drebezg;
;      87 bit avaria,alarm1,alarm2,alarm_alarm1,alarm_alarm2;
;      88 int count_blink;
_count_blink:
	.BYTE 0x2
;      89 //-------------------------------------------------------------------//
;      90 interrupt [TIM2_OVF] void timer2_ovf_isr(void)
;      91         {//прерывание 500мкс

	.CSEG
_timer2_ovf_isr:
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
;      92         char n;
;      93         TCNT2=TCNT2_reload;
	ST   -Y,R16
;	n -> R16
	LDI  R30,LOW(131)
	OUT  0x24,R30
;      94         #asm("sei");
	sei
;      95         sys_time=sys_time+1;
	LDS  R30,_sys_time
	LDS  R31,_sys_time+1
	LDS  R22,_sys_time+2
	LDS  R23,_sys_time+3
	__ADDD1N 1
	STS  _sys_time,R30
	STS  _sys_time+1,R31
	STS  _sys_time+2,R22
	STS  _sys_time+3,R23
;      96 
;      97 	if (mod_time==0){if (rx_m==1) {rx_c=1;	rx_tx=1;}}
	TST  R7
	BRNE _0x1C
	SBRS R2,2
	RJMP _0x1D
	SET
	BLD  R2,0
	SBI  0x12,2
_0x1D:
;      98 	else 	mod_time--;
	RJMP _0x1E
_0x1C:
	DEC  R7
;      99 
;     100 
;     101         if (key_1==0){key_mode=1;if ((key_mode_press==0)&&(pik_en==0)){key_mode_press_switch=1;pik_en=1;drebezg=0;}key_mode_press=1;}
_0x1E:
	SBIC 0x13,0
	RJMP _0x1F
	SET
	BLD  R2,7
	SBRC R3,3
	RJMP _0x21
	SBRS R2,5
	RJMP _0x22
_0x21:
	RJMP _0x20
_0x22:
	SET
	BLD  R3,7
	BLD  R2,5
	CLR  R14
_0x20:
	SET
	BLD  R3,3
;     102         else if ((key_2==1)&&(key_3==1)&&(key_4==1)&&(++drebezg>DREBEZG_TIME)){key_mode=0;key_mode_press=0;}
	RJMP _0x23
_0x1F:
	SBIS 0x13,1
	RJMP _0x25
	SBIS 0x10,6
	RJMP _0x25
	SBIS 0x10,7
	RJMP _0x25
	CALL SUBOPT_0x2
	BRLO _0x26
_0x25:
	RJMP _0x24
_0x26:
	CLT
	BLD  R2,7
	BLD  R3,3
;     103 
;     104         if (key_2==0){key_plus=1;if ((key_plus_press==0)&&(pik_en==0)){key_plus_press_switch=1;pik_en=1;drebezg=0;}key_plus_press=1;}
_0x24:
_0x23:
	SBIC 0x13,1
	RJMP _0x27
	SET
	BLD  R3,0
	SBRC R3,4
	RJMP _0x29
	SBRS R2,5
	RJMP _0x2A
_0x29:
	RJMP _0x28
_0x2A:
	SET
	BLD  R4,0
	BLD  R2,5
	CLR  R14
_0x28:
	SET
	BLD  R3,4
;     105         else if ((key_1==1)&&(key_3==1)&&(key_4==1)&&(++drebezg>DREBEZG_TIME)){key_plus=0;key_plus_press=0;}
	RJMP _0x2B
_0x27:
	SBIS 0x13,0
	RJMP _0x2D
	SBIS 0x10,6
	RJMP _0x2D
	SBIS 0x10,7
	RJMP _0x2D
	CALL SUBOPT_0x2
	BRLO _0x2E
_0x2D:
	RJMP _0x2C
_0x2E:
	CLT
	BLD  R3,0
	BLD  R3,4
;     106            
;     107         if (key_3==0){key_mines=1;if ((key_mines_press==0)&&(pik_en==0)){key_minus_press_switch=1;pik_en=1;drebezg=0;}key_mines_press=1;}
_0x2C:
_0x2B:
	SBIC 0x10,6
	RJMP _0x2F
	SET
	BLD  R3,1
	SBRC R3,5
	RJMP _0x31
	SBRS R2,5
	RJMP _0x32
_0x31:
	RJMP _0x30
_0x32:
	SET
	BLD  R4,1
	BLD  R2,5
	CLR  R14
_0x30:
	SET
	BLD  R3,5
;     108         else if ((key_2==1)&&(key_1==1)&&(key_4==1)&&(++drebezg>DREBEZG_TIME)){key_mines=0;key_mines_press=0;}
	RJMP _0x33
_0x2F:
	SBIS 0x13,1
	RJMP _0x35
	SBIS 0x13,0
	RJMP _0x35
	SBIS 0x10,7
	RJMP _0x35
	CALL SUBOPT_0x2
	BRLO _0x36
_0x35:
	RJMP _0x34
_0x36:
	CLT
	BLD  R3,1
	BLD  R3,5
;     109                 
;     110         if (key_4==0){key_enter=1;if (key_enter_press==0){key_enter_press_switch=1;pik_en=1;whait_time=sys_time;}key_enter_press=1;alarm_alarm1=0;alarm_alarm2=0;}
_0x34:
_0x33:
	SBIC 0x10,7
	RJMP _0x37
	SET
	BLD  R3,2
	SBRC R3,6
	RJMP _0x38
	BLD  R4,2
	BLD  R2,5
	LDS  R30,_sys_time
	LDS  R31,_sys_time+1
	LDS  R22,_sys_time+2
	LDS  R23,_sys_time+3
	STS  _whait_time,R30
	STS  _whait_time+1,R31
	STS  _whait_time+2,R22
	STS  _whait_time+3,R23
_0x38:
	SET
	BLD  R3,6
	CLT
	BLD  R4,6
	BLD  R4,7
;     111         else {key_enter=0;key_enter_press=0;}
	RJMP _0x39
_0x37:
	CLT
	BLD  R3,2
	BLD  R3,6
_0x39:
;     112         
;     113         if (++count_blink>2000) count_blink=0;
	LDS  R26,_count_blink
	LDS  R27,_count_blink+1
	ADIW R26,1
	STS  _count_blink,R26
	STS  _count_blink+1,R27
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x3A
	LDI  R30,0
	STS  _count_blink,R30
	STS  _count_blink+1,R30
;     114         if (count_blink<300) {n=1;buzer_en=0;if ((alarm_alarm1==1)||(alarm_alarm2==1))buzer_en=1;else buzer_en=0;}
_0x3A:
	LDS  R26,_count_blink
	LDS  R27,_count_blink+1
	CPI  R26,LOW(0x12C)
	LDI  R30,HIGH(0x12C)
	CPC  R27,R30
	BRGE _0x3B
	LDI  R16,LOW(1)
	CLT
	BLD  R2,3
	SBRC R4,6
	RJMP _0x3D
	SBRS R4,7
	RJMP _0x3C
_0x3D:
	SET
	BLD  R2,3
	RJMP _0x3F
_0x3C:
	CLT
	BLD  R2,3
_0x3F:
;     115         else {n=0;if ((alarm1==1)||(alarm2==1))buzer_en=1;}
	RJMP _0x40
_0x3B:
	LDI  R16,LOW(0)
	SBRC R4,4
	RJMP _0x42
	SBRS R4,5
	RJMP _0x41
_0x42:
	SET
	BLD  R2,3
_0x41:
_0x40:
;     116         PORTA=0xFF;
	LDI  R30,LOW(255)
	OUT  0x1B,R30
;     117         anode1=0;anode2=0;anode3=0;anode4=0;anode5=0;DDRC.3=0;DDRC.4=0;DDRC.5=0;DDRC.6=0;DDRC.7=0;
	CBI  0x15,3
	CBI  0x15,4
	CBI  0x15,5
	CBI  0x15,6
	CBI  0x15,7
	CBI  0x14,3
	CBI  0x14,4
	CBI  0x14,5
	CBI  0x14,6
	CBI  0x14,7
;     118         switch (count_led)        
	MOV  R30,R13
;     119                 {
;     120                 case 9: count_led=0;anode1=1;DDRC.3=1;PORTA=led_byte[0,n];break;
	CPI  R30,LOW(0x9)
	BRNE _0x47
	CLR  R13
	SBI  0x15,3
	SBI  0x14,3
	CALL SUBOPT_0x3
	RJMP _0x46
;     121                 case 8: count_led=9;anode1=1;DDRC.3=1;PORTA=led_byte[0,n];break;
_0x47:
	CPI  R30,LOW(0x8)
	BRNE _0x48
	LDI  R30,LOW(9)
	MOV  R13,R30
	SBI  0x15,3
	SBI  0x14,3
	CALL SUBOPT_0x3
	RJMP _0x46
;     122                 case 7: count_led=8;anode2=1;DDRC.4=1;PORTA=led_byte[1,n];break;
_0x48:
	CPI  R30,LOW(0x7)
	BRNE _0x49
	LDI  R30,LOW(8)
	MOV  R13,R30
	SBI  0x15,4
	SBI  0x14,4
	__POINTW2MN _led_byte,2
	CALL SUBOPT_0x4
	RJMP _0x46
;     123                 case 6: count_led=7;anode2=1;DDRC.4=1;PORTA=led_byte[1,n];break;
_0x49:
	CPI  R30,LOW(0x6)
	BRNE _0x4A
	LDI  R30,LOW(7)
	MOV  R13,R30
	SBI  0x15,4
	SBI  0x14,4
	__POINTW2MN _led_byte,2
	CALL SUBOPT_0x4
	RJMP _0x46
;     124                 case 5: count_led=6;anode3=1;DDRC.5=1;PORTA=led_byte[2,n];break;
_0x4A:
	CPI  R30,LOW(0x5)
	BRNE _0x4B
	LDI  R30,LOW(6)
	MOV  R13,R30
	SBI  0x15,5
	SBI  0x14,5
	__POINTW2MN _led_byte,4
	CALL SUBOPT_0x4
	RJMP _0x46
;     125                 case 4: count_led=5;anode3=1;DDRC.5=1;PORTA=led_byte[2,n];break;
_0x4B:
	CPI  R30,LOW(0x4)
	BRNE _0x4C
	LDI  R30,LOW(5)
	MOV  R13,R30
	SBI  0x15,5
	SBI  0x14,5
	__POINTW2MN _led_byte,4
	CALL SUBOPT_0x4
	RJMP _0x46
;     126                 case 3: count_led=4;anode4=1;DDRC.6=1;PORTA=led_byte[3,n];break;
_0x4C:
	CPI  R30,LOW(0x3)
	BRNE _0x4D
	LDI  R30,LOW(4)
	MOV  R13,R30
	SBI  0x15,6
	SBI  0x14,6
	__POINTW2MN _led_byte,6
	CALL SUBOPT_0x4
	RJMP _0x46
;     127                 case 2: count_led=3;anode4=1;DDRC.6=1;PORTA=led_byte[3,n];break;
_0x4D:
	CPI  R30,LOW(0x2)
	BRNE _0x4E
	LDI  R30,LOW(3)
	MOV  R13,R30
	SBI  0x15,6
	SBI  0x14,6
	__POINTW2MN _led_byte,6
	CALL SUBOPT_0x4
	RJMP _0x46
;     128                 case 1: count_led=2;anode5=1;DDRC.7=1;PORTA=led_byte[4,n];break;//anode5=1;DDRC.7=1;PORTA=0xFF;break;
_0x4E:
	CPI  R30,LOW(0x1)
	BRNE _0x50
	LDI  R30,LOW(2)
	MOV  R13,R30
	SBI  0x15,7
	SBI  0x14,7
	__POINTW2MN _led_byte,8
	CALL SUBOPT_0x4
	RJMP _0x46
;     129                 default:count_led=1;anode5=1;DDRC.7=1;PORTA=led_byte[4,n];break;
_0x50:
	LDI  R30,LOW(1)
	MOV  R13,R30
	SBI  0x15,7
	SBI  0x14,7
	__POINTW2MN _led_byte,8
	CALL SUBOPT_0x4
;     130                 }
_0x46:
;     131         }
	LD   R16,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R23,Y+
	LD   R22,Y+
	RETI
;     132 //-------------------------------------------------------------------//
;     133 interrupt [TIM2_COMP] void timer2_comp_isr(void){}
_timer2_comp_isr:
	RETI
;     134 #include <spi.h>
;     135 // #asm
;     136 // .eseg
;     137 // .org 0x10
;     138 // .cseg
;     139 // #endasm
;     140 eeprom float *ee_float;

	.DSEG
_ee_float:
	.BYTE 0x2
;     141 eeprom char *ee_char;
_ee_char:
	.BYTE 0x2
;     142 //eeprom float kal[2]={0,0.005};
;     143 eeprom float reg[30]={0,

	.ESEG
_reg:
;     144 5.6,7.1,0,5,0,1,
;     145 /*A_1  A_2  A_3  A_4  A_5  A_6   A_7  A_8  A_9  A_10  A_11  A_12  A_13  A_14  A_15  A_16  A_17  A_18  A_19 */
;     146    0,   1,   0,   0,   1, 0.00, 20.00, 2,   2,   0,    10,   2,    5,    0,    1,    1,    0,    0,    0,    1};
	.DW  0x0
	.DW  0x0
	.DW  0x3333
	.DW  0x40B3
	.DW  0x3333
	.DW  0x40E3
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x40A0
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x3F80
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x3F80
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x3F80
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x41A0
	.DW  0x0
	.DW  0x4000
	.DW  0x0
	.DW  0x4000
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x4120
	.DW  0x0
	.DW  0x4000
	.DW  0x0
	.DW  0x40A0
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x3F80
	.DW  0x0
	.DW  0x3F80
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x3F80
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
;     147 eeprom char ee_point=3;
_ee_point:
	.DB  0x3
;     148 
;     149 char mode,point,work_point,save_point;

	.DSEG
_mode:
	.BYTE 0x1
_point:
	.BYTE 0x1
_work_point:
	.BYTE 0x1
_save_point:
	.BYTE 0x1
;     150 #include <function_led.h>

	.CSEG
_led_calk:
	LD   R30,Y
	CPI  R30,0
	BRNE _0x54
	LDI  R30,LOW(64)
	ST   Y,R30
	RJMP _0x53
_0x54:
	CPI  R30,LOW(0x1)
	BRNE _0x55
	LDI  R30,LOW(121)
	ST   Y,R30
	RJMP _0x53
_0x55:
	CPI  R30,LOW(0x2)
	BRNE _0x56
	LDI  R30,LOW(36)
	ST   Y,R30
	RJMP _0x53
_0x56:
	CPI  R30,LOW(0x3)
	BRNE _0x57
	LDI  R30,LOW(48)
	ST   Y,R30
	RJMP _0x53
_0x57:
	CPI  R30,LOW(0x4)
	BRNE _0x58
	LDI  R30,LOW(25)
	ST   Y,R30
	RJMP _0x53
_0x58:
	CPI  R30,LOW(0x5)
	BRNE _0x59
	LDI  R30,LOW(18)
	ST   Y,R30
	RJMP _0x53
_0x59:
	CPI  R30,LOW(0x6)
	BRNE _0x5A
	LDI  R30,LOW(2)
	ST   Y,R30
	RJMP _0x53
_0x5A:
	CPI  R30,LOW(0x7)
	BRNE _0x5B
	LDI  R30,LOW(120)
	ST   Y,R30
	RJMP _0x53
_0x5B:
	CPI  R30,LOW(0x8)
	BRNE _0x5C
	LDI  R30,LOW(0)
	ST   Y,R30
	RJMP _0x53
_0x5C:
	CPI  R30,LOW(0x9)
	BRNE _0x5D
	LDI  R30,LOW(16)
	ST   Y,R30
	RJMP _0x53
_0x5D:
	CPI  R30,LOW(0x20)
	BRNE _0x5E
	LDI  R30,LOW(127)
	ST   Y,R30
	RJMP _0x53
_0x5E:
	CPI  R30,LOW(0x5F)
	BRNE _0x5F
	LDI  R30,LOW(119)
	ST   Y,R30
	RJMP _0x53
_0x5F:
	CPI  R30,LOW(0xD3)
	BRNE _0x60
	LDI  R30,LOW(17)
	ST   Y,R30
	RJMP _0x53
_0x60:
	CPI  R30,LOW(0x61)
	BRNE _0x61
	LDI  R30,LOW(8)
	ST   Y,R30
	RJMP _0x53
_0x61:
	CPI  R30,LOW(0xEF)
	BRNE _0x62
	LDI  R30,LOW(72)
	ST   Y,R30
	RJMP _0x53
_0x62:
	CPI  R30,LOW(0x63)
	BRNE _0x63
	LDI  R30,LOW(70)
	ST   Y,R30
	RJMP _0x53
_0x63:
	CPI  R30,LOW(0x70)
	BRNE _0x64
	LDI  R30,LOW(12)
	ST   Y,R30
	RJMP _0x53
_0x64:
	CPI  R30,LOW(0x2D)
	BRNE _0x65
	LDI  R30,LOW(63)
	ST   Y,R30
	RJMP _0x53
_0x65:
	CPI  R30,LOW(0x74)
	BRNE _0x66
	LDI  R30,LOW(114)
	ST   Y,R30
	RJMP _0x53
_0x66:
	CPI  R30,LOW(0x62)
	BRNE _0x67
	LDI  R30,LOW(121)
	ST   Y,R30
	RJMP _0x53
_0x67:
	CPI  R30,LOW(0x64)
	BRNE _0x68
	LDI  R30,LOW(94)
	ST   Y,R30
	RJMP _0x53
_0x68:
	CPI  R30,LOW(0x65)
	BRNE _0x69
	LDI  R30,LOW(47)
	ST   Y,R30
	RJMP _0x53
_0x69:
	CPI  R30,LOW(0x66)
	BRNE _0x6A
	LDI  R30,LOW(23)
	ST   Y,R30
	RJMP _0x53
_0x6A:
	CPI  R30,LOW(0x67)
	BRNE _0x6B
	LDI  R30,LOW(75)
	ST   Y,R30
	RJMP _0x53
_0x6B:
	CPI  R30,LOW(0x68)
	BRNE _0x6D
	LDI  R30,LOW(101)
	ST   Y,R30
	RJMP _0x53
_0x6D:
	LDI  R30,LOW(114)
	ST   Y,R30
_0x53:
	LD   R30,Y
	ADIW R28,1
	RET
_set_led_on:
	ST   -Y,R16
;	a -> Y+8
;	b -> Y+7
;	c -> Y+6
;	d -> Y+5
;	p1 -> Y+4
;	p2 -> Y+3
;	p3 -> Y+2
;	p4 -> Y+1
;	i -> R16
	SBRS R4,3
	RJMP _0x6E
	LDI  R30,LOW(0)
	STD  Y+5,R30
_0x6E:
	LDD  R30,Y+4
	CPI  R30,0
	BRNE _0x6F
	LDS  R16,_led_byte
	ORI  R16,LOW(128)
	STS  _led_byte,R16
	RJMP _0x70
_0x6F:
	LDS  R16,_led_byte
	ANDI R16,LOW(127)
	STS  _led_byte,R16
_0x70:
	LDD  R30,Y+3
	CPI  R30,0
	BRNE _0x71
	__POINTW1MN _led_byte,2
	LD   R16,Z
	ORI  R16,LOW(128)
	__PUTBMRN _led_byte,2,16
	RJMP _0x72
_0x71:
	__POINTW1MN _led_byte,2
	LD   R16,Z
	ANDI R16,LOW(127)
	__PUTBMRN _led_byte,2,16
_0x72:
	LDD  R30,Y+2
	CPI  R30,0
	BRNE _0x73
	__POINTW1MN _led_byte,4
	LD   R16,Z
	ORI  R16,LOW(128)
	__PUTBMRN _led_byte,4,16
	RJMP _0x74
_0x73:
	__POINTW1MN _led_byte,4
	LD   R16,Z
	ANDI R16,LOW(127)
	__PUTBMRN _led_byte,4,16
_0x74:
	LDD  R30,Y+1
	CPI  R30,0
	BRNE _0x75
	__POINTW1MN _led_byte,6
	LD   R16,Z
	ORI  R16,LOW(128)
	__PUTBMRN _led_byte,6,16
	RJMP _0x76
_0x75:
	__POINTW1MN _led_byte,6
	LD   R16,Z
	ANDI R16,LOW(127)
	__PUTBMRN _led_byte,6,16
_0x76:
	LDD  R26,Y+8
	CPI  R26,LOW(0x0)
	BRNE _0x78
	SBRS R4,3
	RJMP _0x79
_0x78:
	RJMP _0x77
_0x79:
	__GETB1MN _led_byte,8
	ORI  R30,1
	__PUTB1MN _led_byte,8
	RJMP _0x7A
_0x77:
	__GETB1MN _led_byte,8
	ANDI R30,0xFE
	__PUTB1MN _led_byte,8
_0x7A:
	LDD  R26,Y+7
	CPI  R26,LOW(0x0)
	BRNE _0x7C
	SBRS R4,5
	RJMP _0x7D
_0x7C:
	RJMP _0x7B
_0x7D:
	__GETB1MN _led_byte,8
	ORI  R30,2
	__PUTB1MN _led_byte,8
	RJMP _0x7E
_0x7B:
	__GETB1MN _led_byte,8
	ANDI R30,0xFD
	__PUTB1MN _led_byte,8
_0x7E:
	LDD  R26,Y+6
	CPI  R26,LOW(0x0)
	BRNE _0x80
	SBRS R4,4
	RJMP _0x81
_0x80:
	RJMP _0x7F
_0x81:
	__GETB1MN _led_byte,8
	ORI  R30,4
	__PUTB1MN _led_byte,8
	RJMP _0x82
_0x7F:
	__GETB1MN _led_byte,8
	ANDI R30,0xFB
	__PUTB1MN _led_byte,8
_0x82:
	LDD  R30,Y+5
	CPI  R30,0
	BRNE _0x83
	__GETB1MN _led_byte,8
	ORI  R30,8
	__PUTB1MN _led_byte,8
	RJMP _0x84
_0x83:
	__GETB1MN _led_byte,8
	ANDI R30,0XF7
	__PUTB1MN _led_byte,8
_0x84:
	RJMP _0x29C
_set_led_off:
	ST   -Y,R16
;	a -> Y+8
;	b -> Y+7
;	c -> Y+6
;	d -> Y+5
;	p1 -> Y+4
;	p2 -> Y+3
;	p3 -> Y+2
;	p4 -> Y+1
;	i -> R16
	SBRS R4,3
	RJMP _0x85
	LDI  R30,LOW(0)
	STD  Y+5,R30
_0x85:
	LDD  R30,Y+4
	CPI  R30,0
	BRNE _0x86
	__POINTW1MN _led_byte,1
	LD   R16,Z
	ORI  R16,LOW(128)
	__PUTBMRN _led_byte,1,16
	RJMP _0x87
_0x86:
	__POINTW1MN _led_byte,1
	LD   R16,Z
	ANDI R16,LOW(127)
	__PUTBMRN _led_byte,1,16
_0x87:
	LDD  R30,Y+3
	CPI  R30,0
	BRNE _0x88
	__POINTW1MN _led_byte,3
	LD   R16,Z
	ORI  R16,LOW(128)
	__PUTBMRN _led_byte,3,16
	RJMP _0x89
_0x88:
	__POINTW1MN _led_byte,3
	LD   R16,Z
	ANDI R16,LOW(127)
	__PUTBMRN _led_byte,3,16
_0x89:
	LDD  R30,Y+2
	CPI  R30,0
	BRNE _0x8A
	__POINTW1MN _led_byte,5
	LD   R16,Z
	ORI  R16,LOW(128)
	__PUTBMRN _led_byte,5,16
	RJMP _0x8B
_0x8A:
	__POINTW1MN _led_byte,5
	LD   R16,Z
	ANDI R16,LOW(127)
	__PUTBMRN _led_byte,5,16
_0x8B:
	LDD  R30,Y+1
	CPI  R30,0
	BRNE _0x8C
	__POINTW1MN _led_byte,7
	LD   R16,Z
	ORI  R16,LOW(128)
	__PUTBMRN _led_byte,7,16
	RJMP _0x8D
_0x8C:
	__POINTW1MN _led_byte,7
	LD   R16,Z
	ANDI R16,LOW(127)
	__PUTBMRN _led_byte,7,16
_0x8D:
	LDD  R30,Y+8
	CPI  R30,0
	BRNE _0x8E
	__GETB1MN _led_byte,9
	ORI  R30,1
	__PUTB1MN _led_byte,9
	RJMP _0x8F
_0x8E:
	__GETB1MN _led_byte,9
	ANDI R30,0xFE
	__PUTB1MN _led_byte,9
_0x8F:
	LDD  R26,Y+7
	CPI  R26,LOW(0x0)
	BRNE _0x91
	SBRS R4,7
	RJMP _0x92
_0x91:
	RJMP _0x90
_0x92:
	__GETB1MN _led_byte,9
	ORI  R30,2
	__PUTB1MN _led_byte,9
	RJMP _0x93
_0x90:
	__GETB1MN _led_byte,9
	ANDI R30,0xFD
	__PUTB1MN _led_byte,9
_0x93:
	LDD  R26,Y+6
	CPI  R26,LOW(0x0)
	BRNE _0x95
	SBRS R4,6
	RJMP _0x96
_0x95:
	RJMP _0x94
_0x96:
	__GETB1MN _led_byte,9
	ORI  R30,4
	__PUTB1MN _led_byte,9
	RJMP _0x97
_0x94:
	__GETB1MN _led_byte,9
	ANDI R30,0xFB
	__PUTB1MN _led_byte,9
_0x97:
	LDD  R30,Y+5
	CPI  R30,0
	BRNE _0x98
	__GETB1MN _led_byte,9
	ORI  R30,8
	__PUTB1MN _led_byte,9
	RJMP _0x99
_0x98:
	__GETB1MN _led_byte,9
	ANDI R30,0XF7
	__PUTB1MN _led_byte,9
_0x99:
_0x29C:
	LDD  R16,Y+0
	ADIW R28,9
	RET
_set_digit_on:
	ST   -Y,R16
;	a -> Y+4
;	b -> Y+3
;	c -> Y+2
;	d -> Y+1
;	i -> R16
	LDS  R16,_led_byte
	ANDI R16,LOW(128)
	CALL SUBOPT_0x5
	OR   R16,R30
	STS  _led_byte,R16
	__POINTW1MN _led_byte,2
	LD   R16,Z
	ANDI R16,LOW(128)
	CALL SUBOPT_0x6
	OR   R16,R30
	__PUTBMRN _led_byte,2,16
	__POINTW1MN _led_byte,4
	LD   R16,Z
	ANDI R16,LOW(128)
	CALL SUBOPT_0x7
	OR   R16,R30
	__PUTBMRN _led_byte,4,16
	__POINTW1MN _led_byte,6
	LD   R16,Z
	ANDI R16,LOW(128)
	CALL SUBOPT_0x8
	OR   R16,R30
	__PUTBMRN _led_byte,6,16
	LDD  R16,Y+0
	RJMP _0x29B
_set_digit_off:
	ST   -Y,R16
;	a -> Y+4
;	b -> Y+3
;	c -> Y+2
;	d -> Y+1
;	i -> R16
	__POINTW1MN _led_byte,1
	LD   R16,Z
	ANDI R16,LOW(128)
	CALL SUBOPT_0x5
	OR   R16,R30
	__PUTBMRN _led_byte,1,16
	__POINTW1MN _led_byte,3
	LD   R16,Z
	ANDI R16,LOW(128)
	CALL SUBOPT_0x6
	OR   R16,R30
	__PUTBMRN _led_byte,3,16
	__POINTW1MN _led_byte,5
	LD   R16,Z
	ANDI R16,LOW(128)
	CALL SUBOPT_0x7
	OR   R16,R30
	__PUTBMRN _led_byte,5,16
	__POINTW1MN _led_byte,7
	LD   R16,Z
	ANDI R16,LOW(128)
	CALL SUBOPT_0x8
	OR   R16,R30
	__PUTBMRN _led_byte,7,16
	LDD  R16,Y+0
	RJMP _0x29B
;     151 
;     152         
;     153 char ed,des,sot,tis,count_filter,count_filter1,i,count_key,count_key1;

	.DSEG
_ed:
	.BYTE 0x1
_des:
	.BYTE 0x1
_sot:
	.BYTE 0x1
_tis:
	.BYTE 0x1
_count_filter:
	.BYTE 0x1
_count_filter1:
	.BYTE 0x1
_i:
	.BYTE 0x1
_count_key:
	.BYTE 0x1
_count_key1:
	.BYTE 0x1
;     154 long filter_value;
_filter_value:
	.BYTE 0x4
;     155 unsigned int adc_buf,filter_min,filter_max,filter_buf[9],filter_buf1[100];
_adc_buf:
	.BYTE 0x2
_filter_min:
	.BYTE 0x2
_filter_max:
	.BYTE 0x2
_filter_buf:
	.BYTE 0x12
_filter_buf1:
	.BYTE 0xC8
;     156 
;     157 void hex2dec(float x)		// подпрограмма преобразования кода в ASCII
;     158  	{				//

	.CSEG
_hex2dec:
;     159  	char str[9],str1[9];
;     160  	signed char a,b;
;     161  	if (x<-999) x=-999;
	SBIW R28,18
	ST   -Y,R17
	ST   -Y,R16
;	x -> Y+20
;	str -> Y+11
;	str1 -> Y+2
;	a -> R16
;	b -> R17
	__GETD2S 20
	__GETD1N 0xC479C000
	CALL __CMPF12
	BRSH _0x9A
	__PUTD1S 20
;     162  	if (x>9999) x=9999;
_0x9A:
	__GETD2S 20
	__GETD1N 0x461C3C00
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x9B
	__PUTD1S 20
;     163  	ftoa(x,5,str1);
_0x9B:
	__GETD1S 20
	CALL __PUTPARD1
	LDI  R30,LOW(5)
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,7
	ST   -Y,R31
	ST   -Y,R30
	CALL _ftoa
;     164  	for (a=0;a<9;a++)
	LDI  R16,LOW(0)
_0x9D:
	CPI  R16,9
	BRGE _0x9E
;     165  	        {
;     166  	        if (str1[a]=='.') goto p1;
	CALL SUBOPT_0x9
	LD   R26,X
	CPI  R26,LOW(0x2E)
	BREQ _0xA0
;     167  	        }
	SUBI R16,-1
	RJMP _0x9D
_0x9E:
;     168 p1:
_0xA0:
;     169         b=4;
	LDI  R17,LOW(4)
;     170         while ((a>=0)&&(b>=0))
_0xA1:
	CPI  R16,0
	BRLT _0xA4
	CPI  R17,0
	BRGE _0xA5
_0xA4:
	RJMP _0xA3
_0xA5:
;     171                 {
;     172                 str[b]=str1[a];
	CALL SUBOPT_0xA
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x9
	LD   R30,X
	POP  R26
	POP  R27
	ST   X,R30
;     173                 a--;b--;
	SUBI R16,1
	SUBI R17,1
;     174                 }
	RJMP _0xA1
_0xA3:
;     175         a=3-b;
	LDI  R30,LOW(3)
	SUB  R30,R17
	MOV  R16,R30
;     176         while (b>=0) {str[b]='0';b--;}
_0xA6:
	CPI  R17,0
	BRLT _0xA8
	CALL SUBOPT_0xA
	CALL SUBOPT_0xB
	SUBI R17,1
	RJMP _0xA6
_0xA8:
;     177                 
;     178         b=4;
	LDI  R17,LOW(4)
;     179         while ((a<9)&&(b<9))
_0xA9:
	CPI  R16,9
	BRGE _0xAC
	CPI  R17,9
	BRLT _0xAD
_0xAC:
	RJMP _0xAB
_0xAD:
;     180                 {
;     181                 str[b]=str1[a];
	CALL SUBOPT_0xA
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x9
	LD   R30,X
	POP  R26
	POP  R27
	ST   X,R30
;     182                 a++;b++;
	SUBI R16,-1
	SUBI R17,-1
;     183                 }
	RJMP _0xA9
_0xAB:
;     184 
;     185         while (b<9) {str[b]='0';b++;}
_0xAE:
	CPI  R17,9
	BRGE _0xB0
	CALL SUBOPT_0xA
	CALL SUBOPT_0xB
	SUBI R17,-1
	RJMP _0xAE
_0xB0:
;     186 
;     187  	if (point==1)
	LDS  R26,_point
	CPI  R26,LOW(0x1)
	BRNE _0xB1
;     188  	        {
;     189                 if (str[0]=='-') tis='-';
	LDD  R26,Y+11
	CPI  R26,LOW(0x2D)
	BRNE _0xB2
	LDI  R30,LOW(45)
	STS  _tis,R30
;     190                 else if (str[0]==0)tis=0;
	RJMP _0xB3
_0xB2:
	LDD  R30,Y+11
	CPI  R30,0
	BRNE _0xB4
	LDI  R30,LOW(0)
	RJMP _0x29D
;     191                 else tis=str[0]-0x30;
_0xB4:
	LDD  R30,Y+11
	SUBI R30,LOW(48)
_0x29D:
	STS  _tis,R30
;     192 
;     193 
;     194                 sot=str[1]-0x30;
_0xB3:
	LDD  R30,Y+12
	SUBI R30,LOW(48)
	STS  _sot,R30
;     195                 des=str[2]-0x30;
	LDD  R30,Y+13
	SUBI R30,LOW(48)
	STS  _des,R30
;     196                 ed=str[3]-0x30;
	LDD  R30,Y+14
	CALL SUBOPT_0xC
;     197                 if (tis==0)
	BRNE _0xB6
;     198                         {
;     199                         tis=' ';
	CALL SUBOPT_0xD
;     200                         if (sot==0)
	BRNE _0xB7
;     201                                 {
;     202                                 sot=' ';
	LDI  R30,LOW(32)
	STS  _sot,R30
;     203                                 if(des==0) des=' ';
	LDS  R30,_des
	CPI  R30,0
	BRNE _0xB8
	LDI  R30,LOW(32)
	STS  _des,R30
;     204                                 }
_0xB8:
;     205                         }
_0xB7:
;     206  	        }
_0xB6:
;     207  	if (point==2)
_0xB1:
	LDS  R26,_point
	CPI  R26,LOW(0x2)
	BRNE _0xB9
;     208  	        {
;     209                 if (str[1]=='-') tis='-';
	LDD  R26,Y+12
	CPI  R26,LOW(0x2D)
	BRNE _0xBA
	LDI  R30,LOW(45)
	STS  _tis,R30
;     210                 else if (str[1]==0)tis=0;
	RJMP _0xBB
_0xBA:
	LDD  R30,Y+12
	CPI  R30,0
	BRNE _0xBC
	LDI  R30,LOW(0)
	RJMP _0x29E
;     211                 else tis=str[1]-0x30;
_0xBC:
	LDD  R30,Y+12
	SUBI R30,LOW(48)
_0x29E:
	STS  _tis,R30
;     212 
;     213                 if (str[2]=='-') sot='-';
_0xBB:
	LDD  R26,Y+13
	CPI  R26,LOW(0x2D)
	BRNE _0xBE
	LDI  R30,LOW(45)
	STS  _sot,R30
;     214                 else if (str[2]==0)sot=0;
	RJMP _0xBF
_0xBE:
	LDD  R30,Y+13
	CPI  R30,0
	BRNE _0xC0
	LDI  R30,LOW(0)
	RJMP _0x29F
;     215                 else sot=str[2]-0x30;
_0xC0:
	LDD  R30,Y+13
	SUBI R30,LOW(48)
_0x29F:
	STS  _sot,R30
;     216 //                sot=str[2]-0x30;
;     217                 des=str[3]-0x30;
_0xBF:
	LDD  R30,Y+14
	SUBI R30,LOW(48)
	STS  _des,R30
;     218                 ed=str[5]-0x30;
	LDD  R30,Y+16
	CALL SUBOPT_0xC
;     219                 if (tis==0)
	BRNE _0xC2
;     220                         {
;     221                         tis=' ';
	CALL SUBOPT_0xD
;     222                         if (sot==0)
	BRNE _0xC3
;     223                                 {
;     224                                 sot=' ';
	LDI  R30,LOW(32)
	STS  _sot,R30
;     225                                 }
;     226                         }
_0xC3:
;     227  	        }
_0xC2:
;     228  	if (point==3)
_0xB9:
	LDS  R26,_point
	CPI  R26,LOW(0x3)
	BRNE _0xC4
;     229  	        {
;     230                 if (str[2]=='-') tis='-';
	LDD  R26,Y+13
	CPI  R26,LOW(0x2D)
	BRNE _0xC5
	LDI  R30,LOW(45)
	STS  _tis,R30
;     231                 else if (str[2]==0)tis=0;
	RJMP _0xC6
_0xC5:
	LDD  R30,Y+13
	CPI  R30,0
	BRNE _0xC7
	LDI  R30,LOW(0)
	RJMP _0x2A0
;     232                 else tis=str[2]-0x30;
_0xC7:
	LDD  R30,Y+13
	SUBI R30,LOW(48)
_0x2A0:
	STS  _tis,R30
;     233 
;     234                 if (str[3]=='-') sot='-';
_0xC6:
	LDD  R26,Y+14
	CPI  R26,LOW(0x2D)
	BRNE _0xC9
	LDI  R30,LOW(45)
	STS  _sot,R30
;     235                 else if (str[3]==0)sot=0;
	RJMP _0xCA
_0xC9:
	LDD  R30,Y+14
	CPI  R30,0
	BRNE _0xCB
	LDI  R30,LOW(0)
	RJMP _0x2A1
;     236                 else sot=str[3]-0x30;
_0xCB:
	LDD  R30,Y+14
	SUBI R30,LOW(48)
_0x2A1:
	STS  _sot,R30
;     237 
;     238 //                sot=str[3]-0x30;
;     239                 des=str[5]-0x30;
_0xCA:
	LDD  R30,Y+16
	SUBI R30,LOW(48)
	STS  _des,R30
;     240                 ed=str[6]-0x30;
	LDD  R30,Y+17
	CALL SUBOPT_0xC
;     241                 if (tis==0)
	BRNE _0xCD
;     242                         {
;     243                         tis=' ';
	LDI  R30,LOW(32)
	STS  _tis,R30
;     244                         }
;     245  	        }
_0xCD:
;     246  	if (point==4)
_0xC4:
	LDS  R26,_point
	CPI  R26,LOW(0x4)
	BRNE _0xCE
;     247  	        {
;     248                 if (str[3]=='-') tis='-';
	LDD  R26,Y+14
	CPI  R26,LOW(0x2D)
	BRNE _0xCF
	LDI  R30,LOW(45)
	STS  _tis,R30
;     249                 else if (str[3]==0)tis=0;
	RJMP _0xD0
_0xCF:
	LDD  R30,Y+14
	CPI  R30,0
	BRNE _0xD1
	LDI  R30,LOW(0)
	RJMP _0x2A2
;     250                 else tis=str[3]-0x30;
_0xD1:
	LDD  R30,Y+14
	SUBI R30,LOW(48)
_0x2A2:
	STS  _tis,R30
;     251 
;     252                 if (str[5]=='-') sot='-';
_0xD0:
	LDD  R26,Y+16
	CPI  R26,LOW(0x2D)
	BRNE _0xD3
	LDI  R30,LOW(45)
	STS  _sot,R30
;     253                 else if (str[5]==0)sot=0;
	RJMP _0xD4
_0xD3:
	LDD  R30,Y+16
	CPI  R30,0
	BRNE _0xD5
	LDI  R30,LOW(0)
	RJMP _0x2A3
;     254                 else sot=str[5]-0x30;
_0xD5:
	LDD  R30,Y+16
	SUBI R30,LOW(48)
_0x2A3:
	STS  _sot,R30
;     255 
;     256 //                sot=str[5]-0x30;
;     257                 des=str[6]-0x30;
_0xD4:
	LDD  R30,Y+17
	SUBI R30,LOW(48)
	STS  _des,R30
;     258                 ed=str[7]-0x30;
	LDD  R30,Y+18
	SUBI R30,LOW(48)
	STS  _ed,R30
;     259  	        }
;     260  	}
_0xCE:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,24
	RET
;     261 //-------------------------------------------------------------------//
;     262 // чтение из АЦП
;     263 //-------------------------------------------------------------------//
;     264 // int read_adc()
;     265 //         {
;     266 //         int a;
;     267 //         a=rand();
;     268 //         a=a/200;
;     269 //         a=a+618;
;     270 //         return a;
;     271 //         }
;     272 int read_adc()
;     273         {
_read_adc:
;     274         int a;
;     275         cs=0;
	ST   -Y,R17
	ST   -Y,R16
;	a -> R16,R17
	CBI  0x18,4
;     276         SPCR=0b01010001;SPDR=0b10110001;
	LDI  R30,LOW(81)
	OUT  0xD,R30
	LDI  R30,LOW(177)
	OUT  0xF,R30
;     277         while(SPSR.7==0);a=SPDR;SPDR=0;a=a<<8;
_0xD7:
	SBIS 0xE,7
	RJMP _0xD7
	IN   R30,0xF
	LDI  R31,0
	__PUTW1R 16,17
	LDI  R30,LOW(0)
	OUT  0xF,R30
	MOV  R17,R16
	CLR  R16
;     278         while (SPSR.7 == 0);a = a + SPDR; 
_0xDA:
	SBIS 0xE,7
	RJMP _0xDA
	IN   R30,0xF
	__GETW2R 16,17
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	__PUTW1R 16,17
;     279         cs=1;
	SBI  0x18,4
;     280         return a;
	__GETW1R 16,17
	LD   R16,Y+
	LD   R17,Y+
	RET
;     281         }
;     282 //-------------------------------------------------------------------//
;     283 
;     284 unsigned int buf[9],buf_m[9];

	.DSEG
_buf:
	.BYTE 0x12
_buf_m:
	.BYTE 0x12
;     285 char buf_begin,buf_end,buf_n[9];
_buf_begin:
	.BYTE 0x1
_buf_end:
	.BYTE 0x1
_buf_n:
	.BYTE 0x9
;     286 float x,adc_filter;
_x:
	.BYTE 0x4
_adc_filter:
	.BYTE 0x4
;     287 char j,k,count_register,count_key2;
_j:
	.BYTE 0x1
_k:
	.BYTE 0x1
_count_register:
	.BYTE 0x1
_count_key2:
	.BYTE 0x1
;     288 long start_time,start_time_mode,time_key;
_start_time:
	.BYTE 0x4
_start_time_mode:
	.BYTE 0x4
_time_key:
	.BYTE 0x4
;     289 
;     290 #include <function.h>

	.CSEG
_read_reg:
	SBIW R28,4
;	a -> Y+4
;	k_f -> Y+0
	LDD  R30,Y+4
	LDI  R26,LOW(_reg)
	LDI  R27,HIGH(_reg)
	CALL SUBOPT_0xE
	STS  _ee_float,R30
	STS  _ee_float+1,R31
	LDS  R26,_ee_float
	LDS  R27,_ee_float+1
	CALL __EEPROMRDD
	__PUTD1S 0
	CALL SUBOPT_0xF
	CALL SUBOPT_0x10
	__GETD2S 0
	CALL __CMPF12
	BREQ PC+4
	BRCS PC+3
	JMP  _0xDE
	CALL SUBOPT_0xF
	PUSH R27
	PUSH R26
	CALL __LSLW3
	POP  R26
	POP  R27
	ADD  R30,R26
	ADC  R31,R27
	CALL __GETD1PF
	__GETD2S 0
	CALL __CMPF12
	BRSH _0xDD
_0xDE:
	LDI  R26,LOW(_FAKTORY*2)
	LDI  R27,HIGH(_FAKTORY*2)
	LDD  R30,Y+4
	CALL SUBOPT_0xE
	CALL __GETD1PF
	__PUTD1S 0
_0xDD:
	__GETD1S 0
_0x29B:
	ADIW R28,5
	RET
_save_reg:
	ST   -Y,R17
	ST   -Y,R16
;	a -> Y+4
;	b -> Y+2
;	*ee_float -> R16,R17
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	LDI  R26,LOW(_reg)
	LDI  R27,HIGH(_reg)
	CALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	__PUTW1R 16,17
	__GETD1S 4
	__GETW2R 16,17
	CALL __EEPROMWRD
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,8
	RET
_rekey:
	LDS  R26,_count_key2
	LDI  R30,LOW(20)
	CP   R30,R26
	BRSH _0xE0
	CALL SUBOPT_0x11
	LDI  R30,LOW(103)
	CP   R30,R26
	BRSH _0xE1
	LDI  R30,LOW(102)
	STS  _count_key1,R30
_0xE1:
	RJMP _0xE2
_0xE0:
	LDS  R26,_count_key1
	LDI  R30,LOW(100)
	CP   R30,R26
	BRSH _0xE3
	CALL SUBOPT_0x11
	LDI  R30,LOW(106)
	CP   R30,R26
	BRSH _0xE4
	LDI  R30,LOW(102)
	STS  _count_key1,R30
	LDS  R30,_count_key2
	SUBI R30,-LOW(1)
	STS  _count_key2,R30
_0xE4:
	RJMP _0xE5
_0xE3:
	LDS  R26,_time_key
	LDS  R27,_time_key+1
	LDS  R24,_time_key+2
	LDS  R25,_time_key+3
	CALL SUBOPT_0x12
	__GETD1N 0x32
	CALL __CPD12
	BRGE _0xE7
	LDS  R26,_count_key
	LDI  R30,LOW(0)
	CP   R30,R26
	BRLO _0xE8
_0xE7:
	RJMP _0xE6
_0xE8:
	LDS  R30,_sys_time
	LDS  R31,_sys_time+1
	LDS  R22,_sys_time+2
	LDS  R23,_sys_time+3
	STS  _time_key,R30
	STS  _time_key+1,R31
	STS  _time_key+2,R22
	STS  _time_key+3,R23
	LDS  R26,_count_key
	SUBI R26,LOW(1)
	STS  _count_key,R26
	CPI  R26,LOW(0x14)
	BRSH _0xE9
	LDI  R30,LOW(40)
	STS  _count_key,R30
	CALL SUBOPT_0x11
	LDI  R30,LOW(4)
	CP   R30,R26
	BRSH _0xEA
	LDI  R30,LOW(102)
	STS  _count_key1,R30
	LDI  R30,LOW(250)
	STS  _count_key,R30
_0xEA:
_0xE9:
_0xE6:
_0xE5:
_0xE2:
	RET
;     291 
;     292 float izm()
;     293         {
_izm:
;     294         char min_r,min_n;
;     295         signed char rang[9];
;     296         float k_f;
;     297         //-------------------------------------------------------------------//
;     298         //измерение
;     299         //-------------------------------------------------------------------//
;     300         if (++buf_end>8) buf_end=0;buf[buf_end]=read_adc();min_r=9;
	SBIW R28,13
	ST   -Y,R17
	ST   -Y,R16
;	min_r -> R16
;	min_n -> R17
;	rang -> Y+6
;	k_f -> Y+2
	LDS  R26,_buf_end
	SUBI R26,-LOW(1)
	STS  _buf_end,R26
	LDI  R30,LOW(8)
	CP   R30,R26
	BRSH _0xEB
	LDI  R30,LOW(0)
	STS  _buf_end,R30
_0xEB:
	CALL SUBOPT_0x13
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	CALL _read_adc
	POP  R26
	POP  R27
	ST   X+,R30
	ST   X,R31
	LDI  R16,LOW(9)
;     301         //-------------------------------------------------------------------//
;     302         //-------------------------------------------------------------------//
;     303         //модальный фильтр
;     304         //-------------------------------------------------------------------//
;     305         for (j=0;j<9;j++)
	LDI  R30,LOW(0)
	STS  _j,R30
_0xED:
	LDS  R26,_j
	CPI  R26,LOW(0x9)
	BRLO PC+3
	JMP _0xEE
;     306                 {
;     307                 rang[j]=0;for (i=0;i<9;i++)
	CALL SUBOPT_0x14
	LDI  R30,LOW(0)
	ST   X,R30
	STS  _i,R30
_0xF0:
	LDS  R26,_i
	CPI  R26,LOW(0x9)
	BRSH _0xF1
;     308                         {
;     309                         if (i!=j)
	LDS  R30,_j
	CP   R30,R26
	BREQ _0xF2
;     310                                 {
;     311                                 if (buf[j]<buf[i]) rang[j]--;
	CALL SUBOPT_0x15
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x16
	POP  R26
	POP  R27
	CP   R26,R30
	CPC  R27,R31
	BRSH _0xF3
	CALL SUBOPT_0x14
	LD   R30,X
	SUBI R30,LOW(1)
	ST   X,R30
;     312                                 if (buf[j]>buf[i]) rang[j]++;
_0xF3:
	CALL SUBOPT_0x15
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x16
	POP  R26
	POP  R27
	CP   R30,R26
	CPC  R31,R27
	BRSH _0xF4
	CALL SUBOPT_0x14
	LD   R30,X
	SUBI R30,-LOW(1)
	ST   X,R30
;     313                                 }
_0xF4:
;     314                         }
_0xF2:
	CALL SUBOPT_0x17
	RJMP _0xF0
_0xF1:
;     315                 if (cabs(rang[j])<min_r) {min_r=cabs(rang[j]);min_n=j;}
	CALL SUBOPT_0x14
	CALL SUBOPT_0x18
	CP   R30,R16
	BRSH _0xF5
	CALL SUBOPT_0x14
	CALL SUBOPT_0x18
	MOV  R16,R30
	LDS  R17,_j
;     316                 }
_0xF5:
	LDS  R30,_j
	SUBI R30,-LOW(1)
	STS  _j,R30
	RJMP _0xED
_0xEE:
;     317         //-------------------------------------------------------------------//
;     318         //ФНЧ
;     319         //-------------------------------------------------------------------//
;     320         k_f=read_reg(A_10);
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _read_reg
	__PUTD1S 2
;     321 //        if (k_f==0) {adc_filter=buf[buf_end];}
;     322 //        else {k_f=0.002/k_f;adc_filter=k_f*buf[min_n]+(1-k_f)*adc_filter;}
;     323         if (k_f==0) k_f=0.001;
	CALL __CPD10
	BRNE _0xF6
	__GETD1N 0x3A83126F
	__PUTD1S 2
;     324         k_f=0.001/k_f;adc_filter=k_f*buf[min_n]+(1-k_f)*adc_filter;
_0xF6:
	__GETD1S 2
	__GETD2N 0x3A83126F
	CALL __DIVF21
	__PUTD1S 2
	MOV  R30,R17
	LDI  R26,LOW(_buf)
	LDI  R27,HIGH(_buf)
	CALL SUBOPT_0x19
	__GETD2S 2
	CLR  R22
	CLR  R23
	CALL __CDF1
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETD2S 2
	__GETD1N 0x3F800000
	CALL __SUBF12
	LDS  R26,_adc_filter
	LDS  R27,_adc_filter+1
	LDS  R24,_adc_filter+2
	LDS  R25,_adc_filter+3
	CALL __MULF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
	STS  _adc_filter,R30
	STS  _adc_filter+1,R31
	STS  _adc_filter+2,R22
	STS  _adc_filter+3,R23
;     325         //-------------------------------------------------------------------//
;     326         return adc_filter;
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,15
	RET
;     327         }
;     328 //-------------------------------------------------------------------//
;     329 int crc;

	.DSEG
_crc:
	.BYTE 0x2
;     330 float adc_value3;
_adc_value3:
	.BYTE 0x4
;     331 bit error,blok1,blok2,signal;
;     332 void response_m_aa3();
;     333 void response_m_aa6();
;     334 void response_m_aa4();
;     335 void check_add_cr();
;     336 
;     337 void mov_buf_mod(char a);		//
;     338 void mov_buf(char a);			//
;     339 void crc_end();				//
;     340 void crc_rtu(char a);			//
;     341 
;     342 
;     343 void main(void)
;     344 {

	.CSEG
_main:
;     345 bit flag_start_pause1,flag_start_pause2,f_m1,key_enter_press_switch1;
;     346 float time_pause1,time_pause2,adc_value1;
;     347 float data_register,adc_filter,adc_value2;
;     348 float k_k,kk,bb;
;     349 ee_char=&ee_point;point=*ee_char;
	SBIW R28,36
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	CALL SUBOPT_0x1A
;     350 
;     351 
;     352 
;     353 
;     354 
;     355 
;     356 // PORTA=0b11111111;DDRA=0b11111111;
;     357 // PORTB=0b00000000;DDRB=0b10110011;
;     358 // PORTC=0b11111011;DDRC=0b11111000;
;     359 // PORTD=0b11000011;DDRD=0b00111110;
;     360 // UBRRH=0x00;UBRRL=0x67;
;     361 // UCSRB=0x18;
;     362 // UCSRC=0x86;
;     363 // 
;     364 // rx_tx=1;
;     365 // putchar(1);
;     366 // putchar(2);
;     367 // putchar(3);
;     368 // putchar(4);
;     369 // putchar(5);
;     370 // putchar(6);
;     371 // putchar(7);
;     372 // putchar(8);
;     373 // putchar(9);
;     374 // putchar(10);
;     375 // delay_ms(20);
;     376 // rx_tx=0;
;     377 // 
;     378 // 
;     379 // while (1)
;     380 //         {
;     381 // while (!(UCSRA&0b10000000));
;     382 // 
;     383 // i=UDR;
;     384 // rx_tx=1;
;     385 // putchar(i);
;     386 // delay_ms(20);
;     387 // rx_tx=0;
;     388 //         }
;     389 // 
;     390 
;     391 
;     392 
;     393 
;     394 
;     395 
;     396 
;     397 power_off:
_0xF7:
;     398 
;     399 #asm("cli");
	cli
;     400 PORTA=0b11111111;DDRA=0b11111111;
	LDI  R30,LOW(255)
	OUT  0x1B,R30
	OUT  0x1A,R30
;     401 PORTB=0b00000000;DDRB=0b10110011;
	LDI  R30,LOW(0)
	OUT  0x18,R30
	LDI  R30,LOW(179)
	OUT  0x17,R30
;     402 PORTC=0b11111011;DDRC=0b11111000;
	LDI  R30,LOW(251)
	OUT  0x15,R30
	LDI  R30,LOW(248)
	OUT  0x14,R30
;     403 PORTD=0b11000011;DDRD=0b00111110;
	LDI  R30,LOW(195)
	OUT  0x12,R30
	LDI  R30,LOW(62)
	OUT  0x11,R30
;     404 
;     405 while ((key_1==0)&&(key_2==0)&&(key_3==0)&&(key_4==0));
_0xF8:
	SBIC 0x13,0
	RJMP _0xFB
	SBIC 0x13,1
	RJMP _0xFB
	SBIC 0x10,6
	RJMP _0xFB
	SBIS 0x10,7
	RJMP _0xFC
_0xFB:
	RJMP _0xFA
_0xFC:
	RJMP _0xF8
_0xFA:
;     406 TCCR0=0x03;TCNT0=TCNT0_reload;OCR0=0x00;
	LDI  R30,LOW(3)
	OUT  0x33,R30
	LDI  R30,LOW(220)
	OUT  0x32,R30
	LDI  R30,LOW(0)
	OUT  0x3C,R30
;     407 
;     408 
;     409 // TCCR1A=0b11000011;
;     410 // TCCR1B=0b00001010;
;     411 // 
;     412 // 
;     413 // OCR1AH=0x01;
;     414 // OCR1AL=0x7F;
;     415 // 
;     416 
;     417 ASSR=0x00;TCCR2=0x04;TCNT2=TCNT2_reload;OCR2=0x00;
	OUT  0x22,R30
	LDI  R30,LOW(4)
	OUT  0x25,R30
	LDI  R30,LOW(131)
	OUT  0x24,R30
	LDI  R30,LOW(0)
	OUT  0x23,R30
;     418 MCUCR=0x00;MCUCSR=0x00;TIMSK=0xFF;
	OUT  0x35,R30
	OUT  0x34,R30
	LDI  R30,LOW(255)
	OUT  0x39,R30
;     419 
;     420 UBRRH=0x00;UBRRL=0x67;UCSRB=0xD8;UCSRC=0x86;
	LDI  R30,LOW(0)
	OUT  0x20,R30
	LDI  R30,LOW(103)
	OUT  0x9,R30
	LDI  R30,LOW(216)
	OUT  0xA,R30
	LDI  R30,LOW(134)
	OUT  0x20,R30
;     421 ACSR=0x80;SFIOR=0x00;SPCR=0x52;SPSR=0x00;WDTCR=0x1F;WDTCR=0x0F;
	LDI  R30,LOW(128)
	OUT  0x8,R30
	LDI  R30,LOW(0)
	OUT  0x30,R30
	LDI  R30,LOW(82)
	OUT  0xD,R30
	LDI  R30,LOW(0)
	OUT  0xE,R30
	LDI  R30,LOW(31)
	OUT  0x21,R30
	LDI  R30,LOW(15)
	OUT  0x21,R30
;     422 mod_time_s=60;
	LDI  R30,LOW(60)
	MOV  R8,R30
;     423 
;     424 
;     425 
;     426 
;     427 goto a1;//test
	RJMP _0xFD
;     428 
;     429 //-------------------------------------------------------------------//
;     430 //Ожидание включения питания 
;     431 //-------------------------------------------------------------------//
;     432 i=0;
;     433 while (i<100)
_0xFE:
	LDS  R26,_i
	CPI  R26,LOW(0x64)
	BRSH _0x100
;     434         {
;     435         if ((key_1==0)&&(key_4==0)&&(key_2==1)&&(key_3==1)) i++;
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
;	power_off -> Y+283
	SBIC 0x13,0
	RJMP _0x102
	SBIC 0x10,7
	RJMP _0x102
	SBIS 0x13,1
	RJMP _0x102
	SBIC 0x10,6
	RJMP _0x103
_0x102:
	RJMP _0x101
_0x103:
	LDS  R30,_i
	SUBI R30,-LOW(1)
	RJMP _0x2A4
;     436         else i=0;
_0x101:
	LDI  R30,LOW(0)
_0x2A4:
	STS  _i,R30
;     437         delay_ms(20);
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
;     438         }
	RJMP _0xFE
_0x100:
;     439 //-------------------------------------------------------------------//
;     440 power=1;
	SBI  0x12,3
;     441 data_register=read_reg(A_07);
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1C
;     442 if (data_register<0)
	BRGE _0x105
;     443         {
;     444         if (data_register>=-1000)point=1;
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
;	power_off -> Y+283
	CALL SUBOPT_0x1D
	BRLO _0x106
	LDI  R30,LOW(1)
	STS  _point,R30
;     445         else if (data_register>=-100)point=2;
	RJMP _0x107
_0x106:
	CALL SUBOPT_0x1E
	BRLO _0x108
	LDI  R30,LOW(2)
	STS  _point,R30
;     446         else if (data_register>=-10)point=3;
	RJMP _0x109
_0x108:
	CALL SUBOPT_0x1F
	BRLO _0x10A
	LDI  R30,LOW(3)
	STS  _point,R30
;     447         }
_0x10A:
_0x109:
_0x107:
;     448 else
	RJMP _0x10B
_0x105:
;     449         {
;     450         if (data_register<10)point=4;
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
;	power_off -> Y+283
	CALL SUBOPT_0x20
	BRSH _0x10C
	LDI  R30,LOW(4)
	STS  _point,R30
;     451         else if (data_register<100)point=3;
	RJMP _0x10D
_0x10C:
	CALL SUBOPT_0x21
	BRSH _0x10E
	LDI  R30,LOW(3)
	STS  _point,R30
;     452         else if (data_register<1000)point=2;
	RJMP _0x10F
_0x10E:
	CALL SUBOPT_0x22
	BRSH _0x110
	LDI  R30,LOW(2)
	STS  _point,R30
;     453         else if (data_register>=1000)point=1;
	RJMP _0x111
_0x110:
	CALL SUBOPT_0x22
	BRLO _0x112
	LDI  R30,LOW(1)
	STS  _point,R30
;     454         }
_0x112:
_0x111:
_0x10F:
_0x10D:
_0x10B:
;     455 work_point=point;
	LDS  R30,_point
	STS  _work_point,R30
;     456 #asm("sei")
	sei
;     457 //-------------------------------------------------------------------//
;     458 //Показать основные настройки
;     459 //блокировка по включению
;     460 //-------------------------------------------------------------------//
;     461 start_time=sys_time;count_register=1;
	LDS  R30,_sys_time
	LDS  R31,_sys_time+1
	LDS  R22,_sys_time+2
	LDS  R23,_sys_time+3
	STS  _start_time,R30
	STS  _start_time+1,R31
	STS  _start_time+2,R22
	STS  _start_time+3,R23
	LDI  R30,LOW(1)
	STS  _count_register,R30
;     462 set_led_on(0,0,0,0,0,0,0,0);         set_led_off(0,0,0,0,0,0,0,0);
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL _set_led_on
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL _set_led_off
;     463 while ((sys_time-start_time)<read_reg(A_11)*2000) 
_0x113:
	LDS  R26,_start_time
	LDS  R27,_start_time+1
	LDS  R24,_start_time+2
	LDS  R25,_start_time+3
	LDS  R30,_sys_time
	LDS  R31,_sys_time+1
	LDS  R22,_sys_time+2
	LDS  R23,_sys_time+3
	CALL __SUBD12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDI  R30,LOW(17)
	CALL SUBOPT_0x24
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __CDF2
	CALL __CMPF12
	BRLO PC+3
	JMP _0x115
;     464         {
;     465 //        hex2dec(count_register);
;     466         ed=' ';
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
;	power_off -> Y+283
	CALL SUBOPT_0x25
;     467         switch (count_register)
;     468                 {
;     469                 case 2: tis='У';sot='_';des= 2 ;break;
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
;	power_off -> Y+283
	BRNE _0x119
	CALL SUBOPT_0x26
	LDI  R30,LOW(2)
	STS  _des,R30
	RJMP _0x118
;     470                 case 3: tis= 3 ;sot='_';des= 1 ;break;
_0x119:
	CPI  R30,LOW(0x3)
	BRNE _0x11A
	CALL SUBOPT_0x27
	LDI  R30,LOW(1)
	STS  _des,R30
	RJMP _0x118
;     471                 case 4: tis= 3 ;sot='_';des= 2 ;break;
_0x11A:
	CPI  R30,LOW(0x4)
	BRNE _0x11B
	CALL SUBOPT_0x27
	LDI  R30,LOW(2)
	STS  _des,R30
	RJMP _0x118
;     472                 case 5: tis='p';sot='_';des='_';break;
_0x11B:
	CPI  R30,LOW(0x5)
	BRNE _0x11C
	CALL SUBOPT_0x28
	RJMP _0x118
;     473                 case 6: tis='c';sot='_';des='_';break;
_0x11C:
	CPI  R30,LOW(0x6)
	BRNE _0x11D
	CALL SUBOPT_0x29
	RJMP _0x118
;     474                 case 1: tis='У';sot='_';des= 1 ;break;
_0x11D:
	CPI  R30,LOW(0x1)
	BRNE _0x118
	CALL SUBOPT_0x26
	LDI  R30,LOW(1)
	STS  _des,R30
;     475                 /*default:*/tis='У';sot='_';des= 1 ;break;
;     476                 }
_0x118:
;     477         set_digit_on(tis,sot,des,ed);        set_digit_off(tis,sot,des,ed);
	CALL SUBOPT_0x2A
	CALL _set_digit_on
	CALL SUBOPT_0x2A
	CALL _set_digit_off
;     478         set_led_on(0,0,0,0,0,0,0,0);         set_led_off(0,0,0,0,0,0,0,0);
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL _set_led_on
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL _set_led_off
;     479         delay_ms(500);
	CALL SUBOPT_0x2B
;     480 
;     481         data_register=read_reg(count_register);
	CALL SUBOPT_0x2C
;     482 //        if ((data_register>MAX_MIN[count_register,1])||(data_register<MAX_MIN[count_register,0])) data_register=FAKTORY[count_register];//проверка граничных значений
;     483 
;     484 //        save_reg(data_register,count_register);
;     485         
;     486         switch (count_register)
	LDS  R30,_count_register
;     487                 {
;     488                 case 2: count_register=3;point=work_point;break;
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
;	power_off -> Y+283
	CPI  R30,LOW(0x2)
	BRNE _0x122
	LDI  R30,LOW(3)
	CALL SUBOPT_0x2D
	RJMP _0x121
;     489                 case 3: count_register=4;point=1;break;
_0x122:
	CPI  R30,LOW(0x3)
	BRNE _0x123
	LDI  R30,LOW(4)
	CALL SUBOPT_0x2E
	RJMP _0x121
;     490                 case 4: count_register=5;point=1;break;
_0x123:
	CPI  R30,LOW(0x4)
	BRNE _0x124
	LDI  R30,LOW(5)
	CALL SUBOPT_0x2E
	RJMP _0x121
;     491                 case 5: count_register=6;point=1;break;
_0x124:
	CPI  R30,LOW(0x5)
	BRNE _0x125
	LDI  R30,LOW(6)
	CALL SUBOPT_0x2E
	RJMP _0x121
;     492                 case 6: count_register=1;point=1;break;
_0x125:
	CPI  R30,LOW(0x6)
	BRNE _0x126
	LDI  R30,LOW(1)
	CALL SUBOPT_0x2E
	RJMP _0x121
;     493                 case 1: count_register=2;point=work_point;break;
_0x126:
	CPI  R30,LOW(0x1)
	BRNE _0x121
	LDI  R30,LOW(2)
	CALL SUBOPT_0x2D
;     494 //                default:count_register=2;point=work_point;break;
;     495                 }
_0x121:
;     496         hex2dec(data_register);
	CALL SUBOPT_0x2F
;     497         set_digit_on(tis,sot,des,ed);        set_digit_off(tis,sot,des,ed);
	CALL SUBOPT_0x2A
	CALL _set_digit_on
	CALL SUBOPT_0x2A
	CALL _set_digit_off
;     498         if (point==1)       {set_led_on(0,0,0,0,0,0,0,0);set_led_off(0,0,0,0,0,0,0,0);}
	LDS  R26,_point
	CPI  R26,LOW(0x1)
	BRNE _0x128
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
;	power_off -> Y+283
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL _set_led_on
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL _set_led_off
;     499         else if (point==2)  {set_led_on(0,0,0,0,0,0,1,0);set_led_off(0,0,0,0,0,0,1,0);}
	RJMP _0x129
_0x128:
	LDS  R26,_point
	CPI  R26,LOW(0x2)
	BRNE _0x12A
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
;	power_off -> Y+283
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL SUBOPT_0x30
	CALL _set_led_on
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL SUBOPT_0x30
	CALL _set_led_off
;     500         else if (point==3)  {set_led_on(0,0,0,0,0,1,0,0);set_led_off(0,0,0,0,0,1,0,0);}
	RJMP _0x12B
_0x12A:
	LDS  R26,_point
	CPI  R26,LOW(0x3)
	BRNE _0x12C
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
;	power_off -> Y+283
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL SUBOPT_0x31
	CALL _set_led_on
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL SUBOPT_0x31
	CALL _set_led_off
;     501         else if (point==4)  {set_led_on(0,0,0,0,1,0,0,0);set_led_off(0,0,0,0,1,0,0,0);}
	RJMP _0x12D
_0x12C:
	LDS  R26,_point
	CPI  R26,LOW(0x4)
	BRNE _0x12E
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
;	power_off -> Y+283
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL SUBOPT_0x32
	CALL SUBOPT_0x33
	CALL SUBOPT_0x23
	CALL SUBOPT_0x32
	CALL SUBOPT_0x34
;     502         delay_ms(500);
_0x12E:
_0x12D:
_0x12B:
_0x129:
	CALL SUBOPT_0x2B
;     503         }
	RJMP _0x113
_0x115:
;     504 a1:
_0xFD:
;     505 
;     506 key_mode_press=0;
	CLT
	BLD  R3,3
;     507 key_plus_press=0;
	BLD  R3,4
;     508 key_mines_press=0;
	BLD  R3,5
;     509 key_enter_press=0;
	BLD  R3,6
;     510 key_mode_press_switch=0;
	BLD  R3,7
;     511 key_plus_press_switch=0;
	BLD  R4,0
;     512 key_minus_press_switch=0;
	BLD  R4,1
;     513 
;     514 #asm("sei")
	sei
;     515 mode=0;
	LDI  R30,LOW(0)
	STS  _mode,R30
;     516 x=0;
	__GETD1N 0x0
	STS  _x,R30
	STS  _x+1,R31
	STS  _x+2,R22
	STS  _x+3,R23
;     517 start_time=sys_time;
	LDS  R30,_sys_time
	LDS  R31,_sys_time+1
	LDS  R22,_sys_time+2
	LDS  R23,_sys_time+3
	STS  _start_time,R30
	STS  _start_time+1,R31
	STS  _start_time+2,R22
	STS  _start_time+3,R23
;     518 k_k=read_reg(A_16);
	LDI  R30,LOW(22)
	ST   -Y,R30
	CALL _read_reg
	__PUTD1S 8
;     519 
;     520 ee_char=&ee_point;
	CALL SUBOPT_0x1A
;     521 point=*ee_char;
;     522 work_point=point;
	LDS  R30,_point
	STS  _work_point,R30
;     523 
;     524 //-------------------------------------------------------------------//
;     525 while (1)
_0x12F:
;     526         {
;     527         #asm("wdr");
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
;	power_off -> Y+283
	wdr
;     528         adc_filter=izm();
	CALL _izm
	__PUTD1S 16
;     529         //-------------------------------------------------------------------//
;     530         //абсолютная величина
;     531         //-------------------------------------------------------------------//
;     532         if (read_reg(A_12)<3) adc_value1=adc_filter*k_k/100;
	CALL SUBOPT_0x35
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x40400000
	CALL __CMPF12
	BRSH _0x132
	CALL SUBOPT_0x36
	__GETD1N 0x42C80000
	RJMP _0x2A5
;     533         else adc_value1=adc_filter*k_k/200;
_0x132:
	CALL SUBOPT_0x36
	__GETD1N 0x43480000
_0x2A5:
	CALL __DIVF21
	__PUTD1S 24
;     534 
;     535         //-------------------------------------------------------------------//
;     536         //относительная величина
;     537         //-------------------------------------------------------------------//
;     538         i=read_reg(A_12);
	CALL SUBOPT_0x35
	CALL __CFD1
	STS  _i,R30
;     539         switch (i)
;     540                 {
;     541                 case 0:kk=(read_reg(A_07)-read_reg(A_06))/(20-4);bb=read_reg(A_06)-kk*4;break;//4-20mA
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
;	power_off -> Y+283
	CPI  R30,0
	BRNE _0x137
	CALL SUBOPT_0x1B
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x37
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x38
	__GETD1N 0x41800000
	CALL SUBOPT_0x39
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETD2S 4
	__GETD1N 0x40800000
	CALL __MULF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x3A
	RJMP _0x136
;     542                 case 1:kk=(read_reg(A_07)-read_reg(A_06))/(5-0);bb=read_reg(A_06)-kk*0;break;//0-5mA
_0x137:
	CPI  R30,LOW(0x1)
	BRNE _0x138
	CALL SUBOPT_0x1B
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x37
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x38
	__GETD1N 0x40A00000
	CALL SUBOPT_0x39
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x3B
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x3A
	RJMP _0x136
;     543                 case 2:kk=(read_reg(A_07)-read_reg(A_06))/(20-0);bb=read_reg(A_06)-kk*0;break;//0-20mA
_0x138:
	CPI  R30,LOW(0x2)
	BRNE _0x139
	CALL SUBOPT_0x1B
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x37
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x38
	__GETD1N 0x41A00000
	CALL SUBOPT_0x39
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x3B
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x3A
	RJMP _0x136
;     544                 case 3:kk=(read_reg(A_07)-read_reg(A_06))/(10-0);bb=read_reg(A_06)-kk*0;break;//0-10V
_0x139:
	CPI  R30,LOW(0x3)
	BRNE _0x13B
	CALL SUBOPT_0x1B
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x37
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x38
	__GETD1N 0x41200000
	CALL SUBOPT_0x39
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x3B
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x3A
	RJMP _0x136
;     545                 default:kk=(read_reg(A_07)-read_reg(A_06))/(5-0);bb=read_reg(A_06)-kk*0;break;//0-5V
_0x13B:
	CALL SUBOPT_0x1B
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x37
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x38
	__GETD1N 0x40A00000
	CALL SUBOPT_0x39
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x3B
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x3A
;     546                 }
_0x136:
;     547         adc_value2=adc_value1*kk+bb;
	__GETD1S 4
	__GETD2S 24
	CALL __MULF12
	__GETD2S 0
	CALL __ADDF12
	__PUTD1S 12
;     548                 
;     549         //-------------------------------------------------------------------//
;     550         //авария
;     551         //-------------------------------------------------------------------//
;     552         if (adc_value2<(read_reg(A_06)*(1-read_reg(A_08)/100))) {avaria=1;}
	CALL SUBOPT_0x37
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDI  R30,LOW(14)
	CALL SUBOPT_0x3C
	CALL __SWAPD12
	CALL __SUBF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x3D
	BRSH _0x13C
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
;	power_off -> Y+283
	SET
	BLD  R4,3
;     553         else if (adc_value2>(read_reg(A_07)*(1+read_reg(A_09)/100))) {avaria=1;}
	RJMP _0x13D
_0x13C:
	CALL SUBOPT_0x1B
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDI  R30,LOW(15)
	CALL SUBOPT_0x3C
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x3D
	BREQ PC+2
	BRCC PC+3
	JMP  _0x13E
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
;	power_off -> Y+283
	SET
	BLD  R4,3
;     554         else avaria=0;
	RJMP _0x13F
_0x13E:
	CLT
	BLD  R4,3
;     555         //-------------------------------------------------------------------//
;     556 
;     557 
;     558         //-------------------------------------------------------------------//
;     559         //уставка 1,2
;     560         //-------------------------------------------------------------------//
;     561         if (adc_value2>(read_reg(Y_01)*(1+read_reg(A_01)/100))) {alarm1=1;}
_0x13F:
_0x13D:
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _read_reg
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDI  R30,LOW(7)
	CALL SUBOPT_0x3C
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x3D
	BREQ PC+2
	BRCC PC+3
	JMP  _0x140
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
;	power_off -> Y+283
	SET
	BLD  R4,4
;     562         else 
	RJMP _0x141
_0x140:
;     563                 {
;     564                 alarm1=0;flag_start_pause1=0;
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
;	power_off -> Y+283
	CLT
	BLD  R4,4
	BLD  R15,0
;     565                 if ((read_reg(P___)==0)||(read_reg(P___)==1)&&(read_reg(A_14)==0))alarm_alarm1=0;
	CALL SUBOPT_0x3E
	CALL __CPD10
	BREQ _0x143
	CALL SUBOPT_0x3E
	__CPD1N 0x3F800000
	BRNE _0x144
	CALL SUBOPT_0x3F
	BREQ _0x143
_0x144:
	RJMP _0x142
_0x143:
	CLT
	BLD  R4,6
;     566                 }
_0x142:
_0x141:
;     567         if (adc_value2>(read_reg(Y_02)*(1+read_reg(A_01)/100))) {alarm2=1;}
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _read_reg
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDI  R30,LOW(7)
	CALL SUBOPT_0x3C
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x3D
	BREQ PC+2
	BRCC PC+3
	JMP  _0x147
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
;	power_off -> Y+283
	SET
	BLD  R4,5
;     568         else 
	RJMP _0x148
_0x147:
;     569                 {
;     570                 alarm2=0;flag_start_pause2=0;
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
;	power_off -> Y+283
	CLT
	BLD  R4,5
	BLD  R15,1
;     571                 if ((read_reg(P___)==0)||(read_reg(P___)==1)&&(read_reg(A_15)==0))alarm_alarm2=0;
	CALL SUBOPT_0x3E
	CALL __CPD10
	BREQ _0x14A
	CALL SUBOPT_0x3E
	__CPD1N 0x3F800000
	BRNE _0x14B
	CALL SUBOPT_0x40
	BREQ _0x14A
_0x14B:
	RJMP _0x149
_0x14A:
	CLT
	BLD  R4,7
;     572                 }
_0x149:
_0x148:
;     573         //-------------------------------------------------------------------//
;     574         //
;     575         //добавить маску и блокировку
;     576         //
;     577         //-------------------------------------------------------------------//
;     578         
;     579 
;     580 
;     581         //-------------------------------------------------------------------//
;     582 
;     583         //-------------------------------------------------------------------//
;     584         //пауза 1,2
;     585         //-------------------------------------------------------------------//
;     586         if (alarm_alarm1==1){relay_alarm1=1;}
	SBRS R4,6
	RJMP _0x14E
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
;	power_off -> Y+283
	SBI  0x18,0
;     587         else relay_alarm1=0;
	RJMP _0x14F
_0x14E:
	CBI  0x18,0
;     588         if (alarm_alarm2==1){relay_alarm2=1;}
_0x14F:
	SBRS R4,7
	RJMP _0x150
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
;	power_off -> Y+283
	SBI  0x18,1
;     589         else relay_alarm2=0;
	RJMP _0x151
_0x150:
	CBI  0x18,1
;     590         
;     591         if ((flag_start_pause1==1))//&&(alarm_alarm1==0))
_0x151:
	SBRS R15,0
	RJMP _0x152
;     592                 {
;     593                 if ((sys_time-time_pause1)>(read_reg(3)*2000)){alarm_alarm1=1;}
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
;	power_off -> Y+283
	__GETD1S 32
	CALL SUBOPT_0x41
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDI  R30,LOW(3)
	CALL SUBOPT_0x24
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x153
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
;	power_off -> Y+283
	SET
	BLD  R4,6
;     594                 }
_0x153:
;     595         else if (alarm1==1)
	RJMP _0x154
_0x152:
	SBRS R4,4
	RJMP _0x155
;     596                 {
;     597                 if ( ( (read_reg(C___)==1) && (read_reg(A_02)==1) ) ){signal=1;buzer_buzer_en=1;}
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
;	power_off -> Y+283
	CALL SUBOPT_0x42
	__CPD1N 0x3F800000
	BRNE _0x157
	CALL SUBOPT_0x43
	__CPD1N 0x3F800000
	BREQ _0x158
_0x157:
	RJMP _0x156
_0x158:
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
;	power_off -> Y+283
	SET
	BLD  R5,3
	BLD  R2,6
;     598                 if ( (read_reg(P___)==0) || ( (read_reg(P___)==1) && (read_reg(A_03)==1) ) )
_0x156:
	CALL SUBOPT_0x3E
	CALL __CPD10
	BREQ _0x15A
	CALL SUBOPT_0x3E
	__CPD1N 0x3F800000
	BRNE _0x15B
	LDI  R30,LOW(9)
	CALL SUBOPT_0x44
	BREQ _0x15A
_0x15B:
	RJMP _0x159
_0x15A:
;     599                         {
;     600                         time_pause1=sys_time;
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
;	power_off -> Y+283
	LDS  R30,_sys_time
	LDS  R31,_sys_time+1
	LDS  R22,_sys_time+2
	LDS  R23,_sys_time+3
	CALL __CDF1
	__PUTD1S 32
;     601                         flag_start_pause1=1;
	SET
	BLD  R15,0
;     602                         }
;     603                 }
_0x159:
;     604         if ((alarm1==0)&&(alarm2==0))
_0x155:
_0x154:
	SBRC R4,4
	RJMP _0x15F
	SBRS R4,5
	RJMP _0x160
_0x15F:
	RJMP _0x15E
_0x160:
;     605                 {
;     606                 if (((alarm_alarm1==0)||((alarm_alarm1==1)&&(read_reg(A_14)==0)))&&((alarm_alarm2==0)||((alarm_alarm2==1)&&(read_reg(A_15)==0)))){signal=0;buzer_buzer_en=0;}
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
;	power_off -> Y+283
	SBRS R4,6
	RJMP _0x162
	SBRS R4,6
	RJMP _0x163
	CALL SUBOPT_0x3F
	BREQ _0x162
_0x163:
	RJMP _0x166
_0x162:
	SBRS R4,7
	RJMP _0x167
	SBRS R4,7
	RJMP _0x168
	CALL SUBOPT_0x40
	BREQ _0x167
_0x168:
	RJMP _0x166
_0x167:
	RJMP _0x16B
_0x166:
	RJMP _0x161
_0x16B:
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
;	power_off -> Y+283
	CLT
	BLD  R5,3
	BLD  R2,6
;     607                 if ((blok1==0)&&(blok2==0)){signal=0;buzer_buzer_en=0;}
_0x161:
	SBRC R5,1
	RJMP _0x16D
	SBRS R5,2
	RJMP _0x16E
_0x16D:
	RJMP _0x16C
_0x16E:
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
;	power_off -> Y+283
	CLT
	BLD  R5,3
	BLD  R2,6
;     608                 }
_0x16C:
;     609         if (read_reg(C___)==0)buzer_buzer_en=0;
_0x15E:
	CALL SUBOPT_0x42
	CALL __CPD10
	BRNE _0x16F
	CLT
	BLD  R2,6
;     610         if ((flag_start_pause2==1))//&&(alarm_alarm2==0))
_0x16F:
	SBRS R15,1
	RJMP _0x170
;     611                 {
;     612                 if ((sys_time-time_pause2)>(read_reg(4)*2000))alarm_alarm2=1;
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
;	power_off -> Y+283
	__GETD1S 28
	CALL SUBOPT_0x41
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDI  R30,LOW(4)
	CALL SUBOPT_0x24
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x171
	SET
	BLD  R4,7
;     613                 }
_0x171:
;     614         else if (alarm2==1)
	RJMP _0x172
_0x170:
	SBRS R4,5
	RJMP _0x173
;     615                 {
;     616                 if (((read_reg(C___)==0)&&(read_reg(A_02)==2)))signal=1;
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
;	power_off -> Y+283
	CALL SUBOPT_0x42
	CALL __CPD10
	BRNE _0x175
	CALL SUBOPT_0x43
	__CPD1N 0x40000000
	BREQ _0x176
_0x175:
	RJMP _0x174
_0x176:
	SET
	BLD  R5,3
;     617                 if ((read_reg(P___)==0)||((read_reg(P___)==1)&&(read_reg(A_04)==1)))
_0x174:
	CALL SUBOPT_0x3E
	CALL __CPD10
	BREQ _0x178
	CALL SUBOPT_0x3E
	__CPD1N 0x3F800000
	BRNE _0x179
	LDI  R30,LOW(10)
	CALL SUBOPT_0x44
	BREQ _0x178
_0x179:
	RJMP _0x177
_0x178:
;     618                         {
;     619                         time_pause2=sys_time;
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
;	power_off -> Y+283
	LDS  R30,_sys_time
	LDS  R31,_sys_time+1
	LDS  R22,_sys_time+2
	LDS  R23,_sys_time+3
	CALL __CDF1
	__PUTD1S 28
;     620                         flag_start_pause2=1;
	SET
	BLD  R15,1
;     621                         }
;     622                 }
_0x177:
;     623         //-------------------------------------------------------------------//
;     624         
;     625 
;     626 
;     627 
;     628 
;     629 
;     630 
;     631 
;     632 
;     633 
;     634 
;     635 
;     636         //-------------------------------------------------------------------//
;     637         //      МЕНЮ
;     638         //-------------------------------------------------------------------//
;     639         //возврат из меню
;     640         //-------------------------------------------------------------------//
;     641         if (((sys_time-start_time_mode)>read_reg(A_13)*2000)){mode=0;f_m1=0;}
_0x173:
_0x172:
	LDS  R26,_start_time_mode
	LDS  R27,_start_time_mode+1
	LDS  R24,_start_time_mode+2
	LDS  R25,_start_time_mode+3
	LDS  R30,_sys_time
	LDS  R31,_sys_time+1
	LDS  R22,_sys_time+2
	LDS  R23,_sys_time+3
	CALL __SUBD12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDI  R30,LOW(19)
	CALL SUBOPT_0x24
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __CDF2
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x17C
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
;	power_off -> Y+283
	LDI  R30,LOW(0)
	STS  _mode,R30
	CLT
	BLD  R15,2
;     642         //-------------------------------------------------------------------//
;     643 
;     644 
;     645 
;     646         if ((key_enter_press_switch==1)&&(mode==0)){key_enter_press_switch=0;key_enter_press_switch1=1;}
_0x17C:
	SBRS R4,2
	RJMP _0x17E
	LDS  R26,_mode
	CPI  R26,LOW(0x0)
	BREQ _0x17F
_0x17E:
	RJMP _0x17D
_0x17F:
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
;	power_off -> Y+283
	CLT
	BLD  R4,2
	SET
	BLD  R15,3
;     647 
;     648 
;     649         //-------------------------------------------------------------------//
;     650         //вход в инженерное меню
;     651         //-------------------------------------------------------------------//
;     652         if ((key_enter_press_switch1==1)&&(key_enter==1)&&(key_mode==0))
_0x17D:
	SBRS R15,3
	RJMP _0x181
	SBRS R3,2
	RJMP _0x181
	SBRS R2,7
	RJMP _0x182
_0x181:
	RJMP _0x180
_0x182:
;     653                 {if ((sys_time-whait_time)>3000){mode=10;start_time_mode=sys_time;key_enter_press_switch1=0;}}
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
;	power_off -> Y+283
	LDS  R26,_whait_time
	LDS  R27,_whait_time+1
	LDS  R24,_whait_time+2
	LDS  R25,_whait_time+3
	CALL SUBOPT_0x12
	__GETD1N 0xBB8
	CALL __CPD12
	BRGE _0x183
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
;	power_off -> Y+283
	LDI  R30,LOW(10)
	STS  _mode,R30
	LDS  R30,_sys_time
	LDS  R31,_sys_time+1
	LDS  R22,_sys_time+2
	LDS  R23,_sys_time+3
	STS  _start_time_mode,R30
	STS  _start_time_mode+1,R31
	STS  _start_time_mode+2,R22
	STS  _start_time_mode+3,R23
	CLT
	BLD  R15,3
_0x183:
;     654         //-------------------------------------------------------------------//
;     655 
;     656         //-------------------------------------------------------------------//
;     657         //Ожидание выключения питания 
;     658         //-------------------------------------------------------------------//
;     659         if ((key_enter_press_switch1==1)&&(key_enter==1)&&(key_mode==1)&&(key_2==1)&&(key_3==1))
_0x180:
	SBRS R15,3
	RJMP _0x185
	SBRS R3,2
	RJMP _0x185
	SBRS R2,7
	RJMP _0x185
	SBIS 0x13,1
	RJMP _0x185
	SBIC 0x10,6
	RJMP _0x186
_0x185:
	RJMP _0x184
_0x186:
;     660                 {if ((sys_time-whait_time)>3000) {goto power_off;}}
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
;	power_off -> Y+283
	LDS  R26,_whait_time
	LDS  R27,_whait_time+1
	LDS  R24,_whait_time+2
	LDS  R25,_whait_time+3
	CALL SUBOPT_0x12
	__GETD1N 0xBB8
	CALL __CPD12
	BRGE _0x187
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
;	power_off -> Y+283
	RJMP _0xF7
_0x187:
;     661         //-------------------------------------------------------------------//
;     662 
;     663         //-------------------------------------------------------------------//
;     664         //что показывать в mode=0
;     665         //-------------------------------------------------------------------//
;     666         if (mode==0)
_0x184:
	LDS  R30,_mode
	CPI  R30,0
	BREQ PC+3
	JMP _0x188
;     667                 {
;     668                 count_register=1;
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	LDI  R30,LOW(1)
	CALL SUBOPT_0x2D
;     669                 point=work_point;
;     670                 if (((alarm_alarm1==0)||((alarm_alarm1==1)&&(read_reg(A_14)==0)))&&((alarm_alarm2==0)||((alarm_alarm2==1)&&(read_reg(A_15)==0))))
	SBRS R4,6
	RJMP _0x18A
	SBRS R4,6
	RJMP _0x18B
	CALL SUBOPT_0x3F
	BREQ _0x18A
_0x18B:
	RJMP _0x18E
_0x18A:
	SBRS R4,7
	RJMP _0x18F
	SBRS R4,7
	RJMP _0x190
	CALL SUBOPT_0x40
	BREQ _0x18F
_0x190:
	RJMP _0x18E
_0x18F:
	RJMP _0x193
_0x18E:
	RJMP _0x189
_0x193:
;     671                         {
;     672                         if (read_reg(A_05)==0)adc_value3=adc_value1;
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	CALL SUBOPT_0x45
	CALL __CPD10
	BRNE _0x194
	__GETD1S 24
	STS  _adc_value3,R30
	STS  _adc_value3+1,R31
	STS  _adc_value3+2,R22
	STS  _adc_value3+3,R23
;     673                         else if (read_reg(A_05)==2){adc_value3=buf[buf_end];point=1;}
	RJMP _0x195
_0x194:
	CALL SUBOPT_0x45
	__CPD1N 0x40000000
	BRNE _0x196
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	CALL SUBOPT_0x13
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	CLR  R22
	CLR  R23
	CALL __CDF1
	STS  _adc_value3,R30
	STS  _adc_value3+1,R31
	STS  _adc_value3+2,R22
	STS  _adc_value3+3,R23
	LDI  R30,LOW(1)
	STS  _point,R30
;     674                         else adc_value3=adc_value2;
	RJMP _0x197
_0x196:
	__GETD1S 12
	STS  _adc_value3,R30
	STS  _adc_value3+1,R31
	STS  _adc_value3+2,R22
	STS  _adc_value3+3,R23
;     675                         }
_0x197:
_0x195:
;     676                 hex2dec(adc_value3);
_0x189:
	CALL SUBOPT_0x46
;     677                 if (point==1)       {set_led_on(0,0,0,1,0,0,0,0);set_led_off(0,0,0,1,0,0,0,0);}
	BRNE _0x198
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	CALL SUBOPT_0x23
	CALL SUBOPT_0x31
	CALL SUBOPT_0x23
	CALL _set_led_on
	CALL SUBOPT_0x23
	CALL SUBOPT_0x31
	CALL SUBOPT_0x23
	CALL _set_led_off
;     678                 else if (point==2)  {set_led_on(0,0,0,1,0,0,1,0);set_led_off(0,0,0,1,0,0,1,0);}
	RJMP _0x199
_0x198:
	LDS  R26,_point
	CPI  R26,LOW(0x2)
	BRNE _0x19A
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	CALL SUBOPT_0x23
	CALL SUBOPT_0x31
	CALL SUBOPT_0x30
	CALL _set_led_on
	CALL SUBOPT_0x23
	CALL SUBOPT_0x31
	CALL SUBOPT_0x30
	CALL _set_led_off
;     679                 else if (point==3)  {set_led_on(0,0,0,1,0,1,0,0);set_led_off(0,0,0,1,0,1,0,0);}
	RJMP _0x19B
_0x19A:
	LDS  R26,_point
	CPI  R26,LOW(0x3)
	BRNE _0x19C
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	CALL SUBOPT_0x23
	CALL SUBOPT_0x47
	CALL SUBOPT_0x32
	CALL _set_led_on
	CALL SUBOPT_0x23
	CALL SUBOPT_0x47
	CALL SUBOPT_0x32
	CALL _set_led_off
;     680                 else if (point==4)  {set_led_on(0,0,0,1,1,0,0,0);set_led_off(0,0,0,1,1,0,0,0);}
	RJMP _0x19D
_0x19C:
	LDS  R26,_point
	CPI  R26,LOW(0x4)
	BRNE _0x19E
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	CALL SUBOPT_0x23
	CALL SUBOPT_0x48
	CALL SUBOPT_0x33
	CALL SUBOPT_0x48
	CALL SUBOPT_0x34
;     681                 }
_0x19E:
_0x19D:
_0x19B:
_0x199:
;     682         //-------------------------------------------------------------------//
;     683                 
;     684         //-------------------------------------------------------------------//
;     685         //пользовательское меню
;     686         //-------------------------------------------------------------------//
;     687         if (mode==1)
_0x188:
	LDS  R26,_mode
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x19F
;     688                 {
;     689                 hex2dec(count_register);
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	LDS  R30,_count_register
	CALL SUBOPT_0x49
;     690                 ed=' ';
	CALL SUBOPT_0x25
;     691                 switch (count_register)
;     692                         {
;     693                         case 2: tis='У';sot='_';des= 2 ;set_led_on(0,1,0,1,0,0,0,0);break;
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	BRNE _0x1A3
	CALL SUBOPT_0x26
	CALL SUBOPT_0x4A
	CALL SUBOPT_0x32
	CALL SUBOPT_0x23
	CALL _set_led_on
	RJMP _0x1A2
;     694                         case 3: tis= 3 ;sot='_';des= 1 ;set_led_on(0,0,1,1,0,0,0,0);break;
_0x1A3:
	CPI  R30,LOW(0x3)
	BRNE _0x1A4
	CALL SUBOPT_0x27
	CALL SUBOPT_0x4B
	CALL SUBOPT_0x4C
	CALL SUBOPT_0x23
	CALL _set_led_on
	RJMP _0x1A2
;     695                         case 4: tis= 3 ;sot='_';des= 2 ;set_led_on(0,1,0,1,0,0,0,0);break;
_0x1A4:
	CPI  R30,LOW(0x4)
	BRNE _0x1A5
	CALL SUBOPT_0x27
	CALL SUBOPT_0x4A
	CALL SUBOPT_0x32
	CALL SUBOPT_0x23
	CALL _set_led_on
	RJMP _0x1A2
;     696                         case 5: tis='p';sot='_';des='_';set_led_on(0,0,0,1,0,0,0,0);break;
_0x1A5:
	CPI  R30,LOW(0x5)
	BRNE _0x1A6
	CALL SUBOPT_0x28
	CALL SUBOPT_0x23
	CALL SUBOPT_0x31
	CALL SUBOPT_0x23
	CALL _set_led_on
	RJMP _0x1A2
;     697                         case 6: tis='c';sot='_';des='_';set_led_on(0,0,0,1,0,0,0,0);break;
_0x1A6:
	CPI  R30,LOW(0x6)
	BRNE _0x1A8
	CALL SUBOPT_0x29
	CALL SUBOPT_0x23
	CALL SUBOPT_0x31
	CALL SUBOPT_0x23
	CALL _set_led_on
	RJMP _0x1A2
;     698                         default:tis='У';sot='_';des= 1 ;set_led_on(0,0,1,1,0,0,0,0);break;
_0x1A8:
	CALL SUBOPT_0x26
	CALL SUBOPT_0x4B
	CALL SUBOPT_0x4C
	CALL SUBOPT_0x23
	CALL _set_led_on
;     699                         }
_0x1A2:
;     700                 set_led_off(0,0,0,1,0,0,0,0);
	CALL SUBOPT_0x23
	CALL SUBOPT_0x31
	CALL SUBOPT_0x23
	CALL _set_led_off
;     701                 }
;     702         //-------------------------------------------------------------------//
;     703 
;     704         //-------------------------------------------------------------------//
;     705         //данные пользовательского меню
;     706         //-------------------------------------------------------------------//
;     707         if (mode==2)
_0x19F:
	LDS  R26,_mode
	CPI  R26,LOW(0x2)
	BREQ PC+3
	JMP _0x1A9
;     708                 {
;     709                 if (count_register>6)count_register=1;
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	LDS  R26,_count_register
	LDI  R30,LOW(6)
	CP   R30,R26
	BRSH _0x1AA
	LDI  R30,LOW(1)
	STS  _count_register,R30
;     710                 if (count_register<3)point=work_point;
_0x1AA:
	LDS  R26,_count_register
	CPI  R26,LOW(0x3)
	BRSH _0x1AB
	LDS  R30,_work_point
	RJMP _0x2A6
;     711                 else point=1;
_0x1AB:
	LDI  R30,LOW(1)
_0x2A6:
	STS  _point,R30
;     712                 hex2dec(data_register);
	CALL SUBOPT_0x2F
;     713                 if (point==1)       {set_led_on(0,0,0,0,0,0,0,0);set_led_off(0,0,0,0,0,0,0,0);}
	LDS  R26,_point
	CPI  R26,LOW(0x1)
	BRNE _0x1AD
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL _set_led_on
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL _set_led_off
;     714                 else if (point==2)  {set_led_on(0,0,0,0,0,0,1,0);set_led_off(0,0,0,0,0,0,1,0);}
	RJMP _0x1AE
_0x1AD:
	LDS  R26,_point
	CPI  R26,LOW(0x2)
	BRNE _0x1AF
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL SUBOPT_0x30
	CALL _set_led_on
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL SUBOPT_0x30
	CALL _set_led_off
;     715                 else if (point==3)  {set_led_on(0,0,0,0,0,1,0,0);set_led_off(0,0,0,0,0,1,0,0);}
	RJMP _0x1B0
_0x1AF:
	LDS  R26,_point
	CPI  R26,LOW(0x3)
	BRNE _0x1B1
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL SUBOPT_0x31
	CALL _set_led_on
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL SUBOPT_0x31
	CALL _set_led_off
;     716                 else if (point==4)  {set_led_on(0,0,0,0,1,0,0,0);set_led_off(0,0,0,0,1,0,0,0);}
	RJMP _0x1B2
_0x1B1:
	LDS  R26,_point
	CPI  R26,LOW(0x4)
	BRNE _0x1B3
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL SUBOPT_0x32
	CALL SUBOPT_0x33
	CALL SUBOPT_0x23
	CALL SUBOPT_0x32
	CALL SUBOPT_0x34
;     717                 }
_0x1B3:
_0x1B2:
_0x1B0:
_0x1AE:
;     718         //-------------------------------------------------------------------//
;     719 
;     720         //-------------------------------------------------------------------//
;     721         //инженерное меню
;     722         //-------------------------------------------------------------------//
;     723         if (mode==10)
_0x1A9:
	LDS  R26,_mode
	CPI  R26,LOW(0xA)
	BRNE _0x1B4
;     724                 {
;     725                 if (count_register<7) count_register=7;
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	LDS  R26,_count_register
	CPI  R26,LOW(0x7)
	BRSH _0x1B5
	LDI  R30,LOW(7)
	STS  _count_register,R30
;     726                 hex2dec(count_register-6);point=1;
_0x1B5:
	LDS  R30,_count_register
	SUBI R30,LOW(6)
	CALL SUBOPT_0x49
	LDI  R30,LOW(1)
	STS  _point,R30
;     727                 if (des==' ') des='_';
	LDS  R26,_des
	CPI  R26,LOW(0x20)
	BRNE _0x1B6
	LDI  R30,LOW(95)
	STS  _des,R30
;     728                 tis='a';sot='_';
_0x1B6:
	LDI  R30,LOW(97)
	STS  _tis,R30
	LDI  R30,LOW(95)
	STS  _sot,R30
;     729                 set_led_on(0,0,0,1,0,0,0,0);
	CALL SUBOPT_0x23
	CALL SUBOPT_0x31
	CALL SUBOPT_0x23
	CALL _set_led_on
;     730                 set_led_off(0,0,0,1,0,0,0,0);
	CALL SUBOPT_0x23
	CALL SUBOPT_0x31
	CALL SUBOPT_0x23
	CALL _set_led_off
;     731                 }
;     732         //-------------------------------------------------------------------//
;     733 
;     734         //-------------------------------------------------------------------//
;     735         //калибровка
;     736         //-------------------------------------------------------------------//
;     737         if ((mode==11)&&(count_register==A_16))
_0x1B4:
	LDS  R26,_mode
	CPI  R26,LOW(0xB)
	BRNE _0x1B8
	LDS  R26,_count_register
	CPI  R26,LOW(0x16)
	BREQ _0x1B9
_0x1B8:
	RJMP _0x1B7
_0x1B9:
;     738                 {
;     739                 point=work_point;
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	LDS  R30,_work_point
	STS  _point,R30
;     740                 k_k=data_register;
	__GETD1S 20
	__PUTD1S 8
;     741                 if (read_reg(A_05)==0)adc_value3=adc_value1;
	CALL SUBOPT_0x45
	CALL __CPD10
	BRNE _0x1BA
	__GETD1S 24
	RJMP _0x2A7
;     742                 else adc_value3=adc_value2;
_0x1BA:
	__GETD1S 12
_0x2A7:
	STS  _adc_value3,R30
	STS  _adc_value3+1,R31
	STS  _adc_value3+2,R22
	STS  _adc_value3+3,R23
;     743                 hex2dec(adc_value3);
	CALL SUBOPT_0x46
;     744                 if (point==1)       {set_led_on(0,0,0,1,0,0,0,0);set_led_off(0,0,0,1,0,0,0,0);}
	BRNE _0x1BC
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	CALL SUBOPT_0x23
	CALL SUBOPT_0x31
	CALL SUBOPT_0x23
	CALL _set_led_on
	CALL SUBOPT_0x23
	CALL SUBOPT_0x31
	CALL SUBOPT_0x23
	CALL _set_led_off
;     745                 else if (point==2)  {set_led_on(0,0,0,1,0,0,1,0);set_led_off(0,0,0,1,0,0,1,0);}
	RJMP _0x1BD
_0x1BC:
	LDS  R26,_point
	CPI  R26,LOW(0x2)
	BRNE _0x1BE
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	CALL SUBOPT_0x23
	CALL SUBOPT_0x31
	CALL SUBOPT_0x30
	CALL _set_led_on
	CALL SUBOPT_0x23
	CALL SUBOPT_0x31
	CALL SUBOPT_0x30
	CALL _set_led_off
;     746                 else if (point==3)  {set_led_on(0,0,0,1,0,1,0,0);set_led_off(0,0,0,1,0,1,0,0);}
	RJMP _0x1BF
_0x1BE:
	LDS  R26,_point
	CPI  R26,LOW(0x3)
	BRNE _0x1C0
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	CALL SUBOPT_0x23
	CALL SUBOPT_0x47
	CALL SUBOPT_0x32
	CALL _set_led_on
	CALL SUBOPT_0x23
	CALL SUBOPT_0x47
	CALL SUBOPT_0x32
	CALL _set_led_off
;     747                 else if (point==4)  {set_led_on(0,0,0,1,1,0,0,0);set_led_off(0,0,0,1,1,0,0,0);}
	RJMP _0x1C1
_0x1C0:
	LDS  R26,_point
	CPI  R26,LOW(0x4)
	BRNE _0x1C2
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	CALL SUBOPT_0x23
	CALL SUBOPT_0x48
	CALL SUBOPT_0x33
	CALL SUBOPT_0x48
	CALL SUBOPT_0x34
;     748                 point=4;
_0x1C2:
_0x1C1:
_0x1BF:
_0x1BD:
	LDI  R30,LOW(4)
	STS  _point,R30
;     749                 }
;     750         //-------------------------------------------------------------------//
;     751 
;     752         //-------------------------------------------------------------------//
;     753         //данные инженерного меню
;     754         //-------------------------------------------------------------------//
;     755         if ((mode==11)&&(count_register!=A_16))
_0x1B7:
	LDS  R26,_mode
	CPI  R26,LOW(0xB)
	BRNE _0x1C4
	LDS  R26,_count_register
	CPI  R26,LOW(0x16)
	BRNE _0x1C5
_0x1C4:
	RJMP _0x1C3
_0x1C5:
;     756                 {
;     757                 if (((count_register>=A_06)&&(count_register<=A_09)))
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	LDS  R26,_count_register
	CPI  R26,LOW(0xC)
	BRLO _0x1C7
	LDI  R30,LOW(15)
	CP   R30,R26
	BRSH _0x1C8
_0x1C7:
	RJMP _0x1C6
_0x1C8:
;     758                         {//point=work_point;
;     759                         if ((data_register<0))
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	__GETD2S 20
	CALL __CPD20
	BRGE _0x1C9
;     760                                 {
;     761                                 if (data_register>=-1000)point=1;
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	CALL SUBOPT_0x1D
	BRLO _0x1CA
	LDI  R30,LOW(1)
	STS  _point,R30
;     762                                 else if (data_register>=-100)point=2;
	RJMP _0x1CB
_0x1CA:
	CALL SUBOPT_0x1E
	BRLO _0x1CC
	LDI  R30,LOW(2)
	STS  _point,R30
;     763                                 else if (data_register>=-10)point=3;
	RJMP _0x1CD
_0x1CC:
	CALL SUBOPT_0x1F
	BRLO _0x1CE
	LDI  R30,LOW(3)
	STS  _point,R30
;     764                                 }
_0x1CE:
_0x1CD:
_0x1CB:
;     765                         else
	RJMP _0x1CF
_0x1C9:
;     766                                 {
;     767                                 if (data_register<10)point=4;
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	CALL SUBOPT_0x20
	BRSH _0x1D0
	LDI  R30,LOW(4)
	STS  _point,R30
;     768                                 else if (data_register<100)point=3;
	RJMP _0x1D1
_0x1D0:
	CALL SUBOPT_0x21
	BRSH _0x1D2
	LDI  R30,LOW(3)
	STS  _point,R30
;     769                                 else if (data_register<1000)point=2;
	RJMP _0x1D3
_0x1D2:
	CALL SUBOPT_0x22
	BRSH _0x1D4
	LDI  R30,LOW(2)
	STS  _point,R30
;     770                                 else if (data_register>=1000)point=1;
	RJMP _0x1D5
_0x1D4:
	CALL SUBOPT_0x22
	BRLO _0x1D6
	LDI  R30,LOW(1)
	STS  _point,R30
;     771                                 }
_0x1D6:
_0x1D5:
_0x1D3:
_0x1D1:
_0x1CF:
;     772                         }
;     773                 else if (count_register==A_10)point=3;
	RJMP _0x1D7
_0x1C6:
	LDS  R26,_count_register
	CPI  R26,LOW(0x10)
	BRNE _0x1D8
	LDI  R30,LOW(3)
	RJMP _0x2A8
;     774                 else point=1;
_0x1D8:
	LDI  R30,LOW(1)
_0x2A8:
	STS  _point,R30
;     775                 hex2dec(data_register);
_0x1D7:
	CALL SUBOPT_0x2F
;     776                 if (count_register==A_18){tis='a',sot=2;des='-';ed=1;point=1;}
	LDS  R26,_count_register
	CPI  R26,LOW(0x18)
	BRNE _0x1DA
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	LDI  R30,LOW(97)
	STS  _tis,R30
	LDI  R30,LOW(2)
	STS  _sot,R30
	LDI  R30,LOW(45)
	STS  _des,R30
	LDI  R30,LOW(1)
	CALL SUBOPT_0x4D
;     777                 if (count_register==A_19){tis=0,sot=1;des=0;ed=7;point=3;}
_0x1DA:
	LDS  R26,_count_register
	CPI  R26,LOW(0x19)
	BRNE _0x1DB
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	LDI  R30,LOW(0)
	STS  _tis,R30
	LDI  R30,LOW(1)
	CALL SUBOPT_0x4E
	LDI  R30,LOW(7)
	STS  _ed,R30
	LDI  R30,LOW(3)
	STS  _point,R30
;     778                 if (count_register==A_16)
_0x1DB:
	LDS  R26,_count_register
	CPI  R26,LOW(0x16)
	BREQ PC+3
	JMP _0x1DC
;     779                         {
;     780                         if (data_register==0)     {tis=4,sot='-';des=2;ed=0;point=1;}
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	__GETD1S 20
	CALL __CPD10
	BRNE _0x1DD
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	LDI  R30,LOW(4)
	CALL SUBOPT_0x4F
;     781                         else if (data_register==1){tis=0,sot='-';des=0;ed=5;point=1;}
	RJMP _0x1DE
_0x1DD:
	__GETD2S 20
	__CPD2N 0x3F800000
	BRNE _0x1DF
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	CALL SUBOPT_0x50
	CALL SUBOPT_0x4E
	LDI  R30,LOW(5)
	CALL SUBOPT_0x4D
;     782                         else if (data_register==2){tis=0,sot='-';des=2;ed=0;point=1;}
	RJMP _0x1E0
_0x1DF:
	__GETD2S 20
	__CPD2N 0x40000000
	BRNE _0x1E1
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	LDI  R30,LOW(0)
	CALL SUBOPT_0x4F
;     783                         else if (data_register==3){tis=0,sot='-';des=1;ed=0;point=1;}
	RJMP _0x1E2
_0x1E1:
	__GETD2S 20
	__CPD2N 0x40400000
	BRNE _0x1E3
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	CALL SUBOPT_0x50
	STS  _sot,R30
	LDI  R30,LOW(1)
	STS  _des,R30
	LDI  R30,LOW(0)
	STS  _ed,R30
	LDI  R30,LOW(1)
	RJMP _0x2A9
;     784                         else                      {tis=0,sot='-';des=0;ed=5;point=3;}
_0x1E3:
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	CALL SUBOPT_0x50
	CALL SUBOPT_0x4E
	LDI  R30,LOW(5)
	STS  _ed,R30
	LDI  R30,LOW(3)
_0x2A9:
	STS  _point,R30
_0x1E2:
_0x1E0:
_0x1DE:
;     785                         }
;     786                 if (point==1)       {set_led_on(0,0,0,0,0,0,0,0);set_led_off(0,0,0,0,0,0,0,0);}
_0x1DC:
	LDS  R26,_point
	CPI  R26,LOW(0x1)
	BRNE _0x1E5
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL _set_led_on
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL _set_led_off
;     787                 else if (point==2)  {set_led_on(0,0,0,0,0,0,1,0);set_led_off(0,0,0,0,0,0,1,0);}
	RJMP _0x1E6
_0x1E5:
	LDS  R26,_point
	CPI  R26,LOW(0x2)
	BRNE _0x1E7
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL SUBOPT_0x30
	CALL _set_led_on
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL SUBOPT_0x30
	CALL _set_led_off
;     788                 else if (point==3)  {set_led_on(0,0,0,0,0,1,0,0);set_led_off(0,0,0,0,0,1,0,0);}
	RJMP _0x1E8
_0x1E7:
	LDS  R26,_point
	CPI  R26,LOW(0x3)
	BRNE _0x1E9
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL SUBOPT_0x31
	CALL _set_led_on
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL SUBOPT_0x31
	CALL _set_led_off
;     789                 else if (point==4)  {set_led_on(0,0,0,0,1,0,0,0);set_led_off(0,0,0,0,1,0,0,0);}
	RJMP _0x1EA
_0x1E9:
	LDS  R26,_point
	CPI  R26,LOW(0x4)
	BRNE _0x1EB
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL SUBOPT_0x32
	CALL SUBOPT_0x33
	CALL SUBOPT_0x23
	CALL SUBOPT_0x32
	CALL SUBOPT_0x34
;     790                 }
_0x1EB:
_0x1EA:
_0x1E8:
_0x1E6:
;     791         //-------------------------------------------------------------------//
;     792         
;     793         
;     794         if (key_plus_press==1)
_0x1C3:
	SBRS R3,4
	RJMP _0x1EC
;     795                 {
;     796                 start_time_mode=sys_time;
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	CALL SUBOPT_0x51
;     797                 if (count_key==0)
	BRNE _0x1ED
;     798                         {
;     799                         if (mode==10)if (++count_register>MAX_REGISTER)count_register=MAX_REGISTER;
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	LDS  R26,_mode
	CPI  R26,LOW(0xA)
	BRNE _0x1EE
	CALL SUBOPT_0x52
	LDI  R30,LOW(26)
	CP   R30,R26
	BRSH _0x1EF
	STS  _count_register,R30
;     800                         if (mode==1)if (++count_register>6)count_register=6;
_0x1EF:
_0x1EE:
	LDS  R26,_mode
	CPI  R26,LOW(0x1)
	BRNE _0x1F0
	CALL SUBOPT_0x52
	LDI  R30,LOW(6)
	CP   R30,R26
	BRSH _0x1F1
	STS  _count_register,R30
;     801                         }
_0x1F1:
_0x1F0:
;     802                 if ((count_key==0)||(count_key==21)||(count_key1==102))
_0x1ED:
	LDS  R26,_count_key
	CPI  R26,LOW(0x0)
	BREQ _0x1F3
	CPI  R26,LOW(0x15)
	BREQ _0x1F3
	LDS  R26,_count_key1
	CPI  R26,LOW(0x66)
	BREQ _0x1F3
	RJMP _0x1F2
_0x1F3:
;     803                         {
;     804                         if      (point==1)
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	LDS  R26,_point
	CPI  R26,LOW(0x1)
	BRNE _0x1F5
;     805                                 {
;     806                                 data_register=data_register+1;
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	__GETD1S 20
	__GETD2N 0x3F800000
	CALL __ADDF12
	CALL SUBOPT_0x1C
;     807                                 if ((data_register<0)&&(data_register>=-100))point=2;
	BRGE _0x1F7
	CALL SUBOPT_0x1E
	BRSH _0x1F8
_0x1F7:
	RJMP _0x1F6
_0x1F8:
	LDI  R30,LOW(2)
	STS  _point,R30
;     808                                 }
_0x1F6:
;     809                         else if (point==2)
	RJMP _0x1F9
_0x1F5:
	LDS  R26,_point
	CPI  R26,LOW(0x2)
	BRNE _0x1FA
;     810                                 {
;     811                                 data_register=data_register+0.1;
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	__GETD1S 20
	__GETD2N 0x3DCCCCCD
	CALL SUBOPT_0x53
;     812                                 if ((data_register>0)&&(data_register>=1000))point=1;
	BRGE _0x1FC
	CALL SUBOPT_0x22
	BRSH _0x1FD
_0x1FC:
	RJMP _0x1FB
_0x1FD:
	LDI  R30,LOW(1)
	STS  _point,R30
;     813                                 else if ((data_register<0)&&(data_register>=-10))point=3;
	RJMP _0x1FE
_0x1FB:
	__GETD2S 20
	CALL __CPD20
	BRGE _0x200
	CALL SUBOPT_0x1F
	BRSH _0x201
_0x200:
	RJMP _0x1FF
_0x201:
	LDI  R30,LOW(3)
	STS  _point,R30
;     814                                 }
_0x1FF:
_0x1FE:
;     815                         else if (point==3)
	RJMP _0x202
_0x1FA:
	LDS  R26,_point
	CPI  R26,LOW(0x3)
	BRNE _0x203
;     816                                 {
;     817                                 data_register=data_register+0.01;
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	__GETD1S 20
	__GETD2N 0x3C23D70A
	CALL SUBOPT_0x53
;     818                                 if ((data_register>0)&&(data_register>=100))point=2;
	BRGE _0x205
	CALL SUBOPT_0x21
	BRSH _0x206
_0x205:
	RJMP _0x204
_0x206:
	LDI  R30,LOW(2)
	STS  _point,R30
;     819                                 else if ((data_register<0)&&(data_register>=-10))point=2;
	RJMP _0x207
_0x204:
	__GETD2S 20
	CALL __CPD20
	BRGE _0x209
	CALL SUBOPT_0x1F
	BRSH _0x20A
_0x209:
	RJMP _0x208
_0x20A:
	LDI  R30,LOW(2)
	STS  _point,R30
;     820                                 }
_0x208:
_0x207:
;     821                         else if (point==4)
	RJMP _0x20B
_0x203:
	LDS  R26,_point
	CPI  R26,LOW(0x4)
	BRNE _0x20C
;     822                                 {
;     823                                 data_register=data_register+0.001;
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	__GETD1S 20
	__GETD2N 0x3A83126F
	CALL SUBOPT_0x53
;     824                                 if ((data_register>0)&&(data_register>=10))point=3;
	BRGE _0x20E
	CALL SUBOPT_0x20
	BRSH _0x20F
_0x20E:
	RJMP _0x20D
_0x20F:
	LDI  R30,LOW(3)
	STS  _point,R30
;     825 //                                else if ((data_register<0)&&(data_register>=-1))point=3;
;     826                                 }
_0x20D:
;     827                         if (data_register>MAX_MIN[count_register,1])data_register=MAX_MIN[count_register,1];
_0x20C:
_0x20B:
_0x202:
_0x1F9:
	CALL SUBOPT_0x54
	__GETD2S 20
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x210
	CALL SUBOPT_0x54
	__PUTD1S 20
;     828                         if (count_key==0)count_key=60;if (count_key==21)count_key=20;
_0x210:
	LDS  R30,_count_key
	CPI  R30,0
	BRNE _0x211
	LDI  R30,LOW(60)
	STS  _count_key,R30
_0x211:
	LDS  R26,_count_key
	CPI  R26,LOW(0x15)
	BRNE _0x212
	LDI  R30,LOW(20)
	STS  _count_key,R30
;     829                         }
_0x212:
;     830                 rekey();
_0x1F2:
	CALL _rekey
;     831                 }
;     832         else if ((mode!=100)&&(key_enter_press==0)&&(key_mines_press==0)){count_key=0;count_key1=0;count_key2=0;}
	RJMP _0x213
_0x1EC:
	LDS  R26,_mode
	CPI  R26,LOW(0x64)
	BREQ _0x215
	SBRC R3,6
	RJMP _0x215
	SBRS R3,5
	RJMP _0x216
_0x215:
	RJMP _0x214
_0x216:
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	CALL SUBOPT_0x55
;     833 
;     834         if (key_mines_press==1)
_0x214:
_0x213:
	SBRS R3,5
	RJMP _0x217
;     835                 {
;     836                 start_time_mode=sys_time;
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	CALL SUBOPT_0x51
;     837                 if (count_key==0)
	BRNE _0x218
;     838                         {
;     839                         if (mode==10)if (--count_register<7)count_register=7;
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	LDS  R26,_mode
	CPI  R26,LOW(0xA)
	BRNE _0x219
	CALL SUBOPT_0x56
	CPI  R26,LOW(0x7)
	BRSH _0x21A
	LDI  R30,LOW(7)
	STS  _count_register,R30
;     840                         if (mode==1)if (--count_register<1)count_register=1;
_0x21A:
_0x219:
	LDS  R26,_mode
	CPI  R26,LOW(0x1)
	BRNE _0x21B
	CALL SUBOPT_0x56
	CPI  R26,LOW(0x1)
	BRSH _0x21C
	LDI  R30,LOW(1)
	STS  _count_register,R30
;     841                         }
_0x21C:
_0x21B:
;     842                 if ((count_key==0)||(count_key==21)||(count_key1==102))
_0x218:
	LDS  R26,_count_key
	CPI  R26,LOW(0x0)
	BREQ _0x21E
	CPI  R26,LOW(0x15)
	BREQ _0x21E
	LDS  R26,_count_key1
	CPI  R26,LOW(0x66)
	BREQ _0x21E
	RJMP _0x21D
_0x21E:
;     843                         {
;     844                         if      (point==1)
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	LDS  R26,_point
	CPI  R26,LOW(0x1)
	BRNE _0x220
;     845                                 {
;     846                                 data_register=data_register-1;
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	__GETD2S 20
	__GETD1N 0x3F800000
	CALL SUBOPT_0x57
;     847                                 if ((data_register>0)&&(data_register<1000))point=2;
	BRGE _0x222
	CALL SUBOPT_0x22
	BRLO _0x223
_0x222:
	RJMP _0x221
_0x223:
	LDI  R30,LOW(2)
	STS  _point,R30
;     848                                 }
_0x221:
;     849                         else if (point==2)
	RJMP _0x224
_0x220:
	LDS  R26,_point
	CPI  R26,LOW(0x2)
	BRNE _0x225
;     850                                 {
;     851                                 data_register=data_register-0.1;
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	__GETD2S 20
	__GETD1N 0x3DCCCCCD
	CALL SUBOPT_0x57
;     852                                 if ((data_register>0)&&(data_register<100))point=3;
	BRGE _0x227
	CALL SUBOPT_0x21
	BRLO _0x228
_0x227:
	RJMP _0x226
_0x228:
	LDI  R30,LOW(3)
	STS  _point,R30
;     853                                 else if ((data_register<0)&&(data_register<=-100))point=1;
	RJMP _0x229
_0x226:
	__GETD2S 20
	CALL __CPD20
	BRGE _0x22B
	CALL SUBOPT_0x1E
	BREQ PC+4
	BRCS PC+3
	JMP  _0x22B
	RJMP _0x22C
_0x22B:
	RJMP _0x22A
_0x22C:
	LDI  R30,LOW(1)
	STS  _point,R30
;     854                                 }
_0x22A:
_0x229:
;     855                         else if (point==3)
	RJMP _0x22D
_0x225:
	LDS  R26,_point
	CPI  R26,LOW(0x3)
	BRNE _0x22E
;     856                                 {
;     857                                 data_register=data_register-0.01;
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	__GETD2S 20
	__GETD1N 0x3C23D70A
	CALL SUBOPT_0x57
;     858                                 if ((data_register>0)&&(data_register<10))point=4;
	BRGE _0x230
	CALL SUBOPT_0x20
	BRLO _0x231
_0x230:
	RJMP _0x22F
_0x231:
	LDI  R30,LOW(4)
	STS  _point,R30
;     859                                 else if ((data_register<0)&&(data_register<=-10))point=2;
	RJMP _0x232
_0x22F:
	__GETD2S 20
	CALL __CPD20
	BRGE _0x234
	CALL SUBOPT_0x1F
	BREQ PC+4
	BRCS PC+3
	JMP  _0x234
	RJMP _0x235
_0x234:
	RJMP _0x233
_0x235:
	LDI  R30,LOW(2)
	STS  _point,R30
;     860                                
;     861                                 }
_0x233:
_0x232:
;     862                         else if (point==4)
	RJMP _0x236
_0x22E:
	LDS  R26,_point
	CPI  R26,LOW(0x4)
	BRNE _0x237
;     863                                 {
;     864                                 data_register=data_register-0.001;
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	__GETD2S 20
	__GETD1N 0x3A83126F
	CALL __SWAPD12
	CALL __SUBF12
	CALL SUBOPT_0x1C
;     865                                 if ((data_register<0))point=3;
	BRGE _0x238
	LDI  R30,LOW(3)
	STS  _point,R30
;     866                                 }
_0x238:
;     867                         if (data_register<MAX_MIN[count_register,0])data_register=MAX_MIN[count_register,0];
_0x237:
_0x236:
_0x22D:
_0x224:
	CALL SUBOPT_0x58
	__GETD2S 20
	CALL __CMPF12
	BRSH _0x239
	CALL SUBOPT_0x58
	__PUTD1S 20
;     868                         if (count_key==0)count_key=60;if (count_key==21)count_key=20;
_0x239:
	LDS  R30,_count_key
	CPI  R30,0
	BRNE _0x23A
	LDI  R30,LOW(60)
	STS  _count_key,R30
_0x23A:
	LDS  R26,_count_key
	CPI  R26,LOW(0x15)
	BRNE _0x23B
	LDI  R30,LOW(20)
	STS  _count_key,R30
;     869                         }
_0x23B:
;     870                 rekey();
_0x21D:
	CALL _rekey
;     871                 }
;     872         else if ((mode!=100)&&(key_enter_press==0)&&(key_plus_press==0)){count_key=0;count_key1=0;count_key2=0;}
	RJMP _0x23C
_0x217:
	LDS  R26,_mode
	CPI  R26,LOW(0x64)
	BREQ _0x23E
	SBRC R3,6
	RJMP _0x23E
	SBRS R3,4
	RJMP _0x23F
_0x23E:
	RJMP _0x23D
_0x23F:
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	CALL SUBOPT_0x55
;     873 
;     874         if ((key_enter_press_switch==1)&&(key_enter==1)&&(key_plus_press==0)&&(key_mines_press==0)&&(key_mode_press==0)&&(mode!=0)&&(mode!=10)&&(mode!=1))
_0x23D:
_0x23C:
	SBRS R4,2
	RJMP _0x241
	SBRS R3,2
	RJMP _0x241
	SBRC R3,4
	RJMP _0x241
	SBRC R3,5
	RJMP _0x241
	SBRC R3,3
	RJMP _0x241
	LDS  R26,_mode
	CPI  R26,LOW(0x0)
	BREQ _0x241
	CPI  R26,LOW(0xA)
	BREQ _0x241
	CPI  R26,LOW(0x1)
	BRNE _0x242
_0x241:
	RJMP _0x240
_0x242:
;     875                 {
;     876                 save_reg(data_register,count_register);
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	__GETD1S 20
	CALL __PUTPARD1
	LDS  R30,_count_register
	CALL SUBOPT_0x59
;     877                 start_time_mode=sys_time;
	LDS  R30,_sys_time
	LDS  R31,_sys_time+1
	LDS  R22,_sys_time+2
	LDS  R23,_sys_time+3
	STS  _start_time_mode,R30
	STS  _start_time_mode+1,R31
	STS  _start_time_mode+2,R22
	STS  _start_time_mode+3,R23
;     878                 if (count_register==A_07)
	LDS  R26,_count_register
	CPI  R26,LOW(0xD)
	BRNE _0x243
;     879                         {
;     880                         ee_char=&ee_point;
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	LDI  R30,LOW(_ee_point)
	LDI  R31,HIGH(_ee_point)
	STS  _ee_char,R30
	STS  _ee_char+1,R31
;     881                         *ee_char=point;
	LDS  R30,_point
	LDS  R26,_ee_char
	LDS  R27,_ee_char+1
	CALL __EEPROMWRB
;     882                         work_point=point;
	STS  _work_point,R30
;     883                         }
;     884                 if (count_register==A_17)
_0x243:
	LDS  R26,_count_register
	CPI  R26,LOW(0x17)
	BRNE _0x244
;     885                         {
;     886                         for (i=0;i<22;i++)
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	LDI  R30,LOW(0)
	STS  _i,R30
_0x246:
	LDS  R26,_i
	CPI  R26,LOW(0x16)
	BRSH _0x247
;     887                                 {
;     888                                 save_reg(FAKTORY[i],i);
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	LDI  R26,LOW(_FAKTORY*2)
	LDI  R27,HIGH(_FAKTORY*2)
	LDS  R30,_i
	CALL SUBOPT_0xE
	CALL __GETD1PF
	CALL __PUTPARD1
	LDS  R30,_i
	CALL SUBOPT_0x59
;     889                                 }
	CALL SUBOPT_0x17
	RJMP _0x246
_0x247:
;     890                         }
;     891                 set_digit_on(' ',3,'a','п');
_0x244:
	CALL SUBOPT_0x5A
	CALL _set_digit_on
;     892                 set_digit_off(' ',3,'a','п');
	CALL SUBOPT_0x5A
	CALL _set_digit_off
;     893                 set_led_on(0,0,0,1,0,0,0,0);
	CALL SUBOPT_0x23
	CALL SUBOPT_0x31
	CALL SUBOPT_0x23
	CALL _set_led_on
;     894                 set_led_off(0,0,0,1,0,0,0,0);
	CALL SUBOPT_0x23
	CALL SUBOPT_0x31
	CALL SUBOPT_0x23
	CALL _set_led_off
;     895                 delay_ms(3000);key_enter_press_switch=0;
	LDI  R30,LOW(3000)
	LDI  R31,HIGH(3000)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	CLT
	BLD  R4,2
;     896                 set_digit_off(' ',' ',' ',' ');
	CALL SUBOPT_0x5B
	CALL SUBOPT_0x5B
	CALL _set_digit_off
;     897                 start_time_mode=sys_time;start_time=sys_time;
	LDS  R30,_sys_time
	LDS  R31,_sys_time+1
	LDS  R22,_sys_time+2
	LDS  R23,_sys_time+3
	STS  _start_time_mode,R30
	STS  _start_time_mode+1,R31
	STS  _start_time_mode+2,R22
	STS  _start_time_mode+3,R23
	LDS  R30,_sys_time
	LDS  R31,_sys_time+1
	LDS  R22,_sys_time+2
	LDS  R23,_sys_time+3
	STS  _start_time,R30
	STS  _start_time+1,R31
	STS  _start_time+2,R22
	STS  _start_time+3,R23
;     898                 f_m1=0;
	CLT
	BLD  R15,2
;     899                 }
;     900         if ((key_mode_press_switch==1)&&(key_4==1))
_0x240:
	SBRS R3,7
	RJMP _0x249
	SBIC 0x10,7
	RJMP _0x24A
_0x249:
	RJMP _0x248
_0x24A:
;     901                 {
;     902                 key_mode_press_switch=0;f_m1=0;
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	CLT
	BLD  R3,7
	BLD  R15,2
;     903                 start_time_mode=sys_time;
	LDS  R30,_sys_time
	LDS  R31,_sys_time+1
	LDS  R22,_sys_time+2
	LDS  R23,_sys_time+3
	STS  _start_time_mode,R30
	STS  _start_time_mode+1,R31
	STS  _start_time_mode+2,R22
	STS  _start_time_mode+3,R23
;     904                 switch (mode)
	LDS  R30,_mode
;     905                         {
;     906                         case 0: mode=1;count_register=1;break;
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	CPI  R30,0
	BRNE _0x24E
	LDI  R30,LOW(1)
	STS  _mode,R30
	STS  _count_register,R30
	RJMP _0x24D
;     907                         case 1: mode=2;data_register=read_reg(count_register);break;
_0x24E:
	CPI  R30,LOW(0x1)
	BRNE _0x24F
	LDI  R30,LOW(2)
	STS  _mode,R30
	CALL SUBOPT_0x2C
	RJMP _0x24D
;     908                         case 2: mode=1;break;
_0x24F:
	CPI  R30,LOW(0x2)
	BRNE _0x250
	LDI  R30,LOW(1)
	STS  _mode,R30
	RJMP _0x24D
;     909                         case 10:mode=11;data_register=read_reg(count_register);break;
_0x250:
	CPI  R30,LOW(0xA)
	BRNE _0x251
	LDI  R30,LOW(11)
	STS  _mode,R30
	CALL SUBOPT_0x2C
	RJMP _0x24D
;     910                         case 11:mode=10;break;
_0x251:
	CPI  R30,LOW(0xB)
	BRNE _0x252
	LDI  R30,LOW(10)
	STS  _mode,R30
	RJMP _0x24D
;     911                         case 100:mode=100;break;
_0x252:
	CPI  R30,LOW(0x64)
	BRNE _0x24D
	LDI  R30,LOW(100)
	STS  _mode,R30
;     912                         }
_0x24D:
;     913                 }
;     914 
;     915         if (((sys_time-start_time)>250)) 
_0x248:
	LDS  R26,_start_time
	LDS  R27,_start_time+1
	LDS  R24,_start_time+2
	LDS  R25,_start_time+3
	CALL SUBOPT_0x12
	__GETD1N 0xFA
	CALL __CPD12
	BRGE _0x254
;     916                 {
;     917                 set_digit_on(tis,sot,des,ed);
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	CALL SUBOPT_0x2A
	CALL _set_digit_on
;     918                 if (mode>0)//это шобы мигало
	LDS  R26,_mode
	LDI  R30,LOW(0)
	CP   R30,R26
	BRSH _0x255
;     919                         {
;     920                         if((key_plus_press==1)||(key_mines_press==1)) set_digit_off(tis,sot,des,ed);
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	SBRC R3,4
	RJMP _0x257
	SBRS R3,5
	RJMP _0x256
_0x257:
	LDS  R30,_tis
	ST   -Y,R30
	LDS  R30,_sot
	ST   -Y,R30
	LDS  R30,_des
	ST   -Y,R30
	LDS  R30,_ed
	RJMP _0x2AA
;     921                         else set_digit_off(' ',' ',' ',' ');
_0x256:
	CALL SUBOPT_0x5B
	LDI  R30,LOW(32)
	ST   -Y,R30
_0x2AA:
	ST   -Y,R30
	CALL _set_digit_off
;     922                         }
;     923                 if (mode==0)//а это шобы не мигало
_0x255:
	LDS  R30,_mode
	CPI  R30,0
	BRNE _0x25A
;     924                         {
;     925                         set_digit_off(tis,sot,des,ed);
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	CALL SUBOPT_0x2A
	CALL _set_digit_off
;     926                         }
;     927                 start_time=sys_time;
_0x25A:
	LDS  R30,_sys_time
	LDS  R31,_sys_time+1
	LDS  R22,_sys_time+2
	LDS  R23,_sys_time+3
	STS  _start_time,R30
	STS  _start_time+1,R31
	STS  _start_time+2,R22
	STS  _start_time+3,R23
;     928                 }
;     929 
;     930 //	rx_buffer[0]=1;      //
;     931 //	rx_buffer[1]=4;      //
;     932 //        rx_buffer[5]=3;    //
;     933 //        response_m_aa4();               //
;     934 	if (rx_c==1)			//
_0x254:
	SBRS R2,0
	RJMP _0x25B
;     935 		{			//
;     936 		check_add_cr();
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	RCALL _check_add_cr
;     937 		crc=0xffff;
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	STS  _crc,R30
	STS  _crc+1,R31
;     938 //	rx_buffer[0]=read_reg(adres);      //
;     939 //        response_m_aa4();               //
;     940 
;     941         mov_buf_mod(rx_buffer[0]);
	CALL SUBOPT_0x5C
;     942         mov_buf_mod(rx_buffer[1]);
	__GETB1MN _rx_buffer,1
	ST   -Y,R30
	RCALL _mov_buf_mod
;     943         mov_buf_mod(rx_buffer[2]);
	__GETB1MN _rx_buffer,2
	ST   -Y,R30
	RCALL _mov_buf_mod
;     944         mov_buf_mod(rx_buffer[3]);
	__GETB1MN _rx_buffer,3
	ST   -Y,R30
	RCALL _mov_buf_mod
;     945         mov_buf_mod(rx_buffer[4]);
	__GETB1MN _rx_buffer,4
	ST   -Y,R30
	RCALL _mov_buf_mod
;     946         mov_buf_mod(rx_buffer[5]);
	__GETB1MN _rx_buffer,5
	ST   -Y,R30
	RCALL _mov_buf_mod
;     947         mov_buf_mod(rx_buffer[6]);
	__GETB1MN _rx_buffer,6
	ST   -Y,R30
	RCALL _mov_buf_mod
;     948         mov_buf_mod(rx_buffer[7]);
	__GETB1MN _rx_buffer,7
	CALL SUBOPT_0x5D
;     949         crc_end();
;     950 
;     951 
;     952 
;     953                 error=1;
	SET
	BLD  R5,0
;     954 
;     955 		if (error==0)
	SBRC R5,0
	RJMP _0x25C
;     956 			{
;     957 		       //команда 04-------------------------------//
;     958 			if (rx_buffer[1]==4)
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	__GETB1MN _rx_buffer,1
	CPI  R30,LOW(0x4)
	BRNE _0x25D
;     959 	          		{
;     960 	                      	if (rx_counter==8)
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	LDI  R30,LOW(8)
	CP   R30,R6
	BRNE _0x25E
;     961 	                      		{ 
;     962 	          			if (rx_buffer[3]==0) {response_m_aa4();  goto response_end;}
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	__GETB1MN _rx_buffer,3
	CPI  R30,0
	BRNE _0x25F
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	RCALL _response_m_aa4
	RJMP _0x260
;     963        					else  {mov_buf_mod(3); crc_end();} 
_0x25F:
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	LDI  R30,LOW(3)
	CALL SUBOPT_0x5D
;     964     			    	        }
;     965                   	     	else {mov_buf_mod(1); crc_end();} 
	RJMP _0x262
_0x25E:
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	LDI  R30,LOW(1)
	CALL SUBOPT_0x5D
_0x262:
;     966                            	}
;     967                         //-------------------команда 03------------------------------//  
;     968                         else if (rx_buffer[1]==3)
	RJMP _0x263
_0x25D:
	__GETB1MN _rx_buffer,1
	CPI  R30,LOW(0x3)
	BRNE _0x264
;     969 			        {
;     970 			        if (rx_counter==8)
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	LDI  R30,LOW(8)
	CP   R30,R6
	BRNE _0x265
;     971 			                {
;     972 				        if ((rx_buffer[2]==0)&&(rx_buffer[3]==200)&&(rx_buffer[5]==3))
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	__GETB1MN _rx_buffer,2
	CPI  R30,0
	BRNE _0x267
	__GETB1MN _rx_buffer,3
	CPI  R30,LOW(0xC8)
	BRNE _0x267
	__GETB1MN _rx_buffer,5
	CPI  R30,LOW(0x3)
	BREQ _0x268
_0x267:
	RJMP _0x266
_0x268:
;     973 				        	{response_m_aa3();  goto response_end;}
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	RCALL _response_m_aa3
	RJMP _0x260
;     974 				        else  {mov_buf_mod(3); crc_end();} 
_0x266:
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	LDI  R30,LOW(3)
	CALL SUBOPT_0x5D
;     975 				        }
;     976                   	     	else {mov_buf_mod(1); crc_end();} 
	RJMP _0x26A
_0x265:
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	LDI  R30,LOW(1)
	CALL SUBOPT_0x5D
_0x26A:
;     977                            	}
;     978                         //-----------------------------команда 06adr-----------------------------------------//
;     979                        	 else	if (rx_buffer[1]==6)
	RJMP _0x26B
_0x264:
	__GETB1MN _rx_buffer,1
	CPI  R30,LOW(0x6)
	BRNE _0x26C
;     980 	          		{
;     981 	                      	if     (rx_counter==8)
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	LDI  R30,LOW(8)
	CP   R30,R6
	BRNE _0x26D
;     982 	                      	        { 
;     983 				        if ((rx_buffer[2]==2)&&(rx_buffer[3]==0)) 
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	__GETB1MN _rx_buffer,2
	CPI  R30,LOW(0x2)
	BRNE _0x26F
	__GETB1MN _rx_buffer,3
	CPI  R30,0
	BREQ _0x270
_0x26F:
	RJMP _0x26E
_0x270:
;     984        						{response_m_aa6();  goto response_end;}
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	RCALL _response_m_aa6
	RJMP _0x260
;     985 				        else  {mov_buf_mod(3); crc_end();} 
_0x26E:
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	LDI  R30,LOW(3)
	CALL SUBOPT_0x5D
;     986 				        }
;     987                   	     	else {mov_buf_mod(1); crc_end();} 
	RJMP _0x272
_0x26D:
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	LDI  R30,LOW(1)
	CALL SUBOPT_0x5D
_0x272:
;     988                            	}
;     989 		        else  {mov_buf_mod(2); crc_end();}
	RJMP _0x273
_0x26C:
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+32
;	time_pause2 -> Y+28
;	adc_value1 -> Y+24
;	data_register -> Y+20
;	adc_filter -> Y+16
;	adc_value2 -> Y+12
;	k_k -> Y+8
;	kk -> Y+4
;	bb -> Y+0
	LDI  R30,LOW(2)
	CALL SUBOPT_0x5D
_0x273:
_0x26B:
_0x263:
;     990 		        } 
;     991 		}
_0x25C:
;     992 response_end:
_0x25B:
_0x260:
;     993         rx_c=0;rx_m=0;rx_counter=0;
	CLT
	BLD  R2,0
	BLD  R2,2
	CLR  R6
;     994         };
	JMP  _0x12F
;     995 }
	ADIW R28,36
_0x274:
	RJMP _0x274
;     996 
;     997 void response_m_aa3()
;     998         {
_response_m_aa3:
;     999 	char a;
;    1000 	mov_buf_mod(rx_buffer[0]);
	ST   -Y,R16
;	a -> R16
	CALL SUBOPT_0x5C
;    1001 	mov_buf_mod(rx_buffer[1]); 
	__GETB1MN _rx_buffer,1
	ST   -Y,R30
	RCALL _mov_buf_mod
;    1002 	mov_buf_mod(rx_buffer[5]*2);
	__GETB1MN _rx_buffer,5
	CALL SUBOPT_0x5E
;    1003         i=rx_buffer[5]*2;
	__GETB1MN _rx_buffer,5
	LSL  R30
	STS  _i,R30
;    1004         a=rx_buffer[3];
	__POINTW1MN _rx_buffer,3
	LD   R16,Z
;    1005         while (i>0)
_0x275:
	CALL SUBOPT_0x5F
	BRSH _0x277
;    1006         	{
;    1007 
;    1008 
;    1009         	ee_char=(*((int *)(&reg[30])+a));
	__POINTW2MN _reg,120
	MOV  R30,R16
	CALL SUBOPT_0x19
	STS  _ee_char,R30
	STS  _ee_char+1,R31
;    1010         	mov_buf_mod(*ee_char);
	LDS  R26,_ee_char
	LDS  R27,_ee_char+1
	CALL __EEPROMRDB
	ST   -Y,R30
	RCALL _mov_buf_mod
;    1011 		a++; 
	SUBI R16,-1
;    1012 		i--;
	CALL SUBOPT_0x60
;    1013 		}
	RJMP _0x275
_0x277:
;    1014 	crc_end(); 
	RCALL _crc_end
;    1015         }
	RJMP _0x29A
;    1016 void response_m_aa6()
;    1017         {
_response_m_aa6:
;    1018         mov_buf_mod(rx_buffer[0]);
	CALL SUBOPT_0x5C
;    1019         mov_buf_mod(rx_buffer[1]);
	__GETB1MN _rx_buffer,1
	ST   -Y,R30
	RCALL _mov_buf_mod
;    1020         mov_buf_mod(rx_buffer[2]);
	__GETB1MN _rx_buffer,2
	ST   -Y,R30
	RCALL _mov_buf_mod
;    1021         mov_buf_mod(rx_buffer[3]);
	__GETB1MN _rx_buffer,3
	ST   -Y,R30
	RCALL _mov_buf_mod
;    1022         mov_buf_mod(rx_buffer[4]);
	__GETB1MN _rx_buffer,4
	ST   -Y,R30
	RCALL _mov_buf_mod
;    1023         mov_buf_mod(rx_buffer[5]);
	__GETB1MN _rx_buffer,5
	CALL SUBOPT_0x5D
;    1024 	crc_end(); 
;    1025         }                               //
	RET
;    1026 //--------------------------------------//
;    1027 void response_m_aa4()                   //
;    1028 	{                               //
_response_m_aa4:
;    1029 	char a;                         //
;    1030 	mov_buf_mod(rx_buffer[0]);      //
	ST   -Y,R16
;	a -> R16
	CALL SUBOPT_0x5C
;    1031 	mov_buf_mod(rx_buffer[1]);      //
	__GETB1MN _rx_buffer,1
	ST   -Y,R30
	RCALL _mov_buf_mod
;    1032 	mov_buf_mod(rx_buffer[5]*2);    //
	__GETB1MN _rx_buffer,5
	CALL SUBOPT_0x5E
;    1033         i=rx_buffer[5]*2;a=0;           //
	__GETB1MN _rx_buffer,5
	LSL  R30
	STS  _i,R30
	LDI  R16,LOW(0)
;    1034         while (i>0) {mov_buf_mod(*((unsigned char *)(&adc_value3)+a));a++;i--;}
_0x278:
	CALL SUBOPT_0x5F
	BRSH _0x27A
	MOV  R30,R16
	LDI  R31,0
	SUBI R30,LOW(-_adc_value3)
	SBCI R31,HIGH(-_adc_value3)
	LD   R30,Z
	ST   -Y,R30
	RCALL _mov_buf_mod
	SUBI R16,-1
	CALL SUBOPT_0x60
	RJMP _0x278
_0x27A:
;    1035 	crc_end();                      //
	RCALL _crc_end
;    1036 	}                               //
_0x29A:
	LD   R16,Y+
	RET
;    1037 //--------------------------------------//
;    1038 void check_add_cr()                     //
;    1039 	{                               //
_check_add_cr:
;    1040 	error=0;                        //
	CLT
	BLD  R5,0
;    1041 	if (rx_buffer[0]!=read_reg(adres)) error=1;
	LDI  R30,LOW(27)
	ST   -Y,R30
	CALL _read_reg
	LDS  R26,_rx_buffer
	CLR  R27
	CLR  R24
	CLR  R25
	CALL __CDF2
	CALL __CPD12
	BREQ _0x27B
	SET
	BLD  R5,0
;    1042 	crc=0xFFFF;                     //
_0x27B:
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	STS  _crc,R30
	STS  _crc+1,R31
;    1043 	i=0;                            //
	LDI  R30,LOW(0)
	STS  _i,R30
;    1044 	while (i<(rx_counter-1))       //
_0x27C:
	MOV  R30,R6
	SUBI R30,LOW(1)
	LDS  R26,_i
	CP   R26,R30
	BRSH _0x27E
;    1045 		{                       //
;    1046 		crc_rtu(rx_buffer[i]);  //
	LDS  R30,_i
	CALL SUBOPT_0x61
	ST   -Y,R30
	RCALL _crc_rtu
;    1047 		i++;                    //
	CALL SUBOPT_0x17
;    1048 		}                       //
	RJMP _0x27C
_0x27E:
;    1049 	if ((rx_buffer[rx_counter])!=(crc>>8)) error=1;
	MOV  R30,R6
	CALL SUBOPT_0x61
	MOV  R26,R30
	LDS  R30,_crc
	LDS  R31,_crc+1
	CALL __ASRW8
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	BREQ _0x27F
	SET
	BLD  R5,0
;    1050 	if ((rx_buffer[rx_counter-1])!=(crc&0x00FF)) error=1;
_0x27F:
	MOV  R30,R6
	SUBI R30,LOW(1)
	CALL SUBOPT_0x61
	MOV  R26,R30
	LDS  R30,_crc
	LDS  R31,_crc+1
	ANDI R31,HIGH(0xFF)
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	BREQ _0x280
	SET
	BLD  R5,0
;    1051 	}                               //
_0x280:
	RET
;    1052 //--------------------------------------//
;    1053 void mov_buf_mod(char a){crc_rtu(a);mov_buf(a);}//
_mov_buf_mod:
	LD   R30,Y
	ST   -Y,R30
	RCALL _crc_rtu
	LD   R30,Y
	ST   -Y,R30
	RCALL _mov_buf
	RJMP _0x299
;    1054 //--------------------------------------//
;    1055 void mov_buf(char a){tx_buffer[tx_buffer_end]=a;if (++tx_buffer_end==TX_BUFFER_SIZE) tx_buffer_end=0;}
_mov_buf:
	MOV  R30,R11
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	LD   R26,Y
	STD  Z+0,R26
	INC  R11
	LDI  R30,LOW(64)
	CP   R30,R11
	BRNE _0x281
	CLR  R11
_0x281:
_0x299:
	ADIW R28,1
	RET
;    1056 //--------------------------------------//
;    1057 void crc_end(){mov_buf(crc);mov_buf(crc>>8);rx_tx=1;UDR=tx_buffer[tx_buffer_begin];ti_en=1;crc=0xffff;}				//
_crc_end:
	LDS  R30,_crc
	ST   -Y,R30
	CALL _mov_buf
	LDS  R30,_crc
	LDS  R31,_crc+1
	CALL __ASRW8
	ST   -Y,R30
	CALL _mov_buf
	SBI  0x12,2
	CALL SUBOPT_0x0
	SET
	BLD  R2,1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	STS  _crc,R30
	STS  _crc+1,R31
	RET
;    1058 //--------------------------------------//
;    1059 void crc_rtu(char a)			//
;    1060 	{				//
_crc_rtu:
;    1061 	char n;                         //
;    1062 	crc = a^crc;			//
	ST   -Y,R16
;	a -> Y+1
;	n -> R16
	LDS  R30,_crc
	LDS  R31,_crc+1
	LDD  R26,Y+1
	LDI  R27,0
	EOR  R30,R26
	EOR  R31,R27
	STS  _crc,R30
	STS  _crc+1,R31
;    1063 	for(n=0; n<8; n++)		//
	LDI  R16,LOW(0)
_0x283:
	CPI  R16,8
	BRSH _0x284
;    1064 		{			//
;    1065 		if(crc & 0x0001 == 1)	//
	LDS  R30,_crc
	ANDI R30,LOW(0x1)
	BREQ _0x285
;    1066 			{		//
;    1067 			crc = crc>>1;	//
	CALL SUBOPT_0x62
;    1068 			crc=crc&0x7fff;	//
	STS  _crc,R30
	STS  _crc+1,R31
;    1069 			crc = crc^0xA001;//
	LDS  R26,_crc
	LDS  R27,_crc+1
	LDI  R30,LOW(40961)
	LDI  R31,HIGH(40961)
	EOR  R30,R26
	EOR  R31,R27
	RJMP _0x2AB
;    1070 			}		//
;    1071 		else			//
_0x285:
;    1072 			{ 		//
;    1073 			crc = crc>>1;	//
	CALL SUBOPT_0x62
;    1074 			crc=crc&0x7fff;	//
_0x2AB:
	STS  _crc,R30
	STS  _crc+1,R31
;    1075 			} 		//
;    1076 		}			//
	SUBI R16,-1
	RJMP _0x283
_0x284:
;    1077 	}				//
	LDD  R16,Y+0
	ADIW R28,2
	RET
;    1078 //--------------------------------------//

_ftoa:
	SBIW R28,4
	ST   -Y,R17
	ST   -Y,R16
	__GETD2S 9
	CALL __CPD20
	BRGE _0x287
	__GETD1S 9
	CALL __ANEGF1
	__PUTD1S 9
	CALL SUBOPT_0x63
	LDI  R30,LOW(45)
	ST   X,R30
_0x287:
	LDD  R26,Y+8
	LDI  R30,LOW(5)
	CP   R30,R26
	BRSH _0x288
	STD  Y+8,R30
_0x288:
	LDI  R26,LOW(__fround_G2*2)
	LDI  R27,HIGH(__fround_G2*2)
	LDD  R30,Y+8
	CALL SUBOPT_0xE
	CALL __GETD1PF
	__GETD2S 9
	CALL __ADDF12
	__PUTD1S 9
	LDI  R16,LOW(0)
	__GETD1N 0x3F800000
	__PUTD1S 2
_0x289:
	__GETD1S 2
	__GETD2S 9
	CALL __CMPF12
	BRLO _0x28B
	__GETD2S 2
	__GETD1N 0x41200000
	CALL __MULF12
	__PUTD1S 2
	SUBI R16,-LOW(1)
	RJMP _0x289
_0x28B:
	CPI  R16,0
	BRNE _0x28C
	CALL SUBOPT_0x63
	LDI  R30,LOW(48)
	ST   X,R30
	RJMP _0x28D
_0x28C:
_0x28E:
	MOV  R30,R16
	SUBI R16,1
	CPI  R30,0
	BREQ _0x290
	__GETD2S 2
	__GETD1N 0x41200000
	CALL __DIVF21
	__GETD2N 0x3F000000
	CALL __ADDF12
	CALL __PUTPARD1
	CALL _floor
	__PUTD1S 2
	__GETD2S 9
	CALL __DIVF21
	CALL __CFD1
	MOV  R17,R30
	CALL SUBOPT_0x63
	CALL SUBOPT_0x64
	__GETD2S 2
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	CALL __MULF12
	__GETD2S 9
	CALL SUBOPT_0x65
	RJMP _0x28E
_0x290:
_0x28D:
	LDD  R30,Y+8
	CPI  R30,0
	BRNE _0x291
	CALL SUBOPT_0x66
	RJMP _0x298
_0x291:
	CALL SUBOPT_0x63
	LDI  R30,LOW(46)
	ST   X,R30
_0x292:
	LDD  R30,Y+8
	SUBI R30,LOW(1)
	STD  Y+8,R30
	SUBI R30,-LOW(1)
	BREQ _0x294
	__GETD2S 9
	__GETD1N 0x41200000
	CALL __MULF12
	__PUTD1S 9
	CALL __CFD1
	MOV  R17,R30
	CALL SUBOPT_0x63
	CALL SUBOPT_0x64
	__GETD2S 9
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	CALL SUBOPT_0x65
	RJMP _0x292
_0x294:
	CALL SUBOPT_0x66
_0x298:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,13
	RET
_cabs:
    ld   r30,y+
    cpi  r30,0
    brpl __cabs0
    neg  r30
__cabs0:
    ret
_getchar:
     sbis usr,rxc
     rjmp _getchar
     in   r26,udr
	RET
_putchar:
     sbis usr,udre
     rjmp _putchar
     ld   r26,y
     out  udr,r26
	ADIW R28,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x0:
	MOV  R30,R10
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	LD   R30,Z
	OUT  0xC,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x1:
	INC  R12
	LDI  R30,LOW(200)
	CP   R30,R12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x2:
	INC  R14
	LDI  R30,LOW(200)
	CP   R30,R14
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x3:
	MOV  R30,R16
	LDI  R31,0
	SUBI R30,LOW(-_led_byte)
	SBCI R31,HIGH(-_led_byte)
	LD   R30,Z
	OUT  0x1B,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES
SUBOPT_0x4:
	MOV  R30,R16
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	OUT  0x1B,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x5:
	LDD  R30,Y+4
	ST   -Y,R30
	JMP  _led_calk

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x6:
	LDD  R30,Y+3
	ST   -Y,R30
	JMP  _led_calk

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x7:
	LDD  R30,Y+2
	ST   -Y,R30
	JMP  _led_calk

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x8:
	LDD  R30,Y+1
	ST   -Y,R30
	JMP  _led_calk

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x9:
	MOV  R30,R16
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,2
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0xA:
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,11
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xB:
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(48)
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0xC:
	SUBI R30,LOW(48)
	STS  _ed,R30
	LDS  R30,_tis
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xD:
	LDI  R30,LOW(32)
	STS  _tis,R30
	LDS  R30,_sot
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0xE:
	LDI  R31,0
	CALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xF:
	LDI  R26,LOW(_MAX_MIN*2)
	LDI  R27,HIGH(_MAX_MIN*2)
	LDD  R30,Y+4
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x10:
	CALL __LSLW3
	ADD  R30,R26
	ADC  R31,R27
	ADIW R30,4
	CALL __GETD1PF
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x11:
	LDS  R26,_count_key1
	SUBI R26,-LOW(1)
	STS  _count_key1,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x12:
	LDS  R30,_sys_time
	LDS  R31,_sys_time+1
	LDS  R22,_sys_time+2
	LDS  R23,_sys_time+3
	CALL __SUBD12
	MOVW R26,R30
	MOVW R24,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x13:
	LDS  R30,_buf_end
	LDI  R26,LOW(_buf)
	LDI  R27,HIGH(_buf)
	LDI  R31,0
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES
SUBOPT_0x14:
	LDS  R30,_j
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x15:
	LDS  R30,_j
	LDI  R26,LOW(_buf)
	LDI  R27,HIGH(_buf)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x16:
	LDS  R30,_i
	LDI  R26,LOW(_buf)
	LDI  R27,HIGH(_buf)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x17:
	LDS  R30,_i
	SUBI R30,-LOW(1)
	STS  _i,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x18:
	LD   R30,X
	ST   -Y,R30
	JMP  _cabs

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x19:
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x1A:
	LDI  R30,LOW(_ee_point)
	LDI  R31,HIGH(_ee_point)
	STS  _ee_char,R30
	STS  _ee_char+1,R31
	LDS  R26,_ee_char
	LDS  R27,_ee_char+1
	CALL __EEPROMRDB
	STS  _point,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES
SUBOPT_0x1B:
	LDI  R30,LOW(13)
	ST   -Y,R30
	JMP  _read_reg

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x1C:
	__PUTD1S 20
	__GETD2S 20
	CALL __CPD20
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x1D:
	__GETD2S 20
	__GETD1N 0xC47A0000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x1E:
	__GETD2S 20
	__GETD1N 0xC2C80000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES
SUBOPT_0x1F:
	__GETD2S 20
	__GETD1N 0xC1200000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x20:
	__GETD2S 20
	__GETD1N 0x41200000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x21:
	__GETD2S 20
	__GETD1N 0x42C80000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES
SUBOPT_0x22:
	__GETD2S 20
	__GETD1N 0x447A0000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 161 TIMES
SUBOPT_0x23:
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x24:
	ST   -Y,R30
	CALL _read_reg
	__GETD2N 0x44FA0000
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x25:
	LDI  R30,LOW(32)
	STS  _ed,R30
	LDS  R30,_count_register
	CPI  R30,LOW(0x2)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x26:
	LDI  R30,LOW(211)
	STS  _tis,R30
	LDI  R30,LOW(95)
	STS  _sot,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x27:
	LDI  R30,LOW(3)
	STS  _tis,R30
	LDI  R30,LOW(95)
	STS  _sot,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x28:
	LDI  R30,LOW(112)
	STS  _tis,R30
	LDI  R30,LOW(95)
	STS  _sot,R30
	STS  _des,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x29:
	LDI  R30,LOW(99)
	STS  _tis,R30
	LDI  R30,LOW(95)
	STS  _sot,R30
	STS  _des,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES
SUBOPT_0x2A:
	LDS  R30,_tis
	ST   -Y,R30
	LDS  R30,_sot
	ST   -Y,R30
	LDS  R30,_des
	ST   -Y,R30
	LDS  R30,_ed
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x2B:
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x2C:
	LDS  R30,_count_register
	ST   -Y,R30
	CALL _read_reg
	__PUTD1S 20
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x2D:
	STS  _count_register,R30
	LDS  R30,_work_point
	STS  _point,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x2E:
	STS  _count_register,R30
	LDI  R30,LOW(1)
	STS  _point,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x2F:
	__GETD1S 20
	CALL __PUTPARD1
	JMP  _hex2dec

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES
SUBOPT_0x30:
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 21 TIMES
SUBOPT_0x31:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RJMP SUBOPT_0x23

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES
SUBOPT_0x32:
	LDI  R30,LOW(1)
	ST   -Y,R30
	RJMP SUBOPT_0x23

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES
SUBOPT_0x33:
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _set_led_on
	RJMP SUBOPT_0x23

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES
SUBOPT_0x34:
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _set_led_off

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x35:
	LDI  R30,LOW(18)
	ST   -Y,R30
	JMP  _read_reg

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x36:
	__GETD1S 8
	__GETD2S 16
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES
SUBOPT_0x37:
	LDI  R30,LOW(12)
	ST   -Y,R30
	JMP  _read_reg

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES
SUBOPT_0x38:
	CALL __SWAPD12
	CALL __SUBF12
	MOVW R26,R30
	MOVW R24,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES
SUBOPT_0x39:
	CALL __DIVF21
	__PUTD1S 4
	RJMP SUBOPT_0x37

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES
SUBOPT_0x3A:
	CALL __SWAPD12
	CALL __SUBF12
	__PUTD1S 0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x3B:
	__GETD2S 4
	__GETD1N 0x0
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x3C:
	ST   -Y,R30
	CALL _read_reg
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x42C80000
	CALL __DIVF21
	__GETD2N 0x3F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x3D:
	CALL __MULF12
	__GETD2S 12
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES
SUBOPT_0x3E:
	LDI  R30,LOW(5)
	ST   -Y,R30
	JMP  _read_reg

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x3F:
	LDI  R30,LOW(20)
	ST   -Y,R30
	CALL _read_reg
	CALL __CPD10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x40:
	LDI  R30,LOW(21)
	ST   -Y,R30
	CALL _read_reg
	CALL __CPD10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x41:
	LDS  R26,_sys_time
	LDS  R27,_sys_time+1
	LDS  R24,_sys_time+2
	LDS  R25,_sys_time+3
	CALL __CDF2
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x42:
	LDI  R30,LOW(6)
	ST   -Y,R30
	JMP  _read_reg

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x43:
	LDI  R30,LOW(8)
	ST   -Y,R30
	JMP  _read_reg

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x44:
	ST   -Y,R30
	CALL _read_reg
	__CPD1N 0x3F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x45:
	LDI  R30,LOW(11)
	ST   -Y,R30
	JMP  _read_reg

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x46:
	LDS  R30,_adc_value3
	LDS  R31,_adc_value3+1
	LDS  R22,_adc_value3+2
	LDS  R23,_adc_value3+3
	CALL __PUTPARD1
	CALL _hex2dec
	LDS  R26,_point
	CPI  R26,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES
SUBOPT_0x47:
	LDI  R30,LOW(0)
	ST   -Y,R30
	RJMP SUBOPT_0x30

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x48:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R30
	RJMP SUBOPT_0x23

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x49:
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	CALL __PUTPARD1
	JMP  _hex2dec

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x4A:
	LDI  R30,LOW(2)
	STS  _des,R30
	RJMP SUBOPT_0x47

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x4B:
	LDI  R30,LOW(1)
	STS  _des,R30
	RJMP SUBOPT_0x23

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x4C:
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R30
	RJMP SUBOPT_0x23

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x4D:
	STS  _ed,R30
	LDI  R30,LOW(1)
	STS  _point,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x4E:
	STS  _sot,R30
	LDI  R30,LOW(0)
	STS  _des,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x4F:
	STS  _tis,R30
	LDI  R30,LOW(45)
	STS  _sot,R30
	LDI  R30,LOW(2)
	STS  _des,R30
	LDI  R30,LOW(0)
	RJMP SUBOPT_0x4D

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x50:
	LDI  R30,LOW(0)
	STS  _tis,R30
	LDI  R30,LOW(45)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x51:
	LDS  R30,_sys_time
	LDS  R31,_sys_time+1
	LDS  R22,_sys_time+2
	LDS  R23,_sys_time+3
	STS  _start_time_mode,R30
	STS  _start_time_mode+1,R31
	STS  _start_time_mode+2,R22
	STS  _start_time_mode+3,R23
	LDS  R30,_count_key
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x52:
	LDS  R26,_count_register
	SUBI R26,-LOW(1)
	STS  _count_register,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x53:
	CALL __ADDF12
	__PUTD1S 20
	__GETD2S 20
	CALL __CPD02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x54:
	LDI  R26,LOW(_MAX_MIN*2)
	LDI  R27,HIGH(_MAX_MIN*2)
	LDS  R30,_count_register
	LDI  R31,0
	RJMP SUBOPT_0x10

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x55:
	LDI  R30,LOW(0)
	STS  _count_key,R30
	STS  _count_key1,R30
	STS  _count_key2,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x56:
	LDS  R26,_count_register
	SUBI R26,LOW(1)
	STS  _count_register,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x57:
	CALL __SWAPD12
	CALL __SUBF12
	__PUTD1S 20
	__GETD2S 20
	CALL __CPD02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x58:
	LDI  R26,LOW(_MAX_MIN*2)
	LDI  R27,HIGH(_MAX_MIN*2)
	LDS  R30,_count_register
	LDI  R31,0
	CALL __LSLW3
	ADD  R30,R26
	ADC  R31,R27
	CALL __GETD1PF
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x59:
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	JMP  _save_reg

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x5A:
	LDI  R30,LOW(32)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R30,LOW(97)
	ST   -Y,R30
	LDI  R30,LOW(239)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x5B:
	LDI  R30,LOW(32)
	ST   -Y,R30
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x5C:
	LDS  R30,_rx_buffer
	ST   -Y,R30
	JMP  _mov_buf_mod

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES
SUBOPT_0x5D:
	ST   -Y,R30
	CALL _mov_buf_mod
	JMP  _crc_end

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x5E:
	LSL  R30
	ST   -Y,R30
	JMP  _mov_buf_mod

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x5F:
	LDS  R26,_i
	LDI  R30,LOW(0)
	CP   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x60:
	LDS  R30,_i
	SUBI R30,LOW(1)
	STS  _i,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x61:
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	LD   R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x62:
	LDS  R30,_crc
	LDS  R31,_crc+1
	ASR  R31
	ROR  R30
	STS  _crc,R30
	STS  _crc+1,R31
	ANDI R31,HIGH(0x7FFF)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES
SUBOPT_0x63:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x64:
	MOV  R30,R17
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x65:
	CALL __SWAPD12
	CALL __SUBF12
	__PUTD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x66:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	RET

_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA0
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__ftrunc:
	ldd  r23,y+3
	ldd  r22,y+2
	ldd  r31,y+1
	ld   r30,y
	bst  r23,7
	lsl  r23
	sbrc r22,7
	sbr  r23,1
	mov  r25,r23
	subi r25,0x7e
	breq __ftrunc0
	brcs __ftrunc0
	cpi  r25,24
	brsh __ftrunc1
	clr  r26
	clr  r27
	clr  r24
__ftrunc2:
	sec
	ror  r24
	ror  r27
	ror  r26
	dec  r25
	brne __ftrunc2
	and  r30,r26
	and  r31,r27
	and  r22,r24
	rjmp __ftrunc1
__ftrunc0:
	clt
	clr  r23
	clr  r30
	clr  r31
	clr  r22
__ftrunc1:
	cbr  r22,0x80
	lsr  r23
	brcc __ftrunc3
	sbr  r22,0x80
__ftrunc3:
	bld  r23,7
	ld   r26,y+
	ld   r27,y+
	ld   r24,y+
	ld   r25,y+
	cp   r30,r26
	cpc  r31,r27
	cpc  r22,r24
	cpc  r23,r25
	bst  r25,7
	ret

_floor:
	rcall __ftrunc
	brne __floor1
__floor0:
	ret
__floor1:
	brtc __floor0
	ldi  r25,0xbf

__addfc:
	clr  r26
	clr  r27
	ldi  r24,0x80
	rjmp __addf12

__SUBD12:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	SBC  R23,R25
	RET

__ANEGD1:
	COM  R30
	COM  R31
	COM  R22
	COM  R23
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__LSLW3:
	LSL  R30
	ROL  R31
__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__ASRW8:
	MOV  R30,R31
	CLR  R31
	SBRC R30,7
	SER  R31
	RET

__CBD1:
	MOV  R31,R30
	ADD  R31,R31
	SBC  R31,R31
	MOV  R22,R31
	MOV  R23,R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__CBD2:
	MOV  R27,R26
	ADD  R27,R27
	SBC  R27,R27
	MOV  R24,R27
	MOV  R25,R27
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1PF:
	LPM  R0,Z+
	LPM  R1,Z+
	LPM  R22,Z+
	LPM  R23,Z
	MOVW R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__CDF2U:
	SET
	RJMP __CDF2U0
__CDF2:
	CLT
__CDF2U0:
	RCALL __SWAPD12
	RCALL __CDF1U0

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__EEPROMRDD:
	ADIW R26,2
	RCALL __EEPROMRDW
	MOV  R23,R31
	MOV  R22,R30
	SBIW R26,2

__EEPROMRDW:
	ADIW R26,1
	RCALL __EEPROMRDB
	MOV  R31,R30
	SBIW R26,1

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRD:
	RCALL __EEPROMWRW
	ADIW R26,2
	MOV  R0,R30
	MOV  R1,R31
	MOV  R30,R22
	MOV  R31,R23
	RCALL __EEPROMWRW
	MOV  R30,R0
	MOV  R31,R1
	SBIW R26,2
	RET

__EEPROMWRW:
	RCALL __EEPROMWRB
	ADIW R26,1
	PUSH R30
	MOV  R30,R31
	RCALL __EEPROMWRB
	POP  R30
	SBIW R26,1
	RET

__EEPROMWRB:
	SBIC EECR,EEWE
	RJMP __EEPROMWRB
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__ANEGF1:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __ANEGF10
	SUBI R23,0x80
__ANEGF10:
	RET

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	MOV  R21,R30
	MOV  R30,R26
	MOV  R26,R21
	MOV  R21,R31
	MOV  R31,R27
	MOV  R27,R21
	MOV  R21,R22
	MOV  R22,R24
	MOV  R24,R21
	MOV  R21,R23
	MOV  R23,R25
	MOV  R25,R21
	MOV  R21,R0
	MOV  R0,R1
	MOV  R1,R21
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF129
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,24
__MULF120:
	LSL  R19
	ROL  R20
	ROL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	BRCC __MULF121
	ADD  R19,R26
	ADC  R20,R27
	ADC  R21,R24
	ADC  R30,R1
	ADC  R31,R1
	ADC  R22,R1
__MULF121:
	DEC  R25
	BRNE __MULF120
	POP  R20
	POP  R19
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __REPACK
	POP  R21
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __MAXRES
	RJMP __MINRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	LSR  R22
	ROR  R31
	ROR  R30
	LSR  R24
	ROR  R27
	ROR  R26
	PUSH R20
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R25,24
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R1
	ROL  R20
	ROL  R21
	ROL  R26
	ROL  R27
	ROL  R24
	DEC  R25
	BRNE __DIVF212
	MOV  R30,R1
	MOV  R31,R20
	MOV  R22,R21
	LSR  R26
	ADC  R30,R25
	ADC  R31,R25
	ADC  R22,R25
	POP  R20
	TST  R22
	BRMI __DIVF215
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__CPD20:
	SBIW R26,0
	SBCI R24,0
	SBCI R25,0
	RET

__CPD02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	CPC  R0,R24
	CPC  R0,R25
	RET

__CPD12:
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
	RET

;END OF CODE MARKER
__END_OF_CODE:
