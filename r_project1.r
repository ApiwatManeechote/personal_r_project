install.packages(dplyr)
install.packages(tidyverse)

library(dplyr, tidyverse)

jojo_cha <- data.frame(
  cha_id = c(1, 2, 3),
  cha_name = c('Jonathan', 'Joseph', 'Jotaro'),
  jojo_part = c(1, 2, 3)
)

View(jojo_cha)

jojo_cha2 <- data.frame(
  cha_id = c(4, 5, 6),
  cha_name = c('Josuke', 'Giorno', 'Jolyne'),
  jojo_part = c(4, 5, 6)
)

jojo_cha <- rbind(jojo_cha, jojo_cha2)

jojo_cha$cha_power <- c('Hamon', 'Hamon', 'Stand', 'Stand', 'Stand', 'Stand')

jojo_cha$cha_power[jojo_cha$cha_name == 'Joseph'] <- 'Hamon and Stand'

jojo_cha <- jojo_cha[!grepl("Hamon", jojo_cha$cha_power), ]
