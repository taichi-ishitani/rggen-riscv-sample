# frozen_string_literal: true

RgGen.modify_simple_feature(:register, :offset_address) do
  register_map do
    build do
      @offset_address = @offset_address * configuration.bus_width / 8
    end
  end
end
