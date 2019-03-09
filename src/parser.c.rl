#include "parser.h"

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-const-variable"
%%{
  machine marked;
  write data;
}%%
#pragma GCC diagnostic pop

%%{
  action mark { mark = (p - parser->buffer); }

  action atx_header_end     { node->child = marked_parser_stack_pop(parser); }
  action atx_header_start   {
    marked_node *header = marked_node_new(parser->buffer);
    header->offset = mark;
    marked_parser_stack_push(parser, header);
  }
  action atx_header_content {
    marked_node *header = marked_parser_stack_current(parser);
    header->length = (mark - header->offset);
  }
  action atx_header_prefix  {
    marked_node *header = marked_parser_stack_current(parser);
    switch(mark - header->offset) {
      case 1: header->type = HEADER1; break;
      case 2: header->type = HEADER2; break;
      case 3: header->type = HEADER3; break;
      case 4: header->type = HEADER4; break;
      case 5: header->type = HEADER5; break;
      case 6: header->type = HEADER6; break;
    }
  }

  action AtxHeaderContent {}
  action AtxHeaderEnd {
    node->length = (p - buffer) - node->offset;
    printf("node->length = %d\n", node->length);
    printf("node->content = %s\n", marked_node_content(node));
  }

  Newline = '\n';
  AtxHeader = '#'{1,6} >mark %atx_header_start space >mark %atx_header_prefix any+ >mark %atx_header_content (('#'+ Newline) | Newline) Newline >atx_header_end;
  SetexHeader = (any+ - Newline) Newline ('#' | '-')+ Newline Newline;

  Document := AtxHeader | SetexHeader | any;
}%%

marked_parser *marked_parser_new(char *buffer) {
  marked_parser *parser = malloc(sizeof(marked_parser));

  parser->buffer = buffer;
  parser->length = strlen(buffer);
  parser->stack = NULL;

  return parser;
}

void marked_parser_free(marked_parser *parser) {
  for(marked_parser_stack_element *el = parser->stack; el != NULL; el = el->next) {
    free(el);
  }

  free(parser);
}

marked_node *marked_parser_parse(marked_parser *parser) {
  int cs, res __attribute__((unused))= 0;
  int mark = 0;
  char *p = parser->buffer;
  char *eof __attribute__((unused));
  char *pe = p + parser->length + 1;

  marked_node *node = marked_node_new(p);
  node->type = DOCUMENT;
  node->length = (pe - p);

  %%write init;
  %%write exec;

  return node;
}

void marked_parser_stack_push(marked_parser *parser, marked_node *node) {
  marked_parser_stack_element *stack = malloc(sizeof(marked_parser_stack_element));

  stack->node = node;
  stack->previous = NULL;
  stack->next = NULL;

  if(parser->stack != NULL) {
    parser->stack->next = stack;
    stack->previous = parser->stack;
  }
  parser->stack = stack;
}

marked_node *marked_parser_stack_pop(marked_parser *parser) {
  assert(parser->stack);

  marked_parser_stack_element *stack = parser->stack;
  parser->stack = stack->previous;

  marked_node *node = stack->node;
  free(stack);

  return node;
}

marked_node *marked_parser_stack_current(marked_parser *parser) {
  assert(parser->stack);
  return parser->stack->node;
}
