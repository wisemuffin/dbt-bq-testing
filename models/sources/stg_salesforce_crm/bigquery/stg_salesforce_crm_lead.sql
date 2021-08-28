{{config(enabled = target.type == 'bigquery')}}
{% if var("crm_warehouse_contact_sources") %}
{% if 'salesforce_crm' in var("crm_warehouse_contact_sources")  %}

with source as (

    {# select * from lead #}
    {{ filter_stitch_relation(relation=var('stg_salesforce_crm_stitch_lead_table'),unique_column='id') }}

),

renamed as (

    select

        id as lead_id,
        ownerid as owner_id,
        null as opportunity_id,
        null as account_id,
        null as contact_id,
        leadsource as lead_source,
        status,
        isconverted as is_converted,
        null as converted_date,
        firstname as first_name,
        null as middle_name,
        lastname as last_name,
        name as full_name,
        title,
        email,
        phone as work_phone,
        null as mobile_phone,
        null as can_call,
        isunreadbyowner as is_unread_by_owner,
        company as company_name,
        city as company_city,
        null as website,
        numberofemployees as number_of_employees,
        null as last_activity_date,
        createddate as created_at,
        lastmodifieddate as updated_at

    from source

)

select * from renamed

{% else %} {{config(enabled=false)}} {% endif %}
{% else %} {{config(enabled=false)}} {% endif %}
