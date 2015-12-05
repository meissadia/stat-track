# Wrapper : ActiveRecord
module WAR
  # Create dictionary from array
  # @param field_names [Array] Symbols of fields
  # @param source [Array] Source data
  #
  def from_array(field_names=[], source=[])
    fl = {}                # Resulting Field List
    idx = 0                # Source cursor

    # Create and store k:v field_name:source
    field_names.each do |f|
      fl[f] = source[idx]
      idx += 1
    end
    return fl
  end

  # Create dictionary from 2d array
  # @param field_names [Array] Symbols of fields
  # @param source [[Array]] Source data
  #
  def from_array2d (field_names=[], source=[[]])
    fl_a = []
    # Process each row of Source table
    source.each do |s|
      fl_a << from_array(field_names, s)
    end
    return fl_a
  end
end
