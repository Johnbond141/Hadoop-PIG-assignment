/* loading in the data */
ordersCSV = LOAD '/user/maria_dev/diplomacy/orders.csv' USING PigStorage(',') AS
    (game_id:chararray,
    unit_id:chararray,
    unit_order:chararray,
    location:chararray,
    target:chararray,
    target_dest:chararray,
    success:chararray,
    reason:chararray,
    turn_num:chararray);

/* Only select the column that are neccessary, in this case the location and target */
selected = FOREACH ordersCSV GENERATE location, target;
// Filter the target column on Holland */
filterlist = FILTER selected BY target MATCHES '.*Holland.*';

/* Group on the location and target */
groupbylist = GROUP filterlist by (location, target);
// Add the count column
countlist = FOREACH groupbylist GENERATE FLATTEN(group) as (location, target), COUNT($1);

/* Order the list alphabetically based on the location column */
orderedlist = ORDER countlist BY location;
    
DUMP orderedlist;
