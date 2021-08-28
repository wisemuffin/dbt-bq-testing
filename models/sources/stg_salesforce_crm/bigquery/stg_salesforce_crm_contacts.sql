{{config(enabled = target.type == 'bigquery')}}
{% if var("crm_warehouse_contact_sources") %}
{% if 'salesforce_crm' in var("crm_warehouse_contact_sources")  %}

with source as (

    {# select * from contact #}
    {{ filter_stitch_relation(relation=var('stg_salesforce_crm_stitch_contact_table'),unique_column='id') }}

),

renamed as (

    select
        id as contact_id,
        {# ownerid as owner_id, #}
        {# accountid as account_id, #}
        firstname as contact_first_name,
        lastname as contact_last_name,
        coalesce(concat(firstname,' ',lastname),email) as contact_name,
        title as contact_job_title,
        email as contact_email,
        {# phone as work_phone, #}
        mobilephone as contact_phone,
        cast(null as string) as contact_address,
        cast(null as string)  as contact_city,
        cast(null as string)  as contact_state,
        cast(null as string)  as contact_country,
        cast(null as string)  as contact_postcode_zip,
        cast(null as string)  contact_company,
        cast(null as string)  contact_website,
        cast(null as int64)  as contact_company_id,
        cast(null as int64)  as contact_owner_id,
        cast(null as string)  as contact_lifecycle_stage,
        cast(null as boolean)         as contact_is_contractor,
        cast(null as boolean) as contact_is_staff,
        cast(null as int64)           as contact_weekly_capacity,
        cast(null as int64)           as contact_default_hourly_rate,
        cast(null as int64)           as contact_cost_rate,
        false                          as contact_is_active,
        createddate as contact_created_date,
        lastmodifieddate as contact_last_modified_date

    from source

)

select * from renamed

{% else %} {{config(enabled=false)}} {% endif %}
{% else %} {{config(enabled=false)}} {% endif %}
