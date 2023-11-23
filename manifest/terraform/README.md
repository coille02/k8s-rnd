# terraform-rnd

# terraform v1.5.5 설치 권고

terraform을 설치할 때  v1.5.5 이하 버전으로 꼭!!! 설치 하세요. 
최신 버전으로 설치하면 terragrunt를 못써요



# terraform 명령어
```shell
# state index 변경 필요할때
# bash
terraform state mv 'module.redis["prod-rnd-kr-redis-user"].aws_elasticache_replication_group.this[0]' 'module.redis["user-redis"].aws_elasticache_replication_group.this[0]'

# windows  
terraform state mv 'module.redis[\"prod-rnd-kr-redis-world\"].aws_elasticache_replication_group.this[0]' 'module.redis[\"world-redis\"].aws_elasticache_replication_group.this[0]'



# state 리스트를 확인하고 싶을때
terraform state list

# state를 확인하고 싶을때
# bash
terraform state show 'module.redis["user-redis"].aws_elasticache_replication_group.this[0]'

# windows
terraform state show 'module.redis[\"world-redis\"].aws_elasticache_replication_group.this[0]' 


# terraform import 를 하고 싶을 때
# bash
terraform import 'module.redis["test"].aws_elasticache_replication_group.this[0]' 'AWS 자원'

# windows
terraform import 'module.redis[\"test\"].aws_elasticache_replication_group.this[0]' 'AWS 자원'

```

