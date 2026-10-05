package model;

import java.sql.Date;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;

/**
 * Registration Model representing a student's registration for an event.
 */
public class Registration {
    private int id;
    private int userId;
    private int eventId;
    private Timestamp registeredAt;
    private String status; // 'CONFIRMED', 'CANCELLED', 'ATTENDED'

    // Joined metadata for UI display
    private String userName;
    private String userEmail;
    private String userDepartment;
    private String userYear;

    private String eventTitle;
    private Date eventDate;
    private String eventStartTime;
    private String eventVenue;
    private String eventCategory;
    private String eventOrganizer;
    private String eventImage;

    public Registration() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getEventId() { return eventId; }
    public void setEventId(int eventId) { this.eventId = eventId; }

    public Timestamp getRegisteredAt() { return registeredAt; }
    public void setRegisteredAt(Timestamp registeredAt) { this.registeredAt = registeredAt; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }

    public String getUserEmail() { return userEmail; }
    public void setUserEmail(String userEmail) { this.userEmail = userEmail; }

    public String getUserDepartment() { return userDepartment; }
    public void setUserDepartment(String userDepartment) { this.userDepartment = userDepartment; }

    public String getUserYear() { return userYear; }
    public void setUserYear(String userYear) { this.userYear = userYear; }

    public String getEventTitle() { return eventTitle; }
    public void setEventTitle(String eventTitle) { this.eventTitle = eventTitle; }

    public Date getEventDate() { return eventDate; }
    public void setEventDate(Date eventDate) { this.eventDate = eventDate; }

    public String getEventStartTime() { return eventStartTime; }
    public void setEventStartTime(String eventStartTime) { this.eventStartTime = eventStartTime; }

    public String getEventVenue() { return eventVenue; }
    public void setEventVenue(String eventVenue) { this.eventVenue = eventVenue; }

    public String getEventCategory() { return eventCategory; }
    public void setEventCategory(String eventCategory) { this.eventCategory = eventCategory; }

    public String getEventOrganizer() { return eventOrganizer; }
    public void setEventOrganizer(String eventOrganizer) { this.eventOrganizer = eventOrganizer; }

    public String getEventImage() { return eventImage; }
    public void setEventImage(String eventImage) { this.eventImage = eventImage; }

    public String getFormattedRegisteredAt() {
        if (registeredAt == null) return "Recently";
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy, hh:mm a");
            return sdf.format(registeredAt);
        } catch (Exception e) {
            return registeredAt.toString();
        }
    }

    public String getFormattedEventDate() {
        if (eventDate == null) return "TBA";
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("EEE, dd MMM yyyy");
            return sdf.format(eventDate);
        } catch (Exception e) {
            return eventDate.toString();
        }
    }
}
