package util;

import javax.servlet.http.HttpServletRequest;
import java.net.URI;
import java.util.regex.Pattern;

/**
 * SecurityUtil provides centralized defensive security helpers:
 * - HTML escaping to prevent Cross-Site Scripting (XSS)
 * - Input sanitization for database persistence
 * - Safe URL redirect validation (prevent Open Redirect attacks)
 * - Safe Client IP extraction
 * - Origin / Referer validation for Cross-Site Request Forgery (CSRF) defense
 */
public class SecurityUtil {

    private static final Pattern HTML_TAG_PATTERN = Pattern.compile("<[^>]*>", Pattern.CASE_INSENSITIVE);
    private static final Pattern SCRIPT_PATTERN = Pattern.compile("(?i)(javascript|vbscript|data):");
    private static final Pattern EVENT_HANDLER_PATTERN = Pattern.compile("(?i)on[a-z]+\\s*=");
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");

    /**
     * Escapes special HTML characters to prevent XSS when echoing strings inside HTML markup or attributes.
     */
    public static String escapeHtml(String input) {
        if (input == null) return "";
        StringBuilder out = new StringBuilder(input.length() + 16);
        for (int i = 0; i < input.length(); i++) {
            char c = input.charAt(i);
            switch (c) {
                case '&':
                    out.append("&amp;");
                    break;
                case '<':
                    out.append("&lt;");
                    break;
                case '>':
                    out.append("&gt;");
                    break;
                case '"':
                    out.append("&quot;");
                    break;
                case '\'':
                    out.append("&#x27;");
                    break;
                default:
                    out.append(c);
            }
        }
        return out.toString();
    }

    /**
     * Strips dangerous tags, script schemes, and event handlers from text inputs.
     */
    public static String sanitize(String input) {
        if (input == null) return "";
        String cleaned = HTML_TAG_PATTERN.matcher(input).replaceAll("");
        cleaned = SCRIPT_PATTERN.matcher(cleaned).replaceAll("");
        cleaned = EVENT_HANDLER_PATTERN.matcher(cleaned).replaceAll("");
        return cleaned.trim();
    }

    /**
     * Validates that an email matches standard email pattern.
     */
    public static boolean isValidEmail(String email) {
        if (email == null) return false;
        String trimmed = email.trim();
        return trimmed.length() <= 120 && EMAIL_PATTERN.matcher(trimmed).matches();
    }

    /**
     * Validates that a redirect URL is strictly an internal application path.
     * Prevents Open-Redirect phishing attacks (e.g. /\evil.com, //evil.com, https://...).
     */
    public static boolean isSafeRedirect(String redirectUrl, String contextPath) {
        if (redirectUrl == null || redirectUrl.trim().isEmpty()) {
            return false;
        }
        String url = redirectUrl.trim();

        // Reject newlines or control chars (HTTP response splitting)
        if (url.indexOf('\r') != -1 || url.indexOf('\n') != -1) {
            return false;
        }

        // Must not contain backslashes or scheme colons (e.g. javascript:, http:)
        if (url.indexOf('\\') != -1 || url.indexOf(':') != -1) {
            return false;
        }

        // Must not be protocol-relative (//evil.com)
        if (url.startsWith("//")) {
            return false;
        }

        // If contextPath is present, check if it starts with contextPath or relative '/'
        if (contextPath != null && !contextPath.isEmpty()) {
            if (url.startsWith(contextPath + "/")) {
                return true;
            }
        }

        // Relative path starting with single forward slash
        if (url.startsWith("/") && !url.startsWith("//")) {
            return true;
        }

        return false;
    }

    /**
     * Safely determines the client's IP address.
     */
    public static String getClientIp(HttpServletRequest req) {
        String remoteAddr = req.getRemoteAddr();
        // Only inspect X-Forwarded-For if request comes from local loopback or private network proxy
        if (remoteAddr != null && (remoteAddr.equals("127.0.0.1") || remoteAddr.equals("0:0:0:0:0:0:0:1") || remoteAddr.startsWith("10.") || remoteAddr.startsWith("192.168."))) {
            String xff = req.getHeader("X-Forwarded-For");
            if (xff != null && !xff.trim().isEmpty()) {
                String firstIp = xff.split(",")[0].trim();
                if (firstIp.length() <= 45 && (firstIp.indexOf('.') != -1 || firstIp.indexOf(':') != -1)) {
                    return firstIp;
                }
            }
        }
        return remoteAddr != null ? remoteAddr : "unknown";
    }

    /**
     * Verifies Origin / Referer against server host to defend against Cross-Site Request Forgery (CSRF).
     */
    public static boolean isSameOrigin(HttpServletRequest req) {
        String origin = req.getHeader("Origin");
        if (origin != null && !origin.trim().isEmpty()) {
            try {
                URI originUri = URI.create(origin.trim());
                String originHost = originUri.getHost();
                String serverHost = req.getServerName();
                return originHost != null && originHost.equalsIgnoreCase(serverHost);
            } catch (Exception e) {
                return false;
            }
        }

        String referer = req.getHeader("Referer");
        if (referer != null && !referer.trim().isEmpty()) {
            try {
                URI refererUri = URI.create(referer.trim());
                String refererHost = refererUri.getHost();
                String serverHost = req.getServerName();
                return refererHost != null && refererHost.equalsIgnoreCase(serverHost);
            } catch (Exception e) {
                return false;
            }
        }

        // If no Origin or Referer header is sent (e.g. standard same-site browser navigation), allow
        return true;
    }
}
