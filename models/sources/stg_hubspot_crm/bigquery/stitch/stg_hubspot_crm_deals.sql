{{config
  (enabled =
      (target.type == 'bigquery' and var("stg_hubspot_crm_etl") == 'stitch')
   )
}}
{% if var("marketing_warehouse_deal_sources") %}
{% if 'hubspot_crm' in var("marketing_warehouse_deal_sources") %}

with source as (
  {{ filter_stitch_relation(relation=var('stg_hubspot_crm_stitch_deals_table'),unique_column='dealid') }}

),
hubspot_deal_pipelines_source as (
  SELECT *
  FROM
  {{ ref('stg_hubspot_crm_pipelines') }}
)
,
hubspot_deal_stages as (
  select *
  from  {{ ref('stg_hubspot_crm_pipeline_stages') }}
),
hubspot_deal_owners as (
  SELECT *
  FROM {{ ref('stg_hubspot_crm_owners') }}
),
renamed as (
  SELECT
      dealid as deal_id,
      concat('hubspot-',cast(associatedcompanyids.value as string)) as company_id,
      property_dealname.value                                     as deal_name,
      case when property_dealtype.value  = 'newbusiness' then 'New Business'
           when property_dealtype.value  = 'existingbusiness' then 'Existing Client'
           else 'Existing Client' end as deal_type,
      null                                  as deal_description,
      property_createdate.value                                   as deal_created_ts,
      TIMESTAMP_MILLIS(safe_cast(null  as int64)) as delivery_schedule_ts,
      TIMESTAMP_MILLIS(safe_cast(null     as int64)) as delivery_start_date_ts,
      property_closedate.value                                    as deal_closed_ts,
      property_hs_lastmodifieddate.value                          as deal_last_modified_ts,
      property_dealstage.value                                    as deal_pipeline_stage_id,
      property_dealstage.timestamp                                as deal_pipeline_stage_ts,
      TIMESTAMP_MILLIS(safe_cast(null as int64))         as deal_end_ts,
      null                                                        as deal_sales_email_last_replied,
      null                                                        as deal_last_meeting_booked_date,
      property_hs_deal_stage_probability.value                    as deal_stage_probability_pct,
      property_pipeline.value                                     as deal_pipeline_id,
      null                                                        as hubspot_team_id,
      null                                                        as deal_owner_id,
      property_hs_created_by_user_id.value                        as created_by_user_id,
      cast (null as boolean)                                      as deal_is_deleted,
      null                                                        as deal_currency_code,
      null                                                        as deal_source,
      property_hs_analytics_source.value                          as hs_analytics_source,
      property_hs_analytics_source_data_1.value                   as hs_analytics_source_data_1,
      property_hs_analytics_source_data_2.value                   as hs_analytics_source_data_2,
      property_amount.value                                       as deal_amount,
      property_hs_projected_amount_in_home_currency.value         as projected_home_currency_amount,
      property_amount_in_home_currency.value                      as projected_local_currency_amount,
      null                                                        as deal_total_contract_amount,
      null                                                        as deal_annual_contract_amount,
      null                                                        as deal_annual_recurring_revenue_amount,
      property_hs_closed_amount.value                             as deal_closed_amount_value,
      property_hs_closed_amount_in_home_currency.value            as hs_closed_amount_in_home_currency,
      property_days_to_close.value                                as deal_days_to_close,
      null                                                        as deal_closed_lost_reason,
      null                                                        as deal_harvest_project_id,
      null                                                        as deal_number_of_sprints,
      null                                                        as deal_components,
      null                                                        as deal_pricing_model,
      null                                                        as deal_partner_referral,
    --   property_sprint_type.value                                  as deal_sprint_type,
    --   property_license_referral_harvest_project_code.value        as deal_license_referral_harvest_project_code,
    --   property_jira_project_code.value                            as deal_jira_project_code,
    --   property_assigned_consultant.value                          as deal_assigned_consultant,
    --   property_products_in_solution.value                         as deal_products_in_solution,
      property_hs_date_entered_appointmentscheduled.value         as date_entered_deal_stage_0,
      property_hs_date_exited_appointmentscheduled.value          as date_exited_deal_stage_0,
      round(cast(property_hs_time_in_appointmentscheduled.value   as int64)/3600000/24,0) as days_in_deal_stage_0,
    --   property_hs_date_entered_1164152.value                      as date_entered_deal_stage_1,
    --   property_hs_date_exited_1164152.value                       as date_exited_deal_stage_1,
    --   round(cast(property_hs_time_in_1164152.value                as int64)/3600000/24,0) as days_in_deal_stage_1,
      property_hs_date_entered_qualifiedtobuy.value               as date_entered_deal_stage_2,
      property_hs_date_exited_qualifiedtobuy.value                as date_exited_deal_stage_2,
      round(cast(property_hs_time_in_qualifiedtobuy.value         as int64)/3600000/24,0) as days_in_deal_stage_2,
    --   property_hs_date_entered_1357010.value                      as date_entered_deal_stage_3,
    --   property_hs_date_exited_1357010.value                       as date_exited_deal_stage_3,
    --   round(cast(property_hs_time_in_1357010.value                as int64)/3600000/24,0) as days_in_deal_stage_3,
      property_hs_date_entered_presentationscheduled.value        as date_entered_deal_stage_4,
      property_hs_date_exited_presentationscheduled.value         as date_exited_deal_stage_4,
      round(cast(property_hs_time_in_presentationscheduled.value  as int64)/3600000/24,0) as days_in_deal_stage_4
    --   property_hs_date_entered_1164140.value                      as date_entered_deal_stage_5,
    --   property_hs_date_exited_1164140.value                       as date_exited_deal_stage_5,
    --   round(cast(property_hs_time_in_1164140.value                as int64)/3600000/24,0) as days_in_deal_stage_5,
    --   property_hs_date_entered_553a886b_24bc_4ec4_bca3_b1b7fcd9e1c7_1321074272.value as date_entered_deal_stage_6,
    --   property_hs_date_exited_553a886b_24bc_4ec4_bca3_b1b7fcd9e1c7_1321074272.value as date_exited_deal_stage_6,
    --   round(cast(property_hs_time_in_553a886b_24bc_4ec4_bca3_b1b7fcd9e1c7_1321074272.value as int64)/3600000/24,0) as days_in_deal_stage_6,
    --   property_hs_date_entered_7c41062e_06c6_4a4a_87eb_de503061b23c_975176047.value as date_entered_deal_stage_7,
    --   property_hs_date_exited_7c41062e_06c6_4a4a_87eb_de503061b23c_975176047.value as date_exited_deal_stage_7,
    --   round(cast(property_hs_time_in_7c41062e_06c6_4a4a_87eb_de503061b23c_975176047.value as int64)/3600000/24,0) as days_in_deal_stage_7,
    --   property_hs_date_entered_1031924.value as date_entered_deal_stage_8,
    --   round(cast(property_hs_time_in_1031924.value as int64)/3600000/24,0) as days_in_deal_stage_8,
    --   property_hs_date_entered_1031923.value as date_entered_deal_stage_9,
    --   round(cast(property_hs_time_in_1031923.value as int64)/3600000/24,0) as days_in_deal_stage_9,
    --   property_hs_date_entered_closedlost.value as date_entered_deal_stage_10,
    --   round(cast(property_hs_time_in_closedlost.value as int64)/3600000/24,0) as days_in_deal_stage_10,
    --   property_hs_manual_forecast_category.value as manual_forecast_category,
    --   property_hs_forecast_probability.value as forecast_probability,
    --   property_hs_merged_object_ids.value as merged_object_ids,
    --   property_hs_predicted_amount.value as predicted_amount
      FROM
      source,
                unnest(associations.associatedcompanyids) associatedcompanyids
),
joined as (
    select
    d.*,
    -- d.days_in_deal_stage_0 +
    --   coalesce(d.days_in_deal_stage_1,0) +
    --   coalesce(d.days_in_deal_stage_2,0) +
    --   coalesce(d.days_in_deal_stage_3,0) +
    --   coalesce(d.days_in_deal_stage_4,0) +
    --   coalesce(d.days_in_deal_stage_5,0) +
    --   coalesce(d.days_in_deal_stage_6,0) +
    --   coalesce(d.days_in_deal_stage_7,0) as days_in_pipeline,
    p.pipeline_label,
    p.pipeline_display_order,
    s.pipeline_stage_label,
    s.pipeline_stage_display_order,
    s.pipeline_stage_close_probability_pct,
    s.pipeline_stage_closed_won,
    u.owner_full_name,
    u.owner_email
    from renamed d
    join hubspot_deal_stages s on d.deal_pipeline_stage_id = s.pipeline_stage_id
    join hubspot_deal_pipelines_source p on s.pipeline_id = p.pipeline_id
    left outer join hubspot_deal_owners u on safe_cast(d.deal_owner_id as int64) = u.owner_id
)

select * from joined

{% else %} {{config(enabled=false)}} {% endif %}
{% else %} {{config(enabled=false)}} {% endif %}
