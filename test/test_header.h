#pragma once

#include "minunit.h"

#include "node.h"
#include "parser.h"

MU_TEST(test_header_atx_no_suffix) {
  char *input = "# Title goes here\n\n";
  marked_parser *parser = marked_parser_new(input);
  marked_node *node = marked_parser_parse(parser);

  mu_assert(node->child, "document has no children");
  mu_assert(node->child->type == HEADER1, "wrong kind of node");
}

MU_TEST(test_header_atx_with_suffix) {
  char *input = "### Title also goes here ####\n\n";
  marked_parser *parser = marked_parser_new(input);
  marked_node *node = marked_parser_parse(parser);

  mu_assert(node->child, "document has no children");
  mu_assert(node->child->type == HEADER3, "wrong kind of node");
}

MU_TEST(test_header_setex) {
  char *input = "And yet another title\n=\n\n";
  marked_parser *parser = marked_parser_new(input);
  marked_node *node = marked_parser_parse(parser);

  mu_assert(node->child, "document has no children");
  mu_assert(node->child->type == HEADER1, "wrong kind of node");
}

MU_TEST_SUITE(test_headers) {
  MU_RUN_TEST(test_header_atx_no_suffix);
  MU_RUN_TEST(test_header_atx_with_suffix);
  MU_RUN_TEST(test_header_setex);
}
