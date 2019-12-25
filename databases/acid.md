# ACID

- atomicity: if one part of a transaction fails, the entire transaction will fail
- consistency: data can only be added to the database when it is consistent with the database's rules (e.g. FKs, CHECK CONSTRAINTs)
- isolation: ability to concurrently process multiple transactions in a way that one does not affect another. e.g. if I buy 5 items on amazon, there will be N - 5 remaining for someone who tries to buy directly after me.
- durability: able to handle issues that would normally result in data loss
