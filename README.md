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
***
## 分析結果
### 第一部分：外送時間的分析
1. 以 Anova 分析及 LM 回歸模型，分析道路交通密度對外送時間的影響程度。
2. 以多元回歸模型分析四種指標外送距離、天氣狀況、交通路況、其他訂單對於外送時間的影響程度。
- 外送評分統計

由表可看出，給予高分者占大多數

<img width="615" height="537" alt="image" src="https://github.com/user-attachments/assets/d48391de-edda-4d1a-9793-b43a6e237e31" />

***
- Anova 分析交通壅擠程度對應外送時間，各組之間是否有顯著差異

由表可看出
1. High 跟 Medium 的信賴區間重疊，對外送時間的影響不顯著。
2. Low 跟 Jam 沒有信賴區間重疊，因此對外送時間影響顯著。

<img width="616" height="444" alt="image" src="https://github.com/user-attachments/assets/9b2b58aa-c642-4e35-8c9e-b873e7b122c1" />

***
- 天氣對外送時間的影響

由表可看出
1. 從外送時間很短(<20)可以發現六種天氣狀況都有峰值，所以天氣不影響。
2. 外送時間很長時(>35)可以發現六種天氣狀況也都有峰值，所以天氣不影響
3. 從各別直方圖可以看出，Cloudy與Fog會導致時間較長，其他四種情況則直方圖偏左，會使時間較短

<img width="513" height="691" alt="image" src="https://github.com/user-attachments/assets/834be0b9-a8ba-41ce-ac2e-a2911870c116" />

***
- 交通壅塞程度對外送時間的影響

由表可看出
1. 當路況Jam與Medium時，在時間多(>35)有峰值，理解為路況普通或是壅擠時會使時間變長。
2. 當路況為Low時，在時間少(<20)時有峰值，可以理解為路況良好會使時間明顯變短。
3. 反而路況為High時對時間影響程度不大。

<img width="504" height="675" alt="image" src="https://github.com/user-attachments/assets/91eb4e6d-1027-4289-b635-028c71a2282c" />

***
- 外送距離對外送時間的影響

由表可看出
1. 當外送距離很近(為1)，在時間少(<20)時有峰值，理解為距離很短會使時間明顯變短。
2. 在外送距離為中長距離(為3、4)時，在時間多(>35)時有峰值，理解為距離為中或較長距離時，會使時間變長。
3. 反而距離很長時，因資料不足導致無法斷定是否會影響時間。

<img width="495" height="671" alt="image" src="https://github.com/user-attachments/assets/35462954-2c49-44f3-bb6a-b51f6f952024" />

***
- 額外接單對外送時間的影響

由表可看出
1. 額外接單可以忽略轉接2次以上，因數據量少。
2. 整個直方圖受0與1次轉接影響，又1次轉接佔了幾乎大量的外送數據，因此1的直方圖與總直方圖十分相似。

<img width="508" height="676" alt="image" src="https://github.com/user-attachments/assets/c0022a4d-ad4a-47bd-a072-1213953b823a" />

***
- 相關係數分析：模型一（外送距離 + 天氣狀況 + 交通路況 + 其他訂單）

可以看出「是否有其他訂單」、「路況壅擠」及「天氣晴」會影響外送時間，但這幾項因素之間沒有關係，因此模型並不好且有 underfitting 的情況

<img width="625" height="414" alt="image" src="https://github.com/user-attachments/assets/6a8e69ec-dd4b-409e-b1be-ea8e6d7a0ab8" />

***
- 相關係數分析：模型二（外送距離 + 天氣狀況 * 交通路況 + 其他訂單）

可以看出天氣（雲/霧）及交通狀況（擁擠）對外送時間影響較大，相比模型一，這個模型的天氣狀況 x 交通路況因變數有較好的模型表

<img width="786" height="570" alt="image" src="https://github.com/user-attachments/assets/f2f1eb27-1ef7-46db-955d-c27388b99cd2" />

***
- 相關係數分析：模型三（天氣狀況 * 交通路況 + 外送距離 * 其他訂單）

可以看出天氣（雲/霧）及交通狀況（擁擠）對外送時間影響較大，相比模型二，外送距離 x 其他訂單較沒有顯著性

<img width="761" height="472" alt="image" src="https://github.com/user-attachments/assets/d45455af-498e-471c-819c-da75485ca9c6" />

***
- 相關係數分析：模型四（外送距離 * 天氣狀況 * 交通路況 + 其他訂單）

可以看出僅有其他訂單狀況對外送時間影響較大，相比其他模型，綜合外送距離 x 天氣狀況 x 交通路況反而使顯著性降低。

<img width="767" height="556" alt="image" src="https://github.com/user-attachments/assets/ddca7a9b-b65e-4dac-9282-6ed3ff5b31f7" />

***
- 相關係數分析：模型四（外送距離 + 交通路況 + 天氣狀況 * 其他訂單）

可以看出天氣狀況 x 其他訂單有較高的顯著性，但是相比模型二並沒有更佳。

<img width="771" height="432" alt="image" src="https://github.com/user-attachments/assets/24901e97-c6ba-4767-a625-5ad1e4dac939" />

***
-
<img width="769" height="671" alt="image" src="https://github.com/user-attachments/assets/335f422b-72b4-477a-9fbf-fb1ade6ae458" />










