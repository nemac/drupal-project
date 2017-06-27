#!/usr/bin/env bash

#tables="batch,block_content,block_content__body,block_content_field_data,block_content_field_revision,block_content_revision,block_content_revision__body,cache_bootstrap,cache_config,cache_container,cache_data,cache_default,cache_discovery,cache_entity,cachetags,comment,comment__comment_body,comment_entity_statistics,comment_field_data,config,file_managed,file_usage,history,key_value,key_value_expire,menu_link_content,menu_link_content_data,menu_tree,node,node__body,node__comment,node__field_image,node__field_tags,node_access,node_field_data,node_field_revision,node_revision,node_revision__body,node_revision__comment,node_revision__field_image,node_revision__field_tags,queue,router,search_dataset,search_index,search_total,semaphore,sequences,sessions,shortcut,shortcut_field_data,shortcut_set_users,taxonomy_index,taxonomy_term_data,taxonomy_term_field_data,taxonomy_term_hierarchy,url_alias,user__roles,user__user_picture,users,users_data,users_field_data,watchdog"
#tables=(${tables//,/ })

# Usage: dumpTable "table-name"
dumpTable(){
mysqldump --order-by-primary=TRUE --opt --skip-comments --protocol=tcp --compress=TRUE --default-character-set=utf8 --host=${DB_HOST} --user=${DB_USER} --skip-extended-insert --dump-date=FALSE --replace=TRUE --port=${DB_PORT} --password=${DB_PASSWORD} --skip-triggers --quick "${DB_DATABASE}" "$1"
}

echo "Attempted to clean: $1"
dumpTable ${1:0:-4}

#for t in "${!tables[@]}"; do
#    dumpTable "${tables[t]}"
#done
