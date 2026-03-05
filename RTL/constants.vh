// constants.vh - Global Constants and Parameters

`define DATA_WIDTH 128
`define BYTE_WIDTH 8

// FSM Configuration
`define STATE_WIDTH 2

// FSM States Encoding: RESET -> IDLE -> SB -> MC -> IDLE
`define STATE_RESET 2'd0
`define STATE_IDLE  2'd1
`define STATE_SB    2'd2
`define STATE_MC    2'd3

`define SIM_DELAY #1
