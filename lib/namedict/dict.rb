class Dict
  attr_accessor :chars

  def initialize(file_dict, file_ps)
    if File.exist?(file_ps) && ( count(file_ps) == 9933 )
      @chars = retrieve(file_ps)
      # to_json(file_dict, file_json)
    else
      @chars = parse(file_dict)
      store(file_ps, @chars)
    end
  end

  def parse(file_dict)
    regex_cols = /^(\d+)\s+(.+?)\s+(\d+)\s+([0-9\.]+)\s+(.+?)\s+(.*?)$/
    tmp_pc ||= BigDecimal.new('0')

    list = File.open(file_dict, 'r:utf-8').inject([]) do |chars, line|
      # ( md = regex_cols.match(line) ) ? chars << {sn: md[1].to_i, ch: md[2], fq: md[3].to_i, pc: md[4].to_f, py: md[5], en: md[6]} : chars
      if ( md = regex_cols.match(line) )
        chars << Char.new(
          # sn: md[1].to_i,
          ch: md[2],
          # fq: md[3].to_i,
          pc: BigDecimal.new(md[4]) - tmp_pc, # md[4].to_f - tmp_pc,
          py: md[5].split("/"),
          tr: md[6].chomp
        )
        tmp_pc = BigDecimal.new(md[4])
      end
      chars
    end
  end

  def store(file_ps, chars)
    dict = PStore.new(file_ps)
    chars.each_index do |i|
      dict.transaction do
        dict[i+1] = chars[i]
      end
    end
  end

  def retrieve(file_ps)
    dict = PStore.new(file_ps)
    chars = []
    dict.transaction do
      dict.roots.each do |i|
        chars << dict[i]
      end
    end
    return chars
  end

  def count(file_ps)
    dict = PStore.new(file_ps)
    dict.transaction do
      return dict.roots.size
    end
  end

=begin
  def to_json(file_dict, file_json)
    regex_cols = /^(\d+)\s+(.+?)\s+(\d+)\s+([0-9\.]+)\s+(.+?)\s+(.*?)$/
    tmp_pc ||= BigDecimal.new('0')

    list = File.open(file_dict, 'r:utf-8').inject([]) do |chars, line|
      # ( md = regex_cols.match(line) ) ? chars << {sn: md[1].to_i, ch: md[2], fq: md[3].to_i, pc: md[4].to_f, py: md[5], en: md[6]} : chars
      if ( md = regex_cols.match(line) )
        chars << {
          # sn: md[1].to_i,
          ch: md[2],
          # fq: md[3].to_i,
          pc: format("%.10f", (BigDecimal.new(md[4]) - tmp_pc).to_f), # md[4].to_f - tmp_pc,
          py: md[5].split("/"),
          tr: md[6].chomp
        }
        tmp_pc = BigDecimal.new(md[4])
      end
      chars
    end

    File.open(file_json, "w+") do |f|
      f.puts( JSON.pretty_generate(list) )
    end
  end
=end

  private :parse, :store, :retrieve, :count
end