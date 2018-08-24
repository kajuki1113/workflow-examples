with features_exploded as (
  select
    h.rowid
    ,extract_feature(t.fv) as feature
    ,extract_weight(t.fv) as value
  from 
    test h
    LATERAL VIEW explode(features) t as fv
)
-- DIGDAG_INSERT_LINE
select
  t.rowid
  ,sum(m.weight * t.value) as predicted_price
from
  features_exploded t
  LEFT OUTER JOIN regressor m ON (t.feature = m.feature)
group by
  t.rowid
;