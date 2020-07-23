## A Brief Introduction to `make` {#sec:make_intro}

`make` is a file-oriented build automation tool.
A `Makefile` describes the steps necessary to create a file in the form of
a _task_.
A task declares an output and several inputs, then defines the steps necessary
to create the output file.
While tasks are generally files, tasks can also be _phony_, in that
they don't actually create the file named in the task.
`make` figures out what files need to be created to accomplish the primary task
and executes all of the other tasks necessary to create those files.

@Lst:example_makefile shows a basic `Makefile` used to compile a C program.
Programs written in C are generally comprised of several C source code files.
Each C source file, e.g. `code.c`, is compiled into an object code file, e.g. `code.o`.
This happens for all of the files: `main.c`, `net.c`, and `cli.c` are built
into `main.o`, `net.o`, and `cli.c`.
Once all of the object code files are ready, another step essentially
_combines_ these files into an executable binary, e.g. `hello` or `hello.exe`.
Note that this is a simple explanation and more elaborate setups are possible.
If you want to try this out and have a C compiler already installed –
try `gcc -v` – then write the contents of @lst:helloworld_c to `hello.c` and
run `make` after writing the contents of @lst:example_makefile to `Makefile`.

Listing: A basic `Makefile` used to compile a program written in C (`Makefile.helloworld`) {#lst:example_makefile}

```{.makefile pipe="tee Makefile.helloworld"}
# get all of the C files in the directory
C_FILES := $(wildcard *.c)
# replace the 'c' with 'o', convention for compiled C object code
OBJECTS := $(patsubst %.c, %.o, $(C_FILES))
# the final binary file name
BINARY  := hello

# convenient way to run, and the first task defined is the executed when
# running make without a specified task
all: $(BINARY)

# to produce $(BINARY), we need all $(OBJECTS) to be built
$(BINARY): $(OBJECTS)
# $@ means "the output file"
# $^ means "all of the input files"
	$(CC) $(LDFLAGS) -o $@ $^

# to produce any file ending in '.o', we need a file that has the same
# basename but ends with '.c'. These files already exist, so make tracks
# when they've been altered and knows that it only needs to run this for
# altered files.
%.o: %.c
# $< means "just the first input file"
	$(CC) $(CFLAGS) -c -o $@ $<

# phony explicitly declares that this task will never create a file.
.PHONY: clean
clean:
	rm -rf $(BINARY) $(OBJECTS)
```

`make` is one of the older tools still in active use today.
Designed by Stuart Feldman in 1976, the three common derivatives – BSD make,
GNU make, and Microsoft nmake (@wikipedia:make).
It's important to know what version of `make` you are using because there are
subtle differences between these derivatives.
If you are using Linux, you are likely using GNU make.
If you are using macOS or a BSD, you are likely using BSD make by default, but
can install GNU make easily.
If you are using Windows, you likely have nmake available to you if you have
installed Visual Studio or you can install GNU make through scoop.
You probably installed GNU make in the process of installing the dependencies
of this workshop in @sec:dependencies.
Run `make -v` to see the version, and ensure that it's the same derivative,
but not necessarily the same _version number_ what's shown in @lst:versions.
If it's not, you'll _probably_ be OK as this author tries to write portable
Makefiles [^portability], but you've been warned.

[^portability]: Derivatives of `make` have different ways of handling tabs
  versus spaces and provide some different built-in functions.
  GNU make tends to be the most permissive and user-friendly,
  thus this author's preference for it in general.
