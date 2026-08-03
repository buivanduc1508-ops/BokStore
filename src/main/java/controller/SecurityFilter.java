package controller;
import java.io.IOException; import java.util.UUID; import jakarta.servlet.*; import jakarta.servlet.annotation.WebFilter; import jakarta.servlet.http.*; import model.User;
@WebFilter("/*")
public class SecurityFilter implements Filter {
    public void doFilter(ServletRequest request,ServletResponse response,FilterChain chain)throws IOException,ServletException{
        HttpServletRequest r=(HttpServletRequest)request;HttpServletResponse p=(HttpServletResponse)response;HttpSession s=r.getSession();
        p.setHeader("X-Content-Type-Options","nosniff");p.setHeader("X-Frame-Options","SAMEORIGIN");p.setHeader("Referrer-Policy","strict-origin-when-cross-origin");p.setHeader("Cache-Control","no-store");
        String token=(String)s.getAttribute("csrfToken");if(token==null){token=UUID.randomUUID().toString();s.setAttribute("csrfToken",token);}
        String path=r.getServletPath();User u=(User)s.getAttribute("user");
        if(path.startsWith("/admin/")&&(u==null||!"ADMIN".equals(u.getRole()))){p.sendError(403);return;}
        if("POST".equalsIgnoreCase(r.getMethod())&&!token.equals(r.getParameter("csrfToken"))){p.sendError(403,"Phiên biểu mẫu không hợp lệ. Vui lòng tải lại trang.");return;}
        chain.doFilter(request,response);
    }
}
