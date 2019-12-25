# Glossary

cap theorem: a distributed database system can only have 2 of the 3: consistency, availability, and partition tolerance

partition tolerance: a system is partition tolerant when it can sustain any amount of network failure that doesn't result in a failure of the entire network. data records are replicated across combinations of nodes to keep the system up through intermittent outages. this is a necessity. hence, we trade between consistency and availability.

consistency: a read from any node results in the same output. nodes need time to replicate data to other nodes, so here we are trading availability.

availability: not feasible when analyzing streaming data at high frequency, as nodes need time to replicate.

eventual consistency: if no additional updates are performed on a data item, eventually all accesses to that item will return the last updated value. used to obtain high availability

two-phase commit and consensus protocols: all sites in a distributed system agree to commit a transactin. the protocol results in either all nodes committing the transaction or aborting, even in hte case of site failures and message losses.
