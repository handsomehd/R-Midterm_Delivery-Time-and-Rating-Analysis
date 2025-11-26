## **專題名稱：R 語言期中專題－外送時間與評分分析**
本專題藉由 Kaggle 平台取得的國外外送資料來分析外送的各項指標，探討何種因素能創造高評價及影響外送時間的因素
****
## 專案簡介
**專題目的：**
1. 分析外送平台的各種指標含意。
2. 透過 Anova 分析及 LM 回歸模型，分析四種類型的道路交通密度（Jam、High、Medium、Low），藉由其信賴區間對外送時間是否具有顯著性，評斷對時間的影響程度。
3. 以多元回歸模型分析四種指標（外送距離、天氣狀況、交通路況、其他訂單）對於外送時間的影響程度。
4. 以羅吉斯回歸分析何種因素將影響外送評分高低（以評分4.8以上為高分）。

**資料說明：**

|欄位名稱|欄位說明|
|---|---|
|Delivery_person_Ratings|外送人員的評分|
|Restaurant_latitude|餐廳的緯度|
|Restaurant_longitude|餐廳的經度|
|Delivery_location_latitude|交付位置的緯度|
|Delivery_location_longitude|交付位置的經度|
|Weatherconditions|天氣情況|
|Road_traffic_density|道路交通密度|
|Type_of_order|訂單類型|
|multiple_deliveries|是否有其他訂單外送|
|Time_taken (min)|完成訂單所需的時間（以分鐘為單位）|

## 分析結果
第一部分：外送時間的分析
1. 以 Anova 分析及 LM 回歸模型，分析道路交通密度對外送時間的影響程度。
2. 以多元回歸模型分析四種指標外送距離、天氣狀況、交通路況、其他訂單對於外送時間的影響程度。

# 圖片


