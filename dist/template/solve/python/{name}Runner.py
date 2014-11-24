<%= engine = PythonEngine.new func, vars
    engine.shebang %>
import os, sys
import <%= prob.name %>

def main():
    sys.path.append("../../../common/include/python")
    import topcoder as tc
    with open(sys.argv[1], "r") as fi:
        input = fi.read()
        reader = tc.Reader(input)
<%= engine.input.gsub(/^/, ' ' * 8) %>

    result = <%= prob.name %>.<%= func.name %>(<%= engine.arglist %>)
    with open(sys.argv[2], "w") as fo:
        fo.write(tc.write(result, "<%= func.type %>"))

if __name__ == "__main__":
    main()
