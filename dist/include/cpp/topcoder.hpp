#ifndef GETTC_TOPCODER_H 
#define GETTC_TOPCODER_H

#include <algorithm>
#include <exception>
#include <string>
#include <vector>
#include <iostream>
#include <sstream>
#include <cmath>
#include <cctype>

typedef unsigned int uint;
typedef long long int64;
typedef unsigned long long uint64;
    
namespace TopCoder {
    const int _CHUNK_SIZE = 65536;

    class ParseException: public std::exception {
    private:
        std::string message;
        void buildMessage(std::string const &required, char actual, 
                          std::string const &rest) { 
            std::ostringstream oss;
            oss << required << " at: <" << rest << ">";
            oss << " (got '" << actual << "')";
            message = oss.str();
        }

    public:
        ParseException() : message("ParseException occurred") {}
        ParseException(std::string const &message) : message(message) {}
        ~ParseException() throw () {}

        virtual const char* what() const throw() { 
            return message.c_str(); 
        }

        ParseException(std::string const &required, char actual, 
                       std::string const &rest) { 
            buildMessage(required, actual, rest);
        }

        ParseException(char expected, char actual, 
                       std::string const &rest) { 
            std::ostringstream oss;
            oss << "Expect '" << expected << "'";
            buildMessage(oss.str(), actual, rest);
        }

        ParseException(std::string const &required, std::string const &rest) {
            std::ostringstream oss;
            oss << required << " at: <" << rest << ">";
            message = oss.str();
        }

        ParseException(char expected) {
            std::ostringstream oss;
            oss << "Expect '" << expected << " before end of stream";
            message = oss.str();
        }
    };

    std::string _rest(std::istream &is) {
        std::ostringstream oss;
        char chunk[_CHUNK_SIZE];
        while (is.good()) {
            is.get(chunk, _CHUNK_SIZE);
            oss << chunk;
        } 
        return oss.str();
    }

    void _spaces(std::istream &is) {
        while (is.good()) {
            int i = is.peek();
            if (isspace(i)) is.ignore(1);
            else break;
        } 
    } 

    void _expect(std::istream &is, char expected) {
        _spaces(is); char actual = is.peek();
        if (expected != actual) 
            throw ParseException(expected, actual, _rest(is));
        is.ignore(1);
    }

    void next(std::istream &is) {
        _expect(is, ',');
    } 

    void read(std::istream &is, int &i) { 
        is >> i; 
    }

    void read(std::istream &is, int64 &l) { 
        is >> l; 
    }

    void read(std::istream &is, float &f) { 
        is >> f; 
    }

    void read(std::istream &is, double &d) { 
        is >> d; 
    }

    void read(std::istream &is, char &c) {
        _expect(is, '\'');
        is.get(c);
        if (c == '\'') {
            c = 0;
        } else {
            _expect(is, '\'');
        }
    }

    void read(std::istream &is, std::string &s) {
        _expect(is, '"');
        std::ostringstream oss;    
        while (is.good()) {
            char c; is.get(c);
            if (c == '"') {
                std::streampos pos = is.tellg();
                _spaces(is);
                if (is.eof()) {
                    s = oss.str();
                    return;
                }
                char cc; is.get(cc);
                if (cc == ',' || cc == ']') {
                    s = oss.str();
                    is.unget();
                    return;
                }
                is.seekg(pos);
            }
            oss << c;
        }
        throw ParseException('"');
    }

    void read(std::istream &is, bool &b) { 
        _spaces(is);
        std::ostringstream oss;
        while (is.good()) {
            int i = is.peek();
            if (!isalpha(i)) {
                break;
            }
            oss.put(i);
            is.ignore(1);
        } 
        std::string s = oss.str();
        std::transform(s.begin(), s.end(), s.begin(), ::tolower);
        if (s == "true")  {
            b = true;
        } else if (s == "false") {
            b = false;
        } else {
            throw ParseException("Expect a boolean value (true or false)", _rest(is));
        }
    }

    template <typename T>
    void read(std::istream &is, std::vector<T> &v) {
        v.clear();
        _expect(is, '['); 
        _spaces(is);
        int i = is.peek(); 
        if (i == ']') {
            is.ignore(1);
            return;
        }
        while (is.good()) { 
            T e; read(is, e); v.push_back(e);
            _spaces(is); char c; is.get(c);
            if (c == ']') {
                return;
            }
            if (c != ',') {
                throw ParseException("Expect ',' or ']'", c, _rest(is));
            }
        } 
        throw ParseException(']');
    } 

    void show(std::ostream &os, int i) { 
        os << i; 
    }

    void show(std::ostream &os, int64 l) { 
        os << l; 
    }

    void show(std::ostream &os, float f) {
        os.precision(8);
        os << f; 
    }

    void show(std::ostream &os, double d) {
        os.precision(16);
        os << d; 
    }

    void show(std::ostream &os, char c) {
        os << '\'' << c << '\'';
    }

    void show(std::ostream &os, std::string const &s) {
        os << '"' << s << '"';
    }

    void show(std::ostream &os, bool b) {
        os << (b ? "true" : "false");
    }

    template <typename T>
    void show(std::ostream &os, std::vector<T> const &v) {
        typedef typename std::vector<T>::const_iterator Iterator;
        bool first = true;
        os << '[';
        for (Iterator it = v.begin(); it != v.end(); ++it) {            
            if (!first) {
                os << ',';
            }
            show(os, *it);
            first = false;
        }
        os << ']';
    }

    bool same(int i, int j) { 
        return i == j; 
    }

    bool same(int64 i, int64 j) { 
        return i == j; 
    }

    bool same(char i, char j) { 
        return i == j; 
    }

    bool same(std::string const &x, std::string const &y) { 
        return x == y; 
    }

    bool same(float x, float y) {
        float p = x * (1.0 - 1e-5);
        float q = x * (1.0 + 1e-5);
        return y >= std::min(p, q) && y <= std::max(p, q);
    }

    bool same(double x, double y) {
        double p = x * (1.0 - 1e-9);
        double q = x * (1.0 + 1e-9);
        return y >= std::min(p, q) && y <= std::max(p, q);
    } 

    template <typename T>
    bool same(std::vector<T> const &v1, std::vector<T> const &v2) {
        typedef typename std::vector<T>::const_iterator Iterator;
        Iterator i1 = v1.begin(),
                 i2 = v2.begin();
        while (true) {
            if (i1 == v1.end()) return i2 == v2.end();
            if (i2 == v2.end()) return false;
            if (!same(*i1++, *i2++)) return false;
        }
    }
}

#endif /* GETTC_TOPCODER_H */ 
