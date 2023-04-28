current_branch = "3.1.4-postgresql-metastore"
build:
	docker build -t lingoxp/hive:$(current_branch) ./
push:
	docker push lingoxp/hive:$(current_branch)
