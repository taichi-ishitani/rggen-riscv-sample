module rggen_riscv_csrbus_adapter
  import  rggen_rtl_pkg::*;
#(
  parameter int                     ADDRESS_WIDTH       = 8,
  parameter int                     LOCAL_ADDRESS_WIDTH = 8,
  parameter int                     BUS_WIDTH           = 32,
  parameter int                     REGISTERS           = 1,
  parameter bit                     PRE_DECODE          = 0,
  parameter bit [ADDRESS_WIDTH-1:0] BASE_ADDRESS        = '0,
  parameter int                     BYTE_SIZE           = 256,
  parameter bit                     ERROR_STATUS        = 0,
  parameter bit [BUS_WIDTH-1:0]     DEFAULT_READ_DATA   = '0,
  parameter bit                     INSERT_SLICER       = 0
)(
  input var               i_clk,
  input var               i_rst_n,
  riscv_csrbus_if.slave   csrbus_if,
  rggen_register_if.host  register_if[REGISTERS]
);
  localparam  int       ADDRESS_SHIFT = $clog2(BUS_WIDTH / 8);
  localparam  bit [2:0] CSRRW         = 3'b001;
  localparam  bit [2:0] CSRRWI        = 3'b101;
  localparam  bit [2:0] CSRRS         = 3'b010;
  localparam  bit [2:0] CSRRSI        = 3'b110;
  localparam  bit [2:0] CSRRC         = 3'b011;
  localparam  bit [2:0] CSRRCI        = 3'b111;

  rggen_bus_if #(ADDRESS_WIDTH, BUS_WIDTH, BUS_WIDTH) bus_if();

  always_comb begin
    bus_if.valid    = csrbus_if.valid;
    bus_if.address  = ADDRESS_WIDTH'({csrbus_if.csr, ADDRESS_SHIFT'(0)});

    case (csrbus_if.funct3)
      CSRRW: begin
        bus_if.write_data = csrbus_if.rs1_value;
        bus_if.strobe     = '1;
      end
      CSRRWI: begin
        bus_if.write_data = BUS_WIDTH'(csrbus_if.rs1);
        bus_if.strobe     = '1;
      end
      CSRRS: begin
        bus_if.write_data = '1;
        bus_if.strobe     = csrbus_if.rs1_value;
      end
      CSRRSI: begin
        bus_if.write_data = '1;
        bus_if.strobe     = BUS_WIDTH'(csrbus_if.rs1);
      end
      CSRRC: begin
        bus_if.write_data = '0;
        bus_if.strobe     = csrbus_if.rs1_value;
      end
      default: begin
        bus_if.write_data = '0;
        bus_if.strobe     = BUS_WIDTH'(csrbus_if.rs1);
      end
    endcase

    if ((csrbus_if.funct3 inside {CSRRW, CSRRWI}) || (csrbus_if.rs1 != '0)) begin
      bus_if.access = RGGEN_WRITE;
    end
    else begin
      bus_if.access = RGGEN_READ;
    end
  end

  always_comb begin
    csrbus_if.ready     = bus_if.valid && bus_if.ready;
    csrbus_if.rd_value  = bus_if.read_data;
    csrbus_if.error     = bus_if.status[1];
  end

  rggen_adapter_common #(
    .ADDRESS_WIDTH        (ADDRESS_WIDTH        ),
    .LOCAL_ADDRESS_WIDTH  (LOCAL_ADDRESS_WIDTH  ),
    .BUS_WIDTH            (BUS_WIDTH            ),
    .STROBE_WIDTH         (BUS_WIDTH            ),
    .REGISTERS            (REGISTERS            ),
    .PRE_DECODE           (PRE_DECODE           ),
    .BASE_ADDRESS         (BASE_ADDRESS         ),
    .BYTE_SIZE            (BYTE_SIZE            ),
    .ERROR_STATUS         (1                    ),
    .DEFAULT_READ_DATA    (DEFAULT_READ_DATA    ),
    .INSERT_SLICER        (INSERT_SLICER        )
  ) u_adapter_common (
    .i_clk        (i_clk        ),
    .i_rst_n      (i_rst_n      ),
    .bus_if       (bus_if       ),
    .register_if  (register_if  )
  );
endmodule
