#setwd("C:/Users/janya/OneDrive/Desktop/misdirected_behaviour") # set working directory

library(tidyverse)
library(lme4)
library(DHARMa)
library(car)
library(emmeans)

My_Theme = theme_classic() + 
           theme(axis.title.x = element_text(size = 16),
           axis.text.x = element_text(size = 16),
           axis.title.y = element_text(size = 16), 
           axis.text.y = element_text(size = 16))

############################ Male-male mounting ################################
## Import csv with number of mounts performed per day for each male
mount_summary_days <- read.csv("data/mounts_per_day.csv") |> 
                      mutate(male_mount_rate = male_mounts/total_mounts) # calculate proportion of mounts at males


## Plot raw data (unweighted by number of observations per male)
ggplot(data = mount_summary_days, 
       aes(x = day, y = male_mount_rate, color = treatment, fill = treatment)) + 
       geom_smooth(method = "lm", se = FALSE) + 
       geom_point(alpha = 0.25) + theme_classic() +
       ylab("Proportion of mounts directed at other males") + xlab("Day") + 
       scale_color_manual(values = c("good" = "#023e8a", "poor" = "orange")) +
       scale_fill_manual(values = c("good" = "#023e8a", "poor" = "orange"))

## GLMM assessing effects of body condition x day
male_mount_model <- glmer(data = mount_summary_days, cbind(male_mounts, female_mounts) ~
                            treatment*day + (1|replicate/focal), family = binomial())

plot(simulateResiduals(male_mount_model)) # Model diagnostics looks good

Anova(male_mount_model) # Model results
summary(male_mount_model) # For reporting effect estimates and SE

## Plot predicted probabilities from model
# Extract predicted probabilities across the 5 days
male_mount_pred <- emmeans(male_mount_model, ~ treatment | day,
                           at = list(day = seq(1, 5, length.out = 100)),
                           type = "response")

male_mount_pred_df <- as.data.frame(male_mount_pred) # Convert to data frame

# Plot predicted probabilities from model (MANUSCRIPT FIG 2a)
ggplot(male_mount_pred_df, 
       aes(x = day, y = prob, colour = treatment, fill = treatment)) +
       geom_ribbon(aes(ymin = asymp.LCL, ymax = asymp.UCL), alpha = 0.1, color = NA) + # 95% CIs
       geom_line(linewidth = 1.5) + # lines
       scale_y_continuous(limits = c(0, 0.15), breaks = seq(0, 0.15, by = 0.05)) +
       labs(x = "Day", y = "Predicted probability of mounting another male",
       colour = "Body condition", fill = "Body condition") + 
       scale_color_manual(values = c("good" = "#023e8a", "poor" = "orange")) +
       scale_fill_manual(values = c("good" = "#023e8a", "poor" = "orange")) + My_Theme

## See what's going on with total mounts over time
ggplot(data = mount_summary_days, 
       aes(x = day, y = total_mounts, color = treatment, fill = treatment)) + 
       geom_smooth(method = "lm", se = FALSE) + 
       geom_point(alpha = 0.25) + theme_classic() +
       ylab("Number of mounts directed at females") + xlab("Day") + 
       scale_color_manual(values = c("good" = "#023e8a", "poor" = "orange")) +
       scale_fill_manual(values = c("good" = "#023e8a", "poor" = "orange"))

############################### Female attacks ################################
attack_summary_days <- read.csv("data/attacks_per_day.csv") |> 
                       mutate(female_attack_rate = female_attacks/total_attacks)

## Plot raw data
ggplot(data = attack_summary_days, 
       aes(x = day, y = female_attack_rate, color = treatment, fill = treatment)) + 
       geom_smooth(method = "lm", se = FALSE) + 
       geom_point(alpha = 0.25) +
       ylab("Proportion of attacks directed at other females") + xlab("Day") + 
       scale_color_manual(values = c("good" = "#023e8a", "poor" = "orange")) +
       scale_fill_manual(values = c("good" = "#023e8a", "poor" = "orange")) + 
       My_Theme

## GLMM assessing effects of body condition x day
female_attack_model <- glmer(data = attack_summary_days, cbind(female_attacks, male_attacks) ~ 
                             treatment*day + replicate + (1|replicate:focal), family = binomial())

plot(simulateResiduals(female_attack_model)) # Model diagnostics look generally fine

Anova(female_attack_model) # Model results
summary(female_attack_model) # Get estimates and SE to report

## Plot predicted probabilities from model
# Predicted probabilities across the 5 days
fem_attack_pred <- emmeans(female_attack_model, ~ treatment | day,
                           at = list(day = seq(1, 5, length.out = 100)),
                           type = "response")

fem_attack_pred_df <- as.data.frame(fem_attack_pred) # Convert to data frame

# Plot predicted probabilities from model (MANUSCRIPT FIG 2b)
ggplot(fem_attack_pred_df, 
       aes(x = day, y = prob, colour = treatment, fill = treatment)) +
       geom_ribbon(aes(ymin = asymp.LCL, ymax = asymp.UCL), alpha = 0.1, color = NA) + # 95% CIs
       geom_line(linewidth = 1.5) + # lines
       scale_y_continuous(limits = c(0, 0.65), breaks = seq(0, 0.65, by = 0.1)) +
       labs(x = "Day", y = "Predicted probability of attacking a female",
       colour = "Body condition", fill = "Body condition") +
       scale_color_manual(values = c("good" = "#023e8a", "poor" = "orange")) +
       scale_fill_manual(values = c("good" = "#023e8a", "poor" = "orange")) + 
       My_Theme

##### Extra analyses for attacks including fights
attacks_with_fights <- read.csv("data/attacks_per_day_with_fights.csv")

# GLMM assessing effects of body condition x day
female_attack_model_2 <- glmer(data = attacks_with_fights, cbind(female_attacks, male_attacks) ~ 
                               treatment*day + replicate + (1|replicate:focal), family = binomial())

plot(simulateResiduals(female_attack_model_2)) # Model diagnostics look generally fine

Anova(female_attack_model_2) # Model results
summary(female_attack_model_2) # Get estimates and SE to report

## Plot predicted probabilities from model
# Predicted probabilities across the 5 days
fem_attack_pred_2 <- emmeans(female_attack_model_2, ~ treatment | day,
                             at = list(day = seq(1, 5, length.out = 100)),
                             type = "response")

fem_attack_pred_df_2 <- as.data.frame(fem_attack_pred_2) # Convert to data frame

# Plot predicted probabilities from model
ggplot(fem_attack_pred_df_2, 
       aes(x = day, y = prob, colour = treatment, fill = treatment)) +
       geom_ribbon(aes(ymin = asymp.LCL, ymax = asymp.UCL), alpha = 0.1, color = NA) + # 95% CIs
       geom_line(linewidth = 1.5) + # lines
       scale_y_continuous(limits = c(0, 0.65), breaks = seq(0, 0.65, by = 0.1)) +
       labs(x = "Day", y = "Predicted probability of attacking a female",
       colour = "Body condition", fill = "Body condition") +
       scale_color_manual(values = c("good" = "#023e8a", "poor" = "orange")) +
       scale_fill_manual(values = c("good" = "#023e8a", "poor" = "orange")) + 
       My_Theme

## See what's going on with total attacks over time
ggplot(data = attack_summary_days, 
       aes(x = day, y = total_attacks, color = treatment, fill = treatment)) + 
       geom_smooth(method = "lm", se = FALSE) + 
       geom_point(alpha = 0.25) +
       ylab("Proportion of attacks directed at other females") + xlab("Day") + 
       scale_color_manual(values = c("good" = "#023e8a", "poor" = "orange")) +
       scale_fill_manual(values = c("good" = "#023e8a", "poor" = "orange")) + 
       My_Theme

################# RELATIONSHIP BETWEEN BOTH MISDIRECTED BEHAVIOURS ##############
combined_data <- read.csv("data/combined_data.csv")

# PLOT (Fig 3)
ggplot(combined_data, aes(x = female_attack_rate, y = male_mount_rate, color = treatment)) + 
       geom_smooth(method = "lm", se = FALSE) + # line
       geom_point(size = 2, alpha = 0.6, # points
                  position = position_jitter(width = 0.005, height = 0.005)) + #tiny bit of jitter
       labs(x = "Female attack rate", y = "Male mount rate", 
       colour = "Body condition") +
       My_Theme + scale_color_manual(values = c("good" = "#023e8a", "poor" = "orange"))

# MAIN TEST (Spearman's rank correlation - which I think is most appropriate for our question) 
cor.test(combined_data$male_mount_rate,
         combined_data$female_attack_rate,
         method = "spearman")

#### Same analyses using combined data including fights
combined_data_with_fights <- read.csv("data/combined_data_with_fights.csv")
                      
# PLOT
ggplot(combined_data_with_fights, aes(x = female_attack_rate, y = male_mount_rate, color = treatment)) + 
       geom_smooth(method = "lm", se = FALSE) + # line
       geom_point(size = 2, alpha = 0.6, # points
                  position = position_jitter(width = 0.005, height = 0.005)) + #tiny bit of jitter
       labs(x = "Female attack rate", y = "Male mount rate", 
       colour = "Body condition") +
       My_Theme + scale_color_manual(values = c("good" = "#023e8a", "poor" = "orange"))

# Spearman's rank correlation test
cor.test(combined_data_with_fights$male_mount_rate,
         combined_data_with_fights$female_attack_rate,
         method = "spearman")

# Additional models to confirm results
# Modelling variable as a binomial taking into account number of observations to see if it makes a diff
# Female attack rate as binomial response variable
#corr_model_1 <- glm(data = combined_data, cbind(female_attacks, male_attacks) ~ 
#                      male_mount_rate + replicate, family = binomial()) # attack as binomial response

#plot(simulateResiduals(corr_model_1))

#Anova(corr_model_1) # Result: no sig correlation

# Male mount rate as binomial response variable
#corr_model_2 <- glmer(data = combined_data, cbind(male_mounts, female_mounts) ~ 
#                        female_attack_rate + (1|replicate), family = binomial()) # mount as binomial response

#plot(simulateResiduals(corr_model_2))

#Anova(corr_model_2) # Result: no sig correlation

