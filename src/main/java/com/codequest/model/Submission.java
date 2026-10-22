package com.codequest.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class Submission implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int userId;
    private int missionId;
    private String selectedOption;
    private boolean isCorrect;
    private Timestamp submittedAt;

    public Submission() {}

    public Submission(int id, int userId, int missionId, String selectedOption, boolean isCorrect, Timestamp submittedAt) {
        this.id = id;
        this.userId = userId;
        this.missionId = missionId;
        this.selectedOption = selectedOption;
        this.isCorrect = isCorrect;
        this.submittedAt = submittedAt;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getMissionId() { return missionId; }
    public void setMissionId(int missionId) { this.missionId = missionId; }

    public String getSelectedOption() { return selectedOption; }
    public void setSelectedOption(String selectedOption) { this.selectedOption = selectedOption; }

    public boolean isCorrect() { return isCorrect; }
    public void setCorrect(boolean correct) { isCorrect = correct; }

    public Timestamp getSubmittedAt() { return submittedAt; }
    public void setSubmittedAt(Timestamp submittedAt) { this.submittedAt = submittedAt; }
}
