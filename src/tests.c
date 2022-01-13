#include <stdio.h>
#include <stdlib.h>

int char_size(char* c);
void loop_array(char* c);
int check_for_operator(char c);

int main() {
    char arr[] = "Um *teste* mais **teste**.";
    int n = char_size(arr);
    int limit = 0;
    int indexes[n];
    int token;
    char index_op;
    for (int i = 0; i < n; i++) {
        char current_char = arr[i];

        if (current_char == '*' || current_char == '_' || current_char == '`') {
            token = check_for_operator(current_char);
            char next_char = arr[i + 1];
            int next_token = check_for_operator(next_char);
            if (next_token == token){
                continue;
            }

            if (limit == 0) {
                ++limit;
            } else 
            if (limit == 1) {
                --limit;
            }
        }

        indexes[i] = limit;
    }

    for (int i = 0; i < n; i++) {
        printf("%d", indexes[i]);
    }
    

}

int char_size(char* c) {
    size_t len = strlen(c);
    return len;
    // O operador sizeof() parece não ser preciso para medir char arrays
    //return sizeof(c) / sizeof(c[0]);
}

int check_for_operator(char c) {
    char current_char = c;
    switch (current_char)
    {
    case '`':
        return 1;
        break;
    
    case '*':
        return 2;
        break;

    case '_':
        return 3;
        break;

    default:
        return 0;
        break;
    }
}


void loop_array(char* c){
    int n = char_size(c);
    int index = 0;
    for (int i = 0; i < n; i++) {
        
        printf("%d", index);
    }
}