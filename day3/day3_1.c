#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>

#define BUF_SIZE 65536

typedef struct msz {
    size_t rows;
    size_t cols;
} matrix_sizes;

matrix_sizes count_lines(FILE* file) {
    char buffer[BUF_SIZE];
    int rows = 1;
    int cols = 0;
    while (1) {
        size_t read = fread(buffer, 1, BUF_SIZE, file);
        if (ferror(file)) {
            return (matrix_sizes) {-1, -1};
        }

        int i;
        for (i = 0; i < read; ++i) {
            if (buffer[i] == '\n') {
                rows++;
            } else if (rows == 1) {
                cols++;
            }
        }

        if (feof(file)) {
            break;
        }
    }

    return (matrix_sizes) {rows, cols};
}

int load_matrix(char** matrix, FILE* file) {
    char buffer[BUF_SIZE];
    int curr_row = 0, curr_col = 0;
    while (1) {
        size_t read = fread(buffer, 1, BUF_SIZE, file);
        if (ferror(file)) {
            return -1;
        }

        int i;
        for (i = 0; i < read; ++i) {
            if (buffer[i] == '\n') {
                curr_row++;
                curr_col = 0;
            } else {
                matrix[curr_row][curr_col++] = buffer[i];
            }
        }

        if (feof(file)) {
            break;
        }
    }

    return 0;
}

void print_matrix(char** matrix, size_t n_rows, size_t n_cols) {
    int i, j;
    for (i = 0; i < n_rows; ++i) {
        for (j = 0; j < n_cols; ++j) {
            printf("%c", matrix[i][j]);
        }
        printf("\n");
    }
}

int is_special_char(char c) {
    return (!isdigit(c) && c != '.');
}

int check_adjacency(char** matrix, size_t n_rows, size_t n_cols, int i, int j) {
    if (i - 1 >= 0) {
        if (j - 1 >= 0) {
            if (is_special_char(matrix[i-1][j-1])) return 1;
        }
        if (is_special_char(matrix[i-1][j])) return 1;
        if (j + 1 < n_cols) {
            if (is_special_char(matrix[i-1][j+1])) return 1;
        }
    }
    if (j - 1 >= 0) {
        if (is_special_char(matrix[i][j-1])) return 1;
    }
    if (j + 1 < n_cols) {
        if (is_special_char(matrix[i][j+1])) return 1;
    }
    if (i + 1 < n_rows) {
        if (j - 1 >= 0) {
            if (is_special_char(matrix[i+1][j-1])) return 1;
        }
        if (is_special_char(matrix[i+1][j])) return 1;
        if (j + 1 < n_cols) {
            if (is_special_char(matrix[i+1][j+1])) return 1;
        }
    }
    return 0;
}

int scan_matrix(char** matrix, size_t n_rows, size_t n_cols) {
    int i, j;
    int count = 0;
    int has_adjacent_symbol = -1;
    for (i = 0; i < n_rows; ++i) {
        for (j = 0; j < n_cols; ++j) {
            if (isdigit(matrix[i][j])) {
                char* current_num = (char*) malloc(n_rows * sizeof(char));
                int digits = 0;
                long number;
                has_adjacent_symbol = 0;
                while (isdigit(matrix[i][j+digits])) {
                    has_adjacent_symbol = has_adjacent_symbol || check_adjacency(matrix, n_rows, n_cols, i, j+digits);
                    current_num[digits] = matrix[i][j+digits];
                    digits++;
                }
                current_num[digits] = '\0';

                number = strtol(current_num, NULL, 10);

                printf("Read number %ld ", number);

                if (has_adjacent_symbol) {
                    printf("and it will be counted\n");
                    count += number;
                } else {
                    printf("but it won't be counted\n");
                }

                free(current_num);

                j += digits - 1;
            }
        }
    }

    return count;
}

int main() {
    FILE* fp = fopen("../input.txt", "r");

    if (fp == NULL) {
        printf("Could not open file\n");
        exit(-1);
    }

    matrix_sizes m = count_lines(fp);

    printf("Matrix size: %zu %zu\n", m.rows, m.cols);

    rewind(fp);

    char** matrix = (char**) malloc(m.rows * sizeof(char*));

    int i;
    for (i = 0; i < m.rows; ++i) {
        matrix[i] = (char*) malloc(m.cols * sizeof(char));
    }

    int error = load_matrix(matrix, fp);
    if (error == -1) {
        exit(-1);
    }

    fclose(fp);

    //print_matrix(matrix, m.rows, m.cols);

    int result = scan_matrix(matrix, m.rows, m.cols);
    printf("Result is %d", result);

    for (i = 0; i < m.rows; ++i) {
        free(matrix[i]);
    }

    free(matrix);

    return 0;
}
