# A 'hopefully better' gettc. 

Originally gettc doesn't support out-of-tree build. Few problems have been 
observed. First of all, all output files were in the same folder as the problem, 
which made output files cleanup tedious, especially when you have quite a big 
bunch of files. Because runner.sh had multiple copies across problems, it is very 
difficult to change it or to fix a bug for it. And there was no common file sharing 
between problems, except the fancy hidden folder ‘.gettc’ which somehow made the 
ability to run out-of-the-box so difficult, or, say, obscure. 

Therefore the following changes have been made:
- Now we have a “common” folder to shares files, so runner.sh, common Makefile 
  and include files have a better place to sit on.
- Fixed dependency issue in Makefile. The C++ Makefile wasn't handling dependency
  correctly, so files were complied every time we run make. And all Makefiles are 
  generalised so minimised the specialisation for each problem. 
- Can run out-of-the-box. Just copy everything you can see from the output folder, 
  you're ready to go. Nothing is hiding anymore. 

NOTE: These are all private change and done only for my convenience and BAD personal taste. I'll keep 
refining it. Even some languages support is very likely to be removed in the near 
future. And, of course, NO intention to back-port to origin. 

----------
Download a [TopCoder](http://topcoder.com/tc) problem, parse the examples and
system tests, then finally generate a naive solution for the following languages:

- C++
- Haskell
- Java
- Python 3
- Go

And support for more languages is just around the corner. 
    
> You can email me to request support for your favourite language. I will
> prioritize development on the most requested ones.

You write the function definition and the generated solution will take care of
running it against the downloaded input and output files.

TopCoder is a heaven for programmers. Solving algorithmic problems is a great
way to embrace the passion for programming. There are problems for all levels. 
A strong academic background is not required to enjoy it. If you like Project
Euler, you will probably love TopCoder. 

However, the TopCoder online arena is quite inconvenient and supports only a 
few languages. Gettc's goal is to make the practice of solving algorithmic
problems convenient and fun, and in your desired language.

# At a glance

    $ [sudo] gem install gettc
    $ gettc 11127

Note that 11127 is the ID that TopCoder gives to the problem named `DigitHoles`. You
can find the ID for any problem if you look at the URL for 
[that problem's statement](http://community.topcoder.com/stat?c=problem_statement&pm=11127) 
(you need to have a TopCoder account). Output:

    You have given ID = 11127
    Downloading problem to raw HTML ... Done
    Parsing problem from raw HTML ... Done
    Generating problem diectory for DigitHoles ... Done

Now:

    $ cd DigitHoles/solve/cpp
    $ make demo

Output:

    Check 0 ... 0m0.328s
    Failed
        Input: <42>
        Expected: <1>
        Received: <0>
    Check 1 ... 0m0.015s
    Failed
        Input: <669>
        Expected: <3>
        Received: <0>
    Check 2 ... 0m0.016s
    Failed
        Input: <688>
        Expected: <5>
        Received: <0>
    Check 3 ... 0m0.015s
    Passed
    Check 4 ... 0m0.016s
    Failed
        Input: <456>
        Expected: <2>
        Received: <0>
    Check 5 ... 0m0.016s
    Failed
        Input: <789>
        Expected: <3>
        Received: <0>
    6 cases checked, 5 failed, 0 errored
    Failed cases: 0 1 2 4 5

As you can see, the generated solution actually managed to solve 1 test case. 
Gettc is pretty smart after all. Anyway, you still need to do the hard work.
Open the file `DigitHoles.cpp` in your favourite editor and enter the following
content:

    int numHoles(int number) {
        static int holes[] = {1, 0, 0, 0, 1, 0, 1, 0, 2, 1};
        int ret = 0;
        while (number > 0) {
            ret += holes[number % 10];
            number /= 10;
        }
        return ret;
    }

And then try again:

    $ make demo

You should see:

    Check 0 ... 0m0.141s
    Passed
    Check 1 ... 0m0.015s
    Passed
    Check 2 ... 0m0.016s
    Passed
    Check 3 ... 0m0.015s
    Passed
    Check 4 ... 0m0.016s
    Passed
    Check 5 ... 0m0.015s
    Passed
    6 cases checked, 0 failed, 0 errored

Good. We have passed all the example tests. Why not challenge the system tests
while we are it?

    $ make sys

Output:

    131 cases checked, 0 failed, 0 errored

Congratulations! You have solved a TopCoder problem like a boss!

# Installation

Gettc works on most operating systems, including Linux, Windows, and Mac OS.

The following packages are hard dependencies:

- [Ruby](http://www.ruby-lang.org/en/downloads/): The
[Ruby installer](http://rubyinstaller.org/) is recommend for Windows users. 
- [RubyGems](http://rubygems.org/pages/download): Many Ruby installations
already bundle RubyGems.
- The standard GCC toolset: Specifically, you should be able to run g++ and make
from the command line. Windows users may use [MinGW](http://www.mingw.org) or
Cygwin.

> If you have problems installing on Windows, this may help:
> https://www.quora.com/How-do-I-install-gettc-for-downloading-TopCoder-problems/answer/Rajneesh-Chauhan

With those in place, we are aready to go:

    $ [sudo] gem install gettc

Once that is done, you should be able to run gettc on the command line. The
standard procedure is:

    $ gettc problem_id
    $ cd ProblemName/solve/your_language
    $ make

Now there are a couple things you need to get depending on your desired language.
- For C++: You are already ready to solve problems [using C++](https://github.com/seri/gettc/blob/master/plugins/cpp/README.md).
- For Haskell: [Come here](https://github.com/seri/gettc/blob/master/plugins/haskell/README.md)
- For Java: [Come here](https://github.com/seri/gettc/blob/master/plugins/java/README.md)
- For Python: [Come here](https://github.com/seri/gettc/blob/master/plugins/python/README.md)
- For Go: [Come here](https://github.com/seri/gettc/blob/master/plugins/go/README.md)
# Tips

- ~~Provide your own username/password in `~/.gettc/config.yml` if download fails.~~
- Use `make sysv` to display failed cases when challenging the system tests.
- You may `rm -rf build` after you're done solving to save some disk space.
- ~~You can play with the contents of the directory `~/.gettc` to, say, remove things
you don't want to be generated. If you mess up, you can safely delete the
whole directory `~/.gettc`. The next time gettc runs, it will notice that 
there is no `~/.gettc` and regenerate that.~~
- You can bring the solutions generated by gettc to another computer to run.
Such system doesn't need to have gettc, or even ruby, but it will need the 
standard gcc toolchain, and of course the compiler for your desired language
(if it isn't C++). ~~You will also need to copy `~/.gettc` to that system.~~

> This document is for new users. Existing users can find details about updating by
> reading the [change log](https://github.com/seri/gettc/blob/master/CHANGELOG.md).
