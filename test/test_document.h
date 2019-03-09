#pragma once

#include "node.h"
#include "parser.h"

MU_TEST(test_parser_returns_document) {
  char *input = "Hello **world**.";
  marked_node *node = marked_parse(input);

  mu_check(node->type == DOCUMENT);
}

MU_TEST_SUITE(test_document) {
  MU_RUN_TEST(test_parser_returns_document);
}
