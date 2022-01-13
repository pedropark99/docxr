#include <stdio.h>
#include <stdlib.h>
#include <time.h>

/*size_t char_size (char* c) {
   return strlen(c);
}*/

struct stack {
    char operand;
    char text[100];
};

void print_stack (struct stack st) {
    printf("Operand: %c", st.operand);
    printf("  |  Text: %s", st.text);
}


int main() {
    float startTime = (float)clock()/CLOCKS_PER_SEC;

    float abs[100000000];
    for (int i = 0; i < 100000000; i++) {
        i * 2;
    }

    float endTime = (float)clock()/CLOCKS_PER_SEC;

    float timeElapsed = endTime - startTime;
    printf("%f", timeElapsed);
}