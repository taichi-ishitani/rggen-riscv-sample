interface riscv_csrbus_if #(
  parameter int XLEN  = 32
);
  logic             valid;
  logic [2:0]       funct3;
  logic [11:0]      csr;
  logic [4:0]       rs1;
  logic [XLEN-1:0]  rs1_value;
  logic             ready;
  logic [XLEN-1:0]  rd_value;
  logic             error;

  modport master (
    output  valid,
    output  funct3,
    output  csr,
    output  rs1,
    output  rs1_value,
    input   ready,
    input   rd_value,
    input   error
  );

  modport slave (
    input   valid,
    input   funct3,
    input   csr,
    input   rs1,
    input   rs1_value,
    output  ready,
    output  rd_value,
    output  error
  );
endinterface
