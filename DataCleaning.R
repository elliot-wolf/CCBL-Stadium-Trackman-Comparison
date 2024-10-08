
# Load packages
library(tidyverse)

# Import data
master <- read.csv("dat.csv")

# Select desired variables, filter just fastballs
dat <- master %>%
  select(Pitcher, PitcherThrows, PitcherTeam, TaggedPitchType, AutoPitchType,
         Stadium, RelSpeed, VertRelAngle, HorzRelAngle, SpinRate, SpinAxis, 
         Tilt, RelHeight, RelSide, Extension,  VertBreak, InducedVertBreak, 
         HorzBreak) %>%
  filter((TaggedPitchType == "Fastball" | TaggedPitchType == "FourSeamFastBall" |
            TaggedPitchType == "Sinker" | TaggedPitchType == "TwoSeamFastBall" |
            TaggedPitchType == "Cutter") &
           (AutoPitchType == "Sinker" | AutoPitchType == "Four-Seam" |
              AutoPitchType == "Cutter") & 
           RelSpeed >= 85)

# Group by pitcher and stadium, find avg statistic
dat1 <- dat %>%
  filter(Stadium == "CCBLCotuit" | Stadium == "CCBLWareham") %>% 
  group_by(Pitcher, Stadium) %>%
  summarise(AvgVelo = mean(RelSpeed)) %>% 
  filter(AvgVelo >= 90) %>% 
  ungroup()

# Pivot data
dat2 <- dat1 %>%
  pivot_wider(names_from = Stadium, values_from = AvgVelo) %>% 
  drop_na()

# Export csv
write.csv(dat2, "/Users/apple/Desktop/TM Comparison/comparison.csv", row.names = FALSE)
