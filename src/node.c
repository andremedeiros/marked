#include <stdlib.h>

#include "node.h"

marked_node *marked_node_new(char *content) {
  marked_node *node = malloc(sizeof(marked_node));

  node->content = content;
  node->type = UNKNOWN;

  node->length = 0;
  node->offset = 0;

  node->child = NULL;
  node->next = NULL;

  return node;
}

char *marked_node_content(marked_node *node) {
  char *content = malloc(sizeof(char *) * node->length + 1);
  memcpy(content, node->content, node->length);
  content[node->length + 1] = '\0';

  return content;
}

void marked_node_free(marked_node *node) {
  free(node);
}


