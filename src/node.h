#ifndef __NODE_H
#define __NODE_H

enum marked_node_type {
	UNKNOWN,
	DOCUMENT,
	HEADING
};

typedef struct {
	enum marked_node_type type;
	int offset;
} marked_node;

marked_node *marked_node_new();
void marked_node_free(marked_node *node);

#endif // __NODE_H
