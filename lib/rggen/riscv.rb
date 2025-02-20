# frozen_string_literal: true

require_relative 'riscv/version'

RgGen.setup_plugin :'rggen-riscv' do |plugin|
  plugin.version RgGen::RISCV::VERSION
  plugin.files [
    'riscv/byte_size',
    'riscv/offset_address',
    'riscv/riscv_csrbus'
  ]
end
