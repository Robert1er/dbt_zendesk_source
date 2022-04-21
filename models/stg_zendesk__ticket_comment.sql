
with base as (

    select * 
    from {{ ref('stg_zendesk__ticket_comment_tmp') }}

),

fields as (

    select
        /*
        The below macro is used to generate the correct SQL for package staging models. It takes a list of columns 
        that are expected/needed (staging_columns from dbt_zendesk_source/models/tmp/) and compares it with columns 
        in the source (source_columns from dbt_zendesk_source/macros/).
        For more information refer to our dbt_fivetran_utils documentation (https://github.com/fivetran/dbt_fivetran_utils.git).
        */
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_zendesk__ticket_comment_tmp')),
                staging_columns=get_ticket_comment_columns()
            )
        }}
        
    from base
),

final as (
    
    select 
        id as ticket_comment_id,
        _fivetran_synced,
        body,
        {% if target.type == 'redshift' -%}
            cast(created as timestamp without time zone) as created_at,
        {% else -%}
            created as created_at,
        {% endif %}
        public as is_public,
        ticket_id,
        user_id,
        facebook_comment as is_facebook_comment,
        tweet as is_tweet,
        voice_comment as is_voice_comment
    from fields
)

select * 
from final