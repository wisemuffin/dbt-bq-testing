{{config(enabled = target.type == 'bigquery')}}
{% if var("crm_warehouse_contact_sources") %}
{% if 'salesforce_crm' in var("crm_warehouse_contact_sources")  %}

with source as (

    {# select * from user #}
    {{ filter_stitch_relation(relation=var('stg_salesforce_crm_stitch_user_table'),unique_column='id') }}

),

renamed as (

    select

        id as user_id,
        null as account_id,
        firstname as first_name,
        null as middle_name,
        lastname as last_name,
        name as full_name,
        username as user_name,
        null as title,
        email,
        null as work_phone,
        null as mobile_phone,
        createddate as created_at,
        lastmodifieddate as updated_at

    from source

)

select * from renamed

{% else %} {{config(enabled=false)}} {% endif %}
{% else %} {{config(enabled=false)}} {% endif %}
