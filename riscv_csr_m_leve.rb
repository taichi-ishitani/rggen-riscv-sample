xlen = configuration.bus_width

register_block {
  name "riscv_csr_m_level_xlen#{xlen}"

  register {
    name 'mtvec'
    offset_address 0x305

    bit_field {
      name 'mode'
      bit_assignment lsb: 0, width: 2
      type :rw
      initial_value 0
    }

    bit_field {
      name 'base'
      bit_assignment lsb: 2, width: xlen - 2
      type :rw
      initial_value 0
    }
  }
}
