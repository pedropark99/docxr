#include <stdio.h>
#include <stdlib.h>
#include <string.h>

size_t char_size (char* c) {
   return strlen(c);
};

int check_for_operator (char c) {
    return (c == '`' || c == '*' || c == '_');
};

struct stack {
    char operand;
    char text[100];
};

void print_stack (struct stack st) {
    printf("Operand: %c", st.operand);
    printf("  |  Text: %s\n", st.text);
};

int count_operators (char* c, size_t n) {
    int count = 0;
    for (int i = 0; i < n; i++) {
        if(check_for_operator(c[i])){
            count++;
        }
    }
    return count;
}

void depth_indexes (char* c, int* indexes, size_t n) {
    int limit = 0;    
    char current_char;
    int to_subtract;
    char tokens[20];
    tokens[0] = 'n';
    for (int i = 0; i < n; i++) {
        current_char = c[i];
        if (to_subtract == 1) {
            --limit;
        }

        if (check_for_operator(current_char)) {
            if (current_char != tokens[limit - 1]) {
                ++limit;
                indexes[i] = limit;
                tokens[limit - 1] = current_char;
                continue;
            } else {
                to_subtract = 1;
                indexes[i] = limit;
                continue;
            }
        }

        indexes[i] = limit;
        to_subtract = 0;
    }
}


int main() {
    char teste[] = "Um *teste*, mais `outro`, Mais _um_ a";
    size_t n = char_size(teste);
    int stack_n = count_operators(teste, n) / 2;
    struct stack arr_stack[stack_n];
    char cchar, ctoken = '0';
    int to_include = 0, stack_id = 0, char_count = 0;
    //printf("char| token | inclu | count \n", cchar);
    for (int i = 0; i < n; i++) {
        cchar = teste[i];
        //printf("%c   |", cchar);
        //printf("   %c   |", ctoken);
        //printf("   %d   |", to_include);
        //printf("   %d\n\n", char_count);
        if (check_for_operator(cchar)) {
            if (cchar == ctoken) {
                ctoken = '0';
                to_include = 0;
                char_count = 0;
                stack_id++;
                continue;
            } else {
                arr_stack[stack_id].operand = cchar;
                ctoken = cchar;
                to_include = 1;
                continue;
            }
        }

        if (to_include == 1) {
            arr_stack[stack_id].text[char_count] = cchar;
            //printf("%d", char_count);
            char_count++;
        }
    }

    for (int i = 0; i < stack_n; i++) {
        print_stack(arr_stack[i]);
    }

    //printf("%s", arr_stack[0].text);

};
