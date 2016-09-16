//
// cortex-m0-inst-decode.v
//
// Instruction decoder for cortex-m0 3-stage pipeline
//
// Danny Gale
// 9/15/2016
//

module cortex_m0_decode (
   input clk,
   input reset,

   input [15:0] inst

	output reg [2:0] Rd;
	output reg [2:0] Rm;
	output reg [2:0] Rn;
	output reg [7:0] imm;
);

wire main_opcode = inst[15:10]

// Rd = destination register
// Rn = first operand register
// Rm = second operand register
// immn = n-bit immediate operand

// sasmc instructions:
// inst[15:14] = 00
// inst[13:9] = opcode
// op			  inst	mode	operation						encoding
// 00000xx    LSL		imm	logical shift left			10:6=imm5,	5:3=Rm, 2:0=Rd
// 00001xx    LSR 	imm  	logical shift right        10:6=imm5,	5:3=Rm, 2:0=Rd
// 00010xx    ASR 	imm  	arithmetic shift right     10:6=imm5,	5:3=Rm, 2:0=Rd
// 0001100    ADD 	reg	add register					8:6=Rm,		5:3=Rn, 2:0=Rd
// 0001101    SUB 	reg	subtract register				8:6=Rm,		5:3=Rn, 2:0=Rd
// 0001110    ADD 	imm	add 3b immediate				8:6=imm3,	5:3=Rn, 2:0=Rd
// 0001111    SUB 	imm	subtract 3b immediate		8:6=imm3,	5:3=Rn, 2:0=Rd
// 00100xx    MOV 	imm	move								10:8=Rd,		7:0=imm8
// 00101xx    CMP 	imm	compare							10:8=Rn,		7:0=imm8
// 00110xx    ADD 	imm	add 8b immediate				10:8=Rdn,	7:0=imm8
// 00111xx    SUB 	imm	subtract 8b immediate		10:8=Rdn,	7:0=imm8
wire sasmc = main_opcode == 6'b00xxxx;

// data processing instructions:
// [15:10] = 010000, [9:6] = opcode
//
//		  op		inst	mode  operation						encoding
// 010000000	AND	reg	bitwise and						
// 010000001	EOR	reg	exclusive or
// 010000010	LSL	reg	logical shift left
// 010000011	LSR	reg	logical shift right
// 010000100	ASR	reg	arithmetic shift right
// 010000101	ADC	reg	add w/carry						5:3=Rm, 2:0=Rdn
// 010000110	SBC	reg	subtract w/carry
// 010000111	ROR	reg	rotate right
// 010000000	TST	reg	set flags on bitwise and
// 010000001	RSB	imm	reverse subtract from 0
// 010000010	CMP	reg	compare registers
// 010000011	CMN	reg	compare negative
// 010000100	ORR	reg	logical or
// 010000101	MUL	reg	multiply two registers
// 010000110	BIC	reg	bit clear
// 010000111	MVN	reg	bitwise not
wire data_processing = main_opcode == 6'b010000;  // 6'b010000

// special data instructions and branch and exchange
// [15:10] = 010001, [9:6] = opcode
//
// [9:6]	inst	mode	operation						encoding
// 00xx	ADD	reg	add registers
// 0100	UNPREDICTABLE
// 0101	CMP	reg	compare registers
// 011x	CMP	reg	compare registers
// 10xx	MOV	reg	move registers
// 110x	BX				branch and exchange
// 111x	BLX			branch w/link & exchange
wire special = main_opcode == 6'b010001;

// load/store single data item
// [15:12] == 0101 => register mode
// [15:12] == 0110 => immediate, whole register
// [15:12] == 0111 => immediate, register byte
// [15:12] == 1000 => immediate, halfword
// [15:12] == 1001 => immediate, SP relative
//
// [15:12]	[11:9]	inst	mode	operation		encoding
// 0101		000		STR	reg	store register
// 0101		001		STRH	reg	store register halfword
// 0101		010		STRB	reg	store register byte
// 0101		011		LDRSB	reg	load register signed byte
// 0101		100		LDR	reg	load register
// 0101		101		LDRH	reg	load register halfword
// 0101		110		LDRB	reg	load register byte
// 0101		111		LDRSH	reg	load register signed halfword
// 0110		0xx		STR	imm	Store register
// 0110		1xx		LDR	imm	load register
// 0111		0xx		STR	imm	store register byte
// 0111		1xx		LDR	imm	load register byte
// 1000		0xx		STRH	imm	store register halfword
// 1000		1xx		LDRH	imm	load register halfword
// 1001		0xx		STR	imm	store register sp relative
// 1011		1xx		LDR	imm	load register sp relative
wire load_store_single = (main_opcode == 6'b0101xx) || (main_opcode == 6'b0110xx) || 
	(main_opcode == 6'b0111xx) || (main_opcode == 6'b100xxx);

// miscellaneous 16-bit instructions
// [15:12] = 1011. [11:5] = opcode
//
// [11:5]	inst	mode	operation						encoding
// 00000xx	ADD	SPPI	add immediate to SP			T1: 10:8=Rd, 7:0=imm8
//																	T2: 
// 00001xx	SUB	SPMI	subtract immedaite from SP
// 001000x	SXTH			signed extend halfword
// 001001x	SXTB			signed extend byte
// 001010x	UXTH			unsigned extend halfword
// 001011x	UXTB			unsigned extend byte
// 010xxxx	PUSH			push multiple registers
// 0110011	CPS			change processor state
// 101000x	REV			byte reverse word
// 101001x	REV16			byte reverse packed halfword
// 101011x	REVSH			byte reverse signed halfword
// 110xxxx	POP			pop multiple registers
// 1110xxx	BKPT			breakpoint
wire misc = (inst[15:12] == 4'b1011) && (
	//( inst[11:5] == 7'b00000xx ) || // ADD
	//( inst[11:5] == 7'b00001xx ) || // SUB these two become:
	( inst[11:5] == 7'b0000xxx ) ||
	//( inst[11:5] == 7'b001000x ) || // SXTH
	//( inst[11:5] == 7'b001001x ) || // SXTB these two become:
	( inst[11:5] == 7'b00100xx ) ||
);

// hint instructions
// [15:12] = 1011, 11:8 = 1111, 7:4 = OpA, 3:0 = OpB
//
// OpA	OpB		inst		operation					encoding
// xxxx	not 0000 UNDEFINED
// 0000	0000		NOP		no operation hint
// 0001	0000		YIELD		yield hind
// 0010	0000		WFE		wait for event
// 0011	0000		WFI		wait for interrupt hint
// 0100	0000		SEV		send event hint


// conditional branch, and supervisor call
// 15:12 = 1101, 11:8 = opcode
//
// opcode	inst	operation								encoding
// not 111x	B		conditional branch
// 1110		UDF	permanently undefined
// 1111		SVC	supervisor call

// 32-bit thumb instructions
// for 32-bit instructions, [12:11] of upper word is != 00
// 
// 12:11
// x1			UDF
// 10			if highest bit of low inst word is 1, branch and misc, see below.
//					else undefined
//
//
// Branch and misc control
//
// 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0 | 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0
// 1  1  1 | 1 0 |      op1     |        | 1 |   op2  |
//
// op2	op1		inst	operation
// 0x0	011100x	MSR	move to special register
// 0x0	0111011			miscellaneous and control instructions
// 0x0	011111x	MRS	move from special register
//	010	1111111	UDF	permanently undefined
//	1x1				BL		branch with link
//
// miscellaneous control instructions
// op is bits [7:4] of lower word
// op		inst	operation
// 0100	DSB	data synchronization barrier
// 0101	DMB	data memory barrier
// 0110	ISB	instruction synchronization barrier



endmodule;
