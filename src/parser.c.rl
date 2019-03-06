#include <stdio.h>
#include <string.h>

#include "parser.h"

%%{
  machine marked;
  write data;


  action mark { mark = (p - buffer); }

  action atx_header_end     { node->child = header; }
  action atx_header_start   { header->offset = mark; }
  action atx_header_content { header->length = (mark - header->offset); }
  action atx_header_prefix  {
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

marked_node *marked_parse(char *buffer) {
  marked_node *header = marked_node_new(buffer);

  int cs, res __attribute__((unused))= 0;
  int mark = 0;
  char *p = buffer;
  char *eof;
  char *pe = p + strlen(buffer) + 1;

  marked_node *node = marked_node_new(p);
  node->type = DOCUMENT;
  node->length = (pe - p);

  %%write init;
  %%write exec;

  return node;
}
