package com.codequest.model;

import java.io.Serializable;

public class LeaderboardEntry implements Serializable {
    private static final long serialVersionUID = 1L;

    private int rank;
    private int userId;
    private String username;
    private int level;
    private int completedMissions;
    private int totalXp;

    public LeaderboardEntry() {}

    public LeaderboardEntry(int rank, int userId, String username, int level, int completedMissions, int totalXp) {
        this.rank = rank;
        this.userId = userId;
        this.username = username;
        this.level = level;
        this.completedMissions = completedMissions;
        this.totalXp = totalXp;
    }

    public int getRank() { return rank; }
    public void setRank(int rank) { this.rank = rank; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public int getLevel() { return level; }
    public void setLevel(int level) { this.level = level; }

    public int getCompletedMissions() { return completedMissions; }
    public void setCompletedMissions(int completedMissions) { this.completedMissions = completedMissions; }

    public int getTotalXp() { return totalXp; }
    public void setTotalXp(int totalXp) { this.totalXp = totalXp; }
}
