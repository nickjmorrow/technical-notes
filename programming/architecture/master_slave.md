# Master-Slave

- model of comm where one process has unidirectional control over one or more other devices. sometimes there's a group of devices, with a master being selected among them.
- in database replication, the master database is regarded as the authoritative source, and slave databases are synced
- the architecture initially started in database replication
- also referred to as primary vs replica (or primary vs secondar)
- read and writes only occur for the master, and reads only occur for the slaves
- slaves are used when master fails or for batch processing if hte clients don't need live data
- in modern systems, masters are used as controllers, as in the master's role is only to identify which slave should handle the request. in other systems, masters do the same work as the replica but an addtl task as controllers. in these, the masters are chose narbitrarily between one of these replica, and if the master fails, the replicas choose the new master automatically
- used for dispatching work of some sort to a collection of connected worker nodes / slaves
- slaves can be optimized for perform the specific work delegated by the master
- one copy is nice for consistency, but not so for reliability. if it goes down, you're hosed
- master slave - consistency is not difficult because each piece of data has exactly one owning master. but what if you can't see that master, then some kind of postponed work is needed.
- master master makes it really hard to ensure consistency, although they do improve reliability.
- common database replication types include: - master-slave - master-master - mysql cluster
