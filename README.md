# Analyses
This R script (misdirected_behaviours_clean.R) contains all of the code needed to reproduce the statistical analyses and figures presented in the manuscript.

# Data
### Mounts per day (mounts_per_day.csv)
This csv file contains information on how many mounts each male performed each day of the experiment along with the ID and treatment of each male. Every unique male appears five times, representing the five days of the experiment. Male IDs were re-used between replicates. Description of each column below:

**replicate:** represents which replicate the male was from (ranges from 1-6)

**day:** represents days 1-5 of the experiment

**focal:** represents the individual ID assigned to the male for the experiment. IDs were re-used between replicates. In other words, '0 from replicate 1 is a different male than `0 from replicate 2. 
**total mounts:** total number of mounts the male performed on a given day. This is a sum of female and male mounts. 
**male mounts:** total number of mounts directed at males on a given day.
**female mounts:** total number of mounts directed at females on a given day. These include mounts that eventually resulted in mating. 
**matings:** number of matings each male secured in a given day.
**treatment:** indicates whether males were part of the good body condition or poor body condition treatment. 

### Attacks per day (attacks_per_day.csv)
This csv file contains information on how many attacks each male performed each day of the experiment along with the ID and treatment of each male. Every unique male appears five times, representing the five days of the experiment. Male IDs were re-used between replicates. Description of each column below:

**replicate:** represents which replicate the male was from (ranges from 1-6)
**day:** represents days 1-5 of the experiment
**focal:** represents the individual ID assigned to the male for the experiment. IDs were re-used between replicates. In other words, '0 from replicate 1 is a different male than `0 from replicate 2. 
**total attacks:** total number of attacks the male performed on a given day. This is a sum of female and male attacks. 
**male attacks:** total number of attacks directed at males on a given day.
**female attacks:** total number of attacks directed at females on a given day.
**treatment:** indicates whether males were part of the good body condition or poor body condition treatment. 

### Attacks per day with fights included (attacks_per_day_with_fights.csv)
This csv file is identical to the one above (attacks_per_day.csv) except male escalated contest data is included. Specifically, for each escalated grappling fight that occurred between a dyad of males, it was scored as one attack exhibited by each male against the other. Otherwise, the column contents are identical to the above csv so I did not repeat the descriptions here. 

### Data combined (combined_data.csv)
This csv was used to run the Spearman's correlation test and plot the association between male mounting rate and female attack rate. Most of the columns overlap with the previous two csv files as this one just combines the data. The attack columns here do not include male escalated fights. The two new columns are described here:

**male_mount_rate:** calculated as mounts directed at males divided by total mounts
**female_attack_rate:** calculated as attacks directed at females divided by total attacks






