locals {
  create_prod_vpc   = var.create_prod_vpc
  create_dev_vpc    = var.create_dev_vpc
  dev_access_key    = var.dev_access_key
  dev_secret_key    = var.dev_secret_key
  dev_session_token = var.dev_session_token
  dev_region        = var.dev_region
  prod_region       = var.prod_region
}
provider "aws" {
  alias  = "prod"
  region = local.prod_region
}

provider "aws" {
  alias  = "dev"
  region = var.dev_region

  access_key = try(local.dev_access_key, null)
  secret_key = try(local.dev_secret_key, null)
  token      = try(local.dev_session_token, null)
}

# aurora 5.7 parameter
resource "aws_db_parameteprod_group" "dev-aurora-param-mysql57" {
  count    = local.create_dev_vpc ? 1 : 0
  provider = aws.dev
  name     = "dev-${var.game_code}-aurora-mysql57"
  family   = "aurora-mysql5.7"

  parameter {
    name         = "log_throttle_queries_not_using_indexes"
    value        = 0
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "query_cache_type"
    value        = 0
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "query_cache_size"
    value        = 0
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "query_cache_wlock_invalidate"
    value        = 0
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "long_query_time"
    value        = 0.5
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "performance_schema"
    value        = 1
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "innodb_print_all_deadlocks"
    value        = 1
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "innodb_status_output"
    value        = 1
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "innodb_status_output_locks"
    value        = 1
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "autocommit"
    value        = 1
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "slow_query_log"
    value        = 1
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "log_queries_not_using_indexes"
    value        = 1
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "innodb_large_prefix"
    value        = 1
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "log_bin_trust_function_creators"
    value        = 1
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "innodb_adaptive_flushing"
    value        = 1
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "innodb_adaptive_hash_index"
    value        = 1
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "innodb_adaptive_hash_index_parts"
    value        = 8
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "innodb_lock_wait_timeout"
    value        = 10
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "connect_timeout"
    value        = 10
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "innodb_max_dirty_pages_pct"
    value        = 75
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "edev_range_index_dive_limit"
    value        = 200
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "query_cache_min_res_unit"
    value        = 4096
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "wait_timeout"
    value        = 28800
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "innodb_adaptive_max_sleep_delay"
    value        = 150000
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "max_connect_errors"
    value        = 999999
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "query_cache_limit"
    value        = 1048576
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "max_allowed_packet"
    value        = 268435456
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "innodb_monitoprod_enable"
    value        = "all"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "innodb_file_format"
    value        = "Barracuda"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "log_output"
    value        = "FILE"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "default_tmp_storage_engine"
    value        = "InnoDB"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "event_scheduler"
    value        = "ON"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "tx_isolation"
    value        = "REPEATABLE-READ"
    apply_method = "pending-reboot"
  }
  lifecycle {
    ignore_changes = [parameter]
  }
}

# aurora 5.7 cluster parameter
resource "aws_rds_clusteprod_parameteprod_group" "dev-aurora-param-cluster-mysql57" {
  count    = local.create_dev_vpc ? 1 : 0
  provider = aws.dev
  name     = "dev-${var.game_code}-aurora-param-cluster-mysql57"
  family   = "aurora-mysql5.7"

  parameter {
    name         = "innodb_flush_log_at_trx_commit"
    value        = 0
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "log_throttle_queries_not_using_indexes"
    value        = 0
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "serveprod_audit_logging"
    value        = 0
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "query_cache_type"
    value        = 0
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "query_cache_size"
    value        = 0
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "query_cache_wlock_invalidate"
    value        = 0
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "long_query_time"
    value        = 0.5
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "performance_schema"
    value        = 1
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "innodb_print_all_deadlocks"
    value        = 1
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "innodb_status_output"
    value        = 1
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "innodb_status_output_locks"
    value        = 1
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "innodb_file_peprod_table"
    value        = 1
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "autocommit"
    value        = 1
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "slow_query_log"
    value        = 1
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "log_queries_not_using_indexes"
    value        = 1
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "innodb_large_prefix"
    value        = 1
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "log_bin_trust_function_creators"
    value        = 1
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "innodb_adaptive_flushing"
    value        = 1
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "innodb_adaptive_hash_index"
    value        = 1
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "innodb_spin_wait_delay"
    value        = 6
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "innodb_adaptive_hash_index_parts"
    value        = 8
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "innodb_lock_wait_timeout"
    value        = 10
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "connect_timeout"
    value        = 10
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "innodb_sync_spin_loops"
    value        = 30
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "innodb_max_dirty_pages_pct"
    value        = 75
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "edev_range_index_dive_limit"
    value        = 200
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "query_cache_min_res_unit"
    value        = 4096
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "wait_timeout"
    value        = 28800
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "innodb_adaptive_max_sleep_delay"
    value        = 150000
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "max_connect_errors"
    value        = 999999
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "query_cache_limit"
    value        = 1048576
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "max_allowed_packet"
    value        = 268435456
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "innodb_monitoprod_enable"
    value        = "all"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "innodb_file_format"
    value        = "Barracuda"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "serveprod_audit_events"
    value        = "CONNECT, QUERY, TABLE"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "log_output"
    value        = "FILE"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "default_tmp_storage_engine"
    value        = "InnoDB"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "binlog_format"
    value        = "MIXED"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "event_scheduler"
    value        = "ON"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "tx_isolation"
    value        = "REPEATABLE-READ"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "time_zone"
    value        = "UTC"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "characteprod_set_client"
    value        = "utf8mb4"
    apply_method = "immediate"
  }

  parameter {
    name         = "characteprod_set_connection"
    value        = "utf8mb4"
    apply_method = "immediate"
  }

  parameter {
    name         = "characteprod_set_database"
    value        = "utf8mb4"
    apply_method = "immediate"
  }

  parameter {
    name         = "characteprod_set_filesystem"
    value        = "utf8mb4"
    apply_method = "immediate"
  }

  parameter {
    name         = "characteprod_set_results"
    value        = "utf8mb4"
    apply_method = "immediate"
  }

  parameter {
    name         = "characteprod_set_server"
    value        = "utf8mb4"
    apply_method = "immediate"
  }

  parameter {
    name         = "collation_connection"
    value        = "utf8mb4_unicode_ci"
    apply_method = "immediate"
  }

  parameter {
    name         = "collation_server"
    value        = "utf8mb4_unicode_ci"
    apply_method = "immediate"
  }
  lifecycle {
    ignore_changes = [parameter]
  }
}


# aurora 5.7 parameter
resource "aws_db_parameteprod_group" "aurora-param-mysql57" {
  count    = local.create_prod_vpc ? 1 : 0
  provider = aws.prod
  name     = "r-${var.game_code}-aurora-mysql57"
  family   = "aurora-mysql5.7"

  parameter {
    name         = "log_throttle_queries_not_using_indexes"
    value        = 0
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "query_cache_type"
    value        = 0
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "query_cache_size"
    value        = 0
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "query_cache_wlock_invalidate"
    value        = 0
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "long_query_time"
    value        = 0.5
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "performance_schema"
    value        = 1
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "innodb_print_all_deadlocks"
    value        = 1
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "innodb_status_output"
    value        = 1
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "innodb_status_output_locks"
    value        = 1
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "autocommit"
    value        = 1
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "slow_query_log"
    value        = 1
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "log_queries_not_using_indexes"
    value        = 1
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "innodb_large_prefix"
    value        = 1
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "log_bin_trust_function_creators"
    value        = 1
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "innodb_adaptive_flushing"
    value        = 1
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "innodb_adaptive_hash_index"
    value        = 1
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "innodb_adaptive_hash_index_parts"
    value        = 8
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "innodb_lock_wait_timeout"
    value        = 10
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "connect_timeout"
    value        = 10
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "innodb_max_dirty_pages_pct"
    value        = 75
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "edev_range_index_dive_limit"
    value        = 200
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "query_cache_min_res_unit"
    value        = 4096
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "wait_timeout"
    value        = 28800
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "innodb_adaptive_max_sleep_delay"
    value        = 150000
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "max_connect_errors"
    value        = 999999
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "query_cache_limit"
    value        = 1048576
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "max_allowed_packet"
    value        = 268435456
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "innodb_monitoprod_enable"
    value        = "all"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "innodb_file_format"
    value        = "Barracuda"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "log_output"
    value        = "FILE"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "default_tmp_storage_engine"
    value        = "InnoDB"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "event_scheduler"
    value        = "ON"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "tx_isolation"
    value        = "REPEATABLE-READ"
    apply_method = "pending-reboot"
  }
  lifecycle {
    ignore_changes = [parameter]
  }
}

# aurora 5.7 cluster parameter
resource "aws_rds_clusteprod_parameteprod_group" "aurora-param-cluster-mysql57" {
  count    = local.create_prod_vpc ? 1 : 0
  provider = aws.prod
  name     = "r-${var.game_code}-aurora-param-cluster-mysql57"
  family   = "aurora-mysql5.7"

  parameter {
    name         = "innodb_flush_log_at_trx_commit"
    value        = 0
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "log_throttle_queries_not_using_indexes"
    value        = 0
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "serveprod_audit_logging"
    value        = 0
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "query_cache_type"
    value        = 0
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "query_cache_size"
    value        = 0
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "query_cache_wlock_invalidate"
    value        = 0
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "long_query_time"
    value        = 0.5
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "performance_schema"
    value        = 1
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "innodb_print_all_deadlocks"
    value        = 1
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "innodb_status_output"
    value        = 1
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "innodb_status_output_locks"
    value        = 1
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "innodb_file_peprod_table"
    value        = 1
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "autocommit"
    value        = 1
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "slow_query_log"
    value        = 1
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "log_queries_not_using_indexes"
    value        = 1
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "innodb_large_prefix"
    value        = 1
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "log_bin_trust_function_creators"
    value        = 1
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "innodb_adaptive_flushing"
    value        = 1
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "innodb_adaptive_hash_index"
    value        = 1
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "innodb_spin_wait_delay"
    value        = 6
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "innodb_adaptive_hash_index_parts"
    value        = 8
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "innodb_lock_wait_timeout"
    value        = 10
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "connect_timeout"
    value        = 10
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "innodb_sync_spin_loops"
    value        = 30
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "innodb_max_dirty_pages_pct"
    value        = 75
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "edev_range_index_dive_limit"
    value        = 200
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "query_cache_min_res_unit"
    value        = 4096
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "wait_timeout"
    value        = 28800
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "innodb_adaptive_max_sleep_delay"
    value        = 150000
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "max_connect_errors"
    value        = 999999
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "query_cache_limit"
    value        = 1048576
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "max_allowed_packet"
    value        = 268435456
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "innodb_monitoprod_enable"
    value        = "all"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "innodb_file_format"
    value        = "Barracuda"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "serveprod_audit_events"
    value        = "CONNECT, QUERY, TABLE"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "log_output"
    value        = "FILE"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "default_tmp_storage_engine"
    value        = "InnoDB"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "binlog_format"
    value        = "MIXED"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "event_scheduler"
    value        = "ON"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "tx_isolation"
    value        = "REPEATABLE-READ"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "time_zone"
    value        = "UTC"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "characteprod_set_client"
    value        = "utf8mb4"
    apply_method = "immediate"
  }

  parameter {
    name         = "characteprod_set_connection"
    value        = "utf8mb4"
    apply_method = "immediate"
  }

  parameter {
    name         = "characteprod_set_database"
    value        = "utf8mb4"
    apply_method = "immediate"
  }

  parameter {
    name         = "characteprod_set_filesystem"
    value        = "utf8mb4"
    apply_method = "immediate"
  }

  parameter {
    name         = "characteprod_set_results"
    value        = "utf8mb4"
    apply_method = "immediate"
  }

  parameter {
    name         = "characteprod_set_server"
    value        = "utf8mb4"
    apply_method = "immediate"
  }

  parameter {
    name         = "collation_connection"
    value        = "utf8mb4_unicode_ci"
    apply_method = "immediate"
  }

  parameter {
    name         = "collation_server"
    value        = "utf8mb4_unicode_ci"
    apply_method = "immediate"
  }
  lifecycle {
    ignore_changes = [parameter]
  }
}
