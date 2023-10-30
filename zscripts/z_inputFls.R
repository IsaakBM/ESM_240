# This code was written by Isaac Brito-Morales (ibrito@conservation.org)
# Please do not distribute this code without permission.
# NO GUARANTEES THAT CODE IS CORRECT
# Caveat Emptor!

library(terra)
library(sf)
library(dplyr)
library(tidyr)
library(stringr)

########################
####### Whale Shark (mmf)
########################
  
  ws01 <- readRDS("data/mm_mmf/MMF_WhaleSharkTracks_Madagascar.rds")
  ws02 <- readRDS("data/mm_mmf/MMF_WhaleSharkTracks_Mozambique.rds")
  
  wsF <- rbind(ws01, ws02) %>% 
    dplyr::mutate(group = "Whale Shark")
  
  wsF01 <- wsF %>% 
    dplyr::filter(dates %in% wsF$dates[stringr::str_detect(string = wsF$dates, pattern = "2016-10.*")])
  wsF02 <- wsF %>% 
    dplyr::filter(dates %in% wsF$dates[stringr::str_detect(string = wsF$dates, pattern = "2016-11.*")])
  wsF03 <- wsF %>% 
    dplyr::filter(dates %in% wsF$dates[stringr::str_detect(string = wsF$dates, pattern = "2016-12.*")])
  
  wsF04 <- wsF %>% 
    dplyr::filter(dates %in% wsF$dates[stringr::str_detect(string = wsF$dates, pattern = "2011-07.*")])
  wsF05 <- wsF %>% 
    dplyr::filter(dates %in% wsF$dates[stringr::str_detect(string = wsF$dates, pattern = "2011-08.*")])
  wsF06 <- wsF %>% 
    dplyr::filter(dates %in% wsF$dates[stringr::str_detect(string = wsF$dates, pattern = "2011-09.*")])
  wsF07 <- wsF %>% 
    dplyr::filter(dates %in% wsF$dates[stringr::str_detect(string = wsF$dates, pattern = "2011-10.*")])
  wsF08 <- wsF %>% 
    dplyr::filter(dates %in% wsF$dates[stringr::str_detect(string = wsF$dates, pattern = "2011-11.*")])
  wsF09 <- wsF %>% 
    dplyr::filter(dates %in% wsF$dates[stringr::str_detect(string = wsF$dates, pattern = "2011-12.*")])