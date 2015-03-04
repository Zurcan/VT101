
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega16L
;Program type             : Application
;Clock frequency          : 8,000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 256 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : No
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega16L
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1119
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
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

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

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

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
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

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
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

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
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

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
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
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
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

	.MACRO __PUTBSR
	STD  Y+@1,R@0
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
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
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

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
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

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
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

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
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
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
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

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
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
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _CRCLow=R7
	.DEF _rx_counter=R6
	.DEF _mod_time=R9
	.DEF _mod_time_s=R8
	.DEF _rx_wr_index=R11
	.DEF _CRCHigh=R10
	.DEF _tx_buffer_begin=R13
	.DEF _tx_buffer_end=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  _timer2_comp_isr
	JMP  _timer2_ovf_isr
	JMP  _timer1_capt_isr
	JMP  _timer1_compa_isr
	JMP  _timer1_compb_isr
	JMP  _timer1_ovf_isr
	JMP  _timer0_ovf_isr
	JMP  0x00
	JMP  _usart_rx_isr
	JMP  0x00
	JMP  _usart_tx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer0_comp_isr
	JMP  0x00

_crctable:
	.DB  0x0,0x0,0xC0,0xC1,0xC1,0x81,0x1,0x40
	.DB  0xC3,0x1,0x3,0xC0,0x2,0x80,0xC2,0x41
	.DB  0xC6,0x1,0x6,0xC0,0x7,0x80,0xC7,0x41
	.DB  0x5,0x0,0xC5,0xC1,0xC4,0x81,0x4,0x40
	.DB  0xCC,0x1,0xC,0xC0,0xD,0x80,0xCD,0x41
	.DB  0xF,0x0,0xCF,0xC1,0xCE,0x81,0xE,0x40
	.DB  0xA,0x0,0xCA,0xC1,0xCB,0x81,0xB,0x40
	.DB  0xC9,0x1,0x9,0xC0,0x8,0x80,0xC8,0x41
	.DB  0xD8,0x1,0x18,0xC0,0x19,0x80,0xD9,0x41
	.DB  0x1B,0x0,0xDB,0xC1,0xDA,0x81,0x1A,0x40
	.DB  0x1E,0x0,0xDE,0xC1,0xDF,0x81,0x1F,0x40
	.DB  0xDD,0x1,0x1D,0xC0,0x1C,0x80,0xDC,0x41
	.DB  0x14,0x0,0xD4,0xC1,0xD5,0x81,0x15,0x40
	.DB  0xD7,0x1,0x17,0xC0,0x16,0x80,0xD6,0x41
	.DB  0xD2,0x1,0x12,0xC0,0x13,0x80,0xD3,0x41
	.DB  0x11,0x0,0xD1,0xC1,0xD0,0x81,0x10,0x40
	.DB  0xF0,0x1,0x30,0xC0,0x31,0x80,0xF1,0x41
	.DB  0x33,0x0,0xF3,0xC1,0xF2,0x81,0x32,0x40
	.DB  0x36,0x0,0xF6,0xC1,0xF7,0x81,0x37,0x40
	.DB  0xF5,0x1,0x35,0xC0,0x34,0x80,0xF4,0x41
	.DB  0x3C,0x0,0xFC,0xC1,0xFD,0x81,0x3D,0x40
	.DB  0xFF,0x1,0x3F,0xC0,0x3E,0x80,0xFE,0x41
	.DB  0xFA,0x1,0x3A,0xC0,0x3B,0x80,0xFB,0x41
	.DB  0x39,0x0,0xF9,0xC1,0xF8,0x81,0x38,0x40
	.DB  0x28,0x0,0xE8,0xC1,0xE9,0x81,0x29,0x40
	.DB  0xEB,0x1,0x2B,0xC0,0x2A,0x80,0xEA,0x41
	.DB  0xEE,0x1,0x2E,0xC0,0x2F,0x80,0xEF,0x41
	.DB  0x2D,0x0,0xED,0xC1,0xEC,0x81,0x2C,0x40
	.DB  0xE4,0x1,0x24,0xC0,0x25,0x80,0xE5,0x41
	.DB  0x27,0x0,0xE7,0xC1,0xE6,0x81,0x26,0x40
	.DB  0x22,0x0,0xE2,0xC1,0xE3,0x81,0x23,0x40
	.DB  0xE1,0x1,0x21,0xC0,0x20,0x80,0xE0,0x41
	.DB  0xA0,0x1,0x60,0xC0,0x61,0x80,0xA1,0x41
	.DB  0x63,0x0,0xA3,0xC1,0xA2,0x81,0x62,0x40
	.DB  0x66,0x0,0xA6,0xC1,0xA7,0x81,0x67,0x40
	.DB  0xA5,0x1,0x65,0xC0,0x64,0x80,0xA4,0x41
	.DB  0x6C,0x0,0xAC,0xC1,0xAD,0x81,0x6D,0x40
	.DB  0xAF,0x1,0x6F,0xC0,0x6E,0x80,0xAE,0x41
	.DB  0xAA,0x1,0x6A,0xC0,0x6B,0x80,0xAB,0x41
	.DB  0x69,0x0,0xA9,0xC1,0xA8,0x81,0x68,0x40
	.DB  0x78,0x0,0xB8,0xC1,0xB9,0x81,0x79,0x40
	.DB  0xBB,0x1,0x7B,0xC0,0x7A,0x80,0xBA,0x41
	.DB  0xBE,0x1,0x7E,0xC0,0x7F,0x80,0xBF,0x41
	.DB  0x7D,0x0,0xBD,0xC1,0xBC,0x81,0x7C,0x40
	.DB  0xB4,0x1,0x74,0xC0,0x75,0x80,0xB5,0x41
	.DB  0x77,0x0,0xB7,0xC1,0xB6,0x81,0x76,0x40
	.DB  0x72,0x0,0xB2,0xC1,0xB3,0x81,0x73,0x40
	.DB  0xB1,0x1,0x71,0xC0,0x70,0x80,0xB0,0x41
	.DB  0x50,0x0,0x90,0xC1,0x91,0x81,0x51,0x40
	.DB  0x93,0x1,0x53,0xC0,0x52,0x80,0x92,0x41
	.DB  0x96,0x1,0x56,0xC0,0x57,0x80,0x97,0x41
	.DB  0x55,0x0,0x95,0xC1,0x94,0x81,0x54,0x40
	.DB  0x9C,0x1,0x5C,0xC0,0x5D,0x80,0x9D,0x41
	.DB  0x5F,0x0,0x9F,0xC1,0x9E,0x81,0x5E,0x40
	.DB  0x5A,0x0,0x9A,0xC1,0x9B,0x81,0x5B,0x40
	.DB  0x99,0x1,0x59,0xC0,0x58,0x80,0x98,0x41
	.DB  0x88,0x1,0x48,0xC0,0x49,0x80,0x89,0x41
	.DB  0x4B,0x0,0x8B,0xC1,0x8A,0x81,0x4A,0x40
	.DB  0x4E,0x0,0x8E,0xC1,0x8F,0x81,0x4F,0x40
	.DB  0x8D,0x1,0x4D,0xC0,0x4C,0x80,0x8C,0x41
	.DB  0x44,0x0,0x84,0xC1,0x85,0x81,0x45,0x40
	.DB  0x87,0x1,0x47,0xC0,0x46,0x80,0x86,0x41
	.DB  0x82,0x1,0x42,0xC0,0x43,0x80,0x83,0x41
	.DB  0x41,0x0,0x81,0xC1,0x80,0x81,0x40,0x40

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000
	.DW  0x0000

_0x122:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0
_0x3EB:
	.DB  0xFF,0x0,0x0,0xFF
_0x2000060:
	.DB  0x1
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x04
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x04
	.DW  0x07
	.DW  _0x3EB*2

	.DW  0x01
	.DW  __seed_G100
	.DW  _0x2000060*2

_0xFFFFFFFF:
	.DW  0

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
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
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

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*****************************************************
;Project : ТКБ ВИБРО-Т
;Version : 3.0.00
;Date    : 02.07.2008
;Author  : Метелкин Евгений
;Comments: V1.24.5 Standard
;
;Program type        : Application
;Clock frequency     : 8,000000 MHz
;*****************************************************/
;#include <define.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;//#define cc
;//#define ca
;//--------------------------------------//
;//	USART Receiver buffer
;//--------------------------------------//
;
;#define RX_BUFFER_SIZE 64
;
;char rx_buffer[RX_BUFFER_SIZE];
;unsigned char CRCLow = 0xff,rx_counter,mod_time,mod_time_s,rx_wr_index,CRCHigh=0xff;
;bit rx_c,ti_en,rx_m;
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0000 0018         {

	.CSEG
_usart_rx_isr:
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0019 	char status,d;
; 0000 001A 	status=UCSRA;d=UDR;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	d -> R16
	IN   R17,11
	IN   R16,12
; 0000 001B 	if (((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)&&((ti_en==0)&&(rx_c==0)))
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x4
	LDI  R26,0
	SBRC R2,1
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0x5
	LDI  R26,0
	SBRC R2,0
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BREQ _0x6
_0x5:
	RJMP _0x4
_0x6:
	RJMP _0x7
_0x4:
	RJMP _0x3
_0x7:
; 0000 001C 		{if (mod_time==0){rx_m=1;rx_wr_index=0;}mod_time=mod_time_s;}
	TST  R9
	BRNE _0x8
	SET
	BLD  R2,2
	CLR  R11
_0x8:
	MOV  R9,R8
; 0000 001D 	rx_buffer[rx_wr_index]=d;
_0x3:
	MOV  R30,R11
	CALL SUBOPT_0x0
	ST   Z,R16
; 0000 001E 	if (++rx_wr_index >= RX_BUFFER_SIZE) rx_wr_index=0;
	INC  R11
	LDI  R30,LOW(64)
	CP   R11,R30
	BRLO _0x9
	CLR  R11
; 0000 001F 	if (++rx_counter >= RX_BUFFER_SIZE) rx_counter=0;
_0x9:
	INC  R6
	LDI  R30,LOW(64)
	CP   R6,R30
	BRLO _0xA
	CLR  R6
; 0000 0020 	}
_0xA:
	LD   R16,Y+
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R26,Y+
	RETI
;//--------------------------------------//
;// USART Transmitter buffer
;//--------------------------------------//
;#define TX_BUFFER_SIZE 64
;unsigned char tx_buffer_begin,tx_buffer_end,tx_buffer[TX_BUFFER_SIZE];
;interrupt [USART_TXC] void usart_tx_isr(void)
; 0000 0027         {
_usart_tx_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0028         if (ti_en==1)
	SBRS R2,1
	RJMP _0xB
; 0000 0029 	        {
; 0000 002A         	if (++tx_buffer_begin>=TX_BUFFER_SIZE) tx_buffer_begin=0;
	INC  R13
	LDI  R30,LOW(64)
	CP   R13,R30
	BRLO _0xC
	CLR  R13
; 0000 002B 	        if (tx_buffer_begin!=tx_buffer_end) {UDR=tx_buffer[tx_buffer_begin];}
_0xC:
	CP   R12,R13
	BREQ _0xD
	CALL SUBOPT_0x1
; 0000 002C         	else {ti_en=0;rx_c=0;rx_m=0;rx_tx=0;rx_counter=0;}
	RJMP _0xE
_0xD:
	CLT
	BLD  R2,1
	BLD  R2,0
	BLD  R2,2
	CBI  0x12,2
	CLR  R6
_0xE:
; 0000 002D 	        }
; 0000 002E         }
_0xB:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;//-------------------------------------------------------------------//
;bit buzer_en,buzer,pik_en,buzer_buzer_en;
;char pik_count;
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0033         {//прерывание для бузера
_timer0_ovf_isr:
	ST   -Y,R26
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 0034         TCNT0=TCNT0_reload;
	LDI  R30,LOW(111)
	OUT  0x32,R30
; 0000 0035         #asm("wdr");
	wdr
; 0000 0036         if ((buzer_en==1)&&(buzer_buzer_en==1)){if (buzer==1) {buzerp=1;buzer=0;}else {buzerp=0;buzer=1;}}
	SBRS R2,3
	RJMP _0x12
	SBRC R2,6
	RJMP _0x13
_0x12:
	RJMP _0x11
_0x13:
	SBRS R2,4
	RJMP _0x14
	SBI  0x12,5
	CLT
	RJMP _0x38F
_0x14:
	CBI  0x12,5
	SET
_0x38F:
	BLD  R2,4
; 0000 0037         else if (pik_en==1){if (++pik_count>200) {pik_en=0;pik_count=0;}if (buzer==1) {buzerp=1;buzer=0;}else {buzerp=0;buzer=1;}}
	RJMP _0x1A
_0x11:
	SBRS R2,5
	RJMP _0x1B
	CALL SUBOPT_0x2
	BRLO _0x1C
	CLT
	BLD  R2,5
	LDI  R30,LOW(0)
	STS  _pik_count,R30
_0x1C:
	SBRS R2,4
	RJMP _0x1D
	SBI  0x12,5
	CLT
	RJMP _0x390
_0x1D:
	CBI  0x12,5
	SET
_0x390:
	BLD  R2,4
; 0000 0038         else buzerp=0;
	RJMP _0x23
_0x1B:
	CBI  0x12,5
; 0000 0039         if (pik_en==1){if (++pik_count>200) {pik_en=0;pik_count=0;}}
_0x23:
_0x1A:
	SBRS R2,5
	RJMP _0x26
	CALL SUBOPT_0x2
	BRLO _0x27
	CLT
	BLD  R2,5
	LDI  R30,LOW(0)
	STS  _pik_count,R30
_0x27:
; 0000 003A         }
_0x26:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	LD   R26,Y+
	RETI
;char led_byte[5][2];
;interrupt [TIM0_COMP] void timer0_comp_isr(void){}
; 0000 003C interrupt [20] void timer0_comp_isr(void){}
_timer0_comp_isr:
	RETI
;interrupt [TIM1_OVF] void timer1_ovf_isr(void){TCNT1H=0x05;TCNT1L=0x01;}
; 0000 003D interrupt [9] void timer1_ovf_isr(void){TCNT1H=0x05;TCNT1L=0x01;}
_timer1_ovf_isr:
	ST   -Y,R30
	LDI  R30,LOW(5)
	OUT  0x2D,R30
	LDI  R30,LOW(1)
	OUT  0x2C,R30
	LD   R30,Y+
	RETI
;interrupt [TIM1_CAPT] void timer1_capt_isr(void){}
; 0000 003E interrupt [6] void timer1_capt_isr(void){}
_timer1_capt_isr:
	RETI
;interrupt [TIM1_COMPA] void timer1_compa_isr(void){}
; 0000 003F interrupt [7] void timer1_compa_isr(void){}
_timer1_compa_isr:
	RETI
;interrupt [TIM1_COMPB] void timer1_compb_isr(void){}
; 0000 0040 interrupt [8] void timer1_compb_isr(void){}
_timer1_compb_isr:
	RETI
;//-------------------------------------------------------------------//
;// прерывание каждые 500 мкс
;//-------------------------------------------------------------------//
;long sys_time,whait_time;
;bit key_mode,key_plus,key_mines,key_enter,key_mode_press,key_plus_press,key_mines_press,key_enter_press,key_mode_press_switch;
;bit key_plus_press_switch,key_minus_press_switch,key_enter_press_switch;
;char count_led,count_led1,drebezg;
;bit avaria,alarm1,alarm2,alarm_alarm1,alarm_alarm2;
;int count_blink,crc;
;//-------------------------------------------------------------------//
;interrupt [TIM2_OVF] void timer2_ovf_isr(void)
; 0000 004C         {//прерывание 500мкс
_timer2_ovf_isr:
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 004D         char n;
; 0000 004E         TCNT2=TCNT2_reload;
	ST   -Y,R17
;	n -> R17
	LDI  R30,LOW(94)
	OUT  0x24,R30
; 0000 004F         #asm("sei");
	sei
; 0000 0050         sys_time=sys_time+1;
	CALL SUBOPT_0x3
	__ADDD1N 1
	STS  _sys_time,R30
	STS  _sys_time+1,R31
	STS  _sys_time+2,R22
	STS  _sys_time+3,R23
; 0000 0051 
; 0000 0052 	if (mod_time==0){if (rx_m==1) rx_c=1;}
	TST  R9
	BRNE _0x28
	SBRS R2,2
	RJMP _0x29
	SET
	BLD  R2,0
_0x29:
; 0000 0053 	else 	mod_time--;
	RJMP _0x2A
_0x28:
	DEC  R9
; 0000 0054 
; 0000 0055 
; 0000 0056         if (key_1==0){key_mode=1;if ((key_mode_press==0)&&(pik_en==0)){key_mode_press_switch=1;pik_en=1;drebezg=0;}key_mode_press=1;}
_0x2A:
	SBIC 0x13,0
	RJMP _0x2B
	SET
	BLD  R2,7
	LDI  R26,0
	SBRC R3,3
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0x2D
	CALL SUBOPT_0x4
	BREQ _0x2E
_0x2D:
	RJMP _0x2C
_0x2E:
	SET
	BLD  R3,7
	CALL SUBOPT_0x5
_0x2C:
	SET
	RJMP _0x391
; 0000 0057         else if ((key_2==1)&&(key_3==1)&&(key_4==1)&&(++drebezg>DREBEZG_TIME)){key_mode=0;key_mode_press=0;}
_0x2B:
	SBIS 0x13,1
	RJMP _0x31
	SBIS 0x10,6
	RJMP _0x31
	SBIS 0x10,7
	RJMP _0x31
	CALL SUBOPT_0x6
	BRSH _0x32
_0x31:
	RJMP _0x30
_0x32:
	CLT
	BLD  R2,7
_0x391:
	BLD  R3,3
; 0000 0058 
; 0000 0059         if (key_2==0){key_plus=1;if ((key_plus_press==0)&&(pik_en==0)){key_plus_press_switch=1;pik_en=1;drebezg=0;}key_plus_press=1;}
_0x30:
	SBIC 0x13,1
	RJMP _0x33
	SET
	BLD  R3,0
	CALL SUBOPT_0x7
	BRNE _0x35
	CALL SUBOPT_0x4
	BREQ _0x36
_0x35:
	RJMP _0x34
_0x36:
	SET
	BLD  R4,0
	CALL SUBOPT_0x5
_0x34:
	SET
	RJMP _0x392
; 0000 005A         else if ((key_1==1)&&(key_3==1)&&(key_4==1)&&(++drebezg>DREBEZG_TIME)){key_plus=0;key_plus_press=0;}
_0x33:
	SBIS 0x13,0
	RJMP _0x39
	SBIS 0x10,6
	RJMP _0x39
	SBIS 0x10,7
	RJMP _0x39
	CALL SUBOPT_0x6
	BRSH _0x3A
_0x39:
	RJMP _0x38
_0x3A:
	CLT
	BLD  R3,0
_0x392:
	BLD  R3,4
; 0000 005B 
; 0000 005C         if (key_3==0){key_mines=1;if ((key_mines_press==0)&&(pik_en==0)){key_minus_press_switch=1;pik_en=1;drebezg=0;}key_mines_press=1;}
_0x38:
	SBIC 0x10,6
	RJMP _0x3B
	SET
	BLD  R3,1
	CALL SUBOPT_0x8
	BRNE _0x3D
	CALL SUBOPT_0x4
	BREQ _0x3E
_0x3D:
	RJMP _0x3C
_0x3E:
	SET
	BLD  R4,1
	CALL SUBOPT_0x5
_0x3C:
	SET
	RJMP _0x393
; 0000 005D         else if ((key_2==1)&&(key_1==1)&&(key_4==1)&&(++drebezg>DREBEZG_TIME)){key_mines=0;key_mines_press=0;}
_0x3B:
	SBIS 0x13,1
	RJMP _0x41
	SBIS 0x13,0
	RJMP _0x41
	SBIS 0x10,7
	RJMP _0x41
	CALL SUBOPT_0x6
	BRSH _0x42
_0x41:
	RJMP _0x40
_0x42:
	CLT
	BLD  R3,1
_0x393:
	BLD  R3,5
; 0000 005E 
; 0000 005F         if (key_4==0){key_enter=1;if (key_enter_press==0){key_enter_press_switch=1;pik_en=1;whait_time=sys_time;}key_enter_press=1;alarm_alarm1=0;alarm_alarm2=0;}
_0x40:
	SBIC 0x10,7
	RJMP _0x43
	SET
	BLD  R3,2
	SBRC R3,6
	RJMP _0x44
	BLD  R4,2
	BLD  R2,5
	CALL SUBOPT_0x3
	STS  _whait_time,R30
	STS  _whait_time+1,R31
	STS  _whait_time+2,R22
	STS  _whait_time+3,R23
_0x44:
	SET
	BLD  R3,6
	CLT
	BLD  R4,6
	BLD  R4,7
; 0000 0060         else {key_enter=0;key_enter_press=0;}
	RJMP _0x45
_0x43:
	CLT
	BLD  R3,2
	BLD  R3,6
_0x45:
; 0000 0061 
; 0000 0062         if (++count_blink>2000) count_blink=0;
	LDI  R26,LOW(_count_blink)
	LDI  R27,HIGH(_count_blink)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	CPI  R30,LOW(0x7D1)
	LDI  R26,HIGH(0x7D1)
	CPC  R31,R26
	BRLT _0x46
	LDI  R30,LOW(0)
	STS  _count_blink,R30
	STS  _count_blink+1,R30
; 0000 0063         if (count_blink<300) {n=1;buzer_en=0;if ((alarm_alarm1==1)||(alarm_alarm2==1))buzer_en=1;else buzer_en=0;}
_0x46:
	LDS  R26,_count_blink
	LDS  R27,_count_blink+1
	CPI  R26,LOW(0x12C)
	LDI  R30,HIGH(0x12C)
	CPC  R27,R30
	BRGE _0x47
	LDI  R17,LOW(1)
	CLT
	BLD  R2,3
	SBRC R4,6
	RJMP _0x49
	SBRS R4,7
	RJMP _0x48
_0x49:
	SET
	RJMP _0x394
_0x48:
	CLT
_0x394:
	BLD  R2,3
; 0000 0064         else {n=0;if ((alarm1==1)||(alarm2==1))buzer_en=1;}
	RJMP _0x4C
_0x47:
	LDI  R17,LOW(0)
	SBRC R4,4
	RJMP _0x4E
	SBRS R4,5
	RJMP _0x4D
_0x4E:
	SET
	BLD  R2,3
_0x4D:
_0x4C:
; 0000 0065 //#ifdef ca
; 0000 0066          katode=0xFF;anode=anode&0b00000111;
	LDI  R30,LOW(255)
	OUT  0x1B,R30
	IN   R30,0x15
	ANDI R30,LOW(0x7)
	OUT  0x15,R30
; 0000 0067 /*#else
; 0000 0068         katode=0x00;anode=anode|0b01111000;anode5=0;
; 0000 0069 #endif*/
; 0000 006A         switch (count_led)
	LDS  R30,_count_led
; 0000 006B                 {
; 0000 006C //#ifdef ca
; 0000 006D                  case 4: count_led=0;anode1=1;DDRC.3=1;katode=led_byte[0][n];break;
	CPI  R30,LOW(0x4)
	BRNE _0x53
	LDI  R30,LOW(0)
	STS  _count_led,R30
	SBI  0x15,3
	SBI  0x14,3
	CALL SUBOPT_0x9
	SUBI R30,LOW(-_led_byte)
	SBCI R31,HIGH(-_led_byte)
	LD   R30,Z
	RJMP _0x395
; 0000 006E                  case 3: count_led=4;anode2=1;DDRC.4=1;katode=led_byte[1][n];break;
_0x53:
	CPI  R30,LOW(0x3)
	BRNE _0x58
	LDI  R30,LOW(4)
	STS  _count_led,R30
	SBI  0x15,4
	SBI  0x14,4
	__POINTW2MN _led_byte,2
	RJMP _0x396
; 0000 006F                  case 2: count_led=3;anode3=1;DDRC.5=1;katode=led_byte[2][n];break;
_0x58:
	CPI  R30,LOW(0x2)
	BRNE _0x5D
	LDI  R30,LOW(3)
	STS  _count_led,R30
	SBI  0x15,5
	SBI  0x14,5
	__POINTW2MN _led_byte,4
	RJMP _0x396
; 0000 0070                  case 1: count_led=2;anode4=1;DDRC.6=1;katode=led_byte[3][n];break;
_0x5D:
	CPI  R30,LOW(0x1)
	BRNE _0x67
	LDI  R30,LOW(2)
	STS  _count_led,R30
	SBI  0x15,6
	SBI  0x14,6
	__POINTW2MN _led_byte,6
	RJMP _0x396
; 0000 0071                  default:count_led=1;anode5=1;DDRC.7=1;katode=led_byte[4][n];break;
_0x67:
	LDI  R30,LOW(1)
	STS  _count_led,R30
	SBI  0x15,7
	SBI  0x14,7
	__POINTW2MN _led_byte,8
_0x396:
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R30,X
_0x395:
	OUT  0x1B,R30
; 0000 0072 /*#else
; 0000 0073 
; 0000 0074                 case 4: count_led=0;katode=led_byte[0,n];anode1=0;DDRC.3=1;break;
; 0000 0075                 case 3: count_led=4;katode=led_byte[1,n];anode2=0;DDRC.4=1;break;
; 0000 0076                 case 2: count_led=3;katode=led_byte[2,n];anode3=0;DDRC.5=1;break;
; 0000 0077                 case 1: count_led=2;katode=led_byte[3,n];anode4=0;DDRC.6=1;break;
; 0000 0078                 default:
; 0000 0079                         {count_led=1;
; 0000 007A                         if (++count_led1>5)
; 0000 007B                                 {count_led1=0;katode=led_byte[4,n];anode5=1;DDRC.7=1;}*/
; 0000 007C                     //    break;
; 0000 007D                         }
; 0000 007E 
; 0000 007F 
; 0000 0080 //#endif
; 0000 0081  //               }
; 0000 0082         }
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R23,Y+
	LD   R22,Y+
	RETI
;//-------------------------------------------------------------------//
;interrupt [TIM2_COMP] void timer2_comp_isr(void){}
; 0000 0084 interrupt [4] void timer2_comp_isr(void){}
_timer2_comp_isr:
	RETI
;#include <spi.h>
;
;eeprom float reg[4][27]=
; {{0, 4.6, 7.1,   0,   5,   0,   1,   0,   1,   0,   0,   0,0.00,20.0,   2,   2,   0,  10,   2,   5,   0,   0,   1,   0,1.00, 2.15,    1},
;  {0, 4.6, 7.1,   0,   5,   0,   1,   0,   1,   0,   0,   0,0.00,20.0,   2,   2,   0,  10,   2,   5,   0,   0,   1,   0,1.00, 2.15,    1},
;  {0,999,999,  30,  30,   1,   1,  10,   2,   1,   1,   2,999,999,  10,  10,   5,  30,   4,  10,   1,   1, 1.8,   1,1.00,12.99,  247},
;  {0,-999,-999,   0,   0,   0,   0,   0,   1,   0,   0,   0,-999,-999,   0,   0,   0,   0,   0,   1,   0,   0, 0.2,   0,1.00,1.00,    0}};
;  //|уст1 |уст2 |зад1|зад2|маск|звук  |гист|звук |рел1 |рел2 |едиз | нпи | впи  |дсну|дсву  |врус |вбпв|диап |ввим |зал1 |зал2 | кал |заву  |верс|дата|адрес|
;  // Y_01,Y_02,Z_01,Z_02,P___,C___,A_01,A_02,A_03,A_04,A_05,A_06,A_07,A_08,A_09,A_10,A_11,A_12,A_13,A_14,A_15,A_16,A_17,A_18,A_19,Adres;
;
;eeprom char ee_point=3;
;eeprom int crceep = 0x0000;  //   расчётное crc     5я строка до 1ff, 2 байта начиная со 2го байта в строке (после  1001B000)
;eeprom const int crcstatic = 0x70bb;//0x45cb;
;eeprom char crc1digit = 3, crc2digit = 'c', crc3digit =2 , crc4digit = 1;
;//eeprom char smth[9];
;
;//eeprom const
;char mode,point,work_point,save_point;
;#include <function_led.h>
_led_calk:
;	a -> Y+0
	LD   R30,Y
	CPI  R30,0
	BRNE _0x6F
	LDI  R30,LOW(64)
	RJMP _0x397
_0x6F:
	CPI  R30,LOW(0x1)
	BRNE _0x70
	LDI  R30,LOW(121)
	RJMP _0x397
_0x70:
	CPI  R30,LOW(0x2)
	BRNE _0x71
	LDI  R30,LOW(36)
	RJMP _0x397
_0x71:
	CPI  R30,LOW(0x3)
	BRNE _0x72
	LDI  R30,LOW(48)
	RJMP _0x397
_0x72:
	CPI  R30,LOW(0x4)
	BRNE _0x73
	LDI  R30,LOW(25)
	RJMP _0x397
_0x73:
	CPI  R30,LOW(0x5)
	BRNE _0x74
	LDI  R30,LOW(18)
	RJMP _0x397
_0x74:
	CPI  R30,LOW(0x6)
	BRNE _0x75
	LDI  R30,LOW(2)
	RJMP _0x397
_0x75:
	CPI  R30,LOW(0x7)
	BRNE _0x76
	LDI  R30,LOW(120)
	RJMP _0x397
_0x76:
	CPI  R30,LOW(0x8)
	BRNE _0x77
	LDI  R30,LOW(0)
	RJMP _0x397
_0x77:
	CPI  R30,LOW(0x9)
	BRNE _0x78
	LDI  R30,LOW(16)
	RJMP _0x397
_0x78:
	CPI  R30,LOW(0x20)
	BRNE _0x79
	LDI  R30,LOW(127)
	RJMP _0x397
_0x79:
	CPI  R30,LOW(0x5F)
	BRNE _0x7A
	LDI  R30,LOW(119)
	RJMP _0x397
_0x7A:
	CPI  R30,LOW(0xD3)
	BRNE _0x7B
	LDI  R30,LOW(17)
	RJMP _0x397
_0x7B:
	CPI  R30,LOW(0x61)
	BRNE _0x7C
	LDI  R30,LOW(8)
	RJMP _0x397
_0x7C:
	CPI  R30,LOW(0xEF)
	BRNE _0x7D
	LDI  R30,LOW(72)
	RJMP _0x397
_0x7D:
	CPI  R30,LOW(0x63)
	BRNE _0x7E
	LDI  R30,LOW(70)
	RJMP _0x397
_0x7E:
	CPI  R30,LOW(0x70)
	BRNE _0x7F
	LDI  R30,LOW(12)
	RJMP _0x397
_0x7F:
	CPI  R30,LOW(0x2D)
	BRNE _0x80
	LDI  R30,LOW(63)
	RJMP _0x397
_0x80:
	CPI  R30,LOW(0x72)
	BRNE _0x81
	LDI  R30,LOW(47)
	RJMP _0x397
_0x81:
	CPI  R30,LOW(0x74)
	BRNE _0x82
	LDI  R30,LOW(7)
	RJMP _0x397
_0x82:
	CPI  R30,LOW(0x62)
	BRNE _0x83
	LDI  R30,LOW(3)
	RJMP _0x397
_0x83:
	CPI  R30,LOW(0x64)
	BRNE _0x84
	LDI  R30,LOW(33)
	RJMP _0x397
_0x84:
	CPI  R30,LOW(0x65)
	BRNE _0x85
	LDI  R30,LOW(6)
	RJMP _0x397
_0x85:
	CPI  R30,LOW(0x66)
	BRNE _0x86
	LDI  R30,LOW(14)
	RJMP _0x397
_0x86:
	CPI  R30,LOW(0x67)
	BRNE _0x87
	LDI  R30,LOW(66)
	RJMP _0x397
_0x87:
	CPI  R30,LOW(0x68)
	BRNE _0x88
	LDI  R30,LOW(101)
	RJMP _0x397
_0x88:
	CPI  R30,LOW(0x6B)
	BRNE _0x89
	LDI  R30,LOW(10)
	RJMP _0x397
_0x89:
	CPI  R30,LOW(0x69)
	BRNE _0x8A
	LDI  R30,LOW(79)
	RJMP _0x397
_0x8A:
	CPI  R30,LOW(0x6C)
	BRNE _0x8B
	LDI  R30,LOW(71)
	RJMP _0x397
_0x8B:
	CPI  R30,LOW(0x76)
	BRNE _0x8D
	LDI  R30,LOW(65)
	RJMP _0x397
_0x8D:
	LDI  R30,LOW(114)
_0x397:
	ST   Y,R30
	RJMP _0x20A0006
_set_led_on:
	ST   -Y,R17
;	a -> Y+8
;	b -> Y+7
;	c -> Y+6
;	d -> Y+5
;	p1 -> Y+4
;	p2 -> Y+3
;	p3 -> Y+2
;	p4 -> Y+1
;	i -> R17
	SBRS R4,3
	RJMP _0x8E
	LDI  R30,LOW(0)
	STD  Y+5,R30
_0x8E:
	LDD  R30,Y+4
	CPI  R30,0
	BRNE _0x8F
	LDS  R17,_led_byte
	ORI  R17,LOW(128)
	RJMP _0x398
_0x8F:
	LDS  R17,_led_byte
	ANDI R17,LOW(127)
_0x398:
	STS  _led_byte,R17
	LDD  R30,Y+3
	CPI  R30,0
	BRNE _0x91
	__GETBRMN 17,_led_byte,2
	ORI  R17,LOW(128)
	RJMP _0x399
_0x91:
	__GETBRMN 17,_led_byte,2
	ANDI R17,LOW(127)
_0x399:
	__PUTBMRN _led_byte,2,17
	LDD  R30,Y+2
	CPI  R30,0
	BRNE _0x93
	__GETBRMN 17,_led_byte,4
	ORI  R17,LOW(128)
	RJMP _0x39A
_0x93:
	__GETBRMN 17,_led_byte,4
	ANDI R17,LOW(127)
_0x39A:
	__PUTBMRN _led_byte,4,17
	LDD  R30,Y+1
	CPI  R30,0
	BRNE _0x95
	__GETBRMN 17,_led_byte,6
	ORI  R17,LOW(128)
	RJMP _0x39B
_0x95:
	__GETBRMN 17,_led_byte,6
	ANDI R17,LOW(127)
_0x39B:
	__PUTBMRN _led_byte,6,17
	LDD  R26,Y+8
	CPI  R26,LOW(0x0)
	BRNE _0x98
	LDI  R26,0
	SBRC R4,3
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BREQ _0x99
_0x98:
	RJMP _0x97
_0x99:
	__GETB1MN _led_byte,8
	ORI  R30,1
	RJMP _0x39C
_0x97:
	__GETB1MN _led_byte,8
	ANDI R30,0xFE
_0x39C:
	__PUTB1MN _led_byte,8
	LDD  R26,Y+7
	CPI  R26,LOW(0x0)
	BRNE _0x9C
	LDI  R26,0
	SBRC R4,5
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BREQ _0x9D
_0x9C:
	RJMP _0x9B
_0x9D:
	__GETB1MN _led_byte,8
	ORI  R30,2
	RJMP _0x39D
_0x9B:
	__GETB1MN _led_byte,8
	ANDI R30,0xFD
_0x39D:
	__PUTB1MN _led_byte,8
	LDD  R26,Y+6
	CPI  R26,LOW(0x0)
	BRNE _0xA0
	LDI  R26,0
	SBRC R4,4
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BREQ _0xA1
_0xA0:
	RJMP _0x9F
_0xA1:
	__GETB1MN _led_byte,8
	ORI  R30,4
	RJMP _0x39E
_0x9F:
	__GETB1MN _led_byte,8
	ANDI R30,0xFB
_0x39E:
	__PUTB1MN _led_byte,8
	LDD  R30,Y+5
	CPI  R30,0
	BRNE _0xA3
	__GETB1MN _led_byte,8
	ORI  R30,8
	RJMP _0x39F
_0xA3:
	__GETB1MN _led_byte,8
	ANDI R30,0XF7
_0x39F:
	__PUTB1MN _led_byte,8
	RJMP _0x20A0008
_set_led_off:
	ST   -Y,R17
;	a -> Y+8
;	b -> Y+7
;	c -> Y+6
;	d -> Y+5
;	p1 -> Y+4
;	p2 -> Y+3
;	p3 -> Y+2
;	p4 -> Y+1
;	i -> R17
	SBRS R4,3
	RJMP _0xA5
	LDI  R30,LOW(0)
	STD  Y+5,R30
_0xA5:
	LDD  R30,Y+4
	CPI  R30,0
	BRNE _0xA6
	__GETBRMN 17,_led_byte,1
	ORI  R17,LOW(128)
	RJMP _0x3A0
_0xA6:
	__GETBRMN 17,_led_byte,1
	ANDI R17,LOW(127)
_0x3A0:
	__PUTBMRN _led_byte,1,17
	LDD  R30,Y+3
	CPI  R30,0
	BRNE _0xA8
	__GETBRMN 17,_led_byte,3
	ORI  R17,LOW(128)
	RJMP _0x3A1
_0xA8:
	__GETBRMN 17,_led_byte,3
	ANDI R17,LOW(127)
_0x3A1:
	__PUTBMRN _led_byte,3,17
	LDD  R30,Y+2
	CPI  R30,0
	BRNE _0xAA
	__GETBRMN 17,_led_byte,5
	ORI  R17,LOW(128)
	RJMP _0x3A2
_0xAA:
	__GETBRMN 17,_led_byte,5
	ANDI R17,LOW(127)
_0x3A2:
	__PUTBMRN _led_byte,5,17
	LDD  R30,Y+1
	CPI  R30,0
	BRNE _0xAC
	__GETBRMN 17,_led_byte,7
	ORI  R17,LOW(128)
	RJMP _0x3A3
_0xAC:
	__GETBRMN 17,_led_byte,7
	ANDI R17,LOW(127)
_0x3A3:
	__PUTBMRN _led_byte,7,17
	LDD  R26,Y+8
	CPI  R26,LOW(0x0)
	BRNE _0xAF
	LDI  R26,0
	SBRC R4,3
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BREQ _0xB0
_0xAF:
	RJMP _0xAE
_0xB0:
	__GETB1MN _led_byte,9
	ORI  R30,1
	RJMP _0x3A4
_0xAE:
	__GETB1MN _led_byte,9
	ANDI R30,0xFE
_0x3A4:
	__PUTB1MN _led_byte,9
	LDD  R26,Y+7
	CPI  R26,LOW(0x0)
	BRNE _0xB3
	CALL SUBOPT_0xA
	BREQ _0xB4
_0xB3:
	RJMP _0xB2
_0xB4:
	__GETB1MN _led_byte,9
	ORI  R30,2
	RJMP _0x3A5
_0xB2:
	__GETB1MN _led_byte,9
	ANDI R30,0xFD
_0x3A5:
	__PUTB1MN _led_byte,9
	LDD  R26,Y+6
	CPI  R26,LOW(0x0)
	BRNE _0xB7
	CALL SUBOPT_0xB
	BREQ _0xB8
_0xB7:
	RJMP _0xB6
_0xB8:
	__GETB1MN _led_byte,9
	ORI  R30,4
	RJMP _0x3A6
_0xB6:
	__GETB1MN _led_byte,9
	ANDI R30,0xFB
_0x3A6:
	__PUTB1MN _led_byte,9
	LDD  R30,Y+5
	CPI  R30,0
	BRNE _0xBA
	__GETB1MN _led_byte,9
	ORI  R30,8
	RJMP _0x3A7
_0xBA:
	__GETB1MN _led_byte,9
	ANDI R30,0XF7
_0x3A7:
	__PUTB1MN _led_byte,9
_0x20A0008:
	LDD  R17,Y+0
	ADIW R28,9
	RET
_set_digit_on:
	ST   -Y,R17
;	a -> Y+4
;	b -> Y+3
;	c -> Y+2
;	d -> Y+1
;	i -> R17
	LDS  R17,_led_byte
	CALL SUBOPT_0xC
	STS  _led_byte,R17
	__GETBRMN 17,_led_byte,2
	CALL SUBOPT_0xD
	__PUTBMRN _led_byte,2,17
	__GETBRMN 17,_led_byte,4
	CALL SUBOPT_0xE
	__PUTBMRN _led_byte,4,17
	__GETBRMN 17,_led_byte,6
	CALL SUBOPT_0xF
	__PUTBMRN _led_byte,6,17
	RJMP _0x20A0007
_set_digit_off:
	ST   -Y,R17
;	a -> Y+4
;	b -> Y+3
;	c -> Y+2
;	d -> Y+1
;	i -> R17
	__GETBRMN 17,_led_byte,1
	CALL SUBOPT_0xC
	__PUTBMRN _led_byte,1,17
	__GETBRMN 17,_led_byte,3
	CALL SUBOPT_0xD
	__PUTBMRN _led_byte,3,17
	__GETBRMN 17,_led_byte,5
	CALL SUBOPT_0xE
	__PUTBMRN _led_byte,5,17
	__GETBRMN 17,_led_byte,7
	CALL SUBOPT_0xF
	__PUTBMRN _led_byte,7,17
_0x20A0007:
	LDD  R17,Y+0
	ADIW R28,5
	RET
;
;char ed,des,sot,tis,count_filter,count_filter1,i,count_key,count_key1;
;long filter_value;
;unsigned int adc_buf;
;flash  int crctable[256]= {
;        0x0000, 0xC1C0, 0x81C1, 0x4001, 0x01C3, 0xC003, 0x8002, 0x41C2, 0x01C6, 0xC006,
;        0x8007, 0x41C7, 0x0005, 0xC1C5, 0x81C4, 0x4004, 0x01CC, 0xC00C, 0x800D, 0x41CD,
;        0x000F, 0xC1CF, 0x81CE, 0x400E, 0x000A, 0xC1CA, 0x81CB, 0x400B, 0x01C9, 0xC009,
;        0x8008, 0x41C8, 0x01D8, 0xC018, 0x8019, 0x41D9, 0x001B, 0xC1DB, 0x81DA, 0x401A,
;        0x001E, 0xC1DE, 0x81DF, 0x401F, 0x01DD, 0xC01D, 0x801C, 0x41DC, 0x0014, 0xC1D4,
;        0x81D5, 0x4015, 0x01D7, 0xC017, 0x8016, 0x41D6, 0x01D2, 0xC012, 0x8013, 0x41D3,
;        0x0011, 0xC1D1, 0x81D0, 0x4010, 0x01F0, 0xC030, 0x8031, 0x41F1, 0x0033, 0xC1F3,
;        0x81F2, 0x4032, 0x0036, 0xC1F6, 0x81F7, 0x4037, 0x01F5, 0xC035, 0x8034, 0x41F4,
;        0x003C, 0xC1FC, 0x81FD, 0x403D, 0x01FF, 0xC03F, 0x803E, 0x41FE, 0x01FA, 0xC03A,
;        0x803B, 0x41FB, 0x0039, 0xC1F9, 0x81F8, 0x4038, 0x0028, 0xC1E8, 0x81E9, 0x4029,
;        0x01EB, 0xC02B, 0x802A, 0x41EA, 0x01EE, 0xC02E, 0x802F, 0x41EF, 0x002D, 0xC1ED,
;        0x81EC, 0x402C, 0x01E4, 0xC024, 0x8025, 0x41E5, 0x0027, 0xC1E7, 0x81E6, 0x4026,
;        0x0022, 0xC1E2, 0x81E3, 0x4023, 0x01E1, 0xC021, 0x8020, 0x41E0, 0x01A0, 0xC060,
;        0x8061, 0x41A1, 0x0063, 0xC1A3, 0x81A2, 0x4062, 0x0066, 0xC1A6, 0x81A7, 0x4067,
;        0x01A5, 0xC065, 0x8064, 0x41A4, 0x006C, 0xC1AC, 0x81AD, 0x406D, 0x01AF, 0xC06F,
;        0x806E, 0x41AE, 0x01AA, 0xC06A, 0x806B, 0x41AB, 0x0069, 0xC1A9, 0x81A8, 0x4068,
;        0x0078, 0xC1B8, 0x81B9, 0x4079, 0x01BB, 0xC07B, 0x807A, 0x41BA, 0x01BE, 0xC07E,
;        0x807F, 0x41BF, 0x007D, 0xC1BD, 0x81BC, 0x407C, 0x01B4, 0xC074, 0x8075, 0x41B5,
;        0x0077, 0xC1B7, 0x81B6, 0x4076, 0x0072, 0xC1B2, 0x81B3, 0x4073, 0x01B1, 0xC071,
;        0x8070, 0x41B0, 0x0050, 0xC190, 0x8191, 0x4051, 0x0193, 0xC053, 0x8052, 0x4192,
;        0x0196, 0xC056, 0x8057, 0x4197, 0x0055, 0xC195, 0x8194, 0x4054, 0x019C, 0xC05C,
;	0x805D, 0x419D, 0x005F, 0xC19F, 0x819E, 0x405E, 0x005A, 0xC19A, 0x819B, 0x405B,
;	0x0199, 0xC059, 0x8058, 0x4198, 0x0188, 0xC048, 0x8049, 0x4189, 0x004B, 0xC18B,
;	0x818A, 0x404A, 0x004E, 0xC18E, 0x818F, 0x404F, 0x018D, 0xC04D, 0x804C, 0x418C,
;	0x0044, 0xC184, 0x8185, 0x4045, 0x0187, 0xC047, 0x8046, 0x4186, 0x0182, 0xC042,
;	0x8043, 0x4183, 0x0041, 0xC181, 0x8180, 0x4040
;};
;
;void  CRC_update(unsigned char d)
; 0000 00BA {
_CRC_update:
; 0000 00BB   //unsigned char uindex;
; 0000 00BC   //uindex = CRCHigh^d;
; 0000 00BD   //CRCHigh=CRCLow^((int)crctable[uindex]>>8);
; 0000 00BE   //CRCLow=crctable[uindex];
; 0000 00BF   //crc = CRCHigh;
; 0000 00C0   //crc = ((int)crc)<<8+CRCLow;
; 0000 00C1   crc = crctable[((crc>>8)^d)&0xFF] ^ (crc<<8);
;	d -> Y+0
	CALL SUBOPT_0x10
	CALL __ASRW8
	MOVW R26,R30
	LD   R30,Y
	LDI  R31,0
	EOR  R26,R30
	EOR  R27,R31
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	AND  R30,R26
	AND  R31,R27
	LDI  R26,LOW(_crctable*2)
	LDI  R27,HIGH(_crctable*2)
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	CALL __GETW2PF
	LDS  R31,_crc
	LDI  R30,LOW(0)
	CALL SUBOPT_0x11
; 0000 00C2 }
_0x20A0006:
	ADIW R28,1
	RET
;void hex2dec(float x)		// подпрограмма преобразования кода в ASCII
; 0000 00C4  	{				//
_hex2dec:
; 0000 00C5  	char str[9],str1[9];
; 0000 00C6  	signed char a,b;
; 0000 00C7     char counter=0;
; 0000 00C8  	if (x<-999) x=-999;
	SBIW R28,18
	CALL __SAVELOCR4
;	x -> Y+22
;	str -> Y+13
;	str1 -> Y+4
;	a -> R17
;	b -> R16
;	counter -> R19
	LDI  R19,0
	__GETD2S 22
	__GETD1N 0xC479C000
	CALL __CMPF12
	BRSH _0xBC
	__PUTD1S 22
; 0000 00C9  	if (x>999) x=999;
_0xBC:
	__GETD2S 22
	__GETD1N 0x4479C000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xBD
	__PUTD1S 22
; 0000 00CA  	ftoa(x,5,str1);
_0xBD:
	__GETD1S 22
	CALL __PUTPARD1
	LDI  R30,LOW(5)
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,9
	ST   -Y,R31
	ST   -Y,R30
	CALL _ftoa
; 0000 00CB //    for(a=0; a < 5; a++)
; 0000 00CC //    {
; 0000 00CD //
; 0000 00CE //        if(str1[a]==0x2e)
; 0000 00CF //        {
; 0000 00D0 //           // point = a;
; 0000 00D1 //        }
; 0000 00D2 //        else
; 0000 00D3 //        {
; 0000 00D4 //            if(counter==0)
; 0000 00D5 //            {
; 0000 00D6 //                if(x<0)
; 0000 00D7 //                   tis='-';
; 0000 00D8 //                else
; 0000 00D9 //                    tis = str1[a]-0x30;
; 0000 00DA //            }
; 0000 00DB //            else if(counter==1)
; 0000 00DC //            {
; 0000 00DD //                sot =  str1[a]-0x30;
; 0000 00DE //            }
; 0000 00DF //            else if(counter==2)
; 0000 00E0 //            {
; 0000 00E1 //                des =  str1[a]-0x30;
; 0000 00E2 //            }
; 0000 00E3 //            else if(counter==3)
; 0000 00E4 //            {
; 0000 00E5 //                ed =  str1[a]-0x30;
; 0000 00E6 //            }
; 0000 00E7 //            counter++;
; 0000 00E8 //        }
; 0000 00E9 //
; 0000 00EA //    }
; 0000 00EB  	for (a=0;a<9;a++)
	LDI  R17,LOW(0)
_0xBF:
	CPI  R17,9
	BRGE _0xC0
; 0000 00EC     {
; 0000 00ED         if (str1[a]=='.')
	CALL SUBOPT_0x9
	CALL SUBOPT_0x12
	LD   R26,X
	CPI  R26,LOW(0x2E)
	BREQ _0xC2
; 0000 00EE             goto p1;
; 0000 00EF     }
	SUBI R17,-1
	RJMP _0xBF
_0xC0:
; 0000 00F0 p1:
_0xC2:
; 0000 00F1         b=4;
	LDI  R16,LOW(4)
; 0000 00F2         while ((a>=0)&&(b>=0))
_0xC3:
	CPI  R17,0
	BRLT _0xC6
	CPI  R16,0
	BRGE _0xC7
_0xC6:
	RJMP _0xC5
_0xC7:
; 0000 00F3         {
; 0000 00F4             str[b]=str1[a];
	CALL SUBOPT_0x13
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	CALL SUBOPT_0x9
	CALL SUBOPT_0x12
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
; 0000 00F5             a--;
	SUBI R17,1
; 0000 00F6             b--;
	SUBI R16,1
; 0000 00F7         }
	RJMP _0xC3
_0xC5:
; 0000 00F8         a=3-b;
	LDI  R30,LOW(3)
	SUB  R30,R16
	MOV  R17,R30
; 0000 00F9         while (b>=0)
_0xC8:
	CPI  R16,0
	BRLT _0xCA
; 0000 00FA         {
; 0000 00FB             str[b]='0';
	CALL SUBOPT_0x13
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(48)
	ST   X,R30
; 0000 00FC             b--;
	SUBI R16,1
; 0000 00FD         }
	RJMP _0xC8
_0xCA:
; 0000 00FE         b=4;
	LDI  R16,LOW(4)
; 0000 00FF         while ((a<9)&&(b<9))
_0xCB:
	CPI  R17,9
	BRGE _0xCE
	CPI  R16,9
	BRLT _0xCF
_0xCE:
	RJMP _0xCD
_0xCF:
; 0000 0100         {
; 0000 0101             str[b]=str1[a];
	CALL SUBOPT_0x13
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	CALL SUBOPT_0x9
	CALL SUBOPT_0x12
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
; 0000 0102             a++;
	SUBI R17,-1
; 0000 0103             b++;
	SUBI R16,-1
; 0000 0104         }
	RJMP _0xCB
_0xCD:
; 0000 0105         while (b<9)
_0xD0:
	CPI  R16,9
	BRGE _0xD2
; 0000 0106          {
; 0000 0107             str[b]='0';
	CALL SUBOPT_0x13
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(48)
	ST   X,R30
; 0000 0108             b++;
	SUBI R16,-1
; 0000 0109          }
	RJMP _0xD0
_0xD2:
; 0000 010A  	if (point==1)
	LDS  R26,_point
	CPI  R26,LOW(0x1)
	BRNE _0xD3
; 0000 010B  	        {
; 0000 010C                 if (str[0]=='-') tis='-';
	LDD  R26,Y+13
	CPI  R26,LOW(0x2D)
	BRNE _0xD4
	LDI  R30,LOW(45)
	RJMP _0x3A8
; 0000 010D                 else if (str[0]==0)
_0xD4:
	LDD  R30,Y+13
	CPI  R30,0
	BRNE _0xD6
; 0000 010E                     tis=0;
	LDI  R30,LOW(0)
	RJMP _0x3A8
; 0000 010F                 else
_0xD6:
; 0000 0110                     tis=str[0]-0x30;
	LDD  R30,Y+13
	SUBI R30,LOW(48)
_0x3A8:
	STS  _tis,R30
; 0000 0111                 sot=str[1]-0x30;
	LDD  R30,Y+14
	SUBI R30,LOW(48)
	STS  _sot,R30
; 0000 0112                 des=str[2]-0x30;
	LDD  R30,Y+15
	SUBI R30,LOW(48)
	STS  _des,R30
; 0000 0113                 ed=str[3]-0x30;
	LDD  R30,Y+16
	CALL SUBOPT_0x14
; 0000 0114                 if (tis==0)
	BRNE _0xD8
; 0000 0115                 {
; 0000 0116                     tis=' ';
	CALL SUBOPT_0x15
; 0000 0117                     if (sot==0)
	BRNE _0xD9
; 0000 0118                     {
; 0000 0119                         sot=' ';
	LDI  R30,LOW(32)
	STS  _sot,R30
; 0000 011A                         if(des==0)
	LDS  R30,_des
	CPI  R30,0
	BRNE _0xDA
; 0000 011B                             des=' ';
	LDI  R30,LOW(32)
	STS  _des,R30
; 0000 011C                     }
_0xDA:
; 0000 011D                     }
_0xD9:
; 0000 011E  	        }
_0xD8:
; 0000 011F  	if (point==2)
_0xD3:
	LDS  R26,_point
	CPI  R26,LOW(0x2)
	BRNE _0xDB
; 0000 0120  	        {
; 0000 0121                 if (str[1]=='-') tis='-';
	LDD  R26,Y+14
	CPI  R26,LOW(0x2D)
	BRNE _0xDC
	LDI  R30,LOW(45)
	RJMP _0x3A9
; 0000 0122                 else if (str[1]==0)tis=0;
_0xDC:
	LDD  R30,Y+14
	CPI  R30,0
	BRNE _0xDE
	LDI  R30,LOW(0)
	RJMP _0x3A9
; 0000 0123                 else tis=str[1]-0x30;
_0xDE:
	LDD  R30,Y+14
	SUBI R30,LOW(48)
_0x3A9:
	STS  _tis,R30
; 0000 0124                 if (str[2]=='-') sot='-';
	LDD  R26,Y+15
	CPI  R26,LOW(0x2D)
	BRNE _0xE0
	LDI  R30,LOW(45)
	RJMP _0x3AA
; 0000 0125                 else if (str[2]==0)sot=0;
_0xE0:
	LDD  R30,Y+15
	CPI  R30,0
	BRNE _0xE2
	LDI  R30,LOW(0)
	RJMP _0x3AA
; 0000 0126                 else sot=str[2]-0x30;
_0xE2:
	LDD  R30,Y+15
	SUBI R30,LOW(48)
_0x3AA:
	STS  _sot,R30
; 0000 0127                 des=str[3]-0x30;
	LDD  R30,Y+16
	SUBI R30,LOW(48)
	STS  _des,R30
; 0000 0128                 ed=str[5]-0x30;
	LDD  R30,Y+18
	CALL SUBOPT_0x14
; 0000 0129                 if (tis==0){tis=' ';if (sot==0)sot=' ';}
	BRNE _0xE4
	CALL SUBOPT_0x15
	BRNE _0xE5
	LDI  R30,LOW(32)
	STS  _sot,R30
_0xE5:
; 0000 012A  	        }
_0xE4:
; 0000 012B  	if (point==3)
_0xDB:
	LDS  R26,_point
	CPI  R26,LOW(0x3)
	BRNE _0xE6
; 0000 012C  	        {
; 0000 012D                 if (str[2]=='-') tis='-';
	LDD  R26,Y+15
	CPI  R26,LOW(0x2D)
	BRNE _0xE7
	LDI  R30,LOW(45)
	RJMP _0x3AB
; 0000 012E                 else if (str[2]==0)tis=0;
_0xE7:
	LDD  R30,Y+15
	CPI  R30,0
	BRNE _0xE9
	LDI  R30,LOW(0)
	RJMP _0x3AB
; 0000 012F                 else tis=str[2]-0x30;
_0xE9:
	LDD  R30,Y+15
	SUBI R30,LOW(48)
_0x3AB:
	STS  _tis,R30
; 0000 0130                 if (str[3]=='-') sot='-';
	LDD  R26,Y+16
	CPI  R26,LOW(0x2D)
	BRNE _0xEB
	LDI  R30,LOW(45)
	RJMP _0x3AC
; 0000 0131                 else if (str[3]==0)sot=0;
_0xEB:
	LDD  R30,Y+16
	CPI  R30,0
	BRNE _0xED
	LDI  R30,LOW(0)
	RJMP _0x3AC
; 0000 0132                 else sot=str[3]-0x30;
_0xED:
	LDD  R30,Y+16
	SUBI R30,LOW(48)
_0x3AC:
	STS  _sot,R30
; 0000 0133                 des=str[5]-0x30;
	LDD  R30,Y+18
	SUBI R30,LOW(48)
	STS  _des,R30
; 0000 0134                 ed=str[6]-0x30;
	LDD  R30,Y+19
	CALL SUBOPT_0x14
; 0000 0135                 if (tis==0)tis=' ';
	BRNE _0xEF
	LDI  R30,LOW(32)
	STS  _tis,R30
; 0000 0136  	        }
_0xEF:
; 0000 0137  	if (point==4)
_0xE6:
	LDS  R26,_point
	CPI  R26,LOW(0x4)
	BRNE _0xF0
; 0000 0138  	        {
; 0000 0139                 if (str[3]=='-') tis='-';
	LDD  R26,Y+16
	CPI  R26,LOW(0x2D)
	BRNE _0xF1
	LDI  R30,LOW(45)
	RJMP _0x3AD
; 0000 013A                 else if (str[3]==0)tis=0;
_0xF1:
	LDD  R30,Y+16
	CPI  R30,0
	BRNE _0xF3
	LDI  R30,LOW(0)
	RJMP _0x3AD
; 0000 013B                 else tis=str[3]-0x30;
_0xF3:
	LDD  R30,Y+16
	SUBI R30,LOW(48)
_0x3AD:
	STS  _tis,R30
; 0000 013C                 if (str[5]=='-') sot='-';
	LDD  R26,Y+18
	CPI  R26,LOW(0x2D)
	BRNE _0xF5
	LDI  R30,LOW(45)
	RJMP _0x3AE
; 0000 013D                 else if (str[5]==0)sot=0;
_0xF5:
	LDD  R30,Y+18
	CPI  R30,0
	BRNE _0xF7
	LDI  R30,LOW(0)
	RJMP _0x3AE
; 0000 013E                 else sot=str[5]-0x30;
_0xF7:
	LDD  R30,Y+18
	SUBI R30,LOW(48)
_0x3AE:
	STS  _sot,R30
; 0000 013F                 des=str[6]-0x30;
	LDD  R30,Y+19
	SUBI R30,LOW(48)
	STS  _des,R30
; 0000 0140                 ed=str[7]-0x30;
	LDD  R30,Y+20
	SUBI R30,LOW(48)
	STS  _ed,R30
; 0000 0141  	        }
; 0000 0142  	}
_0xF0:
	CALL __LOADLOCR4
	ADIW R28,26
	RET
;//-------------------------------------------------------------------//
;// чтение из АЦП
;void find_save_reg(unsigned int a,float b);
;float find_reg(unsigned int a);
;void response_m_err(char a);                     //
;//-------------------------------------------------------------------//
;int read_adc()
; 0000 014A         {
_read_adc:
; 0000 014B         int a;
; 0000 014C         cs=0;
	ST   -Y,R17
	ST   -Y,R16
;	a -> R16,R17
	CBI  0x18,4
; 0000 014D         SPCR=0b01010001;
	LDI  R30,LOW(81)
	OUT  0xD,R30
; 0000 014E         i=reg[0][A_12];
	CALL SUBOPT_0x16
; 0000 014F         switch (i)
; 0000 0150                 {
; 0000 0151                 case 0: SPDR=0b10110001;break;//4-20mA 20=4.4   =3606 k=20/3606 AIN0
	BREQ _0x3AF
; 0000 0152                 case 1: SPDR=0b10111001;break;//0-5mA   5=4.4   =3606 k= 5/3606 AIN1
	CPI  R30,LOW(0x1)
	BRNE _0xFF
	LDI  R30,LOW(185)
	RJMP _0x3B0
; 0000 0153                 case 2: SPDR=0b10110001;break;//0-20mA 20=4.4   =3606 k=20/3606 AIN0
_0xFF:
	CPI  R30,LOW(0x2)
	BREQ _0x3AF
; 0000 0154                 case 3: SPDR=0b10111001;break;//0-10V  10=4.506 =3606 k=10/3691 AIN1
	CPI  R30,LOW(0x3)
	BRNE _0x102
	LDI  R30,LOW(185)
	RJMP _0x3B0
; 0000 0155                 default:SPDR=0b10110001;break;//0-5V    5=4.506 =3606 k= 5/3691 AIN0
_0x102:
_0x3AF:
	LDI  R30,LOW(177)
_0x3B0:
	OUT  0xF,R30
; 0000 0156                 }
; 0000 0157         while(SPSR.7==0);
_0x103:
	SBIS 0xE,7
	RJMP _0x103
; 0000 0158         a=SPDR;
	IN   R16,15
	CLR  R17
; 0000 0159         SPDR=0;
	LDI  R30,LOW(0)
	OUT  0xF,R30
; 0000 015A         a=a<<8;
	MOV  R17,R16
	CLR  R16
; 0000 015B         while (SPSR.7 == 0);
_0x106:
	SBIS 0xE,7
	RJMP _0x106
; 0000 015C         a = a + SPDR;
	IN   R30,0xF
	LDI  R31,0
	__ADDWRR 16,17,30,31
; 0000 015D         cs=1;
	SBI  0x18,4
; 0000 015E         return a;
	MOVW R30,R16
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0000 015F         }
;//-------------------------------------------------------------------//
;unsigned int buf[9],buf_m[9];
;char buf_begin,buf_end,buf_n[9];
;float x,adc_filter;
;char j,k,count_register,count_key2;
;long start_time,start_time_mode,time_key;
;
;#include <function.h>
_rekey:
	LDS  R26,_count_key2
	CPI  R26,LOW(0x15)
	BRLO _0x10B
	CALL SUBOPT_0x17
	CPI  R26,LOW(0x68)
	BRLO _0x10C
	LDI  R30,LOW(102)
	STS  _count_key1,R30
_0x10C:
	RJMP _0x10D
_0x10B:
	LDS  R26,_count_key1
	CPI  R26,LOW(0x65)
	BRLO _0x10E
	CALL SUBOPT_0x17
	CPI  R26,LOW(0x6B)
	BRLO _0x10F
	LDI  R30,LOW(102)
	STS  _count_key1,R30
	LDS  R30,_count_key2
	SUBI R30,-LOW(1)
	STS  _count_key2,R30
_0x10F:
	RJMP _0x110
_0x10E:
	LDS  R26,_time_key
	LDS  R27,_time_key+1
	LDS  R24,_time_key+2
	LDS  R25,_time_key+3
	CALL SUBOPT_0x18
	__CPD1N 0x33
	BRLT _0x112
	LDS  R26,_count_key
	CPI  R26,LOW(0x1)
	BRSH _0x113
_0x112:
	RJMP _0x111
_0x113:
	CALL SUBOPT_0x3
	STS  _time_key,R30
	STS  _time_key+1,R31
	STS  _time_key+2,R22
	STS  _time_key+3,R23
	LDS  R26,_count_key
	SUBI R26,LOW(1)
	STS  _count_key,R26
	CPI  R26,LOW(0x14)
	BRSH _0x114
	LDI  R30,LOW(40)
	STS  _count_key,R30
	CALL SUBOPT_0x17
	CPI  R26,LOW(0x5)
	BRLO _0x115
	LDI  R30,LOW(102)
	STS  _count_key1,R30
	LDI  R30,LOW(250)
	STS  _count_key,R30
_0x115:
_0x114:
_0x111:
_0x110:
_0x10D:
	RET
;
;float izm()
; 0000 016A         {
_izm:
; 0000 016B         char min_r,min_n;
; 0000 016C         signed char rang[9];
; 0000 016D         float k_f;
; 0000 016E         //-------------------------------------------------------------------//
; 0000 016F         //измерение
; 0000 0170         //-------------------------------------------------------------------//
; 0000 0171         if (++buf_end>8) buf_end=0;
	SBIW R28,13
	ST   -Y,R17
	ST   -Y,R16
;	min_r -> R17
;	min_n -> R16
;	rang -> Y+6
;	k_f -> Y+2
	LDS  R26,_buf_end
	SUBI R26,-LOW(1)
	STS  _buf_end,R26
	CPI  R26,LOW(0x9)
	BRLO _0x116
	LDI  R30,LOW(0)
	STS  _buf_end,R30
; 0000 0172         buf[buf_end]=read_adc();
_0x116:
	CALL SUBOPT_0x19
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	RCALL _read_adc
	POP  R26
	POP  R27
	ST   X+,R30
	ST   X,R31
; 0000 0173         min_r=9;
	LDI  R17,LOW(9)
; 0000 0174         //-------------------------------------------------------------------//
; 0000 0175         //-------------------------------------------------------------------//
; 0000 0176         //модальный фильтр *- нижепреведенный код не делает ничего, кроме выборки наименьшего значения из последних 9ти измерений*
; 0000 0177         //-------------------------------------------------------------------//
; 0000 0178         for (j=0;j<9;j++)
	LDI  R30,LOW(0)
	STS  _j,R30
_0x118:
	LDS  R26,_j
	CPI  R26,LOW(0x9)
	BRLO PC+3
	JMP _0x119
; 0000 0179                 {
; 0000 017A                 rang[j]=0;
	CALL SUBOPT_0x1A
	LDI  R30,LOW(0)
	ST   X,R30
; 0000 017B                 for (i=0;i<9;i++)
	STS  _i,R30
_0x11B:
	LDS  R26,_i
	CPI  R26,LOW(0x9)
	BRSH _0x11C
; 0000 017C                         {
; 0000 017D                         if (i!=j)
	LDS  R30,_j
	CP   R30,R26
	BREQ _0x11D
; 0000 017E                                 {
; 0000 017F                                 if (buf[j]<buf[i]) rang[j]--;
	CALL SUBOPT_0x1B
	CP   R0,R30
	CPC  R1,R31
	BRSH _0x11E
	CALL SUBOPT_0x1A
	LD   R30,X
	SUBI R30,LOW(1)
	ST   X,R30
; 0000 0180                                 if (buf[j]>buf[i]) rang[j]++;
_0x11E:
	CALL SUBOPT_0x1B
	CP   R30,R0
	CPC  R31,R1
	BRSH _0x11F
	CALL SUBOPT_0x1A
	LD   R30,X
	SUBI R30,-LOW(1)
	ST   X,R30
; 0000 0181                                 }
_0x11F:
; 0000 0182                         }
_0x11D:
	CALL SUBOPT_0x1C
	RJMP _0x11B
_0x11C:
; 0000 0183                 if (cabs(rang[j])<min_r)
	CALL SUBOPT_0x1A
	LD   R30,X
	ST   -Y,R30
	CALL _cabs
	CP   R30,R17
	BRSH _0x120
; 0000 0184                         {
; 0000 0185                         min_r=cabs(rang[j]);
	CALL SUBOPT_0x1A
	LD   R30,X
	ST   -Y,R30
	CALL _cabs
	MOV  R17,R30
; 0000 0186                         min_n=j;
	LDS  R16,_j
; 0000 0187                         }
; 0000 0188                 }
_0x120:
	LDS  R30,_j
	SUBI R30,-LOW(1)
	STS  _j,R30
	RJMP _0x118
_0x119:
; 0000 0189         //-------------------------------------------------------------------//
; 0000 018A         //ФНЧ *- есть некоторые сомнения, что это можно назвать фильтром низких частот, тупо усредняем значение измерения ацп в единицу времени усреднения*
; 0000 018B         //-------------------------------------------------------------------//
; 0000 018C         k_f=reg[0][A_10];
	__POINTW2MN _reg,64
	CALL __EEPROMRDD
	CALL SUBOPT_0x1D
; 0000 018D         if (k_f==0) k_f=0.001;
	CALL SUBOPT_0x1E
	CALL __CPD10
	BRNE _0x121
	__GETD1N 0x3A83126F
	CALL SUBOPT_0x1D
; 0000 018E         k_f=0.001/k_f;
_0x121:
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1F
	CALL __DIVF21
	CALL SUBOPT_0x1D
; 0000 018F         adc_filter=k_f*buf[min_n]+(1-k_f)*adc_filter;
	MOV  R30,R16
	LDI  R26,LOW(_buf)
	LDI  R27,HIGH(_buf)
	LDI  R31,0
	LSL  R30
	ROL  R31
	CALL SUBOPT_0x20
	CALL SUBOPT_0x21
	CALL SUBOPT_0x22
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x21
	CALL SUBOPT_0x23
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
; 0000 0190         //-------------------------------------------------------------------//
; 0000 0191         return adc_filter;
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,15
	RET
; 0000 0192         }
;//-------------------------------------------------------------------//
;char error;
;//int crc;
;float value[6],adc_value1,adc_value2,adc_value3;
;bit blok1,blok2,signal;
;void response_m_aa1();
;void response_m_aa46();
;void response_m_aa48();
;void check_add_cr();
;
;void check_rx();
;void mov_buf_mod(char a);		//
;void mov_buf(char a);			//
;void crc_end();				//
;void crc_rtu(char a);			//
;
;//////////////////////////////////////////////////////////////////////
;//
;//      Считывание данных из Flash
;//      The registers R0, R1, R22, R23, R24, R25, R26, R27, R30 and R31 can be freely used in assembly routines.
;/////////////////////////////////////////////////////////////////////////////
;int read_program_memory (int adr)
; 0000 01A9 {
_read_program_memory:
; 0000 01AA        #asm
;	adr -> Y+0
; 0000 01AB        LPM R22,Z+;//     загрузка в регистр R23 содержимого флеш по адресу Z с постинкрементом (мл. байт)
       LPM R22,Z+;//     загрузка в регистр R23 содержимого флеш по адресу Z с постинкрементом (мл. байт)
; 0000 01AC        LPM R23,Z; //     загрузка в регистр R22 содержимого Flash  по адресу Z+1 (старший байт)
       LPM R23,Z; //     загрузка в регистр R22 содержимого Flash  по адресу Z+1 (старший байт)
; 0000 01AD        MOV R30, R22;
       MOV R30, R22;
; 0000 01AE        MOV R31, R23;
       MOV R31, R23;
; 0000 01AF        #endasm
; 0000 01B0 }
	ADIW R28,2
	RET
;
;void sys_init()
; 0000 01B3 {
_sys_init:
; 0000 01B4 PORTA=0b11111111;DDRA=0b11111111;
	LDI  R30,LOW(255)
	OUT  0x1B,R30
	OUT  0x1A,R30
; 0000 01B5 PORTB=0b00000000;DDRB=0b10110011;
	LDI  R30,LOW(0)
	OUT  0x18,R30
	LDI  R30,LOW(179)
	OUT  0x17,R30
; 0000 01B6 PORTC=0b11111011;DDRC=0b11111000;
	LDI  R30,LOW(251)
	OUT  0x15,R30
	LDI  R30,LOW(248)
	OUT  0x14,R30
; 0000 01B7 PORTD=0b11000011;DDRD=0b00111110;
	LDI  R30,LOW(195)
	OUT  0x12,R30
	LDI  R30,LOW(62)
	OUT  0x11,R30
; 0000 01B8 //UBRRH=0x00;UBRRL=0x5f;UCSRB=0xD8;UCSRC=0x86;
; 0000 01B9 
; 0000 01BA 
; 0000 01BB 
; 0000 01BC TCCR0=0x03;TCNT0=TCNT0_reload;OCR0=0x00;
	LDI  R30,LOW(3)
	OUT  0x33,R30
	LDI  R30,LOW(111)
	OUT  0x32,R30
	LDI  R30,LOW(0)
	OUT  0x3C,R30
; 0000 01BD 
; 0000 01BE ASSR=0x00;TCCR2=0x04;TCNT2=TCNT2_reload;OCR2=0x00;
	OUT  0x22,R30
	LDI  R30,LOW(4)
	OUT  0x25,R30
	LDI  R30,LOW(94)
	OUT  0x24,R30
	LDI  R30,LOW(0)
	OUT  0x23,R30
; 0000 01BF //ASSR=0x00;TCCR2=0x07;TCNT2=TCNT2_reload;OCR2=0x00;
; 0000 01C0 MCUCR=0x00;MCUCSR=0x00;TIMSK=0xFF;
	OUT  0x35,R30
	OUT  0x34,R30
	LDI  R30,LOW(255)
	OUT  0x39,R30
; 0000 01C1 
; 0000 01C2 //UBRRH=0x00;UBRRL=0x67;UCSRB=0xD8;UCSRC=0x86;
; 0000 01C3 ACSR=0x80;SFIOR=0x00;SPCR=0x52;SPSR=0x00;WDTCR=0x1F;WDTCR=0x0F;
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
; 0000 01C4 mod_time_s=60;
	LDI  R30,LOW(60)
	MOV  R8,R30
; 0000 01C5 }
	RET
;
;void main(void)
; 0000 01C8 {
_main:
; 0000 01C9 bit flag_start_pause1,flag_start_pause2,f_m1,key_enter_press_switch1;
; 0000 01CA float time_pause1,time_pause2/*,adc_value1*/;
; 0000 01CB float data_register,adc_filter/*,adc_value2*/;
; 0000 01CC float k_k,kk,bb,dop1,dop2;
; 0000 01CD float gis_val1=reg[0][Y_01];         //значение с учетом гистерезиса
; 0000 01CE float gis_val2=reg[0][Y_02];
; 0000 01CF char q1,q2,q3,q4,diap_val1=0,diap_val2=0,dataH,dataL,crcok_flag=0;//diap_val1,2 - это диапазон на 1м и на 2м шаге
; 0000 01D0 float temp;
; 0000 01D1 int  imin, imax, data, j = 0, j1=0;
; 0000 01D2 unsigned char tmp[9];
; 0000 01D3 crc = 0xffff;
	SBIW R28,63
	SBIW R28,7
	LDI  R24,15
	LDI  R26,LOW(9)
	LDI  R27,HIGH(9)
	LDI  R30,LOW(_0x122*2)
	LDI  R31,HIGH(_0x122*2)
	CALL __INITLOCB
;	flag_start_pause1 -> R15.0
;	flag_start_pause2 -> R15.1
;	f_m1 -> R15.2
;	key_enter_press_switch1 -> R15.3
;	time_pause1 -> Y+66
;	time_pause2 -> Y+62
;	data_register -> Y+58
;	adc_filter -> Y+54
;	k_k -> Y+50
;	kk -> Y+46
;	bb -> Y+42
;	dop1 -> Y+38
;	dop2 -> Y+34
;	gis_val1 -> Y+30
;	gis_val2 -> Y+26
;	q1 -> R17
;	q2 -> R16
;	q3 -> R19
;	q4 -> R18
;	diap_val1 -> R21
;	diap_val2 -> R20
;	dataH -> Y+25
;	dataL -> Y+24
;	crcok_flag -> Y+23
;	temp -> Y+19
;	imin -> Y+17
;	imax -> Y+15
;	data -> Y+13
;	j -> Y+11
;	j1 -> Y+9
;	tmp -> Y+0
	CALL SUBOPT_0x24
	__PUTD1S 30
	CALL SUBOPT_0x25
	__PUTD1S 26
	LDI  R21,0
	LDI  R20,0
	CALL SUBOPT_0x26
; 0000 01D4 //if(high==0)
; 0000 01D5 //{
; 0000 01D6           // imin=0;
; 0000 01D7          //  imax=PAGESIZE*APP_PAGES;
; 0000 01D8 //}
; 0000 01D9 //else
; 0000 01DA //{
; 0000 01DB //   imin=PAGESIZE*APP_PAGES;
; 0000 01DC //   imax=PAGESIZE*PAGES;
; 0000 01DD //}
; 0000 01DE //            for(i=imin; i<imax;  i+=2)
; 0000 01DF //            {
; 0000 01E0 //               data= read_program_memory (i,0);
; 0000 01E1 //               crc^=LOBYTE(data);
; 0000 01E2 //               crc^=HIBYTE(data);
; 0000 01E3 //            }
; 0000 01E4 //
; 0000 01E5 // while(1)
; 0000 01E6 //         {
; 0000 01E7 //         DDRC=0xFF;
; 0000 01E8 //         DDRA=0xFF;
; 0000 01E9 //         anode1=1;
; 0000 01EA //         anode2=1;
; 0000 01EB //         anode3=1;
; 0000 01EC //         anode4=0;
; 0000 01ED //         anode5=0;
; 0000 01EE //         q1++;
; 0000 01EF //         if (q1>9)q1=0;
; 0000 01F0 //         katode=255-led_calk(q1);
; 0000 01F1 //         delay_ms(500);
; 0000 01F2 //
; 0000 01F3 //
; 0000 01F4 //         }
; 0000 01F5 //
; 0000 01F6 // temp=2345;
; 0000 01F7 // reg[0,0]=temp;
; 0000 01F8 //
; 0000 01F9 // reg[0,0]=1234;
; 0000 01FA // temp=reg[0,0];
; 0000 01FB //
; 0000 01FC // q1=(*((unsigned char *)(&temp)+0));
; 0000 01FD // q2=(*((unsigned char *)(&temp)+1));
; 0000 01FE // q3=(*((unsigned char *)(&temp)+2));
; 0000 01FF // q4=(*((unsigned char *)(&temp)+3));
; 0000 0200 //
; 0000 0201 //
; 0000 0202 // q1=0;
; 0000 0203 // q2=1;
; 0000 0204 // q3=2;
; 0000 0205 // q4=0x44;
; 0000 0206 //
; 0000 0207 //
; 0000 0208 // *((unsigned char *)(&temp)+0)=q1;
; 0000 0209 // *((unsigned char *)(&temp)+1)=q2;
; 0000 020A // *((unsigned char *)(&temp)+2)=q3;
; 0000 020B // *((unsigned char *)(&temp)+3)=q4;
; 0000 020C //
; 0000 020D // reg[0,0]=temp;
; 0000 020E // reg[0,0]=temp;
; 0000 020F // reg[0,0]=temp;
; 0000 0210 //
; 0000 0211 
; 0000 0212 point=ee_point;
	CALL SUBOPT_0x27
; 0000 0213 
; 0000 0214 sys_init();
	RCALL _sys_init
; 0000 0215 #asm("cli");
	cli
; 0000 0216 
; 0000 0217 
; 0000 0218 //goto a1;//test
; 0000 0219 //goto a2;//test
; 0000 021A 
; 0000 021B //-------------------------------------------------------------------//
; 0000 021C //Ожидание включения питания
; 0000 021D //-------------------------------------------------------------------//
; 0000 021E 
; 0000 021F while ((data<=65534)|(j<=16382))
_0x123:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDI  R30,LOW(65534)
	LDI  R31,HIGH(65534)
	CALL __LEW12U
	MOV  R0,R30
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	LDI  R30,LOW(16382)
	LDI  R31,HIGH(16382)
	CALL __LEW12
	OR   R30,R0
	BREQ _0x125
; 0000 0220 {
; 0000 0221     data= read_program_memory (j);
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL _read_program_memory
	STD  Y+13,R30
	STD  Y+13+1,R31
; 0000 0222     dataH = (int)data>>8;
	CALL __ASRW8
	STD  Y+25,R30
; 0000 0223     dataL = data;
	LDD  R30,Y+13
	STD  Y+24,R30
; 0000 0224     CRC_update(dataH);
	LDD  R30,Y+25
	ST   -Y,R30
	RCALL _CRC_update
; 0000 0225     CRC_update(dataL);
	LDD  R30,Y+24
	ST   -Y,R30
	RCALL _CRC_update
; 0000 0226     //crc_rtu(data);
; 0000 0227     //j++;
; 0000 0228     j=j+2;
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	ADIW R30,2
	STD  Y+11,R30
	STD  Y+11+1,R31
; 0000 0229 }
	RJMP _0x123
_0x125:
; 0000 022A crceep = crc;
	CALL SUBOPT_0x10
	LDI  R26,LOW(_crceep)
	LDI  R27,HIGH(_crceep)
	CALL __EEPROMWRW
; 0000 022B i=0;
	LDI  R30,LOW(0)
	STS  _i,R30
; 0000 022C #asm("sei")
	sei
; 0000 022D start_time=sys_time;count_register=1;
	CALL SUBOPT_0x28
; 0000 022E power = 1;
	SBI  0x12,3
; 0000 022F 
; 0000 0230 //ftoa(-100.989,5,tmp);
; 0000 0231 //for(j=0; j < 9; j++)
; 0000 0232 //    smth[j] = tmp[j];
; 0000 0233 for(j1=0;j1<2;j1++)
	LDI  R30,LOW(0)
	STD  Y+9,R30
	STD  Y+9+1,R30
_0x129:
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	SBIW R26,2
	BRLT PC+3
	JMP _0x12A
; 0000 0234 {
; 0000 0235 tis='v';sot=1;des= 0 ;ed=1;
	CALL SUBOPT_0x29
; 0000 0236 set_digit_on(tis,sot,des,ed);        set_digit_off(tis,sot,des,ed);
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 0237 set_led_on(0,0,0,0,0,0,0,0);         set_led_off(0,0,0,0,0,0,0,0);
	CALL SUBOPT_0x2D
; 0000 0238 delay_ms(1500);
; 0000 0239 
; 0000 023A if(reg[0][24]>=1000)
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x2F
	CALL __CMPF12
	BRLO _0x12B
; 0000 023B {
; 0000 023C       tis=1;sot=0;des= 0 ;ed=0;
	LDI  R30,LOW(1)
	STS  _tis,R30
	LDI  R30,LOW(0)
	CALL SUBOPT_0x30
	LDI  R30,LOW(0)
	CALL SUBOPT_0x31
; 0000 023D        set_digit_on(tis,sot,des,ed);
	CALL SUBOPT_0x32
; 0000 023E       set_led_on(0,0,0,0,0,0,0,0);
	LDI  R30,LOW(0)
	RJMP _0x3B1
; 0000 023F }
; 0000 0240 else
_0x12B:
; 0000 0241 {
; 0000 0242     tis  = (reg[0][24]*1000)/1000;
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x33
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x34
; 0000 0243     sot  = ((int)(reg[0][24]*1000)%1000)/100;
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x33
	CALL SUBOPT_0x35
	CALL SUBOPT_0x36
; 0000 0244     des  = ((int)(reg[0][24]*1000)%100)/10;
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x33
	CALL SUBOPT_0x35
	CALL SUBOPT_0x37
; 0000 0245     ed  =(int) (reg[0][24]*1000)%10;
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x33
	CALL SUBOPT_0x35
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	CALL SUBOPT_0x31
; 0000 0246     set_digit_on(tis,sot,des,ed);
	CALL SUBOPT_0x32
; 0000 0247     set_led_on(0,0,0,0,1,0,0,0);
	LDI  R30,LOW(1)
_0x3B1:
	ST   -Y,R30
	CALL SUBOPT_0x38
	RCALL _set_led_on
; 0000 0248 }
; 0000 0249 delay_ms(1000);
	CALL SUBOPT_0x39
; 0000 024A //tis=1;sot=0;des= 0 ;ed=0;
; 0000 024B set_digit_off(tis,sot,des,ed);
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x2C
; 0000 024C set_led_off(0,0,0,0,0,0,0,0);
	RCALL _set_led_off
; 0000 024D //delay_ms(750);
; 0000 024E 
; 0000 024F //set_digit_off(tis,sot,des,ed);
; 0000 0250 tis='c';sot='r';des= 'c' ;ed=' ';
	LDI  R30,LOW(99)
	STS  _tis,R30
	LDI  R30,LOW(114)
	STS  _sot,R30
	LDI  R30,LOW(99)
	STS  _des,R30
	LDI  R30,LOW(32)
	CALL SUBOPT_0x31
; 0000 0251 set_digit_on(tis,sot,des,ed);        set_digit_off(tis,sot,des,ed);
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 0252 set_led_on(0,0,0,0,0,0,0,0);         set_led_off(0,0,0,0,0,0,0,0);
	CALL SUBOPT_0x2D
; 0000 0253 delay_ms(1500);
; 0000 0254 tis=3;sot='c';des= 2 ;ed=1;
	LDI  R30,LOW(3)
	STS  _tis,R30
	LDI  R30,LOW(99)
	CALL SUBOPT_0x3A
	LDI  R30,LOW(1)
	CALL SUBOPT_0x31
; 0000 0255 set_digit_on(tis,sot,des,ed);        set_digit_off(tis,sot,des,ed);
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 0256 set_led_on(0,0,0,0,0,0,0,0);         set_led_off(0,0,0,0,0,0,0,0);
	CALL SUBOPT_0x2D
; 0000 0257 delay_ms(1500);
; 0000 0258 tis=' ';sot=' ';des= ' ' ;ed = ' ';
	LDI  R30,LOW(32)
	STS  _tis,R30
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x31
; 0000 0259 set_digit_on(tis,sot,des,ed);        set_digit_off(tis,sot,des,ed);
	CALL SUBOPT_0x2B
	RCALL _set_digit_off
; 0000 025A if(crceep == crcstatic)
	LDI  R26,LOW(_crceep)
	LDI  R27,HIGH(_crceep)
	CALL __EEPROMRDW
	MOVW R0,R30
	LDI  R26,LOW(_crcstatic)
	LDI  R27,HIGH(_crcstatic)
	CALL __EEPROMRDW
	CP   R30,R0
	CPC  R31,R1
	BRNE _0x12D
; 0000 025B     {
; 0000 025C     tis=0;
	LDI  R30,LOW(0)
	STS  _tis,R30
; 0000 025D     sot='k';
	LDI  R30,LOW(107)
	CALL SUBOPT_0x3B
; 0000 025E     des=' ';
; 0000 025F     ed = ' ';
	STS  _ed,R30
; 0000 0260     crcok_flag=1;
	LDI  R30,LOW(1)
	RJMP _0x3B2
; 0000 0261     }
; 0000 0262 else
_0x12D:
; 0000 0263     {
; 0000 0264     tis='f';sot='a';des= 'i' ;ed = 'l';
	LDI  R30,LOW(102)
	STS  _tis,R30
	LDI  R30,LOW(97)
	STS  _sot,R30
	LDI  R30,LOW(105)
	STS  _des,R30
	LDI  R30,LOW(108)
	STS  _ed,R30
; 0000 0265     crcok_flag = 0;
	LDI  R30,LOW(0)
_0x3B2:
	STD  Y+23,R30
; 0000 0266     }
; 0000 0267 set_digit_on(tis,sot,des,ed);        set_digit_off(tis,sot,des,ed);
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x2B
	RCALL _set_digit_off
; 0000 0268 delay_ms(1500);
	LDI  R30,LOW(1500)
	LDI  R31,HIGH(1500)
	CALL SUBOPT_0x3C
; 0000 0269 
; 0000 026A }
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ADIW R30,1
	STD  Y+9,R30
	STD  Y+9+1,R31
	RJMP _0x129
_0x12A:
; 0000 026B power_off:
_0x12F:
; 0000 026C sys_init();
	RCALL _sys_init
; 0000 026D start_time =0;
	LDI  R30,LOW(0)
	STS  _start_time,R30
	STS  _start_time+1,R30
	STS  _start_time+2,R30
	STS  _start_time+3,R30
; 0000 026E #asm ("cli")
	cli
; 0000 026F power = 0;
	CBI  0x12,3
; 0000 0270 if(crcok_flag==1)
	LDD  R26,Y+23
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x132
; 0000 0271 {
; 0000 0272 while ((key_1==0)&&(key_2==0)&&(key_3==0)&&(key_4==0));
_0x133:
	LDI  R26,0
	SBIC 0x13,0
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0x136
	LDI  R26,0
	SBIC 0x13,1
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0x136
	LDI  R26,0
	SBIC 0x10,6
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0x136
	LDI  R26,0
	SBIC 0x10,7
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BREQ _0x137
_0x136:
	RJMP _0x135
_0x137:
	RJMP _0x133
_0x135:
; 0000 0273 while (i<100)
_0x138:
	LDS  R26,_i
	CPI  R26,LOW(0x64)
	BRSH _0x13A
; 0000 0274         {
; 0000 0275         if ((key_1==0)&&(key_4==0)&&(key_2==1)&&(key_3==1)) i++;
	LDI  R26,0
	SBIC 0x13,0
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0x13C
	LDI  R26,0
	SBIC 0x10,7
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0x13C
	SBIS 0x13,1
	RJMP _0x13C
	SBIC 0x10,6
	RJMP _0x13D
_0x13C:
	RJMP _0x13B
_0x13D:
	LDS  R30,_i
	SUBI R30,-LOW(1)
	RJMP _0x3B3
; 0000 0276         else i=0;
_0x13B:
	LDI  R30,LOW(0)
_0x3B3:
	STS  _i,R30
; 0000 0277         delay_ms(20);
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CALL SUBOPT_0x3C
; 0000 0278         }
	RJMP _0x138
_0x13A:
; 0000 0279 //-------------------------------------------------------------------//
; 0000 027A 
; 0000 027B power=1;
	SBI  0x12,3
; 0000 027C data_register=reg[0][A_07];
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x3E
; 0000 027D if (data_register<0)
	LDD  R26,Y+61
	TST  R26
	BRPL _0x141
; 0000 027E         {
; 0000 027F         if (data_register>=-1000)point=1;
	CALL SUBOPT_0x3F
	CALL SUBOPT_0x40
	BRLO _0x142
	LDI  R30,LOW(1)
	STS  _point,R30
; 0000 0280         if (data_register>=-100)point=2;
_0x142:
	CALL SUBOPT_0x41
	BRLO _0x143
	LDI  R30,LOW(2)
	STS  _point,R30
; 0000 0281         if (data_register>=-10)point=3;
_0x143:
	CALL SUBOPT_0x42
	BRLO _0x144
	LDI  R30,LOW(3)
	STS  _point,R30
; 0000 0282         }
_0x144:
; 0000 0283 else
	RJMP _0x145
_0x141:
; 0000 0284         {
; 0000 0285         if (data_register<10)point=4;
	CALL SUBOPT_0x43
	BRSH _0x146
	LDI  R30,LOW(4)
	RJMP _0x3B4
; 0000 0286         else if (data_register<100)point=3;
_0x146:
	CALL SUBOPT_0x44
	BRSH _0x148
	LDI  R30,LOW(3)
	RJMP _0x3B4
; 0000 0287         else if (data_register<1000)point=2;
_0x148:
	CALL SUBOPT_0x45
	BRSH _0x14A
	LDI  R30,LOW(2)
	RJMP _0x3B4
; 0000 0288         else if (data_register>=1000)point=1;
_0x14A:
	CALL SUBOPT_0x45
	BRLO _0x14C
	LDI  R30,LOW(1)
_0x3B4:
	STS  _point,R30
; 0000 0289         }
_0x14C:
_0x145:
; 0000 028A 
; 0000 028B work_point=point;
	CALL SUBOPT_0x46
; 0000 028C 
; 0000 028D // a2:
; 0000 028E #asm("sei")
	sei
; 0000 028F //         tis=1;sot=2;des=3;ed=4;
; 0000 0290 //         set_digit_on(tis,sot,des,ed);        set_digit_off(tis,sot,des,ed);
; 0000 0291 //         set_led_on(0,0,0,0,0,0,0,0);         set_led_off(0,0,0,0,0,0,0,0);
; 0000 0292 // //        delay_ms(500);
; 0000 0293 //
; 0000 0294 // while (1);
; 0000 0295 //-------------------------------------------------------------------//
; 0000 0296 //Показать основные настройки
; 0000 0297 //блокировка по включению
; 0000 0298 //-------------------------------------------------------------------//
; 0000 0299 start_time=sys_time;count_register=1;
	CALL SUBOPT_0x28
; 0000 029A set_led_on(0,0,0,0,0,0,0,0);         set_led_off(0,0,0,0,0,0,0,0);
	CALL SUBOPT_0x38
	CALL SUBOPT_0x38
	CALL SUBOPT_0x47
	CALL SUBOPT_0x48
	CALL SUBOPT_0x38
	CALL SUBOPT_0x47
	CALL _set_led_off
; 0000 029B while ((sys_time-start_time)<reg[0][A_11]*1000)
_0x14D:
	CALL SUBOPT_0x49
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__POINTW2MN _reg,68
	CALL __EEPROMRDD
	CALL SUBOPT_0x33
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __CDF2
	CALL __CMPF12
	BRLO PC+3
	JMP _0x14F
; 0000 029C //while (1)
; 0000 029D         {
; 0000 029E         ed=' ';
	CALL SUBOPT_0x4A
; 0000 029F         switch (count_register)
; 0000 02A0                 {
; 0000 02A1                 case 2: tis='У';sot='_';des= 2 ;break;
	BRNE _0x153
	LDI  R30,LOW(211)
	CALL SUBOPT_0x4B
	RJMP _0x3B5
; 0000 02A2                 case 3: tis= 3 ;sot='_';des= 1 ;break;
_0x153:
	CPI  R30,LOW(0x3)
	BRNE _0x154
	LDI  R30,LOW(3)
	RJMP _0x3B6
; 0000 02A3                 case 4: tis= 3 ;sot='_';des= 2 ;break;
_0x154:
	CPI  R30,LOW(0x4)
	BRNE _0x155
	LDI  R30,LOW(3)
	CALL SUBOPT_0x4B
	RJMP _0x3B5
; 0000 02A4                 case 5: tis='p';sot='_';des='_';break;
_0x155:
	CPI  R30,LOW(0x5)
	BRNE _0x156
	CALL SUBOPT_0x4C
	RJMP _0x3B5
; 0000 02A5                 case 6: tis='c';sot='_';des='_';break;
_0x156:
	CPI  R30,LOW(0x6)
	BRNE _0x157
	CALL SUBOPT_0x4D
	RJMP _0x3B5
; 0000 02A6                 case 1: tis='У';sot='_';des= 1 ;break;
_0x157:
; 0000 02A7                 default:tis='У';sot='_';des= 1 ;break;
_0x3B7:
	LDI  R30,LOW(211)
_0x3B6:
	STS  _tis,R30
	LDI  R30,LOW(95)
	STS  _sot,R30
	LDI  R30,LOW(1)
_0x3B5:
	STS  _des,R30
; 0000 02A8                 }
; 0000 02A9         set_digit_on(tis,sot,des,ed);        set_digit_off(tis,sot,des,ed);
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 02AA         set_led_on(0,0,0,0,0,0,0,0);         set_led_off(0,0,0,0,0,0,0,0);
	CALL SUBOPT_0x48
	CALL SUBOPT_0x38
	CALL SUBOPT_0x47
	CALL _set_led_off
; 0000 02AB         delay_ms(500);
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	CALL SUBOPT_0x3C
; 0000 02AC 
; 0000 02AD         data_register=reg[0][count_register];
	CALL SUBOPT_0x4E
	CALL SUBOPT_0x4F
	CALL SUBOPT_0x3E
; 0000 02AE //        if ((data_register>MAX_MIN[count_register,1])||(data_register<MAX_MIN[count_register,0])) data_register=FAKTORY[count_register];//проверка граничных значений
; 0000 02AF 
; 0000 02B0 //        save_reg(data_register,count_register);
; 0000 02B1 
; 0000 02B2         switch (count_register)
	LDS  R30,_count_register
; 0000 02B3                 {
; 0000 02B4                 case 2: count_register=3;point=work_point;break;
	CPI  R30,LOW(0x2)
	BRNE _0x15D
	LDI  R30,LOW(3)
	RJMP _0x3B8
; 0000 02B5                 case 3: count_register=4;point=1;break;
_0x15D:
	CPI  R30,LOW(0x3)
	BRNE _0x15E
	LDI  R30,LOW(4)
	STS  _count_register,R30
	LDI  R30,LOW(1)
	RJMP _0x3B9
; 0000 02B6                 case 4: count_register=5;point=1;break;
_0x15E:
	CPI  R30,LOW(0x4)
	BRNE _0x15F
	LDI  R30,LOW(5)
	STS  _count_register,R30
	LDI  R30,LOW(1)
	RJMP _0x3B9
; 0000 02B7                 case 5: count_register=6;point=1;break;
_0x15F:
	CPI  R30,LOW(0x5)
	BRNE _0x160
	LDI  R30,LOW(6)
	STS  _count_register,R30
	LDI  R30,LOW(1)
	RJMP _0x3B9
; 0000 02B8                 case 6: count_register=1;point=1;break;
_0x160:
	CPI  R30,LOW(0x6)
	BRNE _0x161
	LDI  R30,LOW(1)
	STS  _count_register,R30
	RJMP _0x3B9
; 0000 02B9                 case 1: count_register=2;point=work_point;break;
_0x161:
; 0000 02BA                 default:count_register=2;point=work_point;break;
_0x3BA:
	LDI  R30,LOW(2)
_0x3B8:
	STS  _count_register,R30
	LDS  R30,_work_point
_0x3B9:
	STS  _point,R30
; 0000 02BB                 }
; 0000 02BC         hex2dec(data_register);
	CALL SUBOPT_0x50
; 0000 02BD         set_digit_on(tis,sot,des,ed);        set_digit_off(tis,sot,des,ed);
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x2B
	CALL _set_digit_off
; 0000 02BE         if (point==1)       {set_led_on(0,0,0,0,0,0,0,0);set_led_off(0,0,0,0,0,0,0,0);}
	LDS  R26,_point
	CPI  R26,LOW(0x1)
	BRNE _0x164
	CALL SUBOPT_0x38
	CALL SUBOPT_0x38
	CALL SUBOPT_0x47
	CALL SUBOPT_0x48
	LDI  R30,LOW(0)
	ST   -Y,R30
	RJMP _0x3BB
; 0000 02BF         else if (point==2)  {set_led_on(0,0,0,0,0,0,1,0);set_led_off(0,0,0,0,0,0,1,0);}
_0x164:
	LDS  R26,_point
	CPI  R26,LOW(0x2)
	BRNE _0x166
	CALL SUBOPT_0x38
	CALL SUBOPT_0x38
	CALL SUBOPT_0x51
	CALL SUBOPT_0x38
	LDI  R30,LOW(1)
	RJMP _0x3BC
; 0000 02C0         else if (point==3)  {set_led_on(0,0,0,0,0,1,0,0);set_led_off(0,0,0,0,0,1,0,0);}
_0x166:
	LDS  R26,_point
	CPI  R26,LOW(0x3)
	BRNE _0x168
	CALL SUBOPT_0x38
	CALL SUBOPT_0x47
	CALL SUBOPT_0x52
	CALL SUBOPT_0x48
	CALL SUBOPT_0x47
	LDI  R30,LOW(1)
	RJMP _0x3BD
; 0000 02C1         else if (point==4)  {set_led_on(0,0,0,0,1,0,0,0);set_led_off(0,0,0,0,1,0,0,0);}
_0x168:
	LDS  R26,_point
	CPI  R26,LOW(0x4)
	BRNE _0x16A
	CALL SUBOPT_0x38
	CALL SUBOPT_0x53
	CALL SUBOPT_0x38
	CALL SUBOPT_0x48
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
_0x3BB:
	ST   -Y,R30
	LDI  R30,LOW(0)
_0x3BD:
	ST   -Y,R30
	LDI  R30,LOW(0)
_0x3BC:
	ST   -Y,R30
	CALL SUBOPT_0x54
; 0000 02C2         delay_ms(500);
_0x16A:
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	CALL SUBOPT_0x3C
; 0000 02C3         }
	RJMP _0x14D
_0x14F:
; 0000 02C4 a1:
; 0000 02C5 UBRRH=0x00;UBRRL=0x5f;UCSRB=0xD8;UCSRC=0x86;UCSRA=0x02;
	LDI  R30,LOW(0)
	OUT  0x20,R30
	LDI  R30,LOW(95)
	OUT  0x9,R30
	LDI  R30,LOW(216)
	OUT  0xA,R30
	LDI  R30,LOW(134)
	OUT  0x20,R30
	LDI  R30,LOW(2)
	OUT  0xB,R30
; 0000 02C6 crc=0xffff;
	CALL SUBOPT_0x26
; 0000 02C7 power=1;
	SBI  0x12,3
; 0000 02C8 
; 0000 02C9 
; 0000 02CA key_mode_press=0;
	CLT
	BLD  R3,3
; 0000 02CB key_plus_press=0;
	BLD  R3,4
; 0000 02CC key_mines_press=0;
	BLD  R3,5
; 0000 02CD key_enter_press=0;
	BLD  R3,6
; 0000 02CE key_mode_press_switch=0;
	BLD  R3,7
; 0000 02CF key_plus_press_switch=0;
	BLD  R4,0
; 0000 02D0 key_minus_press_switch=0;
	BLD  R4,1
; 0000 02D1 
; 0000 02D2 #asm("sei")
	sei
; 0000 02D3 mode=0;
	LDI  R30,LOW(0)
	STS  _mode,R30
; 0000 02D4 x=0;
	STS  _x,R30
	STS  _x+1,R30
	STS  _x+2,R30
	STS  _x+3,R30
; 0000 02D5 start_time=sys_time;
	CALL SUBOPT_0x55
; 0000 02D6 k_k=reg[0][A_16];
	__POINTW2MN _reg,88
	CALL __EEPROMRDD
	__PUTD1S 50
; 0000 02D7 
; 0000 02D8 point=ee_point;
	CALL SUBOPT_0x27
; 0000 02D9 work_point=point;
	CALL SUBOPT_0x46
; 0000 02DA ti_en=0;
	CLT
	BLD  R2,1
; 0000 02DB //tmpVal=UBRRL;
; 0000 02DC rx_wr_index=0;
	CLR  R11
; 0000 02DD tx_buffer_begin=0;
	CLR  R13
; 0000 02DE tx_buffer_end=0;
	CLR  R12
; 0000 02DF //-------------------------------------------------------------------//
; 0000 02E0 while (1)
_0x16E:
; 0000 02E1         {
; 0000 02E2         #asm("wdr");
	wdr
; 0000 02E3         adc_filter=izm();
	RCALL _izm
	__PUTD1S 54
; 0000 02E4 //        adc_filter=1234;
; 0000 02E5         //-------------------------------------------------------------------//
; 0000 02E6         //абсолютная величина
; 0000 02E7         //-------------------------------------------------------------------//
; 0000 02E8         i=reg[0][A_12];
	CALL SUBOPT_0x16
; 0000 02E9         switch (i)
; 0000 02EA                 {
; 0000 02EB                 case 0: adc_value1=adc_filter*k_k*20/3606;break;//4-20mA 20=4.4   =3606 k=20/3606
	BRNE _0x174
	CALL SUBOPT_0x56
	CALL SUBOPT_0x57
	RJMP _0x3BE
; 0000 02EC                 case 1: adc_value1=adc_filter*k_k* 5/3606;break;//0-5mA   5=4.4   =3606 k= 5/3606
_0x174:
	CPI  R30,LOW(0x1)
	BRNE _0x175
	CALL SUBOPT_0x56
	__GETD2N 0x40A00000
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x45616000
	RJMP _0x3BE
; 0000 02ED                 case 2: adc_value1=adc_filter*k_k*20/3606;break;//0-20mA 20=4.4   =3606 k=20/3606
_0x175:
	CPI  R30,LOW(0x2)
	BRNE _0x176
	CALL SUBOPT_0x56
	CALL SUBOPT_0x57
	RJMP _0x3BE
; 0000 02EE                 case 3: adc_value1=adc_filter*k_k*10/3691;break;//0-10V  10=4.506 =3606 k=10/3691
_0x176:
	CPI  R30,LOW(0x3)
	BRNE _0x178
	CALL SUBOPT_0x56
	__GETD2N 0x41200000
	RJMP _0x3BF
; 0000 02EF                 default:adc_value1=adc_filter*k_k* 5/3691;break;//0-5V    5=4.506 =3606 k= 5/3691
_0x178:
	CALL SUBOPT_0x56
	__GETD2N 0x40A00000
_0x3BF:
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x4566B000
_0x3BE:
	CALL __DIVF21
	STS  _adc_value1,R30
	STS  _adc_value1+1,R31
	STS  _adc_value1+2,R22
	STS  _adc_value1+3,R23
; 0000 02F0                 }
; 0000 02F1 
; 0000 02F2 
; 0000 02F3 
; 0000 02F4 //        if (reg[0,A_12]<3) adc_value1=adc_filter*k_k/100;
; 0000 02F5 //        else adc_value1=adc_filter*k_k/200;
; 0000 02F6         //-------------------------------------------------------------------//
; 0000 02F7         //относительная величина
; 0000 02F8         //-------------------------------------------------------------------//
; 0000 02F9         i=reg[0][A_12];
	CALL SUBOPT_0x16
; 0000 02FA         switch (i)
; 0000 02FB                 {
; 0000 02FC                 case 0:
	BRNE _0x17C
; 0000 02FD                     kk=(reg[0][A_07]-reg[0][A_06])/(20-4);
	CALL SUBOPT_0x3D
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x58
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x59
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x41800000
	CALL SUBOPT_0x5A
; 0000 02FE                     bb=reg[0][A_06]-kk*4;
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x5B
	CALL SUBOPT_0x5C
	CALL __MULF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x59
	CALL SUBOPT_0x5D
; 0000 02FF                     dop1=4;
	CALL SUBOPT_0x5C
	__PUTD1S 38
; 0000 0300                     dop2=20;
	CALL SUBOPT_0x5E
	RJMP _0x3C0
; 0000 0301                     break;//4-20mA
; 0000 0302                 case 1:
_0x17C:
	CPI  R30,LOW(0x1)
	BRNE _0x17D
; 0000 0303                     kk=(reg[0][A_07]-reg[0][A_06])/( 5-0);
	CALL SUBOPT_0x3D
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x58
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x59
	CALL SUBOPT_0x5F
; 0000 0304                     bb=reg[0][A_06]-kk*0;
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x60
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RJMP _0x3C1
; 0000 0305                     dop1=0;
; 0000 0306                     dop2= 5;
; 0000 0307                     break;//0-5mA
; 0000 0308                 case 2:
_0x17D:
	CPI  R30,LOW(0x2)
	BRNE _0x17E
; 0000 0309                     kk=(reg[0][A_07]-reg[0][A_06])/(20-0);
	CALL SUBOPT_0x3D
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x58
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x59
	MOVW R26,R30
	MOVW R24,R22
	CALL SUBOPT_0x5E
	CALL SUBOPT_0x5A
; 0000 030A                     bb=reg[0][A_06]-kk*0;
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x60
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x59
	CALL SUBOPT_0x61
; 0000 030B                     dop1=0;
; 0000 030C                     dop2=20;
	CALL SUBOPT_0x5E
	RJMP _0x3C0
; 0000 030D                     break;//0-20mA
; 0000 030E                 case 3:
_0x17E:
	CPI  R30,LOW(0x3)
	BRNE _0x180
; 0000 030F                     kk=(reg[0][A_07]-reg[0][A_06])/(10-0);
	CALL SUBOPT_0x3D
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x58
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x59
	MOVW R26,R30
	MOVW R24,R22
	CALL SUBOPT_0x62
	CALL SUBOPT_0x5A
; 0000 0310                     bb=reg[0][A_06]-kk*0;
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x60
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x59
	CALL SUBOPT_0x61
; 0000 0311                     dop1=0;
; 0000 0312                     dop2=10;
	CALL SUBOPT_0x62
	RJMP _0x3C0
; 0000 0313                     break;//0-10V
; 0000 0314                 default:
_0x180:
; 0000 0315                     kk=(reg[0][A_07]-reg[0][A_06])/( 5-0);
	CALL SUBOPT_0x3D
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x58
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x59
	CALL SUBOPT_0x5F
; 0000 0316                     bb=reg[0][A_06]-kk*0;
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x60
	POP  R26
	POP  R27
	POP  R24
	POP  R25
_0x3C1:
	CALL __SWAPD12
	CALL __SUBF12
	CALL SUBOPT_0x61
; 0000 0317                     dop1=0;
; 0000 0318                     dop2= 5;
	__GETD1N 0x40A00000
_0x3C0:
	__PUTD1S 34
; 0000 0319                     break;//0-5V
; 0000 031A                 }
; 0000 031B         adc_value2=adc_value1*kk+bb;
	__GETD1S 46
	CALL SUBOPT_0x63
	CALL SUBOPT_0x64
; 0000 031C 
; 0000 031D         //-------------------------------------------------------------------//
; 0000 031E         //авария
; 0000 031F         //-------------------------------------------------------------------//
; 0000 0320 
; 0000 0321         if (adc_value1<(dop1*(1-reg[0][A_08]/100)))//потестить с adc_value2
	CALL SUBOPT_0x65
	CALL SUBOPT_0x66
	CALL SUBOPT_0x63
	CALL __CMPF12
	BRSH _0x181
; 0000 0322                 {
; 0000 0323                 avaria=1;
	SET
	BLD  R4,3
; 0000 0324                 adc_value2=(dop1*(1-reg[0][A_08]/100))*kk+bb;
	CALL SUBOPT_0x65
	CALL SUBOPT_0x66
	CALL SUBOPT_0x5B
	CALL SUBOPT_0x64
; 0000 0325                 }
; 0000 0326         else if (adc_value2>(dop2*(1+reg[0][A_09]/100)))
	RJMP _0x182
_0x181:
	CALL SUBOPT_0x67
	CALL SUBOPT_0x68
	BREQ PC+2
	BRCC PC+3
	JMP  _0x183
; 0000 0327                 {
; 0000 0328                 avaria=1;
	SET
	BLD  R4,3
; 0000 0329                 adc_value2=(dop2*(1+reg[0][A_09]/100))*kk+bb;
	CALL SUBOPT_0x67
	CALL SUBOPT_0x5B
	CALL SUBOPT_0x64
; 0000 032A                 }
; 0000 032B         else avaria=0;
	RJMP _0x184
_0x183:
	CLT
	BLD  R4,3
; 0000 032C 
; 0000 032D 
; 0000 032E //         if (adc_value2<(reg[0,A_06]*(1-reg[0,A_08]/100)))
; 0000 032F //                 {avaria=1;adc_value2=reg[0,A_06]*(1-reg[0,A_08]/100);}
; 0000 0330 //         else if (adc_value2>(reg[0,A_07]*(1+reg[0,A_09]/100)))
; 0000 0331 //                 {avaria=1;adc_value2=reg[0,A_07]*(1+reg[0,A_09]/100);}
; 0000 0332 //         else avaria=0;
; 0000 0333 
; 0000 0334         //-------------------------------------------------------------------//
; 0000 0335 
; 0000 0336 
; 0000 0337         //-------------------------------------------------------------------//
; 0000 0338         //уставка 1,2
; 0000 0339         //-------------------------------------------------------------------//
; 0000 033A         if ((alarm1==1)&&(alarm_alarm1==1)){
_0x184:
_0x182:
	SBRS R4,4
	RJMP _0x186
	SBRC R4,6
	RJMP _0x187
_0x186:
	RJMP _0x185
_0x187:
; 0000 033B         switch(key_enter_press){
	LDI  R30,0
	SBRC R3,6
	LDI  R30,1
; 0000 033C         case 1:
	CPI  R30,LOW(0x1)
	BRNE _0x193
; 0000 033D                 if (adc_value2>gis_val1){//if (adc_value2>(reg[0,Y_01]*(1+reg[0,A_01]/100))) {
	CALL SUBOPT_0x69
	BREQ PC+2
	BRCC PC+3
	JMP  _0x18C
; 0000 033E                          alarm1=1;
	SET
	BLD  R4,4
; 0000 033F                         gis_val1=(reg[0][Y_01])*(1-reg[0][A_01]/100);}
	CALL SUBOPT_0x24
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x6A
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __MULF12
	RJMP _0x3C2
; 0000 0340                 else
_0x18C:
; 0000 0341                         {
; 0000 0342                          alarm1=0;flag_start_pause1=0;
	CALL SUBOPT_0x6B
; 0000 0343                         if ((reg[0][P___]==0)||(reg[0][P___]==1)&&(reg[0][A_14]==0))alarm_alarm1=0;
	BREQ _0x18F
	CALL SUBOPT_0x6C
	BRNE _0x190
	CALL SUBOPT_0x6D
	BREQ _0x18F
_0x190:
	RJMP _0x18E
_0x18F:
	CLT
	BLD  R4,6
; 0000 0344                         gis_val1=(reg[0][Y_01]);
_0x18E:
	CALL SUBOPT_0x24
_0x3C2:
	__PUTD1S 30
; 0000 0345                         }
; 0000 0346                         key_enter_press=0;
	CLT
	BLD  R3,6
; 0000 0347                 break;
; 0000 0348         default:      break;}}
_0x193:
; 0000 0349         else   {
	RJMP _0x194
_0x185:
; 0000 034A                         if (adc_value2>gis_val1){//if (adc_value2>(reg[0,Y_01]*(1+reg[0,A_01]/100))) {
	CALL SUBOPT_0x69
	BREQ PC+2
	BRCC PC+3
	JMP  _0x195
; 0000 034B                          alarm1=1;
	SET
	BLD  R4,4
; 0000 034C                         gis_val1=(reg[0][Y_01])*(1-reg[0][A_01]/100);}
	CALL SUBOPT_0x24
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x6A
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __MULF12
	RJMP _0x3C3
; 0000 034D                         else
_0x195:
; 0000 034E                         {
; 0000 034F                          alarm1=0;flag_start_pause1=0;
	CALL SUBOPT_0x6B
; 0000 0350                         if ((reg[0][P___]==0)||(reg[0][P___]==1)&&(reg[0][A_14]==0))alarm_alarm1=0;
	BREQ _0x198
	CALL SUBOPT_0x6C
	BRNE _0x199
	CALL SUBOPT_0x6D
	BREQ _0x198
_0x199:
	RJMP _0x197
_0x198:
	CLT
	BLD  R4,6
; 0000 0351                         gis_val1=(reg[0][Y_01]);
_0x197:
	CALL SUBOPT_0x24
_0x3C3:
	__PUTD1S 30
; 0000 0352                         }
; 0000 0353                        // key_enter_press_switch1=0;
; 0000 0354                 }
_0x194:
; 0000 0355         if ((alarm2==1)&&(alarm_alarm2==1)){
	SBRS R4,5
	RJMP _0x19D
	SBRC R4,7
	RJMP _0x19E
_0x19D:
	RJMP _0x19C
_0x19E:
; 0000 0356         switch(key_enter_press){
	LDI  R30,0
	SBRC R3,6
	LDI  R30,1
; 0000 0357         case 1:
	CPI  R30,LOW(0x1)
	BRNE _0x1AA
; 0000 0358                         if (adc_value2>gis_val2)//if (adc_value2>(reg[0,Y_02]*(1+reg[0,A_01]/100)))
	CALL SUBOPT_0x6E
	BREQ PC+2
	BRCC PC+3
	JMP  _0x1A3
; 0000 0359                                 {alarm2=1;
	SET
	BLD  R4,5
; 0000 035A                                 gis_val2=(reg[0][Y_02])*(1-reg[0][A_01]/100);}
	CALL SUBOPT_0x25
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x6A
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __MULF12
	RJMP _0x3C4
; 0000 035B                         else
_0x1A3:
; 0000 035C                                 {
; 0000 035D                                 alarm2=0;flag_start_pause2=0;
	CALL SUBOPT_0x6F
; 0000 035E                                 if ((reg[0][P___]==0)||(reg[0][P___]==1)&&(reg[0][A_15]==0))alarm_alarm2=0;
	BREQ _0x1A6
	CALL SUBOPT_0x6C
	BRNE _0x1A7
	CALL SUBOPT_0x70
	BREQ _0x1A6
_0x1A7:
	RJMP _0x1A5
_0x1A6:
	CLT
	BLD  R4,7
; 0000 035F                                 gis_val2=(reg[0][Y_02]);
_0x1A5:
	CALL SUBOPT_0x25
_0x3C4:
	__PUTD1S 26
; 0000 0360                                 }
; 0000 0361                        key_enter_press=0;
	CLT
	BLD  R3,6
; 0000 0362                 break;
; 0000 0363         default: break;}}
_0x1AA:
; 0000 0364         else {
	RJMP _0x1AB
_0x19C:
; 0000 0365                 if (adc_value2>gis_val2)//if (adc_value2>(reg[0,Y_02]*(1+reg[0,A_01]/100)))
	CALL SUBOPT_0x6E
	BREQ PC+2
	BRCC PC+3
	JMP  _0x1AC
; 0000 0366                    {alarm2=1;
	SET
	BLD  R4,5
; 0000 0367                    gis_val2=(reg[0][Y_02])*(1-reg[0][A_01]/100);}
	CALL SUBOPT_0x25
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x6A
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __MULF12
	RJMP _0x3C5
; 0000 0368                 else
_0x1AC:
; 0000 0369                    {
; 0000 036A                    alarm2=0;flag_start_pause2=0;
	CALL SUBOPT_0x6F
; 0000 036B                    if ((reg[0][P___]==0)||(reg[0][P___]==1)&&(reg[0][A_15]==0))alarm_alarm2=0;
	BREQ _0x1AF
	CALL SUBOPT_0x6C
	BRNE _0x1B0
	CALL SUBOPT_0x70
	BREQ _0x1AF
_0x1B0:
	RJMP _0x1AE
_0x1AF:
	CLT
	BLD  R4,7
; 0000 036C                    gis_val2=(reg[0][Y_02]);
_0x1AE:
	CALL SUBOPT_0x25
_0x3C5:
	__PUTD1S 26
; 0000 036D                    }
; 0000 036E                // key_enter_press_switch1=0;
; 0000 036F               }
_0x1AB:
; 0000 0370         //-------------------------------------------------------------------//
; 0000 0371         //
; 0000 0372         //добавить маску и блокировку
; 0000 0373         //
; 0000 0374         //-------------------------------------------------------------------//
; 0000 0375 
; 0000 0376 
; 0000 0377 
; 0000 0378         //-------------------------------------------------------------------//
; 0000 0379 
; 0000 037A         //-------------------------------------------------------------------//
; 0000 037B         //пауза 1,2
; 0000 037C         //-------------------------------------------------------------------//
; 0000 037D         if (alarm_alarm1==1){relay_alarm1=1;}
	SBRS R4,6
	RJMP _0x1B3
	SBI  0x18,0
; 0000 037E         else relay_alarm1=0;
	RJMP _0x1B6
_0x1B3:
	CBI  0x18,0
; 0000 037F         if (alarm_alarm2==1){relay_alarm2=1;}
_0x1B6:
	SBRS R4,7
	RJMP _0x1B9
	SBI  0x18,1
; 0000 0380         else relay_alarm2=0;
	RJMP _0x1BC
_0x1B9:
	CBI  0x18,1
; 0000 0381 
; 0000 0382         if ((flag_start_pause1==1))//&&(alarm_alarm1==0))
_0x1BC:
	SBRS R15,0
	RJMP _0x1BF
; 0000 0383                 {
; 0000 0384                 if ((sys_time-time_pause1)>(reg[0][Z_01]*800)){alarm_alarm1=1;}
	__GETD1SX 66
	CALL SUBOPT_0x71
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__POINTW2MN _reg,12
	CALL SUBOPT_0x72
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x1C0
	SET
	BLD  R4,6
; 0000 0385                 }
_0x1C0:
; 0000 0386         else if (alarm1==1)
	RJMP _0x1C1
_0x1BF:
	SBRS R4,4
	RJMP _0x1C2
; 0000 0387                 {
; 0000 0388                 if ( ( (reg[0][C___]==1) && (reg[0][A_02]==1) ) ){signal=1;buzer_buzer_en=1;}
	CALL SUBOPT_0x73
	CALL SUBOPT_0x6C
	BRNE _0x1C4
	CALL SUBOPT_0x74
	CALL SUBOPT_0x6C
	BREQ _0x1C5
_0x1C4:
	RJMP _0x1C3
_0x1C5:
	SET
	BLD  R5,2
	BLD  R2,6
; 0000 0389                 if ( (reg[0][P___]==0) || ( (reg[0][P___]==1) && (reg[0][A_03]==1) ) )
_0x1C3:
	CALL SUBOPT_0x75
	BREQ _0x1C7
	CALL SUBOPT_0x6C
	BRNE _0x1C8
	__POINTW2MN _reg,36
	CALL __EEPROMRDD
	CALL SUBOPT_0x6C
	BREQ _0x1C7
_0x1C8:
	RJMP _0x1C6
_0x1C7:
; 0000 038A                         {
; 0000 038B                         time_pause1=sys_time;
	CALL SUBOPT_0x3
	CALL __CDF1
	__PUTD1SX 66
; 0000 038C                         flag_start_pause1=1;
	SET
	BLD  R15,0
; 0000 038D                         }
; 0000 038E                 }
_0x1C6:
; 0000 038F         if ((alarm1==0)&&(alarm2==0))
_0x1C2:
_0x1C1:
	LDI  R26,0
	SBRC R4,4
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0x1CC
	LDI  R26,0
	SBRC R4,5
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BREQ _0x1CD
_0x1CC:
	RJMP _0x1CB
_0x1CD:
; 0000 0390                 {
; 0000 0391                 if (((alarm_alarm1==0)||((alarm_alarm1==1)&&(reg[0][A_14]==0)))&&((alarm_alarm2==0)||((alarm_alarm2==1)&&(reg[0][A_15]==0)))){signal=0;buzer_buzer_en=0;}
	CALL SUBOPT_0xB
	BREQ _0x1CF
	SBRS R4,6
	RJMP _0x1D0
	CALL SUBOPT_0x6D
	BREQ _0x1CF
_0x1D0:
	RJMP _0x1D3
_0x1CF:
	CALL SUBOPT_0xA
	BREQ _0x1D4
	SBRS R4,7
	RJMP _0x1D5
	CALL SUBOPT_0x70
	BREQ _0x1D4
_0x1D5:
	RJMP _0x1D3
_0x1D4:
	RJMP _0x1D8
_0x1D3:
	RJMP _0x1CE
_0x1D8:
	CLT
	BLD  R5,2
	BLD  R2,6
; 0000 0392                 if ((blok1==0)&&(blok2==0)){signal=0;buzer_buzer_en=0;}
_0x1CE:
	LDI  R26,0
	SBRC R5,0
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0x1DA
	LDI  R26,0
	SBRC R5,1
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BREQ _0x1DB
_0x1DA:
	RJMP _0x1D9
_0x1DB:
	CLT
	BLD  R5,2
	BLD  R2,6
; 0000 0393                 }
_0x1D9:
; 0000 0394         if (reg[0][C___]==0)buzer_buzer_en=0;
_0x1CB:
	CALL SUBOPT_0x73
	CALL __CPD10
	BRNE _0x1DC
	CLT
	BLD  R2,6
; 0000 0395         if ((flag_start_pause2==1))//&&(alarm_alarm2==0))
_0x1DC:
	SBRS R15,1
	RJMP _0x1DD
; 0000 0396                 {
; 0000 0397                 if ((sys_time-time_pause2)>(reg[0][Z_02]*800))alarm_alarm2=1;
	__GETD1SX 62
	CALL SUBOPT_0x71
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__POINTW2MN _reg,16
	CALL SUBOPT_0x72
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x1DE
	SET
	BLD  R4,7
; 0000 0398                 }
_0x1DE:
; 0000 0399         else if (alarm2==1)
	RJMP _0x1DF
_0x1DD:
	SBRS R4,5
	RJMP _0x1E0
; 0000 039A                 {
; 0000 039B                 if (((reg[0][C___]==1)&&(reg[0][A_02]==2))){signal=1;buzer_buzer_en=1;}
	CALL SUBOPT_0x73
	CALL SUBOPT_0x6C
	BRNE _0x1E2
	CALL SUBOPT_0x74
	CALL SUBOPT_0x76
	BREQ _0x1E3
_0x1E2:
	RJMP _0x1E1
_0x1E3:
	SET
	BLD  R5,2
	BLD  R2,6
; 0000 039C                 if ((reg[0][P___]==0)||((reg[0][P___]==1)&&(reg[0][A_04]==1)))
_0x1E1:
	CALL SUBOPT_0x75
	BREQ _0x1E5
	CALL SUBOPT_0x6C
	BRNE _0x1E6
	__POINTW2MN _reg,40
	CALL __EEPROMRDD
	CALL SUBOPT_0x6C
	BREQ _0x1E5
_0x1E6:
	RJMP _0x1E4
_0x1E5:
; 0000 039D                         {
; 0000 039E                         time_pause2=sys_time;
	CALL SUBOPT_0x3
	CALL __CDF1
	__PUTD1SX 62
; 0000 039F                         flag_start_pause2=1;
	SET
	BLD  R15,1
; 0000 03A0                         }
; 0000 03A1                 }
_0x1E4:
; 0000 03A2         //-------------------------------------------------------------------//
; 0000 03A3 
; 0000 03A4 
; 0000 03A5 
; 0000 03A6 
; 0000 03A7 
; 0000 03A8 
; 0000 03A9 
; 0000 03AA 
; 0000 03AB 
; 0000 03AC 
; 0000 03AD 
; 0000 03AE 
; 0000 03AF         //-------------------------------------------------------------------//
; 0000 03B0         //      МЕНЮ
; 0000 03B1         //-------------------------------------------------------------------//
; 0000 03B2         //возврат из меню
; 0000 03B3         //-------------------------------------------------------------------//
; 0000 03B4         if (((sys_time-start_time_mode)>reg[0][A_13]*1000)){mode=0;f_m1=0;}
_0x1E0:
_0x1DF:
	LDS  R26,_start_time_mode
	LDS  R27,_start_time_mode+1
	LDS  R24,_start_time_mode+2
	LDS  R25,_start_time_mode+3
	CALL SUBOPT_0x18
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__POINTW2MN _reg,76
	CALL __EEPROMRDD
	CALL SUBOPT_0x33
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __CDF2
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x1E9
	LDI  R30,LOW(0)
	STS  _mode,R30
	CLT
	BLD  R15,2
; 0000 03B5         //-------------------------------------------------------------------//
; 0000 03B6 
; 0000 03B7 
; 0000 03B8 
; 0000 03B9         if ((key_enter_press_switch==1)&&(mode==0)){key_enter_press_switch=0;key_enter_press_switch1=1;}
_0x1E9:
	SBRS R4,2
	RJMP _0x1EB
	LDS  R26,_mode
	CPI  R26,LOW(0x0)
	BREQ _0x1EC
_0x1EB:
	RJMP _0x1EA
_0x1EC:
	CLT
	BLD  R4,2
	SET
	BLD  R15,3
; 0000 03BA 
; 0000 03BB 
; 0000 03BC         //-------------------------------------------------------------------//
; 0000 03BD         //вход в инженерное меню
; 0000 03BE         //-------------------------------------------------------------------//
; 0000 03BF         if ((key_enter_press_switch1==1)&&(key_enter==1)&&(key_mode==0))
_0x1EA:
	SBRS R15,3
	RJMP _0x1EE
	SBRS R3,2
	RJMP _0x1EE
	LDI  R26,0
	SBRC R2,7
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BREQ _0x1EF
_0x1EE:
	RJMP _0x1ED
_0x1EF:
; 0000 03C0                 {if ((sys_time-whait_time)>1500){mode=10;start_time_mode=sys_time;key_enter_press_switch1=0;}}
	CALL SUBOPT_0x77
	CALL SUBOPT_0x78
	BRLT _0x1F0
	LDI  R30,LOW(10)
	STS  _mode,R30
	CALL SUBOPT_0x79
	CLT
	BLD  R15,3
_0x1F0:
; 0000 03C1         //-------------------------------------------------------------------//
; 0000 03C2 
; 0000 03C3         //-------------------------------------------------------------------//
; 0000 03C4         //Ожидание выключения питания
; 0000 03C5         //-------------------------------------------------------------------//
; 0000 03C6         if ((key_enter_press_switch1==1)&&(key_enter==1)&&(key_mode==1)&&(key_2==1)&&(key_3==1))
_0x1ED:
	SBRS R15,3
	RJMP _0x1F2
	SBRS R3,2
	RJMP _0x1F2
	SBRS R2,7
	RJMP _0x1F2
	SBIS 0x13,1
	RJMP _0x1F2
	SBIC 0x10,6
	RJMP _0x1F3
_0x1F2:
	RJMP _0x1F1
_0x1F3:
; 0000 03C7                 {if ((sys_time-whait_time)>1500) {goto power_off;}}
	CALL SUBOPT_0x77
	CALL SUBOPT_0x78
	BRLT _0x1F4
	RJMP _0x12F
_0x1F4:
; 0000 03C8         //-------------------------------------------------------------------//
; 0000 03C9 
; 0000 03CA         //-------------------------------------------------------------------//
; 0000 03CB         //что показывать в mode=0
; 0000 03CC         //-------------------------------------------------------------------//
; 0000 03CD         if (mode==0)
_0x1F1:
	LDS  R30,_mode
	CPI  R30,0
	BREQ PC+3
	JMP _0x1F5
; 0000 03CE                 {
; 0000 03CF                 count_register=1;
	LDI  R30,LOW(1)
	STS  _count_register,R30
; 0000 03D0                 point=work_point;
	LDS  R30,_work_point
	STS  _point,R30
; 0000 03D1                 if (((alarm_alarm1==0)||((alarm_alarm1==1)&&(reg[0][A_14]==0)))&&((alarm_alarm2==0)||((alarm_alarm2==1)&&(reg[0][A_15]==0))))
	CALL SUBOPT_0xB
	BREQ _0x1F7
	SBRS R4,6
	RJMP _0x1F8
	CALL SUBOPT_0x6D
	BREQ _0x1F7
_0x1F8:
	RJMP _0x1FB
_0x1F7:
	CALL SUBOPT_0xA
	BREQ _0x1FC
	SBRS R4,7
	RJMP _0x1FD
	CALL SUBOPT_0x70
	BREQ _0x1FC
_0x1FD:
	RJMP _0x1FB
_0x1FC:
	RJMP _0x200
_0x1FB:
	RJMP _0x1F6
_0x200:
; 0000 03D2                         {
; 0000 03D3                         if (reg[0][A_05]==0)adc_value3=adc_value1;
	CALL SUBOPT_0x7A
	CALL __CPD10
	BRNE _0x201
	CALL SUBOPT_0x7B
	RJMP _0x3C6
; 0000 03D4                         else if (reg[0][A_05]==2){adc_value3=buf[buf_end];point=1;}
_0x201:
	CALL SUBOPT_0x7A
	CALL SUBOPT_0x76
	BRNE _0x203
	CALL SUBOPT_0x19
	CALL SUBOPT_0x20
	LDI  R26,LOW(_adc_value3)
	LDI  R27,HIGH(_adc_value3)
	CALL SUBOPT_0x22
	CALL __PUTDP1
	LDI  R30,LOW(1)
	STS  _point,R30
; 0000 03D5                         else adc_value3=adc_value2;
	RJMP _0x204
_0x203:
	CALL SUBOPT_0x7C
_0x3C6:
	STS  _adc_value3,R30
	STS  _adc_value3+1,R31
	STS  _adc_value3+2,R22
	STS  _adc_value3+3,R23
; 0000 03D6                         }
_0x204:
; 0000 03D7                 hex2dec(adc_value3);
_0x1F6:
	CALL SUBOPT_0x7D
; 0000 03D8                 if (point==1)       {set_led_on(0,0,0,1,0,0,0,0);set_led_off(0,0,0,1,0,0,0,0);}
	BRNE _0x205
	CALL SUBOPT_0x38
	CALL SUBOPT_0x7E
	CALL SUBOPT_0x7F
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(0)
	RJMP _0x3C7
; 0000 03D9                 else if (point==2)  {set_led_on(0,0,0,1,0,0,1,0);set_led_off(0,0,0,1,0,0,1,0);}
_0x205:
	LDS  R26,_point
	CPI  R26,LOW(0x2)
	BRNE _0x207
	CALL SUBOPT_0x38
	CALL SUBOPT_0x52
	CALL SUBOPT_0x51
	CALL SUBOPT_0x52
	LDI  R30,LOW(1)
	RJMP _0x3C8
; 0000 03DA                 else if (point==3)  {set_led_on(0,0,0,1,0,1,0,0);set_led_off(0,0,0,1,0,1,0,0);}
_0x207:
	LDS  R26,_point
	CPI  R26,LOW(0x3)
	BRNE _0x209
	CALL SUBOPT_0x38
	CALL SUBOPT_0x80
	CALL SUBOPT_0x52
	CALL SUBOPT_0x48
	CALL SUBOPT_0x80
	LDI  R30,LOW(1)
	RJMP _0x3C9
; 0000 03DB                 else if (point==4)  {set_led_on(0,0,0,1,1,0,0,0);set_led_off(0,0,0,1,1,0,0,0);}
_0x209:
	LDS  R26,_point
	CPI  R26,LOW(0x4)
	BRNE _0x20B
	CALL SUBOPT_0x38
	CALL SUBOPT_0x81
	CALL SUBOPT_0x48
	LDI  R30,LOW(1)
	ST   -Y,R30
_0x3C7:
	ST   -Y,R30
	LDI  R30,LOW(0)
_0x3C9:
	ST   -Y,R30
	LDI  R30,LOW(0)
_0x3C8:
	ST   -Y,R30
	CALL SUBOPT_0x54
; 0000 03DC                 }
_0x20B:
; 0000 03DD         //-------------------------------------------------------------------//
; 0000 03DE 
; 0000 03DF         //-------------------------------------------------------------------//
; 0000 03E0         //пользовательское меню
; 0000 03E1         //-------------------------------------------------------------------//
; 0000 03E2         if (mode==1)
_0x1F5:
	LDS  R26,_mode
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x20C
; 0000 03E3                 {
; 0000 03E4                 hex2dec(count_register);
	LDS  R30,_count_register
	CALL SUBOPT_0x82
; 0000 03E5                 ed=' ';
	CALL SUBOPT_0x4A
; 0000 03E6                 switch (count_register)
; 0000 03E7                         {
; 0000 03E8                         case 2: tis='У';sot='_';des= 2 ;set_led_on(0,1,0,1,0,0,0,0);break;
	BRNE _0x210
	LDI  R30,LOW(211)
	STS  _tis,R30
	LDI  R30,LOW(95)
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x53
	LDI  R30,LOW(0)
	RJMP _0x3CA
; 0000 03E9                         case 3: tis= 3 ;sot='_';des= 1 ;set_led_on(0,0,1,1,0,0,0,0);break;
_0x210:
	CPI  R30,LOW(0x3)
	BRNE _0x211
	LDI  R30,LOW(3)
	RJMP _0x3CB
; 0000 03EA                         case 4: tis= 3 ;sot='_';des= 2 ;set_led_on(0,1,0,1,0,0,0,0);break;
_0x211:
	CPI  R30,LOW(0x4)
	BRNE _0x212
	LDI  R30,LOW(3)
	STS  _tis,R30
	LDI  R30,LOW(95)
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x53
	LDI  R30,LOW(0)
	RJMP _0x3CA
; 0000 03EB                         case 5: tis='p';sot='_';des='_';set_led_on(0,0,0,1,0,0,0,0);break;
_0x212:
	CPI  R30,LOW(0x5)
	BRNE _0x213
	CALL SUBOPT_0x4C
	CALL SUBOPT_0x83
	LDI  R30,LOW(0)
	RJMP _0x3CA
; 0000 03EC                         case 6: tis='c';sot='_';des='_';set_led_on(0,0,0,1,0,0,0,0);break;
_0x213:
	CPI  R30,LOW(0x6)
	BRNE _0x215
	CALL SUBOPT_0x4D
	CALL SUBOPT_0x83
	LDI  R30,LOW(0)
	RJMP _0x3CA
; 0000 03ED                         default:tis='У';sot='_';des= 1 ;set_led_on(0,0,1,1,0,0,0,0);break;
_0x215:
	LDI  R30,LOW(211)
_0x3CB:
	STS  _tis,R30
	LDI  R30,LOW(95)
	STS  _sot,R30
	LDI  R30,LOW(1)
	CALL SUBOPT_0x83
	LDI  R30,LOW(1)
_0x3CA:
	ST   -Y,R30
	CALL SUBOPT_0x7E
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _set_led_on
; 0000 03EE                         }
; 0000 03EF                 set_led_off(0,0,0,1,0,0,0,0);
	CALL SUBOPT_0x38
	CALL SUBOPT_0x7E
	CALL SUBOPT_0x54
; 0000 03F0                 }
; 0000 03F1         //-------------------------------------------------------------------//
; 0000 03F2 
; 0000 03F3         //-------------------------------------------------------------------//
; 0000 03F4         //данные пользовательского меню
; 0000 03F5         //-------------------------------------------------------------------//
; 0000 03F6         if (mode==2)
_0x20C:
	LDS  R26,_mode
	CPI  R26,LOW(0x2)
	BREQ PC+3
	JMP _0x216
; 0000 03F7                 {
; 0000 03F8                 if (count_register>6)count_register=1;
	LDS  R26,_count_register
	CPI  R26,LOW(0x7)
	BRLO _0x217
	LDI  R30,LOW(1)
	STS  _count_register,R30
; 0000 03F9                 if (count_register<3)
_0x217:
	LDS  R26,_count_register
	CPI  R26,LOW(0x3)
	BRSH _0x218
; 0000 03FA                 {
; 0000 03FB                          if ((data_register<0))
	LDD  R26,Y+61
	TST  R26
	BRPL _0x219
; 0000 03FC                                 {
; 0000 03FD                                 if (data_register>=-1000)
	CALL SUBOPT_0x3F
	CALL SUBOPT_0x40
	BRLO _0x21A
; 0000 03FE                                    point = 1;
	LDI  R30,LOW(1)
	STS  _point,R30
; 0000 03FF                                  if (data_register>=-100)
_0x21A:
	CALL SUBOPT_0x41
	BRLO _0x21B
; 0000 0400                                     point=2;
	LDI  R30,LOW(2)
	STS  _point,R30
; 0000 0401                                 if (data_register>=-10)
_0x21B:
	CALL SUBOPT_0x42
	BRLO _0x21C
; 0000 0402                                     point=3;
	LDI  R30,LOW(3)
	STS  _point,R30
; 0000 0403                                 }
_0x21C:
; 0000 0404                         else
	RJMP _0x21D
_0x219:
; 0000 0405                                 {
; 0000 0406                                 if (data_register<10)
	CALL SUBOPT_0x43
	BRSH _0x21E
; 0000 0407                                     point=work_point;
	LDS  R30,_work_point
	RJMP _0x3CC
; 0000 0408                                 else if (data_register<100)
_0x21E:
	CALL SUBOPT_0x44
	BRSH _0x220
; 0000 0409                                     point=3;
	LDI  R30,LOW(3)
	RJMP _0x3CC
; 0000 040A                                 else if (data_register<1000)
_0x220:
	CALL SUBOPT_0x45
	BRSH _0x222
; 0000 040B                                     point=2;
	LDI  R30,LOW(2)
	RJMP _0x3CC
; 0000 040C                                 else if (data_register>=1000)
_0x222:
	CALL SUBOPT_0x45
	BRLO _0x224
; 0000 040D                                     point=1;
	LDI  R30,LOW(1)
_0x3CC:
	STS  _point,R30
; 0000 040E                                 }
_0x224:
_0x21D:
; 0000 040F                 }
; 0000 0410                 else point=1;
	RJMP _0x225
_0x218:
	LDI  R30,LOW(1)
	STS  _point,R30
; 0000 0411                 hex2dec(data_register);
_0x225:
	CALL SUBOPT_0x50
; 0000 0412                 if (point==1)       {set_led_on(0,0,0,0,0,0,0,0);set_led_off(0,0,0,0,0,0,0,0);}
	LDS  R26,_point
	CPI  R26,LOW(0x1)
	BRNE _0x226
	CALL SUBOPT_0x38
	CALL SUBOPT_0x38
	CALL SUBOPT_0x47
	CALL SUBOPT_0x48
	LDI  R30,LOW(0)
	ST   -Y,R30
	RJMP _0x3CD
; 0000 0413                 else if (point==2)  {set_led_on(0,0,0,0,0,0,1,0);set_led_off(0,0,0,0,0,0,1,0);}
_0x226:
	LDS  R26,_point
	CPI  R26,LOW(0x2)
	BRNE _0x228
	CALL SUBOPT_0x38
	CALL SUBOPT_0x38
	CALL SUBOPT_0x51
	CALL SUBOPT_0x38
	LDI  R30,LOW(1)
	RJMP _0x3CE
; 0000 0414                 else if (point==3)  {set_led_on(0,0,0,0,0,1,0,0);set_led_off(0,0,0,0,0,1,0,0);}
_0x228:
	LDS  R26,_point
	CPI  R26,LOW(0x3)
	BRNE _0x22A
	CALL SUBOPT_0x38
	CALL SUBOPT_0x47
	CALL SUBOPT_0x52
	CALL SUBOPT_0x48
	CALL SUBOPT_0x47
	LDI  R30,LOW(1)
	RJMP _0x3CF
; 0000 0415                 else if (point==4)  {set_led_on(0,0,0,0,1,0,0,0);set_led_off(0,0,0,0,1,0,0,0);}
_0x22A:
	LDS  R26,_point
	CPI  R26,LOW(0x4)
	BRNE _0x22C
	CALL SUBOPT_0x38
	CALL SUBOPT_0x53
	CALL SUBOPT_0x38
	CALL SUBOPT_0x48
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
_0x3CD:
	ST   -Y,R30
	LDI  R30,LOW(0)
_0x3CF:
	ST   -Y,R30
	LDI  R30,LOW(0)
_0x3CE:
	ST   -Y,R30
	CALL SUBOPT_0x54
; 0000 0416                 }
_0x22C:
; 0000 0417         //-------------------------------------------------------------------//
; 0000 0418 
; 0000 0419         //-------------------------------------------------------------------//
; 0000 041A         //инженерное меню
; 0000 041B         //-------------------------------------------------------------------//
; 0000 041C         if (mode==10)
_0x216:
	LDS  R26,_mode
	CPI  R26,LOW(0xA)
	BRNE _0x22D
; 0000 041D                 {
; 0000 041E                 if (count_register<7) count_register=7;
	LDS  R26,_count_register
	CPI  R26,LOW(0x7)
	BRSH _0x22E
	LDI  R30,LOW(7)
	STS  _count_register,R30
; 0000 041F                 hex2dec(count_register-6);point=1;
_0x22E:
	LDS  R30,_count_register
	SUBI R30,LOW(6)
	CALL SUBOPT_0x82
	LDI  R30,LOW(1)
	STS  _point,R30
; 0000 0420                 if (des==' ') des='_';
	LDS  R26,_des
	CPI  R26,LOW(0x20)
	BRNE _0x22F
	LDI  R30,LOW(95)
	STS  _des,R30
; 0000 0421                 tis='a';sot='_';
_0x22F:
	LDI  R30,LOW(97)
	STS  _tis,R30
	LDI  R30,LOW(95)
	STS  _sot,R30
; 0000 0422                 set_led_on(0,0,0,1,0,0,0,0);
	CALL SUBOPT_0x38
	CALL SUBOPT_0x7E
	CALL SUBOPT_0x7F
; 0000 0423                 set_led_off(0,0,0,1,0,0,0,0);
	CALL SUBOPT_0x7E
	CALL SUBOPT_0x54
; 0000 0424                 }
; 0000 0425         //-------------------------------------------------------------------//
; 0000 0426 
; 0000 0427         //-------------------------------------------------------------------//
; 0000 0428         //калибровка
; 0000 0429         //-------------------------------------------------------------------//
; 0000 042A         if ((mode==11)&&(count_register==A_16))
_0x22D:
	LDS  R26,_mode
	CPI  R26,LOW(0xB)
	BRNE _0x231
	LDS  R26,_count_register
	CPI  R26,LOW(0x16)
	BREQ _0x232
_0x231:
	RJMP _0x230
_0x232:
; 0000 042B                 {
; 0000 042C                 point=work_point;
	LDS  R30,_work_point
	STS  _point,R30
; 0000 042D                 k_k=data_register;
	CALL SUBOPT_0x84
	__PUTD1S 50
; 0000 042E                 if (reg[0][A_05]==0)adc_value3=adc_value1;
	CALL SUBOPT_0x7A
	CALL __CPD10
	BRNE _0x233
	CALL SUBOPT_0x7B
	RJMP _0x3D0
; 0000 042F                 else adc_value3=adc_value2;
_0x233:
	CALL SUBOPT_0x7C
_0x3D0:
	STS  _adc_value3,R30
	STS  _adc_value3+1,R31
	STS  _adc_value3+2,R22
	STS  _adc_value3+3,R23
; 0000 0430                 hex2dec(adc_value3);
	CALL SUBOPT_0x7D
; 0000 0431                 if (point==1)       {set_led_on(0,0,0,1,0,0,0,0);set_led_off(0,0,0,1,0,0,0,0);}
	BRNE _0x235
	CALL SUBOPT_0x38
	CALL SUBOPT_0x7E
	CALL SUBOPT_0x7F
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(0)
	RJMP _0x3D1
; 0000 0432                 else if (point==2)  {set_led_on(0,0,0,1,0,0,1,0);set_led_off(0,0,0,1,0,0,1,0);}
_0x235:
	LDS  R26,_point
	CPI  R26,LOW(0x2)
	BRNE _0x237
	CALL SUBOPT_0x38
	CALL SUBOPT_0x52
	CALL SUBOPT_0x51
	CALL SUBOPT_0x52
	LDI  R30,LOW(1)
	RJMP _0x3D2
; 0000 0433                 else if (point==3)  {set_led_on(0,0,0,1,0,1,0,0);set_led_off(0,0,0,1,0,1,0,0);}
_0x237:
	LDS  R26,_point
	CPI  R26,LOW(0x3)
	BRNE _0x239
	CALL SUBOPT_0x38
	CALL SUBOPT_0x80
	CALL SUBOPT_0x52
	CALL SUBOPT_0x48
	CALL SUBOPT_0x80
	LDI  R30,LOW(1)
	RJMP _0x3D3
; 0000 0434                 else if (point==4)  {set_led_on(0,0,0,1,1,0,0,0);set_led_off(0,0,0,1,1,0,0,0);}
_0x239:
	LDS  R26,_point
	CPI  R26,LOW(0x4)
	BRNE _0x23B
	CALL SUBOPT_0x38
	CALL SUBOPT_0x81
	CALL SUBOPT_0x48
	LDI  R30,LOW(1)
	ST   -Y,R30
_0x3D1:
	ST   -Y,R30
	LDI  R30,LOW(0)
_0x3D3:
	ST   -Y,R30
	LDI  R30,LOW(0)
_0x3D2:
	ST   -Y,R30
	CALL SUBOPT_0x54
; 0000 0435                 point=4;
_0x23B:
	LDI  R30,LOW(4)
	STS  _point,R30
; 0000 0436                 }
; 0000 0437         //-------------------------------------------------------------------//
; 0000 0438 
; 0000 0439         //-------------------------------------------------------------------//
; 0000 043A         //данные инженерного меню
; 0000 043B         //-------------------------------------------------------------------//
; 0000 043C         if ((mode==11)&&(count_register!=A_16))
_0x230:
	LDS  R26,_mode
	CPI  R26,LOW(0xB)
	BRNE _0x23D
	LDS  R26,_count_register
	CPI  R26,LOW(0x16)
	BRNE _0x23E
_0x23D:
	RJMP _0x23C
_0x23E:
; 0000 043D                 {
; 0000 043E                 if (((count_register==A_06)|(count_register==A_07))|(count_register==A_18))//|(count_register==A_19))
	LDS  R26,_count_register
	LDI  R30,LOW(12)
	CALL SUBOPT_0x85
	LDI  R30,LOW(13)
	CALL SUBOPT_0x86
	LDI  R30,LOW(24)
	CALL __EQB12
	OR   R30,R0
	BREQ _0x23F
; 0000 043F                         {//point=work_point;
; 0000 0440                         if ((data_register<0))
	LDD  R26,Y+61
	TST  R26
	BRPL _0x240
; 0000 0441                                 {
; 0000 0442                                 if (data_register>=-1000)
	CALL SUBOPT_0x3F
	CALL SUBOPT_0x40
	BRLO _0x241
; 0000 0443                                    point = 1;
	LDI  R30,LOW(1)
	STS  _point,R30
; 0000 0444                                  if (data_register>=-100)
_0x241:
	CALL SUBOPT_0x41
	BRLO _0x242
; 0000 0445                                     point=2;
	LDI  R30,LOW(2)
	STS  _point,R30
; 0000 0446                                 if (data_register>=-10)
_0x242:
	CALL SUBOPT_0x42
	BRLO _0x243
; 0000 0447                                     point=3;
	LDI  R30,LOW(3)
	STS  _point,R30
; 0000 0448                                 }
_0x243:
; 0000 0449                         else
	RJMP _0x244
_0x240:
; 0000 044A                                 {
; 0000 044B                                 if (data_register<10)
	CALL SUBOPT_0x43
	BRSH _0x245
; 0000 044C                                     point=4;
	LDI  R30,LOW(4)
	RJMP _0x3D4
; 0000 044D                                 else if (data_register<100)
_0x245:
	CALL SUBOPT_0x44
	BRSH _0x247
; 0000 044E                                     point=3;
	LDI  R30,LOW(3)
	RJMP _0x3D4
; 0000 044F                                 else if (data_register<1000)
_0x247:
	CALL SUBOPT_0x45
	BRSH _0x249
; 0000 0450                                     point=2;
	LDI  R30,LOW(2)
	RJMP _0x3D4
; 0000 0451                                 else if (data_register>=1000)
_0x249:
	CALL SUBOPT_0x45
	BRLO _0x24B
; 0000 0452                                     point=1;
	LDI  R30,LOW(1)
_0x3D4:
	STS  _point,R30
; 0000 0453                                 }
_0x24B:
_0x244:
; 0000 0454                         }
; 0000 0455                 else if((count_register==A_08)|(count_register==A_09))
	RJMP _0x24C
_0x23F:
	LDS  R26,_count_register
	LDI  R30,LOW(14)
	CALL SUBOPT_0x85
	LDI  R30,LOW(15)
	CALL __EQB12
	OR   R30,R0
	BRNE _0x3D5
; 0000 0456                 {
; 0000 0457                             point = 1;
; 0000 0458                 }
; 0000 0459                 else if (count_register==A_10)point=3;
	LDS  R26,_count_register
	CPI  R26,LOW(0x10)
	BRNE _0x24F
	LDI  R30,LOW(3)
	RJMP _0x3D6
; 0000 045A                 else point=1;
_0x24F:
_0x3D5:
	LDI  R30,LOW(1)
_0x3D6:
	STS  _point,R30
; 0000 045B                 hex2dec(data_register);
_0x24C:
	CALL SUBOPT_0x50
; 0000 045C               // if (count_register==A_19){tis=1,sot=1;des=0;ed=9;point=3;}//вписать дату и время
; 0000 045D                 if (count_register==A_16)
	LDS  R26,_count_register
	CPI  R26,LOW(0x16)
	BREQ PC+3
	JMP _0x251
; 0000 045E                         {
; 0000 045F                         if      (data_register==0){tis=4,sot='-';des=2;ed=0;point=1;}
	CALL SUBOPT_0x84
	CALL __CPD10
	BRNE _0x252
	LDI  R30,LOW(4)
	STS  _tis,R30
	LDI  R30,LOW(45)
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x87
	RJMP _0x3D7
; 0000 0460                         else if (data_register==1){tis=0,sot='-';des=0;ed=5;point=1;}
_0x252:
	CALL SUBOPT_0x3F
	__CPD2N 0x3F800000
	BRNE _0x254
	CALL SUBOPT_0x88
	CALL SUBOPT_0x30
	LDI  R30,LOW(5)
	STS  _ed,R30
	LDI  R30,LOW(1)
	RJMP _0x3D7
; 0000 0461                         else if (data_register==2){tis=0,sot='-';des=2;ed=0;point=1;}
_0x254:
	CALL SUBOPT_0x3F
	__CPD2N 0x40000000
	BRNE _0x256
	CALL SUBOPT_0x88
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x87
	RJMP _0x3D7
; 0000 0462                         else if (data_register==3){tis=0,sot='-';des=1;ed=0;point=1;}
_0x256:
	CALL SUBOPT_0x3F
	__CPD2N 0x40400000
	BRNE _0x258
	CALL SUBOPT_0x88
	STS  _sot,R30
	LDI  R30,LOW(1)
	STS  _des,R30
	CALL SUBOPT_0x87
	RJMP _0x3D7
; 0000 0463                         else                      {tis=0,sot='-';des=0;ed=5;point=3;}
_0x258:
	CALL SUBOPT_0x88
	CALL SUBOPT_0x30
	LDI  R30,LOW(5)
	STS  _ed,R30
	LDI  R30,LOW(3)
_0x3D7:
	STS  _point,R30
; 0000 0464                         }
; 0000 0465                 if(count_register==A_19)
_0x251:
	LDS  R26,_count_register
	CPI  R26,LOW(0x19)
	BRNE _0x25A
; 0000 0466                 {
; 0000 0467                      tis  = (reg[0][25]*100)/1000;
	CALL SUBOPT_0x89
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x34
; 0000 0468                      sot  = ((int)(reg[0][25]*100)%1000)/100;
	CALL SUBOPT_0x89
	CALL SUBOPT_0x35
	CALL SUBOPT_0x36
; 0000 0469                      des  = ((int)(reg[0][25]*100)%100)/10;
	CALL SUBOPT_0x89
	CALL SUBOPT_0x35
	CALL SUBOPT_0x37
; 0000 046A                      ed  =(int) (reg[0][25]*100)%10;
	CALL SUBOPT_0x89
	CALL SUBOPT_0x35
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	STS  _ed,R30
; 0000 046B                      point = 3;
	LDI  R30,LOW(3)
	STS  _point,R30
; 0000 046C                 }
; 0000 046D //                if (count_register==A_18)
; 0000 046E //                {
; 0000 046F //                        tis=1;sot=1;des=0;ed=0;point=3;
; 0000 0470 //                        //set_led_on(0,0,0,0,1,1,0,0);set_led_off(0,0,0,0,1,1,0,0);
; 0000 0471 //                }
; 0000 0472                 if (point==1)
_0x25A:
	LDS  R26,_point
	CPI  R26,LOW(0x1)
	BRNE _0x25B
; 0000 0473                 {
; 0000 0474                     set_led_on(0,0,0,0,0,0,0,0);
	CALL SUBOPT_0x38
	CALL SUBOPT_0x38
	CALL SUBOPT_0x47
	CALL SUBOPT_0x48
; 0000 0475                     set_led_off(0,0,0,0,0,0,0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	RJMP _0x3D8
; 0000 0476                 }
; 0000 0477                 else if (point==2)
_0x25B:
	LDS  R26,_point
	CPI  R26,LOW(0x2)
	BRNE _0x25D
; 0000 0478                 {
; 0000 0479                     set_led_on(0,0,0,0,0,0,1,0);
	CALL SUBOPT_0x38
	CALL SUBOPT_0x38
	CALL SUBOPT_0x51
; 0000 047A                     set_led_off(0,0,0,0,0,0,1,0);
	CALL SUBOPT_0x38
	LDI  R30,LOW(1)
	RJMP _0x3D9
; 0000 047B                 }
; 0000 047C                 else if (point==3)
_0x25D:
	LDS  R26,_point
	CPI  R26,LOW(0x3)
	BRNE _0x25F
; 0000 047D                 {
; 0000 047E                     set_led_on(0,0,0,0,0,1,0,0);
	CALL SUBOPT_0x38
	CALL SUBOPT_0x47
	CALL SUBOPT_0x52
	CALL SUBOPT_0x48
; 0000 047F                     set_led_off(0,0,0,0,0,1,0,0);
	CALL SUBOPT_0x47
	LDI  R30,LOW(1)
	RJMP _0x3DA
; 0000 0480                 }
; 0000 0481                 else if (point==4)
_0x25F:
	LDS  R26,_point
	CPI  R26,LOW(0x4)
	BRNE _0x261
; 0000 0482                 {
; 0000 0483                     set_led_on(0,0,0,0,1,0,0,0);
	CALL SUBOPT_0x38
	CALL SUBOPT_0x53
	CALL SUBOPT_0x38
	CALL SUBOPT_0x48
; 0000 0484                     set_led_off(0,0,0,0,1,0,0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
_0x3D8:
	ST   -Y,R30
	LDI  R30,LOW(0)
_0x3DA:
	ST   -Y,R30
	LDI  R30,LOW(0)
_0x3D9:
	ST   -Y,R30
	CALL SUBOPT_0x54
; 0000 0485                 }
; 0000 0486 
; 0000 0487 
; 0000 0488                 if(count_register==CRCCONST) {tis = crc1digit; sot = crc2digit; des =crc3digit; ed = crc4digit; point = 0;}
_0x261:
	LDS  R26,_count_register
	CPI  R26,LOW(0x1B)
	BRNE _0x262
	LDI  R26,LOW(_crc1digit)
	LDI  R27,HIGH(_crc1digit)
	CALL __EEPROMRDB
	STS  _tis,R30
	LDI  R26,LOW(_crc2digit)
	LDI  R27,HIGH(_crc2digit)
	CALL __EEPROMRDB
	STS  _sot,R30
	LDI  R26,LOW(_crc3digit)
	LDI  R27,HIGH(_crc3digit)
	CALL __EEPROMRDB
	STS  _des,R30
	LDI  R26,LOW(_crc4digit)
	LDI  R27,HIGH(_crc4digit)
	CALL __EEPROMRDB
	STS  _ed,R30
	LDI  R30,LOW(0)
	STS  _point,R30
; 0000 0489                 if(count_register==SOFTID) {tis = 'v'; sot = 1; des = 0; ed = 1; point = 0;}
_0x262:
	LDS  R26,_count_register
	CPI  R26,LOW(0x1C)
	BRNE _0x263
	CALL SUBOPT_0x29
	LDI  R30,LOW(0)
	STS  _point,R30
; 0000 048A                 }
_0x263:
; 0000 048B         //-------------------------------------------------------------------//
; 0000 048C 
; 0000 048D         diap_val1 = reg[0][A_12];/*в этом участке кода устанавливаем соответствующее значение*/
_0x23C:
	__POINTW2MN _reg,72
	CALL __EEPROMRDD
	CALL __CFD1U
	MOV  R21,R30
; 0000 048E         if(diap_val1!=diap_val2)
	CP   R20,R21
	BREQ _0x264
; 0000 048F         {
; 0000 0490             diap_val2=diap_val1;
	MOV  R20,R21
; 0000 0491             switch (diap_val1)
	MOV  R30,R21
; 0000 0492             {
; 0000 0493                 case 0:reg[0][A_06]=4; reg[0][A_07]=20;point=3;break;
	CPI  R30,0
	BRNE _0x268
	__POINTW2MN _reg,48
	CALL SUBOPT_0x5C
	CALL SUBOPT_0x8A
	RJMP _0x3DB
; 0000 0494                 case 1:reg[0][A_06]=0; reg[0][A_07]=5;point=4;break;
_0x268:
	CPI  R30,LOW(0x1)
	BREQ _0x3DC
; 0000 0495                 case 2:reg[0][A_06]=0; reg[0][A_07]=20;point=3;break;
	CPI  R30,LOW(0x2)
	BRNE _0x26A
	CALL SUBOPT_0x8B
	CALL SUBOPT_0x8A
	RJMP _0x3DB
; 0000 0496                 case 3:reg[0][A_06]=0; reg[0][A_07]=10;point=3;break;
_0x26A:
	CPI  R30,LOW(0x3)
	BRNE _0x26C
	CALL SUBOPT_0x8B
	CALL __EEPROMWRD
	__POINTW2MN _reg,52
	CALL SUBOPT_0x62
	CALL __EEPROMWRD
	LDI  R30,LOW(3)
	RJMP _0x3DB
; 0000 0497                 default:reg[0][A_06]=0; reg[0][A_07]=5;point=4;break;
_0x26C:
_0x3DC:
	__POINTW2MN _reg,48
	__GETD1N 0x0
	CALL __EEPROMWRD
	__POINTW2MN _reg,52
	__GETD1N 0x40A00000
	CALL __EEPROMWRD
	LDI  R30,LOW(4)
_0x3DB:
	STS  _point,R30
; 0000 0498             }
; 0000 0499                 ee_point=point;work_point=point;
	CALL SUBOPT_0x8C
; 0000 049A         }        //здесь устанавливаем необходимое количество цифр в зависимости от режима работы (для 0-10 - 3 цифры после запятой, для 0-20 - 2 цифры после запятой)
; 0000 049B 
; 0000 049C 
; 0000 049D         if (key_plus_press==1)
_0x264:
	SBRS R3,4
	RJMP _0x26D
; 0000 049E                 {
; 0000 049F 
; 0000 04A0                 start_time_mode=sys_time;
	CALL SUBOPT_0x79
; 0000 04A1                 if (count_key==0)
	LDS  R30,_count_key
	CPI  R30,0
	BRNE _0x26E
; 0000 04A2                         {
; 0000 04A3                         if (mode==10)if (++count_register>MAX_REGISTER)count_register=MAX_REGISTER;
	LDS  R26,_mode
	CPI  R26,LOW(0xA)
	BRNE _0x26F
	LDS  R26,_count_register
	SUBI R26,-LOW(1)
	STS  _count_register,R26
	CPI  R26,LOW(0x1D)
	BRLO _0x270
	LDI  R30,LOW(28)
	STS  _count_register,R30
; 0000 04A4                         if (mode==1)if (++count_register>6)count_register=6;
_0x270:
_0x26F:
	LDS  R26,_mode
	CPI  R26,LOW(0x1)
	BRNE _0x271
	LDS  R26,_count_register
	SUBI R26,-LOW(1)
	STS  _count_register,R26
	CPI  R26,LOW(0x7)
	BRLO _0x272
	LDI  R30,LOW(6)
	STS  _count_register,R30
; 0000 04A5                         }
_0x272:
_0x271:
; 0000 04A6                 if ((count_key==0)||(count_key==21)||(count_key1==102))
_0x26E:
	LDS  R26,_count_key
	CPI  R26,LOW(0x0)
	BREQ _0x274
	CPI  R26,LOW(0x15)
	BREQ _0x274
	LDS  R26,_count_key1
	CPI  R26,LOW(0x66)
	BREQ _0x274
	RJMP _0x273
_0x274:
; 0000 04A7                         {
; 0000 04A8                         if      (point==1)
	LDS  R26,_point
	CPI  R26,LOW(0x1)
	BRNE _0x276
; 0000 04A9                                 {
; 0000 04AA                                 data_register=data_register+1;
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x8E
; 0000 04AB                                 if ((data_register<0)&&(data_register>=-100))point=2;
	LDD  R26,Y+61
	TST  R26
	BRPL _0x278
	CALL SUBOPT_0x41
	BRSH _0x279
_0x278:
	RJMP _0x277
_0x279:
	LDI  R30,LOW(2)
	STS  _point,R30
; 0000 04AC                                 }
_0x277:
; 0000 04AD                         else if (point==2)
	RJMP _0x27A
_0x276:
	LDS  R26,_point
	CPI  R26,LOW(0x2)
	BRNE _0x27B
; 0000 04AE                                 {
; 0000 04AF                                 data_register=data_register+0.1;
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x8E
; 0000 04B0                                 if ((data_register>0)&&(data_register>=1000))point=1;
	CALL SUBOPT_0x90
	BRGE _0x27D
	CALL SUBOPT_0x45
	BRSH _0x27E
_0x27D:
	RJMP _0x27C
_0x27E:
	LDI  R30,LOW(1)
	RJMP _0x3DD
; 0000 04B1                                 else if ((data_register<0)&&(data_register>=-10))point=3;
_0x27C:
	LDD  R26,Y+61
	TST  R26
	BRPL _0x281
	CALL SUBOPT_0x42
	BRSH _0x282
_0x281:
	RJMP _0x280
_0x282:
	LDI  R30,LOW(3)
_0x3DD:
	STS  _point,R30
; 0000 04B2                                 }
_0x280:
; 0000 04B3                         else if (point==3)
	RJMP _0x283
_0x27B:
	LDS  R26,_point
	CPI  R26,LOW(0x3)
	BRNE _0x284
; 0000 04B4                                 {
; 0000 04B5                                 data_register=data_register+0.01;
	CALL SUBOPT_0x91
	CALL SUBOPT_0x8E
; 0000 04B6                                 if ((data_register>0)&&(data_register>=100))point=2;
	CALL SUBOPT_0x90
	BRGE _0x286
	CALL SUBOPT_0x44
	BRSH _0x287
_0x286:
	RJMP _0x285
_0x287:
	RJMP _0x3DE
; 0000 04B7                                 else if ((data_register<0)&&(data_register>=-10))point=2;
_0x285:
	LDD  R26,Y+61
	TST  R26
	BRPL _0x28A
	CALL SUBOPT_0x42
	BRSH _0x28B
_0x28A:
	RJMP _0x289
_0x28B:
_0x3DE:
	LDI  R30,LOW(2)
	STS  _point,R30
; 0000 04B8                                 }
_0x289:
; 0000 04B9                         else if (point==4)
	RJMP _0x28C
_0x284:
	LDS  R26,_point
	CPI  R26,LOW(0x4)
	BRNE _0x28D
; 0000 04BA                                 {
; 0000 04BB                                 data_register=data_register+0.001;
	CALL SUBOPT_0x84
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x8E
; 0000 04BC                                 if ((data_register>0)&&(data_register>=10))point=3;
	CALL SUBOPT_0x90
	BRGE _0x28F
	CALL SUBOPT_0x43
	BRSH _0x290
_0x28F:
	RJMP _0x28E
_0x290:
	LDI  R30,LOW(3)
	STS  _point,R30
; 0000 04BD //                                else if ((data_register<0)&&(data_register>=-1))point=3;
; 0000 04BE                                 }
_0x28E:
; 0000 04BF                         if (data_register>reg[2][count_register])data_register=reg[2][count_register];
_0x28D:
_0x28C:
_0x283:
_0x27A:
	CALL SUBOPT_0x92
	CALL SUBOPT_0x3F
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x291
	CALL SUBOPT_0x92
	CALL SUBOPT_0x3E
; 0000 04C0                         if (count_key==0)count_key=60;if (count_key==21)count_key=20;
_0x291:
	LDS  R30,_count_key
	CPI  R30,0
	BRNE _0x292
	LDI  R30,LOW(60)
	STS  _count_key,R30
_0x292:
	LDS  R26,_count_key
	CPI  R26,LOW(0x15)
	BRNE _0x293
	LDI  R30,LOW(20)
	STS  _count_key,R30
; 0000 04C1                         }
_0x293:
; 0000 04C2                 rekey();
_0x273:
	CALL _rekey
; 0000 04C3                 }
; 0000 04C4         else if ((mode!=100)&&(key_enter_press==0)&&(key_mines_press==0)){count_key=0;count_key1=0;count_key2=0;}
	RJMP _0x294
_0x26D:
	LDS  R26,_mode
	CPI  R26,LOW(0x64)
	BREQ _0x296
	LDI  R26,0
	SBRC R3,6
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0x296
	CALL SUBOPT_0x8
	BREQ _0x297
_0x296:
	RJMP _0x295
_0x297:
	CALL SUBOPT_0x93
; 0000 04C5 
; 0000 04C6         if (key_mines_press==1)
_0x295:
_0x294:
	SBRS R3,5
	RJMP _0x298
; 0000 04C7                 {
; 0000 04C8                 start_time_mode=sys_time;
	CALL SUBOPT_0x79
; 0000 04C9                 if (count_key==0)
	LDS  R30,_count_key
	CPI  R30,0
	BRNE _0x299
; 0000 04CA                         {
; 0000 04CB                         if (mode==10)if (--count_register<7)count_register=7;
	LDS  R26,_mode
	CPI  R26,LOW(0xA)
	BRNE _0x29A
	LDS  R26,_count_register
	SUBI R26,LOW(1)
	STS  _count_register,R26
	CPI  R26,LOW(0x7)
	BRSH _0x29B
	LDI  R30,LOW(7)
	STS  _count_register,R30
; 0000 04CC                         if (mode==1)if (--count_register<1)count_register=1;
_0x29B:
_0x29A:
	LDS  R26,_mode
	CPI  R26,LOW(0x1)
	BRNE _0x29C
	LDS  R26,_count_register
	SUBI R26,LOW(1)
	STS  _count_register,R26
	CPI  R26,LOW(0x1)
	BRSH _0x29D
	LDI  R30,LOW(1)
	STS  _count_register,R30
; 0000 04CD                         }
_0x29D:
_0x29C:
; 0000 04CE                 if ((count_key==0)||(count_key==21)||(count_key1==102))
_0x299:
	LDS  R26,_count_key
	CPI  R26,LOW(0x0)
	BREQ _0x29F
	CPI  R26,LOW(0x15)
	BREQ _0x29F
	LDS  R26,_count_key1
	CPI  R26,LOW(0x66)
	BREQ _0x29F
	RJMP _0x29E
_0x29F:
; 0000 04CF                         {
; 0000 04D0                         if      (point==1)
	LDS  R26,_point
	CPI  R26,LOW(0x1)
	BRNE _0x2A1
; 0000 04D1                                 {
; 0000 04D2                                 data_register=data_register-1;
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x94
; 0000 04D3                                 if ((data_register>0)&&(data_register<1000))point=2;
	BRGE _0x2A3
	CALL SUBOPT_0x45
	BRLO _0x2A4
_0x2A3:
	RJMP _0x2A2
_0x2A4:
	LDI  R30,LOW(2)
	STS  _point,R30
; 0000 04D4                                 }
_0x2A2:
; 0000 04D5                         else if (point==2)
	RJMP _0x2A5
_0x2A1:
	LDS  R26,_point
	CPI  R26,LOW(0x2)
	BRNE _0x2A6
; 0000 04D6                                 {
; 0000 04D7                                 data_register=data_register-0.1;
	CALL SUBOPT_0x8F
	CALL SUBOPT_0x94
; 0000 04D8                                 if ((data_register>0)&&(data_register<100))point=3;
	BRGE _0x2A8
	CALL SUBOPT_0x44
	BRLO _0x2A9
_0x2A8:
	RJMP _0x2A7
_0x2A9:
	LDI  R30,LOW(3)
	RJMP _0x3DF
; 0000 04D9                                 else if ((data_register<0)&&(data_register<=-100))point=1;
_0x2A7:
	LDD  R26,Y+61
	TST  R26
	BRPL _0x2AC
	CALL SUBOPT_0x41
	BREQ PC+4
	BRCS PC+3
	JMP  _0x2AC
	RJMP _0x2AD
_0x2AC:
	RJMP _0x2AB
_0x2AD:
	LDI  R30,LOW(1)
_0x3DF:
	STS  _point,R30
; 0000 04DA                                 }
_0x2AB:
; 0000 04DB                         else if (point==3)
	RJMP _0x2AE
_0x2A6:
	LDS  R26,_point
	CPI  R26,LOW(0x3)
	BRNE _0x2AF
; 0000 04DC                                 {
; 0000 04DD                                 data_register=data_register-0.01;
	CALL SUBOPT_0x91
	CALL SUBOPT_0x94
; 0000 04DE                                 if ((data_register>0)&&(data_register<10))point=4;
	BRGE _0x2B1
	CALL SUBOPT_0x43
	BRLO _0x2B2
_0x2B1:
	RJMP _0x2B0
_0x2B2:
	LDI  R30,LOW(4)
	RJMP _0x3E0
; 0000 04DF                                 else if ((data_register<0)&&(data_register<=-10))point=2;
_0x2B0:
	LDD  R26,Y+61
	TST  R26
	BRPL _0x2B5
	CALL SUBOPT_0x42
	BREQ PC+4
	BRCS PC+3
	JMP  _0x2B5
	RJMP _0x2B6
_0x2B5:
	RJMP _0x2B4
_0x2B6:
	LDI  R30,LOW(2)
_0x3E0:
	STS  _point,R30
; 0000 04E0 
; 0000 04E1                                 }
_0x2B4:
; 0000 04E2                         else if (point==4)
	RJMP _0x2B7
_0x2AF:
	LDS  R26,_point
	CPI  R26,LOW(0x4)
	BRNE _0x2B8
; 0000 04E3                                 {
; 0000 04E4                                 data_register=data_register-0.001;
	CALL SUBOPT_0x84
	CALL SUBOPT_0x1F
	CALL __SUBF12
	CALL SUBOPT_0x3E
; 0000 04E5                                 if ((data_register<0))point=3;
	LDD  R26,Y+61
	TST  R26
	BRPL _0x2B9
	LDI  R30,LOW(3)
	STS  _point,R30
; 0000 04E6                                 }
_0x2B9:
; 0000 04E7                         if (data_register<reg[3][count_register])data_register=reg[3][count_register];
_0x2B8:
_0x2B7:
_0x2AE:
_0x2A5:
	CALL SUBOPT_0x95
	CALL SUBOPT_0x3F
	CALL __CMPF12
	BRSH _0x2BA
	CALL SUBOPT_0x95
	CALL SUBOPT_0x3E
; 0000 04E8                         if (count_key==0)count_key=60;if (count_key==21)count_key=20;
_0x2BA:
	LDS  R30,_count_key
	CPI  R30,0
	BRNE _0x2BB
	LDI  R30,LOW(60)
	STS  _count_key,R30
_0x2BB:
	LDS  R26,_count_key
	CPI  R26,LOW(0x15)
	BRNE _0x2BC
	LDI  R30,LOW(20)
	STS  _count_key,R30
; 0000 04E9                         }
_0x2BC:
; 0000 04EA                 rekey();
_0x29E:
	CALL _rekey
; 0000 04EB                 }
; 0000 04EC         else if ((mode!=100)&&(key_enter_press==0)&&(key_plus_press==0)){count_key=0;count_key1=0;count_key2=0;}
	RJMP _0x2BD
_0x298:
	LDS  R26,_mode
	CPI  R26,LOW(0x64)
	BREQ _0x2BF
	LDI  R26,0
	SBRC R3,6
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0x2BF
	CALL SUBOPT_0x7
	BREQ _0x2C0
_0x2BF:
	RJMP _0x2BE
_0x2C0:
	CALL SUBOPT_0x93
; 0000 04ED 
; 0000 04EE         if ((key_enter_press_switch==1)&&(key_enter==1)&&(key_plus_press==0)&&(key_mines_press==0)&&(key_mode_press==0)&&(mode!=0)&&(mode!=10)&&(mode!=1))
_0x2BE:
_0x2BD:
	SBRS R4,2
	RJMP _0x2C2
	SBRS R3,2
	RJMP _0x2C2
	CALL SUBOPT_0x7
	BRNE _0x2C2
	CALL SUBOPT_0x8
	BRNE _0x2C2
	LDI  R26,0
	SBRC R3,3
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0x2C2
	LDS  R26,_mode
	CPI  R26,LOW(0x0)
	BREQ _0x2C2
	CPI  R26,LOW(0xA)
	BREQ _0x2C2
	CPI  R26,LOW(0x1)
	BRNE _0x2C3
_0x2C2:
	RJMP _0x2C1
_0x2C3:
; 0000 04EF                 {
; 0000 04F0                     if((count_register==A_18)|(count_register==A_19)|(count_register==CRCCONST)|(count_register==SOFTID)){;}
	LDS  R26,_count_register
	LDI  R30,LOW(24)
	CALL SUBOPT_0x85
	LDI  R30,LOW(25)
	CALL SUBOPT_0x86
	LDI  R30,LOW(27)
	CALL SUBOPT_0x86
	LDI  R30,LOW(28)
	CALL __EQB12
	OR   R30,R0
	BREQ _0x2C4
; 0000 04F1                     else
	RJMP _0x2C5
_0x2C4:
; 0000 04F2                     {
; 0000 04F3                     reg[0][count_register]=data_register;
	CALL SUBOPT_0x4E
	ADD  R26,R30
	ADC  R27,R31
	CALL SUBOPT_0x84
	CALL __EEPROMWRD
; 0000 04F4 
; 0000 04F5                     start_time_mode=sys_time;
	CALL SUBOPT_0x79
; 0000 04F6                     if (count_register==A_07){ee_point=point;work_point=point;}
	LDS  R26,_count_register
	CPI  R26,LOW(0xD)
	BRNE _0x2C6
	CALL SUBOPT_0x8C
; 0000 04F7                     if (count_register==A_17)
_0x2C6:
	LDS  R26,_count_register
	CPI  R26,LOW(0x17)
	BRNE _0x2C7
; 0000 04F8                             {
; 0000 04F9                             for (i=0;i<22;i++)reg[0][i]=reg[1][i];
	LDI  R30,LOW(0)
	STS  _i,R30
_0x2C9:
	LDS  R26,_i
	CPI  R26,LOW(0x16)
	BRSH _0x2CA
	LDS  R30,_i
	LDI  R26,LOW(_reg)
	LDI  R27,HIGH(_reg)
	LDI  R31,0
	CALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	__POINTW2MN _reg,108
	LDS  R30,_i
	LDI  R31,0
	CALL __LSLW2
	CALL SUBOPT_0x4F
	MOVW R26,R0
	CALL __EEPROMWRD
	CALL SUBOPT_0x1C
	RJMP _0x2C9
_0x2CA:
; 0000 04FA }
; 0000 04FB                     set_digit_on(' ',3,'a','п');
_0x2C7:
	CALL SUBOPT_0x96
	CALL _set_digit_on
; 0000 04FC                     set_digit_off(' ',3,'a','п');
	CALL SUBOPT_0x96
	CALL _set_digit_off
; 0000 04FD                     set_led_on(0,0,0,1,0,0,0,0);
	CALL SUBOPT_0x38
	CALL SUBOPT_0x7E
	CALL SUBOPT_0x7F
; 0000 04FE                     set_led_off(0,0,0,1,0,0,0,0);
	CALL SUBOPT_0x7E
	CALL SUBOPT_0x54
; 0000 04FF                     for (i=0;i<100;i++)
	LDI  R30,LOW(0)
	STS  _i,R30
_0x2CC:
	LDS  R26,_i
	CPI  R26,LOW(0x64)
	BRSH _0x2CD
; 0000 0500                             {
; 0000 0501                             delay_ms(10);
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x3C
; 0000 0502                             check_rx();
	RCALL _check_rx
; 0000 0503                             delay_ms(10);
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x3C
; 0000 0504                             check_rx();
	RCALL _check_rx
; 0000 0505                             }
	CALL SUBOPT_0x1C
	RJMP _0x2CC
_0x2CD:
; 0000 0506                     key_enter_press_switch=0;
	CLT
	BLD  R4,2
; 0000 0507                     set_digit_off(' ',' ',' ',' ');
	CALL SUBOPT_0x97
	ST   -Y,R30
	CALL _set_digit_off
; 0000 0508                     start_time_mode=sys_time;start_time=sys_time;
	CALL SUBOPT_0x79
	CALL SUBOPT_0x55
; 0000 0509                     f_m1=0;
	CLT
	BLD  R15,2
; 0000 050A                     }
_0x2C5:
; 0000 050B                 }
; 0000 050C         if ((key_mode_press_switch==1)&&(key_4==1))
_0x2C1:
	SBRS R3,7
	RJMP _0x2CF
	SBIC 0x10,7
	RJMP _0x2D0
_0x2CF:
	RJMP _0x2CE
_0x2D0:
; 0000 050D                 {
; 0000 050E                 key_mode_press_switch=0;f_m1=0;
	CLT
	BLD  R3,7
	BLD  R15,2
; 0000 050F                 start_time_mode=sys_time;
	CALL SUBOPT_0x79
; 0000 0510                 switch (mode)
	LDS  R30,_mode
; 0000 0511                         {
; 0000 0512                         case 0: mode=1;count_register=1;break;
	CPI  R30,0
	BRNE _0x2D4
	LDI  R30,LOW(1)
	STS  _mode,R30
	STS  _count_register,R30
	RJMP _0x2D3
; 0000 0513                         case 1: mode=2;data_register=reg[0][count_register];break;
_0x2D4:
	CPI  R30,LOW(0x1)
	BRNE _0x2D5
	LDI  R30,LOW(2)
	STS  _mode,R30
	CALL SUBOPT_0x4E
	CALL SUBOPT_0x4F
	CALL SUBOPT_0x3E
	RJMP _0x2D3
; 0000 0514                         case 2: mode=1;break;
_0x2D5:
	CPI  R30,LOW(0x2)
	BRNE _0x2D6
	LDI  R30,LOW(1)
	RJMP _0x3E1
; 0000 0515                         case 10:mode=11;data_register=reg[0][count_register];break;
_0x2D6:
	CPI  R30,LOW(0xA)
	BRNE _0x2D7
	LDI  R30,LOW(11)
	STS  _mode,R30
	CALL SUBOPT_0x4E
	CALL SUBOPT_0x4F
	CALL SUBOPT_0x3E
	RJMP _0x2D3
; 0000 0516                         case 11:mode=10;break;
_0x2D7:
	CPI  R30,LOW(0xB)
	BRNE _0x2D8
	LDI  R30,LOW(10)
	RJMP _0x3E1
; 0000 0517                         case 100:mode=100;break;
_0x2D8:
	CPI  R30,LOW(0x64)
	BRNE _0x2D3
	LDI  R30,LOW(100)
_0x3E1:
	STS  _mode,R30
; 0000 0518                         }
_0x2D3:
; 0000 0519                 }
; 0000 051A 
; 0000 051B         if (((sys_time-start_time)>250))
_0x2CE:
	CALL SUBOPT_0x49
	__CPD1N 0xFB
	BRLT _0x2DA
; 0000 051C                 {
; 0000 051D                 set_digit_on(tis,sot,des,ed);
	CALL SUBOPT_0x2A
	CALL _set_digit_on
; 0000 051E                 if ((mode==0)||(key_plus_press==1)||(key_mines_press==1)) set_digit_off(tis,sot,des,ed);
	LDS  R26,_mode
	CPI  R26,LOW(0x0)
	BREQ _0x2DC
	SBRC R3,4
	RJMP _0x2DC
	SBRS R3,5
	RJMP _0x2DB
_0x2DC:
	LDS  R30,_tis
	ST   -Y,R30
	LDS  R30,_sot
	ST   -Y,R30
	LDS  R30,_des
	ST   -Y,R30
	LDS  R30,_ed
	RJMP _0x3E2
; 0000 051F                 else set_digit_off(' ',' ',' ',' ');
_0x2DB:
	CALL SUBOPT_0x97
_0x3E2:
	ST   -Y,R30
	CALL _set_digit_off
; 0000 0520                 start_time=sys_time;
	CALL SUBOPT_0x55
; 0000 0521                 }
; 0000 0522         check_rx();
_0x2DA:
	RCALL _check_rx
; 0000 0523         };
	JMP  _0x16E
; 0000 0524         }
; 0000 0525 else while(1)
_0x132:
_0x2E0:
; 0000 0526 {delay_ms(1000);}
	CALL SUBOPT_0x39
	RJMP _0x2E0
; 0000 0527 
; 0000 0528 }         //main закончился.
_0x2E3:
	RJMP _0x2E3
;void check_rx()
; 0000 052A         {
_check_rx:
; 0000 052B 	if (rx_c==1)			//
	SBRS R2,0
	RJMP _0x2E4
; 0000 052C 		{
; 0000 052D                 //tmpVal++;		//
; 0000 052E 		check_add_cr();
	RCALL _check_add_cr
; 0000 052F //  	        mov_buf(error);
; 0000 0530 //  	        mov_buf(rx_buffer[rx_wr_index-1]);
; 0000 0531 //  	        mov_buf(crc>>8);
; 0000 0532 //  	        mov_buf(rx_buffer[rx_wr_index-2]);
; 0000 0533 //                  mov_buf(crc&0x00FF);
; 0000 0534 //                  crc_end();                      //
; 0000 0535 		crc=0xffff;
	CALL SUBOPT_0x26
; 0000 0536 		if (error==0)
	LDS  R30,_error
	CPI  R30,0
	BREQ PC+3
	JMP _0x2E5
; 0000 0537 		        { //tmpVal++;
; 0000 0538 //               		switch (rx_buffer[1])
; 0000 0539 //                                {
; 0000 053A //                		case 0x1:
; 0000 053B                         if (rx_buffer[1]==1)
	__GETB2MN _rx_buffer,1
	CPI  R26,LOW(0x1)
	BRNE _0x2E6
; 0000 053C                 		        {
; 0000 053D         	        	        if (rx_counter==8)
	LDI  R30,LOW(8)
	CP   R30,R6
	BRNE _0x2E7
; 0000 053E         		                        {
; 0000 053F                 		                if ((rx_buffer[3]+rx_buffer[5])<5) response_m_aa1();
	__GETB2MN _rx_buffer,3
	__GETB1MN _rx_buffer,5
	ADD  R26,R30
	CPI  R26,LOW(0x5)
	BRSH _0x2E8
	RCALL _response_m_aa1
; 0000 0540                                                 else  response_m_err(2);
	RJMP _0x2E9
_0x2E8:
	CALL SUBOPT_0x98
; 0000 0541                                                 }
_0x2E9:
; 0000 0542         	                        else response_m_err(3);
	RJMP _0x2EA
_0x2E7:
	CALL SUBOPT_0x99
; 0000 0543 //                	          	break;
; 0000 0544                 		        }
_0x2EA:
; 0000 0545 //                		case 0x48:
; 0000 0546                         else if (rx_buffer[1]==0x48)
	RJMP _0x2EB
_0x2E6:
	__GETB2MN _rx_buffer,1
	CPI  R26,LOW(0x48)
	BRNE _0x2EC
; 0000 0547                 		        {
; 0000 0548                                        // tmpVal++;
; 0000 0549         	        	        if (rx_counter==8)
	LDI  R30,LOW(8)
	CP   R30,R6
	BRNE _0x2ED
; 0000 054A         		                        {
; 0000 054B                 		                if (rx_buffer[2]<3) response_m_aa48();
	__GETB2MN _rx_buffer,2
	CPI  R26,LOW(0x3)
	BRSH _0x2EE
	RCALL _response_m_aa48
; 0000 054C                                                 else  response_m_err(2);
	RJMP _0x2EF
_0x2EE:
	CALL SUBOPT_0x98
; 0000 054D                                                // tmpVal++;
; 0000 054E                                                 }
_0x2EF:
; 0000 054F         	                        else response_m_err(3);
	RJMP _0x2F0
_0x2ED:
	CALL SUBOPT_0x99
; 0000 0550 //                	          	break;
; 0000 0551                 		        }
_0x2F0:
; 0000 0552 //       		                case 0x46:
; 0000 0553                         else if (rx_buffer[1]==0x46)
	RJMP _0x2F1
_0x2EC:
	__GETB2MN _rx_buffer,1
	CPI  R26,LOW(0x46)
	BRNE _0x2F2
; 0000 0554          		                {
; 0000 0555                                         if (rx_counter==10)
	LDI  R30,LOW(10)
	CP   R30,R6
	BRNE _0x2F3
; 0000 0556                                                 {
; 0000 0557                                                 if (rx_buffer[2]<3) response_m_aa46();
	__GETB2MN _rx_buffer,2
	CPI  R26,LOW(0x3)
	BRSH _0x2F4
	RCALL _response_m_aa46
; 0000 0558                                                 else response_m_err(2);
	RJMP _0x2F5
_0x2F4:
	CALL SUBOPT_0x98
; 0000 0559                                                 }
_0x2F5:
; 0000 055A                  	          	else response_m_err(3);
	RJMP _0x2F6
_0x2F3:
	CALL SUBOPT_0x99
; 0000 055B //                                        rx_c=0;rx_m=0;rx_counter=0;
; 0000 055C //        		                crc=0xffff;
; 0000 055D //                                        rx_wr_index=0;
; 0000 055E //         	                  	break;
; 0000 055F          		                }
_0x2F6:
; 0000 0560 //                		default:response_m_err(1);
; 0000 0561                         else response_m_err(1);
	RJMP _0x2F7
_0x2F2:
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _response_m_err
; 0000 0562 //                		}
; 0000 0563         	        }
_0x2F7:
_0x2F1:
_0x2EB:
; 0000 0564                 rx_c=0;rx_m=0;rx_counter=0;
_0x2E5:
	CLT
	BLD  R2,0
	BLD  R2,2
	CLR  R6
; 0000 0565 		crc=0xffff;
	CALL SUBOPT_0x26
; 0000 0566                 rx_wr_index=0;
	CLR  R11
; 0000 0567        		}
; 0000 0568 	}
_0x2E4:
	RET
;//--------------------------------------//
;float find_reg(unsigned int a)
; 0000 056B         {
_find_reg:
; 0000 056C         float d;
; 0000 056D         if      (a==0x0000)              d=adc_value1;
	SBIW R28,4
;	a -> Y+4
;	d -> Y+0
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SBIW R30,0
	BRNE _0x2F8
	CALL SUBOPT_0x7B
	CALL SUBOPT_0x9A
; 0000 056E         else if (a==0x0001)              d=adc_value2;
	RJMP _0x2F9
_0x2F8:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	SBIW R26,1
	BRNE _0x2FA
	CALL SUBOPT_0x7C
	CALL SUBOPT_0x9A
; 0000 056F         else if (a==0x0002)              d=buf[buf_end];
	RJMP _0x2FB
_0x2FA:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	SBIW R26,2
	BRNE _0x2FC
	CALL SUBOPT_0x19
	CALL SUBOPT_0x20
	CALL SUBOPT_0x22
	CALL SUBOPT_0x9A
; 0000 0570         else if (a==0x0003)
	RJMP _0x2FD
_0x2FC:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	SBIW R26,3
	BREQ PC+3
	JMP _0x2FE
; 0000 0571                 {
; 0000 0572                 if (avaria==0) d=1;
	SBRC R4,3
	RJMP _0x2FF
	CALL SUBOPT_0x23
	CALL SUBOPT_0x9A
; 0000 0573                 else d=0;
	RJMP _0x300
_0x2FF:
	LDI  R30,LOW(0)
	CALL __CLRD1S0
; 0000 0574                 if (alarm2==1) d=d+2;
_0x300:
	SBRS R4,5
	RJMP _0x301
	CALL SUBOPT_0x9B
	__GETD2N 0x40000000
	CALL __ADDF12
	RJMP _0x3E3
; 0000 0575                 else d=d;
_0x301:
	CALL SUBOPT_0x9B
_0x3E3:
	CALL __PUTD1S0
; 0000 0576                 if (alarm1==1) d=d+4;
	SBRS R4,4
	RJMP _0x303
	CALL SUBOPT_0x9B
	__GETD2N 0x40800000
	CALL __ADDF12
	RJMP _0x3E4
; 0000 0577                 else d=d;
_0x303:
	CALL SUBOPT_0x9B
_0x3E4:
	CALL __PUTD1S0
; 0000 0578                 if (avaria==1) d=d+8;
	SBRS R4,3
	RJMP _0x305
	CALL SUBOPT_0x9B
	__GETD2N 0x41000000
	CALL __ADDF12
	RJMP _0x3E5
; 0000 0579                 else d=d;
_0x305:
	CALL SUBOPT_0x9B
_0x3E5:
	CALL __PUTD1S0
; 0000 057A                 }
; 0000 057B 
; 0000 057C 
; 0000 057D         else if (a==0x0100)              d=reg[0][Y_01];
	RJMP _0x307
_0x2FE:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRNE _0x308
	CALL SUBOPT_0x24
	CALL SUBOPT_0x9A
; 0000 057E         else if (a==0x0101)              d=reg[0][Y_02];
	RJMP _0x309
_0x308:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0x101)
	LDI  R30,HIGH(0x101)
	CPC  R27,R30
	BRNE _0x30A
	CALL SUBOPT_0x25
	CALL SUBOPT_0x9A
; 0000 057F         else if (a==0x0102)              d=reg[0][Z_01];
	RJMP _0x30B
_0x30A:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0x102)
	LDI  R30,HIGH(0x102)
	CPC  R27,R30
	BRNE _0x30C
	__POINTW2MN _reg,12
	CALL SUBOPT_0x9C
; 0000 0580         else if (a==0x0103)              d=reg[0][Z_02];
	RJMP _0x30D
_0x30C:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0x103)
	LDI  R30,HIGH(0x103)
	CPC  R27,R30
	BRNE _0x30E
	__POINTW2MN _reg,16
	CALL SUBOPT_0x9C
; 0000 0581         else if (a==0x0104)              d=reg[0][P___];
	RJMP _0x30F
_0x30E:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0x104)
	LDI  R30,HIGH(0x104)
	CPC  R27,R30
	BRNE _0x310
	__POINTW2MN _reg,20
	CALL SUBOPT_0x9C
; 0000 0582         else if (a==0x0105)              d=reg[0][C___];
	RJMP _0x311
_0x310:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0x105)
	LDI  R30,HIGH(0x105)
	CPC  R27,R30
	BRNE _0x312
	CALL SUBOPT_0x73
	CALL SUBOPT_0x9A
; 0000 0583 
; 0000 0584         else if (a==0x0200)              d=reg[0][A_01];
	RJMP _0x313
_0x312:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0x200)
	LDI  R30,HIGH(0x200)
	CPC  R27,R30
	BRNE _0x314
	__POINTW2MN _reg,28
	CALL SUBOPT_0x9C
; 0000 0585         else if (a==0x0201)              d=reg[0][A_02];
	RJMP _0x315
_0x314:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0x201)
	LDI  R30,HIGH(0x201)
	CPC  R27,R30
	BRNE _0x316
	CALL SUBOPT_0x74
	CALL SUBOPT_0x9A
; 0000 0586         else if (a==0x0202)              d=reg[0][A_03];
	RJMP _0x317
_0x316:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0x202)
	LDI  R30,HIGH(0x202)
	CPC  R27,R30
	BRNE _0x318
	__POINTW2MN _reg,36
	CALL SUBOPT_0x9C
; 0000 0587         else if (a==0x0203)              d=reg[0][A_04];
	RJMP _0x319
_0x318:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0x203)
	LDI  R30,HIGH(0x203)
	CPC  R27,R30
	BRNE _0x31A
	__POINTW2MN _reg,40
	CALL SUBOPT_0x9C
; 0000 0588         else if (a==0x0204)              d=reg[0][A_05];
	RJMP _0x31B
_0x31A:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0x204)
	LDI  R30,HIGH(0x204)
	CPC  R27,R30
	BRNE _0x31C
	CALL SUBOPT_0x7A
	CALL SUBOPT_0x9A
; 0000 0589         else if (a==0x0205)              d=reg[0][A_06];
	RJMP _0x31D
_0x31C:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0x205)
	LDI  R30,HIGH(0x205)
	CPC  R27,R30
	BRNE _0x31E
	CALL SUBOPT_0x58
	CALL SUBOPT_0x9A
; 0000 058A         else if (a==0x0206)              d=reg[0][A_07];
	RJMP _0x31F
_0x31E:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0x206)
	LDI  R30,HIGH(0x206)
	CPC  R27,R30
	BRNE _0x320
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x9A
; 0000 058B         else if (a==0x0207)              d=reg[0][A_08];
	RJMP _0x321
_0x320:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0x207)
	LDI  R30,HIGH(0x207)
	CPC  R27,R30
	BRNE _0x322
	__POINTW2MN _reg,56
	CALL SUBOPT_0x9C
; 0000 058C         else if (a==0x0208)              d=reg[0][A_09];
	RJMP _0x323
_0x322:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0x208)
	LDI  R30,HIGH(0x208)
	CPC  R27,R30
	BRNE _0x324
	__POINTW2MN _reg,60
	CALL SUBOPT_0x9C
; 0000 058D         else if (a==0x0209)              d=reg[0][A_10];
	RJMP _0x325
_0x324:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0x209)
	LDI  R30,HIGH(0x209)
	CPC  R27,R30
	BRNE _0x326
	__POINTW2MN _reg,64
	CALL SUBOPT_0x9C
; 0000 058E         else if (a==0x020A)              d=reg[0][A_11];
	RJMP _0x327
_0x326:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0x20A)
	LDI  R30,HIGH(0x20A)
	CPC  R27,R30
	BRNE _0x328
	__POINTW2MN _reg,68
	CALL SUBOPT_0x9C
; 0000 058F         else if (a==0x020B)              d=reg[0][A_12];
	RJMP _0x329
_0x328:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0x20B)
	LDI  R30,HIGH(0x20B)
	CPC  R27,R30
	BRNE _0x32A
	__POINTW2MN _reg,72
	CALL SUBOPT_0x9C
; 0000 0590         else if (a==0x020C)              d=reg[0][A_13];
	RJMP _0x32B
_0x32A:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0x20C)
	LDI  R30,HIGH(0x20C)
	CPC  R27,R30
	BRNE _0x32C
	__POINTW2MN _reg,76
	CALL SUBOPT_0x9C
; 0000 0591         else if (a==0x020D)              d=reg[0][A_14];
	RJMP _0x32D
_0x32C:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0x20D)
	LDI  R30,HIGH(0x20D)
	CPC  R27,R30
	BRNE _0x32E
	__POINTW2MN _reg,80
	CALL SUBOPT_0x9C
; 0000 0592         else if (a==0x020E)              d=reg[0][A_15];
	RJMP _0x32F
_0x32E:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0x20E)
	LDI  R30,HIGH(0x20E)
	CPC  R27,R30
	BRNE _0x330
	__POINTW2MN _reg,84
	CALL SUBOPT_0x9C
; 0000 0593         else if (a==0x020F)              d=reg[0][A_16];
	RJMP _0x331
_0x330:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0x20F)
	LDI  R30,HIGH(0x20F)
	CPC  R27,R30
	BRNE _0x332
	__POINTW2MN _reg,88
	CALL SUBOPT_0x9C
; 0000 0594         else if (a==0x0210)              d=reg[0][A_17];
	RJMP _0x333
_0x332:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0x210)
	LDI  R30,HIGH(0x210)
	CPC  R27,R30
	BRNE _0x334
	__POINTW2MN _reg,92
	CALL SUBOPT_0x9C
; 0000 0595         else if (a==0x0211)              d=reg[0][A_18];
	RJMP _0x335
_0x334:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0x211)
	LDI  R30,HIGH(0x211)
	CPC  R27,R30
	BRNE _0x336
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x9A
; 0000 0596         else if (a==0x0212)              d=reg[0][A_19];
	RJMP _0x337
_0x336:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0x212)
	LDI  R30,HIGH(0x212)
	CPC  R27,R30
	BRNE _0x338
	__POINTW2MN _reg,100
	CALL SUBOPT_0x9C
; 0000 0597         else if (a==0x0213)              d=reg[0][adres];
	RJMP _0x339
_0x338:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0x213)
	LDI  R30,HIGH(0x213)
	CPC  R27,R30
	BRNE _0x33A
	__POINTW2MN _reg,104
	CALL SUBOPT_0x9C
; 0000 0598        // else if (a == 0x0214)
; 0000 0599         else                             d=0;
	RJMP _0x33B
_0x33A:
	LDI  R30,LOW(0)
	CALL __CLRD1S0
; 0000 059A         return d;
_0x33B:
_0x339:
_0x337:
_0x335:
_0x333:
_0x331:
_0x32F:
_0x32D:
_0x32B:
_0x329:
_0x327:
_0x325:
_0x323:
_0x321:
_0x31F:
_0x31D:
_0x31B:
_0x319:
_0x317:
_0x315:
_0x313:
_0x311:
_0x30F:
_0x30D:
_0x30B:
_0x309:
_0x307:
_0x2FD:
_0x2FB:
_0x2F9:
	CALL SUBOPT_0x9B
	RJMP _0x20A0005
; 0000 059B         }
;void find_save_reg(unsigned int a,float b)
; 0000 059D         {
_find_save_reg:
; 0000 059E         if (a==0x0100)                   reg[0][Y_01]=b;
;	a -> Y+4
;	b -> Y+0
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRNE _0x33C
	__POINTW2MN _reg,4
	RJMP _0x3E6
; 0000 059F         else if (a==0x0101)              reg[0][Y_02]=b;
_0x33C:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0x101)
	LDI  R30,HIGH(0x101)
	CPC  R27,R30
	BRNE _0x33E
	__POINTW2MN _reg,8
	RJMP _0x3E6
; 0000 05A0         else if (a==0x0102)              reg[0][Z_01]=b;
_0x33E:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0x102)
	LDI  R30,HIGH(0x102)
	CPC  R27,R30
	BRNE _0x340
	__POINTW2MN _reg,12
	RJMP _0x3E6
; 0000 05A1         else if (a==0x0103)              reg[0][Z_02]=b;
_0x340:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0x103)
	LDI  R30,HIGH(0x103)
	CPC  R27,R30
	BRNE _0x342
	__POINTW2MN _reg,16
	RJMP _0x3E6
; 0000 05A2         else if (a==0x0104)              reg[0][P___]=b;
_0x342:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0x104)
	LDI  R30,HIGH(0x104)
	CPC  R27,R30
	BRNE _0x344
	__POINTW2MN _reg,20
	RJMP _0x3E6
; 0000 05A3         else if (a==0x0105)              reg[0][C___]=b;
_0x344:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0x105)
	LDI  R30,HIGH(0x105)
	CPC  R27,R30
	BRNE _0x346
	__POINTW2MN _reg,24
	RJMP _0x3E6
; 0000 05A4 
; 0000 05A5         else if (a==0x0200)              reg[0][A_01]=b;
_0x346:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0x200)
	LDI  R30,HIGH(0x200)
	CPC  R27,R30
	BRNE _0x348
	__POINTW2MN _reg,28
	RJMP _0x3E6
; 0000 05A6         else if (a==0x0201)              reg[0][A_02]=b;
_0x348:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0x201)
	LDI  R30,HIGH(0x201)
	CPC  R27,R30
	BRNE _0x34A
	__POINTW2MN _reg,32
	RJMP _0x3E6
; 0000 05A7         else if (a==0x0202)              reg[0][A_03]=b;
_0x34A:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0x202)
	LDI  R30,HIGH(0x202)
	CPC  R27,R30
	BRNE _0x34C
	__POINTW2MN _reg,36
	RJMP _0x3E6
; 0000 05A8         else if (a==0x0203)              reg[0][A_04]=b;
_0x34C:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0x203)
	LDI  R30,HIGH(0x203)
	CPC  R27,R30
	BRNE _0x34E
	__POINTW2MN _reg,40
	RJMP _0x3E6
; 0000 05A9         else if (a==0x0204)              reg[0][A_05]=b;
_0x34E:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0x204)
	LDI  R30,HIGH(0x204)
	CPC  R27,R30
	BRNE _0x350
	__POINTW2MN _reg,44
	RJMP _0x3E6
; 0000 05AA         else if (a==0x0205)              reg[0][A_06]=b;
_0x350:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0x205)
	LDI  R30,HIGH(0x205)
	CPC  R27,R30
	BRNE _0x352
	__POINTW2MN _reg,48
	RJMP _0x3E6
; 0000 05AB         else if (a==0x0206)              reg[0][A_07]=b;
_0x352:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0x206)
	LDI  R30,HIGH(0x206)
	CPC  R27,R30
	BRNE _0x354
	__POINTW2MN _reg,52
	RJMP _0x3E6
; 0000 05AC         else if (a==0x0207)              reg[0][A_08]=b;
_0x354:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0x207)
	LDI  R30,HIGH(0x207)
	CPC  R27,R30
	BRNE _0x356
	__POINTW2MN _reg,56
	RJMP _0x3E6
; 0000 05AD         else if (a==0x0208)              reg[0][A_09]=b;
_0x356:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0x208)
	LDI  R30,HIGH(0x208)
	CPC  R27,R30
	BRNE _0x358
	__POINTW2MN _reg,60
	RJMP _0x3E6
; 0000 05AE         else if (a==0x0209)              reg[0][A_10]=b;
_0x358:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0x209)
	LDI  R30,HIGH(0x209)
	CPC  R27,R30
	BRNE _0x35A
	__POINTW2MN _reg,64
	RJMP _0x3E6
; 0000 05AF         else if (a==0x020A)              reg[0][A_11]=b;
_0x35A:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0x20A)
	LDI  R30,HIGH(0x20A)
	CPC  R27,R30
	BRNE _0x35C
	__POINTW2MN _reg,68
	RJMP _0x3E6
; 0000 05B0         else if (a==0x020B)              reg[0][A_12]=b;
_0x35C:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0x20B)
	LDI  R30,HIGH(0x20B)
	CPC  R27,R30
	BRNE _0x35E
	__POINTW2MN _reg,72
	RJMP _0x3E6
; 0000 05B1         else if (a==0x020C)              reg[0][A_13]=b;
_0x35E:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0x20C)
	LDI  R30,HIGH(0x20C)
	CPC  R27,R30
	BRNE _0x360
	__POINTW2MN _reg,76
	RJMP _0x3E6
; 0000 05B2         else if (a==0x020D)              reg[0][A_14]=b;
_0x360:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0x20D)
	LDI  R30,HIGH(0x20D)
	CPC  R27,R30
	BRNE _0x362
	__POINTW2MN _reg,80
	RJMP _0x3E6
; 0000 05B3         else if (a==0x020E)              reg[0][A_15]=b;
_0x362:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0x20E)
	LDI  R30,HIGH(0x20E)
	CPC  R27,R30
	BRNE _0x364
	__POINTW2MN _reg,84
	RJMP _0x3E6
; 0000 05B4         else if (a==0x020F)              reg[0][A_16]=b;
_0x364:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0x20F)
	LDI  R30,HIGH(0x20F)
	CPC  R27,R30
	BRNE _0x366
	__POINTW2MN _reg,88
	RJMP _0x3E6
; 0000 05B5         else if (a==0x0210)              reg[0][A_17]=b;
_0x366:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0x210)
	LDI  R30,HIGH(0x210)
	CPC  R27,R30
	BRNE _0x368
	__POINTW2MN _reg,92
	RJMP _0x3E6
; 0000 05B6         else if (a==0x0211)              reg[0][A_18]=b;
_0x368:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0x211)
	LDI  R30,HIGH(0x211)
	CPC  R27,R30
	BRNE _0x36A
	__POINTW2MN _reg,96
	RJMP _0x3E6
; 0000 05B7         else if (a==0x0212)              reg[0][A_19]=b;
_0x36A:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0x212)
	LDI  R30,HIGH(0x212)
	CPC  R27,R30
	BRNE _0x36C
	__POINTW2MN _reg,100
	RJMP _0x3E6
; 0000 05B8         else if (a==0x0213)              reg[0][adres]=b;
_0x36C:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0x213)
	LDI  R30,HIGH(0x213)
	CPC  R27,R30
	BRNE _0x36E
	__POINTW2MN _reg,104
_0x3E6:
	CALL __GETD1S0
	CALL __EEPROMWRD
; 0000 05B9         }
_0x36E:
	RJMP _0x20A0005
;//--------------------------------------//
;void response_m_aa1()                   //
; 0000 05BC 	{mov_buf_mod(rx_buffer[0]);     //
_response_m_aa1:
	CALL SUBOPT_0x9D
; 0000 05BD 	mov_buf_mod(rx_buffer[1]);      //
; 0000 05BE 	mov_buf_mod(1);                 //
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _mov_buf_mod
; 0000 05BF         while (rx_buffer[5]>0)          //
_0x36F:
	__GETB2MN _rx_buffer,5
	CPI  R26,LOW(0x1)
	BRSH PC+3
	JMP _0x371
; 0000 05C0                 {if (rx_buffer[3]==0)   //
	__GETB1MN _rx_buffer,3
	CPI  R30,0
	BRNE _0x372
; 0000 05C1                         {if (avaria==1) i=1;
	SBRS R4,3
	RJMP _0x373
	LDI  R30,LOW(1)
	RJMP _0x3E7
; 0000 05C2                         else i=0;}      //
_0x373:
	LDI  R30,LOW(0)
_0x3E7:
	STS  _i,R30
; 0000 05C3                 if (rx_buffer[3]==1)    //
_0x372:
	__GETB2MN _rx_buffer,3
	CPI  R26,LOW(0x1)
	BRNE _0x375
; 0000 05C4                         {if (alarm1==0) i=i+2;
	SBRC R4,4
	RJMP _0x376
	LDS  R30,_i
	SUBI R30,-LOW(2)
	RJMP _0x3E8
; 0000 05C5         	        else i=i;}      //
_0x376:
	LDS  R30,_i
_0x3E8:
	STS  _i,R30
; 0000 05C6                 if (rx_buffer[3]==2)    //
_0x375:
	__GETB2MN _rx_buffer,3
	CPI  R26,LOW(0x2)
	BRNE _0x378
; 0000 05C7                         {if (alarm2==0) i=i+4;
	SBRC R4,5
	RJMP _0x379
	LDS  R30,_i
	SUBI R30,-LOW(4)
	RJMP _0x3E9
; 0000 05C8                         else i=i;}      //
_0x379:
	LDS  R30,_i
_0x3E9:
	STS  _i,R30
; 0000 05C9                 if (rx_buffer[3]==3)    //
_0x378:
	__GETB2MN _rx_buffer,3
	CPI  R26,LOW(0x3)
	BRNE _0x37B
; 0000 05CA                         {if (avaria==0) i=i+4;
	SBRC R4,3
	RJMP _0x37C
	LDS  R30,_i
	SUBI R30,-LOW(4)
	RJMP _0x3EA
; 0000 05CB                         else i=i;}      //
_0x37C:
	LDS  R30,_i
_0x3EA:
	STS  _i,R30
; 0000 05CC                	rx_buffer[5]--;         //
_0x37B:
	__GETB1MN _rx_buffer,5
	SUBI R30,LOW(1)
	__PUTB1MN _rx_buffer,5
; 0000 05CD                	rx_buffer[3]++;}        //
	__GETB1MN _rx_buffer,3
	SUBI R30,-LOW(1)
	__PUTB1MN _rx_buffer,3
	RJMP _0x36F
_0x371:
; 0000 05CE         mov_buf_mod(i);crc_end();}      //
	LDS  R30,_i
	CALL SUBOPT_0x9E
	RET
;//--------------------------------------//
;void response_m_aa46()                  //
; 0000 05D1 	{float temp;                    //
_response_m_aa46:
; 0000 05D2         int adr;                        //
; 0000 05D3         *((unsigned char *)(&temp)+0)=rx_buffer[4];
	SBIW R28,4
	ST   -Y,R17
	ST   -Y,R16
;	temp -> Y+2
;	adr -> R16,R17
	__GETB1MN _rx_buffer,4
	STD  Y+2,R30
; 0000 05D4         *((unsigned char *)(&temp)+1)=rx_buffer[5];
	__GETB1MN _rx_buffer,5
	STD  Y+3,R30
; 0000 05D5         *((unsigned char *)(&temp)+2)=rx_buffer[6];
	__GETB1MN _rx_buffer,6
	STD  Y+4,R30
; 0000 05D6         *((unsigned char *)(&temp)+3)=rx_buffer[7];
	__GETB1MN _rx_buffer,7
	STD  Y+5,R30
; 0000 05D7 
; 0000 05D8        	adr=rx_buffer[2];               //
	__GETBRMN 16,_rx_buffer,2
	CLR  R17
; 0000 05D9        	adr=adr<<8;                     //
	MOV  R17,R16
	CLR  R16
; 0000 05DA        	adr=adr+rx_buffer[3];           //
	__GETB1MN _rx_buffer,3
	LDI  R31,0
	__ADDWRR 16,17,30,31
; 0000 05DB         find_save_reg(adr,temp);        //
	ST   -Y,R17
	ST   -Y,R16
	__GETD1S 4
	CALL __PUTPARD1
	RCALL _find_save_reg
; 0000 05DC 	mov_buf_mod(rx_buffer[0]);      //
	CALL SUBOPT_0x9D
; 0000 05DD 	mov_buf_mod(rx_buffer[1]);      //
; 0000 05DE 	mov_buf_mod(rx_buffer[2]);      //
	__GETB1MN _rx_buffer,2
	ST   -Y,R30
	RCALL _mov_buf_mod
; 0000 05DF 	mov_buf_mod(rx_buffer[3]);      //
	__GETB1MN _rx_buffer,3
	ST   -Y,R30
	RCALL _mov_buf_mod
; 0000 05E0 	mov_buf_mod(rx_buffer[4]);      //
	__GETB1MN _rx_buffer,4
	ST   -Y,R30
	RCALL _mov_buf_mod
; 0000 05E1 	mov_buf_mod(rx_buffer[5]);      //
	__GETB1MN _rx_buffer,5
	ST   -Y,R30
	RCALL _mov_buf_mod
; 0000 05E2 	mov_buf_mod(rx_buffer[6]);      //
	__GETB1MN _rx_buffer,6
	ST   -Y,R30
	RCALL _mov_buf_mod
; 0000 05E3 	mov_buf_mod(rx_buffer[7]);      //
	__GETB1MN _rx_buffer,7
	CALL SUBOPT_0x9E
; 0000 05E4         crc_end();}                     //
	LDD  R17,Y+1
	LDD  R16,Y+0
_0x20A0005:
	ADIW R28,6
	RET
;//--------------------------------------//
;void response_m_aa48()                  //
; 0000 05E7 	{char a,i;                      //
_response_m_aa48:
; 0000 05E8         float temp;                     //
; 0000 05E9         int adr;                        //
; 0000 05EA         i=rx_buffer[5]*2;               //
	SBIW R28,4
	CALL __SAVELOCR4
;	a -> R17
;	i -> R16
;	temp -> Y+4
;	adr -> R18,R19
	__GETB1MN _rx_buffer,5
	LSL  R30
	MOV  R16,R30
; 0000 05EB         a=0;                            //
	LDI  R17,LOW(0)
; 0000 05EC        	mov_buf_mod(rx_buffer[0]);      //
	CALL SUBOPT_0x9D
; 0000 05ED         mov_buf_mod(rx_buffer[1]);      //
; 0000 05EE        	mov_buf_mod(rx_buffer[5]*4);    //
	__GETB1MN _rx_buffer,5
	LSL  R30
	LSL  R30
	ST   -Y,R30
	RCALL _mov_buf_mod
; 0000 05EF        	adr=rx_buffer[2];               //
	__GETBRMN 18,_rx_buffer,2
	CLR  R19
; 0000 05F0        	adr=adr<<8;                     //
	MOV  R19,R18
	CLR  R18
; 0000 05F1        	adr=adr+rx_buffer[3];           //
	__GETB1MN _rx_buffer,3
	LDI  R31,0
	__ADDWRR 18,19,30,31
; 0000 05F2         temp=find_reg(adr);             //
	ST   -Y,R19
	ST   -Y,R18
	RCALL _find_reg
	__PUTD1S 4
; 0000 05F3         while (i>0)                     //
_0x37E:
	CPI  R16,1
	BRLO _0x380
; 0000 05F4        	        {mov_buf_mod(*((unsigned char *)(&temp)+0+a));
	MOVW R26,R28
	ADIW R26,4
	CALL SUBOPT_0x9F
; 0000 05F5                 mov_buf_mod(*((unsigned char *)(&temp)+1+a));
	MOVW R26,R28
	ADIW R26,5
	CALL SUBOPT_0x9F
; 0000 05F6        	        i--;a++;a++;}           //
	SUBI R16,1
	SUBI R17,-1
	SUBI R17,-1
	RJMP _0x37E
_0x380:
; 0000 05F7 	crc_end();}                     //
	RCALL _crc_end
	CALL __LOADLOCR4
	ADIW R28,8
	RET
;//--------------------------------------//
;void response_m_err(char a)             //
; 0000 05FA         {mov_buf_mod(rx_buffer[0]);     //
_response_m_err:
;	a -> Y+0
	LDS  R30,_rx_buffer
	ST   -Y,R30
	RCALL _mov_buf_mod
; 0000 05FB 	mov_buf_mod(rx_buffer[1]|128);  //
	__GETB1MN _rx_buffer,1
	ORI  R30,0x80
	ST   -Y,R30
	RCALL _mov_buf_mod
; 0000 05FC 	mov_buf_mod(a);                 //
	LD   R30,Y
	CALL SUBOPT_0x9E
; 0000 05FD         crc_end();}                     //
	RJMP _0x20A0004
;//--------------------------------------//
;void check_add_cr()                     //
; 0000 0600 	{char i;                        //
_check_add_cr:
; 0000 0601 	error=0;crc=0xFFFF;
	ST   -Y,R17
;	i -> R17
	LDI  R30,LOW(0)
	STS  _error,R30
	CALL SUBOPT_0x26
; 0000 0602        	i=(unsigned char)reg[0][adres];  //
	__POINTW2MN _reg,104
	CALL __EEPROMRDD
	CALL __CFD1U
	MOV  R17,R30
; 0000 0603 	if (rx_buffer[0]!=i) error=5;   //
	LDS  R26,_rx_buffer
	CP   R17,R26
	BREQ _0x381
	LDI  R30,LOW(5)
	STS  _error,R30
; 0000 0604 	i=0;                            //
_0x381:
	LDI  R17,LOW(0)
; 0000 0605 	while (i<(rx_wr_index-2)){crc_rtu(rx_buffer[i]);i++;}
_0x382:
	MOV  R30,R11
	SUBI R30,LOW(2)
	CP   R17,R30
	BRSH _0x384
	MOV  R30,R17
	CALL SUBOPT_0x0
	LD   R30,Z
	ST   -Y,R30
	RCALL _crc_rtu
	SUBI R17,-1
	RJMP _0x382
_0x384:
; 0000 0606 	i=crc>>8;                       //
	CALL SUBOPT_0x10
	CALL __ASRW8
	MOV  R17,R30
; 0000 0607 	if ((rx_buffer[rx_wr_index-1])!=i) error=2;
	MOV  R30,R11
	SUBI R30,LOW(1)
	CALL SUBOPT_0x0
	LD   R26,Z
	CP   R17,R26
	BREQ _0x385
	LDI  R30,LOW(2)
	STS  _error,R30
; 0000 0608 	i=crc;                          //
_0x385:
	LDS  R17,_crc
; 0000 0609 	if ((rx_buffer[rx_wr_index-2])!=i) error=3;
	MOV  R30,R11
	SUBI R30,LOW(2)
	CALL SUBOPT_0x0
	LD   R26,Z
	CP   R17,R26
	BREQ _0x386
	LDI  R30,LOW(3)
	STS  _error,R30
; 0000 060A 
; 0000 060B 	}                               //
_0x386:
	LD   R17,Y+
	RET
;//--------------------------------------//
;void mov_buf_mod(char a){crc_rtu(a);mov_buf(a);}
; 0000 060D void mov_buf_mod(char a){crc_rtu(a);mov_buf(a);}
_mov_buf_mod:
;	a -> Y+0
	LD   R30,Y
	ST   -Y,R30
	RCALL _crc_rtu
	LD   R30,Y
	ST   -Y,R30
	RCALL _mov_buf
	RJMP _0x20A0004
;//--------------------------------------//
;void mov_buf(char a)                    //
; 0000 0610         {#asm("cli");                   //
_mov_buf:
;	a -> Y+0
	cli
; 0000 0611         tx_buffer[tx_buffer_end]=a;     //
	MOV  R30,R12
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	LD   R26,Y
	STD  Z+0,R26
; 0000 0612         if (++tx_buffer_end==TX_BUFFER_SIZE) tx_buffer_end=0;
	INC  R12
	LDI  R30,LOW(64)
	CP   R30,R12
	BRNE _0x387
	CLR  R12
; 0000 0613         #asm("sei");}                   //
_0x387:
	sei
_0x20A0004:
	ADIW R28,1
	RET
;//--------------------------------------//
;void crc_end()                          //
; 0000 0616         {mov_buf(crc);mov_buf(crc>>8);rx_tx=1;
_crc_end:
	LDS  R30,_crc
	ST   -Y,R30
	RCALL _mov_buf
	CALL SUBOPT_0x10
	CALL __ASRW8
	ST   -Y,R30
	RCALL _mov_buf
	SBI  0x12,2
; 0000 0617         UDR=tx_buffer[tx_buffer_begin]; //
	CALL SUBOPT_0x1
; 0000 0618         ti_en=1;crc=0xffff;}		//
	SET
	BLD  R2,1
	CALL SUBOPT_0x26
	RET
;//--------------------------------------//
;void crc_rtu(char a)			//
; 0000 061B 	{
_crc_rtu:
; 0000 061C         char n;                         //
; 0000 061D 	crc = a^crc;			//
	ST   -Y,R17
;	a -> Y+1
;	n -> R17
	CALL SUBOPT_0x10
	LDD  R26,Y+1
	EOR  R30,R26
	CALL SUBOPT_0xA0
; 0000 061E 	for(n=0; n<8; n++)		//
	LDI  R17,LOW(0)
_0x38B:
	CPI  R17,8
	BRSH _0x38C
; 0000 061F 		{
; 0000 0620                 if(crc & 0x0001 == 1)  //
	LDS  R30,_crc
	ANDI R30,LOW(0x1)
	BREQ _0x38D
; 0000 0621 		        {
; 0000 0622                         crc = crc>>1;	//
	CALL SUBOPT_0xA1
; 0000 0623 			crc=crc&0x7fff;	//
; 0000 0624 			crc = crc^0xA001;
	LDS  R26,_crc
	LDS  R27,_crc+1
	LDI  R30,LOW(40961)
	LDI  R31,HIGH(40961)
	CALL SUBOPT_0x11
; 0000 0625                         }
; 0000 0626 		else
	RJMP _0x38E
_0x38D:
; 0000 0627                         {
; 0000 0628                         crc = crc>>1;	//
	CALL SUBOPT_0xA1
; 0000 0629 			crc=crc&0x7fff;
; 0000 062A                         }
_0x38E:
; 0000 062B                 }
	SUBI R17,-1
	RJMP _0x38B
_0x38C:
; 0000 062C         }
	LDD  R17,Y+0
	ADIW R28,2
	RET
;//--------------------------------------//
;//adc_value1- mA    reg 0
;//adc_value2- mm    reg 1
;//buf[buf_end]- ADC reg 2
;
;//1-функция
;//2-адрес
;//3-данные
;
;//0 4-20mA  20=4.4   =3606 k=20/3606 AIN0
;//1  0-5mA   5=4.4   =3606 k= 5/3606 AIN1
;//2 0-20mA  20=4.4   =3606 k=20/3606 AIN0
;//3  0-10V  10=4.506 =3606 k=10/3691 AIN1
;//4   0-5V   5=4.506 =3606 k= 5/3691 AIN0
;
;
;// переделать битовый опрос

	.CSEG
_cabs:
    ld   r30,y+
    cpi  r30,0
    brpl __cabs0
    neg  r30
__cabs0:
    ret
_ftoa:
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	ST   -Y,R17
	ST   -Y,R16
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x200000D
	CALL SUBOPT_0xA2
	__POINTW1FN _0x2000000,0
	CALL SUBOPT_0xA3
	RJMP _0x20A0003
_0x200000D:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x200000C
	CALL SUBOPT_0xA2
	__POINTW1FN _0x2000000,1
	CALL SUBOPT_0xA3
	RJMP _0x20A0003
_0x200000C:
	LDD  R26,Y+12
	TST  R26
	BRPL _0x200000F
	__GETD1S 9
	CALL __ANEGF1
	CALL SUBOPT_0xA4
	CALL SUBOPT_0xA5
	LDI  R30,LOW(45)
	ST   X,R30
_0x200000F:
	LDD  R26,Y+8
	CPI  R26,LOW(0x7)
	BRLO _0x2000010
	LDI  R30,LOW(6)
	STD  Y+8,R30
_0x2000010:
	LDD  R17,Y+8
_0x2000011:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x2000013
	CALL SUBOPT_0xA6
	CALL SUBOPT_0x1D
	RJMP _0x2000011
_0x2000013:
	CALL SUBOPT_0xA7
	CALL __ADDF12
	CALL SUBOPT_0xA4
	LDI  R17,LOW(0)
	CALL SUBOPT_0x23
	CALL SUBOPT_0x1D
_0x2000014:
	CALL SUBOPT_0xA7
	CALL __CMPF12
	BRLO _0x2000016
	CALL SUBOPT_0x21
	CALL SUBOPT_0x62
	CALL __MULF12
	CALL SUBOPT_0x1D
	SUBI R17,-LOW(1)
	CPI  R17,39
	BRLO _0x2000017
	CALL SUBOPT_0xA2
	__POINTW1FN _0x2000000,5
	CALL SUBOPT_0xA3
	RJMP _0x20A0003
_0x2000017:
	RJMP _0x2000014
_0x2000016:
	CPI  R17,0
	BRNE _0x2000018
	CALL SUBOPT_0xA5
	LDI  R30,LOW(48)
	ST   X,R30
	RJMP _0x2000019
_0x2000018:
_0x200001A:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x200001C
	CALL SUBOPT_0xA6
	__GETD2N 0x3F000000
	CALL __ADDF12
	CALL __PUTPARD1
	CALL _floor
	CALL SUBOPT_0x1D
	CALL SUBOPT_0xA7
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0xA5
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	CALL SUBOPT_0x21
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	CALL __MULF12
	CALL SUBOPT_0xA8
	CALL SUBOPT_0x59
	CALL SUBOPT_0xA4
	RJMP _0x200001A
_0x200001C:
_0x2000019:
	LDD  R30,Y+8
	CPI  R30,0
	BREQ _0x20A0002
	CALL SUBOPT_0xA5
	LDI  R30,LOW(46)
	ST   X,R30
_0x200001E:
	LDD  R30,Y+8
	SUBI R30,LOW(1)
	STD  Y+8,R30
	SUBI R30,-LOW(1)
	BREQ _0x2000020
	CALL SUBOPT_0xA8
	CALL SUBOPT_0x62
	CALL __MULF12
	CALL SUBOPT_0xA4
	__GETD1S 9
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0xA5
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	CALL SUBOPT_0xA8
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	CALL SUBOPT_0x59
	CALL SUBOPT_0xA4
	RJMP _0x200001E
_0x2000020:
_0x20A0002:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x20A0003:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,13
	RET

	.DSEG

	.CSEG

	.CSEG
_ftrunc:
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
	CALL SUBOPT_0x9B
	CALL __PUTPARD1
	CALL _ftrunc
	CALL SUBOPT_0x9A
    brne __floor1
__floor0:
	CALL SUBOPT_0x9B
	RJMP _0x20A0001
__floor1:
    brtc __floor0
	CALL SUBOPT_0x9B
	__GETD2N 0x3F800000
	CALL __SUBF12
_0x20A0001:
	ADIW R28,4
	RET
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG

	.CSEG

	.CSEG
_strcpyf:
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpyf0:
	lpm  r0,z+
    st   x+,r0
    tst  r0
    brne strcpyf0
    movw r30,r24
    ret

	.DSEG
_rx_buffer:
	.BYTE 0x40
_tx_buffer:
	.BYTE 0x40
_pik_count:
	.BYTE 0x1
_led_byte:
	.BYTE 0xA
_sys_time:
	.BYTE 0x4
_whait_time:
	.BYTE 0x4
_count_led:
	.BYTE 0x1
_drebezg:
	.BYTE 0x1
_count_blink:
	.BYTE 0x2
_crc:
	.BYTE 0x2

	.ESEG
_reg:
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x40933333),HIGH(0x40933333),BYTE3(0x40933333),BYTE4(0x40933333)
	.DB  LOW(0x40E33333),HIGH(0x40E33333),BYTE3(0x40E33333),BYTE4(0x40E33333)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x40A00000),HIGH(0x40A00000),BYTE3(0x40A00000),BYTE4(0x40A00000)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x3F800000),HIGH(0x3F800000),BYTE3(0x3F800000),BYTE4(0x3F800000)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x3F800000),HIGH(0x3F800000),BYTE3(0x3F800000),BYTE4(0x3F800000)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x41A00000),HIGH(0x41A00000),BYTE3(0x41A00000),BYTE4(0x41A00000)
	.DB  LOW(0x40000000),HIGH(0x40000000),BYTE3(0x40000000),BYTE4(0x40000000)
	.DB  LOW(0x40000000),HIGH(0x40000000),BYTE3(0x40000000),BYTE4(0x40000000)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x41200000),HIGH(0x41200000),BYTE3(0x41200000),BYTE4(0x41200000)
	.DB  LOW(0x40000000),HIGH(0x40000000),BYTE3(0x40000000),BYTE4(0x40000000)
	.DB  LOW(0x40A00000),HIGH(0x40A00000),BYTE3(0x40A00000),BYTE4(0x40A00000)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x3F800000),HIGH(0x3F800000),BYTE3(0x3F800000),BYTE4(0x3F800000)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x3F800000),HIGH(0x3F800000),BYTE3(0x3F800000),BYTE4(0x3F800000)
	.DB  LOW(0x4009999A),HIGH(0x4009999A),BYTE3(0x4009999A),BYTE4(0x4009999A)
	.DB  LOW(0x3F800000),HIGH(0x3F800000),BYTE3(0x3F800000),BYTE4(0x3F800000)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x40933333),HIGH(0x40933333),BYTE3(0x40933333),BYTE4(0x40933333)
	.DB  LOW(0x40E33333),HIGH(0x40E33333),BYTE3(0x40E33333),BYTE4(0x40E33333)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x40A00000),HIGH(0x40A00000),BYTE3(0x40A00000),BYTE4(0x40A00000)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x3F800000),HIGH(0x3F800000),BYTE3(0x3F800000),BYTE4(0x3F800000)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x3F800000),HIGH(0x3F800000),BYTE3(0x3F800000),BYTE4(0x3F800000)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x41A00000),HIGH(0x41A00000),BYTE3(0x41A00000),BYTE4(0x41A00000)
	.DB  LOW(0x40000000),HIGH(0x40000000),BYTE3(0x40000000),BYTE4(0x40000000)
	.DB  LOW(0x40000000),HIGH(0x40000000),BYTE3(0x40000000),BYTE4(0x40000000)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x41200000),HIGH(0x41200000),BYTE3(0x41200000),BYTE4(0x41200000)
	.DB  LOW(0x40000000),HIGH(0x40000000),BYTE3(0x40000000),BYTE4(0x40000000)
	.DB  LOW(0x40A00000),HIGH(0x40A00000),BYTE3(0x40A00000),BYTE4(0x40A00000)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x3F800000),HIGH(0x3F800000),BYTE3(0x3F800000),BYTE4(0x3F800000)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x3F800000),HIGH(0x3F800000),BYTE3(0x3F800000),BYTE4(0x3F800000)
	.DB  LOW(0x4009999A),HIGH(0x4009999A),BYTE3(0x4009999A),BYTE4(0x4009999A)
	.DB  LOW(0x3F800000),HIGH(0x3F800000),BYTE3(0x3F800000),BYTE4(0x3F800000)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x4479C000),HIGH(0x4479C000),BYTE3(0x4479C000),BYTE4(0x4479C000)
	.DB  LOW(0x4479C000),HIGH(0x4479C000),BYTE3(0x4479C000),BYTE4(0x4479C000)
	.DB  LOW(0x41F00000),HIGH(0x41F00000),BYTE3(0x41F00000),BYTE4(0x41F00000)
	.DB  LOW(0x41F00000),HIGH(0x41F00000),BYTE3(0x41F00000),BYTE4(0x41F00000)
	.DB  LOW(0x3F800000),HIGH(0x3F800000),BYTE3(0x3F800000),BYTE4(0x3F800000)
	.DB  LOW(0x3F800000),HIGH(0x3F800000),BYTE3(0x3F800000),BYTE4(0x3F800000)
	.DB  LOW(0x41200000),HIGH(0x41200000),BYTE3(0x41200000),BYTE4(0x41200000)
	.DB  LOW(0x40000000),HIGH(0x40000000),BYTE3(0x40000000),BYTE4(0x40000000)
	.DB  LOW(0x3F800000),HIGH(0x3F800000),BYTE3(0x3F800000),BYTE4(0x3F800000)
	.DB  LOW(0x3F800000),HIGH(0x3F800000),BYTE3(0x3F800000),BYTE4(0x3F800000)
	.DB  LOW(0x40000000),HIGH(0x40000000),BYTE3(0x40000000),BYTE4(0x40000000)
	.DB  LOW(0x4479C000),HIGH(0x4479C000),BYTE3(0x4479C000),BYTE4(0x4479C000)
	.DB  LOW(0x4479C000),HIGH(0x4479C000),BYTE3(0x4479C000),BYTE4(0x4479C000)
	.DB  LOW(0x41200000),HIGH(0x41200000),BYTE3(0x41200000),BYTE4(0x41200000)
	.DB  LOW(0x41200000),HIGH(0x41200000),BYTE3(0x41200000),BYTE4(0x41200000)
	.DB  LOW(0x40A00000),HIGH(0x40A00000),BYTE3(0x40A00000),BYTE4(0x40A00000)
	.DB  LOW(0x41F00000),HIGH(0x41F00000),BYTE3(0x41F00000),BYTE4(0x41F00000)
	.DB  LOW(0x40800000),HIGH(0x40800000),BYTE3(0x40800000),BYTE4(0x40800000)
	.DB  LOW(0x41200000),HIGH(0x41200000),BYTE3(0x41200000),BYTE4(0x41200000)
	.DB  LOW(0x3F800000),HIGH(0x3F800000),BYTE3(0x3F800000),BYTE4(0x3F800000)
	.DB  LOW(0x3F800000),HIGH(0x3F800000),BYTE3(0x3F800000),BYTE4(0x3F800000)
	.DB  LOW(0x3FE66666),HIGH(0x3FE66666),BYTE3(0x3FE66666),BYTE4(0x3FE66666)
	.DB  LOW(0x3F800000),HIGH(0x3F800000),BYTE3(0x3F800000),BYTE4(0x3F800000)
	.DB  LOW(0x3F800000),HIGH(0x3F800000),BYTE3(0x3F800000),BYTE4(0x3F800000)
	.DB  LOW(0x414FD70A),HIGH(0x414FD70A),BYTE3(0x414FD70A),BYTE4(0x414FD70A)
	.DB  LOW(0x43770000),HIGH(0x43770000),BYTE3(0x43770000),BYTE4(0x43770000)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0xC479C000),HIGH(0xC479C000),BYTE3(0xC479C000),BYTE4(0xC479C000)
	.DB  LOW(0xC479C000),HIGH(0xC479C000),BYTE3(0xC479C000),BYTE4(0xC479C000)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x3F800000),HIGH(0x3F800000),BYTE3(0x3F800000),BYTE4(0x3F800000)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0xC479C000),HIGH(0xC479C000),BYTE3(0xC479C000),BYTE4(0xC479C000)
	.DB  LOW(0xC479C000),HIGH(0xC479C000),BYTE3(0xC479C000),BYTE4(0xC479C000)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x3F800000),HIGH(0x3F800000),BYTE3(0x3F800000),BYTE4(0x3F800000)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x3E4CCCCD),HIGH(0x3E4CCCCD),BYTE3(0x3E4CCCCD),BYTE4(0x3E4CCCCD)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x3F800000),HIGH(0x3F800000),BYTE3(0x3F800000),BYTE4(0x3F800000)
	.DB  LOW(0x3F800000),HIGH(0x3F800000),BYTE3(0x3F800000),BYTE4(0x3F800000)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
_ee_point:
	.DB  0x3
_crceep:
	.DW  0x0
_crcstatic:
	.DW  0x70BB
_crc1digit:
	.DB  0x3
_crc2digit:
	.DB  0x63
_crc3digit:
	.DB  0x2
_crc4digit:
	.DB  0x1

	.DSEG
_mode:
	.BYTE 0x1
_point:
	.BYTE 0x1
_work_point:
	.BYTE 0x1
_ed:
	.BYTE 0x1
_des:
	.BYTE 0x1
_sot:
	.BYTE 0x1
_tis:
	.BYTE 0x1
_i:
	.BYTE 0x1
_count_key:
	.BYTE 0x1
_count_key1:
	.BYTE 0x1
_buf:
	.BYTE 0x12
_buf_end:
	.BYTE 0x1
_x:
	.BYTE 0x4
_adc_filter:
	.BYTE 0x4
_j:
	.BYTE 0x1
_count_register:
	.BYTE 0x1
_count_key2:
	.BYTE 0x1
_start_time:
	.BYTE 0x4
_start_time_mode:
	.BYTE 0x4
_time_key:
	.BYTE 0x4
_error:
	.BYTE 0x1
_adc_value1:
	.BYTE 0x4
_adc_value2:
	.BYTE 0x4
_adc_value3:
	.BYTE 0x4
__seed_G100:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x0:
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	MOV  R30,R13
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	LD   R30,Z
	OUT  0xC,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	LDS  R26,_pik_count
	SUBI R26,-LOW(1)
	STS  _pik_count,R26
	CPI  R26,LOW(0xC9)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 22 TIMES, CODE SIZE REDUCTION:123 WORDS
SUBOPT_0x3:
	LDS  R30,_sys_time
	LDS  R31,_sys_time+1
	LDS  R22,_sys_time+2
	LDS  R23,_sys_time+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	LDI  R26,0
	SBRC R2,5
	LDI  R26,1
	CPI  R26,LOW(0x0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5:
	SET
	BLD  R2,5
	LDI  R30,LOW(0)
	STS  _drebezg,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x6:
	LDS  R26,_drebezg
	SUBI R26,-LOW(1)
	STS  _drebezg,R26
	CPI  R26,LOW(0xC9)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	LDI  R26,0
	SBRC R3,4
	LDI  R26,1
	CPI  R26,LOW(0x0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	LDI  R26,0
	SBRC R3,5
	LDI  R26,1
	CPI  R26,LOW(0x0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9:
	MOV  R30,R17
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	LDI  R26,0
	SBRC R4,7
	LDI  R26,1
	CPI  R26,LOW(0x0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	LDI  R26,0
	SBRC R4,6
	LDI  R26,1
	CPI  R26,LOW(0x0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	ANDI R17,LOW(128)
	LDD  R30,Y+4
	ST   -Y,R30
	CALL _led_calk
	OR   R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	ANDI R17,LOW(128)
	LDD  R30,Y+3
	ST   -Y,R30
	CALL _led_calk
	OR   R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	ANDI R17,LOW(128)
	LDD  R30,Y+2
	ST   -Y,R30
	CALL _led_calk
	OR   R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	ANDI R17,LOW(128)
	LDD  R30,Y+1
	ST   -Y,R30
	CALL _led_calk
	OR   R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x10:
	LDS  R30,_crc
	LDS  R31,_crc+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	EOR  R30,R26
	EOR  R31,R27
	STS  _crc,R30
	STS  _crc+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	MOVW R26,R28
	ADIW R26,4
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x13:
	MOV  R30,R16
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,13
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x14:
	SUBI R30,LOW(48)
	STS  _ed,R30
	LDS  R30,_tis
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	LDI  R30,LOW(32)
	STS  _tis,R30
	LDS  R30,_sot
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x16:
	__POINTW2MN _reg,72
	CALL __EEPROMRDD
	LDI  R26,LOW(_i)
	LDI  R27,HIGH(_i)
	CALL __CFD1U
	ST   X,R30
	LDS  R30,_i
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x17:
	LDS  R26,_count_key1
	SUBI R26,-LOW(1)
	STS  _count_key1,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x18:
	RCALL SUBOPT_0x3
	CALL __SUBD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x19:
	LDS  R30,_buf_end
	LDI  R26,LOW(_buf)
	LDI  R27,HIGH(_buf)
	LDI  R31,0
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x1A:
	LDS  R30,_j
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x1B:
	LDS  R30,_j
	LDI  R26,LOW(_buf)
	LDI  R27,HIGH(_buf)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LD   R0,X+
	LD   R1,X
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1C:
	LDS  R30,_i
	SUBI R30,-LOW(1)
	STS  _i,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1D:
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1E:
	__GETD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1F:
	__GETD2N 0x3A83126F
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x21:
	__GETD2S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x22:
	CLR  R22
	CLR  R23
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x23:
	__GETD1N 0x3F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x24:
	__POINTW2MN _reg,4
	CALL __EEPROMRDD
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x25:
	__POINTW2MN _reg,8
	CALL __EEPROMRDD
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x26:
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	STS  _crc,R30
	STS  _crc+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x27:
	LDI  R26,LOW(_ee_point)
	LDI  R27,HIGH(_ee_point)
	CALL __EEPROMRDB
	STS  _point,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x28:
	RCALL SUBOPT_0x3
	STS  _start_time,R30
	STS  _start_time+1,R31
	STS  _start_time+2,R22
	STS  _start_time+3,R23
	LDI  R30,LOW(1)
	STS  _count_register,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x29:
	LDI  R30,LOW(118)
	STS  _tis,R30
	LDI  R30,LOW(1)
	STS  _sot,R30
	LDI  R30,LOW(0)
	STS  _des,R30
	LDI  R30,LOW(1)
	STS  _ed,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:167 WORDS
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2B:
	CALL _set_digit_on
	RJMP SUBOPT_0x2A

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:61 WORDS
SUBOPT_0x2C:
	CALL _set_digit_off
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0x2D:
	CALL _set_led_on
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	CALL _set_led_off
	LDI  R30,LOW(1500)
	LDI  R31,HIGH(1500)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x2E:
	__POINTW2MN _reg,96
	CALL __EEPROMRDD
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2F:
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x447A0000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x30:
	STS  _sot,R30
	LDI  R30,LOW(0)
	STS  _des,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x31:
	STS  _ed,R30
	RJMP SUBOPT_0x2A

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x32:
	CALL _set_digit_on
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x33:
	__GETD2N 0x447A0000
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x34:
	CALL __DIVF21
	LDI  R26,LOW(_tis)
	LDI  R27,HIGH(_tis)
	CALL __CFD1U
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x35:
	CALL __CFD1
	CLR  R22
	CLR  R23
	MOVW R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x36:
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL __MODW21
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21
	STS  _sot,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x37:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	STS  _des,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 74 TIMES, CODE SIZE REDUCTION:289 WORDS
SUBOPT_0x38:
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x39:
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3A:
	STS  _sot,R30
	LDI  R30,LOW(2)
	STS  _des,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3B:
	STS  _sot,R30
	LDI  R30,LOW(32)
	STS  _des,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3C:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3D:
	__POINTW2MN _reg,52
	CALL __EEPROMRDD
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x3E:
	__PUTD1S 58
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 43 TIMES, CODE SIZE REDUCTION:81 WORDS
SUBOPT_0x3F:
	__GETD2S 58
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x40:
	__GETD1N 0xC47A0000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x41:
	RCALL SUBOPT_0x3F
	__GETD1N 0xC2C80000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x42:
	RCALL SUBOPT_0x3F
	__GETD1N 0xC1200000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x43:
	RCALL SUBOPT_0x3F
	__GETD1N 0x41200000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x44:
	RCALL SUBOPT_0x3F
	__GETD1N 0x42C80000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x45:
	RCALL SUBOPT_0x3F
	__GETD1N 0x447A0000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x46:
	LDS  R30,_point
	STS  _work_point,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 24 TIMES, CODE SIZE REDUCTION:43 WORDS
SUBOPT_0x47:
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 24 TIMES, CODE SIZE REDUCTION:43 WORDS
SUBOPT_0x48:
	CALL _set_led_on
	RJMP SUBOPT_0x38

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x49:
	LDS  R26,_start_time
	LDS  R27,_start_time+1
	LDS  R24,_start_time+2
	LDS  R25,_start_time+3
	RJMP SUBOPT_0x18

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4A:
	LDI  R30,LOW(32)
	STS  _ed,R30
	LDS  R30,_count_register
	CPI  R30,LOW(0x2)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4B:
	STS  _tis,R30
	LDI  R30,LOW(95)
	STS  _sot,R30
	LDI  R30,LOW(2)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4C:
	LDI  R30,LOW(112)
	STS  _tis,R30
	LDI  R30,LOW(95)
	STS  _sot,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4D:
	LDI  R30,LOW(99)
	STS  _tis,R30
	LDI  R30,LOW(95)
	STS  _sot,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x4E:
	LDS  R30,_count_register
	LDI  R26,LOW(_reg)
	LDI  R27,HIGH(_reg)
	LDI  R31,0
	CALL __LSLW2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x4F:
	ADD  R26,R30
	ADC  R27,R31
	CALL __EEPROMRDD
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x50:
	__GETD1S 58
	CALL __PUTPARD1
	JMP  _hex2dec

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x51:
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RJMP SUBOPT_0x48

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x52:
	LDI  R30,LOW(1)
	ST   -Y,R30
	RJMP SUBOPT_0x47

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x53:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x54:
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _set_led_off

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x55:
	RCALL SUBOPT_0x3
	STS  _start_time,R30
	STS  _start_time+1,R31
	STS  _start_time+2,R22
	STS  _start_time+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x56:
	__GETD1S 50
	__GETD2S 54
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x57:
	__GETD2N 0x41A00000
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x45616000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x58:
	__POINTW2MN _reg,48
	CALL __EEPROMRDD
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:31 WORDS
SUBOPT_0x59:
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x5A:
	CALL __DIVF21
	__PUTD1S 46
	RJMP SUBOPT_0x58

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x5B:
	__GETD2S 46
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5C:
	__GETD1N 0x40800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5D:
	__PUTD1S 42
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5E:
	__GETD1N 0x41A00000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5F:
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x40A00000
	RJMP SUBOPT_0x5A

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x60:
	RCALL SUBOPT_0x5B
	__GETD1N 0x0
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x61:
	RCALL SUBOPT_0x5D
	LDI  R30,LOW(0)
	__CLRD1S 38
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x62:
	__GETD1N 0x41200000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x63:
	LDS  R26,_adc_value1
	LDS  R27,_adc_value1+1
	LDS  R24,_adc_value1+2
	LDS  R25,_adc_value1+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x64:
	CALL __MULF12
	__GETD2S 42
	CALL __ADDF12
	STS  _adc_value2,R30
	STS  _adc_value2+1,R31
	STS  _adc_value2+2,R22
	STS  _adc_value2+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x65:
	__POINTW2MN _reg,56
	CALL __EEPROMRDD
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x42C80000
	CALL __DIVF21
	__GETD2N 0x3F800000
	RJMP SUBOPT_0x59

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x66:
	__GETD2S 38
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x67:
	__POINTW2MN _reg,60
	CALL __EEPROMRDD
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x42C80000
	CALL __DIVF21
	__GETD2N 0x3F800000
	CALL __ADDF12
	__GETD2S 34
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x68:
	LDS  R26,_adc_value2
	LDS  R27,_adc_value2+1
	LDS  R24,_adc_value2+2
	LDS  R25,_adc_value2+3
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x69:
	__GETD1S 30
	RJMP SUBOPT_0x68

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0x6A:
	__POINTW2MN _reg,28
	CALL __EEPROMRDD
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x42C80000
	CALL __DIVF21
	__GETD2N 0x3F800000
	RJMP SUBOPT_0x59

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x6B:
	CLT
	BLD  R4,4
	BLD  R15,0
	__POINTW2MN _reg,20
	CALL __EEPROMRDD
	CALL __CPD10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:47 WORDS
SUBOPT_0x6C:
	__CPD1N 0x3F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x6D:
	__POINTW2MN _reg,80
	CALL __EEPROMRDD
	CALL __CPD10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6E:
	__GETD1S 26
	RJMP SUBOPT_0x68

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x6F:
	CLT
	BLD  R4,5
	BLD  R15,1
	__POINTW2MN _reg,20
	CALL __EEPROMRDD
	CALL __CPD10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x70:
	__POINTW2MN _reg,84
	CALL __EEPROMRDD
	CALL __CPD10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x71:
	LDS  R26,_sys_time
	LDS  R27,_sys_time+1
	LDS  R24,_sys_time+2
	LDS  R25,_sys_time+3
	CALL __CDF2
	RJMP SUBOPT_0x59

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x72:
	CALL __EEPROMRDD
	__GETD2N 0x44480000
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x73:
	__POINTW2MN _reg,24
	CALL __EEPROMRDD
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x74:
	__POINTW2MN _reg,32
	CALL __EEPROMRDD
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x75:
	__POINTW2MN _reg,20
	CALL __EEPROMRDD
	CALL __CPD10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x76:
	__CPD1N 0x40000000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x77:
	LDS  R26,_whait_time
	LDS  R27,_whait_time+1
	LDS  R24,_whait_time+2
	LDS  R25,_whait_time+3
	RJMP SUBOPT_0x18

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x78:
	__CPD1N 0x5DD
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x79:
	RCALL SUBOPT_0x3
	STS  _start_time_mode,R30
	STS  _start_time_mode+1,R31
	STS  _start_time_mode+2,R22
	STS  _start_time_mode+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7A:
	__POINTW2MN _reg,44
	CALL __EEPROMRDD
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x7B:
	LDS  R30,_adc_value1
	LDS  R31,_adc_value1+1
	LDS  R22,_adc_value1+2
	LDS  R23,_adc_value1+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x7C:
	LDS  R30,_adc_value2
	LDS  R31,_adc_value2+1
	LDS  R22,_adc_value2+2
	LDS  R23,_adc_value2+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x7D:
	LDS  R30,_adc_value3
	LDS  R31,_adc_value3+1
	LDS  R22,_adc_value3+2
	LDS  R23,_adc_value3+3
	CALL __PUTPARD1
	CALL _hex2dec
	LDS  R26,_point
	CPI  R26,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x7E:
	LDI  R30,LOW(1)
	ST   -Y,R30
	RJMP SUBOPT_0x38

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7F:
	LDI  R30,LOW(0)
	ST   -Y,R30
	RJMP SUBOPT_0x48

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x80:
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x81:
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R30
	RJMP SUBOPT_0x38

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x82:
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	CALL __PUTPARD1
	JMP  _hex2dec

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x83:
	STS  _des,R30
	RJMP SUBOPT_0x47

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x84:
	__GETD1S 58
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x85:
	CALL __EQB12
	MOV  R0,R30
	LDS  R26,_count_register
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x86:
	CALL __EQB12
	OR   R0,R30
	LDS  R26,_count_register
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x87:
	LDI  R30,LOW(0)
	STS  _ed,R30
	LDI  R30,LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x88:
	LDI  R30,LOW(0)
	STS  _tis,R30
	LDI  R30,LOW(45)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x89:
	__POINTW2MN _reg,100
	CALL __EEPROMRDD
	__GETD2N 0x42C80000
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x8A:
	CALL __EEPROMWRD
	__POINTW2MN _reg,52
	RCALL SUBOPT_0x5E
	CALL __EEPROMWRD
	LDI  R30,LOW(3)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8B:
	__POINTW2MN _reg,48
	__GETD1N 0x0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8C:
	LDS  R30,_point
	LDI  R26,LOW(_ee_point)
	LDI  R27,HIGH(_ee_point)
	CALL __EEPROMWRB
	RJMP SUBOPT_0x46

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8D:
	RCALL SUBOPT_0x84
	__GETD2N 0x3F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8E:
	CALL __ADDF12
	RJMP SUBOPT_0x3E

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8F:
	RCALL SUBOPT_0x84
	__GETD2N 0x3DCCCCCD
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x90:
	RCALL SUBOPT_0x3F
	CALL __CPD02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x91:
	RCALL SUBOPT_0x84
	__GETD2N 0x3C23D70A
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x92:
	__POINTW2MN _reg,216
	LDS  R30,_count_register
	LDI  R31,0
	CALL __LSLW2
	RJMP SUBOPT_0x4F

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x93:
	LDI  R30,LOW(0)
	STS  _count_key,R30
	STS  _count_key1,R30
	STS  _count_key2,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x94:
	CALL __SUBF12
	RCALL SUBOPT_0x3E
	RJMP SUBOPT_0x90

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x95:
	__POINTW2MN _reg,324
	LDS  R30,_count_register
	LDI  R31,0
	CALL __LSLW2
	RJMP SUBOPT_0x4F

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x96:
	LDI  R30,LOW(32)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R30,LOW(97)
	ST   -Y,R30
	LDI  R30,LOW(239)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x97:
	LDI  R30,LOW(32)
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x98:
	LDI  R30,LOW(2)
	ST   -Y,R30
	JMP  _response_m_err

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x99:
	LDI  R30,LOW(3)
	ST   -Y,R30
	JMP  _response_m_err

;OPTIMIZER ADDED SUBROUTINE, CALLED 31 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x9A:
	CALL __PUTD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x9B:
	CALL __GETD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:31 WORDS
SUBOPT_0x9C:
	CALL __EEPROMRDD
	RJMP SUBOPT_0x9A

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x9D:
	LDS  R30,_rx_buffer
	ST   -Y,R30
	CALL _mov_buf_mod
	__GETB1MN _rx_buffer,1
	ST   -Y,R30
	JMP  _mov_buf_mod

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9E:
	ST   -Y,R30
	CALL _mov_buf_mod
	JMP  _crc_end

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x9F:
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R30,X
	ST   -Y,R30
	JMP  _mov_buf_mod

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA0:
	STS  _crc,R30
	STS  _crc+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xA1:
	RCALL SUBOPT_0x10
	ASR  R31
	ROR  R30
	RCALL SUBOPT_0xA0
	__ANDBMNN _crc,1,127
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA2:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA3:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _strcpyf

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xA4:
	__PUTD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xA5:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA6:
	RCALL SUBOPT_0x21
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xA7:
	RCALL SUBOPT_0x1E
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA8:
	__GETD2S 9
	RET


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGF1:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __ANEGF10
	SUBI R23,0x80
__ANEGF10:
	RET

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

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

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
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
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
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
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
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
	BRVS __ADDF1211
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
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
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

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
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
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
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
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
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
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
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

__SUBD12:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	SBC  R23,R25
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

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

__EQB12:
	CP   R30,R26
	LDI  R30,1
	BREQ __EQB12T
	CLR  R30
__EQB12T:
	RET

__LEW12:
	CP   R30,R26
	CPC  R31,R27
	LDI  R30,1
	BRGE __LEW12T
	CLR  R30
__LEW12T:
	RET

__LEW12U:
	CP   R30,R26
	CPC  R31,R27
	LDI  R30,1
	BRSH __LEW12UT
	CLR  R30
__LEW12UT:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__PUTDP1:
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	RET

__GETW2PF:
	LPM  R26,Z+
	LPM  R27,Z
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__CLRD1S0:
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	STD  Y+3,R30
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
	MOVW R22,R30
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
	MOVW R0,R30
	MOVW R30,R22
	RCALL __EEPROMWRW
	MOVW R30,R0
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
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
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

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__CPD02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	CPC  R0,R24
	CPC  R0,R25
	RET

__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__INITLOCB:
__INITLOCW:
	ADD  R26,R28
	ADC  R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	RET

;END OF CODE MARKER
__END_OF_CODE:
