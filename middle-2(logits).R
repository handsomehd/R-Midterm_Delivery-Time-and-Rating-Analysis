library(ggplot2)
library(dplyr)
library(plyr)
library(geosphere)
library(coefplot)
library(useful)
# 設定工作目錄
setwd("C:/Users/User/Documents/R語言/期中繳交/期中程式/data/")
data <- read.csv("food_delivery.csv", header = TRUE)
data <- na.omit(data)
data <- data[data$Delivery_person_Ratings < 6 & data$Delivery_person_Ratings > 2,]

# 新增deliver_distance欄位
data$deliver_distance <- distHaversine(data[, c("Restaurant_longitude", "Restaurant_latitude")],
                                       data[, c("Delivery_location_longitude", "Delivery_location_latitude")]) / 1000 #單位轉換成公里
# 計算上下分位數
q1 <- quantile(data$deliver_distance, 0.25)
q3 <- quantile(data$deliver_distance, 0.75)
# 計算四分位距
iqr <- q3 - q1
# 計算上下邊界
upper_bound <- q3 + 1.5 * iqr
lower_bound <- q1 - 1.5 * iqr
data <- subset(data, deliver_distance > lower_bound & deliver_distance < upper_bound)

colnames(data)[12] <- "Weather"
colnames(data)[13] <- "Traffic"

# Rating <= 4.9 (logistic) 指標圖
third_quartile <- quantile(data$Delivery_person_Ratings, probs = 0.75) # 評分第3分位數
data$Rating <- with(data, Delivery_person_Ratings >= third_quartile)
ggplot(data, aes(x = Delivery_person_Ratings)) +
       geom_density(fill = "grey", color = "grey") +
       geom_vline(xintercept = third_quartile) +
       scale_x_continuous(limits = c(2, 5),
                          breaks = c(seq(2, 5, 0.5), third_quartile),
                          labels = c(seq(2, 5, 0.5), round(third_quartile, 2))) +
       ggtitle("指標圖") +
       theme(plot.title = element_text(hjust = 0.5))


# 係數圖
count1 <- glm(Rating ~ Delivery_person_Age + deliver_distance + Weather + Traffic + Type_of_order + multiple_deliveries + Time_taken..min.,
              data=data,
              family=binomial(link="logit"))
summary(count1)
coefplot(count1)

# 轉換預測係數
invlogit <- function(x)
{
  1/(1 + exp(-x))
}
invlogit(count1$coefficients)