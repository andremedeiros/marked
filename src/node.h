#pragma once

#include <stdlib.h>
#include <string.h>

enum marked_node_type {
  UNKNOWN,
  DOCUMENT,
  HEADER1,
  HEADER2,
  HEADER3,
  HEADER4,
  HEADER5,
  HEADER6
};

typedef struct marked_node {
  char *content;
  enum marked_node_type type;

  int length;
  int offset;

  struct marked_node *child;
  struct marked_node *next;
} marked_node;

marked_node *marked_node_new(char *buffer);
char *marked_node_content(marked_node *node);
void marked_node_free(marked_node *node);
