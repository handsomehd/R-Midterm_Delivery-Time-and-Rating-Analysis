library(ggplot2)
library(dplyr)
library(plyr)
library(geosphere)
library(coefplot)
library(boot)
library(reshape2)
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

# 外送時間統計數據
df_time <- c(mean(data$Time_taken..min.), 
       var(data$Time_taken..min.), 
       sd(data$Time_taken..min.),
       median(data$Time_taken..min.),
       min(data$Time_taken..min.),
       max(data$Time_taken..min.))
names(df_time) <- c("平均數","變異數","標準差","中位數","最小值","最大值")
df_time
# 外送評分統計數據
df_rating <- c(mean(data$Delivery_person_Ratings), 
             var(data$Delivery_person_Ratings), 
             sd(data$Delivery_person_Ratings),
             median(data$Delivery_person_Ratings),
             min(data$Delivery_person_Ratings),
             max(data$Delivery_person_Ratings))
names(df_rating) <- c("平均數","變異數","標準差","中位數","最小值","最大值")
df_rating

cor(data[,c(3,4,20)])
# # Plot the chart.
# h <- hist(data$Delivery_person_Ratings,
#           xlab="Rating",
#           ylab="Count",
#           breaks = seq(2, 5, by = 0.1)
# )
# # anova
# trafficAnova <- aov(data$Time_taken..min. ~ data$Road_traffic_density - 1, data)
# summary(trafficAnova)
# trafficByAge <- ddply(data, "Road_traffic_density", summarise,
#                       timeTaken.mean=mean(Time_taken..min.), timeTaken.sd=sd(Time_taken..min.),
#                       Length=NROW(Time_taken..min.),
#                       tfrac=qt(p=.90, df=Length-1),
#                       Lower=timeTaken.mean - tfrac*timeTaken.sd/sqrt(Length),
#                       Upper=timeTaken.mean + tfrac*timeTaken.sd/sqrt(Length))
# ggplot(trafficByAge, aes(x=timeTaken.mean, y=Road_traffic_density)) +
#   geom_point() +
#   geom_errorbarh(aes(xmin=Lower, xmax=Upper), height=.3)

# lm
trafficLM <- lm(Time_taken..min. ~ Road_traffic_density - 1, data)
trafficInfo <- summary(trafficLM) # Adjusted R-squared: 值1表示完美預測目標欄位中的值的模型
trafficInfo
trafficCoef <- as.data.frame(trafficInfo$coefficients[, 1:2])
trafficCoef <- within(trafficCoef, {
                      Lower <- Estimate - qt(p=0.90, df=trafficInfo$df[2]) * `Std. Error`
                      Upper <- Estimate + qt(p=0.90, df=trafficInfo$df[2]) * `Std. Error`
                      Road_traffic_density <- rownames(trafficCoef)
                      })
trafficCoef
ggplot(trafficCoef, aes(x=Estimate, y=Road_traffic_density)) + geom_point() +
  geom_errorbarh(aes(xmin=Lower, xmax=Upper), height=.3) +
  ggtitle("Time_taken by traffic density calculated from regression model")

# 全部預測變數畫圖 road traffic, weather condition, deliver_distance, multiple delivery
ggplot(data, aes(x=data$Time_taken..min.)) +
             geom_histogram(binwidth=1) +
             labs(x="Time_taken")
# #天氣
# ggplot(data, aes(x=data$Time_taken..min., fill=Weatherconditions)) +
#              geom_histogram(binwidth=1) + labs(x="Time_taken")
# ggplot(data, aes(x=data$Time_taken..min., fill=Weatherconditions)) +
#              geom_histogram(binwidth=1) + labs(x="Time_taken") +
#              facet_wrap(~Weatherconditions)
# #交通
# ggplot(data, aes(x=data$Time_taken..min., fill=Road_traffic_density)) +
#              geom_histogram(binwidth=1) + labs(x="Time_taken")
# ggplot(data, aes(x=data$Time_taken..min., fill=Road_traffic_density)) +
#              geom_histogram(binwidth=1) + labs(x="Time_taken") +
#              facet_wrap(~Road_traffic_density)
# 
# # 假設原始資料的距離欄位名稱為distance
# data$deliver_distance <- cut(data$deliver_distance, breaks = c(0, 5, 10, 15, 20, 25), labels = c(1, 2, 3, 4, 5))
# #距離
# ggplot(data, aes(x=data$Time_taken..min., fill=deliver_distance)) +
#              geom_histogram(binwidth=1) + labs(x="Time_taken")
# ggplot(data, aes(x=data$Time_taken..min., fill=deliver_distance)) +
#              geom_histogram(binwidth=1) + labs(x="Time_taken") +
#              facet_wrap(~deliver_distance)
# 
#額外接單
# ggplot(data, aes(x=data$Time_taken..min., fill=multiple_deliveries)) +
#        geom_histogram(binwidth=1) + labs(x="Time_taken")
# ggplot(data, aes(x=data$Time_taken..min., fill=multiple_deliveries)) +
#        geom_histogram(binwidth=1) + labs(x="Time_taken") +
#        facet_wrap(~multiple_deliveries)
# 
colnames(data)[12] <- "Weather"
colnames(data)[13] <- "Traffic"
head(data)

# 第一個lm模型(無交互作用)
model1 <- lm(Time_taken..min. ~ Weather + Traffic + deliver_distance + multiple_deliveries, data = data)
summary(model1)
coefplot(model1)
head(fortify(house1))

# # 殘差圖
# h1 <- ggplot(aes(x=.fitted, y=.resid), data = model1) +
#              geom_point() +
#              geom_hline(yintercept = 0) +
#              geom_smooth(se = FALSE) +
#              labs(x="Fitted Values", y="Residuals")
# h1
# h1 + geom_point(aes(color = Weather))
# h1 + geom_point(aes(color = Traffic))
# h1 + geom_point(aes(color = deliver_distance))
# h1 + geom_point(aes(color = multiple_deliveries))

# 第二個lm模型
model2 <- lm(Time_taken..min. ~ Weather:Traffic + deliver_distance + multiple_deliveries, data = data)
summary(model2)
coefplot(model2)

# 第三個lm模型
model3 <- lm(Time_taken..min. ~ Weather:Traffic + deliver_distance:multiple_deliveries, data = data)
summary(model3)
coefplot(model3)

# 第四個lm模型
model4 <- lm(Time_taken..min. ~ Weather:Traffic:deliver_distance + multiple_deliveries, data = data)
summary(model4)
coefplot(model4)

# 第五個lm模型
model5 <- lm(Time_taken..min. ~ Weather:multiple_deliveries + Traffic + deliver_distance, data = data)
summary(model5)
coefplot(model5)

# models <- list(model1, model2, model3, model4, model5)

# 5個QQ圖
# for (i in seq_along(models)) {
#   plot(models[[i]], which = 2)
#   print(ggplot(models[[i]], aes(sample = .stdresid)) +
#                stat_qq() + geom_abline() +
#                ggtitle(paste0("模型", i, "-QQ圖")) +
#                theme(plot.title = element_text(hjust = 0.5)))
# }

# 5個殘差直方圖
# for(i in 1:length(models)) {
#   print(ggplot(models[[i]], aes(x = .resid)) + geom_histogram() +
#           ggtitle(paste0("模型", i, "殘差直方圖")) +
#           theme(plot.title = element_text(hjust = 0.5)))
# }

#ggplot(model1, aes(x = .resid)) + geom_histogram()

# 各模型比較
# multiplot(model1, model2, model3, model4, model5)
# 
# AIC, BIC, Anova(RSS) 評估哪個模型最好(分數最低最好)
# 模型2最好
# anova(model1, model2, model3, model4, model5)
# AIC(model1, model2, model3, model4, model5)
# BIC(model1, model2, model3, model4, model5)
# 
# 以glm建模查看偏差平方和(deviance)
# data$long_time <- data$Time_taken..min. >= 30
# high1 <- glm(long_time ~ Weather + Traffic + deliver_distance + multiple_deliveries, data = data, family=binomial(link="logit"))
# high2 <- glm(long_time ~ Weather:Traffic + deliver_distance + multiple_deliveries, data = data, family=binomial(link="logit"))
# high3 <- glm(long_time ~ Weather:Traffic + deliver_distance:multiple_deliveries, data = data, family=binomial(link="logit"))
# high4 <- glm(long_time ~ Weather:Traffic:deliver_distance + multiple_deliveries, data = data, family=binomial(link="logit"))
# high5 <- glm(long_time ~ Weather:multiple_deliveries + Traffic + deliver_distance, data = data, family=binomial(link="logit"))
# AIC, BIC, Anova(RSS) 評估哪個模型最好(分數最低最好)
# 模型2最好
# anova(high1, high2, high3, high4, high5)
# AIC(high1, high2, high3, high4, high5)
# BIC(high1, high2, high3, high4, high5)

# cross-validation
modelG1 <- glm(Time_taken..min. ~ Weather + Traffic + deliver_distance + multiple_deliveries,
               data=data, family=gaussian(link="identity"))
modelG2 <- glm(Time_taken..min. ~ Weather:Traffic + deliver_distance + multiple_deliveries,
               data=data, family=gaussian(link="identity"))
modelG3 <- glm(Time_taken..min. ~ Weather:Traffic + deliver_distance:multiple_deliveries,
               data = data, family=gaussian(link="identity"))
modelG4 <- glm(Time_taken..min. ~ Weather:Traffic:deliver_distance + multiple_deliveries,
               data = data, family=gaussian(link="identity"))
modelG5 <- glm(Time_taken..min. ~ Weather:multiple_deliveries + Traffic + deliver_distance,
               data = data, family=gaussian(link="identity"))
# 執行5折(群)的交叉驗證並檢視delta誤差
modelCV1 <- cv.glm(data, modelG1, K=5)
modelCV2 <- cv.glm(data, modelG2, K=5)
modelCV3 <- cv.glm(data, modelG3, K=5)
modelCV4 <- cv.glm(data, modelG4, K=5)
modelCV5 <- cv.glm(data, modelG5, K=5)

#建立一個data.frame
cvResults <- as.data.frame(rbind(modelCV1$delta,
                                 modelCV2$delta,
                                 modelCV3$delta,
                                 modelCV4$delta,
                                 modelCV5$delta))
#進行一些處理以更好地呈現並取名
names(cvResults) <- c("Error", "Adjusted.Error")
# 加入模型名稱 …
cvResults$Model <- sprintf("modelG%s", 1:5)
cvResults

# 使用 ANOVA、AIC 和交叉驗證
# 視覺化驗證
cvANOVA <-anova(modelG1, modelG2, modelG3, modelG4, modelG5)
cvResults$ANOVA <- cvANOVA$`Resid. Dev`
# 用AIC測量
cvResults$AIC <- AIC(modelG1, modelG2, modelG3, modelG4, modelG5)$AIC
# 以data.frame建立以便繪圖
cvMelt <- melt(cvResults, id.vars="Model", variable.name="Measure",
               value.name="Value")
cvMelt
# ggplot(cvMelt, aes(x=Model, y=Value)) +
#   geom_line(aes(group=Measure, color=Measure)) +
#   facet_wrap(~Measure, scales="free_y") +
#   theme(axis.text.x=element_text(angle=90, vjust=.5)) +
#   guides(color=FALSE)