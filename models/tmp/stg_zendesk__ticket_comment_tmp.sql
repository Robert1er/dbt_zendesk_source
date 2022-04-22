--normally we select * but 'from' column is a sql keyword which breaks the query
--for now just selecting used fields in stg_zendesk__ticket_comment.sql
select
    id,
    _fivetran_synced,
    body,
    created,
    public,
    ticket_id,
    user_id,
    facebook_comment,
    tweet,
    voice_comment

from {{ var('ticket_comment') }}
