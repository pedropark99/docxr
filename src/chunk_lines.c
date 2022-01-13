#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int identify_chunk_limits (char line, int* ids);
void open_file(char filename);


char filename[20] = "teste.md";


int main() {
    FILE *file;
    file = fopen(filename, "r");
    char buffer[500];
    int limits[500];
    int idp = &limits;

    /* A função fgets() lê uma linha do arquivo definido
    em `file`, e armazena essa linha no objeto line.
    Essa linha precisa ter 500 caracteres no máximo.
    Portanto, o objeto `buffer` é um char array comum.*/
    while (fgets(buffer, 500, file) != NULL) {
        //printf("%s", buffer);
        identify_chunk_limits(buffer, idp);
        
    }

    fclose(file);
    return 0;
}


int identify_chunk_limits (char line, int* ids) {
    size_t n = strlen(line);

};


void open_file(char filename) {
    FILE *file;
    file = fopen(filename, "r");
    char line[500];

    while (fgets(line, 500, file) != NULL) {
        printf("%s", line);
    }

    fclose(file);

}