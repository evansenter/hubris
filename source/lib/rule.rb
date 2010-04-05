class Rule
  def initialize(name, parser)
    @name      = name
    @parser    = parser
    @matches   = []
    @lrmatches = []
  end

  def add_match(pattern, block)
    match = Match.new(pattern, block)
    if pattern[0] == @name
      pattern.shift
      @lrmatches << match
    else
      @matches << match
    end
  end

  def parse
    match_result = try_matches(@matches)
    return nil unless match_result
    loop do
      result = try_matches(@lrmatches, match_result)
      return match_result unless result
      match_result = result
    end
  end

  private

  def try_matches(matches, pre_result = nil)
    match_result = nil
    start = @parser.pos
    matches.each do |match|
      r = pre_result ? [pre_result] : []
      match.pattern.each do |token|
        if @parser.rules[token]
          r << @parser.rules[token].parse
          unless r.last
            r = nil
            break
          end
        else
          nt = @parser.expect(token)
          if nt
            r << nt
          else
            r = nil
            break
          end
        end
      end
      if r
        if match.block
          match_result = match.block.call(*r)
        else
          match_result = r[0]
        end
        break
      else
        @parser.pos = start
      end
    end
    return match_result
  end
end