#include <string.h>

#include "parser.h"

%%{
  machine marked;
  write data;

  Newline = '\n';
  AtxHeader = '#'{1,6} space any+ Newline;

  Document := AtxHeader | any;
}%%

marked_node *marked_parse(char *buffer) {
  int cs, res = 0;
  char *p = buffer;
  char *pe = p + strlen(buffer) + 1;

  marked_node *node = marked_node_new();
  node->type = DOCUMENT;

  %%write init;
  %%write exec;

  return node;
}
