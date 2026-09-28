package com.smartmenu.controller;

import com.smartmenu.dto.ApiResponse;
import com.smartmenu.dto.FullAnalysisResponseData;

import com.smartmenu.service.MenuGenerationService;

import lombok.RequiredArgsConstructor;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/smartcoffee")
@RequiredArgsConstructor
@CrossOrigin(originPatterns = "*", allowCredentials = "true")
public class AnalysisController {

    private final MenuGenerationService menuGenerationService;

    /**
     *
     * Bắt đầu phân tích
     *
     * FE truyền sessionId
     *
     */
    @PostMapping("/analyze-full/{sessionId}")
    public ResponseEntity<ApiResponse<FullAnalysisResponseData>> analyzeFull(

            @PathVariable Long sessionId

    ) {

        FullAnalysisResponseData result =

                menuGenerationService

                        .analyzeFullWorkflow(

                                sessionId

                        );

        return ResponseEntity.ok(

                ApiResponse.success(

                        result,

                        "Phân tích SmartMenu hoàn tất"

                )

        );

    }

    /**
     *
     * Lấy lại kết quả phân tích
     *
     */
    @GetMapping("/analysis/{sessionId}")
    public ResponseEntity<ApiResponse<FullAnalysisResponseData>> getAnalysis(

            @PathVariable Long sessionId

    ) {

        FullAnalysisResponseData result =

                menuGenerationService

                        .getAnalysisBySessionId(

                                String.valueOf(
                                        sessionId)

                        );

        return ResponseEntity.ok(

                ApiResponse.success(

                        result,

                        "Lấy dữ liệu thành công"

                )

        );

    }

}