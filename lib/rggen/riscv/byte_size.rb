# frozen_string_literal: true

RgGen.modify_simple_feature(:register_block, :byte_size) do
  register_map do
    property :byte_size, default: -> { 4096 * configuration.bus_width / 8 }
  end
end
