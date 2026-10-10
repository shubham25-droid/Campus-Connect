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

        if (response instanceof HttpServletResponse) {
            HttpServletResponse res = (HttpServletResponse) response;

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
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {}
}
