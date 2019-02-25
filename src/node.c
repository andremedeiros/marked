#include <stdlib.h>

#include "node.h"

marked_node *marked_node_new() {
	marked_node *node = malloc(sizeof(marked_node));

	node->type = UNKNOWN;
	node->offset = 0;

	return node;
}

void marked_node_free(marked_node *node) {
	free(node);
}

