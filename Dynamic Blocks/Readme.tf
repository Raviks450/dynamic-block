/*#A dynamic block lets you generate repeated nested blocks (like attached_disk, ingress, secondary_ip_range) from a list or map variable, 
#instead of hardcoding each one. The four keywords are:

dynamic "block_type" — names the nested block type to repeat
for_each — the collection to iterate over
iterator — optional alias (defaults to the block type name)
content {} — the body of each generated block; reference values via iterator.value
*/