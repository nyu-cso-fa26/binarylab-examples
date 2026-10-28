#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>

/* Modern C headers no longer declare the unsafe gets() function, so we
 * declare it ourselves just so this demo compiles.  Never use gets(). */
char *gets(char *s);

/*
 * get_input() reads a line into an 8-byte buffer and checks it against the
 * password.  gets() does NO bounds checking, so a line longer than 8 bytes
 * overflows buf and keeps writing up the stack, over get_input()'s saved
 * return address.  By writing the right bytes there, an attacker makes
 * get_input() "return" into any code they choose -- for example straight
 * into give_out_lots_of_money(), without ever knowing the password.
 */
bool
get_input()
{
    char buf[8];
    gets(buf);
    return strcmp(buf, "supersecret") == 0;
}

/*
 * force_align_arg_pointer: when the overflow redirects control here, the
 * stack is not 16-byte aligned the way a normal call would leave it, so we
 * ask the compiler to re-align it on entry; otherwise the printf() below
 * crashes.  (Not part of the vulnerability -- just makes the demo robust.)
 */
__attribute__((force_align_arg_pointer))
void
give_out_lots_of_money()
{
    printf("Congratulations! You have earned lots of $$$\n");
    exit(0);
}

int
main()
{
    if (get_input()) {
        give_out_lots_of_money();
    } else {
        printf("sorry dude, you don't have the right password\n");
    }
    return 0;
}
