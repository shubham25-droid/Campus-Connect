package model;

import java.sql.Date;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Locale;

/**
 * Event Model representing a campus event, workshop, seminar, or competition.
 */
public class Event {
    private int id;
    private String title;
    private String shortDescription;
    private String description;
    private String category;
    private String department;
    private String eligibleYear;
    private Date eventDate;
    private String startTime;
    private String endTime;
    private String venue;
    private String organizerName;
    private String organizerContact;
    private Date registrationDeadline;
    private int maxParticipants;
    private String eligibility;
    private String image;
    private String status; // 'Draft', 'Published', 'Cancelled', 'Completed'
    private int createdBy;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // View helper properties
    private int registeredCount;
    private boolean userRegistered;
    private boolean userSaved;

    public Event() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getShortDescription() { return shortDescription; }
    public void setShortDescription(String shortDescription) { this.shortDescription = shortDescription; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getDepartment() { return department; }
    public void setDepartment(String department) { this.department = department; }

    public String getEligibleYear() { return eligibleYear; }
    public void setEligibleYear(String eligibleYear) { this.eligibleYear = eligibleYear; }

    public Date getEventDate() { return eventDate; }
    public void setEventDate(Date eventDate) { this.eventDate = eventDate; }

    public String getStartTime() { return startTime; }
    public void setStartTime(String startTime) { this.startTime = startTime; }

    public String getEndTime() { return endTime; }
    public void setEndTime(String endTime) { this.endTime = endTime; }

    public String getVenue() { return venue; }
    public void setVenue(String venue) { this.venue = venue; }

    public String getOrganizerName() { return organizerName; }
    public void setOrganizerName(String organizerName) { this.organizerName = organizerName; }

    public String getOrganizerContact() { return organizerContact; }
    public void setOrganizerContact(String organizerContact) { this.organizerContact = organizerContact; }

    public Date getRegistrationDeadline() { return registrationDeadline; }
    public void setRegistrationDeadline(Date registrationDeadline) { this.registrationDeadline = registrationDeadline; }

    public int getMaxParticipants() { return maxParticipants; }
    public void setMaxParticipants(int maxParticipants) { this.maxParticipants = maxParticipants; }

    public String getEligibility() { return eligibility; }
    public void setEligibility(String eligibility) { this.eligibility = eligibility; }

    public String getImage() { 
        if (image == null || image.trim().isEmpty()) {
            return "default_event.jpg";
        }
        return image; 
    }
    public void setImage(String image) { this.image = image; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public int getCreatedBy() { return createdBy; }
    public void setCreatedBy(int createdBy) { this.createdBy = createdBy; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    public int getRegisteredCount() { return registeredCount; }
    public void setRegisteredCount(int registeredCount) { this.registeredCount = registeredCount; }

    public boolean isUserRegistered() { return userRegistered; }
    public void setUserRegistered(boolean userRegistered) { this.userRegistered = userRegistered; }

    public boolean isUserSaved() { return userSaved; }
    public void setUserSaved(boolean userSaved) { this.userSaved = userSaved; }

    public int getRemainingSeats() {
        if (maxParticipants <= 0) return 999;
        int remaining = maxParticipants - registeredCount;
        return Math.max(remaining, 0);
    }

    public boolean isPastEvent() {
        if ("Completed".equalsIgnoreCase(status)) {
            return true;
        }
        if (eventDate == null) {
            return false;
        }
        Calendar today = Calendar.getInstance();
        today.set(Calendar.HOUR_OF_DAY, 0);
        today.set(Calendar.MINUTE, 0);
        today.set(Calendar.SECOND, 0);
        today.set(Calendar.MILLISECOND, 0);

        Calendar evt = Calendar.getInstance();
        evt.setTime(eventDate);
        evt.set(Calendar.HOUR_OF_DAY, 0);
        evt.set(Calendar.MINUTE, 0);
        evt.set(Calendar.SECOND, 0);
        evt.set(Calendar.MILLISECOND, 0);

        return evt.before(today);
    }

    public boolean isToday() {
        if (eventDate == null) return false;
        Calendar today = Calendar.getInstance();
        Calendar evt = Calendar.getInstance();
        evt.setTime(eventDate);
        return today.get(Calendar.YEAR) == evt.get(Calendar.YEAR) &&
               today.get(Calendar.DAY_OF_YEAR) == evt.get(Calendar.DAY_OF_YEAR);
    }

    public String getShortMonth() {
        if (eventDate == null) return "OCT";
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("MMM", Locale.ENGLISH);
            return sdf.format(eventDate).toUpperCase();
        } catch (Exception e) {
            return "OCT";
        }
    }

    public String getDayString() {
        if (eventDate == null) return "--";
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("dd");
            return sdf.format(eventDate);
        } catch (Exception e) {
            String s = eventDate.toString();
            return s.length() >= 10 ? s.substring(8) : "--";
        }
    }

    public boolean isRegistrationOpen() {
        if ("Cancelled".equalsIgnoreCase(status) || "Completed".equalsIgnoreCase(status)) {
            return false;
        }
        if (isPastEvent()) {
            return false;
        }
        if (registrationDeadline != null) {
            Calendar today = Calendar.getInstance();
            today.set(Calendar.HOUR_OF_DAY, 0);
            today.set(Calendar.MINUTE, 0);
            today.set(Calendar.SECOND, 0);
            today.set(Calendar.MILLISECOND, 0);

            Calendar dl = Calendar.getInstance();
            dl.setTime(registrationDeadline);
            dl.set(Calendar.HOUR_OF_DAY, 0);
            dl.set(Calendar.MINUTE, 0);
            dl.set(Calendar.SECOND, 0);
            dl.set(Calendar.MILLISECOND, 0);

            if (dl.before(today)) {
                return false;
            }
        }
        return getRemainingSeats() > 0;
    }

    public String getFormattedDate() {
        if (eventDate == null) return "TBA";
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("EEE, dd MMM yyyy");
            return sdf.format(eventDate);
        } catch (Exception e) {
            return eventDate.toString();
        }
    }

    public String getFormattedDeadline() {
        if (registrationDeadline == null) return "TBA";
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy");
            return sdf.format(registrationDeadline);
        } catch (Exception e) {
            return registrationDeadline.toString();
        }
    }

    public String getClubLogo() {
        if (organizerName == null) return "ltce_official_logo.png";
        String org = organizerName.toUpperCase();
        if (org.contains("AIMSA")) return "aimsa.png";
        if (org.contains("CESA")) return "cesa.png";
        if (org.contains("E-CELL") || org.contains("ECELL") || org.contains("ENTREPRENEUR")) return "ecell.png";
        if (org.contains("ENGLISH") || org.contains("CRYSTAL") || org.contains("SPEAKING")) return "english_club.png";
        if (org.contains("TECHNICAL VIDYA") || org.contains("TECH VIDYA") || org.contains("VIDYA")) return "technical_vidya.png";
        if (org.contains("GDG")) return "gdg.svg";
        if (org.contains("GFG") || org.contains("GEEKS")) return "gfg.svg";
        if (org.contains("IIC")) return "iic.svg";
        if (org.contains("DSS") || org.contains("DATA SCIENCE")) return "dssa.png";
        if (org.contains("CSI")) return "csi.svg";
        if (org.contains("IEEE")) return "ieee.svg";
        if (org.contains("ROTARACT")) return "rotaract.svg";
        if (org.contains("PLACEMENT") || org.contains("T&P")) return "tnp.svg";
        if (org.contains("INNOVATION") || org.contains("SIH")) return "sih.svg";
        if (org.contains("ACM")) return "acm.svg";
        return "ltce_official_logo.png";
    }
}
