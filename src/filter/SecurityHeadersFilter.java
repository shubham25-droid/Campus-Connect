package filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * SecurityHeadersFilter attaches production-grade HTTP response headers
 * to protect against clickjacking, MIME sniffing, and information disclosure.
 */
@WebFilter(filterName = "SecurityHeadersFilter", urlPatterns = {"/*"})
public class SecurityHeadersFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        if (request instanceof javax.servlet.http.HttpServletRequest && response instanceof HttpServletResponse) {
            javax.servlet.http.HttpServletRequest req = (javax.servlet.http.HttpServletRequest) request;
            HttpServletResponse res = (HttpServletResponse) response;

            // CSRF Defense: Block cross-origin state-changing requests
            String method = req.getMethod();
            if ("POST".equalsIgnoreCase(method) || "PUT".equalsIgnoreCase(method) || "DELETE".equalsIgnoreCase(method)) {
                if (!util.SecurityUtil.isSameOrigin(req)) {
                    res.sendError(HttpServletResponse.SC_FORBIDDEN, "Cross-Origin Request Blocked by CSRF Protection");
                    return;
                }
            }

            // Prevent MIME-type sniffing
            res.setHeader("X-Content-Type-Options", "nosniff");

            // Prevent Clickjacking (iframe embedding)
            res.setHeader("X-Frame-Options", "SAMEORIGIN");

            // Enable browser cross-site scripting filter
            res.setHeader("X-XSS-Protection", "1; mode=block");

            // Control referrer disclosure
            res.setHeader("Referrer-Policy", "strict-origin-when-cross-origin");

            // Restrict access to sensitive device APIs
            res.setHeader("Permissions-Policy", "camera=(), microphone=(), geolocation=()");

            // Shared computer / Lab browser defense: Prevent disk caching of authenticated & sensitive routes
            String uri = req.getRequestURI();
            if (uri != null && (uri.contains("/admin") || uri.contains("/login") || uri.contains("/register") || uri.contains("/my-registrations"))) {
                res.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
                res.setHeader("Pragma", "no-cache");
                res.setDateHeader("Expires", 0);
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {}
}
