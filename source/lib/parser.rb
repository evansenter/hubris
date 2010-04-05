class Parser
  attr_accessor :pos
  attr_reader :rules
  
  def initialize(&block)
    @lexical_tokens = []
    @rules = {}
    @start = nil
    instance_eval(&block)
  end
  
  def parse(string)
    @tokens = []
    until string.empty?
      raise "unable to lex '#{string}" unless @lexical_tokens.any? do |tok|
        match = tok.pattern.match(string)
        if match
          @tokens << tok.block.call(match.to_s) if tok.block
          string = match.post_match
          true
        else
          false
        end
      end
    end
    @pos = 0
    @max_pos = 0
    @expected = []
    result = @start.parse
    if @pos != @tokens.size
      raise "Parse error. expected: '#{@expected.join(', ')}', found 
  @tokens[@max_pos]}'"
    end
    return result
  end
  
  def next_token
    @pos += 1
    return @tokens[@pos - 1]
  end
  
  def expect(tok)
    t = next_token
    if @pos - 1 > @max_pos
      @max_pos = @pos - 1
      @expected = []
    end
    return t if tok === t
    @expected << tok if @max_pos == @pos - 1 && !@expected.include?(tok)
    return nil
  end
  
  private
  
  def token(pattern, &block)
    @lexical_tokens << LexicalToken.new(Regexp.new("^(?:#{pattern.source})", pattern.options), block)
  end
  
  def start(name, &block)
    rule(name, &block)
    @start = @rules[name]
  end
  
  def rule(name)
    @rules[name] = @current_rule = Rule.new(name, self)
    yield
    remove_instance_variable(:@current_rule)
  end
  
  def match(*pattern, &block)
    @current_rule.add_match(pattern, block)
  end
end