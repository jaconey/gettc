#include <topcoder.hpp>
using namespace TopCoder; 
#include <fstream>
using namespace std;
<% 
    engine = CppEngine.new func, vars
%>
int main(int argc, char *argv[]) { 
    try { 
        <%= func.type.to_cpp %> output, result;
        ifstream ifs;
        
        ifs.open(argv[1]);
        read(ifs, output);
        ifs.close(); 

        ifs.open(argv[2]); 
        read(ifs, result);
        ifs.close();

        return same(output, result) ? 0 : 1;
    } catch (exception &e) {
        cerr << e.what() << endl;       
    }
    return 2;
}
