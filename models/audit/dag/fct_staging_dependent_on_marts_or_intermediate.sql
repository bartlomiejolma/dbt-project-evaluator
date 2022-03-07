-- cases where a staging model depends on a marts model
-- data should flow from raw -> staging -> intermediate -> marts
with direct_model_relationships as (
    select  
        *
    from {{ ref('int_all_dag_relationships') }}
    where distance = 1
    and parent_resource_type = 'model'
    and child_resource_type = 'model' --TO DO: pull out these common starter CTEs into int_ / ephemeral models
),
final as (
    select
        parent,
        parent_model_type,
        child,
        child_model_type
    from direct_model_relationships
    where child_model_type = 'staging'
    and parent_model_type in ('marts', 'intermediate')
)
select * from final