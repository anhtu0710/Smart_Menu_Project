package com.smartmenu.controller;

import com.smartmenu.dto.AccessCheckResponseDto;
import com.smartmenu.dto.ApiResponse;
import com.smartmenu.service.PaymentService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@Slf4j
@CrossOrigin(originPatterns = "*", allowCredentials = "true")
public class ServiceAccessController {

    private final PaymentService paymentService;

    /**
     * API kiểm tra quyền sử dụng dịch vụ thiết kế menu
     * Hỗ trợ cả 2 đường dẫn:
     * - GET /api/service/check-access
     * - GET /api/v1/service/check-access
     */
    @GetMapping({"/api/service/check-access", "/api/v1/service/check-access"})
    public ResponseEntity<ApiResponse<AccessCheckResponseDto>> checkAccess(
            @RequestParam(value = "userId", required = false) Long queryUserId,
            HttpServletRequest request
    ) {
        Long userId = queryUserId;
        if (userId == null) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                userId = (Long) session.getAttribute("AUTH_USER_ID");
            }
        }
        if (userId == null) {
            userId = 1L; // Fallback mặc định tài khoản chính
        }

        AccessCheckResponseDto result = paymentService.checkAccess(userId);
        return ResponseEntity.ok(ApiResponse.success(result, result.getMessage()));
    }
}
