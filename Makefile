current_branch = "3.1.5-postgresql-metastore"
build:
	docker build -t lingoxp/hive:$(current_branch) ./
push:
	docker push lingoxp/hive:$(current_branch)