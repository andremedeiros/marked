#include "minunit.h"

#include "test_document.h"
#include "test_header.h"

int main(int argc, char **argv) {
	MU_RUN_SUITE(test_document);
	MU_RUN_SUITE(test_headers);
	MU_REPORT();
	return minunit_status;
}

