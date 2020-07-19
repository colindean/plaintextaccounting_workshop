## Example C program for use with @lst:example_makefile {#sec:example_c}

This very small program exists to ensure the validity of @lst:example_makefile
but it also serves as a cool way to see `make` in action in its original
intended use environment.

Listing: A simple "hello world" program in C, `hello.c` {#lst:helloworld_c}

```{.c pipe="tee hello.c"}
#include <stdio.h>

int main(void)
{
    printf("hello, world\n");
}
```

Listing: Compiling @lst:helloworld_c with @lst:example_makefile `make all` and then invoking it {#lst:helloworld_c_compile}

```{.bash pipe="sh"}
echo "$ make all"
make -f Makefile.helloworld
echo "$ ./hello"
./hello
```
