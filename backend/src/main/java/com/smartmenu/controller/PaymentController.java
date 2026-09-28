package com.smartmenu.controller;

import com.smartmenu.dto.ApiResponse;
import com.smartmenu.dto.PaymentCreateResponseDto;
import com.smartmenu.service.PaymentService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequiredArgsConstructor
@Slf4j
@CrossOrigin(originPatterns = "*", allowCredentials = "true")
public class PaymentController {

    private final PaymentService paymentService;

    /**
     * API tạo thanh toán
     */
    @PostMapping({"/api/payment/create", "/api/v1/payment/create"})
    public ResponseEntity<ApiResponse<PaymentCreateResponseDto>> createPayment(
            @RequestParam(value = "userId", required = false) Long queryUserId,
            @RequestBody(required = false) Map<String, Object> body,
            HttpServletRequest request
    ) {
        Long userId = queryUserId;
        if (userId == null && body != null && body.containsKey("userId")) {
            try {
                userId = Long.valueOf(body.get("userId").toString());
            } catch (Exception ignored) {}
        }

        if (userId == null) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                userId = (Long) session.getAttribute("AUTH_USER_ID");
            }
        }

        if (userId == null) {
            userId = 1L; // Fallback mặc định
        }

        PaymentCreateResponseDto response = paymentService.createPayment(userId);
        return ResponseEntity.ok(ApiResponse.success(response, "Khởi tạo giao dịch thành công"));
    }

    /**
     * Webhook Callback thanh toán từ Ngân hàng / Cổng thanh toán (SePay / Casso / Ngân hàng thật)
     */
    @PostMapping({"/api/payment/callback", "/api/v1/payment/callback"})
    public ResponseEntity<ApiResponse<String>> paymentCallback(
            @RequestBody(required = false) Map<String, Object> payload
    ) {
        log.info("[PAYMENT-WEBHOOK-RECEIVED] Webhook ngân hàng bắn về: {}", payload);
        boolean ok = paymentService.handleWebhookCallback(payload);
        if (ok) {
            return ResponseEntity.ok(ApiResponse.success("SUCCESS", "Xác nhận thanh toán tiền thật thành công"));
        } else {
            return ResponseEntity.badRequest().body(ApiResponse.error("Không tìm thấy giao dịch hoặc nội dung không hợp lệ"));
        }
    }

    /**
     * API Polling kiểm tra trạng thái thanh toán theo paymentId
     */
    @GetMapping({"/api/payment/check-status/{paymentId}", "/api/v1/payment/check-status/{paymentId}"})
    public ResponseEntity<ApiResponse<Map<String, Object>>> checkStatus(
            @PathVariable Long paymentId
    ) {
        Map<String, Object> status = paymentService.checkStatus(paymentId);
        return ResponseEntity.ok(ApiResponse.success(status, "Lấy trạng thái thành công"));
    }

    /**
     * API xác nhận thanh toán demo/test nhanh trực tiếp trên giao diện
     */
    @PostMapping({"/api/payment/mock-confirm/{paymentId}", "/api/v1/payment/mock-confirm/{paymentId}"})
    public ResponseEntity<ApiResponse<String>> mockConfirm(
            @PathVariable Long paymentId
    ) {
        boolean ok = paymentService.mockConfirmPayment(paymentId);
        if (ok) {
            return ResponseEntity.ok(ApiResponse.success("SUCCESS", "Xác nhận thanh toán thành công"));
        } else {
            return ResponseEntity.badRequest().body(ApiResponse.error("Không tìm thấy giao dịch"));
        }
    }
}
