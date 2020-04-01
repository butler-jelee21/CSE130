#include "stdio.h"

void help();

int main(int argc, char *argv[]) {
  if (argc < 2) {
    help();
  } else {
    printf("%s\n", "Hello World");
  }
  return 0;
}

void help() {
  char *description[20] = {
    "Usage: cat [OPTION]... [FILE]...\n", 
    "Concatenate FILE(s) to standard output.\n\n",
    "With no FILE, or when FILE is -, read standard input.\n",
    "\n\t-A, --show-all\t\t equivalent to -vET\n",
    "\t-b, --number-nonblank\t number nonempty output lines, overrides -n\n",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    ""
  };
  for (int i = 0; i < 20; ++i) {
    printf("%s\n", description[i]);
  }
}