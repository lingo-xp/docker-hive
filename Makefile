current_branch1 = "3.1.7-postgresql-metastore"
hive:
	docker build -t lingoxp/hive:$(current_branch1) ./hive




current_branch2 = "2.0.4-hadoop3.3.5-java8"
hadoop:
	docker build -t lingoxp/hadoop-base:$(current_branch2) ./base
	docker build -t lingoxp/hadoop-namenode:$(current_branch2) ./namenode
	docker build -t lingoxp/hadoop-datanode:$(current_branch2) ./datanode
	docker build -t lingoxp/hadoop-resourcemanager:$(current_branch2) ./resourcemanager
	docker build -t lingoxp/hadoop-nodemanager:$(current_branch2) ./nodemanager
	docker build -t lingoxp/hadoop-historyserver:$(current_branch2) ./historyserver
	docker build -t lingoxp/hadoop-submit:$(current_branch2) ./submit

