module IC
  module Commands
    def self.run_cmd(name, args)
      puts
      case name
      when "reset" then IC.cmd_reset
      when "vars"  then IC.cmd_vars
      when "defs"  then IC.cmd_defs
      else              bug! "Unknown command #{name}"
      end

      puts " => #{"✔".colorize.green}"
    end

    macro commands_regex_names
      "reset|vars|defs"
    end
  end

  def self.cmd_reset
    VarStack.reset
    @@cvars.clear
    @@global.clear
    @@consts.clear
    @@program = Crystal::Program.new
    @@main_visitor = nil
    @@result = IC.nop
    @@busy = false
    @@code_lines = [""]
    IC.run_file IC::PRELUDE_PATH
    IC.underscore = IC.nil
  end

  def self.cmd_vars
    VarStack.top_level_vars.each do |name, value|
      puts Highlighter.highlight(" #{name} : #{value.type} = #{value.result}")
    end
    puts unless @@consts.empty?
    @@consts.each do |name, value|
      puts Highlighter.highlight(" #{name} : #{value.type} = #{value.result}")
    end
  end

  def self.cmd_defs
    @@program.defs.try &.each_value do |defs|
      defs.each do |d|
        puts Highlighter.highlight(d.def.to_s)
        puts
      end
    end
  end
end
