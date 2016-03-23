SELECT
    nid,
    title,
    code
FROM nodes
WHERE datatype = 'frackbox'
AND visible = '1'
AND code NOT NULL
;


UPDATE nodes
    SET code = NULL
    WHERE datatype = 'frackbox'
    AND nid != '6'
    AND nid != '8'
    AND nid != '14'
    AND nid != '15'
    AND nid != '309'
;

UPDATE nodes
    SET
        title = '​​ Frackbox 1 - Springville N',
        code = '​​Springville N'
    WHERE datatype = 'frackbox'
    AND nid = '6'
;

UPDATE nodes
    SET
        title = '​​Frackbox Walk',
        code = '​​Frackbox W'
    WHERE datatype = 'frackbox'
    AND nid = '8'
;

UPDATE nodes
    SET
        title = '​​Frackbox 2 - Washington N',
        code = '​​Washington N'
    WHERE datatype = 'frackbox'
    AND nid = '14'
;

UPDATE nodes
    SET
        title = '​Frackbox 3 - Dimock S',
        code = '​Dimock S'
    WHERE datatype = 'frackbox'
    AND nid = '15'
;

UPDATE nodes
    SET
        title = 'Frackbox 4 - Washington N',
        code = 'Washington N2'
    WHERE datatype = 'frackbox'
    AND nid = '309'
;
