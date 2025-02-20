# frozen_string_literal: true

RgGen.define_list_item_feature(:register_block, :protocol, :riscv_csrbus) do
  sv_rtl do
    build do
      interface_port :csrbus_if, {
        name: 'csrbus_if',
        interface_type: 'riscv_csrbus_if', modport: 'slave'
      }
    end

    main_code :register_block, from_template: true
  end
end
