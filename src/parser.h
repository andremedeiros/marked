#pragma once

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "node.h"

typedef struct marked_parser_stack_element {
  marked_node *node;
  struct marked_parser_stack_element *previous;
  struct marked_parser_stack_element *next;
} marked_parser_stack_element;

typedef struct marked_parser {
  char *buffer;
  int length;
  marked_parser_stack_element *stack;
} marked_parser;

marked_parser *marked_parser_new(char *buffer);
marked_node *marked_parser_parse(marked_parser *parser);
void marked_parser_free(marked_parser *parser);

void marked_parser_stack_push(marked_parser *parser, marked_node *node);
marked_node *marked_parser_stack_pop(marked_parser *parser);
marked_node *marked_parser_stack_current(marked_parser *parser);
