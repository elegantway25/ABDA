# Read the tables

turbine_metadata <- read.csv("Hill_of_Towie_turbine_metadata.csv")
turbine_fields_description <- read.csv("Hill_of_Towie_turbine_fields_description.csv")
tables_description <- read.csv("Hill_of_Towie_tables_description.csv")
# ShuTDownDuration <- read.csv("ShuTDownDuration.csv")
grid_fields_description <- read.csv("Hill_of_Towie_grid_fields_description.csv")
alarms_description <- read.csv("Hill_of_Towie_alarms_description.csv")
AeroUp_install_dates <- read.csv("Hill_of_Towie_AeroUp_install_dates.csv")

# Turbine data for April 2024
GridScientific_2024_04 <- read.csv("2024/tblGridScientific_2024_04.csv")

SCTurbine_2024_04 <- read.csv("2024/tblSCTurbine_2024_04.csv")
SCTurGrid_2024_04 <- read.csv("2024/tblSCTurGrid_2024_04.csv")
SCTurFlag_2024_04 <- read.csv("2024/tblSCTurFlag_2024_04.csv")

# Take time stamps, Ids, wind speeds and wind directions from SCTurbine_2024_04
TD <- 
  data.frame(TimeStamp = SCTurbine_2024_04$TimeStamp, 
             StationId = SCTurbine_2024_04$StationId,
             AcWindSp = SCTurbine_2024_04$wtc_AcWindSp_mean, 
             # PrWindSp = SCTurbine_2024_04$wtc_PrWindSp_mean,
             # SeWindSp = SCTurbine_2024_04$wtc_SeWindSp_mean,
             
             NacelPos = SCTurbine_2024_04$wtc_NacelPos_mean,
             PitchA = SCTurbine_2024_04$wtc_PitcPosA_mean, 
             PitchB = SCTurbine_2024_04$wtc_PitcPosB_mean, 
             PitchC = SCTurbine_2024_04$wtc_PitcPosC_mean, 
             WindDir = SCTurbine_2024_04$wtc_ActualWindDirection_mean)



# Merge with ActivePower from SCTurGrid_2024_04
TD <- merge(
  TD,
  SCTurGrid_2024_04[, c("TimeStamp", "StationId", "wtc_ActPower_mean")],
  by = c("TimeStamp", "StationId"),
  all.x = TRUE,
  sort = FALSE
)
names(TD)[names(TD) == "wtc_ActPower_mean"] <- "ActivePower"

# Connect turbine ids with their names (ex. T01) from turbine_metadata
TD <- merge(
  TD,
  turbine_metadata[, c("Turbine.Name", "Station.ID")],
  by.x = c("StationId"),
  by.y = c("Station.ID"),
  all.x = TRUE,
  sort = FALSE
)
names(TD)[names(TD) == "Turbine.Name"] <- "TurbineName"

# Merge with TimeInOper from SCTurFlag_2024_04 (Time the turbine was running in a given 10-minute period)
TD <- merge(
  TD, 
  SCTurFlag_2024_04[, c("TimeStamp", "StationId", "wtc_ScInOper_timeon")], 
  by = c("TimeStamp", "StationId"), 
  all.x = TRUE,
  sort = FALSE
)
names(TD)[names(TD) == "wtc_ScInOper_timeon"] <- "TimeInOper"


# Sort the data by the time stamp
TD <- TD[order(TD$TimeStamp), ]





