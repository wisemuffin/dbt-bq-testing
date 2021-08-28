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
        null as contact_address,
        null as contact_city,
        null as contact_state,
        null as contact_country,
        null as contact_postcode_zip,
        null contact_company,
        null contact_website,
        null as contact_company_id,
        null as contact_owner_id,
        null as contact_lifecycle_stage,
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
