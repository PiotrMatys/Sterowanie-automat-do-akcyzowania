
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega128
;Program type             : Application
;Clock frequency          : 8,000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 1024 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega128
	#pragma AVRPART MEMORY PROG_FLASH 131072
	#pragma AVRPART MEMORY EEPROM 4096
	#pragma AVRPART MEMORY INT_SRAM SIZE 4351
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

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
	.EQU RAMPZ=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU XMCRA=0x6D
	.EQU XMCRB=0x6C

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

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x10FF
	.EQU __DSTACK_SIZE=0x0400
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
	.DEF _pracuje_w_kierunku=R4
	.DEF _mikro_krokow_na_obrot=R6
	.DEF _zezwalaj_na_kolejny_kubek=R8
	.DEF _dostep_do_podajnika=R10
	.DEF _zezzwalaj_na_oklejenie_boczne=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer2_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer0_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_0x0:
	.DB  0x70,0x72,0x7A,0x65,0x63,0x68,0x6F,0x64
	.DB  0x7A,0x69,0x5F,0x6B,0x75,0x62,0x65,0x6B
	.DB  0x0,0x63,0x7A,0x61,0x73,0x5F,0x6B,0x72
	.DB  0x6F,0x6B,0x75,0x0,0x70,0x6F,0x62,0x69
	.DB  0x65,0x72,0x61,0x6D,0x5F,0x62,0x61,0x6E
	.DB  0x64,0x65,0x72,0x6F,0x6C,0x65,0x0,0x70
	.DB  0x72,0x7A,0x65,0x6A,0x61,0x7A,0x64,0x5F
	.DB  0x6E,0x61,0x64,0x5F,0x6B,0x6C,0x65,0x6A
	.DB  0x65,0x6D,0x0,0x6E,0x61,0x6B,0x6C,0x65
	.DB  0x6A,0x61,0x6D,0x0,0x6F,0x6B,0x6C,0x65
	.DB  0x6A,0x61,0x6E,0x69,0x65,0x5F,0x62,0x6F
	.DB  0x63,0x7A,0x6E,0x65,0x0,0x4F,0x4E,0x4C
	.DB  0x49,0x4E,0x45,0x2D,0x48,0x41,0x53,0x53
	.DB  0x4F,0x0,0x53,0x4C,0x4F,0x57,0x0,0x4F
	.DB  0x4E,0x4C,0x49,0x4E,0x45,0x2D,0x32,0x35
	.DB  0x30,0x0,0x46,0x41,0x53,0x54,0x0,0x4F
	.DB  0x4E,0x4C,0x49,0x4E,0x45,0x2D,0x43,0x48
	.DB  0x41,0x4F,0x53,0x0,0x4F,0x4E,0x4C,0x49
	.DB  0x4E,0x45,0x2D,0x55,0x4C,0x54,0x49,0x4D
	.DB  0x41,0x54,0x45,0x0,0x42,0x52,0x41,0x4B
	.DB  0x20,0x57,0x59,0x42,0x4F,0x52,0x55,0x0
	.DB  0x4B,0x55,0x42,0x4B,0x41,0x0,0x47,0x4C
	.DB  0x55,0x45,0x20,0x4C,0x4F,0x41,0x44,0x45
	.DB  0x44,0x0,0x4C,0x4F,0x41,0x44,0x20,0x47
	.DB  0x4C,0x55,0x45,0x0,0x42,0x72,0x61,0x6B
	.DB  0x20,0x77,0x79,0x6D,0x61,0x67,0x61,0x6E
	.DB  0x65,0x67,0x6F,0x20,0x63,0x69,0x9C,0x6E
	.DB  0x69,0x65,0x6E,0x69,0x61,0x20,0x37,0x20
	.DB  0x62,0x61,0x72,0x0,0x54,0x75,0x72,0x6E
	.DB  0x20,0x6F,0x66,0x66,0x20,0x61,0x6E,0x64
	.DB  0x20,0x63,0x68,0x65,0x63,0x6B,0x20,0x73
	.DB  0x74,0x72,0x65,0x61,0x6D,0x65,0x72,0x73
	.DB  0x0,0x4E,0x55,0x4D,0x45,0x52,0x0,0x44
	.DB  0x41,0x57,0x4B,0x41,0x20,0x4B,0x4C,0x45
	.DB  0x4A,0x55,0x0
_0x2020060:
	.DB  0x1
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0
_0x2060003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x11
	.DW  _0x4
	.DW  _0x0*2

	.DW  0x0B
	.DW  _0x4+17
	.DW  _0x0*2+17

	.DW  0x13
	.DW  _0x4+28
	.DW  _0x0*2+28

	.DW  0x14
	.DW  _0x4+47
	.DW  _0x0*2+47

	.DW  0x09
	.DW  _0x4+67
	.DW  _0x0*2+67

	.DW  0x11
	.DW  _0x4+76
	.DW  _0x0*2+76

	.DW  0x11
	.DW  _0xB
	.DW  _0x0*2

	.DW  0x0B
	.DW  _0xB+17
	.DW  _0x0*2+17

	.DW  0x13
	.DW  _0xB+28
	.DW  _0x0*2+28

	.DW  0x14
	.DW  _0xB+47
	.DW  _0x0*2+47

	.DW  0x09
	.DW  _0xB+67
	.DW  _0x0*2+67

	.DW  0x11
	.DW  _0xB+76
	.DW  _0x0*2+76

	.DW  0x11
	.DW  _0x15
	.DW  _0x0*2+76

	.DW  0x11
	.DW  _0x15+17
	.DW  _0x0*2+76

	.DW  0x0D
	.DW  _0x1A
	.DW  _0x0*2+93

	.DW  0x05
	.DW  _0x1A+13
	.DW  _0x0*2+106

	.DW  0x0B
	.DW  _0x1A+18
	.DW  _0x0*2+111

	.DW  0x05
	.DW  _0x1A+29
	.DW  _0x0*2+106

	.DW  0x0D
	.DW  _0x1A+34
	.DW  _0x0*2+93

	.DW  0x05
	.DW  _0x1A+47
	.DW  _0x0*2+122

	.DW  0x0B
	.DW  _0x1A+52
	.DW  _0x0*2+111

	.DW  0x05
	.DW  _0x1A+63
	.DW  _0x0*2+122

	.DW  0x0D
	.DW  _0x1A+68
	.DW  _0x0*2+127

	.DW  0x05
	.DW  _0x1A+81
	.DW  _0x0*2+122

	.DW  0x0D
	.DW  _0x1A+86
	.DW  _0x0*2+127

	.DW  0x05
	.DW  _0x1A+99
	.DW  _0x0*2+106

	.DW  0x0D
	.DW  _0x21
	.DW  _0x0*2+93

	.DW  0x05
	.DW  _0x21+13
	.DW  _0x0*2+122

	.DW  0x10
	.DW  _0x21+18
	.DW  _0x0*2+140

	.DW  0x05
	.DW  _0x21+34
	.DW  _0x0*2+122

	.DW  0x0D
	.DW  _0x21+39
	.DW  _0x0*2+127

	.DW  0x05
	.DW  _0x21+52
	.DW  _0x0*2+122

	.DW  0x0C
	.DW  _0x21+57
	.DW  _0x0*2+156

	.DW  0x06
	.DW  _0x21+69
	.DW  _0x0*2+168

	.DW  0x0C
	.DW  _0x2D
	.DW  _0x0*2+174

	.DW  0x0A
	.DW  _0x2D+12
	.DW  _0x0*2+186

	.DW  0x13
	.DW  _0x9E
	.DW  _0x0*2+28

	.DW  0x09
	.DW  _0xA9
	.DW  _0x0*2+67

	.DW  0x20
	.DW  _0xAD
	.DW  _0x0*2+196

	.DW  0x1D
	.DW  _0xB8
	.DW  _0x0*2+228

	.DW  0x13
	.DW  _0xC0
	.DW  _0x0*2+28

	.DW  0x13
	.DW  _0xC0+19
	.DW  _0x0*2+28

	.DW  0x13
	.DW  _0xC0+38
	.DW  _0x0*2+28

	.DW  0x13
	.DW  _0xC0+57
	.DW  _0x0*2+28

	.DW  0x13
	.DW  _0xC0+76
	.DW  _0x0*2+28

	.DW  0x13
	.DW  _0xC0+95
	.DW  _0x0*2+28

	.DW  0x13
	.DW  _0xC0+114
	.DW  _0x0*2+28

	.DW  0x13
	.DW  _0xC0+133
	.DW  _0x0*2+28

	.DW  0x13
	.DW  _0xC0+152
	.DW  _0x0*2+28

	.DW  0x13
	.DW  _0xC0+171
	.DW  _0x0*2+28

	.DW  0x13
	.DW  _0xC0+190
	.DW  _0x0*2+28

	.DW  0x13
	.DW  _0xC0+209
	.DW  _0x0*2+28

	.DW  0x13
	.DW  _0xC0+228
	.DW  _0x0*2+28

	.DW  0x09
	.DW  _0xC0+247
	.DW  _0x0*2+67

	.DW  0x09
	.DW  _0xC0+256
	.DW  _0x0*2+67

	.DW  0x09
	.DW  _0xC0+265
	.DW  _0x0*2+67

	.DW  0x09
	.DW  _0xC0+274
	.DW  _0x0*2+67

	.DW  0x06
	.DW  _0x135
	.DW  _0x0*2+257

	.DW  0x0C
	.DW  _0x135+6
	.DW  _0x0*2+263

	.DW  0x06
	.DW  _0x135+18
	.DW  _0x0*2+257

	.DW  0x0C
	.DW  _0x135+24
	.DW  _0x0*2+263

	.DW  0x01
	.DW  __seed_G101
	.DW  _0x2020060*2

	.DW  0x02
	.DW  __base_y_G103
	.DW  _0x2060003*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30
	STS  XMCRB,R30

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
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
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

	OUT  RAMPZ,R24

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
	.ORG 0x500

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.05.0 Professional
;Automatic Program Generator
;© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 2017-01-04
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega128
;Program type            : Application
;AVR Core Clock frequency: 8,000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 1024
;*****************************************************/
;
;#include <mega128.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <string.h>
;#include <stdlib.h>
;#include <math.h>
;#include <alcd.h>
;
;long int ulamki_sekund_0;
;long int ulamki_sekund_1;
;long int ulamki_sekund_2;
;long int milisekundy_przechodzi_kubek;
;long int milisekundy_czas_kroku;
;long int milisekundy_pobieram_banderole;
;long int milisekundy_przejazd_nad_klejem;
;long int milisekundy_naklejam;
;long int milisekundy_oklejanie_boczne;
;//long int milisekundy_silownik_obrotowy;
;long int czas_wylaczenia_falownika;
;long int czas_czyszczenia_tasmy;
;long int licznik_wlacznika_run;
;long int licznik_wyswietlania_kleju;
;long int licznik_wyswietlania_kleju_stala;
;long int licznik_wyswietlen_jak_stoi;
;int pracuje_w_kierunku;
;
;
;float silnik_gorny_zebatka_promien;
;int mikro_krokow_na_obrot;
;long int czas;
;int zezwalaj_na_kolejny_kubek;
;int dostep_do_podajnika;
;int zezzwalaj_na_oklejenie_boczne;
;int oklejam_bok;
;int wyzerowalem_nad_podajnikiem;
;int jest_klej;
;int pracuje;
;int wyswietl_obecnosc_kleju, wyswietl_brak_kleju;
;int zezwolenie_run;
;int dawka_kleju;
;int srednie_kubki;
;int pobralem_banderole;
;int opuscilem_banderole;
;int podnioslem_banderole;
;int lej_klej;
;int cofniety_pistolet;
;int nakleilem;
;int wyzerowalem_krancowke;
;int wykonano_1;
;int wykonano_2;
;int sprawdzilem_banderole;
;int podajnik_gotowy;
;int widzi_kubek;
;int zatrzymalem_kubek;
;int licznik_pionowego_czujnika;
;int licznik_nie_pobrania_banderol;
;int licznik_cykli;
;int sytuacja_startowa;
;int fast;
;int guzik_male_kubki;
;int kubek;
;char *dupa;
;int poczatek_serii;
;int kolejkowanie_start_stop_poczatek;
;int dobieram_dawke;
;int leje_klej;
;int dawka_kleju_wyswietlona;
;int wyk1;
;
;void zeruj_licznik(char *proces)
; 0000 005D {

	.CSEG
_zeruj_licznik:
; 0000 005E 
; 0000 005F if(strcmp(proces, "przechodzi_kubek")==0)
;	*proces -> Y+0
	CALL SUBOPT_0x0
	__POINTW1MN _0x4,0
	CALL SUBOPT_0x1
	BRNE _0x3
; 0000 0060   milisekundy_przechodzi_kubek = ulamki_sekund_1;
	CALL SUBOPT_0x2
	STS  _milisekundy_przechodzi_kubek,R30
	STS  _milisekundy_przechodzi_kubek+1,R31
	STS  _milisekundy_przechodzi_kubek+2,R22
	STS  _milisekundy_przechodzi_kubek+3,R23
; 0000 0061 
; 0000 0062 if(strcmp(proces, "czas_kroku")==0)
_0x3:
	CALL SUBOPT_0x0
	__POINTW1MN _0x4,17
	CALL SUBOPT_0x1
	BRNE _0x5
; 0000 0063   milisekundy_czas_kroku = ulamki_sekund_1;
	CALL SUBOPT_0x2
	STS  _milisekundy_czas_kroku,R30
	STS  _milisekundy_czas_kroku+1,R31
	STS  _milisekundy_czas_kroku+2,R22
	STS  _milisekundy_czas_kroku+3,R23
; 0000 0064 
; 0000 0065 if(strcmp(proces, "pobieram_banderole")==0)
_0x5:
	CALL SUBOPT_0x0
	__POINTW1MN _0x4,28
	CALL SUBOPT_0x1
	BRNE _0x6
; 0000 0066   milisekundy_pobieram_banderole = ulamki_sekund_1;
	CALL SUBOPT_0x2
	STS  _milisekundy_pobieram_banderole,R30
	STS  _milisekundy_pobieram_banderole+1,R31
	STS  _milisekundy_pobieram_banderole+2,R22
	STS  _milisekundy_pobieram_banderole+3,R23
; 0000 0067 
; 0000 0068 if(strcmp(proces, "przejazd_nad_klejem")==0)
_0x6:
	CALL SUBOPT_0x0
	__POINTW1MN _0x4,47
	CALL SUBOPT_0x1
	BRNE _0x7
; 0000 0069   milisekundy_przejazd_nad_klejem = ulamki_sekund_1;
	CALL SUBOPT_0x2
	STS  _milisekundy_przejazd_nad_klejem,R30
	STS  _milisekundy_przejazd_nad_klejem+1,R31
	STS  _milisekundy_przejazd_nad_klejem+2,R22
	STS  _milisekundy_przejazd_nad_klejem+3,R23
; 0000 006A 
; 0000 006B if(strcmp(proces, "naklejam")==0)
_0x7:
	CALL SUBOPT_0x0
	__POINTW1MN _0x4,67
	CALL SUBOPT_0x1
	BRNE _0x8
; 0000 006C   milisekundy_naklejam = ulamki_sekund_1;
	CALL SUBOPT_0x2
	STS  _milisekundy_naklejam,R30
	STS  _milisekundy_naklejam+1,R31
	STS  _milisekundy_naklejam+2,R22
	STS  _milisekundy_naklejam+3,R23
; 0000 006D 
; 0000 006E if(strcmp(proces, "oklejanie_boczne")==0)
_0x8:
	CALL SUBOPT_0x0
	__POINTW1MN _0x4,76
	CALL SUBOPT_0x1
	BRNE _0x9
; 0000 006F   milisekundy_oklejanie_boczne = ulamki_sekund_1;
	CALL SUBOPT_0x2
	STS  _milisekundy_oklejanie_boczne,R30
	STS  _milisekundy_oklejanie_boczne+1,R31
	STS  _milisekundy_oklejanie_boczne+2,R22
	STS  _milisekundy_oklejanie_boczne+3,R23
; 0000 0070 
; 0000 0071 
; 0000 0072 }
_0x9:
	RJMP _0x20A0004

	.DSEG
_0x4:
	.BYTE 0x5D
;
;long int odczyt_licznik(char *proces)
; 0000 0075 {

	.CSEG
_odczyt_licznik:
; 0000 0076 long int stan_licznika;
; 0000 0077 
; 0000 0078 if(strcmp(proces, "przechodzi_kubek")==0)
	SBIW R28,4
;	*proces -> Y+4
;	stan_licznika -> Y+0
	CALL SUBOPT_0x3
	__POINTW1MN _0xB,0
	CALL SUBOPT_0x1
	BRNE _0xA
; 0000 0079     stan_licznika = ulamki_sekund_1 - milisekundy_przechodzi_kubek;
	LDS  R26,_milisekundy_przechodzi_kubek
	LDS  R27,_milisekundy_przechodzi_kubek+1
	LDS  R24,_milisekundy_przechodzi_kubek+2
	LDS  R25,_milisekundy_przechodzi_kubek+3
	CALL SUBOPT_0x4
; 0000 007A 
; 0000 007B if(strcmp(proces, "czas_kroku")==0)
_0xA:
	CALL SUBOPT_0x3
	__POINTW1MN _0xB,17
	CALL SUBOPT_0x1
	BRNE _0xC
; 0000 007C     stan_licznika = ulamki_sekund_1 - milisekundy_czas_kroku;
	LDS  R26,_milisekundy_czas_kroku
	LDS  R27,_milisekundy_czas_kroku+1
	LDS  R24,_milisekundy_czas_kroku+2
	LDS  R25,_milisekundy_czas_kroku+3
	CALL SUBOPT_0x4
; 0000 007D 
; 0000 007E if(strcmp(proces, "pobieram_banderole")==0)
_0xC:
	CALL SUBOPT_0x3
	__POINTW1MN _0xB,28
	CALL SUBOPT_0x1
	BRNE _0xD
; 0000 007F     stan_licznika = ulamki_sekund_1 - milisekundy_pobieram_banderole;
	LDS  R26,_milisekundy_pobieram_banderole
	LDS  R27,_milisekundy_pobieram_banderole+1
	LDS  R24,_milisekundy_pobieram_banderole+2
	LDS  R25,_milisekundy_pobieram_banderole+3
	CALL SUBOPT_0x4
; 0000 0080 
; 0000 0081 if(strcmp(proces, "przejazd_nad_klejem")==0)
_0xD:
	CALL SUBOPT_0x3
	__POINTW1MN _0xB,47
	CALL SUBOPT_0x1
	BRNE _0xE
; 0000 0082     stan_licznika = ulamki_sekund_1 - milisekundy_przejazd_nad_klejem;
	LDS  R26,_milisekundy_przejazd_nad_klejem
	LDS  R27,_milisekundy_przejazd_nad_klejem+1
	LDS  R24,_milisekundy_przejazd_nad_klejem+2
	LDS  R25,_milisekundy_przejazd_nad_klejem+3
	CALL SUBOPT_0x4
; 0000 0083 
; 0000 0084 if(strcmp(proces, "naklejam")==0)
_0xE:
	CALL SUBOPT_0x3
	__POINTW1MN _0xB,67
	CALL SUBOPT_0x1
	BRNE _0xF
; 0000 0085     stan_licznika = ulamki_sekund_1 - milisekundy_naklejam;
	LDS  R26,_milisekundy_naklejam
	LDS  R27,_milisekundy_naklejam+1
	LDS  R24,_milisekundy_naklejam+2
	LDS  R25,_milisekundy_naklejam+3
	CALL SUBOPT_0x4
; 0000 0086 
; 0000 0087 if(strcmp(proces, "oklejanie_boczne")==0)
_0xF:
	CALL SUBOPT_0x3
	__POINTW1MN _0xB,76
	CALL SUBOPT_0x1
	BRNE _0x10
; 0000 0088     stan_licznika = ulamki_sekund_1 - milisekundy_oklejanie_boczne;
	LDS  R26,_milisekundy_oklejanie_boczne
	LDS  R27,_milisekundy_oklejanie_boczne+1
	LDS  R24,_milisekundy_oklejanie_boczne+2
	LDS  R25,_milisekundy_oklejanie_boczne+3
	CALL SUBOPT_0x4
; 0000 0089 
; 0000 008A 
; 0000 008B 
; 0000 008C 
; 0000 008D return stan_licznika;
_0x10:
	CALL __GETD1S0
	RJMP _0x20A0003
; 0000 008E }

	.DSEG
_0xB:
	.BYTE 0x5D
;
;
;void bez_przerwania()
; 0000 0092 {

	.CSEG
; 0000 0093 if(zezzwalaj_na_oklejenie_boczne == 1)
; 0000 0094     {
; 0000 0095     licznik_pionowego_czujnika++;
; 0000 0096     if(PORTA.7 == 0 & licznik_pionowego_czujnika > 6 & srednie_kubki == 0)
; 0000 0097         {
; 0000 0098         PORTA.6 = 0;
; 0000 0099         oklejam_bok = 1;
; 0000 009A         licznik_pionowego_czujnika = 0;
; 0000 009B         zezzwalaj_na_oklejenie_boczne = 0;
; 0000 009C         zeruj_licznik("oklejanie_boczne");
; 0000 009D         }
; 0000 009E     if(PORTA.7 == 0 & licznik_pionowego_czujnika > 12 & srednie_kubki == 1)
; 0000 009F         {
; 0000 00A0         PORTA.6 = 0;
; 0000 00A1         oklejam_bok = 1;
; 0000 00A2         licznik_pionowego_czujnika = 0;
; 0000 00A3         zezzwalaj_na_oklejenie_boczne = 0;
; 0000 00A4         zeruj_licznik("oklejanie_boczne");
; 0000 00A5         }
; 0000 00A6     }
; 0000 00A7 }

	.DSEG
_0x15:
	.BYTE 0x22
;
;
;void wybor_trybu_pracy()
; 0000 00AB {

	.CSEG
; 0000 00AC if(PINB.5 == 1 & PINB.4 == 1)
; 0000 00AD   {
; 0000 00AE   srednie_kubki = 0;
; 0000 00AF   fast = 0;
; 0000 00B0   lcd_clear();
; 0000 00B1   lcd_gotoxy(0,0);
; 0000 00B2   lcd_puts("ONLINE-HASSO");
; 0000 00B3   lcd_gotoxy(0,1);
; 0000 00B4   lcd_puts("SLOW");
; 0000 00B5   }
; 0000 00B6 
; 0000 00B7 if(PINB.5 == 0 & PINB.4 == 1)
; 0000 00B8   {
; 0000 00B9   srednie_kubki = 1;
; 0000 00BA   fast = 0;
; 0000 00BB   lcd_clear();
; 0000 00BC   lcd_gotoxy(0,0);
; 0000 00BD   lcd_puts("ONLINE-250");
; 0000 00BE   lcd_gotoxy(0,1);
; 0000 00BF   lcd_puts("SLOW");
; 0000 00C0   }
; 0000 00C1 
; 0000 00C2 if(PINB.5 == 1 & PINB.4 == 0)
; 0000 00C3   {
; 0000 00C4   srednie_kubki = 0;
; 0000 00C5   fast = 1;
; 0000 00C6   lcd_clear();
; 0000 00C7   lcd_gotoxy(0,0);
; 0000 00C8   lcd_puts("ONLINE-HASSO");
; 0000 00C9   lcd_gotoxy(0,1);
; 0000 00CA   lcd_puts("FAST");
; 0000 00CB   }
; 0000 00CC 
; 0000 00CD 
; 0000 00CE if(PINB.5 == 0 & PINB.4 == 0)
; 0000 00CF   {
; 0000 00D0   srednie_kubki = 1;
; 0000 00D1   fast = 1;
; 0000 00D2   lcd_clear();
; 0000 00D3   lcd_gotoxy(0,0);
; 0000 00D4   lcd_puts("ONLINE-250");
; 0000 00D5   lcd_gotoxy(0,1);
; 0000 00D6   lcd_puts("FAST");
; 0000 00D7   }
; 0000 00D8 //Chaos - jak chaos guzik wlaczony to tamte guzki nie chodza
; 0000 00D9 if(PINB.3 == 0 & PINB.4 == 0)
; 0000 00DA   {
; 0000 00DB   srednie_kubki = 2;
; 0000 00DC   fast = 1;
; 0000 00DD   lcd_clear();
; 0000 00DE   lcd_gotoxy(0,0);
; 0000 00DF   lcd_puts("ONLINE-CHAOS");
; 0000 00E0   lcd_gotoxy(0,1);
; 0000 00E1   lcd_puts("FAST");
; 0000 00E2   }
; 0000 00E3 
; 0000 00E4 
; 0000 00E5 if(PINB.3 == 0 & PINB.4 == 1)
; 0000 00E6   {
; 0000 00E7   srednie_kubki = 2;
; 0000 00E8   fast = 0;
; 0000 00E9   lcd_clear();
; 0000 00EA   lcd_gotoxy(0,0);
; 0000 00EB   lcd_puts("ONLINE-CHAOS");
; 0000 00EC   lcd_gotoxy(0,1);
; 0000 00ED   lcd_puts("SLOW");
; 0000 00EE   }
; 0000 00EF 
; 0000 00F0 }

	.DSEG
_0x1A:
	.BYTE 0x68
;
;void wybor_trybu_pracy_bez_fast()
; 0000 00F3 {

	.CSEG
_wybor_trybu_pracy_bez_fast:
; 0000 00F4 int wybor_kubka;
; 0000 00F5 wybor_kubka = 0;
	ST   -Y,R17
	ST   -Y,R16
;	wybor_kubka -> R16,R17
	__GETWRN 16,17,0
; 0000 00F6 
; 0000 00F7 if(PINB.3 == 1 & PINB.4 == 1 & PINB.5 == 1)
	CALL SUBOPT_0x5
	CALL SUBOPT_0x6
	LDI  R30,LOW(1)
	CALL __EQB12
	AND  R30,R0
	BREQ _0x20
; 0000 00F8   {
; 0000 00F9   srednie_kubki = 0;
	LDI  R30,LOW(0)
	STS  _srednie_kubki,R30
	STS  _srednie_kubki+1,R30
; 0000 00FA   fast = 1;
	CALL SUBOPT_0x7
; 0000 00FB   lcd_clear();
; 0000 00FC   lcd_gotoxy(0,0);
; 0000 00FD   lcd_puts("ONLINE-HASSO");
	__POINTW1MN _0x21,0
	CALL SUBOPT_0x8
; 0000 00FE   lcd_gotoxy(0,1);
	CALL SUBOPT_0x9
; 0000 00FF   lcd_puts("FAST");
	__POINTW1MN _0x21,13
	CALL SUBOPT_0x8
; 0000 0100   wybor_kubka = 1;
	__GETWRN 16,17,1
; 0000 0101   }
; 0000 0102 
; 0000 0103 
; 0000 0104 if(PINB.3 == 1 & PINB.4 == 0 & PINB.5 == 0)
_0x20:
	CALL SUBOPT_0x5
	CALL SUBOPT_0xA
	LDI  R26,0
	SBIC 0x16,5
	LDI  R26,1
	CALL SUBOPT_0xB
	BREQ _0x22
; 0000 0105   {
; 0000 0106   srednie_kubki = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0xC
; 0000 0107   fast = 1;
; 0000 0108   lcd_clear();
; 0000 0109   lcd_gotoxy(0,0);
; 0000 010A   lcd_puts("ONLINE-ULTIMATE");
	__POINTW1MN _0x21,18
	CALL SUBOPT_0x8
; 0000 010B   lcd_gotoxy(0,1);
	CALL SUBOPT_0x9
; 0000 010C   lcd_puts("FAST");
	__POINTW1MN _0x21,34
	CALL SUBOPT_0x8
; 0000 010D   wybor_kubka = 1;
	__GETWRN 16,17,1
; 0000 010E   }
; 0000 010F 
; 0000 0110 if(PINB.3 == 0 & PINB.4 == 1 & PINB.5 == 0)
_0x22:
	LDI  R26,0
	SBIC 0x16,3
	LDI  R26,1
	CALL SUBOPT_0xD
	LDI  R26,0
	SBIC 0x16,4
	LDI  R26,1
	CALL SUBOPT_0x6
	CALL SUBOPT_0xB
	BREQ _0x23
; 0000 0111   {
; 0000 0112   srednie_kubki = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0xC
; 0000 0113   fast = 1;
; 0000 0114   lcd_clear();
; 0000 0115   lcd_gotoxy(0,0);
; 0000 0116   lcd_puts("ONLINE-CHAOS");
	__POINTW1MN _0x21,39
	CALL SUBOPT_0x8
; 0000 0117   lcd_gotoxy(0,1);
	CALL SUBOPT_0x9
; 0000 0118   lcd_puts("FAST");
	__POINTW1MN _0x21,52
	CALL SUBOPT_0x8
; 0000 0119   wybor_kubka = 1;
	__GETWRN 16,17,1
; 0000 011A   }
; 0000 011B 
; 0000 011C if(wybor_kubka == 0)
_0x23:
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x24
; 0000 011D   {
; 0000 011E   lcd_clear();
	CALL SUBOPT_0xE
; 0000 011F   lcd_gotoxy(0,0);
; 0000 0120   lcd_puts("BRAK WYBORU");
	__POINTW1MN _0x21,57
	CALL SUBOPT_0x8
; 0000 0121   lcd_gotoxy(0,1);
	CALL SUBOPT_0x9
; 0000 0122   lcd_puts("KUBKA");
	__POINTW1MN _0x21,69
	CALL SUBOPT_0x8
; 0000 0123   while(1)
_0x25:
; 0000 0124     {
; 0000 0125     }
	RJMP _0x25
; 0000 0126   }
; 0000 0127 
; 0000 0128 }
_0x24:
	LD   R16,Y+
	LD   R17,Y+
	RET

	.DSEG
_0x21:
	.BYTE 0x4B
;
;
;
;
;
;void obsluga_dawki_kleju()
; 0000 012F {

	.CSEG
_obsluga_dawki_kleju:
; 0000 0130 if(PINC.6 == 0 & dobieram_dawke == 0)
	LDI  R26,0
	SBIC 0x13,6
	LDI  R26,1
	CALL SUBOPT_0xD
	LDS  R26,_dobieram_dawke
	LDS  R27,_dobieram_dawke+1
	CALL SUBOPT_0xF
	AND  R30,R0
	BREQ _0x28
; 0000 0131     {
; 0000 0132     dobieram_dawke = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _dobieram_dawke,R30
	STS  _dobieram_dawke+1,R31
; 0000 0133     dawka_kleju++;
	LDI  R26,LOW(_dawka_kleju)
	LDI  R27,HIGH(_dawka_kleju)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 0134     if(dawka_kleju > 7)
	CALL SUBOPT_0x10
	SBIW R26,8
	BRLT _0x29
; 0000 0135         dawka_kleju = 0;
	LDI  R30,LOW(0)
	STS  _dawka_kleju,R30
	STS  _dawka_kleju+1,R30
; 0000 0136     }
_0x29:
; 0000 0137 if(PINC.6 == 1 & dobieram_dawke == 1)
_0x28:
	LDI  R26,0
	SBIC 0x13,6
	LDI  R26,1
	CALL SUBOPT_0x11
	LDS  R26,_dobieram_dawke
	LDS  R27,_dobieram_dawke+1
	CALL SUBOPT_0x12
	AND  R30,R0
	BREQ _0x2A
; 0000 0138     dobieram_dawke = 0;
	LDI  R30,LOW(0)
	STS  _dobieram_dawke,R30
	STS  _dobieram_dawke+1,R30
; 0000 0139 }
_0x2A:
	RET
;
;void obsluga_kleju()
; 0000 013C {
_obsluga_kleju:
; 0000 013D if(PINC.4 == 0)
	SBIC 0x13,4
	RJMP _0x2B
; 0000 013E         {
; 0000 013F         if(wyswietl_obecnosc_kleju == 1)
	LDS  R26,_wyswietl_obecnosc_kleju
	LDS  R27,_wyswietl_obecnosc_kleju+1
	SBIW R26,1
	BRNE _0x2C
; 0000 0140            {
; 0000 0141            lcd_clear();
	CALL SUBOPT_0xE
; 0000 0142            lcd_gotoxy(0,0);
; 0000 0143            lcd_puts("GLUE LOADED");
	__POINTW1MN _0x2D,0
	CALL SUBOPT_0x8
; 0000 0144            }
; 0000 0145         wyswietl_obecnosc_kleju = 0;
_0x2C:
	LDI  R30,LOW(0)
	STS  _wyswietl_obecnosc_kleju,R30
	STS  _wyswietl_obecnosc_kleju+1,R30
; 0000 0146         wyswietl_brak_kleju = 1;
	CALL SUBOPT_0x13
; 0000 0147         jest_klej = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _jest_klej,R30
	STS  _jest_klej+1,R31
; 0000 0148         if(licznik_wyswietlania_kleju < licznik_wyswietlania_kleju_stala)
	CALL SUBOPT_0x14
	CALL __CPD21
	BRGE _0x2E
; 0000 0149             licznik_wyswietlania_kleju++;
	LDI  R26,LOW(_licznik_wyswietlania_kleju)
	LDI  R27,HIGH(_licznik_wyswietlania_kleju)
	CALL SUBOPT_0x15
; 0000 014A 
; 0000 014B         }
_0x2E:
; 0000 014C else
	RJMP _0x2F
_0x2B:
; 0000 014D         {
; 0000 014E         if(wyswietl_brak_kleju == 1)
	LDS  R26,_wyswietl_brak_kleju
	LDS  R27,_wyswietl_brak_kleju+1
	SBIW R26,1
	BRNE _0x30
; 0000 014F             {
; 0000 0150             lcd_clear();
	CALL SUBOPT_0xE
; 0000 0151             lcd_gotoxy(0,0);
; 0000 0152             lcd_puts("LOAD GLUE");
	__POINTW1MN _0x2D,12
	CALL SUBOPT_0x8
; 0000 0153             }
; 0000 0154         wyswietl_obecnosc_kleju = 1;
_0x30:
	CALL SUBOPT_0x16
; 0000 0155         licznik_wyswietlania_kleju = 0;
	LDI  R30,LOW(0)
	STS  _licznik_wyswietlania_kleju,R30
	STS  _licznik_wyswietlania_kleju+1,R30
	STS  _licznik_wyswietlania_kleju+2,R30
	STS  _licznik_wyswietlania_kleju+3,R30
; 0000 0156         wyswietl_brak_kleju = 0;
	STS  _wyswietl_brak_kleju,R30
	STS  _wyswietl_brak_kleju+1,R30
; 0000 0157         jest_klej = 0;
	STS  _jest_klej,R30
	STS  _jest_klej+1,R30
; 0000 0158         }
_0x2F:
; 0000 0159 }
	RET

	.DSEG
_0x2D:
	.BYTE 0x16
;
;
;void sekwencja_wylaczenia_falownika_nowa()
; 0000 015D {

	.CSEG
; 0000 015E }
;
;
;void sekwencja_wylaczenia_falownika()
; 0000 0162 {
_sekwencja_wylaczenia_falownika:
; 0000 0163 czas_wylaczenia_falownika = 0;
	CALL SUBOPT_0x17
; 0000 0164            //run
; 0000 0165        if((PINB.0 == 0 & dostep_do_podajnika == 0) | pracuje == 1)
	LDI  R26,0
	SBIC 0x16,0
	LDI  R26,1
	CALL SUBOPT_0xD
	MOVW R26,R10
	CALL SUBOPT_0xF
	CALL SUBOPT_0x18
	CALL SUBOPT_0x12
	OR   R30,R0
	BREQ _0x31
; 0000 0166             {
; 0000 0167             if(pracuje == 0 & poczatek_serii == 1)
	LDS  R26,_pracuje
	LDS  R27,_pracuje+1
	CALL SUBOPT_0xF
	MOV  R0,R30
	LDS  R26,_poczatek_serii
	LDS  R27,_poczatek_serii+1
	CALL SUBOPT_0x12
	AND  R30,R0
	BREQ _0x32
; 0000 0168                 {
; 0000 0169                 PORTD.2 = 0; //ZMIANA STANU
	CBI  0x12,2
; 0000 016A                 poczatek_serii = 0;
	LDI  R30,LOW(0)
	STS  _poczatek_serii,R30
	STS  _poczatek_serii+1,R30
; 0000 016B                 }
; 0000 016C             }
_0x32:
; 0000 016D         else
	RJMP _0x35
_0x31:
; 0000 016E             {
; 0000 016F             if(PORTD.2 == 0)  //ZMIANA STANU
	SBIC 0x12,2
	RJMP _0x36
; 0000 0170                {                                  //100000  //dziele przez 2
; 0000 0171                 while(czas_wylaczenia_falownika < 50000)
_0x37:
	CALL SUBOPT_0x19
	__CPD2N 0xC350
	BRGE _0x39
; 0000 0172                     czas_wylaczenia_falownika++;  //200000
	CALL SUBOPT_0x1A
	RJMP _0x37
_0x39:
; 0000 0173 while(czas_wylaczenia_falownika < 100000)
_0x3A:
	CALL SUBOPT_0x19
	__CPD2N 0x186A0
	BRGE _0x3C
; 0000 0174                     {
; 0000 0175                     czas_wylaczenia_falownika++;
	CALL SUBOPT_0x1A
; 0000 0176                     PORTA.7 = 0;  //koniec zatrzymania
	CBI  0x1B,7
; 0000 0177                     widzi_kubek = 0;
	CALL SUBOPT_0x1B
; 0000 0178                     }
	RJMP _0x3A
_0x3C:
; 0000 0179                                                  //240000
; 0000 017A                 while(czas_wylaczenia_falownika < 120000)
_0x3F:
	CALL SUBOPT_0x19
	__CPD2N 0x1D4C0
	BRGE _0x41
; 0000 017B                     {
; 0000 017C                     czas_wylaczenia_falownika++;
	CALL SUBOPT_0x1A
; 0000 017D                     widzi_kubek = 0;
	CALL SUBOPT_0x1B
; 0000 017E                     }
	RJMP _0x3F
_0x41:
; 0000 017F                                                  //350000
; 0000 0180                 while(czas_wylaczenia_falownika < 175000)
_0x42:
	CALL SUBOPT_0x19
	__CPD2N 0x2AB98
	BRGE _0x44
; 0000 0181                     {
; 0000 0182                     czas_wylaczenia_falownika++;
	CALL SUBOPT_0x1A
; 0000 0183                     widzi_kubek = 0;
	CALL SUBOPT_0x1B
; 0000 0184                     }
	RJMP _0x42
_0x44:
; 0000 0185 
; 0000 0186                 PORTD.2 = 1; //wylacz falownik //ZMIANA STANU
	SBI  0x12,2
; 0000 0187                 czas = 0;
	CALL SUBOPT_0x1C
; 0000 0188                 licznik_wlacznika_run = 0;
	LDI  R30,LOW(0)
	STS  _licznik_wlacznika_run,R30
	STS  _licznik_wlacznika_run+1,R30
	STS  _licznik_wlacznika_run+2,R30
	STS  _licznik_wlacznika_run+3,R30
; 0000 0189                 poczatek_serii = 1;
	CALL SUBOPT_0x1D
; 0000 018A                 kolejkowanie_start_stop_poczatek = 1;
; 0000 018B                }
; 0000 018C 
; 0000 018D 
; 0000 018E             }
_0x36:
_0x35:
; 0000 018F }
	RET
;
;
;
;
;
;
;void kolejkowanie_start_stop()
; 0000 0197 {
_kolejkowanie_start_stop:
; 0000 0198 if(kolejkowanie_start_stop_poczatek == 1 & PINB.0 == 0)
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x12
	CALL SUBOPT_0x1F
	CALL SUBOPT_0xB
	BREQ _0x47
; 0000 0199     {
; 0000 019A     if(PINB.6 == 0 & kubek == 0)
	LDI  R26,0
	SBIC 0x16,6
	LDI  R26,1
	CALL SUBOPT_0xD
	CALL SUBOPT_0x20
	CALL SUBOPT_0xF
	AND  R30,R0
	BREQ _0x48
; 0000 019B         {
; 0000 019C         czas = 0;
	CALL SUBOPT_0x1C
; 0000 019D         kubek = 1;
	CALL SUBOPT_0x21
; 0000 019E         }
; 0000 019F     if(kubek == 1 & czas > 10000)
_0x48:
	CALL SUBOPT_0x20
	CALL SUBOPT_0x12
	CALL SUBOPT_0x22
	__GETD1N 0x2710
	CALL __GTD12
	AND  R30,R0
	BREQ _0x49
; 0000 01A0         {
; 0000 01A1         czas = 0;
	CALL SUBOPT_0x1C
; 0000 01A2         kubek = 0;
	CALL SUBOPT_0x23
; 0000 01A3         kolejkowanie_start_stop_poczatek = 0;
	LDI  R30,LOW(0)
	STS  _kolejkowanie_start_stop_poczatek,R30
	STS  _kolejkowanie_start_stop_poczatek+1,R30
; 0000 01A4         }
; 0000 01A5 
; 0000 01A6     }
_0x49:
; 0000 01A7 
; 0000 01A8 if(PINB.6 == 0 & kubek == 0 & PINB.0 == 0 & kolejkowanie_start_stop_poczatek == 0)
_0x47:
	LDI  R26,0
	SBIC 0x16,6
	LDI  R26,1
	CALL SUBOPT_0xD
	CALL SUBOPT_0x20
	CALL SUBOPT_0xF
	AND  R0,R30
	LDI  R26,0
	SBIC 0x16,0
	LDI  R26,1
	CALL SUBOPT_0xA
	CALL SUBOPT_0x1E
	CALL SUBOPT_0xF
	AND  R30,R0
	BREQ _0x4A
; 0000 01A9        {
; 0000 01AA        czas = 0;
	CALL SUBOPT_0x1C
; 0000 01AB        kubek = 1;
	CALL SUBOPT_0x21
; 0000 01AC        zatrzymalem_kubek = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _zatrzymalem_kubek,R30
	STS  _zatrzymalem_kubek+1,R31
; 0000 01AD        }
; 0000 01AE                         //500
; 0000 01AF if(kubek == 1 & czas > 400 & kolejkowanie_start_stop_poczatek == 0)
_0x4A:
	CALL SUBOPT_0x20
	CALL SUBOPT_0x12
	CALL SUBOPT_0x22
	__GETD1N 0x190
	CALL __GTD12
	AND  R0,R30
	CALL SUBOPT_0x1E
	CALL SUBOPT_0xF
	AND  R30,R0
	BREQ _0x4B
; 0000 01B0     {
; 0000 01B1     //zatrzymalem_kubek = 1;
; 0000 01B2     PORTD.2 = 1;  //wy³¹czenie falownika
	SBI  0x12,2
; 0000 01B3     kubek = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x24
; 0000 01B4     czas = 0;
; 0000 01B5     }
; 0000 01B6                        //500
; 0000 01B7 
; 0000 01B8 if(kubek == 2 & czas > 1500)  //7800
_0x4B:
	CALL SUBOPT_0x20
	CALL SUBOPT_0x25
	CALL SUBOPT_0x22
	__GETD1N 0x5DC
	CALL __GTD12
	AND  R30,R0
	BREQ _0x4E
; 0000 01B9      {
; 0000 01BA      PORTA.7 = 1;  //zablokuj kubka
	SBI  0x1B,7
; 0000 01BB      kubek = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0x24
; 0000 01BC      czas = 0;
; 0000 01BD      }
; 0000 01BE 
; 0000 01BF if(kubek == 4)
_0x4E:
	CALL SUBOPT_0x20
	SBIW R26,4
	BRNE _0x51
; 0000 01C0      {
; 0000 01C1      PORTA.0 = 0;  //otworz przegrode
	CBI  0x1B,0
; 0000 01C2      czas = 0;
	CALL SUBOPT_0x1C
; 0000 01C3      kubek = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL SUBOPT_0x26
; 0000 01C4      }
; 0000 01C5 
; 0000 01C6 if(kubek == 5 & czas > 4500 & srednie_kubki == 1)
_0x51:
	CALL SUBOPT_0x27
	CALL SUBOPT_0x28
	CALL SUBOPT_0x29
	CALL SUBOPT_0x12
	AND  R30,R0
	BREQ _0x54
; 0000 01C7      {
; 0000 01C8      PORTA.0 = 1;  //zamknij przegrode                //male kubki
	SBI  0x1B,0
; 0000 01C9      czas = 0;
	CALL SUBOPT_0x1C
; 0000 01CA      kubek = 0;
	CALL SUBOPT_0x23
; 0000 01CB      }
; 0000 01CC                         //4800
; 0000 01CD if(kubek == 5 & czas > 5000 & srednie_kubki == 0)
_0x54:
	CALL SUBOPT_0x27
	__GETD1N 0x1388
	CALL SUBOPT_0x2A
	CALL SUBOPT_0xF
	AND  R30,R0
	BREQ _0x57
; 0000 01CE      {                                               //hasso
; 0000 01CF      PORTA.0 = 1;  //zamknij przegrode
	SBI  0x1B,0
; 0000 01D0      czas = 0;
	CALL SUBOPT_0x1C
; 0000 01D1      kubek = 0;
	CALL SUBOPT_0x23
; 0000 01D2      }
; 0000 01D3 
; 0000 01D4 if(kubek == 5 & czas > 5700 & srednie_kubki == 2)  //5800
_0x57:
	CALL SUBOPT_0x27
	__GETD1N 0x1644
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x25
	AND  R30,R0
	BREQ _0x5A
; 0000 01D5      {
; 0000 01D6      PORTA.0 = 1;  //zamknij przegrode                //haos
	SBI  0x1B,0
; 0000 01D7      czas = 0;
	CALL SUBOPT_0x1C
; 0000 01D8      kubek = 6;
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CALL SUBOPT_0x26
; 0000 01D9      }
; 0000 01DA 
; 0000 01DB if(kubek == 6 & czas > 900 & srednie_kubki == 2)  //700
_0x5A:
	CALL SUBOPT_0x20
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x22
	__GETD1N 0x384
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x25
	AND  R30,R0
	BREQ _0x5D
; 0000 01DC      {
; 0000 01DD      czas = 0;
	CALL SUBOPT_0x1C
; 0000 01DE      kubek = 0;
	CALL SUBOPT_0x23
; 0000 01DF      }
; 0000 01E0 
; 0000 01E1 
; 0000 01E2 
; 0000 01E3 //if(kubek == 4 & PINB.6 == 1)  //nie ma kubka
; 0000 01E4 //     {
; 0000 01E5 //     PORTA.0 = 0;  //otworz przegrode
; 0000 01E6 //     czas = 0;
; 0000 01E7 //     kubek = 0;
; 0000 01E8 //     }
; 0000 01E9 
; 0000 01EA 
; 0000 01EB 
; 0000 01EC 
; 0000 01ED 
; 0000 01EE 
; 0000 01EF 
; 0000 01F0 
; 0000 01F1 
; 0000 01F2 /*
; 0000 01F3 
; 0000 01F4 if(PINB.6 == 0 & kubek == 0 & PINB.0 == 0)
; 0000 01F5        {
; 0000 01F6        czas = 0;
; 0000 01F7        kubek = 1;
; 0000 01F8        }
; 0000 01F9 
; 0000 01FA if(kubek == 1 & czas > 2000)  //7800
; 0000 01FB      {
; 0000 01FC      PORTA.0 = 0;  //otworz przegrode
; 0000 01FD      kubek = 2;
; 0000 01FE      czas = 0;
; 0000 01FF      }
; 0000 0200                        //10300
; 0000 0201 if(kubek == 2 & czas > 2000)
; 0000 0202       {
; 0000 0203       PORTA.0 = 1;  //zamknij przegrode
; 0000 0204       kubek = 3;
; 0000 0205       czas = 0;
; 0000 0206       }
; 0000 0207 
; 0000 0208 //if(PINC.1 == 1 & kubek == 3)
; 0000 0209 //        {
; 0000 020A //        kubek = 4;
; 0000 020B //        czas = 0;
; 0000 020C //        }
; 0000 020D 
; 0000 020E if(czas > 1 & kubek == 3)
; 0000 020F    {
; 0000 0210    PORTA.1 = 1;  //szpikulec wystaw
; 0000 0211    //PORTD.2 = 1;  //wy³¹czenie falownika
; 0000 0212    kubek = 4;
; 0000 0213    zatrzymalem_kubek = 1;
; 0000 0214    czas = 0;
; 0000 0215    }
; 0000 0216 
; 0000 0217 if(czas > 1500 & kubek == 4)
; 0000 0218     {
; 0000 0219     PORTD.2 = 1;  //wy³¹czenie falownika
; 0000 021A     kubek = 5;
; 0000 021B     }
; 0000 021C 
; 0000 021D 
; 0000 021E if(czas > 2200 & kubek == 5 & srednie_kubki == 0)
; 0000 021F    {
; 0000 0220    PORTA.7 = 1;  //zablokuj kubka
; 0000 0221    kubek = 6;
; 0000 0222    //PORTD.2 = 1;  //wy³¹czenie falownika
; 0000 0223    }
; 0000 0224 
; 0000 0225 if(czas > 3200 & kubek == 5 & srednie_kubki == 1)
; 0000 0226    {
; 0000 0227    PORTA.7 = 1;  //zablokuj kubka
; 0000 0228    kubek = 6;
; 0000 0229    //PORTD.2 = 1;  //wy³¹czenie falownika
; 0000 022A    }
; 0000 022B 
; 0000 022C if(czas > 4200 & kubek == 5 & srednie_kubki == 2)
; 0000 022D    {
; 0000 022E    PORTA.7 = 1;  //zablokuj kubka
; 0000 022F    kubek = 6;
; 0000 0230    //PORTD.2 = 1;  //wy³¹czenie falownika
; 0000 0231    }
; 0000 0232 
; 0000 0233 //if(PINC.1 == 0 & kubek == 6)   //przejechal kubek wiec moge od nowa dzialac
; 0000 0234 //   {
; 0000 0235 //   kubek = 7;
; 0000 0236 //   czas = 0;
; 0000 0237 //   }
; 0000 0238 //
; 0000 0239 //if(kubek == 5 & czas > 5000)
; 0000 023A //   kubek = 0;
; 0000 023B 
; 0000 023C           -
; 0000 023D 
; 0000 023E 
; 0000 023F */
; 0000 0240 }
_0x5D:
	RET
;
;
;void kolejkowanie_nowe()
; 0000 0244 {
; 0000 0245 
; 0000 0246 
; 0000 0247 zezwolenie_run = 1;
; 0000 0248 
; 0000 0249          //zmieniam polaryzacje pod podpieciu do karty
; 0000 024A if(PINB.6 == 0 & kubek == 0 & PINB.0 == 0 & zezwolenie_run == 1)
; 0000 024B         {
; 0000 024C         kubek = 1;
; 0000 024D         czas = 0;
; 0000 024E         }
; 0000 024F          //7500 16.01.2016
; 0000 0250 if(czas > 7800 & kubek == 1 & zezwolenie_run == 1)
; 0000 0251     {
; 0000 0252     PORTA.0 = 0;  //otworz przegrode
; 0000 0253     kubek = 2;
; 0000 0254     }
; 0000 0255           //10000 - 09.01.2016
; 0000 0256 if(czas > 10300 & czas < 12500 & kubek == 2 & zezwolenie_run == 1)
; 0000 0257    {
; 0000 0258    //PORTA.0 = 1;  //zamknij przegrode
; 0000 0259    PORTA.1 = 1;  //szpikulec wystaw
; 0000 025A    kubek = 3;
; 0000 025B    zatrzymalem_kubek = 1;
; 0000 025C    }
; 0000 025D 
; 0000 025E if(czas > 12500 & kubek == 3 & srednie_kubki == 0 & zezwolenie_run == 1)
; 0000 025F    {
; 0000 0260    PORTA.7 = 1;  //zablokuj kubka
; 0000 0261    kubek = 4;
; 0000 0262    }
; 0000 0263 
; 0000 0264 if(czas > 13500 & kubek == 3 & srednie_kubki == 1 & zezwolenie_run == 1)
; 0000 0265    {
; 0000 0266    PORTA.7 = 1;  //zablokuj kubka
; 0000 0267    kubek = 4;
; 0000 0268    }
; 0000 0269 
; 0000 026A if(czas > 14500 & kubek == 3 & srednie_kubki == 2 & zezwolenie_run == 1)
; 0000 026B    {
; 0000 026C    PORTA.7 = 1;  //zablokuj kubka
; 0000 026D    kubek = 4;
; 0000 026E    }
; 0000 026F 
; 0000 0270 
; 0000 0271 
; 0000 0272 }
;
;// Timer2 overflow interrupt service routine
;
;interrupt [TIM2_OVF] void timer2_ovf_isr(void)
; 0000 0277 {
_timer2_ovf_isr:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0278 ulamki_sekund_1++;
	LDI  R26,LOW(_ulamki_sekund_1)
	LDI  R27,HIGH(_ulamki_sekund_1)
	CALL SUBOPT_0x15
; 0000 0279 kolejkowanie_start_stop();
	RCALL _kolejkowanie_start_stop
; 0000 027A /*
; 0000 027B if(jest_klej == 1 & dawka_kleju != dawka_kleju_wyswietlona)
; 0000 027C     {
; 0000 027D     lcd_gotoxy(13,1);
; 0000 027E     itoa(dawka_kleju,dupa);
; 0000 027F     lcd_puts(dupa);
; 0000 0280     }
; 0000 0281 */
; 0000 0282 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;
;
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0286 {
_timer0_ovf_isr:
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0287 // Place your code here
; 0000 0288 ulamki_sekund_2++;
	LDI  R26,LOW(_ulamki_sekund_2)
	LDI  R27,HIGH(_ulamki_sekund_2)
	CALL SUBOPT_0x15
; 0000 0289 czas++;
	LDI  R26,LOW(_czas)
	LDI  R27,HIGH(_czas)
	CALL SUBOPT_0x15
; 0000 028A ulamki_sekund_0++;
	LDI  R26,LOW(_ulamki_sekund_0)
	LDI  R27,HIGH(_ulamki_sekund_0)
	CALL SUBOPT_0x15
; 0000 028B }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R23,Y+
	LD   R22,Y+
	RETI
;
;void obroc_o_1_8_stopnia_pionowy()
; 0000 028E {
_obroc_o_1_8_stopnia_pionowy:
; 0000 028F PORTE.2 = 0;
	CBI  0x3,2
; 0000 0290 if(ulamki_sekund_2 >= 1)  // bylo 1 12.01
	CALL SUBOPT_0x2C
	__CPD2N 0x1
	BRLT _0x70
; 0000 0291     {
; 0000 0292     PORTE.2 = 1;
	SBI  0x3,2
; 0000 0293     ulamki_sekund_2 = 0;
	CALL SUBOPT_0x2D
; 0000 0294     }
; 0000 0295 
; 0000 0296 }
_0x70:
	RET
;
;void obroc_o_1_8_stopnia(int speed)
; 0000 0299 {
_obroc_o_1_8_stopnia:
; 0000 029A PORTE.4 = 0;
;	speed -> Y+0
	CBI  0x3,4
; 0000 029B if(ulamki_sekund_0 == speed)  //bylo 1;
	LD   R30,Y
	LDD  R31,Y+1
	CALL SUBOPT_0x2E
	CALL __CPD12
	BRNE _0x75
; 0000 029C     {
; 0000 029D     PORTE.4 = 1;
	SBI  0x3,4
; 0000 029E     ulamki_sekund_0 = 0;
	CALL SUBOPT_0x2F
; 0000 029F     }
; 0000 02A0 }
_0x75:
_0x20A0004:
	ADIW R28,2
	RET
;
;
;void jedz_dystans(float d, int speed)
; 0000 02A4 {
_jedz_dystans:
; 0000 02A5 int i;
; 0000 02A6 float kroki_obliczeniowe;
; 0000 02A7 int kroki;
; 0000 02A8 kroki_obliczeniowe = (d/(2*3.14*silnik_gorny_zebatka_promien))*mikro_krokow_na_obrot;
	SBIW R28,4
	CALL __SAVELOCR4
;	d -> Y+10
;	speed -> Y+8
;	i -> R16,R17
;	kroki_obliczeniowe -> Y+4
;	kroki -> R18,R19
	LDS  R30,_silnik_gorny_zebatka_promien
	LDS  R31,_silnik_gorny_zebatka_promien+1
	LDS  R22,_silnik_gorny_zebatka_promien+2
	LDS  R23,_silnik_gorny_zebatka_promien+3
	__GETD2N 0x40C8F5C3
	CALL __MULF12
	__GETD2S 10
	CALL __DIVF21
	MOVW R26,R30
	MOVW R24,R22
	MOVW R30,R6
	CALL __CWD1
	CALL __CDF1
	CALL __MULF12
	__PUTD1S 4
; 0000 02A9 kroki = (int) kroki_obliczeniowe;
	CALL __CFD1
	MOVW R18,R30
; 0000 02AA 
; 0000 02AB //2 * 3.14 * silnik_gorny_zebatka_promien
; 0000 02AC //to caly obrot, zeby tyle to obroc z pelna predkoscia 1 raz
; 0000 02AD //400 razy wykonaj funkcje obroc o kont 1.8 stopnia to bedzie pelny obrot przy pelnokrokowej pracy
; 0000 02AE 
; 0000 02AF for(i=0;i<kroki;i++)
	__GETWRN 16,17,0
_0x79:
	__CPWRR 16,17,18,19
	BRGE _0x7A
; 0000 02B0    {
; 0000 02B1    ulamki_sekund_0 = speed;  //bylo 1
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	CALL SUBOPT_0x30
; 0000 02B2    obroc_o_1_8_stopnia(speed);
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	CALL SUBOPT_0x31
; 0000 02B3    while(ulamki_sekund_0<speed)  //zamiast 5 bylo 1
_0x7B:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	CALL SUBOPT_0x2E
	CALL __CPD21
	BRGE _0x7D
; 0000 02B4        i=i;
	MOVW R16,R16
	RJMP _0x7B
_0x7D:
; 0000 02B5 }
	__ADDWRN 16,17,1
	RJMP _0x79
_0x7A:
; 0000 02B6 }
	CALL __LOADLOCR4
	ADIW R28,14
	RET
;
;void jedz_kroki(int d, int speed)
; 0000 02B9 {
_jedz_kroki:
; 0000 02BA int i;
; 0000 02BB 
; 0000 02BC for(i=0;i<d;i++)
	ST   -Y,R17
	ST   -Y,R16
;	d -> Y+4
;	speed -> Y+2
;	i -> R16,R17
	__GETWRN 16,17,0
_0x7F:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	CP   R16,R30
	CPC  R17,R31
	BRGE _0x80
; 0000 02BD    {
; 0000 02BE    ulamki_sekund_0 = speed;  //bylo 1
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CALL SUBOPT_0x30
; 0000 02BF    obroc_o_1_8_stopnia(speed);
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CALL SUBOPT_0x31
; 0000 02C0    while(ulamki_sekund_0<speed)  //zamiast 5 bylo 1
_0x81:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CALL SUBOPT_0x2E
	CALL __CPD21
	BRGE _0x83
; 0000 02C1        i=i;
	MOVW R16,R16
	RJMP _0x81
_0x83:
; 0000 02C2 }
	__ADDWRN 16,17,1
	RJMP _0x7F
_0x80:
; 0000 02C3 }
	LDD  R17,Y+1
	LDD  R16,Y+0
_0x20A0003:
	ADIW R28,6
	RET
;
;
;void jedz_do_krancowki_poziom()
; 0000 02C7 {
_jedz_do_krancowki_poziom:
; 0000 02C8 
; 0000 02C9 if(PINC.2 == 0)
	SBIC 0x13,2
	RJMP _0x84
; 0000 02CA    {
; 0000 02CB    PORTE.5 = 0;  //DIR //8
	CBI  0x3,5
; 0000 02CC    obroc_o_1_8_stopnia(8);
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL SUBOPT_0x31
; 0000 02CD    }
; 0000 02CE 
; 0000 02CF if(PINC.2 == 1)
_0x84:
	SBIS 0x13,2
	RJMP _0x87
; 0000 02D0     {
; 0000 02D1     wyzerowalem_krancowke = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _wyzerowalem_krancowke,R30
	STS  _wyzerowalem_krancowke+1,R31
; 0000 02D2     }
; 0000 02D3 
; 0000 02D4 
; 0000 02D5 if(wyzerowalem_krancowke == 1)
_0x87:
	CALL SUBOPT_0x32
	SBIW R26,1
	BRNE _0x88
; 0000 02D6         {
; 0000 02D7         PORTE.5 = 1;  //DIR
	SBI  0x3,5
; 0000 02D8         jedz_dystans(46,8);  //jedz nad podajnik  44
	__GETD1N 0x42380000
	CALL __PUTPARD1
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL SUBOPT_0x33
; 0000 02D9         wyzerowalem_nad_podajnikiem = 1;
	STS  _wyzerowalem_nad_podajnikiem,R30
	STS  _wyzerowalem_nad_podajnikiem+1,R31
; 0000 02DA         }
; 0000 02DB 
; 0000 02DC }
_0x88:
	RET
;
;void obsluga_podajnika_banderol()
; 0000 02DF {
_obsluga_podajnika_banderol:
; 0000 02E0     //run              //w dol         //w gore on ciagle zwiera do masy
; 0000 02E1         if(PINB.0 == 1 & PINC.3 == 0 & PINB.1 == 1)
	CALL SUBOPT_0x34
	LDI  R26,0
	SBIC 0x13,3
	LDI  R26,1
	CALL SUBOPT_0xA
	CALL SUBOPT_0x35
	AND  R30,R0
	BREQ _0x8B
; 0000 02E2             {
; 0000 02E3             PORTE.3 = 1;  //DIR
	SBI  0x3,3
; 0000 02E4             obroc_o_1_8_stopnia_pionowy();
	RCALL _obroc_o_1_8_stopnia_pionowy
; 0000 02E5             if(PINB.7 == 0)
	SBIC 0x16,7
	RJMP _0x8E
; 0000 02E6                  podajnik_gotowy = 0;
	LDI  R30,LOW(0)
	STS  _podajnik_gotowy,R30
	STS  _podajnik_gotowy+1,R30
; 0000 02E7             }
_0x8E:
; 0000 02E8 
; 0000 02E9 
; 0000 02EA         //wlacnzik start                                  //w gore
; 0000 02EB         if(PINB.0 == 1 & PINC.3 == 1 & PINB.1 == 0  &  PINB.7 == 0)
_0x8B:
	CALL SUBOPT_0x34
	CALL SUBOPT_0x36
	LDI  R26,0
	SBIC 0x16,1
	LDI  R26,1
	CALL SUBOPT_0xA
	LDI  R26,0
	SBIC 0x16,7
	LDI  R26,1
	CALL SUBOPT_0xB
	BREQ _0x8F
; 0000 02EC             {
; 0000 02ED             PORTE.3 = 0; //DIR pion     //jedziemy w gore recznie jezeli potrzeba
	CBI  0x3,3
; 0000 02EE             obroc_o_1_8_stopnia_pionowy();
	RCALL _obroc_o_1_8_stopnia_pionowy
; 0000 02EF                if(PINB.7 == 1)
	SBIS 0x16,7
	RJMP _0x92
; 0000 02F0                       podajnik_gotowy = 1;
	CALL SUBOPT_0x37
; 0000 02F1             }
_0x92:
; 0000 02F2 
; 0000 02F3 
; 0000 02F4          if(PINB.7 == 1 & podajnik_gotowy == 0)
_0x8F:
	LDI  R26,0
	SBIC 0x16,7
	LDI  R26,1
	CALL SUBOPT_0x11
	CALL SUBOPT_0x38
	AND  R30,R0
	BREQ _0x93
; 0000 02F5               podajnik_gotowy = 1;
	CALL SUBOPT_0x37
; 0000 02F6 
; 0000 02F7                                     //w gore guzik
; 0000 02F8         //wlacnzik start  //guzik jechania w dol   //czujnik banderol //kranocowka banderol //PINB.4 == 0
; 0000 02F9         if(PINB.0 == 0 & PINC.3 == 1 & PINB.1 == 1 & PINB.7 == 0 & podajnik_gotowy == 0)
_0x93:
	LDI  R26,0
	SBIC 0x16,0
	LDI  R26,1
	CALL SUBOPT_0xD
	CALL SUBOPT_0x36
	CALL SUBOPT_0x35
	AND  R0,R30
	LDI  R26,0
	SBIC 0x16,7
	LDI  R26,1
	CALL SUBOPT_0xA
	CALL SUBOPT_0x38
	AND  R30,R0
	BREQ _0x94
; 0000 02FA             {
; 0000 02FB             //if(ulamki_sekund_2 > 1)
; 0000 02FC             //    ulamki_sekund_2 = 0;
; 0000 02FD             PORTE.3 = 0; //DIR pion     //jedziemy w gore na samym poczatku po zainicjowaniu maszyny
	CBI  0x3,3
; 0000 02FE             obroc_o_1_8_stopnia_pionowy();
	RCALL _obroc_o_1_8_stopnia_pionowy
; 0000 02FF             if(PINB.7 == 1)
	SBIS 0x16,7
	RJMP _0x97
; 0000 0300                 podajnik_gotowy = 1;
	CALL SUBOPT_0x37
; 0000 0301             }
_0x97:
; 0000 0302            //run          //st-down    //st-up
; 0000 0303         if(PINB.0 == 1 & PINC.3 == 1 & PINB.1 == 1 & PINB.2 == 0 & wyzerowalem_krancowke == 1 & dostep_do_podajnika == 0)
_0x94:
	CALL SUBOPT_0x34
	CALL SUBOPT_0x36
	CALL SUBOPT_0x35
	AND  R0,R30
	LDI  R26,0
	SBIC 0x16,2
	LDI  R26,1
	CALL SUBOPT_0xA
	CALL SUBOPT_0x39
	AND  R0,R30
	MOVW R26,R10
	CALL SUBOPT_0xF
	AND  R30,R0
	BREQ _0x98
; 0000 0304             {
; 0000 0305             PORTE.5 = 0;  //DIR
	CBI  0x3,5
; 0000 0306             jedz_dystans(40,5);  //70
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x33
; 0000 0307             dostep_do_podajnika = 1;
	MOVW R10,R30
; 0000 0308             }
; 0000 0309         if(PINB.0 == 1 & PINC.3 == 1 & PINB.1 == 1 & PINB.2 == 1 & wyzerowalem_krancowke == 1 & dostep_do_podajnika == 1)
_0x98:
	CALL SUBOPT_0x34
	CALL SUBOPT_0x36
	CALL SUBOPT_0x35
	AND  R0,R30
	LDI  R26,0
	SBIC 0x16,2
	LDI  R26,1
	LDI  R30,LOW(1)
	CALL __EQB12
	AND  R0,R30
	CALL SUBOPT_0x39
	AND  R0,R30
	MOVW R26,R10
	CALL SUBOPT_0x12
	AND  R30,R0
	BREQ _0x9B
; 0000 030A             {
; 0000 030B             PORTE.5 = 1;  //DIR
	SBI  0x3,5
; 0000 030C             jedz_dystans(40,5);      //70
	CALL SUBOPT_0x3A
	ST   -Y,R31
	ST   -Y,R30
	RCALL _jedz_dystans
; 0000 030D             dostep_do_podajnika = 0;
	CLR  R10
	CLR  R11
; 0000 030E             }
; 0000 030F 
; 0000 0310 }
_0x9B:
	RET
;
;
;
;int pobierz_banderole()
; 0000 0315 {
_pobierz_banderole:
; 0000 0316 zeruj_licznik("pobieram_banderole");
	__POINTW1MN _0x9E,0
	ST   -Y,R31
	ST   -Y,R30
	RCALL _zeruj_licznik
; 0000 0317 PORTA.4 = 1;     //ssawka
	SBI  0x1B,4
; 0000 0318 PORTA.5 = 1;    //silownik banderoli
	SBI  0x1B,5
; 0000 0319 return 1;
	RJMP _0x20A0002
; 0000 031A }

	.DSEG
_0x9E:
	.BYTE 0x13
;
;int naklejam()
; 0000 031D {

	.CSEG
_naklejam:
; 0000 031E PORTA.5 = 1;    //silownik banderoli
	SBI  0x1B,5
; 0000 031F PORTA.4 = 0;     //ssanie - na razie ssania nie wylaczam
	CBI  0x1B,4
; 0000 0320 PORTD.1 = 1;  //ZMIANA STANU wylaczam slabe ssanie tez
	SBI  0x12,1
; 0000 0321 
; 0000 0322 zeruj_licznik("naklejam");
	__POINTW1MN _0xA9,0
	ST   -Y,R31
	ST   -Y,R30
	RCALL _zeruj_licznik
; 0000 0323 return 1;
_0x20A0002:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RET
; 0000 0324 }

	.DSEG
_0xA9:
	.BYTE 0x9
;
;void sprawdz_cisnienie()
; 0000 0327 {

	.CSEG
_sprawdz_cisnienie:
; 0000 0328 while(PINC.5 == 1)
_0xAA:
	SBIS 0x13,5
	RJMP _0xAC
; 0000 0329     {
; 0000 032A     lcd_clear();
	CALL SUBOPT_0xE
; 0000 032B     lcd_gotoxy(0,0);
; 0000 032C     lcd_puts("Brak wymaganego ciœnienia 7 bar");
	__POINTW1MN _0xAD,0
	CALL SUBOPT_0x8
; 0000 032D     while(PINC.5 == 1)
_0xAE:
	SBIC 0x13,5
; 0000 032E     {}
	RJMP _0xAE
; 0000 032F     lcd_clear();
	CALL _lcd_clear
; 0000 0330     }
	RJMP _0xAA
_0xAC:
; 0000 0331 }
	RET

	.DSEG
_0xAD:
	.BYTE 0x20
;
;void kontrola_obecnosci_banderol()
; 0000 0334 {

	.CSEG
_kontrola_obecnosci_banderol:
; 0000 0335 
; 0000 0336 if(PINC.1 == 1)
	SBIS 0x13,1
	RJMP _0xB1
; 0000 0337     {
; 0000 0338     PORTD.3 = 1;    //ZMIANA STANU nie lej kleju
	SBI  0x12,3
; 0000 0339     PORTA.2 = 0;   //odsun awaryjnie pistolet
	CBI  0x1B,2
; 0000 033A     PORTA.4 = 0;   //wylacz aby nie ssalo
	CBI  0x1B,4
; 0000 033B     lcd_clear();
	CALL SUBOPT_0xE
; 0000 033C     lcd_gotoxy(0,0);
; 0000 033D     lcd_puts("Turn off and check streamers");
	__POINTW1MN _0xB8,0
	CALL SUBOPT_0x8
; 0000 033E     while(1)
_0xB9:
; 0000 033F         {
; 0000 0340         }
	RJMP _0xB9
; 0000 0341     }
; 0000 0342 //if(PINC.1 == 0)
; 0000 0343 //    {
; 0000 0344 //    lcd_clear();
; 0000 0345 //    lcd_gotoxy(0,0);
; 0000 0346 //    lcd_puts("OK");
; 0000 0347 //    }
; 0000 0348 }
_0xB1:
	RET

	.DSEG
_0xB8:
	.BYTE 0x1D
;
;
;void praca_prawo()
; 0000 034C {

	.CSEG
_praca_prawo:
; 0000 034D if(pobralem_banderole == 0)
	LDS  R30,_pobralem_banderole
	LDS  R31,_pobralem_banderole+1
	SBIW R30,0
	BRNE _0xBC
; 0000 034E         {
; 0000 034F         pracuje_w_kierunku = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R4,R30
; 0000 0350         PORTE.5 = 1;  //DIR
	SBI  0x3,5
; 0000 0351         pobralem_banderole = pobierz_banderole();  //tu powinien na chwile stanac aby zd¹zyæ to zrobiæ
	RCALL _pobierz_banderole
	STS  _pobralem_banderole,R30
	STS  _pobralem_banderole+1,R31
; 0000 0352         }
; 0000 0353                                        //2000
; 0000 0354 if(odczyt_licznik("pobieram_banderole")>2000 & odczyt_licznik("pobieram_banderole")<6000 & wykonano_1 == 0)
_0xBC:
	__POINTW1MN _0xC0,0
	CALL SUBOPT_0x3B
	__GETD1N 0x7D0
	CALL __GTD12
	PUSH R30
	__POINTW1MN _0xC0,19
	CALL SUBOPT_0x3B
	__GETD1N 0x1770
	CALL __LTD12
	POP  R26
	AND  R30,R26
	CALL SUBOPT_0x3C
	CALL SUBOPT_0xF
	AND  R30,R0
	BREQ _0xBF
; 0000 0355         {
; 0000 0356         //PORTA.4 = 1;     //ssawka
; 0000 0357         wykonano_1 = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0x3D
; 0000 0358         wyk1 = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0x3E
; 0000 0359         if(fast == 1)
	CALL SUBOPT_0x3F
	SBIW R26,1
	BRNE _0xC1
; 0000 035A               {
; 0000 035B               PORTA.2 = 1;  //przysun pistolet
	SBI  0x1B,2
; 0000 035C               }
; 0000 035D         }
_0xC1:
; 0000 035E                                       //4000       //& wykonano_1 == 1
; 0000 035F if(odczyt_licznik("pobieram_banderole")>0 & pobralem_banderole == 1 & fast == 1 & leje_klej == 0)
_0xBF:
	__POINTW1MN _0xC0,38
	CALL SUBOPT_0x3B
	__GETD1N 0x0
	CALL SUBOPT_0x40
	CALL SUBOPT_0x41
	CALL SUBOPT_0x42
	CALL SUBOPT_0xF
	AND  R30,R0
	BREQ _0xC4
; 0000 0360     {
; 0000 0361     PORTD.3 = 0;  //ZMIANA STANU lej klej
	CBI  0x12,3
; 0000 0362     leje_klej = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0x43
; 0000 0363     }
; 0000 0364 
; 0000 0365 //odejmuje wszedzie 2000 ponizej
; 0000 0366 //odejmuje wszedzie 1000 ponizej
; 0000 0367 
; 0000 0368 //troche dluzej btc na dole
; 0000 0369                                       //1500     //& wykonano_1 == 1
; 0000 036A if(odczyt_licznik("pobieram_banderole")>1000  & pobralem_banderole == 1 & fast == 1 & dawka_kleju == 0 & leje_klej == 1)
_0xC4:
	__POINTW1MN _0xC0,57
	CALL SUBOPT_0x3B
	__GETD1N 0x3E8
	CALL SUBOPT_0x40
	CALL SUBOPT_0x41
	AND  R0,R30
	CALL SUBOPT_0x10
	CALL SUBOPT_0xF
	CALL SUBOPT_0x42
	CALL SUBOPT_0x12
	AND  R30,R0
	BREQ _0xC7
; 0000 036B     {
; 0000 036C     PORTD.3 = 1;  //ZMIANA STANU przestan lac klej
	CALL SUBOPT_0x44
; 0000 036D     leje_klej = 2;
; 0000 036E     }                                  //2000      //& wykonano_1 == 1
; 0000 036F if(odczyt_licznik("pobieram_banderole")>1400  & pobralem_banderole == 1 & fast == 1 & dawka_kleju == 1 & leje_klej == 1)
_0xC7:
	__POINTW1MN _0xC0,76
	CALL SUBOPT_0x3B
	__GETD1N 0x578
	CALL SUBOPT_0x40
	CALL SUBOPT_0x41
	AND  R0,R30
	CALL SUBOPT_0x10
	CALL SUBOPT_0x12
	CALL SUBOPT_0x42
	CALL SUBOPT_0x12
	AND  R30,R0
	BREQ _0xCA
; 0000 0370     {
; 0000 0371     PORTD.3 = 1;  //ZMIANA STANU przestan lac klej
	CALL SUBOPT_0x44
; 0000 0372     leje_klej = 2;
; 0000 0373     }
; 0000 0374                                        //2500      //& wykonano_1 == 1
; 0000 0375 if(odczyt_licznik("pobieram_banderole")>1800 & pobralem_banderole == 1 & fast == 1 & dawka_kleju == 2 & leje_klej == 1)
_0xCA:
	__POINTW1MN _0xC0,95
	CALL SUBOPT_0x3B
	__GETD1N 0x708
	CALL SUBOPT_0x40
	CALL SUBOPT_0x41
	AND  R0,R30
	CALL SUBOPT_0x10
	CALL SUBOPT_0x25
	CALL SUBOPT_0x42
	CALL SUBOPT_0x12
	AND  R30,R0
	BREQ _0xCD
; 0000 0376     {
; 0000 0377     PORTD.3 = 1;  //ZMIANA STANU przestan lac klej
	CALL SUBOPT_0x44
; 0000 0378     leje_klej = 2;
; 0000 0379     }
; 0000 037A                                        //2950      //& wykonano_1 == 1
; 0000 037B if(odczyt_licznik("pobieram_banderole")>2200 & pobralem_banderole == 1 & fast == 1 & dawka_kleju == 3 & leje_klej == 1)
_0xCD:
	__POINTW1MN _0xC0,114
	CALL SUBOPT_0x3B
	__GETD1N 0x898
	CALL SUBOPT_0x40
	CALL SUBOPT_0x41
	AND  R0,R30
	CALL SUBOPT_0x10
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0x45
	CALL SUBOPT_0x12
	AND  R30,R0
	BREQ _0xD0
; 0000 037C     {
; 0000 037D     PORTD.3 = 1;  //ZMIANA STANU przestan lac klej
	CALL SUBOPT_0x44
; 0000 037E     leje_klej = 2;
; 0000 037F     }
; 0000 0380 
; 0000 0381 
; 0000 0382 //500 to dla niego minimalny impuls
; 0000 0383 
; 0000 0384                                        //3500      //& wykonano_1 == 2
; 0000 0385 if(odczyt_licznik("pobieram_banderole")>2600 & pobralem_banderole == 1 & fast == 1 & dawka_kleju == 4 & leje_klej == 1)
_0xD0:
	__POINTW1MN _0xC0,133
	CALL SUBOPT_0x3B
	__GETD1N 0xA28
	CALL SUBOPT_0x40
	CALL SUBOPT_0x41
	AND  R0,R30
	CALL SUBOPT_0x10
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0x45
	CALL SUBOPT_0x12
	AND  R30,R0
	BREQ _0xD3
; 0000 0386     {
; 0000 0387     PORTD.3 = 1;  //ZMIANA STANU przestan lac klej
	CALL SUBOPT_0x44
; 0000 0388     leje_klej = 2;
; 0000 0389     }
; 0000 038A                                        //4000      //& wykonano_1 == 2
; 0000 038B if(odczyt_licznik("pobieram_banderole")>2800 & pobralem_banderole == 1 & fast == 1 & dawka_kleju == 5 & leje_klej == 1)
_0xD3:
	__POINTW1MN _0xC0,152
	CALL SUBOPT_0x3B
	__GETD1N 0xAF0
	CALL SUBOPT_0x40
	CALL SUBOPT_0x41
	AND  R0,R30
	CALL SUBOPT_0x10
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL SUBOPT_0x45
	CALL SUBOPT_0x12
	AND  R30,R0
	BREQ _0xD6
; 0000 038C     {
; 0000 038D     PORTD.3 = 1;  //ZMIANA STANU przestan lac klej
	CALL SUBOPT_0x44
; 0000 038E     leje_klej = 2;
; 0000 038F     }
; 0000 0390                                        //4500      //& wykonano_1 == 2
; 0000 0391 if(odczyt_licznik("pobieram_banderole")>3200 & pobralem_banderole == 1 & fast == 1 & dawka_kleju == 6 & leje_klej == 1)
_0xD6:
	__POINTW1MN _0xC0,171
	CALL SUBOPT_0x3B
	__GETD1N 0xC80
	CALL SUBOPT_0x40
	CALL SUBOPT_0x41
	AND  R0,R30
	CALL SUBOPT_0x10
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x42
	CALL SUBOPT_0x12
	AND  R30,R0
	BREQ _0xD9
; 0000 0392     {
; 0000 0393     PORTD.3 = 1;  //ZMIANA STANU przestan lac klej
	CALL SUBOPT_0x44
; 0000 0394     leje_klej = 2;
; 0000 0395     }
; 0000 0396                                        //4950      //& wykonano_1 == 2
; 0000 0397 if(odczyt_licznik("pobieram_banderole")>3600 & pobralem_banderole == 1 & fast == 1 & dawka_kleju == 7 & leje_klej == 1)
_0xD9:
	__POINTW1MN _0xC0,190
	CALL SUBOPT_0x3B
	__GETD1N 0xE10
	CALL SUBOPT_0x40
	CALL SUBOPT_0x41
	AND  R0,R30
	CALL SUBOPT_0x10
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CALL SUBOPT_0x45
	CALL SUBOPT_0x12
	AND  R30,R0
	BREQ _0xDC
; 0000 0398     {
; 0000 0399     PORTD.3 = 1;  //ZMIANA STANU przestan lac klej
	CALL SUBOPT_0x44
; 0000 039A     leje_klej = 2;
; 0000 039B     }
; 0000 039C 
; 0000 039D //if(odczyt_licznik("pobieram_banderole")>6000 & wykonano_1 == 1)
; 0000 039E //        {
; 0000 039F //        wykonano_1 = 2;
; 0000 03A0 //        //PORTA.5 = 0;     //podjedz do gory
; 0000 03A1 //        //wyk1 = 2;
; 0000 03A2 //        }
; 0000 03A3                                        //2800 30.10.2017
; 0000 03A4 if(odczyt_licznik("pobieram_banderole")>4500 & wykonano_1 == 1)
_0xDC:
	__POINTW1MN _0xC0,209
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x28
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x12
	AND  R30,R0
	BREQ _0xDF
; 0000 03A5         {
; 0000 03A6         PORTA.5 = 0;     //podjedz do gory
	CBI  0x1B,5
; 0000 03A7         wyk1 = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x3E
; 0000 03A8         }
; 0000 03A9 
; 0000 03AA                                        //3300 30.10.2017
; 0000 03AB if(odczyt_licznik("pobieram_banderole")>5500 & wyk1 == 2)
_0xDF:
	__POINTW1MN _0xC0,228
	CALL SUBOPT_0x3B
	__GETD1N 0x157C
	CALL __GTD12
	MOV  R0,R30
	LDS  R26,_wyk1
	LDS  R27,_wyk1+1
	CALL SUBOPT_0x25
	AND  R30,R0
	BREQ _0xE2
; 0000 03AC         {
; 0000 03AD         jedz_kroki(21,5);
	CALL SUBOPT_0x46
	CALL SUBOPT_0x47
; 0000 03AE         jedz_kroki(21,4);
	CALL SUBOPT_0x48
; 0000 03AF         jedz_kroki(42,3);  //21        10.11.2017
	CALL SUBOPT_0x49
	CALL SUBOPT_0x4A
; 0000 03B0         jedz_kroki(42,2);  //21        10.11.2017
	CALL SUBOPT_0x49
	CALL SUBOPT_0x4B
; 0000 03B1         jedz_kroki(1083,1);  //1125    10.11.2017
	LDI  R30,LOW(1083)
	LDI  R31,HIGH(1083)
	CALL SUBOPT_0x4C
; 0000 03B2         wykonano_1 = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0x3D
; 0000 03B3         wyk1 = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0x3E
; 0000 03B4         }
; 0000 03B5 
; 0000 03B6 if(opuscilem_banderole == 0 & wykonano_1 == 3)
_0xE2:
	LDS  R26,_opuscilem_banderole
	LDS  R27,_opuscilem_banderole+1
	CALL SUBOPT_0xF
	CALL SUBOPT_0x3C
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL __EQW12
	AND  R30,R0
	BREQ _0xE3
; 0000 03B7         {
; 0000 03B8         opuscilem_banderole = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _opuscilem_banderole,R30
	STS  _opuscilem_banderole+1,R31
; 0000 03B9         if(fast == 0)
	CALL SUBOPT_0x4D
	BRNE _0xE4
; 0000 03BA             {
; 0000 03BB             PORTA.2 = 1;  //pistlet przysun
	SBI  0x1B,2
; 0000 03BC             PORTD.3 = 0;  //ZMIANA STANU lej klej
	CBI  0x12,3
; 0000 03BD             }
; 0000 03BE         jedz_kroki(360,1);
_0xE4:
	LDI  R30,LOW(360)
	LDI  R31,HIGH(360)
	CALL SUBOPT_0x4C
; 0000 03BF         jedz_kroki(100,1);
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x4C
; 0000 03C0         wykonano_1 = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0x3D
; 0000 03C1         }
; 0000 03C2 
; 0000 03C3 if(podnioslem_banderole == 0 & wykonano_1 == 4)
_0xE3:
	LDS  R26,_podnioslem_banderole
	LDS  R27,_podnioslem_banderole+1
	CALL SUBOPT_0xF
	CALL SUBOPT_0x3C
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL __EQW12
	AND  R30,R0
	BRNE PC+3
	JMP _0xE9
; 0000 03C4         {
; 0000 03C5         podnioslem_banderole = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _podnioslem_banderole,R30
	STS  _podnioslem_banderole+1,R31
; 0000 03C6 
; 0000 03C7         if(fast == 0)
	CALL SUBOPT_0x4D
	BRNE _0xEA
; 0000 03C8           {
; 0000 03C9           jedz_kroki(42,2); //21 10.11.2017
	CALL SUBOPT_0x49
	CALL SUBOPT_0x4B
; 0000 03CA           jedz_kroki(42,3); //21 10.11.2017
	CALL SUBOPT_0x49
	CALL SUBOPT_0x4A
; 0000 03CB           jedz_kroki(21,4);
	CALL SUBOPT_0x46
	CALL SUBOPT_0x48
; 0000 03CC           jedz_kroki(21,5);
	CALL SUBOPT_0x46
	CALL SUBOPT_0x47
; 0000 03CD           jedz_kroki(21,6);
	CALL SUBOPT_0x4E
; 0000 03CE           jedz_kroki(77,7); //161 10.11.2017
	LDI  R30,LOW(77)
	LDI  R31,HIGH(77)
	CALL SUBOPT_0x4F
; 0000 03CF           PORTD.3 = 1; //ZMIANA STANU przestan lac klej  04.08.2015
	SBI  0x12,3
; 0000 03D0           jedz_kroki(1050,7);   //50
	LDI  R30,LOW(1050)
	LDI  R31,HIGH(1050)
	CALL SUBOPT_0x4F
; 0000 03D1           kontrola_obecnosci_banderol();
	RCALL _kontrola_obecnosci_banderol
; 0000 03D2           jedz_kroki(1050,7);  //1100
	LDI  R30,LOW(1050)
	LDI  R31,HIGH(1050)
	CALL SUBOPT_0x4F
; 0000 03D3           jedz_kroki(21,6);
	CALL SUBOPT_0x46
	CALL SUBOPT_0x4E
; 0000 03D4           jedz_kroki(21,5);
	CALL SUBOPT_0x46
	CALL SUBOPT_0x47
; 0000 03D5           jedz_kroki(21,4);
	CALL SUBOPT_0x48
; 0000 03D6           jedz_kroki(42,3);  //21 10.11.2017
	CALL SUBOPT_0x49
	CALL SUBOPT_0x4A
; 0000 03D7           jedz_kroki(42,2);  //21 10.11.2017
	CALL SUBOPT_0x49
	CALL SUBOPT_0x4B
; 0000 03D8           }
; 0000 03D9 
; 0000 03DA         if(fast == 1)
_0xEA:
	CALL SUBOPT_0x3F
	SBIW R26,1
	BRNE _0xED
; 0000 03DB            {
; 0000 03DC            jedz_kroki(104,1);  //214
	LDI  R30,LOW(104)
	LDI  R31,HIGH(104)
	CALL SUBOPT_0x4C
; 0000 03DD            //delay_ms(1000);
; 0000 03DE            //delay_ms(1000);
; 0000 03DF            //delay_ms(1000);
; 0000 03E0            kontrola_obecnosci_banderol();
	RCALL _kontrola_obecnosci_banderol
; 0000 03E1            jedz_kroki(306,1);  //196
	LDI  R30,LOW(306)
	LDI  R31,HIGH(306)
	CALL SUBOPT_0x4C
; 0000 03E2            jedz_kroki(200,1);
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	CALL SUBOPT_0x4C
; 0000 03E3            jedz_kroki(200,1);
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	CALL SUBOPT_0x4C
; 0000 03E4 
; 0000 03E5            jedz_kroki(661,1);  //1061
	LDI  R30,LOW(661)
	LDI  R31,HIGH(661)
	CALL SUBOPT_0x4C
; 0000 03E6            //PORTA.2 = 0; //cofnij pistolet
; 0000 03E7            }
; 0000 03E8         wykonano_1 = 5;
_0xED:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL SUBOPT_0x3D
; 0000 03E9         }
; 0000 03EA 
; 0000 03EB if(cofniety_pistolet == 0 & wykonano_1 == 5)
_0xE9:
	LDS  R26,_cofniety_pistolet
	LDS  R27,_cofniety_pistolet+1
	CALL SUBOPT_0xF
	CALL SUBOPT_0x3C
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __EQW12
	AND  R30,R0
	BREQ _0xEE
; 0000 03EC {
; 0000 03ED 
; 0000 03EE 
; 0000 03EF PORTD.1 = 0;  //ZMIANA STANU wlacz mniejsze ssanie
	CBI  0x12,1
; 0000 03F0 cofniety_pistolet = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _cofniety_pistolet,R30
	STS  _cofniety_pistolet+1,R31
; 0000 03F1 if(fast == 0)
	CALL SUBOPT_0x4D
	BRNE _0xF1
; 0000 03F2   PORTA.2 = 0; //cofnij pistolet
	CBI  0x1B,2
; 0000 03F3 jedz_kroki(615,1);
_0xF1:
	LDI  R30,LOW(615)
	LDI  R31,HIGH(615)
	CALL SUBOPT_0x4C
; 0000 03F4 PORTA.2 = 0; //cofnij pistolet   //proba
	CBI  0x1B,2
; 0000 03F5 jedz_kroki(1995,1);
	LDI  R30,LOW(1995)
	LDI  R31,HIGH(1995)
	CALL SUBOPT_0x4C
; 0000 03F6 
; 0000 03F7 jedz_kroki(56,1);   //63,1 16.11.2017
	LDI  R30,LOW(56)
	LDI  R31,HIGH(56)
	CALL SUBOPT_0x4C
; 0000 03F8 jedz_kroki(28,1);  //70 10.11.2017
	LDI  R30,LOW(28)
	LDI  R31,HIGH(28)
	CALL SUBOPT_0x4C
; 0000 03F9 
; 0000 03FA jedz_kroki(42,2);  //21 10.11.2017
	CALL SUBOPT_0x49
	CALL SUBOPT_0x4B
; 0000 03FB jedz_kroki(42,3);  //21 10.11.2017
	CALL SUBOPT_0x49
	CALL SUBOPT_0x4A
; 0000 03FC jedz_kroki(21,4);
	CALL SUBOPT_0x46
	CALL SUBOPT_0x48
; 0000 03FD jedz_kroki(21,5);
	CALL SUBOPT_0x46
	CALL SUBOPT_0x50
; 0000 03FE wykonano_1 = 6;
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CALL SUBOPT_0x3D
; 0000 03FF //while(1)
; 0000 0400                // {
; 0000 0401                // }
; 0000 0402 }
; 0000 0403 
; 0000 0404 
; 0000 0405 if(nakleilem == 0 & wykonano_1 == 6)
_0xEE:
	LDS  R26,_nakleilem
	LDS  R27,_nakleilem+1
	CALL SUBOPT_0xF
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x2B
	AND  R30,R0
	BREQ _0xF6
; 0000 0406         {
; 0000 0407         nakleilem = naklejam();
	RCALL _naklejam
	STS  _nakleilem,R30
	STS  _nakleilem+1,R31
; 0000 0408         wykonano_1 = 7;
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CALL SUBOPT_0x3D
; 0000 0409         //while(1)
; 0000 040A         // {
; 0000 040B         // }
; 0000 040C         }
; 0000 040D                              //10 PNE
; 0000 040E if(odczyt_licznik("naklejam")>4000 & wykonano_2 == 0 & wykonano_1 == 7 & fast == 1)
_0xF6:
	__POINTW1MN _0xC0,247
	CALL SUBOPT_0x3B
	__GETD1N 0xFA0
	CALL SUBOPT_0x51
	CALL SUBOPT_0x52
	CALL SUBOPT_0x41
	AND  R30,R0
	BREQ _0xF7
; 0000 040F         {
; 0000 0410         //while(1)
; 0000 0411         //        {
; 0000 0412         //        }
; 0000 0413         PORTD.2 = 0;  //w³¹czenie falownika
	CBI  0x12,2
; 0000 0414         PORTA.5 = 0;     //podjedz do gory
	CBI  0x1B,5
; 0000 0415         //while(1)
; 0000 0416         //        {
; 0000 0417         //        }
; 0000 0418         if(odczyt_licznik("naklejam")>50)   //20
	__POINTW1MN _0xC0,256
	ST   -Y,R31
	ST   -Y,R30
	RCALL _odczyt_licznik
	__CPD1N 0x33
	BRLT _0xFC
; 0000 0419                wykonano_2 = 1;
	CALL SUBOPT_0x53
; 0000 041A         }
_0xFC:
; 0000 041B                              //15 PNE
; 0000 041C if(odczyt_licznik("naklejam")>6000 & wykonano_2 == 0 & wykonano_1 == 7 & fast == 0)
_0xF7:
	__POINTW1MN _0xC0,265
	CALL SUBOPT_0x3B
	__GETD1N 0x1770
	CALL SUBOPT_0x51
	CALL SUBOPT_0x52
	AND  R0,R30
	CALL SUBOPT_0x3F
	CALL SUBOPT_0xF
	AND  R30,R0
	BREQ _0xFD
; 0000 041D         {
; 0000 041E         PORTD.2 = 0;  //w³¹czenie falownika
	CBI  0x12,2
; 0000 041F         PORTA.5 = 0;     //podjedz do gory
	CBI  0x1B,5
; 0000 0420 
; 0000 0421         if(odczyt_licznik("naklejam")>8000)
	__POINTW1MN _0xC0,274
	ST   -Y,R31
	ST   -Y,R30
	RCALL _odczyt_licznik
	__CPD1N 0x1F41
	BRLT _0x102
; 0000 0422                {
; 0000 0423                //while(1)
; 0000 0424                // {
; 0000 0425                // }
; 0000 0426 
; 0000 0427                wykonano_2 = 1;       //20
	CALL SUBOPT_0x53
; 0000 0428                wyk1 = 0;
	LDI  R30,LOW(0)
	STS  _wyk1,R30
	STS  _wyk1+1,R30
; 0000 0429                }
; 0000 042A         }
_0x102:
; 0000 042B 
; 0000 042C }
_0xFD:
	RET

	.DSEG
_0xC0:
	.BYTE 0x11B
;
;void praca_lewo()
; 0000 042F {

	.CSEG
_praca_lewo:
; 0000 0430 pracuje_w_kierunku = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	MOVW R4,R30
; 0000 0431 PORTE.5 = 0;  //DIR
	CBI  0x3,5
; 0000 0432 //zatrzymalem_kubek = 0;
; 0000 0433 //kubek = 0;
; 0000 0434 jedz_kroki(21,5);//
	CALL SUBOPT_0x46
	CALL SUBOPT_0x47
; 0000 0435 jedz_kroki(21,4);//
	CALL SUBOPT_0x48
; 0000 0436 jedz_kroki(42,3);// 21 10.11.2017
	CALL SUBOPT_0x49
	CALL SUBOPT_0x4A
; 0000 0437 jedz_kroki(42,2);  // 21 10.11.2017
	CALL SUBOPT_0x49
	CALL SUBOPT_0x4B
; 0000 0438 jedz_kroki(645,1);  //687 10.11.2017    //645 10.11.2017
	LDI  R30,LOW(645)
	LDI  R31,HIGH(645)
	CALL SUBOPT_0x4C
; 0000 0439 jedz_kroki(50,1);
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	CALL SUBOPT_0x4C
; 0000 043A PORTD.2 = 0;  //w³¹czenie falownika
	CBI  0x12,2
; 0000 043B PORTA.3 = 1;    //opusc stemel doklejajacy  ------------------------------------------------------
	SBI  0x1B,3
; 0000 043C jedz_kroki(2073,1);  //2123 9.01.2016
	LDI  R30,LOW(2073)
	LDI  R31,HIGH(2073)
	CALL SUBOPT_0x4C
; 0000 043D jedz_kroki(212,1);   //212  9.01.2016
	LDI  R30,LOW(212)
	LDI  R31,HIGH(212)
	CALL SUBOPT_0x4C
; 0000 043E zatrzymalem_kubek = 0;
	LDI  R30,LOW(0)
	STS  _zatrzymalem_kubek,R30
	STS  _zatrzymalem_kubek+1,R30
; 0000 043F kubek = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0x26
; 0000 0440 PORTA.3 = 0;    //podnies stemel doklejajacy
	CBI  0x1B,3
; 0000 0441 jedz_kroki(1246,1); //846    9.01.2016
	LDI  R30,LOW(1246)
	LDI  R31,HIGH(1246)
	CALL SUBOPT_0x4C
; 0000 0442 PORTA.1 = 0;  //koniec szpikulca
	CBI  0x1B,1
; 0000 0443 PORTA.7 = 0;  //koniec zatrzymania
	CBI  0x1B,7
; 0000 0444 zezzwalaj_na_oklejenie_boczne = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R12,R30
; 0000 0445 jedz_kroki(598,1);  //1098 9.01.2016
	LDI  R30,LOW(598)
	LDI  R31,HIGH(598)
	CALL SUBOPT_0x4C
; 0000 0446 jedz_kroki(800,1);
	LDI  R30,LOW(800)
	LDI  R31,HIGH(800)
	CALL SUBOPT_0x4C
; 0000 0447 jedz_kroki(56,1);      //63,1   16.11.2016
	LDI  R30,LOW(56)
	LDI  R31,HIGH(56)
	CALL SUBOPT_0x4C
; 0000 0448 //if(duze_kubki == 1 | srednie_kubki == 1)
; 0000 0449 jedz_kroki(28,1);  //70 10.11.2017
	LDI  R30,LOW(28)
	LDI  R31,HIGH(28)
	CALL SUBOPT_0x4C
; 0000 044A 
; 0000 044B jedz_kroki(42,2);   //21  10.11.2017
	CALL SUBOPT_0x49
	CALL SUBOPT_0x4B
; 0000 044C jedz_kroki(42,3);   //21  10.11.2017
	CALL SUBOPT_0x49
	CALL SUBOPT_0x4A
; 0000 044D jedz_kroki(21,4);
	CALL SUBOPT_0x46
	CALL SUBOPT_0x48
; 0000 044E jedz_kroki(21,5);
	CALL SUBOPT_0x46
	CALL SUBOPT_0x50
; 0000 044F leje_klej = 0;
	LDI  R30,LOW(0)
	STS  _leje_klej,R30
	STS  _leje_klej+1,R30
; 0000 0450 }
	RET
;
;void zeruj_flagi()
; 0000 0453 {
_zeruj_flagi:
; 0000 0454 pobralem_banderole = 0;
	LDI  R30,LOW(0)
	STS  _pobralem_banderole,R30
	STS  _pobralem_banderole+1,R30
; 0000 0455 wykonano_1 = 0;
	STS  _wykonano_1,R30
	STS  _wykonano_1+1,R30
; 0000 0456 wykonano_2 = 0;
	STS  _wykonano_2,R30
	STS  _wykonano_2+1,R30
; 0000 0457 opuscilem_banderole = 0;
	STS  _opuscilem_banderole,R30
	STS  _opuscilem_banderole+1,R30
; 0000 0458 podnioslem_banderole = 0;
	STS  _podnioslem_banderole,R30
	STS  _podnioslem_banderole+1,R30
; 0000 0459 nakleilem = 0;
	STS  _nakleilem,R30
	STS  _nakleilem+1,R30
; 0000 045A sprawdzilem_banderole = 0;
	STS  _sprawdzilem_banderole,R30
	STS  _sprawdzilem_banderole+1,R30
; 0000 045B podajnik_gotowy = 0;
	STS  _podajnik_gotowy,R30
	STS  _podajnik_gotowy+1,R30
; 0000 045C cofniety_pistolet = 0;
	STS  _cofniety_pistolet,R30
	STS  _cofniety_pistolet+1,R30
; 0000 045D lej_klej = 0;
	STS  _lej_klej,R30
	STS  _lej_klej+1,R30
; 0000 045E }
	RET
;
;void main(void)
; 0000 0461 {
_main:
; 0000 0462 // Declare your local variables here
; 0000 0463 
; 0000 0464 // Crystal Oscillator division factor: 2
; 0000 0465 //XDIV=0xFF;
; 0000 0466 
; 0000 0467 // Input/Output Ports initialization
; 0000 0468 // Port A initialization
; 0000 0469 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 046A // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 046B PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 046C DDRA=0xFF;
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0000 046D 
; 0000 046E // Port B initialization
; 0000 046F // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0470 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0471 PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0472 DDRB=0x00;
	OUT  0x17,R30
; 0000 0473 
; 0000 0474 // Port C initialization
; 0000 0475 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0476 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0477 PORTC=0x00;
	OUT  0x15,R30
; 0000 0478 DDRC=0x00;
	OUT  0x14,R30
; 0000 0479 
; 0000 047A // Port D initialization
; 0000 047B // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 047C // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 047D PORTD=0x00;
	OUT  0x12,R30
; 0000 047E DDRD=0xFF;
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 047F 
; 0000 0480 // Port E initialization
; 0000 0481 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 0482 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 0483 PORTE=0x00;
	LDI  R30,LOW(0)
	OUT  0x3,R30
; 0000 0484 DDRE=0xFF;
	LDI  R30,LOW(255)
	OUT  0x2,R30
; 0000 0485 
; 0000 0486 // Port F initialization
; 0000 0487 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 0488 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 0489 PORTF=0x00;
	LDI  R30,LOW(0)
	STS  98,R30
; 0000 048A DDRF=0xFF;
	LDI  R30,LOW(255)
	STS  97,R30
; 0000 048B 
; 0000 048C // Port G initialization
; 0000 048D // Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 048E // State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 048F PORTG=0x00;
	LDI  R30,LOW(0)
	STS  101,R30
; 0000 0490 DDRG=0x1F;
	LDI  R30,LOW(31)
	STS  100,R30
; 0000 0491 
; 0000 0492 // Timer/Counter 0 initialization
; 0000 0493 // Clock source: System Clock
; 0000 0494 // Clock value: 2000,000 kHz
; 0000 0495 // Mode: Normal top=0xFF
; 0000 0496 // OC0 output: Disconnected
; 0000 0497 ASSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0498 TCCR0=0x02;//2
	LDI  R30,LOW(2)
	OUT  0x33,R30
; 0000 0499 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 049A OCR0=0x00;
	OUT  0x31,R30
; 0000 049B 
; 0000 049C // Timer/Counter 1 initialization
; 0000 049D // Clock source: System Clock
; 0000 049E // Clock value: Timer1 Stopped
; 0000 049F // Mode: Normal top=0xFFFF
; 0000 04A0 // OC1A output: Discon.
; 0000 04A1 // OC1B output: Discon.
; 0000 04A2 // OC1C output: Discon.
; 0000 04A3 // Noise Canceler: Off
; 0000 04A4 // Input Capture on Falling Edge
; 0000 04A5 // Timer1 Overflow Interrupt: Off
; 0000 04A6 // Input Capture Interrupt: Off
; 0000 04A7 // Compare A Match Interrupt: Off
; 0000 04A8 // Compare B Match Interrupt: Off
; 0000 04A9 // Compare C Match Interrupt: Off
; 0000 04AA TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 04AB TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 04AC TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 04AD TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 04AE ICR1H=0x00;
	OUT  0x27,R30
; 0000 04AF ICR1L=0x00;
	OUT  0x26,R30
; 0000 04B0 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 04B1 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 04B2 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 04B3 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 04B4 OCR1CH=0x00;
	STS  121,R30
; 0000 04B5 OCR1CL=0x00;
	STS  120,R30
; 0000 04B6 
; 0000 04B7 // Timer/Counter 2 initialization
; 0000 04B8 // Clock source: System Clock
; 0000 04B9 // Clock value: 2000,000 kHz
; 0000 04BA // Mode: Normal top=0xFF
; 0000 04BB // OC2 output: Disconnected
; 0000 04BC TCCR2=0x02;
	LDI  R30,LOW(2)
	OUT  0x25,R30
; 0000 04BD TCNT2=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 04BE OCR2=0x00;
	OUT  0x23,R30
; 0000 04BF 
; 0000 04C0 
; 0000 04C1 // Timer/Counter 2 initialization
; 0000 04C2 // Clock source: System Clock
; 0000 04C3 // Clock value: Timer2 Stopped
; 0000 04C4 // Mode: Normal top=0xFF
; 0000 04C5 // OC2 output: Disconnected
; 0000 04C6 //TCCR2=0x00;
; 0000 04C7 //TCNT2=0x00;
; 0000 04C8 //OCR2=0x00;
; 0000 04C9 
; 0000 04CA // Timer/Counter 3 initialization
; 0000 04CB // Clock source: System Clock
; 0000 04CC // Clock value: Timer3 Stopped
; 0000 04CD // Mode: Normal top=0xFFFF
; 0000 04CE // OC3A output: Discon.
; 0000 04CF // OC3B output: Discon.
; 0000 04D0 // OC3C output: Discon.
; 0000 04D1 // Noise Canceler: Off
; 0000 04D2 // Input Capture on Falling Edge
; 0000 04D3 // Timer3 Overflow Interrupt: Off
; 0000 04D4 // Input Capture Interrupt: Off
; 0000 04D5 // Compare A Match Interrupt: Off
; 0000 04D6 // Compare B Match Interrupt: Off
; 0000 04D7 // Compare C Match Interrupt: Off
; 0000 04D8 TCCR3A=0x00;
	STS  139,R30
; 0000 04D9 TCCR3B=0x00;
	STS  138,R30
; 0000 04DA TCNT3H=0x00;
	STS  137,R30
; 0000 04DB TCNT3L=0x00;
	STS  136,R30
; 0000 04DC ICR3H=0x00;
	STS  129,R30
; 0000 04DD ICR3L=0x00;
	STS  128,R30
; 0000 04DE OCR3AH=0x00;
	STS  135,R30
; 0000 04DF OCR3AL=0x00;
	STS  134,R30
; 0000 04E0 OCR3BH=0x00;
	STS  133,R30
; 0000 04E1 OCR3BL=0x00;
	STS  132,R30
; 0000 04E2 OCR3CH=0x00;
	STS  131,R30
; 0000 04E3 OCR3CL=0x00;
	STS  130,R30
; 0000 04E4 
; 0000 04E5 // External Interrupt(s) initialization
; 0000 04E6 // INT0: Off
; 0000 04E7 // INT1: Off
; 0000 04E8 // INT2: Off
; 0000 04E9 // INT3: Off
; 0000 04EA // INT4: Off
; 0000 04EB // INT5: Off
; 0000 04EC // INT6: Off
; 0000 04ED // INT7: Off
; 0000 04EE EICRA=0x00;
	STS  106,R30
; 0000 04EF EICRB=0x00;
	OUT  0x3A,R30
; 0000 04F0 EIMSK=0x00;
	OUT  0x39,R30
; 0000 04F1 
; 0000 04F2 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 04F3 TIMSK=0x41;
	LDI  R30,LOW(65)
	OUT  0x37,R30
; 0000 04F4 
; 0000 04F5 ETIMSK=0x00;
	LDI  R30,LOW(0)
	STS  125,R30
; 0000 04F6 
; 0000 04F7 // USART0 initialization
; 0000 04F8 // USART0 disabled
; 0000 04F9 UCSR0B=0x00;
	OUT  0xA,R30
; 0000 04FA 
; 0000 04FB // USART1 initialization
; 0000 04FC // USART1 disabled
; 0000 04FD UCSR1B=0x00;
	STS  154,R30
; 0000 04FE 
; 0000 04FF // Analog Comparator initialization
; 0000 0500 // Analog Comparator: Off
; 0000 0501 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 0502 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0503 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 0504 
; 0000 0505 // ADC initialization
; 0000 0506 // ADC disabled
; 0000 0507 ADCSRA=0x00;
	OUT  0x6,R30
; 0000 0508 
; 0000 0509 // SPI initialization
; 0000 050A // SPI disabled
; 0000 050B SPCR=0x00;
	OUT  0xD,R30
; 0000 050C 
; 0000 050D // TWI initialization
; 0000 050E // TWI disabled
; 0000 050F TWCR=0x00;
	STS  116,R30
; 0000 0510 
; 0000 0511 // Alphanumeric LCD initialization
; 0000 0512 // Connections specified in the
; 0000 0513 // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 0514 // RS - PORTG Bit 4
; 0000 0515 // RD - PORTD Bit 6
; 0000 0516 // EN - PORTD Bit 7
; 0000 0517 // D4 - PORTG Bit 0
; 0000 0518 // D5 - PORTG Bit 1
; 0000 0519 // D6 - PORTG Bit 2
; 0000 051A // D7 - PORTG Bit 3
; 0000 051B // Characters/line: 8
; 0000 051C lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _lcd_init
; 0000 051D 
; 0000 051E //STARE
; 0000 051F // PORTA.1 = 1 DIR poziomy
; 0000 0520 // PORTA.2 = 1 STEP poziomy
; 0000 0521 
; 0000 0522 // PORTC.1 = 1 DIR pion
; 0000 0523 // PORTC.2 = 1 STEP pion
; 0000 0524 
; 0000 0525 //NOWE
; 0000 0526 //PINE.5 = 1 //DIR POZIOMY
; 0000 0527 //PINE.4 = 1 //STEP POZIOMY
; 0000 0528 
; 0000 0529 //PINE.3  //DIR PIONOWY
; 0000 052A //PINE.2  //STEP pionowy
; 0000 052B 
; 0000 052C PORTA.0 = 0;  //separowanie kubkow
	CBI  0x1B,0
; 0000 052D PORTA.1 = 0;  //szpikulec
	CBI  0x1B,1
; 0000 052E PORTA.2 = 0;  //silownik poruszaj¹cy pistoletem
	CBI  0x1B,2
; 0000 052F PORTA.3 = 0;  //stemel doklejajacy
	CBI  0x1B,3
; 0000 0530 PORTA.4 = 0;  //przyssawka banderoli
	CBI  0x1B,4
; 0000 0531 PORTA.5 = 0;  //silownik banderoli
	CBI  0x1B,5
; 0000 0532 PORTA.6 = 0;  //silownik obrotowy -wywalam
	CBI  0x1B,6
; 0000 0533 PORTA.7 = 0;   //zatrzymywanie kubka
	CBI  0x1B,7
; 0000 0534 
; 0000 0535 PORTD.1 = 1;   //podcisnienie zmiana z duzego na male, czyli teraz po daniu 1 jest duze
	SBI  0x12,1
; 0000 0536 PORTD.2 = 1;   //falownik wylacz
	SBI  0x12,2
; 0000 0537 PORTD.3 = 1;   //nie lej kleju - to jest lanie kleju
	SBI  0x12,3
; 0000 0538 
; 0000 0539 //PINB.0  //RUN
; 0000 053A //PINB.1  //ST-UP
; 0000 053B //PINB.2 //ST-load
; 0000 053C //PINB.3 //kubek chaos
; 0000 053D //PINB.4 //guzik slow fast
; 0000 053E //PINB.5 //guzik big-small
; 0000 053F //PINB.6 //laser obecnosci kubka
; 0000 0540 //PINB.7 //czujnik banderol czy jest w zasobniku
; 0000 0541 
; 0000 0542 //PINC.0 //laser obecnosci banderoli
; 0000 0543 //PINC.1 //czujnik kubek na koncu tasmy - juz wolne
; 0000 0544 //PINC.2 //krancowka lewa pozioma
; 0000 0545 //PINC.3 //guzik banderole w dol
; 0000 0546 //PINC.4 //krancowka odpowiadajaca za brak kleju
; 0000 0547 //PINC.5 //czujnik ciœnienia
; 0000 0548 //PINC.6  //wolne
; 0000 0549 //PINC.7  //wolne
; 0000 054A 
; 0000 054B //Enable obu sterownikow daæ do masy
; 0000 054C 
; 0000 054D silnik_gorny_zebatka_promien = 30;   //mm
	__GETD1N 0x41F00000
	STS  _silnik_gorny_zebatka_promien,R30
	STS  _silnik_gorny_zebatka_promien+1,R31
	STS  _silnik_gorny_zebatka_promien+2,R22
	STS  _silnik_gorny_zebatka_promien+3,R23
; 0000 054E mikro_krokow_na_obrot = 4000;
	LDI  R30,LOW(4000)
	LDI  R31,HIGH(4000)
	MOVW R6,R30
; 0000 054F wyzerowalem_krancowke = 0;
	LDI  R30,LOW(0)
	STS  _wyzerowalem_krancowke,R30
	STS  _wyzerowalem_krancowke+1,R30
; 0000 0550 zezwalaj_na_kolejny_kubek = 0;
	CLR  R8
	CLR  R9
; 0000 0551 sytuacja_startowa = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _sytuacja_startowa,R30
	STS  _sytuacja_startowa+1,R31
; 0000 0552 dostep_do_podajnika = 0;
	CLR  R10
	CLR  R11
; 0000 0553 zezzwalaj_na_oklejenie_boczne = 0;
	CLR  R12
	CLR  R13
; 0000 0554 wyzerowalem_nad_podajnikiem = 0;
	LDI  R30,LOW(0)
	STS  _wyzerowalem_nad_podajnikiem,R30
	STS  _wyzerowalem_nad_podajnikiem+1,R30
; 0000 0555 wyswietl_obecnosc_kleju = 1;
	CALL SUBOPT_0x16
; 0000 0556 wyswietl_brak_kleju = 1;
	CALL SUBOPT_0x13
; 0000 0557 pracuje = 0;
	LDI  R30,LOW(0)
	STS  _pracuje,R30
	STS  _pracuje+1,R30
; 0000 0558 czas_wylaczenia_falownika = 0;
	CALL SUBOPT_0x17
; 0000 0559 czas_czyszczenia_tasmy = 0;
	LDI  R30,LOW(0)
	STS  _czas_czyszczenia_tasmy,R30
	STS  _czas_czyszczenia_tasmy+1,R30
	STS  _czas_czyszczenia_tasmy+2,R30
	STS  _czas_czyszczenia_tasmy+3,R30
; 0000 055A poczatek_serii = 1;
	CALL SUBOPT_0x1D
; 0000 055B kolejkowanie_start_stop_poczatek = 1;
; 0000 055C zeruj_flagi();
	RCALL _zeruj_flagi
; 0000 055D 
; 0000 055E PORTA.0 = 1;     //silownik blokujacy
	SBI  0x1B,0
; 0000 055F PORTE.4 = 1;  //STAN WYSOKI NA STEP poziom
	SBI  0x3,4
; 0000 0560 PORTE.2 = 1;  //STAN WYSOKI NA STEP pion
	SBI  0x3,2
; 0000 0561 ulamki_sekund_0 = 0;
	CALL SUBOPT_0x2F
; 0000 0562 ulamki_sekund_2 = 0;
	CALL SUBOPT_0x2D
; 0000 0563 fast = 0;
	LDI  R30,LOW(0)
	STS  _fast,R30
	STS  _fast+1,R30
; 0000 0564 guzik_male_kubki = 0;
	STS  _guzik_male_kubki,R30
	STS  _guzik_male_kubki+1,R30
; 0000 0565 pracuje_w_kierunku = 0;
	CLR  R4
	CLR  R5
; 0000 0566 dawka_kleju = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	STS  _dawka_kleju,R30
	STS  _dawka_kleju+1,R31
; 0000 0567 dobieram_dawke = 0;
	LDI  R30,LOW(0)
	STS  _dobieram_dawke,R30
	STS  _dobieram_dawke+1,R30
; 0000 0568 licznik_wyswietlania_kleju_stala = 100;
	__GETD1N 0x64
	STS  _licznik_wyswietlania_kleju_stala,R30
	STS  _licznik_wyswietlania_kleju_stala+1,R31
	STS  _licznik_wyswietlania_kleju_stala+2,R22
	STS  _licznik_wyswietlania_kleju_stala+3,R23
; 0000 0569 leje_klej = 0;
	LDI  R30,LOW(0)
	STS  _leje_klej,R30
	STS  _leje_klej+1,R30
; 0000 056A dawka_kleju_wyswietlona = dawka_kleju;
	CALL SUBOPT_0x54
	CALL SUBOPT_0x55
; 0000 056B 
; 0000 056C 
; 0000 056D /*
; 0000 056E PORTD.2 = 0;  //ZMIANA STANU
; 0000 056F while(czas_czyszczenia_tasmy < 1000000)
; 0000 0570        czas_czyszczenia_tasmy++;
; 0000 0571 //while(czas_czyszczenia_tasmy < 1500000)
; 0000 0572 //       czas_czyszczenia_tasmy++;
; 0000 0573 
; 0000 0574 PORTD.2 = 1;  //tasma ZMIANA STANU
; 0000 0575 */
; 0000 0576 
; 0000 0577 delay_ms(1000);
	CALL SUBOPT_0x56
; 0000 0578 delay_ms(1000);
	CALL SUBOPT_0x56
; 0000 0579 wybor_trybu_pracy_bez_fast();
	RCALL _wybor_trybu_pracy_bez_fast
; 0000 057A 
; 0000 057B #asm("sei")
	sei
; 0000 057C 
; 0000 057D 
; 0000 057E //while(1)
; 0000 057F //{
; 0000 0580 //kontrola_obecnosci_banderol();
; 0000 0581 //}
; 0000 0582 
; 0000 0583 
; 0000 0584 
; 0000 0585 
; 0000 0586 
; 0000 0587 
; 0000 0588 
; 0000 0589 
; 0000 058A 
; 0000 058B while(wyzerowalem_nad_podajnikiem == 0)
_0x12B:
	LDS  R30,_wyzerowalem_nad_podajnikiem
	LDS  R31,_wyzerowalem_nad_podajnikiem+1
	SBIW R30,0
	BRNE _0x12D
; 0000 058C {
; 0000 058D if(wyzerowalem_krancowke == 0)
	LDS  R30,_wyzerowalem_krancowke
	LDS  R31,_wyzerowalem_krancowke+1
	SBIW R30,0
	BRNE _0x12E
; 0000 058E    jedz_do_krancowki_poziom();
	RCALL _jedz_do_krancowki_poziom
; 0000 058F }
_0x12E:
	RJMP _0x12B
_0x12D:
; 0000 0590 
; 0000 0591 sprawdz_cisnienie();
	RCALL _sprawdz_cisnienie
; 0000 0592 
; 0000 0593 
; 0000 0594 //ustawienia na liczniku:
; 0000 0595 //male kubki - 9970
; 0000 0596 //hasso - 0000
; 0000 0597 //haos - 0420 + przegroda wydluzona
; 0000 0598 
; 0000 0599 //wydajnosc
; 0000 059A //ultimate - 18 na min
; 0000 059B //hasso - 18 min
; 0000 059C //chaos - 16 min
; 0000 059D 
; 0000 059E 
; 0000 059F //po poprawkach
; 0000 05A0 //ultimate - 23 na min
; 0000 05A1 //hasso - 22 min
; 0000 05A2 //chaos -  21 min
; 0000 05A3 
; 0000 05A4 //PORTA.4 = 1;
; 0000 05A5 //while(1)
; 0000 05A6 {
; 0000 05A7 }
; 0000 05A8 
; 0000 05A9 
; 0000 05AA while (1)
_0x12F:
; 0000 05AB       {
; 0000 05AC 
; 0000 05AD       sprawdz_cisnienie();
	RCALL _sprawdz_cisnienie
; 0000 05AE 
; 0000 05AF       sekwencja_wylaczenia_falownika();
	RCALL _sekwencja_wylaczenia_falownika
; 0000 05B0 
; 0000 05B1       if(ulamki_sekund_2 > 3)
	CALL SUBOPT_0x2C
	__CPD2N 0x4
	BRLT _0x132
; 0000 05B2          ulamki_sekund_2 = 0;
	CALL SUBOPT_0x2D
; 0000 05B3 
; 0000 05B4       obsluga_podajnika_banderol();
_0x132:
	RCALL _obsluga_podajnika_banderol
; 0000 05B5       obsluga_kleju();
	RCALL _obsluga_kleju
; 0000 05B6       obsluga_dawki_kleju();
	RCALL _obsluga_dawki_kleju
; 0000 05B7 
; 0000 05B8                                                                           //run - stoi
; 0000 05B9       if(licznik_wyswietlania_kleju == licznik_wyswietlania_kleju_stala & PINB.0 == 1 & pracuje == 0)
	CALL SUBOPT_0x14
	CALL __EQD12
	CALL SUBOPT_0x1F
	LDI  R30,LOW(1)
	CALL __EQB12
	CALL SUBOPT_0x18
	CALL SUBOPT_0xF
	AND  R30,R0
	BREQ _0x133
; 0000 05BA         {
; 0000 05BB          licznik_wyswietlen_jak_stoi++;
	LDI  R26,LOW(_licznik_wyswietlen_jak_stoi)
	LDI  R27,HIGH(_licznik_wyswietlen_jak_stoi)
	CALL SUBOPT_0x15
; 0000 05BC          if(jest_klej == 1 & licznik_wyswietlen_jak_stoi == 5000)
	CALL SUBOPT_0x57
	MOV  R0,R30
	LDS  R26,_licznik_wyswietlen_jak_stoi
	LDS  R27,_licznik_wyswietlen_jak_stoi+1
	LDS  R24,_licznik_wyswietlen_jak_stoi+2
	LDS  R25,_licznik_wyswietlen_jak_stoi+3
	__GETD1N 0x1388
	CALL __EQD12
	AND  R30,R0
	BREQ _0x134
; 0000 05BD                     {
; 0000 05BE                     lcd_clear();
	CALL SUBOPT_0xE
; 0000 05BF                     lcd_gotoxy(0,0);
; 0000 05C0                     lcd_puts("NUMER");
	__POINTW1MN _0x135,0
	CALL SUBOPT_0x8
; 0000 05C1                     lcd_gotoxy(7,0);
	CALL SUBOPT_0x58
; 0000 05C2                     itoa(licznik_cykli,dupa);
; 0000 05C3                     lcd_puts(dupa);
; 0000 05C4                     lcd_gotoxy(0,1);
	CALL SUBOPT_0x9
; 0000 05C5                     lcd_puts("DAWKA KLEJU");
	__POINTW1MN _0x135,6
	CALL SUBOPT_0x8
; 0000 05C6                     lcd_gotoxy(13,1);
	CALL SUBOPT_0x59
; 0000 05C7                     itoa(dawka_kleju,dupa);
; 0000 05C8                     dawka_kleju_wyswietlona = dawka_kleju;
	CALL SUBOPT_0x54
	CALL SUBOPT_0x55
; 0000 05C9                     lcd_puts(dupa);
	CALL SUBOPT_0x5A
; 0000 05CA                     licznik_wyswietlen_jak_stoi = 0;
	LDI  R30,LOW(0)
	STS  _licznik_wyswietlen_jak_stoi,R30
	STS  _licznik_wyswietlen_jak_stoi+1,R30
	STS  _licznik_wyswietlen_jak_stoi+2,R30
	STS  _licznik_wyswietlen_jak_stoi+3,R30
; 0000 05CB                     }
; 0000 05CC         }
_0x134:
; 0000 05CD 
; 0000 05CE 
; 0000 05CF                                    //run                                                                //ZMIANA STANU
; 0000 05D0    if(wyzerowalem_krancowke == 1 & PINB.0 == 0 & dostep_do_podajnika == 0 & podajnik_gotowy == 1 & zatrzymalem_kubek == 1 & jest_klej == 1 | pracuje == 1)
_0x133:
	CALL SUBOPT_0x39
	CALL SUBOPT_0x1F
	CALL SUBOPT_0xA
	MOVW R26,R10
	CALL SUBOPT_0xF
	AND  R0,R30
	LDS  R26,_podajnik_gotowy
	LDS  R27,_podajnik_gotowy+1
	CALL SUBOPT_0x12
	AND  R0,R30
	LDS  R26,_zatrzymalem_kubek
	LDS  R27,_zatrzymalem_kubek+1
	CALL SUBOPT_0x12
	AND  R0,R30
	CALL SUBOPT_0x57
	CALL SUBOPT_0x18
	CALL SUBOPT_0x12
	OR   R30,R0
	BREQ _0x136
; 0000 05D1             {
; 0000 05D2             praca_prawo();
	RCALL _praca_prawo
; 0000 05D3             pracuje = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _pracuje,R30
	STS  _pracuje+1,R31
; 0000 05D4             if(wykonano_2 == 1)
	LDS  R26,_wykonano_2
	LDS  R27,_wykonano_2+1
	SBIW R26,1
	BRNE _0x137
; 0000 05D5                    {
; 0000 05D6                    praca_lewo();
	RCALL _praca_lewo
; 0000 05D7                    zeruj_flagi();
	RCALL _zeruj_flagi
; 0000 05D8                    licznik_cykli++;
	LDI  R26,LOW(_licznik_cykli)
	LDI  R27,HIGH(_licznik_cykli)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 05D9                    if(jest_klej == 1)
	LDS  R26,_jest_klej
	LDS  R27,_jest_klej+1
	SBIW R26,1
	BRNE _0x138
; 0000 05DA                     {
; 0000 05DB                     lcd_clear();
	CALL SUBOPT_0xE
; 0000 05DC                     lcd_gotoxy(0,0);
; 0000 05DD                     lcd_puts("NUMER");
	__POINTW1MN _0x135,18
	CALL SUBOPT_0x8
; 0000 05DE                     lcd_gotoxy(7,0);
	CALL SUBOPT_0x58
; 0000 05DF                     itoa(licznik_cykli,dupa);
; 0000 05E0                     lcd_puts(dupa);
; 0000 05E1                     lcd_gotoxy(0,1);
	CALL SUBOPT_0x9
; 0000 05E2                     lcd_puts("DAWKA KLEJU");
	__POINTW1MN _0x135,24
	CALL SUBOPT_0x8
; 0000 05E3                     lcd_gotoxy(13,1);
	CALL SUBOPT_0x59
; 0000 05E4                     itoa(dawka_kleju,dupa);
; 0000 05E5                     lcd_puts(dupa);
	CALL SUBOPT_0x5A
; 0000 05E6                     dawka_kleju_wyswietlona = dawka_kleju;
	CALL SUBOPT_0x54
	CALL SUBOPT_0x55
; 0000 05E7                     }
; 0000 05E8                    if(PINB.7 == 1)  //to stary B.2
_0x138:
	SBIS 0x16,7
	RJMP _0x139
; 0000 05E9                       podajnik_gotowy = 1;
	CALL SUBOPT_0x37
; 0000 05EA                    pracuje = 0;
_0x139:
	LDI  R30,LOW(0)
	STS  _pracuje,R30
	STS  _pracuje+1,R30
; 0000 05EB                    }
; 0000 05EC             }
_0x137:
; 0000 05ED 
; 0000 05EE        }
_0x136:
	RJMP _0x12F
; 0000 05EF 
; 0000 05F0 
; 0000 05F1 }
_0x13A:
	RJMP _0x13A

	.DSEG
_0x135:
	.BYTE 0x24
;
;

	.CSEG
_strcmp:
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
strcmp0:
    ld   r22,x+
    ld   r23,z+
    cp   r22,r23
    brne strcmp1
    tst  r22
    brne strcmp0
strcmp3:
    clr  r30
    ret
strcmp1:
    sub  r22,r23
    breq strcmp3
    ldi  r30,1
    brcc strcmp2
    subi r30,2
strcmp2:
    ret

	.CSEG
_itoa:
    ld   r26,y+
    ld   r27,y+
    ld   r30,y+
    ld   r31,y+
    adiw r30,0
    brpl __itoa0
    com  r30
    com  r31
    adiw r30,1
    ldi  r22,'-'
    st   x+,r22
__itoa0:
    clt
    ldi  r24,low(10000)
    ldi  r25,high(10000)
    rcall __itoa1
    ldi  r24,low(1000)
    ldi  r25,high(1000)
    rcall __itoa1
    ldi  r24,100
    clr  r25
    rcall __itoa1
    ldi  r24,10
    rcall __itoa1
    mov  r22,r30
    rcall __itoa5
    clr  r22
    st   x,r22
    ret

__itoa1:
    clr	 r22
__itoa2:
    cp   r30,r24
    cpc  r31,r25
    brlo __itoa3
    inc  r22
    sub  r30,r24
    sbc  r31,r25
    brne __itoa2
__itoa3:
    tst  r22
    brne __itoa4
    brts __itoa5
    ret
__itoa4:
    set
__itoa5:
    subi r22,-0x30
    st   x+,r22
    ret

	.DSEG

	.CSEG

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G103:
	LD   R30,Y
	ANDI R30,LOW(0x10)
	BREQ _0x2060004
	LDS  R30,101
	ORI  R30,1
	RJMP _0x206001D
_0x2060004:
	LDS  R30,101
	ANDI R30,0xFE
_0x206001D:
	STS  101,R30
	LD   R30,Y
	ANDI R30,LOW(0x20)
	BREQ _0x2060006
	LDS  R30,101
	ORI  R30,2
	RJMP _0x206001E
_0x2060006:
	LDS  R30,101
	ANDI R30,0xFD
_0x206001E:
	STS  101,R30
	LD   R30,Y
	ANDI R30,LOW(0x40)
	BREQ _0x2060008
	LDS  R30,101
	ORI  R30,4
	RJMP _0x206001F
_0x2060008:
	LDS  R30,101
	ANDI R30,0xFB
_0x206001F:
	STS  101,R30
	LD   R30,Y
	ANDI R30,LOW(0x80)
	BREQ _0x206000A
	LDS  R30,101
	ORI  R30,8
	RJMP _0x2060020
_0x206000A:
	LDS  R30,101
	ANDI R30,0XF7
_0x2060020:
	STS  101,R30
	__DELAY_USB 5
	SBI  0x12,7
	__DELAY_USB 13
	CBI  0x12,7
	__DELAY_USB 13
	RJMP _0x20A0001
__lcd_write_data:
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_nibble_G103
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_nibble_G103
	__DELAY_USB 133
	RJMP _0x20A0001
_lcd_gotoxy:
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G103)
	SBCI R31,HIGH(-__base_y_G103)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R30,R26
	ST   -Y,R30
	RCALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
	ADIW R28,2
	RET
_lcd_clear:
	LDI  R30,LOW(2)
	CALL SUBOPT_0x5B
	LDI  R30,LOW(12)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(1)
	CALL SUBOPT_0x5B
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
_lcd_putchar:
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2060011
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2060010
_0x2060011:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R30,__lcd_y
	SUBI R30,-LOW(1)
	STS  __lcd_y,R30
	ST   -Y,R30
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2060013
	RJMP _0x20A0001
_0x2060013:
_0x2060010:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	LDS  R30,101
	ORI  R30,0x10
	STS  101,R30
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_data
	LDS  R30,101
	ANDI R30,0xEF
	STS  101,R30
	RJMP _0x20A0001
_lcd_puts:
	ST   -Y,R17
_0x2060014:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2060016
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x2060014
_0x2060016:
	LDD  R17,Y+0
	ADIW R28,3
	RET
_lcd_init:
	LDS  R30,100
	ORI  R30,1
	CALL SUBOPT_0x5C
	ORI  R30,2
	CALL SUBOPT_0x5C
	ORI  R30,4
	CALL SUBOPT_0x5C
	ORI  R30,8
	STS  100,R30
	SBI  0x11,7
	LDS  R30,100
	ORI  R30,0x10
	STS  100,R30
	SBI  0x11,6
	CBI  0x12,7
	LDS  R30,101
	ANDI R30,0xEF
	STS  101,R30
	CBI  0x12,6
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G103,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G103,3
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	CALL SUBOPT_0x5D
	CALL SUBOPT_0x5D
	CALL SUBOPT_0x5D
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_write_nibble_G103
	__DELAY_USW 200
	LDI  R30,LOW(40)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(4)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(133)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(6)
	ST   -Y,R30
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x20A0001:
	ADIW R28,1
	RET

	.CSEG

	.DSEG
_ulamki_sekund_0:
	.BYTE 0x4
_ulamki_sekund_1:
	.BYTE 0x4
_ulamki_sekund_2:
	.BYTE 0x4
_milisekundy_przechodzi_kubek:
	.BYTE 0x4
_milisekundy_czas_kroku:
	.BYTE 0x4
_milisekundy_pobieram_banderole:
	.BYTE 0x4
_milisekundy_przejazd_nad_klejem:
	.BYTE 0x4
_milisekundy_naklejam:
	.BYTE 0x4
_milisekundy_oklejanie_boczne:
	.BYTE 0x4
_czas_wylaczenia_falownika:
	.BYTE 0x4
_czas_czyszczenia_tasmy:
	.BYTE 0x4
_licznik_wlacznika_run:
	.BYTE 0x4
_licznik_wyswietlania_kleju:
	.BYTE 0x4
_licznik_wyswietlania_kleju_stala:
	.BYTE 0x4
_licznik_wyswietlen_jak_stoi:
	.BYTE 0x4
_silnik_gorny_zebatka_promien:
	.BYTE 0x4
_czas:
	.BYTE 0x4
_oklejam_bok:
	.BYTE 0x2
_wyzerowalem_nad_podajnikiem:
	.BYTE 0x2
_jest_klej:
	.BYTE 0x2
_pracuje:
	.BYTE 0x2
_wyswietl_obecnosc_kleju:
	.BYTE 0x2
_wyswietl_brak_kleju:
	.BYTE 0x2
_zezwolenie_run:
	.BYTE 0x2
_dawka_kleju:
	.BYTE 0x2
_srednie_kubki:
	.BYTE 0x2
_pobralem_banderole:
	.BYTE 0x2
_opuscilem_banderole:
	.BYTE 0x2
_podnioslem_banderole:
	.BYTE 0x2
_lej_klej:
	.BYTE 0x2
_cofniety_pistolet:
	.BYTE 0x2
_nakleilem:
	.BYTE 0x2
_wyzerowalem_krancowke:
	.BYTE 0x2
_wykonano_1:
	.BYTE 0x2
_wykonano_2:
	.BYTE 0x2
_sprawdzilem_banderole:
	.BYTE 0x2
_podajnik_gotowy:
	.BYTE 0x2
_widzi_kubek:
	.BYTE 0x2
_zatrzymalem_kubek:
	.BYTE 0x2
_licznik_pionowego_czujnika:
	.BYTE 0x2
_licznik_cykli:
	.BYTE 0x2
_sytuacja_startowa:
	.BYTE 0x2
_fast:
	.BYTE 0x2
_guzik_male_kubki:
	.BYTE 0x2
_kubek:
	.BYTE 0x2
_dupa:
	.BYTE 0x2
_poczatek_serii:
	.BYTE 0x2
_kolejkowanie_start_stop_poczatek:
	.BYTE 0x2
_dobieram_dawke:
	.BYTE 0x2
_leje_klej:
	.BYTE 0x2
_dawka_kleju_wyswietlona:
	.BYTE 0x2
_wyk1:
	.BYTE 0x2
__seed_G101:
	.BYTE 0x4
__base_y_G103:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x0:
	LD   R30,Y
	LDD  R31,Y+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:30 WORDS
SUBOPT_0x1:
	ST   -Y,R31
	ST   -Y,R30
	CALL _strcmp
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:63 WORDS
SUBOPT_0x2:
	LDS  R30,_ulamki_sekund_1
	LDS  R31,_ulamki_sekund_1+1
	LDS  R22,_ulamki_sekund_1+2
	LDS  R23,_ulamki_sekund_1+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x4:
	RCALL SUBOPT_0x2
	CALL __SUBD12
	CALL __PUTD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5:
	LDI  R26,0
	SBIC 0x16,3
	LDI  R26,1
	LDI  R30,LOW(1)
	CALL __EQB12
	MOV  R0,R30
	LDI  R26,0
	SBIC 0x16,4
	LDI  R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(1)
	CALL __EQB12
	AND  R0,R30
	LDI  R26,0
	SBIC 0x16,5
	LDI  R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _fast,R30
	STS  _fast+1,R31
	CALL _lcd_clear
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:35 WORDS
SUBOPT_0x8:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x9:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(0)
	CALL __EQB12
	AND  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(0)
	CALL __EQB12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	STS  _srednie_kubki,R30
	STS  _srednie_kubki+1,R31
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xD:
	LDI  R30,LOW(0)
	CALL __EQB12
	MOV  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0xE:
	CALL _lcd_clear
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 23 TIMES, CODE SIZE REDUCTION:41 WORDS
SUBOPT_0xF:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x10:
	LDS  R26,_dawka_kleju
	LDS  R27,_dawka_kleju+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x11:
	LDI  R30,LOW(1)
	CALL __EQB12
	MOV  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 45 TIMES, CODE SIZE REDUCTION:85 WORDS
SUBOPT_0x12:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _wyswietl_brak_kleju,R30
	STS  _wyswietl_brak_kleju+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x14:
	LDS  R30,_licznik_wyswietlania_kleju_stala
	LDS  R31,_licznik_wyswietlania_kleju_stala+1
	LDS  R22,_licznik_wyswietlania_kleju_stala+2
	LDS  R23,_licznik_wyswietlania_kleju_stala+3
	LDS  R26,_licznik_wyswietlania_kleju
	LDS  R27,_licznik_wyswietlania_kleju+1
	LDS  R24,_licznik_wyswietlania_kleju+2
	LDS  R25,_licznik_wyswietlania_kleju+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:51 WORDS
SUBOPT_0x15:
	CALL __GETD1P_INC
	__SUBD1N -1
	CALL __PUTDP1_DEC
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _wyswietl_obecnosc_kleju,R30
	STS  _wyswietl_obecnosc_kleju+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x17:
	LDI  R30,LOW(0)
	STS  _czas_wylaczenia_falownika,R30
	STS  _czas_wylaczenia_falownika+1,R30
	STS  _czas_wylaczenia_falownika+2,R30
	STS  _czas_wylaczenia_falownika+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x18:
	AND  R0,R30
	LDS  R26,_pracuje
	LDS  R27,_pracuje+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x19:
	LDS  R26,_czas_wylaczenia_falownika
	LDS  R27,_czas_wylaczenia_falownika+1
	LDS  R24,_czas_wylaczenia_falownika+2
	LDS  R25,_czas_wylaczenia_falownika+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1A:
	LDI  R26,LOW(_czas_wylaczenia_falownika)
	LDI  R27,HIGH(_czas_wylaczenia_falownika)
	RJMP SUBOPT_0x15

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1B:
	LDI  R30,LOW(0)
	STS  _widzi_kubek,R30
	STS  _widzi_kubek+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:67 WORDS
SUBOPT_0x1C:
	LDI  R30,LOW(0)
	STS  _czas,R30
	STS  _czas+1,R30
	STS  _czas+2,R30
	STS  _czas+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1D:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _poczatek_serii,R30
	STS  _poczatek_serii+1,R31
	STS  _kolejkowanie_start_stop_poczatek,R30
	STS  _kolejkowanie_start_stop_poczatek+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	LDS  R26,_kolejkowanie_start_stop_poczatek
	LDS  R27,_kolejkowanie_start_stop_poczatek+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1F:
	MOV  R0,R30
	LDI  R26,0
	SBIC 0x16,0
	LDI  R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x20:
	LDS  R26,_kubek
	LDS  R27,_kubek+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x21:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _kubek,R30
	STS  _kubek+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x22:
	MOV  R0,R30
	LDS  R26,_czas
	LDS  R27,_czas+1
	LDS  R24,_czas+2
	LDS  R25,_czas+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x23:
	LDI  R30,LOW(0)
	STS  _kubek,R30
	STS  _kubek+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x24:
	STS  _kubek,R30
	STS  _kubek+1,R31
	RJMP SUBOPT_0x1C

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x25:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x26:
	STS  _kubek,R30
	STS  _kubek+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x27:
	RCALL SUBOPT_0x20
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __EQW12
	RJMP SUBOPT_0x22

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x28:
	__GETD1N 0x1194
	CALL __GTD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x29:
	AND  R0,R30
	LDS  R26,_srednie_kubki
	LDS  R27,_srednie_kubki+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2A:
	CALL __GTD12
	RJMP SUBOPT_0x29

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2B:
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2C:
	LDS  R26,_ulamki_sekund_2
	LDS  R27,_ulamki_sekund_2+1
	LDS  R24,_ulamki_sekund_2+2
	LDS  R25,_ulamki_sekund_2+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x2D:
	LDI  R30,LOW(0)
	STS  _ulamki_sekund_2,R30
	STS  _ulamki_sekund_2+1,R30
	STS  _ulamki_sekund_2+2,R30
	STS  _ulamki_sekund_2+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x2E:
	LDS  R26,_ulamki_sekund_0
	LDS  R27,_ulamki_sekund_0+1
	LDS  R24,_ulamki_sekund_0+2
	LDS  R25,_ulamki_sekund_0+3
	CALL __CWD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2F:
	LDI  R30,LOW(0)
	STS  _ulamki_sekund_0,R30
	STS  _ulamki_sekund_0+1,R30
	STS  _ulamki_sekund_0+2,R30
	STS  _ulamki_sekund_0+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x30:
	CALL __CWD1
	STS  _ulamki_sekund_0,R30
	STS  _ulamki_sekund_0+1,R31
	STS  _ulamki_sekund_0+2,R22
	STS  _ulamki_sekund_0+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x31:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _obroc_o_1_8_stopnia

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x32:
	LDS  R26,_wyzerowalem_krancowke
	LDS  R27,_wyzerowalem_krancowke+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x33:
	ST   -Y,R31
	ST   -Y,R30
	CALL _jedz_dystans
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x34:
	LDI  R26,0
	SBIC 0x16,0
	LDI  R26,1
	RJMP SUBOPT_0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x35:
	LDI  R26,0
	SBIC 0x16,1
	LDI  R26,1
	LDI  R30,LOW(1)
	CALL __EQB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x36:
	LDI  R26,0
	SBIC 0x13,3
	LDI  R26,1
	LDI  R30,LOW(1)
	CALL __EQB12
	AND  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x37:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _podajnik_gotowy,R30
	STS  _podajnik_gotowy+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x38:
	LDS  R26,_podajnik_gotowy
	LDS  R27,_podajnik_gotowy+1
	RJMP SUBOPT_0xF

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x39:
	RCALL SUBOPT_0x32
	RJMP SUBOPT_0x12

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3A:
	__GETD1N 0x42200000
	CALL __PUTPARD1
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:53 WORDS
SUBOPT_0x3B:
	ST   -Y,R31
	ST   -Y,R30
	CALL _odczyt_licznik
	MOVW R26,R30
	MOVW R24,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x3C:
	MOV  R0,R30
	LDS  R26,_wykonano_1
	LDS  R27,_wykonano_1+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3D:
	STS  _wykonano_1,R30
	STS  _wykonano_1+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3E:
	STS  _wyk1,R30
	STS  _wyk1+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x3F:
	LDS  R26,_fast
	LDS  R27,_fast+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:53 WORDS
SUBOPT_0x40:
	CALL __GTD12
	MOV  R0,R30
	LDS  R26,_pobralem_banderole
	LDS  R27,_pobralem_banderole+1
	RJMP SUBOPT_0x12

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x41:
	AND  R0,R30
	RCALL SUBOPT_0x3F
	RJMP SUBOPT_0x12

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x42:
	AND  R0,R30
	LDS  R26,_leje_klej
	LDS  R27,_leje_klej+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x43:
	STS  _leje_klej,R30
	STS  _leje_klej+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x44:
	SBI  0x12,3
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RJMP SUBOPT_0x43

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x45:
	CALL __EQW12
	RJMP SUBOPT_0x42

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x46:
	LDI  R30,LOW(21)
	LDI  R31,HIGH(21)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x47:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	ST   -Y,R31
	ST   -Y,R30
	CALL _jedz_kroki
	RJMP SUBOPT_0x46

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x48:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _jedz_kroki

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x49:
	LDI  R30,LOW(42)
	LDI  R31,HIGH(42)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x4A:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _jedz_kroki

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x4B:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _jedz_kroki

;OPTIMIZER ADDED SUBROUTINE, CALLED 21 TIMES, CODE SIZE REDUCTION:117 WORDS
SUBOPT_0x4C:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _jedz_kroki

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4D:
	LDS  R30,_fast
	LDS  R31,_fast+1
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4E:
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _jedz_kroki

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x4F:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _jedz_kroki

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x50:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _jedz_kroki

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x51:
	CALL __GTD12
	MOV  R0,R30
	LDS  R26,_wykonano_2
	LDS  R27,_wykonano_2+1
	RJMP SUBOPT_0xF

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x52:
	AND  R0,R30
	LDS  R26,_wykonano_1
	LDS  R27,_wykonano_1+1
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x53:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _wykonano_2,R30
	STS  _wykonano_2+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x54:
	LDS  R30,_dawka_kleju
	LDS  R31,_dawka_kleju+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x55:
	STS  _dawka_kleju_wyswietlona,R30
	STS  _dawka_kleju_wyswietlona+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x56:
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x57:
	LDS  R26,_jest_klej
	LDS  R27,_jest_klej+1
	RJMP SUBOPT_0x12

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x58:
	LDI  R30,LOW(7)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _lcd_gotoxy
	LDS  R30,_licznik_cykli
	LDS  R31,_licznik_cykli+1
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_dupa
	LDS  R31,_dupa+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _itoa
	LDS  R30,_dupa
	LDS  R31,_dupa+1
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x59:
	LDI  R30,LOW(13)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
	RCALL SUBOPT_0x54
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_dupa
	LDS  R31,_dupa+1
	ST   -Y,R31
	ST   -Y,R30
	JMP  _itoa

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5A:
	LDS  R30,_dupa
	LDS  R31,_dupa+1
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x5B:
	ST   -Y,R30
	CALL __lcd_write_data
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5C:
	STS  100,R30
	LDS  R30,100
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x5D:
	LDI  R30,LOW(48)
	ST   -Y,R30
	CALL __lcd_write_nibble_G103
	__DELAY_USW 200
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

__SUBD12:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	SBC  R23,R25
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

__EQW12:
	CP   R30,R26
	CPC  R31,R27
	LDI  R30,1
	BREQ __EQW12T
	CLR  R30
__EQW12T:
	RET

__EQD12:
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
	LDI  R30,1
	BREQ __EQD12T
	CLR  R30
__EQD12T:
	RET

__LTD12:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R25,R23
	LDI  R30,1
	BRLT __LTD12T
	CLR  R30
__LTD12T:
	RET

__GTD12:
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
	LDI  R30,1
	BRLT __GTD12T
	CLR  R30
__GTD12T:
	RET

__GETD1P_INC:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X+
	RET

__PUTDP1_DEC:
	ST   -X,R23
	ST   -X,R22
	ST   -X,R31
	ST   -X,R30
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

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__CPD12:
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
	RET

__CPD21:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R25,R23
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

;END OF CODE MARKER
__END_OF_CODE:
