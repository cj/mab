module Mab
  module Indentation
    class Context < Array
      def initialize
        @indentation = 0
      end

      def with_indent
        @indentation += 1
        yield
      ensure
        @indentation -= 1
      end

      def <<(str)
        if empty?
          super("  " * @indentation)
        else
          super($/ + "  " * @indentation)
        end
        super
      end
    end

    def mab_options
      @mab_options ||= super.update(:context => Context)
    end

    def mab_block(tag, &blk)
      super do
        @mab_context.with_indent(&blk)
      end
    end

    def reindent!(str)
      str.split(/\r?\n/).each do |s|
        text! s
      end
    end
  end
end

