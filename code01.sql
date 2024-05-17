create database test;
use test;

DROP TABLE IF EXISTS environmental_monitoring;
-- 创建环保监测表.
CREATE TABLE environmental_monitoring (
 id INT AUTO_INCREMENT PRIMARY KEY,
 license_plate VARCHAR(255) COMMENT '⻋牌号',
 owner_phone VARCHAR(255) COMMENT '⻋主电话',
 monitoring_time DATETIME COMMENT '监测时间',
 monitoring_point VARCHAR(255) COMMENT '监测点',
 is_pass ENUM('合格', '不合格') COMMENT '是否合格'
);
INSERT INTO environmental_monitoring (license_plate, owner_phone, monitoring_time, monitoring_point, is_pass) VALUES
('⻋牌号A', '⻋主号码1001', '2023-09-01 08:15:00', '监测点1', '不合格'),
('⻋牌号B', '⻋主号码1002', '2023-09-01 09:30:00', '监测点2', '不合格'),
('⻋牌号A', '⻋主号码1001', '2023-09-01 13:45:00', '监测点2', '不合格'),
('⻋牌号C', '⻋主号码1003', '2023-09-01 15:00:00', '监测点1', '合格'),
('⻋牌号B', '⻋主号码1002', '2023-09-01 16:30:00', '监测点1', '不合格'),
('⻋牌号A', '⻋主号码1001', '2023-09-02 08:15:00', '监测点1', '合格'),
('⻋牌号B', '⻋主号码1002', '2023-09-02 09:30:00', '监测点2', '不合格'),
('⻋牌号A', '⻋主号码1001', '2023-09-02 13:45:00', '监测点3', '不合格'),
('⻋牌号C', '⻋主号码1003', '2023-09-02 15:00:00', '监测点3', '合格'),
('⻋牌号B', '⻋主号码1002', '2023-09-02 16:30:00', '监测点2', '不合格'),
('⻋牌号A', '⻋主号码1001', '2023-09-03 08:15:00', '监测点4', '不合格'),
('⻋牌号B', '⻋主号码1002', '2023-09-03 09:30:00', '监测点2', '不合格'),
('⻋牌号A', '⻋主号码1001', '2023-09-03 13:45:00', '监测点1', '不合格'),
('⻋牌号C', '⻋主号码1003', '2023-09-03 15:00:00', '监测点2', '不合格'),
('⻋牌号B', '⻋主号码1002', '2023-09-03 16:30:00', '监测点2', '不合格');

select * from environmental_monitoring;


with temp as (SELECT
  license_plate,
  COUNT(is_pass) AS time
FROM
    (
  SELECT
    license_plate,
    monitoring_time,
    is_pass,
    ROW_NUMBER() OVER (PARTITION BY license_plate ORDER BY monitoring_time) rn1,
    ROW_NUMBER() OVER (PARTITION BY license_plate, is_pass ORDER BY monitoring_time) rn2,
    ROW_NUMBER() OVER (PARTITION BY license_plate ORDER BY monitoring_time) - ROW_NUMBER() OVER (PARTITION BY license_plate, is_pass ORDER BY monitoring_time) AS grp
  FROM
    environmental_monitoring
) as RankedData
WHERE
  is_pass = '不合格'
GROUP BY
  license_plate, grp
HAVING
  COUNT(is_pass) > 0)
select
    license_plate,
    max(time)
from temp
group by license_plate;







