# patriots-vball-data

# Cumberlands Volleyball Analysis: Championship Performance Metrics

A comprehensive data visualization and statistical analysis of Cumberlands University's 2025 volleyball team performance compared to current top-10 programs and historical NCAA Division II champions.

## Overview

This project analyzes key performance indicators (KPIs) across offensive efficiency, defensive dominance, and tactical execution to demonstrate how Cumberlands' 2025 season metrics align with championship-caliber programs.

## Key Findings

- **Offensive Efficiency**: Cumberlands' hitting percentage exceeds both current top-10 programs and historical champion averages
- **Defensive Dominance**: Opponent hitting percentage significantly below peer comparisons
- **Serving Pressure**: Exceptional aces-per-set ratio indicates aggressive serving strategy
- **Consistency**: Demonstrates balanced excellence across all key statistical categories

## Data Structure

data/
├── patriots-vball-data.csv # Raw dataset with all metrics
│ ├── Team name and year
│ ├── Category (Current Top 10, Past Champions, Cumberlands)
│ ├── Hitting %, Opp Hitting %
│ ├── Kills/Set, Blocks/Set, Aces/Set, Digs/Set

## Visualizations

The analysis includes 8 publication-ready visualizations:

1. **Lollipop Chart - Offensive Efficiency**: Hitting percentage comparison across groups
2. **Heatmap - Defensive Dominance**: Individual team opponent hitting percentages
3. **Scatter Plot - Efficiency Matrix**: Offense vs. defense positioning
4. **Horizontal Bar Chart - Kills Per Set**: Individual team kill production
5. **Slope Chart - Dual Dominance**: Offensive and defensive excellence trajectory
6. **Faceted Profile Chart - DNA Profile**: Normalized metrics across all categories
7. **Line Chart - Serving Pressure**: Aces per set comparison
8. **Diverging Bar Chart - Hitting Efficiency**: Deviation from average

All visualizations saved to `fig/` folder at 300 DPI with white backgrounds.

## Requirements

System Requirements
R 4.0+
RStudio (optional but recommended)

## Installation & Usage

# Clone the repository
git clone https://github.com/yourusername/cumberlands-vball-analysis.git
cd cumberlands-vball-analysis

# Open in RStudio
open analysis.R

# Or run directly in R
source("analysis.R")

## Running the Analysis
# Load required libraries
library(tidyverse)

# Source the main analysis script
source("analysis.R")

# All visualizations will be generated and saved to fig/

## File Structure

cumberlands-vball-analysis/
├── README.md                        # This file
├── analysis.R                       # Main analysis script
├── data/
│   └── patriots-vball-data.csv     # Raw volleyball data
└── fig/                            # Output directory (auto-created)
    ├── 01_lollipop_offensive_efficiency.png
    ├── 02_heatmap_defensive_dominance.png
    ├── 03_scatter_efficiency_matrix.png
    ├── 04_horizontal_bar_kills_distribution.png
    ├── 05_slope_offense_defense.png
    ├── 06_faceted_dna_profile.png
    ├── 07_line_serving_pressure.png
    └── 08_diverging_hitting_efficiency.png

## Methodology
## Data Cleaning
Parsed hitting percentages from string format to numeric decimals
Normalized category labels for consistent comparison
Handled missing values using na.rm = TRUE
## Comparison Groups

Current Top 10 (2025): Average metrics from 10 elite Division II programs this season
Past Champions (2019-2024): Historical averages from 6 NCAA Division II championship seasons
Cumberlands (2025): Current season individual match-by-match data
Statistical Approach

## All visualizations use averages for comparison groups
Individual team-by-team analysis for detailed positioning
Normalized 0-1 scale in profile chart for relative performance comparison

## Key Metrics Explained
Metric	Definition	Interpretation
Hitting %	(Kills - Errors) / Attempts	Higher = Better offense
Opp Hitting %	Opponent's hitting percentage	Lower = Better defense
Kills/Set	Average kills per set played	Offensive firepower
Blocks/Set	Average blocks per set	Net defense strength
Aces/Set	Average service aces per set	Serving pressure
Digs/Set	Average digs per set	Floor defense consistency

## Color Scheme
The visualizations use a strategic color palette:

Cumberlands: #C8102E (Patriot Red) - Highlights focal team
Top 10: grey70 (Light Gray) - Current peer comparison
Past Champions: steelblue (Steel Blue) - Historical benchmark
Insights & Takeaways
The Championship Profile
Cumberlands demonstrates the "dual dominance" characteristic of championship teams:

## High team hitting percentage (strong offense)
Low opponent hitting percentage (strong defense)
The gap between these metrics is larger than peer comparisons, indicating a significant competitive advantage
Aggressive Serving Strategy
Exceptional aces-per-set ratio suggests intentional high-risk serving, demonstrating confidence and tactical sophistication.

## Consistency Across Categories
Rather than excelling in one area, Cumberlands shows balanced excellence across kills, blocks, aces, and digs—hallmark of complete teams.

## Future Enhancements
 Add interactive Shiny dashboard for real-time updates
 Include match-by-match trend analysis with time series plots
 Expand dataset to include more historical seasons (2015-2024)
 Add statistical significance testing (t-tests, ANOVA)
 Create predictive model for tournament seeding
 Implement automated data pipeline for mid-season updates
## Data Source
Data compiled from official NAIA statistics and institutional athletic records. All data represents official match statistics as of the 10/27/2025.

## Author
Bret Shroats

Email: bshroats5@gmail.com
GitHub: bshroats5

## Citation
If you use this analysis in your work, please cite:

@analysis{cumberlands2025,
  author = Bret Shroats,
  title = {Cumberlands Volleyball Analysis: Championship Performance Metrics},
  year = {2025},
  url = {https://github.com/bshroats5/cumberlands-vball-data}
}

## License
This project is licensed under the MIT License - see the LICENSE file for details.

## Disclaimer
This analysis is for informational and research purposes. Conclusions are based on statistical comparisons and do not constitute official institutional statements. All data represents publicly available NAIA statistics.

## Contact & Questions
For questions, suggestions, or data corrections:

Open an Issue on GitHub
Submit a Pull Request with improvements
Email: bshroats5@gmail.com

Last Updated: 2025
Data Through: 10/27/1988
