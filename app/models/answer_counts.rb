require 'csv'

class AnswerCounts < Struct.new(:total_counts, :repair_counts, :remove_counts)
  def total_hash
    total_counts.reduce({}) do |hash, (property, calls)|
      hash[property.name] = {total: calls}
      hash
    end
  end

  def repair_hash
    repair_counts.reduce({}) do |hash, (property, repairs)|
      hash[property.name] = {repair: repairs}
      hash
    end
  end

  def remove_hash
    remove_counts.reduce({}) do |hash, (property, removals)|
      hash[property.name] = {remove: removals}
      hash
    end
  end

  def to_hash
    total_hash.deep_merge(repair_hash).deep_merge(remove_hash)
  end

  def to_array
    array = Array.new
    to_hash.each { |elem| array << elem }
    array.sort_by { |elem| elem[1][:total].to_i }.reverse
  end

  def to_csv
    CSV.generate do |csv|
      csv << %w[Address Total Repair Remove]
      to_array.each do |address, count_hash|
        csv << [
          address,
          count_hash[:total] || 0,
          count_hash[:repair] || 0,
          count_hash[:remove] || 0,
        ]
      end
    end
  end
end
