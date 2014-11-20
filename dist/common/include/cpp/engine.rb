require "gettc/types"

module Gettc
    class Type
        def to_cpp
            if self == TInt then
                return "int"
            elsif self == TLong then
                return "int64"        
            elsif self == TFloat then
                return "float"
            elsif self == TDouble then
                return "double"
            elsif self == TChar then
                return "char"
            elsif self == TString then
                return "string"
            elsif self == TBoolean then
                return "bool"
            elsif is_a? TArray then
                ret = "vector<" << subtype.to_cpp
                ret << " " if subtype.is_a? TArray
                ret << ">"
                return ret
            else
                return "unknown"
            end 
        end
        def dumb_cpp
            if self == TInt then
                return "0"
            elsif self == TLong then
                return "0"        
            elsif self == TFloat then
                return "0"
            elsif self == TDouble then
                return "0"
            elsif self == TChar then
                return "\"$\""
            elsif self == TString then
                return "\"$\""
            elsif self == TBoolean then
                return "true"
            elsif is_a? TArray then
                return "#{to_cpp}()"
            else
                return "Nil"
            end
        end
    end
    class Signature
        def to_cpp declaring = false
            ret = type.to_cpp
            ret << " "
            ret << "const &" if declaring and type.obj?
            ret << name 
            return ret
        end
    end
    class CppEngine
        attr_reader :declare, :input, :output
        def initialize func, vars
            @func = func
            @vars = vars            
            compute_declare
            compute_input
            compute_output
        end
    private
        def compute_declare
            @declare = @func.to_cpp
            @declare << "("
                indent = " " * @declare.size
                temp = @vars.map do |var| 
                    var.to_cpp true 
                end
                @declare << temp.join(",\n#{indent}")
            @declare << ")"
        end
        def compute_input
            temp = @vars.map do |var|
                x = var.to_cpp
                x << "; tc::read(ifs, "
                x << var.name
                x << ");"
            end
            @input = temp.join " tc::next(ifs);\n"
        end
        def compute_output
            @output = "tc::show(ofs, solver." << @func.name << "("
            temp = @vars.map do |var| 
                var.name 
            end
            @output << temp.join(", ") << "));"
        end
    end
end
