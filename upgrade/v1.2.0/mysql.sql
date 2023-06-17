drop table if exists replica_metrics;
alter table deployment_version add column env_id bigint default 0 comment '环境编号' after version_name;

create table metrics_0 (
	id bigint primary key auto_increment not null comment '主键id',
	replica_name varchar (64) default null comment '副本名称',
	metrics_type tinyint default 0 comment '指标类型',
	metrics_value bigint default 0 comment '指标值',
	creation_time datetime default current_timestamp comment '创建时间',
	update_time datetime default current_timestamp on update current_timestamp comment '修改时间',
	deletion_status tinyint default 0 comment '删除状态，0：未删除，1：已删除'
)comment '副本指标';
create index index_metrics_0 on metrics_0(update_time, replica_name);

create table metrics_1 (
	id bigint primary key auto_increment not null comment '主键id',
	replica_name varchar (64) default null comment '副本名称',
	metrics_type tinyint default 0 comment '指标类型',
	metrics_value bigint default 0 comment '指标值',
	creation_time datetime default current_timestamp comment '创建时间',
	update_time datetime default current_timestamp on update current_timestamp comment '修改时间',
	deletion_status tinyint default 0 comment '删除状态，0：未删除，1：已删除'
)comment '副本指标';
create index index_metrics_1 on metrics_1(update_time, replica_name);

create table metrics_2 (
	id bigint primary key auto_increment not null comment '主键id',
	replica_name varchar (64) default null comment '副本名称',
	metrics_type tinyint default 0 comment '指标类型',
	metrics_value bigint default 0 comment '指标值',
	creation_time datetime default current_timestamp comment '创建时间',
	update_time datetime default current_timestamp on update current_timestamp comment '修改时间',
	deletion_status tinyint default 0 comment '删除状态，0：未删除，1：已删除'
)comment '副本指标';
create index index_metrics_2 on metrics_2(update_time, replica_name);

create table metrics_3 (
	id bigint primary key auto_increment not null comment '主键id',
	replica_name varchar (64) default null comment '副本名称',
	metrics_type tinyint default 0 comment '指标类型',
	metrics_value bigint default 0 comment '指标值',
	creation_time datetime default current_timestamp comment '创建时间',
	update_time datetime default current_timestamp on update current_timestamp comment '修改时间',
	deletion_status tinyint default 0 comment '删除状态，0：未删除，1：已删除'
)comment '副本指标';
create index index_metrics_3 on metrics_3(update_time, replica_name);

create table metrics_4 (
	id bigint primary key auto_increment not null comment '主键id',
	replica_name varchar (64) default null comment '副本名称',
	metrics_type tinyint default 0 comment '指标类型',
	metrics_value bigint default 0 comment '指标值',
	creation_time datetime default current_timestamp comment '创建时间',
	update_time datetime default current_timestamp on update current_timestamp comment '修改时间',
	deletion_status tinyint default 0 comment '删除状态，0：未删除，1：已删除'
)comment '副本指标';
create index index_metrics_4 on metrics_4(update_time, replica_name);

create table metrics_5 (
	id bigint primary key auto_increment not null comment '主键id',
	replica_name varchar (64) default null comment '副本名称',
	metrics_type tinyint default 0 comment '指标类型',
	metrics_value bigint default 0 comment '指标值',
	creation_time datetime default current_timestamp comment '创建时间',
	update_time datetime default current_timestamp on update current_timestamp comment '修改时间',
	deletion_status tinyint default 0 comment '删除状态，0：未删除，1：已删除'
)comment '副本指标';
create index index_metrics_5 on metrics_5(update_time, replica_name);

create table metrics_6 (
	id bigint primary key auto_increment not null comment '主键id',
	replica_name varchar (64) default null comment '副本名称',
	metrics_type tinyint default 0 comment '指标类型',
	metrics_value bigint default 0 comment '指标值',
	creation_time datetime default current_timestamp comment '创建时间',
	update_time datetime default current_timestamp on update current_timestamp comment '修改时间',
	deletion_status tinyint default 0 comment '删除状态，0：未删除，1：已删除'
)comment '副本指标';
create index index_metrics_6 on metrics_6(update_time, replica_name);

create table metrics_7 (
	id bigint primary key auto_increment not null comment '主键id',
	replica_name varchar (64) default null comment '副本名称',
	metrics_type tinyint default 0 comment '指标类型',
	metrics_value bigint default 0 comment '指标值',
	creation_time datetime default current_timestamp comment '创建时间',
	update_time datetime default current_timestamp on update current_timestamp comment '修改时间',
	deletion_status tinyint default 0 comment '删除状态，0：未删除，1：已删除'
)comment '副本指标';
create index index_metrics_7 on metrics_7(update_time, replica_name);

create table metrics_8 (
	id bigint primary key auto_increment not null comment '主键id',
	replica_name varchar (64) default null comment '副本名称',
	metrics_type tinyint default 0 comment '指标类型',
	metrics_value bigint default 0 comment '指标值',
	creation_time datetime default current_timestamp comment '创建时间',
	update_time datetime default current_timestamp on update current_timestamp comment '修改时间',
	deletion_status tinyint default 0 comment '删除状态，0：未删除，1：已删除'
)comment '副本指标';
create index index_metrics_8 on metrics_8(update_time, replica_name);

create table metrics_9 (
	id bigint primary key auto_increment not null comment '主键id',
	replica_name varchar (64) default null comment '副本名称',
	metrics_type tinyint default 0 comment '指标类型',
	metrics_value bigint default 0 comment '指标值',
	creation_time datetime default current_timestamp comment '创建时间',
	update_time datetime default current_timestamp on update current_timestamp comment '修改时间',
	deletion_status tinyint default 0 comment '删除状态，0：未删除，1：已删除'
)comment '副本指标';
create index index_metrics_9 on metrics_9(update_time, replica_name);

create table metrics_10 (
	id bigint primary key auto_increment not null comment '主键id',
	replica_name varchar (64) default null comment '副本名称',
	metrics_type tinyint default 0 comment '指标类型',
	metrics_value bigint default 0 comment '指标值',
	creation_time datetime default current_timestamp comment '创建时间',
	update_time datetime default current_timestamp on update current_timestamp comment '修改时间',
	deletion_status tinyint default 0 comment '删除状态，0：未删除，1：已删除'
)comment '副本指标';
create index index_metrics_10 on metrics_10(update_time, replica_name);

create table metrics_11 (
	id bigint primary key auto_increment not null comment '主键id',
	replica_name varchar (64) default null comment '副本名称',
	metrics_type tinyint default 0 comment '指标类型',
	metrics_value bigint default 0 comment '指标值',
	creation_time datetime default current_timestamp comment '创建时间',
	update_time datetime default current_timestamp on update current_timestamp comment '修改时间',
	deletion_status tinyint default 0 comment '删除状态，0：未删除，1：已删除'
)comment '副本指标';
create index index_metrics_11 on metrics_11(update_time, replica_name);

create table metrics_12 (
	id bigint primary key auto_increment not null comment '主键id',
	replica_name varchar (64) default null comment '副本名称',
	metrics_type tinyint default 0 comment '指标类型',
	metrics_value bigint default 0 comment '指标值',
	creation_time datetime default current_timestamp comment '创建时间',
	update_time datetime default current_timestamp on update current_timestamp comment '修改时间',
	deletion_status tinyint default 0 comment '删除状态，0：未删除，1：已删除'
)comment '副本指标';
create index index_metrics_12 on metrics_12(update_time, replica_name);

create table metrics_13 (
	id bigint primary key auto_increment not null comment '主键id',
	replica_name varchar (64) default null comment '副本名称',
	metrics_type tinyint default 0 comment '指标类型',
	metrics_value bigint default 0 comment '指标值',
	creation_time datetime default current_timestamp comment '创建时间',
	update_time datetime default current_timestamp on update current_timestamp comment '修改时间',
	deletion_status tinyint default 0 comment '删除状态，0：未删除，1：已删除'
)comment '副本指标';
create index index_metrics_13 on metrics_13(update_time, replica_name);

create table metrics_14 (
	id bigint primary key auto_increment not null comment '主键id',
	replica_name varchar (64) default null comment '副本名称',
	metrics_type tinyint default 0 comment '指标类型',
	metrics_value bigint default 0 comment '指标值',
	creation_time datetime default current_timestamp comment '创建时间',
	update_time datetime default current_timestamp on update current_timestamp comment '修改时间',
	deletion_status tinyint default 0 comment '删除状态，0：未删除，1：已删除'
)comment '副本指标';
create index index_metrics_14 on metrics_14(update_time, replica_name);

create table metrics_15 (
	id bigint primary key auto_increment not null comment '主键id',
	replica_name varchar (64) default null comment '副本名称',
	metrics_type tinyint default 0 comment '指标类型',
	metrics_value bigint default 0 comment '指标值',
	creation_time datetime default current_timestamp comment '创建时间',
	update_time datetime default current_timestamp on update current_timestamp comment '修改时间',
	deletion_status tinyint default 0 comment '删除状态，0：未删除，1：已删除'
)comment '副本指标';
create index index_metrics_15 on metrics_15(update_time, replica_name);

create table metrics_16 (
	id bigint primary key auto_increment not null comment '主键id',
	replica_name varchar (64) default null comment '副本名称',
	metrics_type tinyint default 0 comment '指标类型',
	metrics_value bigint default 0 comment '指标值',
	creation_time datetime default current_timestamp comment '创建时间',
	update_time datetime default current_timestamp on update current_timestamp comment '修改时间',
	deletion_status tinyint default 0 comment '删除状态，0：未删除，1：已删除'
)comment '副本指标';
create index index_metrics_16 on metrics_16(update_time, replica_name);

create table metrics_17 (
	id bigint primary key auto_increment not null comment '主键id',
	replica_name varchar (64) default null comment '副本名称',
	metrics_type tinyint default 0 comment '指标类型',
	metrics_value bigint default 0 comment '指标值',
	creation_time datetime default current_timestamp comment '创建时间',
	update_time datetime default current_timestamp on update current_timestamp comment '修改时间',
	deletion_status tinyint default 0 comment '删除状态，0：未删除，1：已删除'
)comment '副本指标';
create index index_metrics_17 on metrics_17(update_time, replica_name);

create table metrics_18 (
	id bigint primary key auto_increment not null comment '主键id',
	replica_name varchar (64) default null comment '副本名称',
	metrics_type tinyint default 0 comment '指标类型',
	metrics_value bigint default 0 comment '指标值',
	creation_time datetime default current_timestamp comment '创建时间',
	update_time datetime default current_timestamp on update current_timestamp comment '修改时间',
	deletion_status tinyint default 0 comment '删除状态，0：未删除，1：已删除'
)comment '副本指标';
create index index_metrics_18 on metrics_18(update_time, replica_name);

create table metrics_19 (
	id bigint primary key auto_increment not null comment '主键id',
	replica_name varchar (64) default null comment '副本名称',
	metrics_type tinyint default 0 comment '指标类型',
	metrics_value bigint default 0 comment '指标值',
	creation_time datetime default current_timestamp comment '创建时间',
	update_time datetime default current_timestamp on update current_timestamp comment '修改时间',
	deletion_status tinyint default 0 comment '删除状态，0：未删除，1：已删除'
)comment '副本指标';
create index index_metrics_19 on metrics_19(update_time, replica_name);

create table metrics_20 (
	id bigint primary key auto_increment not null comment '主键id',
	replica_name varchar (64) default null comment '副本名称',
	metrics_type tinyint default 0 comment '指标类型',
	metrics_value bigint default 0 comment '指标值',
	creation_time datetime default current_timestamp comment '创建时间',
	update_time datetime default current_timestamp on update current_timestamp comment '修改时间',
	deletion_status tinyint default 0 comment '删除状态，0：未删除，1：已删除'
)comment '副本指标';
create index index_metrics_20 on metrics_20(update_time, replica_name);

create table metrics_21 (
	id bigint primary key auto_increment not null comment '主键id',
	replica_name varchar (64) default null comment '副本名称',
	metrics_type tinyint default 0 comment '指标类型',
	metrics_value bigint default 0 comment '指标值',
	creation_time datetime default current_timestamp comment '创建时间',
	update_time datetime default current_timestamp on update current_timestamp comment '修改时间',
	deletion_status tinyint default 0 comment '删除状态，0：未删除，1：已删除'
)comment '副本指标';
create index index_metrics_21 on metrics_21(update_time, replica_name);

create table metrics_22 (
	id bigint primary key auto_increment not null comment '主键id',
	replica_name varchar (64) default null comment '副本名称',
	metrics_type tinyint default 0 comment '指标类型',
	metrics_value bigint default 0 comment '指标值',
	creation_time datetime default current_timestamp comment '创建时间',
	update_time datetime default current_timestamp on update current_timestamp comment '修改时间',
	deletion_status tinyint default 0 comment '删除状态，0：未删除，1：已删除'
)comment '副本指标';
create index index_metrics_22 on metrics_22(update_time, replica_name);

create table metrics_23 (
	id bigint primary key auto_increment not null comment '主键id',
	replica_name varchar (64) default null comment '副本名称',
	metrics_type tinyint default 0 comment '指标类型',
	metrics_value bigint default 0 comment '指标值',
	creation_time datetime default current_timestamp comment '创建时间',
	update_time datetime default current_timestamp on update current_timestamp comment '修改时间',
	deletion_status tinyint default 0 comment '删除状态，0：未删除，1：已删除'
)comment '副本指标';
create index index_metrics_23 on metrics_23(update_time, replica_name);

create table metrics_24 (
	id bigint primary key auto_increment not null comment '主键id',
	replica_name varchar (64) default null comment '副本名称',
	metrics_type tinyint default 0 comment '指标类型',
	metrics_value bigint default 0 comment '指标值',
	creation_time datetime default current_timestamp comment '创建时间',
	update_time datetime default current_timestamp on update current_timestamp comment '修改时间',
	deletion_status tinyint default 0 comment '删除状态，0：未删除，1：已删除'
)comment '副本指标';
create index index_metrics_24 on metrics_24(update_time, replica_name);

create table metrics_25 (
	id bigint primary key auto_increment not null comment '主键id',
	replica_name varchar (64) default null comment '副本名称',
	metrics_type tinyint default 0 comment '指标类型',
	metrics_value bigint default 0 comment '指标值',
	creation_time datetime default current_timestamp comment '创建时间',
	update_time datetime default current_timestamp on update current_timestamp comment '修改时间',
	deletion_status tinyint default 0 comment '删除状态，0：未删除，1：已删除'
)comment '副本指标';
create index index_metrics_25 on metrics_25(update_time, replica_name);

create table metrics_26 (
	id bigint primary key auto_increment not null comment '主键id',
	replica_name varchar (64) default null comment '副本名称',
	metrics_type tinyint default 0 comment '指标类型',
	metrics_value bigint default 0 comment '指标值',
	creation_time datetime default current_timestamp comment '创建时间',
	update_time datetime default current_timestamp on update current_timestamp comment '修改时间',
	deletion_status tinyint default 0 comment '删除状态，0：未删除，1：已删除'
)comment '副本指标';
create index index_metrics_26 on metrics_26(update_time, replica_name);

create table metrics_27 (
	id bigint primary key auto_increment not null comment '主键id',
	replica_name varchar (64) default null comment '副本名称',
	metrics_type tinyint default 0 comment '指标类型',
	metrics_value bigint default 0 comment '指标值',
	creation_time datetime default current_timestamp comment '创建时间',
	update_time datetime default current_timestamp on update current_timestamp comment '修改时间',
	deletion_status tinyint default 0 comment '删除状态，0：未删除，1：已删除'
)comment '副本指标';
create index index_metrics_27 on metrics_27(update_time, replica_name);

create table metrics_28 (
	id bigint primary key auto_increment not null comment '主键id',
	replica_name varchar (64) default null comment '副本名称',
	metrics_type tinyint default 0 comment '指标类型',
	metrics_value bigint default 0 comment '指标值',
	creation_time datetime default current_timestamp comment '创建时间',
	update_time datetime default current_timestamp on update current_timestamp comment '修改时间',
	deletion_status tinyint default 0 comment '删除状态，0：未删除，1：已删除'
)comment '副本指标';
create index index_metrics_28 on metrics_28(update_time, replica_name);

create table metrics_29 (
	id bigint primary key auto_increment not null comment '主键id',
	replica_name varchar (64) default null comment '副本名称',
	metrics_type tinyint default 0 comment '指标类型',
	metrics_value bigint default 0 comment '指标值',
	creation_time datetime default current_timestamp comment '创建时间',
	update_time datetime default current_timestamp on update current_timestamp comment '修改时间',
	deletion_status tinyint default 0 comment '删除状态，0：未删除，1：已删除'
)comment '副本指标';
create index index_metrics_29 on metrics_29(update_time, replica_name);

create table metrics_30 (
	id bigint primary key auto_increment not null comment '主键id',
	replica_name varchar (64) default null comment '副本名称',
	metrics_type tinyint default 0 comment '指标类型',
	metrics_value bigint default 0 comment '指标值',
	creation_time datetime default current_timestamp comment '创建时间',
	update_time datetime default current_timestamp on update current_timestamp comment '修改时间',
	deletion_status tinyint default 0 comment '删除状态，0：未删除，1：已删除'
)comment '副本指标';
create index index_metrics_30 on metrics_30(update_time, replica_name);

create table metrics_31 (
	id bigint primary key auto_increment not null comment '主键id',
	replica_name varchar (64) default null comment '副本名称',
	metrics_type tinyint default 0 comment '指标类型',
	metrics_value bigint default 0 comment '指标值',
	creation_time datetime default current_timestamp comment '创建时间',
	update_time datetime default current_timestamp on update current_timestamp comment '修改时间',
	deletion_status tinyint default 0 comment '删除状态，0：未删除，1：已删除'
)comment '副本指标';
create index index_metrics_31 on metrics_31(update_time, replica_name);