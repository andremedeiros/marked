#ifndef __TEST_HEADER_H
#define __TEST_HEADER_H

#include "minunit.h"

#include "node.h"
#include "parser.h"

MU_TEST(test_header_atx_no_suffix) {
	mu_check(1==1);
}

MU_TEST(test_header_atx_with_suffix) {
	mu_check(1==1);
}

MU_TEST_SUITE(test_headers) {
	MU_RUN_TEST(test_header_atx_no_suffix);
	MU_RUN_TEST(test_header_atx_with_suffix);
}

#endif // __TEST_HEADER_H
