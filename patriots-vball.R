# Clear the environment
rm(list = ls())

# Load the entire Tidyverse suite of packages
library(tidyverse) 

# Load the dataset
data <- read_csv("data/patriots-vball-data.csv")

# --- DATA CLEANING AND PREPARATION ---
data_clean <- data %>%
  mutate(
    hitting_pct_clean = parse_number(`Hitting %`) / 100,
    opp_hitting_pct_clean = parse_number(`Opp Hitting %`) / 100,
    category_clean = if_else(Team == "Cumberlands", "Cumberlands_2025", Category)
  ) %>%
  select(
    team = Team,
    year = Year,
    category = category_clean,
    hitting_pct = hitting_pct_clean,
    opp_hitting_pct = opp_hitting_pct_clean,
    kills_per_set = `Kills/set`,
    blocks_per_set = `Blocks/Set`,
    aces_per_set = `Aces/Set`,
    digs_per_set = `Digs/Set`
  )

glimpse(data_clean)

# --- CREATE COMPARISON GROUPS ---
top10_average <- data_clean %>%
  filter(category == "Current_Top_10") %>%
  summarise(across(where(is.numeric), ~mean(., na.rm = TRUE))) %>%
  mutate(group = "Top 10 (2025 Season)")

champion_average <- data_clean %>%
  filter(category == "Past_Champion") %>%
  summarise(across(where(is.numeric), ~mean(., na.rm = TRUE))) %>%
  mutate(group = "Past Champions (2019-2024)")

cumberlands_data <- data_clean %>%
  filter(category == "Cumberlands_2025") %>%
  mutate(group = "Cumberlands (2025 Season)")

all_groups_comparison <- bind_rows(
  top10_average,
  champion_average,
  cumberlands_data %>% select(-team, -year, -category)
)

print(all_groups_comparison)


# =========================================================================
# VISUALIZATION 1: LOLLIPOP CHART - OFFENSIVE EFFICIENCY
# =========================================================================

comparison_hitting <- all_groups_comparison %>%
  select(group, hitting_pct) %>%
  mutate(group = factor(group, levels = c("Top 10 (2025 Season)", "Past Champions (2019-2024)", "Cumberlands (2025 Season)"))) %>%
  arrange(hitting_pct)

plot1 <- ggplot(comparison_hitting, aes(x = reorder(group, hitting_pct), y = hitting_pct)) +
  geom_segment(aes(x = reorder(group, hitting_pct), xend = reorder(group, hitting_pct), 
                   y = 0, yend = hitting_pct, color = group), size = 2, show.legend = FALSE) +
  geom_point(aes(color = group), size = 8, show.legend = FALSE) +
  geom_text(aes(label = scales::percent(hitting_pct, accuracy = 0.1), color = group), 
            vjust = -1.5, size = 5, fontface = "bold", show.legend = FALSE) +
  scale_color_manual(values = c(
    "Top 10 (2025 Season)" = "grey70",
    "Past Champions (2019-2024)" = "steelblue",
    "Cumberlands (2025 Season)" = "#C8102E"
  )) +
  coord_flip() +
  theme_minimal(base_size = 14) +
  labs(
    title = "Offensive Efficiency: The Championship Hallmark",
    subtitle = "How Cumberlands compares to this season's elite and historical champions",
    x = "",
    y = "Hitting Percentage"
  ) +
  scale_y_continuous(labels = scales::percent, limits = c(0, 0.35)) +
  theme(
    plot.title = element_text(face = "bold", size = 16),
    plot.subtitle = element_text(size = 12, color = "grey40"),
    axis.text.y = element_text(size = 12)
  )

print(plot1)


# =========================================================================
# VISUALIZATION 2: HEATMAP - DEFENSIVE DOMINANCE
# =========================================================================

heatmap_data <- data_clean %>%
  filter(category %in% c("Current_Top_10", "Past_Champion", "Cumberlands_2025")) %>%
  select(team, category, opp_hitting_pct) %>%
  mutate(
    category = factor(category, levels = c("Current_Top_10", "Past_Champion", "Cumberlands_2025")),
    category_label = case_when(
      category == "Current_Top_10" ~ "Top 10 (2025)",
      category == "Past_Champion" ~ "Past Champs",
      category == "Cumberlands_2025" ~ "Cumberlands"
    )
  ) %>%
  arrange(opp_hitting_pct)

plot2 <- ggplot(heatmap_data, aes(x = category_label, y = reorder(team, opp_hitting_pct), fill = opp_hitting_pct)) +
  geom_tile(color = "white", size = 1) +
  scale_fill_gradient(low = "#2ecc71", high = "#e74c3c", labels = scales::percent) +
  geom_text(aes(label = scales::percent(opp_hitting_pct, accuracy = 0.1)), size = 3, fontface = "bold") +
  theme_minimal(base_size = 12) +
  labs(
    title = "Defensive Dominance: Individual Team Analysis",
    subtitle = "Green = Better defense (opponents hitting lower). Cumberlands stands out.",
    x = "",
    y = "",
    fill = "Opp Hitting %"
  ) +
  theme(
    plot.title = element_text(face = "bold", size = 16),
    plot.subtitle = element_text(size = 11, color = "grey40"),
    axis.text.x = element_text(angle = 45, hjust = 1, size = 11),
    legend.position = "right"
  )

print(plot2)


# =========================================================================
# VISUALIZATION 3: SCATTER PLOT - HITTING % vs OPP HITTING %
# =========================================================================

scatter_data <- data_clean %>%
  filter(category %in% c("Current_Top_10", "Past_Champion", "Cumberlands_2025")) %>%
  mutate(
    group = case_when(
      category == "Current_Top_10" ~ "Top 10 (2025 Season)",
      category == "Past_Champion" ~ "Past Champions (2019-2024)",
      category == "Cumberlands_2025" ~ "Cumberlands (2025 Season)"
    ),
    group = factor(group, levels = c("Top 10 (2025 Season)", "Past Champions (2019-2024)", "Cumberlands (2025 Season)"))
  )

plot3 <- ggplot(scatter_data, aes(x = hitting_pct, y = opp_hitting_pct, color = group, size = group)) +
  geom_point(alpha = 0.7) +
  geom_text(aes(label = team), vjust = -0.7, size = 3, show.legend = FALSE) +
  scale_color_manual(values = c(
    "Top 10 (2025 Season)" = "grey70",
    "Past Champions (2019-2024)" = "steelblue",
    "Cumberlands (2025 Season)" = "#C8102E"
  )) +
  scale_size_manual(values = c(
    "Top 10 (2025 Season)" = 3,
    "Past Champions (2019-2024)" = 3,
    "Cumberlands (2025 Season)" = 6
  )) +
  theme_minimal(base_size = 12) +
  labs(
    title = "The Efficiency Matrix: Offense vs Defense",
    subtitle = "Top right = best offense. Bottom left = best defense. Cumberlands dominates both.",
    x = "Team Hitting Percentage (Higher is Better)",
    y = "Opponent Hitting Percentage (Lower is Better)",
    color = "Group",
    size = "Group"
  ) +
  scale_x_continuous(labels = scales::percent) +
  scale_y_continuous(labels = scales::percent) +
  theme(
    plot.title = element_text(face = "bold", size = 16),
    plot.subtitle = element_text(size = 11, color = "grey40"),
    legend.position = "bottom"
  )

print(plot3)


# =========================================================================
# VISUALIZATION 4: BOX PLOT - KILLS PER SET DISTRIBUTION
# =========================================================================

boxplot_data <- data_clean %>%
  filter(category %in% c("Current_Top_10", "Past_Champion", "Cumberlands_2025")) %>%
  mutate(
    group = case_when(
      category == "Current_Top_10" ~ "Top 10 (2025 Season)",
      category == "Past_Champion" ~ "Past Champions (2019-2024)",
      category == "Cumberlands_2025" ~ "Cumberlands (2025 Season)"
    ),
    group = factor(group, levels = c("Top 10 (2025 Season)", "Past Champions (2019-2024)", "Cumberlands (2025 Season)"))
  )

plot4 <- ggplot(boxplot_data, aes(x = group, y = kills_per_set, fill = group)) +
  geom_boxplot(alpha = 0.7, show.legend = FALSE) +
  geom_jitter(width = 0.15, alpha = 0.5, size = 2, show.legend = FALSE) +
  scale_fill_manual(values = c(
    "Top 10 (2025 Season)" = "grey70",
    "Past Champions (2019-2024)" = "steelblue",
    "Cumberlands (2025 Season)" = "#C8102E"
  )) +
  theme_minimal(base_size = 12) +
  labs(
    title = "Offensive Firepower: Kills Per Set Distribution",
    subtitle = "Box shows the range of performance. Cumberlands' consistency is evident.",
    x = "",
    y = "Kills per Set"
  ) +
  theme(
    plot.title = element_text(face = "bold", size = 16),
    plot.subtitle = element_text(size = 11, color = "grey40"),
    axis.text.x = element_text(angle = 45, hjust = 1, size = 10)
  )

print(plot4)


# =========================================================================
# VISUALIZATION 5: SLOPE CHART - OFFENSE TO DEFENSE
# =========================================================================

slope_data <- all_groups_comparison %>%
  select(group, hitting_pct, opp_hitting_pct) %>%
  mutate(group = factor(group, levels = c("Top 10 (2025 Season)", "Past Champions (2019-2024)", "Cumberlands (2025 Season)"))) %>%
  pivot_longer(
    cols = -group,
    names_to = "metric",
    values_to = "value"
  ) %>%
  mutate(
    metric_label = case_when(
      metric == "hitting_pct" ~ "Team Hitting %\n(Higher is Better)",
      metric == "opp_hitting_pct" ~ "Opponent Hitting %\n(Lower is Better)"
    )
  )

plot5 <- ggplot(slope_data, aes(x = metric_label, y = value, color = group, group = group)) +
  geom_line(size = 1.5, alpha = 0.8) +
  geom_point(size = 6) +
  geom_text(aes(label = scales::percent(value, accuracy = 0.1)), vjust = -1.5, size = 4, fontface = "bold") +
  scale_color_manual(values = c(
    "Top 10 (2025 Season)" = "grey70",
    "Past Champions (2019-2024)" = "steelblue",
    "Cumberlands (2025 Season)" = "#C8102E"
  )) +
  scale_y_continuous(labels = scales::percent, limits = c(0, 0.35)) +
  theme_minimal(base_size = 12) +
  labs(
    title = "The Dual Dominance: Offensive & Defensive Excellence",
    subtitle = "Steeper slope = bigger gap between offense and defense (Cumberlands' secret weapon)",
    x = "",
    y = "Percentage",
    color = "Group"
  ) +
  theme(
    plot.title = element_text(face = "bold", size = 16),
    plot.subtitle = element_text(size = 11, color = "grey40"),
    legend.position = "bottom",
    legend.text = element_text(size = 10)
  )

print(plot5)


# =========================================================================
# VISUALIZATION 6: FACETED PROFILE CHART
# =========================================================================

radar_data <- all_groups_comparison %>%
  select(group, hitting_pct, opp_hitting_pct, kills_per_set, blocks_per_set, aces_per_set, digs_per_set) %>%
  pivot_longer(
    cols = -group,
    names_to = "stat",
    values_to = "value"
  ) %>%
  group_by(stat) %>%
  mutate(value_normalized = (value - min(value)) / (max(value) - min(value))) %>%
  ungroup() %>%
  mutate(
    group = factor(group, levels = c("Top 10 (2025 Season)", "Past Champions (2019-2024)", "Cumberlands (2025 Season)")),
    stat_label = case_when(
      stat == "hitting_pct" ~ "Hitting %",
      stat == "opp_hitting_pct" ~ "Opp Hitting %",
      stat == "kills_per_set" ~ "Kills/Set",
      stat == "blocks_per_set" ~ "Blocks/Set",
      stat == "aces_per_set" ~ "Aces/Set",
      stat == "digs_per_set" ~ "Digs/Set"
    )
  )

plot6 <- ggplot(radar_data, aes(x = stat_label, y = value_normalized, fill = group)) +
  geom_col(position = "dodge", alpha = 0.8) +
  scale_fill_manual(values = c(
    "Top 10 (2025 Season)" = "grey70",
    "Past Champions (2019-2024)" = "steelblue",
    "Cumberlands (2025 Season)" = "#C8102E"
  )) +
  coord_flip() +
  facet_wrap(~stat_label, scales = "free_x", nrow = 2) +
  theme_minimal(base_size = 11) +
  labs(
    title = "The Complete DNA Profile: Relative Strengths",
    subtitle = "Each metric normalized to 0-1 scale to show relative dominance across all categories",
    x = "",
    y = "Relative Performance (0-1 scale)",
    fill = "Group"
  ) +
  theme(
    plot.title = element_text(face = "bold", size = 16),
    plot.subtitle = element_text(size = 11, color = "grey40"),
    axis.text.x = element_blank(),
    legend.position = "bottom",
    legend.text = element_text(size = 9)
  )

print(plot6)


# =========================================================================
# VISUALIZATION 7: SERVING PRESSURE - LINE CHART
# =========================================================================

aces_data <- all_groups_comparison %>%
  select(group, aces_per_set) %>%
  mutate(
    group = factor(group, levels = c("Top 10 (2025 Season)", "Past Champions (2019-2024)", "Cumberlands (2025 Season)")),
    x_pos = as.numeric(group)
  )

plot7 <- ggplot(aces_data, aes(x = group, y = aces_per_set, color = group, group = 1)) +
  geom_line(size = 2, color = "grey50", alpha = 0.6) +
  geom_point(size = 8) +
  geom_text(aes(label = round(aces_per_set, 2)), vjust = -1.5, size = 5, fontface = "bold", show.legend = FALSE) +
  scale_color_manual(values = c(
    "Top 10 (2025 Season)" = "grey70",
    "Past Champions (2019-2024)" = "steelblue",
    "Cumberlands (2025 Season)" = "#C8102E"
  )) +
  scale_y_continuous(limits = c(1, 3.2)) +
  theme_minimal(base_size = 14) +
  labs(
    title = "Aggressive Serving: The Cumberlands Difference",
    subtitle = "Aces per set shows Cumberlands' exceptional serving pressure compared to peers and history",
    x = "",
    y = "Aces per Set",
    color = "Group"
  ) +
  theme(
    plot.title = element_text(face = "bold", size = 16),
    plot.subtitle = element_text(size = 11, color = "grey40"),
    legend.position = "none",
    axis.text.x = element_text(angle = 45, hjust = 1, size = 10)
  )

print(plot7)


# =========================================================================
# VISUALIZATION 8: DIVERGING BAR CHART - COMPARISON TO AVERAGE
# =========================================================================

all_data_for_diverging <- data_clean %>%
  filter(category %in% c("Current_Top_10", "Past_Champion", "Cumberlands_2025")) %>%
  group_by(category) %>%
  summarise(avg_hitting = mean(hitting_pct, na.rm = TRUE), .groups = "drop")

overall_avg <- mean(all_data_for_diverging$avg_hitting)

diverging_data <- all_data_for_diverging %>%
  mutate(
    group = case_when(
      category == "Current_Top_10" ~ "Top 10 (2025)",
      category == "Past_Champion" ~ "Past Champions",
      category == "Cumberlands_2025" ~ "Cumberlands (2025)"
    ),
    difference = avg_hitting - overall_avg,
    group = factor(group, levels = c("Cumberlands (2025)", "Past Champions", "Top 10 (2025)"))
  ) %>%
  arrange(difference)

plot8 <- ggplot(diverging_data, aes(x = reorder(group, difference), y = difference, fill = difference > 0)) +
  geom_col(show.legend = FALSE) +
  geom_text(aes(label = scales::percent(difference, accuracy = 0.1)), 
            hjust = ifelse(diverging_data$difference > 0, -0.3, 1.3), 
            vjust = 0.5, size = 5, fontface = "bold") +
  scale_fill_manual(values = c("FALSE" = "#e74c3c", "TRUE" = "#2ecc71")) +
  coord_flip() +
  geom_vline(xintercept = 0, color = "grey30", linetype = "dashed", size = 1) +
  theme_minimal(base_size = 14) +
  labs(
    title = "Hitting Efficiency: Deviation from Average",
    subtitle = "How far is each group from the overall average hitting percentage?",
    x = "",
    y = "Difference from Average"
  ) +
  scale_y_continuous(labels = scales::percent) +
  theme(
    plot.title = element_text(face = "bold", size = 16),
    plot.subtitle = element_text(size = 11, color = "grey40")
  )

print(plot8)


# =========================================================================
# SAVE ALL YOUR PLOTS TO THE 'fig' FOLDER
# =========================================================================

# Create the fig folder if it doesn't exist
if (!dir.exists("fig")) {
  dir.create("fig")
}

ggsave("fig/01_lollipop_offensive_efficiency.png", plot1, width = 10, height = 6, dpi = 300)
ggsave("fig/02_heatmap_defensive_dominance.png", plot2, width = 12, height = 8, dpi = 300)
ggsave("fig/03_scatter_efficiency_matrix.png", plot3, width = 10, height = 7, dpi = 300)
ggsave("fig/04_boxplot_kills_distribution.png", plot4, width = 10, height = 7, dpi = 300)
ggsave("fig/05_slope_offense_defense.png", plot5, width = 10, height = 7, dpi = 300)
ggsave("fig/06_faceted_dna_profile.png", plot6, width = 12, height = 8, dpi = 300)
ggsave("fig/07_line_serving_pressure.png", plot7, width = 10, height = 7, dpi = 300)
ggsave("fig/08_diverging_hitting_efficiency.png", plot8, width = 10, height = 7, dpi = 300)

cat("\n✓ All plots saved successfully to the 'fig' folder!\n")